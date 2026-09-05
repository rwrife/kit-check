import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:kit_check/persistence/local_database.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart' as sqlite;

void main() {
  test('migrates schema v1 kits table to include archive flag', () async {
    final tempDir = await Directory.systemTemp.createTemp(
      'kit-check-migration-',
    );
    final databasePath = p.join(tempDir.path, 'legacy.sqlite');

    final legacy = sqlite.sqlite3.open(databasePath);
    legacy.execute('PRAGMA foreign_keys = ON;');
    legacy.execute('''
      CREATE TABLE kits (
        id TEXT NOT NULL PRIMARY KEY,
        name TEXT NOT NULL,
        created_at_ms INTEGER NOT NULL
      );
    ''');
    legacy.execute('''
      CREATE TABLE kit_categories (
        id TEXT NOT NULL PRIMARY KEY,
        kit_id TEXT NOT NULL REFERENCES kits(id) ON DELETE CASCADE,
        name TEXT NOT NULL,
        sort_order INTEGER NOT NULL
      );
    ''');
    legacy.execute('''
      CREATE TABLE kit_items (
        id TEXT NOT NULL PRIMARY KEY,
        kit_id TEXT NOT NULL REFERENCES kits(id) ON DELETE CASCADE,
        category_id TEXT NULL REFERENCES kit_categories(id) ON DELETE SET NULL,
        name TEXT NOT NULL,
        quantity INTEGER NULL,
        note TEXT NULL,
        sort_order INTEGER NOT NULL
      );
    ''');
    legacy.execute(
      "INSERT INTO kits (id, name, created_at_ms) VALUES ('kit-1', 'Legacy Kit', 123456);",
    );
    legacy.execute('PRAGMA user_version = 1;');
    legacy.close();

    final database = LocalDatabase.file(databasePath);

    final tableInfo = await database
        .customSelect('PRAGMA table_info(kits);')
        .get();
    final hasArchiveColumn = tableInfo.any(
      (row) => row.data['name'] == 'is_archived',
    );

    expect(hasArchiveColumn, isTrue);

    final kits = await database.select(database.kits).get();
    expect(kits, hasLength(1));
    expect(kits.single.name, 'Legacy Kit');
    expect(kits.single.isArchived, isFalse);

    await database.close();
    await tempDir.delete(recursive: true);
  });
}
