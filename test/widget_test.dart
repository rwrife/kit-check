import 'package:flutter_test/flutter_test.dart';
import 'package:kit_check/app/app_configuration.dart';
import 'package:kit_check/presentation/kit_check_app.dart';

void main() {
  testWidgets('app starts in local-only configuration', (tester) async {
    await tester.pumpWidget(
      const KitCheckApp(configuration: AppConfiguration.localOnly()),
    );

    expect(find.text('Kit Check'), findsOneWidget);
    expect(find.textContaining('Local-only mode: enabled'), findsOneWidget);
    expect(
      find.textContaining('Network requests allowed: false'),
      findsOneWidget,
    );
    expect(find.textContaining('Account required: false'), findsOneWidget);
  });
}
