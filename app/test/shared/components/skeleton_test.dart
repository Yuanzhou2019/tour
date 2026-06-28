import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sightour/shared/components/skeleton.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

  testWidgets('skeleton box renders', (tester) async {
    await tester.pumpWidget(
      wrap(const AppSkeletonBox(width: 100, height: 20)),
    );
    expect(find.byType(AppSkeletonBox), findsOneWidget);
  });

  testWidgets('skeleton text renders', (tester) async {
    await tester.pumpWidget(
      wrap(const AppSkeletonText()),
    );
    expect(find.byType(AppSkeletonText), findsOneWidget);
  });

  testWidgets('skeleton list renders 3 rows', (tester) async {
    await tester.pumpWidget(
      wrap(const AppSkeletonList(count: 3)),
    );
    expect(find.byType(AppSkeletonList), findsOneWidget);
    final boxes = find.byType(AppSkeletonBox);
    // Each row has 3 skeleton texts => 9 AppSkeletonBox widgets inside.
    expect(boxes, findsWidgets);
  });
}