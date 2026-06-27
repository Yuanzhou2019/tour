import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_radius.dart';
import 'app_text_styles.dart';

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
      textTheme: AppTextTheme.textTheme,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.ivory,
        foregroundColor: AppColors.slate900,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: const CardThemeData(
        color: AppColors.white,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppRadius.lg)),
          side: BorderSide(color: AppColors.slate200),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.slate100,
        labelStyle: AppTextTheme.textTheme.labelMedium,
        side: BorderSide.none,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.full),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.white,
        selectedItemColor: AppColors.blue600,
        unselectedItemColor: AppColors.slate500,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.slate200,
        space: 1,
        thickness: 1,
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
      scaffoldBackgroundColor: AppColors.slate900,
      textTheme: AppTextTheme.textTheme.apply(
        bodyColor: AppColors.ivory,
        displayColor: AppColors.ivory,
      ),
    );
  }
}
