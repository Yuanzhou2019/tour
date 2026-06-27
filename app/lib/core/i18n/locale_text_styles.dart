import 'package:flutter/material.dart';

TextStyle textStyleForLocale(Locale locale, {required TextStyle base}) {
  final isZh = locale.languageCode == 'zh';
  return base.copyWith(
    fontFamily: isZh ? 'NotoSansSC' : 'Inter',
  );
}
