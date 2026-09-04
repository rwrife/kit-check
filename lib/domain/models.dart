import 'dart:math' as math;

class KitId {
  KitId(String value) : value = _normalized(value);

  final String value;

  static String _normalized(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      throw ArgumentError.value(value, 'value', 'KitId cannot be empty');
    }
    return trimmed;
  }

  @override
  bool operator ==(Object other) => other is KitId && other.value == value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;
}

class CategoryId {
  CategoryId(String value) : value = _normalized(value);

  final String value;

  static String _normalized(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      throw ArgumentError.value(value, 'value', 'CategoryId cannot be empty');
    }
    return trimmed;
  }

  @override
  bool operator ==(Object other) => other is CategoryId && other.value == value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;
}

class ItemId {
  ItemId(String value) : value = _normalized(value);

  final String value;

  static String _normalized(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      throw ArgumentError.value(value, 'value', 'ItemId cannot be empty');
    }
    return trimmed;
  }

  @override
  bool operator ==(Object other) => other is ItemId && other.value == value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;
}

class TripId {
  TripId(String value) : value = _normalized(value);

  final String value;

  static String _normalized(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      throw ArgumentError.value(value, 'value', 'TripId cannot be empty');
    }
    return trimmed;
  }

  @override
  bool operator ==(Object other) => other is TripId && other.value == value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;
}

class KitCategory {
  KitCategory({required this.id, required String name, required this.sortOrder})
    : name = _normalizedName(name);

  final CategoryId id;
  final String name;
  final int sortOrder;

  static String _normalizedName(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      throw ArgumentError.value(value, 'name', 'Category name cannot be empty');
    }
    return trimmed;
  }
}

class KitItemTemplate {
  KitItemTemplate({
    required this.id,
    required String name,
    this.quantity,
    this.note,
    this.categoryId,
    required this.sortOrder,
  }) : name = _normalizedName(name);

  final ItemId id;
  final String name;
  final int? quantity;
  final String? note;
  final CategoryId? categoryId;
  final int sortOrder;

  static String _normalizedName(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      throw ArgumentError.value(value, 'name', 'Item name cannot be empty');
    }
    return trimmed;
  }
}

class KitTemplate {
  KitTemplate({
    required this.id,
    required String name,
    List<KitCategory> categories = const <KitCategory>[],
    List<KitItemTemplate> items = const <KitItemTemplate>[],
    this.isArchived = false,
  }) : name = _normalizedName(name),
       categories = List<KitCategory>.unmodifiable(categories),
       items = List<KitItemTemplate>.unmodifiable(items);

  final KitId id;
  final String name;
  final List<KitCategory> categories;
  final List<KitItemTemplate> items;
  final bool isArchived;

  static String _normalizedName(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      throw ArgumentError.value(value, 'name', 'Kit name cannot be empty');
    }
    return trimmed;
  }
}

enum ChecklistStatus { pending, packed, omitted, returned }

class ChecklistItemSnapshot {
  ChecklistItemSnapshot({
    required this.itemId,
    required String itemName,
    this.quantity,
    this.note,
    this.categoryName,
    this.status = ChecklistStatus.pending,
    this.omissionNote,
  }) : itemName = _normalizedName(itemName);

  final ItemId itemId;
  final String itemName;
  final int? quantity;
  final String? note;
  final String? categoryName;
  final ChecklistStatus status;
  final String? omissionNote;

  bool get isUnresolved => status != ChecklistStatus.returned;

  static String _normalizedName(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      throw ArgumentError.value(value, 'itemName', 'Item name cannot be empty');
    }
    return trimmed;
  }

  ChecklistItemSnapshot copyWith({
    ChecklistStatus? status,
    String? omissionNote,
  }) {
    return ChecklistItemSnapshot(
      itemId: itemId,
      itemName: itemName,
      quantity: quantity,
      note: note,
      categoryName: categoryName,
      status: status ?? this.status,
      omissionNote: omissionNote,
    );
  }

  ChecklistItemSnapshot markPacked() {
    switch (status) {
      case ChecklistStatus.pending:
      case ChecklistStatus.omitted:
        return copyWith(status: ChecklistStatus.packed, omissionNote: null);
      case ChecklistStatus.packed:
        return this;
      case ChecklistStatus.returned:
        throw StateError('Cannot mark a returned item as packed');
    }
  }

  ChecklistItemSnapshot omit(String reason) {
    final normalized = reason.trim();
    if (normalized.isEmpty) {
      throw ArgumentError.value(reason, 'reason', 'Omission note is required');
    }
    if (status == ChecklistStatus.returned) {
      throw StateError('Cannot omit an item that was already returned');
    }
    return copyWith(status: ChecklistStatus.omitted, omissionNote: normalized);
  }

  ChecklistItemSnapshot markReturned() {
    if (status != ChecklistStatus.packed) {
      throw StateError('Only packed items can be marked returned');
    }
    return copyWith(status: ChecklistStatus.returned, omissionNote: null);
  }

  ChecklistItemSnapshot resetToPending() {
    if (status == ChecklistStatus.returned) {
      throw StateError('Returned items cannot return to pending');
    }
    return copyWith(status: ChecklistStatus.pending, omissionNote: null);
  }
}

