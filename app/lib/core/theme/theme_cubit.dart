import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce/hive.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.system);

  static const _boxName = 'prefs';
  static const _key = 'themeMode';

  Future<void> loadFromStorage() async {
    final box = await Hive.openBox(_boxName);
    final name = box.get(_key, defaultValue: ThemeMode.system.name) as String;
    emit(ThemeMode.values.byName(name));
  }

  Future<void> setMode(ThemeMode mode) async {
    final box = await Hive.openBox(_boxName);
    await box.put(_key, mode.name);
    emit(mode);
  }
}
