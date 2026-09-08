import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:kit_check/backup/backup_document.dart';
import 'package:kit_check/backup/backup_service.dart';
import 'package:kit_check/domain/models.dart' as model;
import 'package:kit_check/persistence/local_database.dart';
import 'package:kit_check/persistence/local_kit_check_repository.dart';
import 'package:path/path.dart' as p;

void main() {
  group('BackupService against temporary databases', () {
    late Directory tempDir;
    late LocalDatabase database;
    late LocalDriftKitCheckRepository repository;
    late BackupService service;
    var idCounter = 0;

    String idFactory(String prefix) {
      idCounter += 1;
      return '$prefix-$idCounter';
    }

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('kit-check-backup-test-');
      database = LocalDatabase.file(p.join(tempDir.path, 'kit_check.sqlite'));
      repository = LocalDriftKitCheckRepository(
        database,
        idFactory: idFactory,
        clock: () => DateTime.utc(2026, 1, 1),
      );
      service = BackupService(repository);
      idCounter = 0;
    });

    tearDown(() async {
      await repository.close();
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    Future<model.TripChecklistSnapshot> seedKitAndTrip() async {
      final kit = model.KitTemplate(
        id: model.KitId('kit-seed'),
        name: 'Seed Kit',
        categories: <model.KitCategory>[
          model.KitCategory(
            id: model.CategoryId('cat-seed'),
            name: 'Clothes',
            sortOrder: 0,
          ),
        ],
        items: <model.KitItemTemplate>[
          model.KitItemTemplate(
            id: model.ItemId('item-seed'),
            name: 'Socks',
            quantity: 2,
            categoryId: model.CategoryId('cat-seed'),
            sortOrder: 0,
          ),
        ],
      );
      await repository.saveKit(kit);

      final trip = model.TripChecklistSnapshot(
        id: model.TripId('trip-seed'),
        kitId: kit.id,
        kitName: kit.name,
        tripName: 'Seed Trip',
        startedOn: DateTime.utc(2026, 2, 2),
        items: <model.ChecklistItemSnapshot>[
          model.ChecklistItemSnapshot(
            itemId: model.ItemId('item-seed'),
            itemName: 'Socks',
            quantity: 2,
            categoryName: 'Clothes',
            status: model.ChecklistStatus.packed,
          ),
        ],
      );
      await repository.saveTrip(trip);
      return trip;
    }

    test('export captures archived kits and trip snapshots', () async {
      await seedKitAndTrip();
      await repository.setKitArchived(
        model.KitId('kit-seed'),
        isArchived: true,
      );

      final document = await service.exportBackup();
      expect(document.kits, hasLength(1));
      expect(document.kits.single.isArchived, isTrue);
      expect(document.trips, hasLength(1));
      expect(document.trips.single.tripName, 'Seed Trip');

      final json = await service.exportBackupJson();
      final restored = BackupCodec.decode(json);
      expect(restored.kits.single.id.value, 'kit-seed');
    });

    test(
      'JSON round trip into a fresh temporary database restores data',
      () async {
        await seedKitAndTrip();
        final exported = await service.exportBackupJson();

        final secondTemp = await Directory.systemTemp.createTemp(
          'kit-check-backup-restore-',
        );
        addTearDown(() async {
          if (await secondTemp.exists()) {
            await secondTemp.delete(recursive: true);
          }
        });

        final secondDb = LocalDatabase.file(
          p.join(secondTemp.path, 'restore.sqlite'),
        );
        final secondRepo = LocalDriftKitCheckRepository(
          secondDb,
          clock: () => DateTime.utc(2026, 3, 3),
        );
        addTearDown(secondRepo.close);

        final secondService = BackupService(secondRepo);
        final plan = await secondService.previewRestore(
          BackupCodec.decode(exported),
        );
        expect(plan.newKitIds, <String>['kit-seed']);
        expect(plan.conflictingKitIds, isEmpty);
        expect(plan.newTripIds, <String>['trip-seed']);
        expect(plan.hasConflicts, isFalse);

        final summary = await secondService.applyRestore(
          BackupCodec.decode(exported),
          userConfirmed: true,
        );
        expect(summary.kitsInserted, 1);
        expect(summary.tripsInserted, 1);
        expect(summary.localDataCleared, isFalse);

        final kits = await secondRepo.loadKits();
        expect(kits.single.name, 'Seed Kit');
        expect(kits.single.isArchived, isFalse);

        final trips = await secondRepo.loadTrips();
        expect(trips.single.tripName, 'Seed Trip');
        expect(
          trips.single.startedOn,
          DateTime.utc(2026, 2, 2),
          reason: 'trip timestamps must survive as UTC instants',
        );
        expect(trips.single.items.single.status, model.ChecklistStatus.packed);
      },
    );

    test('applyRestore refuses to run without explicit confirmation', () async {
      await seedKitAndTrip();
      final exported = await service.exportBackupJson();

      expect(
        () => service.applyRestore(
          BackupCodec.decode(exported),
          userConfirmed: false,
        ),
        throwsStateError,
      );

      final kits = await repository.loadKits();
      expect(kits, hasLength(1));
    });

    test(
      'preview detects conflicts and keepLocal preserves local data',
      () async {
        await seedKitAndTrip();
        final exported = BackupCodec.decode(await service.exportBackupJson());

        // Rename the local kit so we can tell which version survived.
        await repository.renameKit(model.KitId('kit-seed'), 'Renamed Local');

        final plan = await service.previewRestore(exported);
        expect(plan.conflictingKitIds, <String>['kit-seed']);
        expect(plan.newKitIds, isEmpty);
        expect(plan.hasConflicts, isTrue);

        final summary = await service.applyRestore(
          exported,
          userConfirmed: true,
        );
        expect(summary.kitsKeptLocal, 1);
        expect(summary.tripsKeptLocal, 1);

        final kits = await repository.loadKits();
        expect(kits.single.name, 'Renamed Local');
      },
    );

    test(
      'replaceAll restore removes local records missing from backup',
      () async {
        await seedKitAndTrip();
        final exported = BackupCodec.decode(await service.exportBackupJson());

        await repository.createKit('Local Only Kit');

        final summary = await service.applyRestore(
          exported,
          userConfirmed: true,
          mode: RestoreMode.replaceAll,
          conflictResolution: RestoreConflictResolution.overwrite,
        );
        expect(summary.localDataCleared, isTrue);

        final kits = await repository.loadKits();
        expect(kits, hasLength(1));
        expect(kits.single.id.value, 'kit-seed');
      },
    );

    test('deleteAllData clears kits, trips, and checklist items', () async {
      await seedKitAndTrip();

      await service.deleteAllData();

      expect(await repository.loadKits(), isEmpty);
      expect(await repository.loadTrips(), isEmpty);

      final secondTemp = await Directory.systemTemp.createTemp(
        'kit-check-backup-empty-',
      );
      addTearDown(() async {
        if (await secondTemp.exists()) {
          await secondTemp.delete(recursive: true);
        }
      });
      final emptyExport = BackupDocument(
        kits: const <model.KitTemplate>[],
        trips: const <model.TripChecklistSnapshot>[],
      );
      expect((await service.previewRestore(emptyExport)).totalIncoming, 0);
    });

    test('CSV export contains documented columns and quoted fields', () async {
      final kit = model.KitTemplate(
        id: model.KitId('kit-csv'),
        name: 'Kit, with comma',
        items: <model.KitItemTemplate>[
          model.KitItemTemplate(
            id: model.ItemId('item-csv'),
            name: 'Socks "wool"',
            sortOrder: 0,
          ),
        ],
      );
      await repository.saveKit(kit);
      await repository.saveTrip(
        model.TripChecklistSnapshot(
          id: model.TripId('trip-csv'),
          kitId: kit.id,
          kitName: kit.name,
          tripName: 'Rainy "Weekend", Part 1',
          startedOn: DateTime.utc(2026, 4, 4),
          items: <model.ChecklistItemSnapshot>[
            model.ChecklistItemSnapshot(
              itemId: model.ItemId('item-csv'),
              itemName: 'Socks "wool"',
              status: model.ChecklistStatus.omitted,
              omissionNote: 'Wet, still damp',
            ),
          ],
        ),
      );

      final csv = await service.exportHistoryCsv();
      final lines = const LineSplitter().convert(csv);

      expect(
        lines.first,
        'trip_id,trip_name,kit_name,started_on_utc,'
        'item_id,item_name,item_status,omission_note',
      );
      expect(lines, hasLength(2));
      // The whole row must contain every field with RFC 4180 quoting.
      expect(lines[1], contains('trip-csv'));
      expect(lines[1], contains('"Kit, with comma"'));
      expect(lines[1], contains('"Socks ""wool"""'));
      expect(lines[1], contains('2026-04-04T00:00:00.000Z'));
      expect(lines[1], contains('"Wet, still damp"'));
      expect(lines[1], contains('omitted'));
    });
  });
}
