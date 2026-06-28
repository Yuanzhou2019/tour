import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sightour/shared/components/chip.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: Center(child: child)));

  testWidgets('unselected chip renders label', (tester) async {
    await tester.pumpWidget(wrap(const AppChip(label: 'All')));
    expect(find.text('All'), findsOneWidget);
  });

  testWidgets('selected chip renders label and triggers onTap', (tester) async {
    var tapped = false;
    await tester.pumpWidget(wrap(AppChip(
      label: 'Eat',
      selected: true,
      onTap: () => tapped = true,
    )));
    expect(find.text('Eat'), findsOneWidget);
    await tester.tap(find.text('Eat'));
    expect(tapped, true);
  });

  testWidgets('chip with leading icon shows icon', (tester) async {
    await tester.pumpWidget(wrap(const AppChip(
      label: 'Hot',
      leadingIcon: Icons.local_fire_department,
    )));
    expect(find.byIcon(Icons.local_fire_department), findsOneWidget);
  });
}