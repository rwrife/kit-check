import 'dart:math';

import 'package:drift/drift.dart';
import 'package:kit_check/domain/models.dart' as model;
import 'package:kit_check/persistence/kit_check_repository.dart';
import 'package:kit_check/persistence/local_database.dart';

class LocalDriftKitCheckRepository implements KitCheckRepository {
  LocalDriftKitCheckRepository(
    this._database, {
    String Function(String prefix)? idFactory,
    DateTime Function()? clock,
  }) : _idFactory = idFactory ?? _defaultIdFactory,
       _clock = clock ?? DateTime.now;

  final LocalDatabase _database;
  final String Function(String prefix) _idFactory;
  final DateTime Function() _clock;

  static final Random _random = Random.secure();

  static String _defaultIdFactory(String prefix) {
    final suffix = _random.nextInt(0x7fffffff).toRadixString(16);
    return '$prefix-${DateTime.now().microsecondsSinceEpoch}-$suffix';
  }

  Future<void> close() => _database.close();

  @override
  Future<model.KitTemplate> createKit(String name) async {
    final kit = model.KitTemplate(
      id: model.KitId(_idFactory('kit')),
      name: name,
    );
    await saveKit(kit);
    return kit;
  }

  @override
  Future<void> deleteKit(model.KitId id) async {
    await (_database.delete(
      _database.kits,
    )..where((tbl) => tbl.id.equals(id.value))).go();
  }

