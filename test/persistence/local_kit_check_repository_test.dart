import 'dart:io';

import 'package:drift/drift.dart' show Variable;
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

    test(
      'trip snapshots remain independent from later template edits',
      () async {
        final kit = model.KitTemplate(
          id: model.KitId('kit-weekend'),
          name: 'Weekend Kit',
          categories: <model.KitCategory>[
            model.KitCategory(
              id: model.CategoryId('cat-clothes'),
              name: 'Clothes',
              sortOrder: 1,
            ),
            model.KitCategory(
              id: model.CategoryId('cat-toiletries'),
              name: 'Toiletries',
              sortOrder: 0,
            ),
          ],
          items: <model.KitItemTemplate>[
            model.KitItemTemplate(
              id: model.ItemId('item-shirt'),
              name: 'Shirt',
              quantity: 2,
              categoryId: model.CategoryId('cat-clothes'),
              sortOrder: 0,
            ),
            model.KitItemTemplate(
              id: model.ItemId('item-toothbrush'),
              name: 'Toothbrush',
              categoryId: model.CategoryId('cat-toiletries'),
              sortOrder: 0,
            ),
          ],
        );
        await repository.saveKit(kit);

        final trip = await repository.createTrip(
          kitId: kit.id,
          tripName: 'Seattle weekend',
          tripNote: 'Rain expected',
          startedOn: DateTime.utc(2026, 9, 5),
        );

        await repository.saveKit(
          model.KitTemplate(
            id: kit.id,
            name: 'Weekend Kit Updated',
            categories: kit.categories,
            items: <model.KitItemTemplate>[
              model.KitItemTemplate(
                id: model.ItemId('item-shirt'),
                name: 'Rain Jacket',
                quantity: 1,
                categoryId: model.CategoryId('cat-clothes'),
                sortOrder: 0,
              ),
            ],
          ),
        );

        await repository.close();
        await openRepository();

        final reloaded = await repository.loadTrip(trip.id);
        expect(reloaded, isNotNull);
        expect(reloaded!.tripName, 'Seattle weekend');
        expect(reloaded.tripNote, 'Rain expected');
        expect(reloaded.startedOn, DateTime.utc(2026, 9, 5));
        expect(
          reloaded.items.map((item) => item.itemName).toList(growable: false),
          <String>['Toothbrush', 'Shirt'],
        );
        expect(
          reloaded.items.map((item) => item.status).toList(growable: false),
          <model.ChecklistStatus>[
            model.ChecklistStatus.pending,
            model.ChecklistStatus.pending,
          ],
        );
      },
    );

    test('persists checklist transitions and unresolved trip items', () async {
      final kit = model.KitTemplate(
        id: model.KitId('kit-core'),
        name: 'Core Kit',
        items: <model.KitItemTemplate>[
          model.KitItemTemplate(
            id: model.ItemId('item-passport'),
            name: 'Passport',
            sortOrder: 0,
          ),
          model.KitItemTemplate(
            id: model.ItemId('item-socks'),
            name: 'Socks',
            sortOrder: 1,
          ),
        ],
      );
      await repository.saveKit(kit);

      final trip = await repository.createTrip(
        kitId: kit.id,
        tripName: 'Road trip',
        startedOn: DateTime.utc(2026, 9, 6),
      );

      final progressed = trip
          .updateItem(
            model.ItemId('item-passport'),
            (item) => item.markPacked().markReturned(),
          )
          .updateItem(
            model.ItemId('item-socks'),
            (item) => item.omit('Laundry not finished'),
          );

      await repository.saveTrip(progressed);

      await repository.close();
      await openRepository();

      final reloaded = await repository.loadTrip(trip.id);
      expect(reloaded, isNotNull);

      final statusByItem = <String, model.ChecklistStatus>{
        for (final item in reloaded!.items) item.itemId.value: item.status,
      };
      expect(statusByItem['item-passport'], model.ChecklistStatus.returned);
      expect(statusByItem['item-socks'], model.ChecklistStatus.omitted);
      expect(
        reloaded.unresolvedItems.map((item) => item.itemId.value),
        <String>['item-socks'],
      );

      final invalidOmission = reloaded.updateItem(
        model.ItemId('item-socks'),
        (item) => item.copyWith(
          status: model.ChecklistStatus.omitted,
          omissionNote: null,
        ),
      );
      await expectLater(
        () => repository.saveTrip(invalidOmission),
        throwsArgumentError,
      );
    });

    test(
      'deleteTrip removes the trip and its checklist items from storage',
      () async {
        final kit = model.KitTemplate(
          id: model.KitId('kit-del'),
          name: 'Delete Kit',
          items: <model.KitItemTemplate>[
            model.KitItemTemplate(
              id: model.ItemId('item-hat'),
              name: 'Hat',
              sortOrder: 0,
            ),
          ],
        );
        await repository.saveKit(kit);

        final doomed = await repository.createTrip(
          kitId: kit.id,
          tripName: 'Doomed Trip',
          startedOn: DateTime.utc(2026, 4, 1),
        );
        final survivor = await repository.createTrip(
          kitId: kit.id,
          tripName: 'Survivor Trip',
          startedOn: DateTime.utc(2026, 4, 2),
        );

        await repository.deleteTrip(doomed.id);

        await repository.close();
        await openRepository();

        expect(await repository.loadTrip(doomed.id), isNull);
        final remaining = await repository.loadTrips();
        expect(remaining.map((trip) => trip.id.value), <String>[
          survivor.id.value,
        ]);

        final remainingChecklist = await database
            .customSelect(
              'SELECT COUNT(*) AS count FROM trip_checklist_items '
              'WHERE trip_id = ?',
              variables: <Variable<Object>>[Variable<String>(doomed.id.value)],
            )
            .getSingle();
        expect(remainingChecklist.read<int>('count'), 0);

        // Deleting a missing trip is a no-op.
        await repository.deleteTrip(model.TripId('trip-missing'));
        expect(await repository.loadTrips(), hasLength(1));
      },
    );
  });
}
