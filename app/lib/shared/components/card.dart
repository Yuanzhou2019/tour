import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_shadow.dart';
import '../../core/theme/app_spacing.dart';

enum AppCardVariant { defaultCard, hero, flat }

class AppCard extends StatelessWidget {
  const AppCard({
    required this.child,
    this.variant = AppCardVariant.defaultCard,
    this.onTap,
    this.padding = const EdgeInsets.all(AppSpacing.s4),
    super.key,
  });

  final Widget child;
  final AppCardVariant variant;
  final VoidCallback? onTap;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(
      variant == AppCardVariant.hero ? AppRadius.xl : AppRadius.lg,
    );
    final decoration = switch (variant) {
      AppCardVariant.defaultCard => BoxDecoration(
          color: AppColors.white,
          borderRadius: radius,
          border: Border.all(color: AppColors.slate200),
          boxShadow: AppShadow.shadow1,
        ),
      AppCardVariant.hero => BoxDecoration(
          color: AppColors.white,
          borderRadius: radius,
          border: Border.all(color: AppColors.slate200),
          boxShadow: AppShadow.shadow2,
        ),
      AppCardVariant.flat => BoxDecoration(
          color: AppColors.slate50,
          borderRadius: radius,
        ),
    };
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: Ink(
          decoration: decoration,
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}