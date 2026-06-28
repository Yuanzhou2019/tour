import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class AppToggle extends StatelessWidget {
  const AppToggle({
    required this.value,
    required this.onChanged,
    super.key,
  });

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: value,
      onChanged: onChanged,
      activeThumbColor: AppColors.white,
      activeTrackColor: AppColors.blue600,
      inactiveTrackColor: AppColors.slate200,
      inactiveThumbColor: AppColors.white,
    );
  }
}