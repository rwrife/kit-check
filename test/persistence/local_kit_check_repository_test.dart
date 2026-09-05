import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:kit_check/domain/models.dart' as model;
import 'package:kit_check/persistence/local_database.dart';
import 'package:kit_check/persistence/local_kit_check_repository.dart';
import 'package:path/path.dart' as p;

void main() {
  group('LocalDriftKitCheckRepository', () {
    late Directory tempDir;
    late String databasePath;
    late LocalDatabase database;
    late LocalDriftKitCheckRepository repository;
    var idCounter = 0;

    String idFactory(String prefix) {
      idCounter += 1;
      return '$prefix-$idCounter';
    }

    Future<void> openRepository() async {
      database = LocalDatabase.file(databasePath);
      repository = LocalDriftKitCheckRepository(
        database,
        idFactory: idFactory,
        clock: () => DateTime.utc(2026, 1, 1),
      );
    }

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('kit-check-repo-test-');
      databasePath = p.join(tempDir.path, 'kit_check.sqlite');
      idCounter = 0;
      await openRepository();
    });

    tearDown(() async {
      await repository.close();
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    test(
      'supports create, rename, archive, duplicate, and delete lifecycle',
      () async {
        final created = await repository.createKit('Weekend Kit');

        final category = model.CategoryId('cat-clothes');
        await repository.saveKit(
          model.KitTemplate(
            id: created.id,
            name: created.name,
            categories: <model.KitCategory>[
              model.KitCategory(id: category, name: 'Clothes', sortOrder: 0),
            ],
            items: <model.KitItemTemplate>[
              model.KitItemTemplate(
                id: model.ItemId('item-socks'),
                name: 'Socks',
                quantity: 3,
                note: 'Wool pairs',
                categoryId: category,
                sortOrder: 0,
              ),
            ],
          ),
        );

        await repository.renameKit(created.id, 'Weekend Carry');
        await repository.setKitArchived(created.id, isArchived: true);

        final duplicated = await repository.duplicateKit(
          created.id,
          name: 'Weekend Carry Active',
        );

        final all = await repository.loadKits();
        expect(all, hasLength(2));
        expect(all.map((kit) => kit.name), <String>[
          'Weekend Carry',
          'Weekend Carry Active',
        ]);

        final archived = all.firstWhere((kit) => kit.id == created.id);
        expect(archived.isArchived, isTrue);

        final visible = await repository.loadKits(includeArchived: false);
        expect(visible, hasLength(1));
        expect(visible.single.id, duplicated.id);
        expect(visible.single.items.single.categoryId, isNotNull);

        await repository.deleteKit(created.id);

        final afterDelete = await repository.loadKits();
        expect(afterDelete, hasLength(1));
        expect(afterDelete.single.id, duplicated.id);
        expect(afterDelete.single.name, 'Weekend Carry Active');
      },
    );

    test(
      'persists deterministic category and item ordering across restarts',
      () async {
        final kit = model.KitTemplate(
          id: model.KitId('kit-a'),
          name: 'Road Trip',
          categories: <model.KitCategory>[
            model.KitCategory(
              id: model.CategoryId('cat-b'),
              name: 'Toiletries',
              sortOrder: 9,
            ),
            model.KitCategory(
              id: model.CategoryId('cat-a'),
              name: 'Clothes',
              sortOrder: 2,
            ),
          ],
          items: <model.KitItemTemplate>[
            model.KitItemTemplate(
              id: model.ItemId('item-c'),
              name: 'Toothbrush',
              quantity: 1,
              note: 'Travel size',
              categoryId: model.CategoryId('cat-b'),
              sortOrder: 7,
            ),
            model.KitItemTemplate(
              id: model.ItemId('item-a'),
              name: 'Socks',
              quantity: 3,
              categoryId: model.CategoryId('cat-a'),
              sortOrder: 0,
            ),
            model.KitItemTemplate(
              id: model.ItemId('item-b'),
              name: 'Passport',
              note: 'Keep handy',
              sortOrder: 4,
            ),
          ],
        );

        await repository.saveKit(kit);

        var persisted = (await repository.loadKits()).single;
        expect(
          persisted.categories
              .map((category) => category.name)
              .toList(growable: false),
          <String>['Clothes', 'Toiletries'],
        );
        expect(
          persisted.categories
              .map((category) => category.sortOrder)
              .toList(growable: false),
          <int>[0, 1],
        );
        expect(
          persisted.items.map((item) => item.name).toList(growable: false),
          <String>['Socks', 'Passport', 'Toothbrush'],
        );
        expect(
          persisted.items.map((item) => item.sortOrder).toList(growable: false),
          <int>[0, 1, 2],
        );

        await repository.close();
        await openRepository();

        persisted = (await repository.loadKits()).single;
        expect(
          persisted.categories
              .map((category) => category.name)
              .toList(growable: false),
          <String>['Clothes', 'Toiletries'],
        );
        expect(
          persisted.items.map((item) => item.name).toList(growable: false),
          <String>['Socks', 'Passport', 'Toothbrush'],
        );
        expect(persisted.items[1].note, 'Keep handy');
        expect(persisted.items[1].categoryId, isNull);
        expect(persisted.items[2].quantity, 1);
      },
    );
  });
}
