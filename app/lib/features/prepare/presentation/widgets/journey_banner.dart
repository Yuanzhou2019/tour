import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../l10n/generated/app_localizations.dart';

class JourneyBanner extends StatelessWidget {
  const JourneyBanner({
    required this.country,
    required this.entryReason,
    required this.entryCity,
    required this.onCountryTap,
    required this.onReasonTap,
    required this.onCityTap,
    super.key,
  });

  final String country;
  final String entryReason;
  final String entryCity;
  final VoidCallback onCountryTap;
  final VoidCallback onReasonTap;
  final VoidCallback onCityTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      margin: const EdgeInsets.fromLTRB(
        AppSpacing.s4,
        AppSpacing.s2,
        AppSpacing.s4,
        AppSpacing.s2,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        gradient: const LinearGradient(
          colors: [
            Color(0xFFD46520),
            AppColors.warmPrimary,
            AppColors.warmSecondary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.warmPrimary.withValues(alpha: 0.25),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative background elements
          Positioned(
            right: -10,
            top: -15,
            child: _DecorativeCircle(
              radius: 55,
              color: AppColors.white.withValues(alpha: 0.06),
            ),
          ),
          Positioned(
            left: 20,
            bottom: -20,
            child: _DecorativeCircle(
              radius: 40,
              color: AppColors.white.withValues(alpha: 0.04),
            ),
          ),
          Positioned(
            right: 60,
            top: 30,
            child: _DecorativeCircle(
              radius: 20,
              color: AppColors.white.withValues(alpha: 0.08),
            ),
          ),
          // Sparkle dots
          Positioned(
            right: 100,
            top: 10,
            child: _SparkleDot(
              color: AppColors.warmAccent.withValues(alpha: 0.6),
              size: 4,
            ),
          ),
          Positioned(
            right: 30,
            top: 50,
            child: _SparkleDot(
              color: AppColors.warmAccent.withValues(alpha: 0.4),
              size: 3,
            ),
          ),
          Positioned(
            left: 40,
            top: 70,
            child: _SparkleDot(
              color: AppColors.white.withValues(alpha: 0.5),
              size: 3,
            ),
          ),
          // City silhouette
          Positioned(
            right: 0,
            bottom: 0,
            child: _CitySilhouette(city: entryCity),
          ),
          // Route dots trail
          Positioned(
            left: 8,
            bottom: 50,
            child: _RouteTrail(),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(AppSpacing.s5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.flight_takeoff,
                        color: AppColors.white.withValues(alpha: 0.9), size: 20),
                    const SizedBox(width: AppSpacing.s1),
                    Text(
                      AppLocalizations.of(context)!.journeyBannerSubtitle,
                      style: AppTextTheme.textTheme.labelLarge?.copyWith(
                        color: AppColors.white.withValues(alpha: 0.85),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.s2),
                Text(
                  _cityGreeting(AppLocalizations.of(context)!),
                  style: AppTextTheme.textTheme.headlineSmall?.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: AppSpacing.s3),
                Row(
                  children: [
                    _FilterChip(
                      icon: Icons.public,
                      label: country,
                      onTap: onCountryTap,
                    ),
                    const SizedBox(width: AppSpacing.s2),
                    _FilterChip(
                      icon: Icons.explore,
                      label: entryReason,
                      onTap: onReasonTap,
                    ),
                    const SizedBox(width: AppSpacing.s2),
                    _FilterChip(
                      icon: Icons.location_on,
                      label: entryCity,
                      onTap: onCityTap,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _cityGreeting(AppLocalizations l10n) {
    switch (entryCity) {
      case 'SH':
        return l10n.journeyBannerGreetingSH;
      case 'BJ':
        return l10n.journeyBannerGreetingBJ;
      case 'GZ':
        return l10n.journeyBannerGreetingGZ;
      default:
        return l10n.journeyBannerGreetingDefault;
    }
  }
}

class _DecorativeCircle extends StatelessWidget {
  const _DecorativeCircle({required this.radius, required this.color});
  final double radius;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}

class _SparkleDot extends StatelessWidget {
  const _SparkleDot({required this.color, required this.size});
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}

class _RouteTrail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      height: 2,
      child: CustomPaint(
        painter: _TrailPainter(),
      ),
    );
  }
}

class _TrailPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.warmAccent.withValues(alpha: 0.4)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    final dash = 4.0;
    var x = 0.0;
    while (x < size.width) {
      canvas.drawLine(
        Offset(x, size.height / 2),
        Offset((x + dash).clamp(0, size.width), size.height / 2),
        paint,
      );
      x += dash + 5;
    }
  }

  @override
  bool shouldRepaint(covariant _TrailPainter old) => false;
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white.withValues(alpha: 0.22),
      borderRadius: BorderRadius.circular(AppRadius.full),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.full),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s3,
            vertical: AppSpacing.s1,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 13, color: AppColors.white),
              const SizedBox(width: AppSpacing.s1),
              Text(
                label,
                style: AppTextTheme.textTheme.labelMedium?.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CitySilhouette extends StatelessWidget {
  const _CitySilhouette({required this.city});

  final String city;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      height: 90,
      child: CustomPaint(
        painter: _SilhouettePainter(city: city),
      ),
    );
  }
}

class _SilhouettePainter extends CustomPainter {
  const _SilhouettePainter({required this.city});

