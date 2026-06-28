import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sightour/shared/components/input.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

  testWidgets('input renders placeholder and accepts text', (tester) async {
    final controller = TextEditingController();
    await tester.pumpWidget(
      wrap(AppInput(controller: controller, placeholder: 'Type here')),
    );
    expect(find.text('Type here'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'hello');
    await tester.pump();
    expect(controller.text, 'hello');
  });

  testWidgets('input shows error message when provided', (tester) async {
    await tester.pumpWidget(
      wrap(const AppInput(placeholder: 'Email', error: 'Required')),
    );
    expect(find.text('Required'), findsOneWidget);
  });

  testWidgets('input enforces maxLength', (tester) async {
    final controller = TextEditingController();
    await tester.pumpWidget(
      wrap(AppInput(controller: controller, maxLength: 5)),
    );
    await tester.enterText(find.byType(TextField), 'abcdef');
    await tester.pump();
    expect(controller.text.length, lessThanOrEqualTo(5));
  });
}