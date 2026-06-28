import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

class AppSearchBar extends StatelessWidget {
  const AppSearchBar({
    this.controller,
    this.placeholder,
    this.onChanged,
    this.onSubmitted,
    this.onCancel,
    super.key,
  });

  final TextEditingController? controller;
  final String? placeholder;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.slate100,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.s3),
            child: Icon(Icons.search, color: AppColors.slate500, size: 20),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              onSubmitted: onSubmitted,
              textInputAction: TextInputAction.search,
              style: AppTextTheme.textTheme.bodyLarge?.copyWith(
                color: AppColors.slate900,
              ),
              decoration: InputDecoration(
                hintText: placeholder,
                hintStyle: AppTextTheme.textTheme.bodyLarge?.copyWith(
                  color: AppColors.slate500,
                ),
                border: InputBorder.none,
                isCollapsed: true,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: AppSpacing.s3,
                ),
              ),
            ),
          ),
          if (onCancel != null)
            TextButton(
              onPressed: onCancel,
              child: Text(
                'Cancel',
                style: AppTextTheme.textTheme.labelMedium?.copyWith(
                  color: AppColors.blue600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}