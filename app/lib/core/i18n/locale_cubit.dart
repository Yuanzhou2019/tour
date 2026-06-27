import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce/hive.dart';

class LocaleCubit extends Cubit<Locale> {
  LocaleCubit() : super(const Locale('en'));

  static const _boxName = 'prefs';
  static const _key = 'locale';
  static const _defaultLocale = Locale('en');

  Future<void> loadFromStorage() async {
    final box = await Hive.openBox(_boxName);
    final code = box.get(_key, defaultValue: _defaultLocale.languageCode) as String;
    emit(Locale(code));
  }

  Future<void> setLocale(Locale locale) async {
    final box = await Hive.openBox(_boxName);
    await box.put(_key, locale.languageCode);
    emit(locale);
  }
}
