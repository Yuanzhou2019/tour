import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';

/// Animated placeholder block.
class AppSkeletonBox extends StatefulWidget {
  const AppSkeletonBox({
    this.width,
    this.height = 16,
    this.radius = AppRadius.sm,
    super.key,
  });

  final double? width;
  final double height;
  final double radius;

  @override
  State<AppSkeletonBox> createState() => _AppSkeletonBoxState();
}

class _AppSkeletonBoxState extends State<AppSkeletonBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) {
        final v = 0.6 + 0.4 * _ctrl.value;
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: AppColors.slate200.withValues(alpha: v),
            borderRadius: BorderRadius.circular(widget.radius),
          ),
        );
      },
    );
  }
}

/// Text-shaped skeleton line.
class AppSkeletonText extends StatelessWidget {
  const AppSkeletonText({this.width = double.infinity, super.key});
  final double width;

  @override
  Widget build(BuildContext context) =>
      AppSkeletonBox(width: width, height: 14);
}

/// Vertical list of skeleton rows used for cards.
class AppSkeletonList extends StatelessWidget {
  const AppSkeletonList({this.count = 3, super.key});
  final int count;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.s4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(count, (i) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.s3),
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.s3),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(color: AppColors.slate200),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppSkeletonText(width: 120),
                  SizedBox(height: AppSpacing.s2),
                  AppSkeletonText(),
                  SizedBox(height: AppSpacing.s1),
                  AppSkeletonText(width: 180),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}