import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sightour/shared/components/button.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: Center(child: child)));

  testWidgets('primary button renders label and is tappable', (tester) async {
    var tapped = false;
    await tester.pumpWidget(wrap(AppButton(label: 'Continue', onPressed: () => tapped = true)));
    expect(find.text('Continue'), findsOneWidget);
    await tester.tap(find.text('Continue'));
    expect(tapped, true);
  });

  testWidgets('disabled button does not invoke onPressed', (tester) async {
    final tapped = <bool>[false];
    await tester.pumpWidget(wrap(const AppButton(label: 'Continue', onPressed: null)));
    await tester.tap(find.text('Continue'));
    expect(tapped[0], false);
  });

  testWidgets('loading shows spinner instead of label', (tester) async {
    await tester.pumpWidget(
      wrap(AppButton(label: 'Send', onPressed: () {}, loading: true)),
    );
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Send'), findsNothing);
  });

  testWidgets('renders with leading icon', (tester) async {
    await tester.pumpWidget(
      wrap(AppButton(label: 'Send', onPressed: () {}, leadingIcon: Icons.send)),
    );
    expect(find.byIcon(Icons.send), findsOneWidget);
    expect(find.text('Send'), findsOneWidget);
  });
}