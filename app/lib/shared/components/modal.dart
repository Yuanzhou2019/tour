import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';

/// Helper that shows a bottom sheet styled with Sightour tokens.
Future<T?> showAppModal<T>({
  required BuildContext context,
  required Widget child,
  bool scrollable = true,
}) {
  return showModalBottomSheet<T>(
    context: context,
    backgroundColor: AppColors.white,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
    ),
    builder: (_) => SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.s4),
        child: scrollable ? SingleChildScrollView(child: child) : child,
      ),
    ),
  );
}