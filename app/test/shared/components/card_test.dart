import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sightour/shared/components/card.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: Center(child: child)));

  testWidgets('default card renders child', (tester) async {
    await tester.pumpWidget(
      wrap(const AppCard(child: Text('Default'))),
    );
    expect(find.text('Default'), findsOneWidget);
  });

  testWidgets('hero card variant renders child', (tester) async {
    await tester.pumpWidget(
      wrap(const AppCard(
        variant: AppCardVariant.hero,
        child: Text('Hero'),
      )),
    );
    expect(find.text('Hero'), findsOneWidget);
  });

  testWidgets('flat card variant renders child', (tester) async {
    await tester.pumpWidget(
      wrap(const AppCard(
        variant: AppCardVariant.flat,
        child: Text('Flat'),
      )),
    );
    expect(find.text('Flat'), findsOneWidget);
  });

  testWidgets('onTap fires callback', (tester) async {
    var tapped = false;
    await tester.pumpWidget(
      wrap(AppCard(
        onTap: () => tapped = true,
        child: const Text('Tap me'),
      )),
    );
    await tester.tap(find.text('Tap me'));
    expect(tapped, true);
  });
}