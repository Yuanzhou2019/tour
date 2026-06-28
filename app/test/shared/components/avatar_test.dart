import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sightour/shared/components/avatar.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: Center(child: child)));

  testWidgets('avatar renders initials when no image is provided', (tester) async {
    await tester.pumpWidget(
      wrap(const AppAvatar(initials: 'JD')),
    );
    expect(find.text('J'), findsOneWidget);
  });

  testWidgets('avatar falls back to initials when image fails', (tester) async {
    await tester.pumpWidget(
      wrap(const AppAvatar(
        imageUrl: 'https://example.com/nope.png',
        initials: 'AB',
      )),
    );
    // ErrorBuilder returns initials view; pump frames to allow async resolution.
    await tester.pump(const Duration(milliseconds: 50));
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.text('A'), findsOneWidget);
  });

  testWidgets('avatar renders different sizes', (tester) async {
    await tester.pumpWidget(
      wrap(const AppAvatar(initials: 'X', size: AvatarSize.lg)),
    );
    final container = tester.widget<Container>(find.byType(Container).first);
    // Container stores width in constraints (when set via width:) or as BoxConstraints
    final minWidth = container.constraints?.minWidth ?? 0;
    expect(minWidth, 56);
  });
}