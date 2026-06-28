import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';

class AppProgressBar extends StatelessWidget {
  const AppProgressBar({
    this.value,
    this.indeterminate = false,
    super.key,
  });

  /// Progress in [0.0, 1.0]. Ignored when [indeterminate] is true.
  final double? value;
  final bool indeterminate;

  @override
  Widget build(BuildContext context) {
    if (indeterminate) {
      return const SizedBox(
        height: 4,
        child: LinearProgressIndicator(
          backgroundColor: AppColors.slate200,
          valueColor: AlwaysStoppedAnimation(AppColors.blue600),
        ),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.full),
      child: SizedBox(
        height: 6,
        child: LinearProgressIndicator(
          value: value == null ? null : value!.clamp(0.0, 1.0).toDouble(),
          backgroundColor: AppColors.slate200,
          valueColor: const AlwaysStoppedAnimation(AppColors.blue600),
        ),
      ),
    );
  }
}