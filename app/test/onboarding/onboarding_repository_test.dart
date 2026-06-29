import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:sightour/core/storage/hive_boxes.dart';
import 'package:sightour/features/onboarding/data/repositories/onboarding_repository_impl.dart';
import 'package:sightour/features/onboarding/domain/entities/country.dart';
import 'package:sightour/features/onboarding/domain/entities/entry_city.dart';
import 'package:sightour/features/onboarding/domain/entities/entry_reason.dart';
import 'package:sightour/features/onboarding/domain/entities/unit_system.dart';
import 'package:sightour/features/onboarding/domain/repositories/onboarding_repository.dart';

class _FakePathProvider extends PathProviderPlatform with MockPlatformInterfaceMixin {
  @override
  Future<String?> getApplicationDocumentsPath() async =>
      '.dart_test/app_docs_onboarding';
}

void main() {
  setUpAll(() {
    PathProviderPlatform.instance = _FakePathProvider();
  });

  setUp(() async {
    final p = '.dart_test/hive_onboarding_${DateTime.now().microsecondsSinceEpoch}';
    Hive.init(p);
    await Hive.openBox(HiveBoxes.prefs);
  });

  tearDown(() async {
    if (Hive.isBoxOpen(HiveBoxes.prefs)) {
      await Hive.box(HiveBoxes.prefs).close();
    }
  });

  test('isCompleted defaults to false', () {
    final repo = OnboardingRepositoryImpl();
    expect(repo.isCompleted(), false);
  });

  test('markCompleted then isCompleted returns true', () async {
    final repo = OnboardingRepositoryImpl();
    await repo.markCompleted();
    expect(repo.isCompleted(), true);
  });

  test('markNotCompleted then isCompleted returns false', () async {
    final repo = OnboardingRepositoryImpl();
    await repo.markCompleted();
    await repo.markNotCompleted();
    expect(repo.isCompleted(), false);
  });

  test('save + load FirstRunPreferences roundtrip', () async {
    final repo = OnboardingRepositoryImpl();
    const original = FirstRunPreferences(
      locale: Locale('zh'),
      themeMode: ThemeMode.dark,
      country: Country.jp,
      unitSystem: UnitSystem.imperial,
      entryReason: EntryReason.education,
      entryCity: EntryCity.beijing,
    );
    await repo.saveFirstRunPreferences(original);
    final loaded = await repo.loadFirstRunPreferences();
    expect(loaded.locale, const Locale('zh'));
    expect(loaded.themeMode, ThemeMode.dark);
    expect(loaded.country, Country.jp);
    expect(loaded.unitSystem, UnitSystem.imperial);
    expect(loaded.entryReason, EntryReason.education);
    expect(loaded.entryCity, EntryCity.beijing);
  });

  test('loadFirstRunPreferences defaults when empty', () async {
    final repo = OnboardingRepositoryImpl();
    final loaded = await repo.loadFirstRunPreferences();
    expect(loaded.locale.languageCode, 'en');
    expect(loaded.themeMode, ThemeMode.system);
    expect(loaded.country, Country.us);
    expect(loaded.unitSystem, UnitSystem.metric);
    expect(loaded.entryReason, EntryReason.tourism);
    expect(loaded.entryCity, EntryCity.shanghai);
  });

  test('loadFirstRunPreferences recovers EntryCity.other', () async {
    final repo = OnboardingRepositoryImpl();
    await repo.saveFirstRunPreferences(
      const FirstRunPreferences(
        locale: Locale('en'),
        themeMode: ThemeMode.system,
        country: Country.us,
        unitSystem: UnitSystem.metric,
        entryReason: EntryReason.business,
        entryCity: EntryCity.other,
      ),
    );
    final loaded = await repo.loadFirstRunPreferences();
    expect(loaded.entryCity, EntryCity.other);
  });
}
