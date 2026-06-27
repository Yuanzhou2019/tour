import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sightour/features/onboarding/domain/entities/country.dart';
import 'package:sightour/features/onboarding/domain/entities/unit_system.dart';
import 'package:sightour/features/onboarding/presentation/cubit/first_run_settings_cubit.dart';

void main() {
  test('default state', () {
    final c = FirstRunSettingsCubit();
    expect(c.state.locale.languageCode, 'en');
    expect(c.state.themeMode, ThemeMode.system);
    expect(c.state.country, Country.us);
    expect(c.state.unitSystem, UnitSystem.metric);
  });

  test('setLocale emits', () {
    final c = FirstRunSettingsCubit();
    c.setLocale(const Locale('zh'));
    expect(c.state.locale, const Locale('zh'));
  });

  test('setTheme emits', () {
    final c = FirstRunSettingsCubit();
    c.setTheme(ThemeMode.dark);
    expect(c.state.themeMode, ThemeMode.dark);
  });

  test('setCountry emits', () {
    final c = FirstRunSettingsCubit();
    c.setCountry(Country.jp);
    expect(c.state.country, Country.jp);
  });

  test('setUnit emits', () {
    final c = FirstRunSettingsCubit();
    c.setUnit(UnitSystem.imperial);
    expect(c.state.unitSystem, UnitSystem.imperial);
  });
}