class TripChecklistSnapshot {
  TripChecklistSnapshot({
    required this.id,
    required this.kitId,
    required this.kitName,
    required this.tripName,
    this.tripNote,
    required this.startedOn,
    required List<ChecklistItemSnapshot> items,
  }) : items = List<ChecklistItemSnapshot>.unmodifiable(items);

  factory TripChecklistSnapshot.fromKitTemplate({
    required TripId id,
    required KitTemplate kit,
    required String tripName,
    String? tripNote,
    required DateTime startedOn,
  }) {
    final categoriesById = <CategoryId, KitCategory>{
      for (final category in kit.categories) category.id: category,
    };
    final uncategorizedOrder = kit.categories.isEmpty
        ? 0
        : kit.categories
                  .map((category) => category.sortOrder)
                  .reduce(math.max) +
              1;

    final ordered = List<KitItemTemplate>.from(kit.items)
      ..sort((left, right) {
        final leftCategoryOrder = _categoryOrder(
          left.categoryId,
          categoriesById,
          fallback: uncategorizedOrder,
        );
        final rightCategoryOrder = _categoryOrder(
          right.categoryId,
          categoriesById,
          fallback: uncategorizedOrder,
        );

        final byCategory = leftCategoryOrder.compareTo(rightCategoryOrder);
        if (byCategory != 0) {
          return byCategory;
        }

        final byOrder = left.sortOrder.compareTo(right.sortOrder);
        if (byOrder != 0) {
          return byOrder;
        }

        return left.name.toLowerCase().compareTo(right.name.toLowerCase());
      });

    final snapshotItems = ordered
        .map(
          (item) => ChecklistItemSnapshot(
            itemId: item.id,
            itemName: item.name,
            quantity: item.quantity,
            note: item.note,
            categoryName: item.categoryId == null
                ? null
                : categoriesById[item.categoryId!]?.name,
          ),
        )
        .toList(growable: false);

    return TripChecklistSnapshot(
      id: id,
      kitId: kit.id,
      kitName: kit.name,
      tripName: _normalizedTripName(tripName),
      tripNote: tripNote?.trim().isEmpty ?? true ? null : tripNote!.trim(),
      startedOn: startedOn,
      items: snapshotItems,
    );
  }

  final TripId id;
  final KitId kitId;
  final String kitName;
  final String tripName;
  final String? tripNote;
  final DateTime startedOn;
  final List<ChecklistItemSnapshot> items;

  List<ChecklistItemSnapshot> get unresolvedItems =>
      items.where((item) => item.isUnresolved).toList(growable: false);

  static int _categoryOrder(
    CategoryId? id,
    Map<CategoryId, KitCategory> categoriesById, {
    required int fallback,
  }) {
    if (id == null) {
      return fallback;
    }
    return categoriesById[id]?.sortOrder ?? fallback;
  }

  static String _normalizedTripName(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      throw ArgumentError.value(value, 'tripName', 'Trip name cannot be empty');
    }
    return trimmed;
  }

  TripChecklistSnapshot updateItem(
    ItemId itemId,
    ChecklistItemSnapshot Function(ChecklistItemSnapshot current) update,
  ) {
    final index = items.indexWhere((item) => item.itemId == itemId);
    if (index == -1) {
      throw ArgumentError.value(
        itemId,
        'itemId',
        'Item does not exist in trip',
      );
    }

    final updated = List<ChecklistItemSnapshot>.from(items);
    updated[index] = update(updated[index]);

    return TripChecklistSnapshot(
      id: id,
      kitId: kitId,
      kitName: kitName,
      tripName: tripName,
      tripNote: tripNote,
      startedOn: startedOn,
      items: updated,
    );
  }
}
