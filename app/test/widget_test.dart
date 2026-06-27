import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:sightour/app.dart';
import 'package:sightour/core/di/injection.dart';

class _FakePathProvider extends PathProviderPlatform with MockPlatformInterfaceMixin {
  @override
  Future<String?> getApplicationDocumentsPath() async => '.dart_test/app_docs_widget';
  @override
  Future<String?> getTemporaryPath() async => '.dart_test/tmp_widget';
}

void main() {
  setUpAll(() async {
    PathProviderPlatform.instance = _FakePathProvider();
    final testPath =
        '.dart_test/hive_widget_${DateTime.now().microsecondsSinceEpoch}';
    Hive.init(testPath);
    await Hive.openBox('prefs');
    await configureDependencies();
  });

  testWidgets('SightourApp launches with Prepare tab and Coming Soon content',
      (tester) async {
    await tester.pumpWidget(const SightourApp());
    await tester.pump();
    expect(find.text('Prepare · US'), findsOneWidget);
    expect(find.text('Coming soon'), findsOneWidget);
    expect(find.byType(BottomNavigationBar), findsOneWidget);
  });
}
