import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sightour/shared/components/search_bar.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

  testWidgets('search bar renders placeholder and accepts input', (tester) async {
    final controller = TextEditingController();
    await tester.pumpWidget(
      wrap(AppSearchBar(controller: controller, placeholder: 'Search')),
    );
    expect(find.text('Search'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'noodle');
    await tester.pump();
    expect(controller.text, 'noodle');
  });

  testWidgets('search bar cancel button triggers callback', (tester) async {
    var cancelled = false;
    await tester.pumpWidget(
      wrap(AppSearchBar(
        placeholder: 'Search',
        onCancel: () => cancelled = true,
      )),
    );
    await tester.tap(find.text('Cancel'));
    expect(cancelled, true);
  });
}