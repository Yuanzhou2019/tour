import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

class AppInput extends StatelessWidget {
  const AppInput({
    this.controller,
    this.placeholder,
    this.label,
    this.error,
    this.maxLength,
    this.onChanged,
    this.obscureText = false,
    this.keyboardType,
    super.key,
  });

  final TextEditingController? controller;
  final String? placeholder;
  final String? label;
  final String? error;
  final int? maxLength;
  final ValueChanged<String>? onChanged;
  final bool obscureText;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    final hasError = error != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: AppTextTheme.textTheme.titleSmall?.copyWith(
              color: AppColors.slate700,
            ),
          ),
          const SizedBox(height: AppSpacing.s1),
        ],
        TextField(
          controller: controller,
          obscureText: obscureText,
          maxLength: maxLength,
          keyboardType: keyboardType,
          onChanged: onChanged,
          style: AppTextTheme.textTheme.bodyLarge?.copyWith(
            color: AppColors.slate900,
          ),
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: AppTextTheme.textTheme.bodyLarge?.copyWith(
              color: AppColors.slate500,
            ),
            filled: true,
            fillColor: AppColors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.s3,
              vertical: AppSpacing.s3,
            ),
            counterText: '',
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: BorderSide(
                color: hasError ? AppColors.clay600 : AppColors.slate200,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: BorderSide(
                color: hasError ? AppColors.clay600 : AppColors.blue600,
                width: 1.5,
              ),
            ),
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: AppSpacing.s1),
          Text(
            error!,
            style: AppTextTheme.textTheme.bodySmall?.copyWith(
              color: AppColors.clay600,
            ),
          ),
        ],
      ],
    );
  }
}