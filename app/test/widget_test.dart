import 'package:flutter_test/flutter_test.dart';
import 'package:sightour/app.dart';

void main() {
  testWidgets('SightourApp renders scaffold ready text on home route',
      (WidgetTester tester) async {
    await tester.pumpWidget(const SightourApp());
    await tester.pump(); // Let FutureBuilder complete
    expect(find.text('Sightour scaffold ready'), findsOneWidget);
  });
}
