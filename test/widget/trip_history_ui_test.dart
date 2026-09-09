import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kit_check/app/app_configuration.dart';
import 'package:kit_check/domain/models.dart';
import 'package:kit_check/persistence/kit_check_repository.dart';
import 'package:kit_check/presentation/kit_check_app.dart';

void main() {
  Future<InMemoryKitCheckRepository> seedTrips(WidgetTester tester) async {
    final repository = InMemoryKitCheckRepository();

    final carryOn = await repository.createKit('Carry-On');
    await repository.saveKit(
      KitTemplate(
        id: carryOn.id,
        name: carryOn.name,
        items: <KitItemTemplate>[
          KitItemTemplate(
            id: ItemId('item-passport'),
            name: 'Passport',
            sortOrder: 0,
          ),
          KitItemTemplate(
            id: ItemId('item-socks'),
            name: 'Socks',
            sortOrder: 1,
          ),
        ],
      ),
    );

    final camping = await repository.createKit('Camping Kit');
    await repository.saveKit(
      KitTemplate(
        id: camping.id,
        name: camping.name,
        items: <KitItemTemplate>[
          KitItemTemplate(id: ItemId('item-tent'), name: 'Tent', sortOrder: 0),
        ],
      ),
    );

    await repository.createTrip(
      kitId: carryOn.id,
      tripName: 'Seattle Weekend',
      startedOn: DateTime.utc(2026, 1, 5),
    );
    await repository.createTrip(
      kitId: camping.id,
      tripName: 'Boat Trip',
      startedOn: DateTime.utc(2026, 3, 20),
    );
    await repository.createTrip(
      kitId: carryOn.id,
      tripName: 'Seattle Business Trip',
      startedOn: DateTime.utc(2026, 2, 10),
    );

    return repository;
  }

  Future<void> pumpApp(
    WidgetTester tester,
    InMemoryKitCheckRepository repository,
  ) async {
    tester.view.physicalSize = const Size(1200, 3200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      KitCheckApp(
        configuration: const AppConfiguration.localOnly(),
        repository: repository,
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('history lists all trips newest-first with local-only notice', (
    tester,
  ) async {
    final repository = await seedTrips(tester);
    await pumpApp(tester, repository);

    expect(find.byKey(const ValueKey('trip-history-section')), findsOneWidget);
    expect(
      find.textContaining(
        'Deleting a trip removes it from local history and future exports',
      ),
      findsOneWidget,
    );

    expect(find.text('3 trip(s) in history'), findsOneWidget);

    // Newest trip appears before older ones in the widget tree order.
    final boatIndex = tester.getTopLeft(find.text('Boat Trip').first);
    final seattleWeekendIndex = tester.getTopLeft(
      find.text('Seattle Weekend').first,
    );
    expect(boatIndex.dy, lessThan(seattleWeekendIndex.dy));
  });

  testWidgets('search filters history case-insensitively', (tester) async {
    final repository = await seedTrips(tester);
    await pumpApp(tester, repository);

    await tester.ensureVisible(
      find.byKey(const ValueKey('history-search-field')),
    );
    await tester.enterText(
      find.byKey(const ValueKey('history-search-field')),
      'seattle',
    );
    await tester.pumpAndSettle();

    expect(find.text('2 of 3 trip(s) match'), findsOneWidget);
    expect(find.text('Boat Trip'), findsNothing);

    await tester.tap(find.byKey(const ValueKey('history-clear-filters')));
    await tester.pumpAndSettle();
    expect(find.text('3 trip(s) in history'), findsOneWidget);
  });

  testWidgets('kit dropdown filter limits results', (tester) async {
    final repository = await seedTrips(tester);
    await pumpApp(tester, repository);

    await tester.ensureVisible(
      find.byKey(const ValueKey('history-kit-filter')),
    );
    await tester.tap(find.byKey(const ValueKey('history-kit-filter')));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Camping Kit').last);
    await tester.pumpAndSettle();

    expect(find.text('1 of 3 trip(s) match'), findsOneWidget);
    expect(find.text('Boat Trip'), findsOneWidget);
    expect(find.text('Seattle Weekend'), findsNothing);
  });

  testWidgets('date range filter matches inclusively by started date', (
    tester,
  ) async {
    final repository = await seedTrips(tester);
    await pumpApp(tester, repository);

    await tester.ensureVisible(
      find.byKey(const ValueKey('history-from-field')),
    );
    await tester.enterText(
      find.byKey(const ValueKey('history-from-field')),
      '2026-02-01',
    );
    await tester.enterText(
      find.byKey(const ValueKey('history-to-field')),
      '2026-02-28',
    );
    await tester.pumpAndSettle();

    expect(find.text('1 of 3 trip(s) match'), findsOneWidget);
    expect(find.text('Seattle Business Trip'), findsOneWidget);
    expect(find.text('Seattle Weekend'), findsNothing);
  });

  testWidgets('unresolved chip hides trips with all items returned', (
    tester,
  ) async {
    final repository = await seedTrips(tester);

    // Complete one trip fully: mark every item packed then returned.
    final trips = await repository.loadTrips();
    final business = trips.firstWhere(
      (trip) => trip.tripName == 'Seattle Business Trip',
    );
    var updated = business;
    for (final item in business.items) {
      updated = updated.updateItem(
        item.itemId,
        (current) => current.markPacked().markReturned(),
      );
    }
    await repository.saveTrip(updated);

    await pumpApp(tester, repository);

    // Before the chip, the completed trip is visible with its label.
    expect(find.text('Completed — all items returned'), findsOneWidget);

    await tester.ensureVisible(
      find.byKey(const ValueKey('history-unresolved-chip')),
    );
    await tester.tap(find.byKey(const ValueKey('history-unresolved-chip')));
    await tester.pumpAndSettle();

    expect(find.text('2 of 3 trip(s) match'), findsOneWidget);
    expect(find.text('Seattle Business Trip'), findsNothing);
  });

  testWidgets('empty search result shows empty-state message', (tester) async {
    final repository = await seedTrips(tester);
    await pumpApp(tester, repository);

    await tester.enterText(
      find.byKey(const ValueKey('history-search-field')),
      'nonexistent-trip-name',
    );
    await tester.pumpAndSettle();

    expect(find.text('0 of 3 trip(s) match'), findsOneWidget);
    expect(find.text('No trips match the current filters.'), findsOneWidget);
  });

  testWidgets('deleting a trip confirms retention behavior and removes it', (
    tester,
  ) async {
    final repository = await seedTrips(tester);
    await pumpApp(tester, repository);

    final trips = await repository.loadTrips();
    final boat = trips.firstWhere((trip) => trip.tripName == 'Boat Trip');

    await tester.ensureVisible(
      find.byKey(ValueKey('delete-trip-${boat.id.value}')),
    );
    await tester.tap(find.byKey(ValueKey('delete-trip-${boat.id.value}')));
    await tester.pumpAndSettle();

    // The confirmation explains the deletion semantics before anything runs.
    expect(
      find.textContaining(
        'permanently removes the trip and its checklist from local history '
        'and from future exports',
      ),
      findsOneWidget,
    );

    await tester.tap(find.byKey(const ValueKey('confirm-delete-trip-button')));
    await tester.pumpAndSettle();

    expect(find.text('Trip deleted from local history.'), findsOneWidget);
    expect(find.text('Boat Trip'), findsNothing);
    expect(find.text('2 trip(s) in history'), findsOneWidget);

    final remaining = await repository.loadTrips();
    expect(
      remaining.map((trip) => trip.tripName),
      isNot(contains('Boat Trip')),
    );
  });

  testWidgets('cancelling trip deletion keeps the trip', (tester) async {
    final repository = await seedTrips(tester);
    await pumpApp(tester, repository);

    final trips = await repository.loadTrips();
    final boat = trips.firstWhere((trip) => trip.tripName == 'Boat Trip');

    await tester.ensureVisible(
      find.byKey(ValueKey('delete-trip-${boat.id.value}')),
    );
    await tester.tap(find.byKey(ValueKey('delete-trip-${boat.id.value}')));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(TextButton, 'Cancel').last);
    await tester.pumpAndSettle();

    expect(find.text('Boat Trip'), findsOneWidget);
    final remaining = await repository.loadTrips();
    expect(remaining, hasLength(3));
  });

  testWidgets('empty history explains there are no trips yet', (tester) async {
    final repository = InMemoryKitCheckRepository();
    await pumpApp(tester, repository);

    expect(
      find.text('No trips yet. Start a trip checklist above.'),
      findsOneWidget,
    );
  });
}
