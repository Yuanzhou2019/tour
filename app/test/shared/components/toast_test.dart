import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sightour/shared/components/toast.dart';

void main() {
  testWidgets('showAppToast does not throw and shows a SnackBar', (tester) async {
    late BuildContext captured;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(builder: (ctx) {
            captured = ctx;
            return const SizedBox.shrink();
          }),
        ),
      ),
    );
    expect(() => showAppToast(captured, message: 'Hello'), returnsNormally);
    await tester.pump();
    expect(find.text('Hello'), findsOneWidget);
  });
}