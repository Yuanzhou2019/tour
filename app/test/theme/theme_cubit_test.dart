import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:sightour/core/theme/theme_cubit.dart';

class _FakePathProvider extends PathProviderPlatform with MockPlatformInterfaceMixin {
  @override
  Future<String?> getApplicationDocumentsPath() async => '.dart_test/app_docs_theme';
}

void main() {
  setUpAll(() async {
    PathProviderPlatform.instance = _FakePathProvider();
    Hive.init('.dart_test/hive_theme');
  });

  setUp(() async {
    await Hive.deleteFromDisk();
  });

  test('default is ThemeMode.system', () {
    final cubit = ThemeCubit();
    expect(cubit.state, ThemeMode.system);
  });

  test('setMode persists and emits', () async {
    final cubit = ThemeCubit();
    await cubit.setMode(ThemeMode.dark);
    expect(cubit.state, ThemeMode.dark);
    final box = await Hive.openBox('prefs');
    expect(box.get('themeMode'), 'dark');
  });
}
