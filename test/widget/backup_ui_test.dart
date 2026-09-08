import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kit_check/app/app_configuration.dart';
import 'package:kit_check/backup/backup_document.dart';
import 'package:kit_check/domain/models.dart';
import 'package:kit_check/persistence/kit_check_repository.dart';
import 'package:kit_check/presentation/kit_check_app.dart';

void main() {
  String? lastClipboardText;

  setUp(() {
    lastClipboardText = null;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, (
          MethodCall call,
        ) async {
          if (call.method == 'Clipboard.setData') {
            lastClipboardText =
                (call.arguments as Map<Object?, Object?>)['text'] as String;
          }
          return null;
        });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, null);
  });

  Future<void> seedKitAndTrip(
    WidgetTester tester,
    InMemoryKitCheckRepository repository,
  ) async {
    final kit = await repository.createKit('Weekend Kit');
    await repository.saveKit(
      KitTemplate(
        id: kit.id,
        name: kit.name,
        items: <KitItemTemplate>[
          KitItemTemplate(id: ItemId('item-1'), name: 'Passport', sortOrder: 0),
        ],
      ),
    );
    await repository.createTrip(
      kitId: kit.id,
      tripName: 'Seattle Weekend',
      startedOn: DateTime.utc(2026, 1, 1),
    );
  }

  Future<void> pumpApp(
    WidgetTester tester,
    InMemoryKitCheckRepository repository,
  ) async {
    tester.view.physicalSize = const Size(1200, 2400);
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

  testWidgets('JSON export writes valid backup content to clipboard', (
    tester,
  ) async {
    final repository = InMemoryKitCheckRepository();
    await seedKitAndTrip(tester, repository);
    await pumpApp(tester, repository);

    await tester.ensureVisible(
      find.byKey(const ValueKey('export-backup-button')),
    );
    await tester.tap(find.byKey(const ValueKey('export-backup-button')));
    await tester.pumpAndSettle();

    expect(lastClipboardText, isNotNull);
    final document = BackupCodec.decode(lastClipboardText!);
    expect(document.kits, hasLength(1));
    expect(document.kits.single.name, 'Weekend Kit');
    expect(document.trips.single.tripName, 'Seattle Weekend');

    expect(
      find.text('Backup copied to clipboard as versioned JSON.'),
      findsOneWidget,
    );
  });

  testWidgets('CSV export writes header and trip rows to clipboard', (
    tester,
  ) async {
    final repository = InMemoryKitCheckRepository();
    await seedKitAndTrip(tester, repository);
    await pumpApp(tester, repository);

    await tester.ensureVisible(find.byKey(const ValueKey('export-csv-button')));
    await tester.tap(find.byKey(const ValueKey('export-csv-button')));
    await tester.pumpAndSettle();

    expect(lastClipboardText, isNotNull);
    final lines = lastClipboardText!.trim().split('\n');
    expect(
      lines.first,
      startsWith(
        'trip_id,trip_name,kit_name,started_on_utc,item_id,item_name,'
        'item_status,omission_note',
      ),
    );
    expect(lines, hasLength(2));
    expect(lines[1], contains('Seattle Weekend'));
    expect(lines[1], contains('pending'));
  });

  testWidgets('restore preview requires confirmation before writing data', (
    tester,
  ) async {
    final repository = InMemoryKitCheckRepository();
    await seedKitAndTrip(tester, repository);

    // A backup taken from another device with a different kit.
    final foreign = KitTemplate(id: KitId('kit-foreign'), name: 'Climbing Kit');
    final backupJson = BackupCodec.encode(
      BackupDocument(
        kits: <KitTemplate>[foreign],
        trips: const <TripChecklistSnapshot>[],
      ),
    );

    await pumpApp(tester, repository);

    await tester.ensureVisible(
      find.byKey(const ValueKey('restore-backup-button')),
    );
    await tester.tap(find.byKey(const ValueKey('restore-backup-button')));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const ValueKey('backup-json-field')),
      backupJson,
    );
    await tester.tap(find.byKey(const ValueKey('preview-restore-button')));
    await tester.pumpAndSettle();

    expect(find.text('Confirm restore'), findsOneWidget);
    expect(find.textContaining('New kits: 1'), findsOneWidget);

    // Cancel out — local data must be untouched.
    await tester.tap(find.widgetWithText(TextButton, 'Cancel').last);
    await tester.pumpAndSettle();

    final kits = await repository.loadKits();
    expect(kits, hasLength(1));
    expect(kits.single.name, 'Weekend Kit');
  });

  testWidgets('confirmed replace-all restore swaps local data', (tester) async {
    final repository = InMemoryKitCheckRepository();
    await seedKitAndTrip(tester, repository);

    final foreign = KitTemplate(id: KitId('kit-foreign'), name: 'Climbing Kit');
    final backupJson = BackupCodec.encode(
      BackupDocument(
        kits: <KitTemplate>[foreign],
        trips: const <TripChecklistSnapshot>[],
      ),
    );

    await pumpApp(tester, repository);

    await tester.ensureVisible(
      find.byKey(const ValueKey('restore-backup-button')),
    );
    await tester.tap(find.byKey(const ValueKey('restore-backup-button')));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const ValueKey('backup-json-field')),
      backupJson,
    );
    await tester.tap(find.byKey(const ValueKey('preview-restore-button')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('confirm-restore-button')));
    await tester.pumpAndSettle();

    final kits = await repository.loadKits();
    expect(kits, hasLength(1));
    expect(kits.single.name, 'Climbing Kit');
    expect(await repository.loadTrips(), isEmpty);
  });

  testWidgets('invalid backup JSON is rejected without data changes', (
    tester,
  ) async {
    final repository = InMemoryKitCheckRepository();
    await seedKitAndTrip(tester, repository);
    await pumpApp(tester, repository);

    await tester.ensureVisible(
      find.byKey(const ValueKey('restore-backup-button')),
    );
    await tester.tap(find.byKey(const ValueKey('restore-backup-button')));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const ValueKey('backup-json-field')),
      '{"schemaVersion": 42, "app": "kit_check", "kits": [], "trips": []}',
    );
    await tester.tap(find.byKey(const ValueKey('preview-restore-button')));
    await tester.pumpAndSettle();

    expect(
      find.textContaining('Backup rejected, no data changed'),
      findsOneWidget,
    );

    final kits = await repository.loadKits();
    expect(kits, hasLength(1));
    expect(kits.single.name, 'Weekend Kit');
  });

  testWidgets('delete-all only clears data after explicit confirmation', (
    tester,
  ) async {
    final repository = InMemoryKitCheckRepository();
    await seedKitAndTrip(tester, repository);
    await pumpApp(tester, repository);

    await tester.ensureVisible(find.byKey(const ValueKey('delete-all-button')));
    await tester.tap(find.byKey(const ValueKey('delete-all-button')));
    await tester.pumpAndSettle();
    expect(find.text('Delete all local data?'), findsOneWidget);

    // First pass: cancel keeps data.
    await tester.tap(find.widgetWithText(TextButton, 'Cancel'));
    await tester.pumpAndSettle();
    expect(await repository.loadKits(), hasLength(1));

    // Second pass: confirm deletes everything.
    await tester.tap(find.byKey(const ValueKey('delete-all-button')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('confirm-delete-all-button')));
    await tester.pumpAndSettle();

    expect(await repository.loadKits(), isEmpty);
    expect(await repository.loadTrips(), isEmpty);
    expect(find.text('All local data deleted.'), findsOneWidget);
  });
}
