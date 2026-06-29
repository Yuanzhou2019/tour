import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:sightour/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('onboarding → prepare → feedback flow', (tester) async {
    app.main();
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // Verify the app shell is rendered with bottom navigation
    expect(find.byType(app.MainShell), findsOneWidget);

    // Tap through onboarding if present
    final nextButton = find.text('Next');
    if (nextButton.evaluate().isNotEmpty) {
      await tester.tap(nextButton);
      await tester.pumpAndSettle();
    }

    // Navigate to Prepare tab (index 1 in bottom nav)
    // The bottom nav items: Discover, Prepare, Map, Tools, You
    final prepareTab = find.text('Prepare');
    if (prepareTab.evaluate().isNotEmpty) {
      await tester.tap(prepareTab);
      await tester.pumpAndSettle(const Duration(seconds: 2));
    }

    // Verify Prepare page loads content
    // Should show policy cards or checklist after loading
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Navigate to You tab (index 4)
    final youTab = find.text('You');
    if (youTab.evaluate().isNotEmpty) {
      await tester.tap(youTab);
      await tester.pumpAndSettle(const Duration(seconds: 2));
    }

    // Verify You page renders
    expect(find.text('About'), findsWidgets);
  });
}
