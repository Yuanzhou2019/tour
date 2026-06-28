import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sightour/shared/components/progress_bar.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

  testWidgets('progress bar renders determinate value', (tester) async {
    await tester.pumpWidget(
      wrap(const AppProgressBar(value: 0.6)),
    );
    final indicator = tester.widget<LinearProgressIndicator>(
      find.byType(LinearProgressIndicator),
    );
    expect(indicator.value, 0.6);
  });

  testWidgets('progress bar renders indeterminate', (tester) async {
    await tester.pumpWidget(
      wrap(const AppProgressBar(indeterminate: true)),
    );
    final indicator = tester.widget<LinearProgressIndicator>(
      find.byType(LinearProgressIndicator),
    );
    expect(indicator.value, isNull);
  });
}