  @override
  Future<model.KitTemplate> duplicateKit(model.KitId id, {String? name}) async {
    final source = await _loadKitById(id);
    if (source == null) {
      throw StateError('Kit not found: ${id.value}');
    }

    final newKitId = model.KitId(_idFactory('kit'));
    final categoryMap = <model.CategoryId, model.CategoryId>{};

    final duplicatedCategories = <model.KitCategory>[];
    for (final category in source.categories) {
      final newCategoryId = model.CategoryId(_idFactory('cat'));
      categoryMap[category.id] = newCategoryId;
      duplicatedCategories.add(
        model.KitCategory(
          id: newCategoryId,
          name: category.name,
          sortOrder: category.sortOrder,
        ),
      );
    }

    final duplicatedItems = source.items
        .map(
          (item) => model.KitItemTemplate(
            id: model.ItemId(_idFactory('item')),
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

    final duplicated = model.KitTemplate(
      id: newKitId,
      name: name ?? '${source.name} Copy',
      categories: duplicatedCategories,
      items: duplicatedItems,
      isArchived: false,
    );

    await saveKit(duplicated);
    return duplicated;
  }

  @override
  Future<List<model.KitTemplate>> loadKits({
    bool includeArchived = true,
  }) async {
    final query = _database.select(_database.kits)
      ..orderBy(<OrderingTerm Function($KitsTable)>[
        (tbl) => OrderingTerm.asc(tbl.name.lower()),
        (tbl) => OrderingTerm.asc(tbl.id),
      ]);

    if (!includeArchived) {
      query.where((tbl) => tbl.isArchived.equals(false));
    }

    final kitRows = await query.get();
    return Future.wait(
      kitRows.map((row) => _loadKitGraph(row)),
      eagerError: true,
    );
  }

  @override
  Future<void> renameKit(model.KitId id, String name) async {
    final normalized = model.KitTemplate(id: id, name: name);
    final rows =
        await (_database.update(_database.kits)
              ..where((tbl) => tbl.id.equals(id.value)))
            .write(KitsCompanion(name: Value(normalized.name)));

    if (rows == 0) {
      throw StateError('Kit not found: ${id.value}');
    }
  }

  @override
  Future<void> saveKit(model.KitTemplate kit) async {
    final canonical = _canonicalizeKit(kit);

    await _database.transaction(() async {
      final existing = await (_database.select(
        _database.kits,
      )..where((tbl) => tbl.id.equals(canonical.id.value))).getSingleOrNull();

      await _database
          .into(_database.kits)
          .insertOnConflictUpdate(
            KitsCompanion.insert(
              id: canonical.id.value,
              name: canonical.name,
              isArchived: Value(canonical.isArchived),
              createdAtMs:
                  existing?.createdAtMs ?? _clock().millisecondsSinceEpoch,
            ),
          );

      await (_database.delete(
        _database.kitItems,
      )..where((tbl) => tbl.kitId.equals(canonical.id.value))).go();
      await (_database.delete(
        _database.kitCategories,
      )..where((tbl) => tbl.kitId.equals(canonical.id.value))).go();

      await _database.batch((batch) {
        batch.insertAll(
          _database.kitCategories,
          canonical.categories
              .map(
                (category) => KitCategoriesCompanion.insert(
                  id: category.id.value,
                  kitId: canonical.id.value,
                  name: category.name,
                  sortOrder: category.sortOrder,
                ),
              )
              .toList(growable: false),
        );

        batch.insertAll(
          _database.kitItems,
          canonical.items
              .map(
                (item) => KitItemsCompanion.insert(
                  id: item.id.value,
                  kitId: canonical.id.value,
                  name: item.name,
                  sortOrder: item.sortOrder,
                  quantity: Value(item.quantity),
                  note: Value(item.note),
                  categoryId: Value(item.categoryId?.value),
                ),
              )
              .toList(growable: false),
        );
      });
    });
  }

  @override
  Future<void> setKitArchived(
    model.KitId id, {
    required bool isArchived,
  }) async {
    final rows =
        await (_database.update(_database.kits)
              ..where((tbl) => tbl.id.equals(id.value)))
            .write(KitsCompanion(isArchived: Value(isArchived)));

    if (rows == 0) {
      throw StateError('Kit not found: ${id.value}');
    }
  }

  Future<model.KitTemplate?> _loadKitById(model.KitId id) async {
    final row = await (_database.select(
      _database.kits,
    )..where((tbl) => tbl.id.equals(id.value))).getSingleOrNull();
    if (row == null) {
      return null;
    }
    return _loadKitGraph(row);
  }

  Future<model.KitTemplate> _loadKitGraph(Kit kitRow) async {
    final categoryRows =
        await (_database.select(_database.kitCategories)
              ..where((tbl) => tbl.kitId.equals(kitRow.id))
              ..orderBy(<OrderingTerm Function($KitCategoriesTable)>[
                (tbl) => OrderingTerm.asc(tbl.sortOrder),
                (tbl) => OrderingTerm.asc(tbl.name.lower()),
                (tbl) => OrderingTerm.asc(tbl.id),
              ]))
            .get();

    final categories = categoryRows
        .map(
          (row) => model.KitCategory(
            id: model.CategoryId(row.id),
            name: row.name,
            sortOrder: row.sortOrder,
          ),
        )
        .toList(growable: false);

    final categoryIds = categories.map((category) => category.id).toSet();

    final itemRows =
        await (_database.select(_database.kitItems)
              ..where((tbl) => tbl.kitId.equals(kitRow.id))
              ..orderBy(<OrderingTerm Function($KitItemsTable)>[
                (tbl) => OrderingTerm.asc(tbl.sortOrder),
                (tbl) => OrderingTerm.asc(tbl.name.lower()),
                (tbl) => OrderingTerm.asc(tbl.id),
              ]))
            .get();

    final items = itemRows
        .map(
          (row) => model.KitItemTemplate(
            id: model.ItemId(row.id),
            name: row.name,
            quantity: row.quantity,
            note: row.note,
            categoryId: row.categoryId == null
                ? null
                : model.CategoryId(row.categoryId!),
            sortOrder: row.sortOrder,
          ),
        )
        .where(
          (item) =>
              item.categoryId == null || categoryIds.contains(item.categoryId!),
        )
        .toList(growable: false);

    return model.KitTemplate(
      id: model.KitId(kitRow.id),
      name: kitRow.name,
      categories: categories,
      items: items,
      isArchived: kitRow.isArchived,
    );
  }

  static int _categoryComparator(
    model.KitCategory left,
    model.KitCategory right,
  ) {
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

  static int _itemComparator(
    model.KitItemTemplate left,
    model.KitItemTemplate right,
  ) {
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

  static model.KitTemplate _canonicalizeKit(model.KitTemplate kit) {
    final sortedCategories = List<model.KitCategory>.from(kit.categories)
      ..sort(_categoryComparator);

    final normalizedCategories = <model.KitCategory>[];
    final knownCategoryIds = <model.CategoryId>{};

    for (var index = 0; index < sortedCategories.length; index += 1) {
      final category = sortedCategories[index];
      normalizedCategories.add(
        model.KitCategory(
          id: category.id,
          name: category.name,
          sortOrder: index,
        ),
      );
      knownCategoryIds.add(category.id);
    }

    final sortedItems = List<model.KitItemTemplate>.from(kit.items)
      ..sort(_itemComparator);
    final normalizedItems = <model.KitItemTemplate>[];

    for (var index = 0; index < sortedItems.length; index += 1) {
      final item = sortedItems[index];
      normalizedItems.add(
        model.KitItemTemplate(
          id: item.id,
          name: item.name,
          quantity: item.quantity,
          note: item.note,
          categoryId:
              item.categoryId != null &&
                  knownCategoryIds.contains(item.categoryId!)
              ? item.categoryId
              : null,
          sortOrder: index,
        ),
      );
    }

    return model.KitTemplate(
      id: kit.id,
      name: kit.name,
      categories: normalizedCategories,
      items: normalizedItems,
      isArchived: kit.isArchived,
    );
  }
}
