import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';

part 'local_database.g.dart';

class Kits extends Table {
  TextColumn get id => text()();

  TextColumn get name => text()();

  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();

  IntColumn get createdAtMs => integer()();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}

class KitCategories extends Table {
  TextColumn get id => text()();

  TextColumn get kitId =>
      text().references(Kits, #id, onDelete: KeyAction.cascade)();

  TextColumn get name => text()();

  IntColumn get sortOrder => integer()();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}

class KitItems extends Table {
  TextColumn get id => text()();

  TextColumn get kitId =>
      text().references(Kits, #id, onDelete: KeyAction.cascade)();

  TextColumn get categoryId => text().nullable().references(
    KitCategories,
    #id,
    onDelete: KeyAction.setNull,
  )();

  TextColumn get name => text()();

  IntColumn get quantity => integer().nullable()();

  TextColumn get note => text().nullable()();

  IntColumn get sortOrder => integer()();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}

LazyDatabase openLocalDatabaseFile(String path) {
  return LazyDatabase(() async {
    final file = File(path);
    await file.parent.create(recursive: true);
    return NativeDatabase.createInBackground(file);
  });
}

@DriftDatabase(tables: <Type>[Kits, KitCategories, KitItems])
class LocalDatabase extends _$LocalDatabase {
  LocalDatabase(super.e);

  factory LocalDatabase.file(String path) {
    return LocalDatabase(openLocalDatabaseFile(path));
  }

  factory LocalDatabase.inMemory() {
    return LocalDatabase(NativeDatabase.memory());
  }

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      if (from < 2) {
        await m.addColumn(kits, kits.isArchived);
      }
    },
    beforeOpen: (OpeningDetails details) async {
      await customStatement('PRAGMA foreign_keys = ON;');
      if ((details.versionBefore ?? 0) < 2) {
        await customStatement(
          'UPDATE kits SET is_archived = 0 WHERE is_archived IS NULL;',
        );
      }
    },
  );
}
