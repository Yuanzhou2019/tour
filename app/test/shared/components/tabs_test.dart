import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sightour/shared/components/tabs.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: Center(child: child)));

  testWidgets('segmented tabs renders all tab labels', (tester) async {
    await tester.pumpWidget(
      wrap(AppSegmentedTab<String>(
        tabs: const [
          ('curated', 'Curated'),
          ('authentic', 'Authentic'),
          ('heads', 'Heads-up'),
        ],
        value: 'curated',
        onChanged: (_) {},
      )),
    );
    expect(find.text('Curated'), findsOneWidget);
    expect(find.text('Authentic'), findsOneWidget);
    expect(find.text('Heads-up'), findsOneWidget);
  });

  testWidgets('segmented tabs onChanged fires when tapping another tab', (tester) async {
    String selected = 'a';
    await tester.pumpWidget(
      wrap(AppSegmentedTab<String>(
        tabs: const [
          ('a', 'A'),
          ('b', 'B'),
        ],
        value: selected,
        onChanged: (v) => selected = v,
      )),
    );
    await tester.tap(find.text('B'));
    expect(selected, 'b');
  });
}