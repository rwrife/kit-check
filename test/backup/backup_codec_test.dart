import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:kit_check/backup/backup_document.dart';
import 'package:kit_check/domain/models.dart';

void main() {
  KitTemplate buildKit() {
    return KitTemplate(
      id: KitId('kit-1'),
      name: 'Weekend Kit',
      categories: <KitCategory>[
        KitCategory(id: CategoryId('cat-1'), name: 'Clothes', sortOrder: 0),
      ],
      items: <KitItemTemplate>[
        KitItemTemplate(
          id: ItemId('item-1'),
          name: 'Socks',
          quantity: 3,
          note: 'Wool pairs',
          categoryId: CategoryId('cat-1'),
          sortOrder: 0,
        ),
      ],
    );
  }

  TripChecklistSnapshot buildTrip() {
    return TripChecklistSnapshot(
      id: TripId('trip-1'),
      kitId: KitId('kit-1'),
      kitName: 'Weekend Kit',
      tripName: 'Seattle Weekend',
      tripNote: 'Ferry booked',
      startedOn: DateTime.utc(2026, 1, 1),
      items: <ChecklistItemSnapshot>[
        ChecklistItemSnapshot(
          itemId: ItemId('item-1'),
          itemName: 'Socks',
          quantity: 3,
          note: 'Wool pairs',
          categoryName: 'Clothes',
          status: ChecklistStatus.omitted,
          omissionNote: 'Laundry not finished',
        ),
      ],
    );
  }

  group('BackupCodec', () {
    test('encodes a documented schema-version-1 envelope', () {
      final json = BackupCodec.encode(
        BackupDocument(kits: [buildKit()], trips: [buildTrip()]),
        exportedAt: DateTime.utc(2026, 1, 1),
      );
      final decoded = jsonDecode(json) as Map<String, Object?>;

      expect(decoded['schemaVersion'], 1);
      expect(decoded['app'], 'kit_check');
      expect(decoded['exportedAt'], '2026-01-01T00:00:00.000Z');
      expect(decoded['kits'], hasLength(1));
      expect(decoded['trips'], hasLength(1));
    });

    test('round-trips kits and trips with all fields preserved', () {
      final original = BackupDocument(kits: [buildKit()], trips: [buildTrip()]);

      final restored = BackupCodec.decode(BackupCodec.encode(original));

      final kit = restored.kits.single;
      expect(kit.id.value, 'kit-1');
      expect(kit.name, 'Weekend Kit');
      expect(kit.isArchived, isFalse);
      expect(kit.categories.single.name, 'Clothes');
      expect(kit.items.single.quantity, 3);
      expect(kit.items.single.note, 'Wool pairs');
      expect(kit.items.single.categoryId?.value, 'cat-1');

      final trip = restored.trips.single;
      expect(trip.tripName, 'Seattle Weekend');
      expect(trip.tripNote, 'Ferry booked');
      expect(trip.startedOn, DateTime.utc(2026, 1, 1));
      expect(trip.items.single.status, ChecklistStatus.omitted);
      expect(trip.items.single.omissionNote, 'Laundry not finished');
    });

    test('rejects malformed JSON', () {
      expect(
        () => BackupCodec.decode('{not json'),
        throwsA(isA<BackupValidationException>()),
      );
    });

    test('rejects unknown schema versions before touching data', () {
      final payload = <String, Object?>{
        'schemaVersion': 99,
        'app': 'kit_check',
        'kits': <Object?>[],
        'trips': <Object?>[],
      };
      expect(
        () => BackupCodec.decode(jsonEncode(payload)),
        throwsA(
          isA<BackupValidationException>().having(
            (error) => error.message,
            'message',
            contains('Unsupported schemaVersion'),
          ),
        ),
      );
    });

    test('rejects documents from a different app', () {
      final payload = <String, Object?>{
        'schemaVersion': 1,
        'app': 'other_app',
        'kits': <Object?>[],
        'trips': <Object?>[],
      };
      expect(
        () => BackupCodec.decode(jsonEncode(payload)),
        throwsA(isA<BackupValidationException>()),
      );
    });

    test('rejects missing kits/trips arrays', () {
      final payload = <String, Object?>{'schemaVersion': 1, 'app': 'kit_check'};
      expect(
        () => BackupCodec.decode(jsonEncode(payload)),
        throwsA(isA<BackupValidationException>()),
      );
    });

    test('rejects duplicate kit ids', () {
      final document = BackupDocument(
        kits: [buildKit(), buildKit()],
        trips: const <TripChecklistSnapshot>[],
      );
      expect(
        () => BackupCodec.decode(BackupCodec.encode(document)),
        throwsA(
          isA<BackupValidationException>().having(
            (error) => error.message,
            'message',
            contains('Duplicate kit id'),
          ),
        ),
      );
    });

    test('rejects item referencing an unknown category', () {
      final kit = KitTemplate(
        id: KitId('kit-1'),
        name: 'Broken Kit',
        items: <KitItemTemplate>[
          KitItemTemplate(
            id: ItemId('item-1'),
            name: 'Socks',
            categoryId: CategoryId('cat-missing'),
            sortOrder: 0,
          ),
        ],
      );
      final document = BackupDocument(
        kits: [kit],
        trips: const <TripChecklistSnapshot>[],
      );
      expect(
        () => BackupCodec.decode(BackupCodec.encode(document)),
        throwsA(
          isA<BackupValidationException>().having(
            (error) => error.message,
            'message',
            contains('does not exist'),
          ),
        ),
      );
    });

    test('rejects unknown checklist status values', () {
      final trip = buildTrip();
      final payload = jsonDecode(
        BackupCodec.encode(BackupDocument(kits: [buildKit()], trips: [trip])),
      ) as Map<String, Object?>;
      final trips = payload['trips'] as List<Object?>;
      final firstTrip = trips.first as Map<String, Object?>;
      final items = firstTrip['items'] as List<Object?>;
      (items.first as Map<String, Object?>)['status'] = 'exploded';

      expect(
        () => BackupCodec.decode(jsonEncode(payload)),
        throwsA(
          isA<BackupValidationException>().having(
            (error) => error.message,
            'message',
            contains('unknown status'),
          ),
        ),
      );
    });

    test('rejects omitted items without a note', () {
      final trip = TripChecklistSnapshot(
        id: TripId('trip-1'),
        kitId: KitId('kit-1'),
        kitName: 'Weekend Kit',
        tripName: 'Seattle Weekend',
        startedOn: DateTime.utc(2026, 1, 1),
        items: <ChecklistItemSnapshot>[
          ChecklistItemSnapshot(
            itemId: ItemId('item-1'),
            itemName: 'Socks',
            status: ChecklistStatus.omitted,
            omissionNote: '   ',
          ),
        ],
      );
      // Encode tolerates the in-memory object; decode must reject it.
      final json = BackupCodec.encode(
        BackupDocument(kits: const [], trips: [trip]),
      );
      expect(
        () => BackupCodec.decode(json),
        throwsA(
          isA<BackupValidationException>().having(
            (error) => error.message,
            'message',
            contains('non-empty omissionNote'),
          ),
        ),
      );
    });

    test('rejects omission notes on non-omitted items', () {
      final trip = TripChecklistSnapshot(
        id: TripId('trip-1'),
        kitId: KitId('kit-1'),
        kitName: 'Weekend Kit',
        tripName: 'Seattle Weekend',
        startedOn: DateTime.utc(2026, 1, 1),
        items: <ChecklistItemSnapshot>[
          ChecklistItemSnapshot(
            itemId: ItemId('item-1'),
            itemName: 'Socks',
            status: ChecklistStatus.packed,
            omissionNote: 'sneaky note',
          ),
        ],
      );
      final json = BackupCodec.encode(
        BackupDocument(kits: const [], trips: [trip]),
      );
      expect(
        () => BackupCodec.decode(json),
        throwsA(isA<BackupValidationException>()),
      );
    });

    test('rejects duplicate item ids within a trip checklist', () {
      final trip = TripChecklistSnapshot(
        id: TripId('trip-1'),
        kitId: KitId('kit-1'),
        kitName: 'Weekend Kit',
        tripName: 'Seattle Weekend',
        startedOn: DateTime.utc(2026, 1, 1),
        items: <ChecklistItemSnapshot>[
          ChecklistItemSnapshot(itemId: ItemId('item-1'), itemName: 'Socks'),
          ChecklistItemSnapshot(
            itemId: ItemId('item-1'),
            itemName: 'Other Socks',
          ),
        ],
      );
      final json = BackupCodec.encode(
        BackupDocument(kits: const [], trips: [trip]),
      );
      expect(
        () => BackupCodec.decode(json),
        throwsA(
          isA<BackupValidationException>().having(
            (error) => error.message,
            'message',
            contains('duplicate item id'),
          ),
        ),
      );
    });
  });
}
