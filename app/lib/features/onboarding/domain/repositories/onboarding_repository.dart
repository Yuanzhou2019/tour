import 'package:flutter/material.dart';
import '../entities/country.dart';
import '../entities/entry_city.dart';
import '../entities/entry_reason.dart';
import '../entities/unit_system.dart';

class FirstRunPreferences {
  const FirstRunPreferences({
    required this.locale,
    required this.themeMode,
    required this.country,
    required this.unitSystem,
    required this.entryReason,
    required this.entryCity,
  });
  final Locale locale;
  final ThemeMode themeMode;
  final Country country;
  final UnitSystem unitSystem;
  final EntryReason entryReason;
  final EntryCity entryCity;
}

abstract class OnboardingRepository {
  bool isCompleted();
  Future<void> markCompleted();
  Future<void> markNotCompleted(); // for testing
  Future<FirstRunPreferences> loadFirstRunPreferences();
  Future<void> saveFirstRunPreferences(FirstRunPreferences prefs);
}
