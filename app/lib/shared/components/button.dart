import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

enum ButtonVariant { primary, secondary, ghost, destructive }

enum ButtonSize { sm, md, lg }

class AppButton extends StatelessWidget {
  const AppButton({
    required this.label,
    required this.onPressed,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.md,
    this.loading = false,
    this.leadingIcon,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final ButtonSize size;
  final bool loading;
  final IconData? leadingIcon;

  @override
  Widget build(BuildContext context) {
    final disabled = onPressed == null;
    final sizeH = switch (size) {
      ButtonSize.sm => 32.0,
      ButtonSize.lg => 52.0,
      ButtonSize.md => 44.0,
    };
    final bg = switch (variant) {
      ButtonVariant.primary => disabled ? AppColors.slate100 : AppColors.slate900,
      ButtonVariant.secondary => AppColors.slate100,
      ButtonVariant.ghost => Colors.transparent,
      ButtonVariant.destructive => disabled ? AppColors.slate100 : AppColors.clay600,
    };
    final fg = switch (variant) {
      ButtonVariant.primary => AppColors.white,
      ButtonVariant.secondary => AppColors.slate700,
      ButtonVariant.ghost => AppColors.blue600,
      ButtonVariant.destructive => AppColors.white,
    };
    return SizedBox(
      height: sizeH,
      child: ElevatedButton(
        onPressed: loading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: fg,
          disabledBackgroundColor: bg,
          disabledForegroundColor: fg,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          padding: size == ButtonSize.sm
              ? const EdgeInsets.symmetric(horizontal: AppSpacing.s3)
              : size == ButtonSize.lg
                  ? const EdgeInsets.symmetric(horizontal: AppSpacing.s6)
                  : const EdgeInsets.symmetric(horizontal: AppSpacing.s4),
        ),
        child: loading
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.white,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (leadingIcon != null) ...[
                    Icon(leadingIcon, size: 18, color: fg),
                    const SizedBox(width: AppSpacing.s2),
                  ],
                  Text(
                    label,
                    style: AppTextTheme.textTheme.bodyLarge?.copyWith(
                      color: fg,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}