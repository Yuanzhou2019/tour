import 'package:flutter/material.dart';
import '../entities/country.dart';
import '../entities/unit_system.dart';

class FirstRunPreferences {
  const FirstRunPreferences({
    required this.locale,
    required this.themeMode,
    required this.country,
    required this.unitSystem,
  });
  final Locale locale;
  final ThemeMode themeMode;
  final Country country;
  final UnitSystem unitSystem;
}

abstract class OnboardingRepository {
  bool isCompleted();
  Future<void> markCompleted();
  Future<void> markNotCompleted(); // for testing
  Future<FirstRunPreferences> loadFirstRunPreferences();
  Future<void> saveFirstRunPreferences(FirstRunPreferences prefs);
}
