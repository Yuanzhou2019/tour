import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class CircularProgressRing extends StatelessWidget {
  const CircularProgressRing({
    required this.progress,
    this.size = 80,
    this.strokeWidth = 6,
    this.backgroundColor,
    super.key,
  });

  final double progress; // 0.0 to 1.0
  final double size;
  final double strokeWidth;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ?? AppColors.warmPrimaryLight;
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(size, size),
            painter: _RingPainter(
              progress: progress,
              backgroundColor: bgColor,
              fillColor: AppColors.warmPrimary,
              strokeWidth: strokeWidth,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${(progress * 100).round()}%',
                style: AppTextTheme.textTheme.titleMedium?.copyWith(
                  color: AppColors.warmPrimaryDark,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                'done',
                style: AppTextTheme.textTheme.labelSmall?.copyWith(
                  color: AppColors.slate500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  const _RingPainter({
    required this.progress,
    required this.backgroundColor,
    required this.fillColor,
    required this.strokeWidth,
  });

  final double progress;
  final Color backgroundColor;
  final Color fillColor;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Background circle
    final bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, bgPaint);

    // Progress arc
    if (progress > 0) {
      final fillPaint = Paint()
        ..color = fillColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -pi / 2,
        2 * pi * progress,
        false,
        fillPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _RingPainter old) =>
      old.progress != progress ||
      old.backgroundColor != backgroundColor ||
      old.fillColor != fillColor;
}
