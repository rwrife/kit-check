import 'package:kit_check/domain/models.dart';

abstract interface class KitCheckRepository {
  Future<List<KitTemplate>> loadKits({bool includeArchived = true});

  Future<KitTemplate> createKit(String name);

  Future<void> saveKit(KitTemplate kit);

  Future<void> renameKit(KitId id, String name);

  Future<void> setKitArchived(KitId id, {required bool isArchived});

  Future<KitTemplate> duplicateKit(KitId id, {String? name});

  Future<void> deleteKit(KitId id);

  Future<TripChecklistSnapshot> createTrip({
    required KitId kitId,
    required String tripName,
    String? tripNote,
    DateTime? startedOn,
  });

  Future<void> saveTrip(TripChecklistSnapshot trip);

  Future<TripChecklistSnapshot?> loadTrip(TripId id);

  Future<List<TripChecklistSnapshot>> loadTrips();
}

class InMemoryKitCheckRepository implements KitCheckRepository {
  InMemoryKitCheckRepository({String Function(String prefix)? idFactory})
    : _idFactory = idFactory ?? _defaultIdFactory;

  final Map<KitId, KitTemplate> _kitsById = <KitId, KitTemplate>{};
  final Map<TripId, TripChecklistSnapshot> _tripsById =
      <TripId, TripChecklistSnapshot>{};
  final String Function(String prefix) _idFactory;

  static int _idCounter = 0;

  static String _defaultIdFactory(String prefix) {
    _idCounter += 1;
    return '$prefix-${DateTime.now().microsecondsSinceEpoch}-$_idCounter';
  }

  @override
  Future<KitTemplate> createKit(String name) async {
    final kit = KitTemplate(id: KitId(_idFactory('kit')), name: name);
    await saveKit(kit);
    return kit;
  }

  @override
  Future<TripChecklistSnapshot> createTrip({
    required KitId kitId,
    required String tripName,
    String? tripNote,
    DateTime? startedOn,
  }) async {
    final kit = _kitsById[kitId];
    if (kit == null) {
      throw StateError('Kit not found: ${kitId.value}');
    }

    final trip = TripChecklistSnapshot.fromKitTemplate(
      id: TripId(_idFactory('trip')),
      kit: kit,
      tripName: tripName,
      tripNote: tripNote,
      startedOn: startedOn ?? DateTime.now(),
    );
    await saveTrip(trip);
    return trip;
  }

  @override
  Future<void> deleteKit(KitId id) async {
    _kitsById.remove(id);
  }

  @override
  Future<KitTemplate> duplicateKit(KitId id, {String? name}) async {
    final source = _kitsById[id];
    if (source == null) {
      throw StateError('Kit not found: ${id.value}');
    }

    final newKitId = KitId(_idFactory('kit'));
    final categoryMap = <CategoryId, CategoryId>{};

    final newCategories = <KitCategory>[];
    for (final category in source.categories) {
      final newCategoryId = CategoryId(_idFactory('cat'));
      categoryMap[category.id] = newCategoryId;
      newCategories.add(
        KitCategory(
          id: newCategoryId,
          name: category.name,
          sortOrder: category.sortOrder,
        ),
      );
    }

    final newItems = source.items
        .map(
          (item) => KitItemTemplate(
            id: ItemId(_idFactory('item')),
            name: item.name,
            quantity: item.quantity,
            note: item.note,
            categoryId: item.categoryId == null
                ? null
                : categoryMap[item.categoryId!],
            sortOrder: item.sortOrder,
          ),
        )
        .toList(growable: false);

    final duplicated = KitTemplate(
      id: newKitId,
      name: name ?? '${source.name} Copy',
      categories: newCategories,
      items: newItems,
      isArchived: false,
    );

    await saveKit(duplicated);
    return duplicated;
  }

  @override
  Future<List<KitTemplate>> loadKits({bool includeArchived = true}) async {
    final kits =
        _kitsById.values
            .where((kit) => includeArchived || !kit.isArchived)
            .toList(growable: false)
          ..sort(_kitComparator);
    return kits;
  }

  @override
  Future<TripChecklistSnapshot?> loadTrip(TripId id) async {
    return _tripsById[id];
  }

  @override
  Future<List<TripChecklistSnapshot>> loadTrips() async {
    final trips = _tripsById.values.toList(growable: false)
      ..sort(_tripComparator);
    return trips;
  }

