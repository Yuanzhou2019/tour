import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:sightour/core/i18n/locale_cubit.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class _FakePathProvider extends PathProviderPlatform with MockPlatformInterfaceMixin {
  @override
  Future<String?> getApplicationDocumentsPath() async => '.dart_test/app_docs';
  @override
  Future<String?> getTemporaryPath() async => '.dart_test/tmp';
}

void main() {
  setUpAll(() async {
    PathProviderPlatform.instance = _FakePathProvider();
    Hive.init('.dart_test/hive_locale');
  });

  setUp(() async {
    await Hive.deleteFromDisk();
  });

  test('default locale is en', () {
    final cubit = LocaleCubit();
    expect(cubit.state, const Locale('en'));
  });

  test('setLocale persists and emits', () async {
    final cubit = LocaleCubit();
    await cubit.setLocale(const Locale('zh'));
    expect(cubit.state, const Locale('zh'));
    final box = await Hive.openBox('prefs');
    expect(box.get('locale'), 'zh');
  });

  test('loadFromStorage reads persisted locale', () async {
    final box = await Hive.openBox('prefs');
    await box.put('locale', 'zh');
    final cubit = LocaleCubit();
    await cubit.loadFromStorage();
    expect(cubit.state, const Locale('zh'));
  });
}
