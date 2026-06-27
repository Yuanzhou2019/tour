import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sightour/core/theme/app_colors.dart';
import 'package:sightour/core/theme/app_theme.dart';

void main() {
  test('AppTheme.light builds', () {
    final theme = AppTheme.light();
    expect(theme.useMaterial3, true);
    expect(theme.brightness, Brightness.light);
    expect(theme.colorScheme.primary, AppColors.blue600);
  });

  test('AppTheme.dark builds', () {
    final theme = AppTheme.dark();
    expect(theme.useMaterial3, true);
    expect(theme.brightness, Brightness.dark);
  });
}
