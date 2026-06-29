import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/country.dart';
import '../../domain/entities/entry_city.dart';
import '../../domain/entities/entry_reason.dart';
import '../../domain/entities/unit_system.dart';

class FirstRunSettingsState {
  const FirstRunSettingsState({
    this.locale = const Locale('en'),
    this.themeMode = ThemeMode.system,
    this.country = Country.us,
    this.unitSystem = UnitSystem.metric,
    this.entryReason = EntryReason.tourism,
    this.entryCity = EntryCity.shanghai,
  });
  final Locale locale;
  final ThemeMode themeMode;
  final Country country;
  final UnitSystem unitSystem;
  final EntryReason entryReason;
  final EntryCity entryCity;

  FirstRunSettingsState copyWith({
    Locale? locale,
    ThemeMode? themeMode,
    Country? country,
    UnitSystem? unitSystem,
    EntryReason? entryReason,
    EntryCity? entryCity,
  }) =>
      FirstRunSettingsState(
        locale: locale ?? this.locale,
        themeMode: themeMode ?? this.themeMode,
        country: country ?? this.country,
        unitSystem: unitSystem ?? this.unitSystem,
        entryReason: entryReason ?? this.entryReason,
        entryCity: entryCity ?? this.entryCity,
      );
}

@lazySingleton
class FirstRunSettingsCubit extends Cubit<FirstRunSettingsState> {
  FirstRunSettingsCubit() : super(const FirstRunSettingsState());
  void setLocale(Locale l) => emit(state.copyWith(locale: l));
  void setTheme(ThemeMode m) => emit(state.copyWith(themeMode: m));
  void setCountry(Country c) => emit(state.copyWith(country: c));
  void setUnit(UnitSystem u) => emit(state.copyWith(unitSystem: u));
  void setEntryReason(EntryReason r) => emit(state.copyWith(entryReason: r));
  void setEntryCity(EntryCity c) => emit(state.copyWith(entryCity: c));
}
