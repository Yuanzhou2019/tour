import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/storage/hive_boxes.dart';
import '../../domain/entities/country.dart';
import '../../domain/entities/unit_system.dart';
import '../../domain/repositories/onboarding_repository.dart';

@LazySingleton(as: OnboardingRepository)
class OnboardingRepositoryImpl implements OnboardingRepository {
  static const _kCompleted = 'onboarding_completed';
  static const _kLocale = 'first_run_locale';
  static const _kTheme = 'first_run_theme';
  static const _kCountry = 'first_run_country';
  static const _kUnit = 'first_run_unit';

  Box get _box => Hive.box(HiveBoxes.prefs);

  @override
  bool isCompleted() => _box.get(_kCompleted, defaultValue: false) as bool;

  @override
  Future<void> markCompleted() => _box.put(_kCompleted, true);

  @override
  Future<void> markNotCompleted() => _box.put(_kCompleted, false);

  @override
  Future<FirstRunPreferences> loadFirstRunPreferences() async {
    final localeCode = _box.get(_kLocale, defaultValue: 'en') as String;
    final themeName =
        _box.get(_kTheme, defaultValue: ThemeMode.system.name) as String;
    final countryIso =
        _box.get(_kCountry, defaultValue: Country.us.iso2) as String;
    final unitName =
        _box.get(_kUnit, defaultValue: UnitSystem.metric.name) as String;
    return FirstRunPreferences(
      locale: Locale(localeCode),
      themeMode: ThemeMode.values.byName(themeName),
      country: Country.values.firstWhere(
        (c) => c.iso2 == countryIso,
        orElse: () => Country.us,
      ),
      unitSystem: UnitSystem.values.byName(unitName),
    );
  }

  @override
  Future<void> saveFirstRunPreferences(FirstRunPreferences prefs) async {
    await _box.put(_kLocale, prefs.locale.languageCode);
    await _box.put(_kTheme, prefs.themeMode.name);
    await _box.put(_kCountry, prefs.country.iso2);
    await _box.put(_kUnit, prefs.unitSystem.name);
  }
}
