import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sightour/shared/components/toggle.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: Center(child: child)));

  testWidgets('toggle starts in off state', (tester) async {
    await tester.pumpWidget(
      wrap(AppToggle(value: false, onChanged: (_) {})),
    );
    final sw = tester.widget<Switch>(find.byType(Switch));
    expect(sw.value, false);
  });

  testWidgets('toggle fires onChanged when tapped', (tester) async {
    bool? latest;
    await tester.pumpWidget(
      wrap(AppToggle(value: false, onChanged: (v) => latest = v)),
    );
    await tester.tap(find.byType(Switch));
    expect(latest, true);
  });
}