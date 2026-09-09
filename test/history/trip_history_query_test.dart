import 'package:flutter_test/flutter_test.dart';
import 'package:kit_check/domain/models.dart';
import 'package:kit_check/history/trip_history_query.dart';

TripChecklistSnapshot _trip({
  required String id,
  required String tripName,
  required KitId kitId,
  required String kitName,
  required DateTime startedOn,
  String? tripNote,
  List<ChecklistItemSnapshot> items = const <ChecklistItemSnapshot>[],
}) {
  return TripChecklistSnapshot(
    id: TripId(id),
    kitId: kitId,
    kitName: kitName,
    tripName: tripName,
    tripNote: tripNote,
    startedOn: startedOn,
    items: items,
  );
}

ChecklistItemSnapshot _item(
  String id,
  String name, {
  ChecklistStatus status = ChecklistStatus.pending,
  String? omissionNote,
}) {
  return ChecklistItemSnapshot(
    itemId: ItemId(id),
    itemName: name,
    status: status,
    omissionNote: omissionNote,
  );
}

void main() {
  final kitA = KitId('kit-a');
  final kitB = KitId('kit-b');

  final older = _trip(
    id: 'trip-1',
    tripName: 'Seattle Weekend',
    kitId: kitA,
    kitName: 'Carry-On',
    startedOn: DateTime.utc(2026, 1, 5),
    items: <ChecklistItemSnapshot>[
      _item('i1', 'Passport', status: ChecklistStatus.returned),
      _item('i2', 'Toothbrush'),
    ],
  );

  final newer = _trip(
    id: 'trip-2',
    tripName: 'Boat Trip',
    kitId: kitB,
    kitName: 'Camping Kit',
    startedOn: DateTime.utc(2026, 3, 20),
    tripNote: 'Lake Ann',
    items: <ChecklistItemSnapshot>[
      _item(
        'i3',
        'Tent',
        status: ChecklistStatus.omitted,
        omissionNote: 'Tent pole broken',
      ),
    ],
  );

  final completed = _trip(
    id: 'trip-3',
    tripName: 'Seattle Business Trip',
    kitId: kitA,
    kitName: 'Carry-On',
    startedOn: DateTime.utc(2026, 2, 10),
    items: <ChecklistItemSnapshot>[
      _item('i4', 'Laptop', status: ChecklistStatus.returned),
    ],
  );

  final trips = <TripChecklistSnapshot>[older, newer, completed];

  group('TripHistoryQuery', () {
    test('empty query matches all trips and is not active', () {
      const query = TripHistoryQuery();
      expect(query.isActive, isFalse);
      expect(filterTrips(trips, query), hasLength(3));
    });

    test('results are sorted newest-first deterministically', () {
      final matches = filterTrips(trips, const TripHistoryQuery());
      expect(matches.map((trip) => trip.id.value).toList(), <String>[
        'trip-2',
        'trip-3',
        'trip-1',
      ]);
    });

    test('ties in start date are broken by trip id ascending', () {
      final a = _trip(
        id: 'trip-b',
        tripName: 'B',
        kitId: kitA,
        kitName: 'K',
        startedOn: DateTime.utc(2026, 5, 1),
      );
      final b = _trip(
        id: 'trip-a',
        tripName: 'A',
        kitId: kitA,
        kitName: 'K',
        startedOn: DateTime.utc(2026, 5, 1),
      );
      final matches = filterTrips(<TripChecklistSnapshot>[
        a,
        b,
      ], const TripHistoryQuery());
      expect(matches.map((trip) => trip.id.value).toList(), <String>[
        'trip-a',
        'trip-b',
      ]);
    });

    test('filters by kit id', () {
      final matches = filterTrips(trips, TripHistoryQuery(kitId: kitA));
      expect(matches.map((trip) => trip.id.value).toList(), <String>[
        'trip-3',
        'trip-1',
      ]);
    });

    test('filters by inclusive date range', () {
      final matches = filterTrips(
        trips,
        TripHistoryQuery(
          startedFrom: DateTime.utc(2026, 1, 5),
          startedThrough: DateTime.utc(2026, 2, 10),
        ),
      );
      expect(matches.map((trip) => trip.id.value).toList(), <String>[
        'trip-3',
        'trip-1',
      ]);
    });

    test('date range with start after end matches nothing', () {
      final matches = filterTrips(
        trips,
        TripHistoryQuery(
          startedFrom: DateTime.utc(2026, 6, 1),
          startedThrough: DateTime.utc(2026, 1, 1),
        ),
      );
      expect(matches, isEmpty);
    });

    test('state filter separates active and completed trips', () {
      final active = filterTrips(
        trips,
        const TripHistoryQuery(state: TripStateFilter.active),
      );
      expect(active.map((trip) => trip.id.value).toList(), <String>[
        'trip-2',
        'trip-1',
      ]);

      final completedMatches = filterTrips(
        trips,
        const TripHistoryQuery(state: TripStateFilter.completed),
      );
      expect(completedMatches.map((trip) => trip.id.value).toList(), <String>[
        'trip-3',
      ]);
    });

    test('unresolvedOnly keeps only trips with unresolved items', () {
      final matches = filterTrips(
        trips,
        const TripHistoryQuery(unresolvedOnly: true),
      );
      expect(matches.map((trip) => trip.id.value).toList(), <String>[
        'trip-2',
        'trip-1',
      ]);
    });

    test('search matches trip name case-insensitively', () {
      final matches = filterTrips(
        trips,
        const TripHistoryQuery(searchText: 'seattle'),
      );
      expect(matches.map((trip) => trip.id.value).toList(), <String>[
        'trip-3',
        'trip-1',
      ]);
    });

    test(
      'search matches trip note, kit name, item name, and omission note',
      () {
        expect(
          filterTrips(
            trips,
            const TripHistoryQuery(searchText: 'lake'),
          ).map((trip) => trip.id.value).toList(),
          <String>['trip-2'],
        );
        expect(
          filterTrips(
            trips,
            const TripHistoryQuery(searchText: 'camping'),
          ).map((trip) => trip.id.value).toList(),
          <String>['trip-2'],
        );
        expect(
          filterTrips(
            trips,
            const TripHistoryQuery(searchText: 'toothbrush'),
          ).map((trip) => trip.id.value).toList(),
          <String>['trip-1'],
        );
        expect(
          filterTrips(
            trips,
            const TripHistoryQuery(searchText: 'pole broken'),
          ).map((trip) => trip.id.value).toList(),
          <String>['trip-2'],
        );
      },
    );

    test('search requires all whitespace-separated terms', () {
      final matches = filterTrips(
        trips,
        const TripHistoryQuery(searchText: 'seattle laptop'),
      );
      expect(matches.map((trip) => trip.id.value).toList(), <String>['trip-3']);
    });

    test('combined filters intersect', () {
      final matches = filterTrips(
        trips,
        TripHistoryQuery(
          kitId: kitA,
          state: TripStateFilter.active,
          searchText: 'weekend',
        ),
      );
      expect(matches.map((trip) => trip.id.value).toList(), <String>['trip-1']);
    });

    test('isActive is true when any filter is set', () {
      expect(const TripHistoryQuery(searchText: 'x').isActive, isTrue);
      expect(const TripHistoryQuery(searchText: '   ').isActive, isFalse);
      expect(TripHistoryQuery(kitId: kitA).isActive, isTrue);
      expect(
        TripHistoryQuery(startedFrom: DateTime.utc(2026)).isActive,
        isTrue,
      );
      expect(
        const TripHistoryQuery(state: TripStateFilter.completed).isActive,
        isTrue,
      );
      expect(const TripHistoryQuery(unresolvedOnly: true).isActive, isTrue);
    });
  });
}