  @override
  Future<void> renameKit(KitId id, String name) async {
    final existing = _kitsById[id];
    if (existing == null) {
      throw StateError('Kit not found: ${id.value}');
    }

    await saveKit(
      KitTemplate(
        id: existing.id,
        name: name,
        categories: existing.categories,
        items: existing.items,
        isArchived: existing.isArchived,
      ),
    );
  }

  @override
  Future<void> saveKit(KitTemplate kit) async {
    _kitsById[kit.id] = _canonicalizeKit(kit);
  }

  @override
  Future<void> saveTrip(TripChecklistSnapshot trip) async {
    _validateTrip(trip);
    _tripsById[trip.id] = trip;
  }

  @override
  Future<void> setKitArchived(KitId id, {required bool isArchived}) async {
    final existing = _kitsById[id];
    if (existing == null) {
      throw StateError('Kit not found: ${id.value}');
    }

    await saveKit(
      KitTemplate(
        id: existing.id,
        name: existing.name,
        categories: existing.categories,
        items: existing.items,
        isArchived: isArchived,
      ),
    );
  }

  static int _kitComparator(KitTemplate left, KitTemplate right) {
    final byName = left.name.toLowerCase().compareTo(right.name.toLowerCase());
    if (byName != 0) {
      return byName;
    }
    return left.id.value.compareTo(right.id.value);
  }

  static int _tripComparator(
    TripChecklistSnapshot left,
    TripChecklistSnapshot right,
  ) {
    final byDate = right.startedOn.compareTo(left.startedOn);
    if (byDate != 0) {
      return byDate;
    }
    return left.id.value.compareTo(right.id.value);
  }

  static void _validateTrip(TripChecklistSnapshot trip) {
    for (final item in trip.items) {
      switch (item.status) {
        case ChecklistStatus.pending:
        case ChecklistStatus.packed:
        case ChecklistStatus.returned:
          if (item.omissionNote != null) {
            throw ArgumentError.value(
              item.omissionNote,
              'omissionNote',
              'Only omitted items can include an omission note',
            );
          }
          break;
        case ChecklistStatus.omitted:
          final note = item.omissionNote?.trim();
          if (note == null || note.isEmpty) {
            throw ArgumentError.value(
              item.omissionNote,
              'omissionNote',
              'Omitted items require an omission note',
            );
          }
          break;
      }
    }
  }

  static int _categoryComparator(KitCategory left, KitCategory right) {
    final byOrder = left.sortOrder.compareTo(right.sortOrder);
    if (byOrder != 0) {
      return byOrder;
    }

    final byName = left.name.toLowerCase().compareTo(right.name.toLowerCase());
    if (byName != 0) {
      return byName;
    }

    return left.id.value.compareTo(right.id.value);
  }

  static int _itemComparator(KitItemTemplate left, KitItemTemplate right) {
    final byOrder = left.sortOrder.compareTo(right.sortOrder);
    if (byOrder != 0) {
      return byOrder;
    }

    final byName = left.name.toLowerCase().compareTo(right.name.toLowerCase());
    if (byName != 0) {
      return byName;
    }

    return left.id.value.compareTo(right.id.value);
  }

  static KitTemplate _canonicalizeKit(KitTemplate kit) {
    final sortedCategories = List<KitCategory>.from(kit.categories)
      ..sort(_categoryComparator);

    final categoryIds = sortedCategories.map((category) => category.id).toSet();

    final normalizedCategories = <KitCategory>[];
    for (var index = 0; index < sortedCategories.length; index += 1) {
      final category = sortedCategories[index];
      normalizedCategories.add(
        KitCategory(id: category.id, name: category.name, sortOrder: index),
      );
    }

    final sortedItems = List<KitItemTemplate>.from(kit.items)
      ..sort(_itemComparator);
    final normalizedItems = <KitItemTemplate>[];

    for (var index = 0; index < sortedItems.length; index += 1) {
      final item = sortedItems[index];
      final categoryId = item.categoryId;
      normalizedItems.add(
        KitItemTemplate(
          id: item.id,
          name: item.name,
          quantity: item.quantity,
          note: item.note,
          categoryId: categoryId != null && categoryIds.contains(categoryId)
              ? categoryId
              : null,
          sortOrder: index,
        ),
      );
    }

    return KitTemplate(
      id: kit.id,
      name: kit.name,
      categories: normalizedCategories,
      items: normalizedItems,
      isArchived: kit.isArchived,
    );
  }
}
