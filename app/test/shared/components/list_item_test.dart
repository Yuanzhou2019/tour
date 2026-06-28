import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sightour/shared/components/list_item.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: Center(child: child)));

  testWidgets('single-line list item', (tester) async {
    await tester.pumpWidget(
      wrap(const AppListItem(title: 'Title only')),
    );
    expect(find.text('Title only'), findsOneWidget);
  });

  testWidgets('two-line list item with subtitle', (tester) async {
    await tester.pumpWidget(
      wrap(const AppListItem(
        title: 'Title',
        subtitle: 'Subtitle text',
      )),
    );
    expect(find.text('Title'), findsOneWidget);
    expect(find.text('Subtitle text'), findsOneWidget);
  });

  testWidgets('three-line list item with leading and trailing', (tester) async {
    await tester.pumpWidget(
      wrap(AppListItem(
        title: 'Title',
        subtitle: 'Subtitle',
        leading: const Icon(Icons.download_outlined),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {},
      )),
    );
    expect(find.byIcon(Icons.download_outlined), findsOneWidget);
    expect(find.byIcon(Icons.chevron_right), findsOneWidget);
    expect(find.text('Title'), findsOneWidget);
    expect(find.text('Subtitle'), findsOneWidget);
  });
}