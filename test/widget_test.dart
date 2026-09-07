import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kit_check/app/app_configuration.dart';
import 'package:kit_check/persistence/kit_check_repository.dart';
import 'package:kit_check/presentation/kit_check_app.dart';

void main() {
  testWidgets('app starts in local-only configuration', (tester) async {
    await tester.pumpWidget(
      KitCheckApp(
        configuration: const AppConfiguration.localOnly(),
        repository: InMemoryKitCheckRepository(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Kit Check'), findsOneWidget);
    expect(find.textContaining('Local-only mode: enabled'), findsOneWidget);
    expect(
      find.textContaining('Network requests allowed: false'),
      findsOneWidget,
    );
    expect(find.textContaining('Account required: false'), findsOneWidget);
  });

  testWidgets('accessible pack and return flow stays in one screen', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 2400);
    tester.view.devicePixelRatio = 1.0;

    final semantics = tester.ensureSemantics();

    try {
      await tester.pumpWidget(
        KitCheckApp(
          configuration: const AppConfiguration.localOnly(),
          repository: InMemoryKitCheckRepository(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.bySemanticsLabel('Add item to current kit'), findsOneWidget);
      expect(
        find.bySemanticsLabel('Create kit from draft items'),
        findsOneWidget,
      );

      await tester.enterText(
        find.byKey(const ValueKey('kit-name-field')),
        'Weekend Kit',
      );

      await tester.enterText(
        find.byKey(const ValueKey('item-name-field')),
        'Passport',
      );
      await tester.tap(find.byKey(const ValueKey('add-item-button')));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const ValueKey('item-name-field')),
        'Socks',
      );
      await tester.tap(find.byKey(const ValueKey('add-item-button')));
      await tester.pumpAndSettle();

      await tester.ensureVisible(
        find.byKey(const ValueKey('create-kit-button')),
      );
      await tester.tap(find.byKey(const ValueKey('create-kit-button')));
      await tester.pumpAndSettle();

      expect(find.text('Kit ready: Weekend Kit'), findsOneWidget);

      await tester.ensureVisible(find.byKey(const ValueKey('trip-name-field')));
      await tester.enterText(
        find.byKey(const ValueKey('trip-name-field')),
        'Seattle Weekend',
      );
      await tester.pump();
      await tester.ensureVisible(
        find.byKey(const ValueKey('start-trip-button')),
      );
      await tester.tap(find.byKey(const ValueKey('start-trip-button')));
      await tester.pumpAndSettle();

      expect(find.text('Trip: Seattle Weekend'), findsOneWidget);
      expect(find.text('Status: Pending'), findsNWidgets(2));

      await tester.ensureVisible(find.byKey(const ValueKey('pack-item-1')));
      await tester.tap(find.byKey(const ValueKey('pack-item-1')));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.byKey(const ValueKey('return-item-1')));
      await tester.tap(find.byKey(const ValueKey('return-item-1')));
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.byKey(const ValueKey('omit-item-2')));
      await tester.tap(find.byKey(const ValueKey('omit-item-2')));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const ValueKey('omission-note-field')),
        'Laundry not finished',
      );
      await tester.tap(find.byKey(const ValueKey('confirm-omit-button')));
      await tester.pumpAndSettle();

      expect(find.text('Unresolved items (1)'), findsOneWidget);
      expect(find.text('Socks — Omitted'), findsOneWidget);

      await tester.ensureVisible(find.byKey(const ValueKey('pack-item-2')));
      await tester.tap(find.byKey(const ValueKey('pack-item-2')));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.byKey(const ValueKey('return-item-2')));
      await tester.tap(find.byKey(const ValueKey('return-item-2')));
      await tester.pumpAndSettle();

      expect(find.text('Return progress: 2 / 2 returned'), findsOneWidget);
      expect(find.text('Unresolved items (0)'), findsOneWidget);
      expect(find.text('All items returned.'), findsOneWidget);
    } finally {
      semantics.dispose();
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    }
  });
}
