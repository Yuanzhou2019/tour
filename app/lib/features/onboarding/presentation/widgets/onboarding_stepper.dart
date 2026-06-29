import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

class OnboardingStepper extends StatelessWidget {
  const OnboardingStepper({
    required this.count,
    required this.current,
    this.labels = const ['Welcome', 'Features', 'Setup', 'Privacy'],
    super.key,
  });

  final int count;
  final int current;
  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s6),
      child: Column(
        children: [
          Row(
            children: List.generate(count, (i) {
              final isLast = i == count - 1;
              return Expanded(
                child: Row(
                  children: [
                    _StepCircle(
                      index: i,
                      current: current,
                      size: i == current ? 14 : 10,
                    ),
                    if (!isLast)
                      Expanded(
                        child: _StepLine(
                          active: i < current,
                          current: i == current,
                        ),
                      ),
                  ],
                ),
              );
            }),
          ),
          const SizedBox(height: AppSpacing.s1),
          Row(
            children: List.generate(count, (i) {
              return Expanded(
                child: Text(
                  i < labels.length ? labels[i] : '',
                  textAlign: TextAlign.center,
                  style: AppTextTheme.textTheme.labelSmall?.copyWith(
                    color: i == current
                        ? AppColors.warmPrimaryDark
                        : i < current
                            ? AppColors.slate500
                            : AppColors.slate300,
                    fontWeight: i >= current ? FontWeight.w600 : FontWeight.w400,
                    fontSize: 10,
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _StepCircle extends StatelessWidget {
  const _StepCircle({
    required this.index,
    required this.current,
    required this.size,
  });

  final int index;
  final int current;
  final double size;

  @override
  Widget build(BuildContext context) {
    if (index < current) {
      // Completed
      return Container(
        width: 24,
        height: 24,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.warmPrimary,
        ),
        child: const Icon(Icons.check, color: AppColors.white, size: 14),
      );
    }
    if (index == current) {
      // Current
      return Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.warmPrimary,
          boxShadow: [
            BoxShadow(
              color: AppColors.warmPrimary.withValues(alpha: 0.4),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Center(
          child: Text(
            '${index + 1}',
            style: AppTextTheme.textTheme.labelMedium?.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );
    }
    // Pending
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.slate300, width: 2),
      ),
    );
  }
}

class _StepLine extends StatelessWidget {
  const _StepLine({required this.active, required this.current});

  final bool active;
  final bool current;

  @override
  Widget build(BuildContext context) {
    final color = active
        ? AppColors.warmSecondary
        : current
            ? AppColors.warmSecondary
            : AppColors.slate200;
    return Container(
      height: 2,
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.s1),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
    );
  }
}
