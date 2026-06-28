import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

/// Shows a transient toast at the bottom of the screen using Sightour tokens.
void showAppToast(BuildContext context, {required String message}) {
  final messenger = ScaffoldMessenger.of(context);
  messenger.removeCurrentSnackBar();
  messenger.showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: AppTextTheme.textTheme.bodyMedium?.copyWith(
          color: AppColors.white,
        ),
      ),
      backgroundColor: AppColors.slate900,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(AppSpacing.s4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      duration: const Duration(seconds: 2),
    ),
  );
}

/// Convenience: `context.showAppToast(message: 'hi')`.
extension AppToastContext on BuildContext {
  void showAppToast({required String message}) {
    final messenger = ScaffoldMessenger.of(this);
    messenger.removeCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: AppTextTheme.textTheme.bodyMedium?.copyWith(
            color: AppColors.white,
          ),
        ),
        backgroundColor: AppColors.slate900,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(AppSpacing.s4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}