import 'package:flutter/material.dart';

/// Design tokens — see [Architecture Spec §9.2](https://example.com).
class AppColors {
  AppColors._();

  static const Color slate900 = Color(0xFF1A2332);
  static const Color slate700 = Color(0xFF374151);
  static const Color slate500 = Color(0xFF6B7280);
  static const Color slate200 = Color(0xFFE2E8F0);
  static const Color slate100 = Color(0xFFF1F5F9);
  static const Color slate50 = Color(0xFFF8FAFC);

  static const Color blue600 = Color(0xFF2A4365);
  static const Color blue50 = Color(0xFFEEF2F7);

  static const Color sand500 = Color(0xFFD4A574);
  static const Color sand50 = Color(0xFFFAF3E7);

  static const Color sage600 = Color(0xFF5B8C5A);
  static const Color sage50 = Color(0xFFEEF5EC);

  static const Color amber500 = Color(0xFFD97706);
  static const Color amber50 = Color(0xFFFEF3E2);

  static const Color clay600 = Color(0xFFC2410C);
  static const Color clay50 = Color(0xFFFDF0E8);

  static const Color ivory = Color(0xFFFAFAF7);
  static const Color white = Color(0xFFFFFFFF);
}

class AppTheme {
  AppTheme._();

  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: AppColors.blue600,
        onPrimary: AppColors.white,
        secondary: AppColors.sand500,
        onSecondary: AppColors.slate900,
        surface: AppColors.ivory,
        onSurface: AppColors.slate900,
        error: AppColors.clay600,
        onError: AppColors.white,
      ),
      scaffoldBackgroundColor: AppColors.ivory,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.ivory,
        foregroundColor: AppColors.slate900,
        elevation: 0,
        centerTitle: false,
      ),
    );
  }

  static ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.sand500,
        onPrimary: AppColors.slate900,
        secondary: AppColors.blue600,
        onSecondary: AppColors.white,
        surface: AppColors.slate900,
        onSurface: AppColors.ivory,
        error: AppColors.clay600,
        onError: AppColors.white,
      ),
    );
  }
}