  final String city;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.white.withValues(alpha: 0.12)
      ..style = PaintingStyle.fill;

    final w = size.width;
    final h = size.height;
    final b = h;

    switch (city) {
      case 'SH':
        // Oriental Pearl + skyline - richer
        _drawRect(canvas, paint, w * 0.08, b - h * 0.45, w * 0.08, h * 0.45);
        _drawRect(canvas, paint, w * 0.22, b - h * 0.65, w * 0.06, h * 0.65);
        _drawOval(canvas, paint, w * 0.18, b - h * 0.78, w * 0.14, h * 0.18);
        _drawRect(canvas, paint, w * 0.32, b - h * 0.5, w * 0.07, h * 0.5);
        _drawRect(canvas, paint, w * 0.45, b - h * 0.7, w * 0.06, h * 0.7);
        _drawOval(canvas, paint, w * 0.42, b - h * 0.82, w * 0.12, h * 0.16);
        _drawRect(canvas, paint, w * 0.56, b - h * 0.55, w * 0.1, h * 0.55);
        _drawRect(canvas, paint, w * 0.72, b - h * 0.6, w * 0.09, h * 0.6);
        _drawRect(canvas, paint, w * 0.86, b - h * 0.45, w * 0.1, h * 0.45);
        break;
      case 'BJ':
        _drawRect(canvas, paint, w * 0.05, b - h * 0.35, w * 0.06, h * 0.35);
        _drawRect(canvas, paint, w * 0.18, b - h * 0.25, w * 0.4, h * 0.25);
        _drawRect(canvas, paint, w * 0.24, b - h * 0.4, w * 0.05, h * 0.15);
        _drawRect(canvas, paint, w * 0.38, b - h * 0.35, w * 0.04, h * 0.1);
        _drawRect(canvas, paint, w * 0.50, b - h * 0.45, w * 0.05, h * 0.2);
        _drawRect(canvas, paint, w * 0.65, b - h * 0.5, w * 0.04, h * 0.25);
        _drawRect(canvas, paint, w * 0.75, b - h * 0.55, w * 0.25, h * 0.2);
        _drawRect(canvas, paint, w * 0.85, b - h * 0.35, w * 0.08, h * 0.35);
        break;
      case 'GZ':
        _drawRect(canvas, paint, w * 0.30, b - h * 0.75, w * 0.06, h * 0.12);
        _drawOval(canvas, paint, w * 0.25, b - h * 0.63, w * 0.16, h * 0.1);
        _drawRect(canvas, paint, w * 0.31, b - h * 0.55, w * 0.04, h * 0.55);
        _drawRect(canvas, paint, w * 0.08, b - h * 0.3, w * 0.1, h * 0.3);
        _drawRect(canvas, paint, w * 0.45, b - h * 0.4, w * 0.09, h * 0.4);
        _drawRect(canvas, paint, w * 0.60, b - h * 0.5, w * 0.08, h * 0.5);
        _drawRect(canvas, paint, w * 0.75, b - h * 0.35, w * 0.1, h * 0.35);
        _drawRect(canvas, paint, w * 0.90, b - h * 0.45, w * 0.06, h * 0.45);
        break;
      default:
        _drawRect(canvas, paint, w * 0.05, b - h * 0.35, w * 0.1, h * 0.35);
        _drawRect(canvas, paint, w * 0.20, b - h * 0.5, w * 0.08, h * 0.5);
        _drawRect(canvas, paint, w * 0.35, b - h * 0.4, w * 0.14, h * 0.4);
        _drawRect(canvas, paint, w * 0.55, b - h * 0.55, w * 0.1, h * 0.55);
        _drawRect(canvas, paint, w * 0.72, b - h * 0.38, w * 0.08, h * 0.38);
        _drawRect(canvas, paint, w * 0.85, b - h * 0.48, w * 0.1, h * 0.48);
        break;
    }
  }

  void _drawRect(Canvas c, Paint p, double x, double y, double w, double h) {
    c.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(x, y, w, h),
        topLeft: const Radius.circular(3),
        topRight: const Radius.circular(3),
      ),
      p,
    );
  }

  void _drawOval(Canvas c, Paint p, double x, double y, double w, double h) {
    c.drawOval(Rect.fromLTWH(x, y, w, h), p);
  }

  @override
  bool shouldRepaint(covariant _SilhouettePainter old) => old.city != city;
}
