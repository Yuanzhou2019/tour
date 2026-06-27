import 'package:flutter/material.dart';

class AppTextTheme {
  AppTextTheme._();

  static const TextTheme textTheme = TextTheme(
    displayLarge: TextStyle(fontSize: 48, height: 1.16, fontWeight: FontWeight.w700),
    displayMedium: TextStyle(fontSize: 36, height: 1.22, fontWeight: FontWeight.w700),
    displaySmall: TextStyle(fontSize: 28, height: 1.28, fontWeight: FontWeight.w700),
    headlineLarge: TextStyle(fontSize: 24, height: 1.33, fontWeight: FontWeight.w700),
    headlineMedium: TextStyle(fontSize: 20, height: 1.4, fontWeight: FontWeight.w600),
    headlineSmall: TextStyle(fontSize: 18, height: 1.44, fontWeight: FontWeight.w600),
    titleLarge: TextStyle(fontSize: 17, height: 1.5, fontWeight: FontWeight.w600),
    titleMedium: TextStyle(fontSize: 15, height: 1.6, fontWeight: FontWeight.w500),
    titleSmall: TextStyle(fontSize: 13, height: 1.7, fontWeight: FontWeight.w500),
    bodyLarge: TextStyle(fontSize: 16, height: 1.5, fontWeight: FontWeight.w400),
    bodyMedium: TextStyle(fontSize: 14, height: 1.57, fontWeight: FontWeight.w400),
    bodySmall: TextStyle(fontSize: 12, height: 1.66, fontWeight: FontWeight.w400),
    labelLarge: TextStyle(fontSize: 14, height: 1.43, fontWeight: FontWeight.w500),
    labelMedium: TextStyle(fontSize: 12, height: 1.5, fontWeight: FontWeight.w500),
    labelSmall: TextStyle(fontSize: 11, height: 1.45, fontWeight: FontWeight.w500),
  );
}
