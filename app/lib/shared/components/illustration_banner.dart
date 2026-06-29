import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Animated illustration banner for onboarding screens.
/// Each scene has unique animated elements: floating, pulsing, rotating.
class IllustrationBanner extends StatefulWidget {
  const IllustrationBanner({required this.scene, super.key});

  final OnboardingScene scene;

  @override
  State<IllustrationBanner> createState() => _IllustrationBannerState();
}

class _IllustrationBannerState extends State<IllustrationBanner>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFFFE8D6),
            AppColors.warmPrimaryLight,
            AppColors.warmSurface,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (_, __) {
          return CustomPaint(
            size: const Size(double.infinity, 280),
            painter: _RichIllustrationPainter(
              scene: widget.scene,
              t: _ctrl.value,
            ),
          );
        },
      ),
    );
  }
}

enum OnboardingScene {
  welcome,
  features,
  setup,
  privacy,
  discover,
  tools,
  map,
  you,
}

class _RichIllustrationPainter extends CustomPainter {
  const _RichIllustrationPainter({
    required this.scene,
    required this.t,
  });

  final OnboardingScene scene;
  final double t;

  static const _p = AppColors.warmPrimary;
  static const _s = AppColors.warmSecondary;
  static const _a = AppColors.warmAccent;
  static const _l = AppColors.warmPrimaryLight;
  static const _w = Colors.white;

  double _pulse(double freq) => 1.0 + sin(t * 2 * pi * freq) * 0.06;
  double _float(double freq, {double amp = 8}) => sin(t * 2 * pi * freq) * amp;
  double _rotateVal(double freq) => t * 2 * pi * freq;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final cx = w / 2;
    final cy = h * 0.45;

    _drawBgCircles(canvas, w, h);

    switch (scene) {
      case OnboardingScene.welcome:
        _drawWelcome(canvas, cx, cy, w, h);
      case OnboardingScene.features:
        _drawFeatures(canvas, cx, cy, w, h);
      case OnboardingScene.setup:
        _drawSetup(canvas, cx, cy, w, h);
      case OnboardingScene.privacy:
        _drawPrivacy(canvas, cx, cy, w, h);
      case OnboardingScene.discover:
        _drawDiscover(canvas, cx, cy, w, h);
      case OnboardingScene.tools:
        _drawTools(canvas, cx, cy, w, h);
      case OnboardingScene.map:
        _drawMap(canvas, cx, cy, w, h);
      case OnboardingScene.you:
        _drawYou(canvas, cx, cy, w, h);
    }
  }

  void _drawBgCircles(Canvas c, double w, double h) {
    final paint = Paint()..style = PaintingStyle.fill;
    final circles = [
      (Offset(w * 0.1 + _float(0.7, amp: 5), h * 0.7 + _float(0.5, amp: 4)),
          60.0, _a.withValues(alpha: 0.08)),
      (Offset(w * 0.85 + _float(0.6, amp: 4), h * 0.3 + _float(0.55, amp: 3)),
          40.0, _a.withValues(alpha: 0.06)),
      (Offset(w * 0.25, h * 0.15), 25.0, _s.withValues(alpha: 0.1)),
      (Offset(w * 0.7 + _float(0.4, amp: 5), h * 0.55 + _float(0.45, amp: 5)),
          35.0, _p.withValues(alpha: 0.06)),
      (Offset(w * 0.5, h * 0.85), 50.0, _a.withValues(alpha: 0.07)),
    ];
    for (final (offset, radius, color) in circles) {
      paint.color = color;
      c.drawCircle(offset, radius, paint);
    }
  }

  /// Welcome: large suitcase + floating passport + pulsing map pin + animated sparkles
  void _drawWelcome(Canvas c, double cx, double cy, double w, double h) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Animated route dots trail (opacity wave)
    for (var i = 0; i < 5; i++) {
      final alpha = (sin(t * 2 * pi + i * 0.6) * 0.3 + 0.5).clamp(0.0, 0.7);
      paint.color = _a.withValues(alpha: alpha);
      final x = cx - 90 + i * 30.0;
      final y = cy - 70 + sin(t * 2 * pi * 0.5 + i * 0.8) * 15;
      c.drawCircle(Offset(x, y), 3 + sin(t * 2 * pi + i) * 1, paint);
    }

    // Large suitcase (subtle float)
    final boxY = cy + 10 + _float(0.4, amp: 4);
    // Shadow
    paint.color = _p.withValues(alpha: 0.1);
    c.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(cx - 5, boxY + 5), width: 90, height: 70),
        const Radius.circular(14),
      ),
      paint,
    );
    // Main body
    paint.color = _p;
    c.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(cx - 10, boxY), width: 86, height: 66),
        const Radius.circular(14),
      ),
      paint,
    );
    // Lighter front panel
    paint.color = _s;
    c.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(cx - 10, boxY + 8), width: 70, height: 42),
        const Radius.circular(8),
      ),
      paint,
    );
    // Handle
    paint.strokeWidth = 4;
    paint.style = PaintingStyle.stroke;
    paint.color = _w;
    c.drawArc(
      Rect.fromCenter(center: Offset(cx - 10, boxY - 33), width: 36, height: 24),
      pi,
      pi,
      false,
      paint,
    );
    // Suitcase wheels
    paint.style = PaintingStyle.fill;
    paint.color = _a;
    c.drawCircle(Offset(cx - 38, boxY + 33), 6, paint);
    c.drawCircle(Offset(cx + 18, boxY + 33), 6, paint);
    paint.color = _w;
    c.drawCircle(Offset(cx - 38, boxY + 33), 3, paint);
    c.drawCircle(Offset(cx + 18, boxY + 33), 3, paint);

    // Floating passport (gentle wobble)
    final passX = cx + 65 + _float(0.35, amp: 4);
    final passY = cy - 50 + _float(0.45, amp: 3);
    final passRotate = _float(0.25, amp: 0.03);
    c.save();
    c.translate(passX, passY);
    c.rotate(passRotate);
    paint.color = _w;
    paint.style = PaintingStyle.fill;
    c.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset.zero, width: 48, height: 34),
        const Radius.circular(5),
      ),
      paint,
    );
    // Passport accent
    paint.color = _p;
    c.drawRect(
      Rect.fromCenter(center: const Offset(0, 5), width: 36, height: 10),
      paint,
    );
    // Lines
    paint.color = _a.withValues(alpha: 0.6);
    paint.strokeWidth = 2;
    paint.style = PaintingStyle.stroke;
    c.drawLine(const Offset(-15, -2), Offset(11, -2), paint);
    c.drawLine(const Offset(-15, 4), Offset(5, 4), paint);
    c.restore();

    // Pulsing map pin
    final pinScale = _pulse(1.0);
    c.save();
    c.translate(cx - 35, cy - 50);
    c.scale(pinScale, pinScale);
    paint.style = PaintingStyle.fill;
    paint.color = _p;
    final pinPath = Path()
      ..moveTo(-20, -5)
      ..cubicTo(0, -25, 20, -5, 0, 20)
      ..close();
    c.drawPath(pinPath, paint);
    // Pin inner circle
    paint.color = _w;
    c.drawCircle(Offset.zero, 7, paint);
    c.restore();

    // Animated sparkle dots (oscillating opacity)
    final sparkles = [
      (Offset(cx + 90, cy - 40), 4.0, 0.6),
      (Offset(cx - 80, cy - 20), 3.0, 0.8),
      (Offset(cx + 50, cy + 45), 3.0, 0.5),
      (Offset(cx + 20, cy - 85), 2.5, 0.7),
      (Offset(cx - 50, cy - 70), 3.5, 0.55),
    ];
    for (final (pos, radius, freq) in sparkles) {
      final alpha = (sin(t * 2 * pi * freq) * 0.4 + 0.4).clamp(0.0, 0.8);
      paint.color = _a.withValues(alpha: alpha);
      paint.style = PaintingStyle.fill;
      c.drawCircle(pos, radius, paint);
    }
  }

  /// Features: rotating compass + floating cards + pulsing route dots
  void _drawFeatures(Canvas c, double cx, double cy, double w, double h) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Rotating compass
    final compassCx = cx + 60;
    final compassCy = cy - 60;
    paint.color = _a.withValues(alpha: 0.15);
    c.drawCircle(Offset(compassCx, compassCy), 50, paint);
    paint.color = _p.withValues(alpha: 0.1);
    c.drawCircle(Offset(compassCx, compassCy), 32, paint);

    // Compass cross (rotating)
    c.save();
    c.translate(compassCx, compassCy);
    c.rotate(_rotateVal(0.15));
    paint.color = _p.withValues(alpha: 0.3);
    paint.strokeWidth = 2;
    paint.style = PaintingStyle.stroke;
    c.drawLine(const Offset(0, -50), const Offset(0, 50), paint);
    c.drawLine(const Offset(-50, 0), const Offset(50, 0), paint);
    // Compass arrow
    paint.style = PaintingStyle.fill;
    paint.color = _p;
    final arrow = Path()
      ..moveTo(0, -45)
      ..lineTo(-5, -5)
      ..lineTo(5, -5)
      ..close();
    c.drawPath(arrow, paint);
    c.restore();

    // Pulsing route dots with connecting line
    final routePoints = [
      Offset(cx - 90, cy - 30 + _float(0.6, amp: 3)),
      Offset(cx - 60, cy - 15 + _float(0.5, amp: 2)),
      Offset(cx - 30, cy - 20 + _float(0.55, amp: 4)),
      Offset(cx, cy + 5 + _float(0.45, amp: 3)),
      Offset(cx + 30, cy + 10 + _float(0.5, amp: 2)),
      Offset(cx + 60, cy + 5 + _float(0.6, amp: 3)),
    ];
    // Animated connecting line
    paint.color = _s.withValues(alpha: 0.35);
    paint.strokeWidth = 2;
    paint.style = PaintingStyle.stroke;
    final route = Path()..moveTo(routePoints.first.dx, routePoints.first.dy);
    for (var i = 1; i < routePoints.length; i++) {
      route.lineTo(routePoints[i].dx, routePoints[i].dy);
    }
    c.drawPath(route, paint);
    // Pulsing dots
    for (var i = 0; i < routePoints.length; i++) {
      final alpha = (sin(t * 2 * pi + i * 0.5) * 0.2 + 0.4).clamp(0.0, 0.6);
      paint.color = _a.withValues(alpha: alpha);
      paint.style = PaintingStyle.fill;
      c.drawCircle(routePoints[i], 3 + sin(t * 2 * pi + i) * 1, paint);
    }

    // Left card: Map (floating)
    final leftCardY = cy - 10 + _float(0.35, amp: 3);
    paint.style = PaintingStyle.fill;
    paint.color = _w;
    _drawShadowCard(c, cx - 70, leftCardY, 70, 95, paint, _p.withValues(alpha: 0.1));
    // Map top bar
    paint.color = _p;
    final topBarRect = Rect.fromCenter(center: Offset(cx - 70, leftCardY - 40), width: 70, height: 14);
    c.drawRRect(
      RRect.fromLTRBR(
        topBarRect.left, topBarRect.top,
        topBarRect.right, topBarRect.bottom,
        const Radius.circular(12),
      ),
      paint,
    );
    // Map content lines
    paint.color = _s.withValues(alpha: 0.3);
    c.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(cx - 85, leftCardY - 5), width: 30, height: 6),
        const Radius.circular(3),
      ),
      paint,
    );
    c.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(cx - 85, leftCardY + 10), width: 24, height: 6),
        const Radius.circular(3),
      ),
      paint,
    );
    c.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(cx - 85, leftCardY + 25), width: 36, height: 6),
        const Radius.circular(3),
      ),
      paint,
    );

    // Checklist card (right, floating)
    final rightCardY = cy + 10 + _float(0.4, amp: 3);
    _drawShadowCard(c, cx + 45, rightCardY, 65, 85, paint, _p.withValues(alpha: 0.1));
    paint.color = _w;
    c.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(cx + 45, rightCardY), width: 65, height: 85),
        const Radius.circular(12),
      ),
      paint,
    );
    for (var i = 0; i < 3; i++) {
      final y = rightCardY - 25 + i * 22.0;
      paint.color = i < 2 ? _p : _s.withValues(alpha: 0.5);
      c.drawCircle(Offset(cx + 25, y), 9, paint);
      if (i < 2) {
        paint.color = _w;
        paint.strokeWidth = 2;
        paint.style = PaintingStyle.stroke;
        paint.strokeCap = StrokeCap.round;
        final check = Path()
          ..moveTo(cx + 20, y)
          ..lineTo(cx + 24, y + 4)
          ..lineTo(cx + 30, y - 4);
        c.drawPath(check, paint);
      }
      paint.style = PaintingStyle.fill;
      paint.color = _s.withValues(alpha: 0.3);
      c.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset(cx + 55, y), width: 28, height: 5),
          const Radius.circular(3),
        ),
        paint,
      );
    }
  }

  void _drawShadowCard(
      Canvas c, double x, double y, double w, double h, Paint p, Color shadow) {
    p.color = shadow;
    final rect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(x + 3, y + 4), width: w, height: h),
      const Radius.circular(12),
    );
    c.drawRRect(rect, p);
    p.color = _w;
    c.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(x, y), width: w, height: h),
        const Radius.circular(12),
      ),
      p,
    );
  }

  /// Setup: orbiting dots + rotating gears + pulsing globe
  void _drawSetup(Canvas c, double cx, double cy, double w, double h) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Orbit ring
    paint.color = _a.withValues(alpha: 0.15);
    paint.strokeWidth = 2;
    paint.style = PaintingStyle.stroke;
    c.drawOval(
      Rect.fromCenter(center: Offset(cx, cy), width: 140, height: 70),
      paint,
    );

    // Orbiting dots along the ellipse
    paint.style = PaintingStyle.fill;
    for (var i = 0; i < 4; i++) {
      final angle = _rotateVal(0.2) + i * pi / 2;
      final dotX = cx + cos(angle) * 70;
      final dotY = cy + sin(angle) * 35;
      paint.color = _a.withValues(alpha: 0.6);
      c.drawCircle(Offset(dotX, dotY), 4, paint);
    }

    // Left gear (rotating)
    c.save();
    c.translate(cx - 70, cy + 15);
    c.rotate(_rotateVal(0.3));
    _drawGear(c, 0, 0, 32, _s.withValues(alpha: 0.3));
    c.restore();

    // Right gear (rotating opposite direction)
    c.save();
    c.translate(cx + 70, cy + 5);
    c.rotate(-_rotateVal(0.25));
    _drawGear(c, 0, 0, 28, _p.withValues(alpha: 0.3));
    c.restore();

    // Pulsing globe
    final globeScale = _pulse(0.8);
    c.save();
    c.translate(cx, cy);
    c.scale(globeScale, globeScale);
    // Globe shadow
    paint.color = _p.withValues(alpha: 0.06);
    c.drawCircle(const Offset(0, 3), 48, paint);
    // Globe fill
    paint.color = _s;
    c.drawCircle(Offset.zero, 48, paint);
    // Highlight
    paint.color = _w.withValues(alpha: 0.2);
    c.drawCircle(const Offset(-15, -15), 20, paint);
    // Latitude lines
    paint.color = _w.withValues(alpha: 0.25);
    paint.strokeWidth = 1.5;
    paint.style = PaintingStyle.stroke;
    c.drawCircle(Offset.zero, 48, paint);
    c.drawLine(const Offset(-48, 0), const Offset(48, 0), paint);
    // Equator
    final eq = Path()
      ..moveTo(-48, 0)
      ..quadraticBezierTo(-24, -18, 0, 5)
      ..quadraticBezierTo(24, 25, 48, 5);
    c.drawPath(eq, paint);
    // Meridian
    final meridian = Path()
      ..moveTo(0, -48)
      ..quadraticBezierTo(18, -24, 0, 0)
      ..quadraticBezierTo(-18, 24, 0, 48);
    c.drawPath(meridian, paint);
    // Location pin
    paint.style = PaintingStyle.fill;
    paint.color = _p;
    final pin = Path()
      ..moveTo(-5, -18)
      ..lineTo(5, -8)
      ..lineTo(-15, -8)
      ..close();
    c.drawPath(pin, paint);
    paint.color = _w;
    c.drawCircle(const Offset(-5, -14), 3, paint);
    c.restore();

    // Sparkles
    paint.color = _a;
    for (var i = 0; i < 3; i++) {
      final alpha = (sin(t * 2 * pi * (0.7 + i * 0.3)) * 0.3 + 0.5).clamp(0.0, 1.0);
      paint.color = _a.withValues(alpha: alpha);
      c.drawCircle(
        Offset(cx - 85 + i * 85.0, cy - 50 + sin(t * 2 * pi * 0.4 + i) * 10),
        3 + i.toDouble(),
        paint,
      );
    }
  }

  void _drawGear(Canvas c, double x, double y, double r, Color color) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    c.drawCircle(Offset(x, y), r, paint);
    const teeth = 8;
    for (var i = 0; i < teeth; i++) {
      final angle = (i / teeth) * 2 * pi;
      final tx = x + cos(angle) * (r - 4);
      final ty = y + sin(angle) * (r - 4);
      c.drawCircle(Offset(tx, ty), 6, paint);
    }
    paint.color = _w.withValues(alpha: 0.4);
    c.drawCircle(Offset(x, y), r * 0.3, paint);
  }

  /// Privacy: pulsing shield + bouncing lock + floating documents
  void _drawPrivacy(Canvas c, double cx, double cy, double w, double h) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Decorative ring (pulsing)
    final ringAlpha = (sin(t * 2 * pi * 0.5) * 0.04 + 0.08).clamp(0.0, 0.12);
    paint.color = _a.withValues(alpha: ringAlpha);
    c.drawCircle(Offset(cx, cy), 70, paint);

    // Floating left document
    final leftDocY = cy + 5 + _float(0.35, amp: 4);
    paint.color = _w;
    _drawDocCard(c, cx - 65, leftDocY, 55, 75, _s.withValues(alpha: 0.15));

    // Floating right document
    final rightDocY = cy - 15 + _float(0.4, amp: 5);
    _drawDocCard(c, cx + 55, rightDocY, 50, 70, _p.withValues(alpha: 0.12));

    // Pulsing shield
    final shieldScale = _pulse(0.9);
    c.save();
    c.translate(cx, cy);
    c.scale(shieldScale, shieldScale);

    paint.color = _w;
    paint.style = PaintingStyle.fill;
    final shieldBody = Path()
      ..moveTo(0, -55)
      ..quadraticBezierTo(60, -35, 50, 20)
      ..lineTo(20, 45)
      ..lineTo(0, 38)
      ..lineTo(-20, 45)
      ..lineTo(-50, 20)
      ..quadraticBezierTo(-60, -35, 0, -55)
      ..close();
    c.drawPath(shieldBody, paint);

    // Shield fill
    paint.color = _p;
    final shieldFill = Path()
      ..moveTo(0, -50)
      ..quadraticBezierTo(54, -35, 45, 15)
      ..lineTo(18, 38)
      ..lineTo(0, 32)
      ..lineTo(-18, 38)
      ..lineTo(-45, 15)
      ..quadraticBezierTo(-54, -35, 0, -50)
      ..close();
    c.drawPath(shieldFill, paint);

    // Shield inner highlight
    paint.color = _w.withValues(alpha: 0.25);
    final highlight = Path()
      ..moveTo(-15, -30)
      ..quadraticBezierTo(0, -40, 15, -30)
      ..quadraticBezierTo(0, -20, -15, -30)
      ..close();
    c.drawPath(highlight, paint);

    // Check mark
    paint.color = _w;
    paint.strokeWidth = 3.5;
    paint.style = PaintingStyle.stroke;
    paint.strokeCap = StrokeCap.round;
    final check = Path()
      ..moveTo(-20, 5)
      ..lineTo(-6, 20)
      ..lineTo(22, -10);
    c.drawPath(check, paint);

    c.restore();

    // Bouncing lock above shield
    final lockBounce = _float(0.55, amp: 6);
    paint.style = PaintingStyle.fill;
    paint.color = _a;
    c.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(cx, cy - 80 + lockBounce), width: 18, height: 20),
        const Radius.circular(4),
      ),
      paint,
    );
    paint.color = _p;
    paint.strokeWidth = 2.5;
    paint.style = PaintingStyle.stroke;
    c.drawArc(
      Rect.fromCenter(
          center: Offset(cx, cy - 88 + lockBounce), width: 16, height: 12),
      pi,
      pi,
      false,
      paint,
    );
    // Lock keyhole
    paint.style = PaintingStyle.fill;
    paint.color = _w;
    c.drawCircle(Offset(cx, cy - 75 + lockBounce), 3, paint);
    c.drawRect(
      Rect.fromCenter(
          center: Offset(cx, cy - 70 + lockBounce), width: 2, height: 6),
      paint,
    );
  }

  void _drawDocCard(Canvas c, double x, double y, double w, double h,
      Color accentColor) {
    final paint = Paint()..style = PaintingStyle.fill;
    // Shadow
    paint.color = _p.withValues(alpha: 0.06);
    c.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(x + 2, y + 3), width: w, height: h),
        const Radius.circular(8),
      ),
      paint,
    );
    // Card body
    paint.color = _w;
    c.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(x, y), width: w, height: h),
        const Radius.circular(8),
      ),
      paint,
    );
    // Colored accent line
    paint.color = accentColor;
    c.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(x, y - h / 2 + 4), width: w, height: 6),
        const Radius.circular(3),
      ),
      paint,
    );
    // Animated text line opacity
    final lineAlpha = (sin(t * 2 * pi * 0.3) * 0.1 + 0.3).clamp(0.0, 0.4);
    paint.color = _s.withValues(alpha: lineAlpha);
    for (var i = 0; i < 3; i++) {
      final lineW = (w - 20) * (1 - i * 0.2);
      c.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(x - 2, y + i * 12.0),
            width: lineW,
            height: 4,
          ),
          const Radius.circular(2),
        ),
        paint,
      );
    }
  }

  /// Discover: open magazine with star ratings, ribbon, sparkles.
  void _drawDiscover(Canvas c, double cx, double cy, double w, double h) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Decorative star bursts in corners (pulsing)
    final cornerStars = [
      Offset(cx - 100, cy - 70),
      Offset(cx + 95, cy - 65),
      Offset(cx - 90, cy + 60),
      Offset(cx + 90, cy + 70),
    ];
    for (var i = 0; i < cornerStars.length; i++) {
      final p = cornerStars[i];
      final scale = _pulse(0.8 + i * 0.15);
      c.save();
      c.translate(p.dx, p.dy);
      c.scale(scale, scale);
      final size = 6.0;
      final star = Path()
        ..moveTo(0, -size)
        ..lineTo(size * 0.3, -size * 0.3)
        ..lineTo(size, -size * 0.3)
        ..lineTo(size * 0.4, size * 0.2)
        ..lineTo(size * 0.6, size)
        ..lineTo(0, size * 0.5)
        ..lineTo(-size * 0.6, size)
        ..lineTo(-size * 0.4, size * 0.2)
        ..lineTo(-size, -size * 0.3)
        ..lineTo(-size * 0.3, -size * 0.3)
        ..close();
      paint.color = _a;
      c.drawPath(star, paint);
      c.restore();
    }

    // Floating ribbon banner above magazine
    final ribbonY = cy - 75 + _float(0.5, amp: 3);
    paint.color = _a;
    c.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(cx, ribbonY), width: 90, height: 18),
        const Radius.circular(4),
      ),
      paint,
    );
    // Ribbon lines
    paint.color = _w.withValues(alpha: 0.6);
    paint.strokeWidth = 1.5;
    paint.style = PaintingStyle.stroke;
    c.drawLine(Offset(cx - 30, ribbonY), Offset(cx - 10, ribbonY), paint);
    c.drawLine(Offset(cx + 10, ribbonY), Offset(cx + 30, ribbonY), paint);
    paint.style = PaintingStyle.fill;

    // Central magazine (open book, large rounded rectangle)
    final magY = cy + 10 + _float(0.3, amp: 2);
    // Shadow
    paint.color = _p.withValues(alpha: 0.1);
    c.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(cx + 3, magY + 4), width: 150, height: 100),
        const Radius.circular(10),
      ),
      paint,
    );
    // Left page
    paint.color = _l;
    c.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(cx - 36, magY), width: 72, height: 95),
        const Radius.circular(8),
      ),
      paint,
    );
    // Right page
    paint.color = _l;
    c.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(cx + 38, magY), width: 72, height: 95),
        const Radius.circular(8),
      ),
      paint,
    );
    // Center spine
    paint.color = _a;
    c.drawRect(
      Rect.fromCenter(center: Offset(cx, magY), width: 3, height: 95),
      paint,
    );

    // Left page: 3 list items
    for (var i = 0; i < 3; i++) {
      final ly = magY - 25 + i * 22.0;
      paint.color = _s;
      c.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset(cx - 50, ly), width: 36, height: 8),
          const Radius.circular(4),
        ),
        paint,
      );
      paint.color = _a.withValues(alpha: 0.5);
      c.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset(cx - 30, ly + 8), width: 24, height: 4),
          const Radius.circular(2),
        ),
        paint,
      );
    }

    // Right page: Top Pick star (pulsing)
    final starScale = _pulse(1.1);
    c.save();
    c.translate(cx + 38, magY - 30);
    c.scale(starScale, starScale);
    final topSize = 10.0;
    final topStar = Path()
      ..moveTo(0, -topSize)
      ..lineTo(topSize * 0.3, -topSize * 0.3)
      ..lineTo(topSize, -topSize * 0.3)
      ..lineTo(topSize * 0.4, topSize * 0.2)
      ..lineTo(topSize * 0.6, topSize)
      ..lineTo(0, topSize * 0.5)
      ..lineTo(-topSize * 0.6, topSize)
      ..lineTo(-topSize * 0.4, topSize * 0.2)
      ..lineTo(-topSize, -topSize * 0.3)
      ..lineTo(-topSize * 0.3, -topSize * 0.3)
      ..close();
    paint.color = _a;
    c.drawPath(topStar, paint);
    c.restore();

    // Right page: 3 list items
    for (var i = 0; i < 3; i++) {
      final ly = magY - 5 + i * 22.0;
      paint.color = _s;
      c.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset(cx + 24, ly), width: 36, height: 8),
          const Radius.circular(4),
        ),
        paint,
      );
      paint.color = _a.withValues(alpha: 0.5);
      c.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset(cx + 44, ly + 8), width: 24, height: 4),
          const Radius.circular(2),
        ),
        paint,
      );
    }

    // Heart icon at bottom-right of magazine (floating)
    final heartX = cx + 95 + _float(0.4, amp: 3);
    final heartY = cy + 35 + _float(0.5, amp: 2);
    c.save();
    c.translate(heartX, heartY);
    final heart = Path()
      ..moveTo(0, 8)
      ..cubicTo(-15, -5, -15, -15, -7, -15)
      ..cubicTo(-3, -15, 0, -10, 0, -7)
      ..cubicTo(0, -10, 3, -15, 7, -15)
      ..cubicTo(15, -15, 15, -5, 0, 8)
      ..close();
    paint.color = _p;
    c.drawPath(heart, paint);
    c.restore();
  }

  /// Tools: toolbox with wrench, gear, calculator and lightbulb.
  void _drawTools(Canvas c, double cx, double cy, double w, double h) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Floating gear on the left
    c.save();
    c.translate(cx - 70, cy - 30);
    c.rotate(_rotateVal(0.3));
    paint.color = _s;
    c.drawCircle(Offset.zero, 16, paint);
    for (var i = 0; i < 8; i++) {
      final angle = i * pi / 4;
      final tx = cos(angle) * 22;
      final ty = sin(angle) * 22;
      c.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset(tx, ty), width: 8, height: 8),
          const Radius.circular(2),
        ),
        paint,
      );
    }
    paint.color = _w;
    c.drawCircle(Offset.zero, 6, paint);
    c.restore();

    // Floating calculator on the right
    final calcX = cx + 75 + _float(0.4, amp: 3);
    final calcY = cy - 25 + _float(0.5, amp: 2);
    // Shadow
    paint.color = _p.withValues(alpha: 0.1);
    c.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(calcX + 2, calcY + 3), width: 44, height: 56),
        const Radius.circular(6),
      ),
      paint,
    );
    // Body
    paint.color = _a;
    c.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(calcX, calcY), width: 44, height: 56),
        const Radius.circular(6),
      ),
      paint,
    );
    // Screen
    paint.color = _w;
    c.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(calcX, calcY - 18), width: 36, height: 12),
        const Radius.circular(2),
      ),
      paint,
    );
    // Dots grid
    paint.color = _p;
    for (var row = 0; row < 3; row++) {
      for (var col = 0; col < 3; col++) {
        c.drawCircle(
          Offset(calcX - 10 + col * 10.0, calcY - 4 + row * 8.0),
          2,
          paint,
        );
      }
    }

    // Lightbulb above toolbox (pulsing)
    final bulbScale = _pulse(1.1);
    c.save();
    c.translate(cx, cy - 78);
    c.scale(bulbScale, bulbScale);
    paint.color = _a;
    c.drawCircle(Offset.zero, 12, paint);
    paint.color = _w;
    c.drawCircle(const Offset(-3, -3), 4, paint);
    // Bulb base
    paint.color = _p;
    c.drawRect(
      Rect.fromCenter(center: const Offset(0, 14), width: 10, height: 4),
      paint,
    );
    c.restore();

    // Toolbox body (large rounded rect)
    final boxY = cy + 25;
    // Shadow
    paint.color = _p.withValues(alpha: 0.12);
    c.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(cx + 4, boxY + 5), width: 120, height: 80),
        const Radius.circular(12),
      ),
      paint,
    );
    // Main body
    paint.color = _p;
    c.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(cx, boxY), width: 120, height: 80),
        const Radius.circular(12),
      ),
      paint,
    );
    // Lid line
    paint.color = _s;
    c.drawRect(
      Rect.fromCenter(center: Offset(cx, boxY - 20), width: 120, height: 4),
      paint,
    );
    // Latch (circle)
    paint.color = _a;
    c.drawCircle(Offset(cx, boxY - 18), 6, paint);
    paint.color = _w;
    c.drawCircle(Offset(cx, boxY - 18), 3, paint);
    // Handle (arc)
    paint.color = _p;
    paint.strokeWidth = 6;
    paint.style = PaintingStyle.stroke;
    paint.strokeCap = StrokeCap.round;
    c.drawArc(
      Rect.fromCenter(center: Offset(cx, boxY - 50), width: 50, height: 28),
      pi,
      pi,
      false,
      paint,
    );
    paint.style = PaintingStyle.fill;

    // Wrench sticking out from the top (rotating slowly)
    c.save();
    c.translate(cx, boxY - 50);
    c.rotate(_rotateVal(0.2));
    paint.color = _s;
    c.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: const Offset(0, -15), width: 8, height: 30),
        const Radius.circular(3),
      ),
      paint,
    );
    // Wrench head
    paint.color = _s;
    c.drawCircle(const Offset(0, -30), 10, paint);
    paint.color = _w;
    c.drawCircle(const Offset(0, -30), 4, paint);
    c.restore();
  }

  /// Map: folded map with grid, route and three pins, compass and magnifier.
  void _drawMap(Canvas c, double cx, double cy, double w, double h) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Folded map (large rounded rect)
    final mapW = 160.0;
    final mapH = 110.0;
    final mapY = cy + 5;
    // Shadow
    paint.color = _p.withValues(alpha: 0.1);
    c.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
            center: Offset(cx + 4, mapY + 5), width: mapW, height: mapH),
        const Radius.circular(10),
      ),
      paint,
    );
    // Map fill
    paint.color = _p;
    c.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(cx, mapY), width: mapW, height: mapH),
        const Radius.circular(10),
      ),
      paint,
    );

    // Map grid lines (2 horizontal + 2 vertical)
    paint.color = _l;
    paint.strokeWidth = 1.5;
    paint.style = PaintingStyle.stroke;
    c.drawLine(
      Offset(cx - mapW / 2, mapY - mapH / 4),
      Offset(cx + mapW / 2, mapY - mapH / 4),
      paint,
    );
    c.drawLine(
      Offset(cx - mapW / 2, mapY + mapH / 4),
      Offset(cx + mapW / 2, mapY + mapH / 4),
      paint,
    );
    c.drawLine(
      Offset(cx - mapW / 4, mapY - mapH / 2),
      Offset(cx - mapW / 4, mapY + mapH / 2),
      paint,
    );
    c.drawLine(
      Offset(cx + mapW / 4, mapY - mapH / 2),
      Offset(cx + mapW / 4, mapY + mapH / 2),
      paint,
    );
    paint.style = PaintingStyle.fill;

    // Route line (curved Path) connecting 3 pins
    final pin1 = Offset(cx - 50, mapY + 20);
    final pin2 = Offset(cx, mapY - 25);
    final pin3 = Offset(cx + 55, mapY + 15);
    paint.color = _s;
    paint.strokeWidth = 3;
    paint.style = PaintingStyle.stroke;
    paint.strokeCap = StrokeCap.round;
    final route = Path()
      ..moveTo(pin1.dx, pin1.dy)
      ..quadraticBezierTo(cx - 30, mapY - 10, pin2.dx, pin2.dy)
      ..quadraticBezierTo(cx + 30, mapY - 10, pin3.dx, pin3.dy);
    c.drawPath(route, paint);
    paint.style = PaintingStyle.fill;

    // 3 location pins
    void drawPin(Offset center, Color color, double pulse) {
      c.save();
      c.translate(center.dx, center.dy);
      final scale = pulse > 0 ? _pulse(1.0) : 1.0;
      c.scale(scale, scale);
      final pin = Path()
        ..moveTo(0, 20)
        ..cubicTo(-15, 5, -15, -10, 0, -20)
        ..cubicTo(15, -10, 15, 5, 0, 20)
        ..close();
      paint.color = color;
      c.drawPath(pin, paint);
      paint.color = _w;
      c.drawCircle(const Offset(0, -5), 6, paint);
      c.restore();
    }

    drawPin(pin1, _p, 0);
    drawPin(pin2, _s, 0);
    drawPin(pin3, _a, 1);

    // Compass rose (small circle with N arrow) in a corner
    final compassCx = cx - 60;
    final compassCy = mapY + 40;
    paint.color = _w.withValues(alpha: 0.85);
    c.drawCircle(Offset(compassCx, compassCy), 12, paint);
    paint.color = _p;
    c.drawCircle(Offset(compassCx, compassCy), 12,
        Paint()
          ..color = _p
          ..strokeWidth = 1.5
          ..style = PaintingStyle.stroke);
    // N arrow
    paint.color = _a;
    final arrow = Path()
      ..moveTo(compassCx, compassCy - 9)
      ..lineTo(compassCx - 4, compassCy + 2)
      ..lineTo(compassCx, compassCy - 1)
      ..lineTo(compassCx + 4, compassCy + 2)
      ..close();
    c.drawPath(arrow, paint);

    // Floating magnifier above the map (slowly rotating)
    c.save();
    final magX = cx + 50 + _float(0.4, amp: 3);
    final magY2 = cy - 75 + _float(0.5, amp: 2);
    c.translate(magX, magY2);
    c.rotate(_rotateVal(0.15));
    paint.color = _w;
    c.drawCircle(Offset.zero, 14, paint);
    paint.color = _a;
    c.drawCircle(Offset.zero, 14,
        Paint()
          ..color = _a
          ..strokeWidth = 3
          ..style = PaintingStyle.stroke);
    // Handle
    paint.color = _p;
    paint.strokeWidth = 4;
    paint.style = PaintingStyle.stroke;
    paint.strokeCap = StrokeCap.round;
    c.drawLine(const Offset(10, 10), const Offset(20, 20), paint);
    paint.style = PaintingStyle.fill;
    c.restore();
  }

  /// You: user avatar with settings gears, bell, heart and sparkles.
  void _drawYou(Canvas c, double cx, double cy, double w, double h) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Two small sparkle dots in corners
    paint.color = _a;
    c.drawCircle(Offset(cx - 95, cy - 70), 3, paint);
    c.drawCircle(Offset(cx + 90, cy - 50), 4, paint);

    // Notification bell at top (bobbing)
    final bellY = cy - 75 + _float(0.55, amp: 4);
    // Bell body
    paint.color = _a;
    c.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(cx, bellY), width: 22, height: 24),
        const Radius.circular(8),
      ),
      paint,
    );
    // Bell base
    paint.color = _p;
    c.drawRect(
      Rect.fromCenter(center: Offset(cx, bellY + 12), width: 22, height: 4),
      paint,
    );
    // Notification dot
    paint.color = _p;
    c.drawCircle(Offset(cx + 10, bellY - 8), 4, paint);

    // Decorative ring around avatar (rotating)
    c.save();
    c.translate(cx, cy + 5);
    c.rotate(_rotateVal(0.2));
    paint.color = _l;
    paint.strokeWidth = 3;
    paint.style = PaintingStyle.stroke;
    c.drawCircle(Offset.zero, 55, paint);
    // Decorative dots on the ring
    paint.style = PaintingStyle.fill;
    for (var i = 0; i < 6; i++) {
      final angle = i * pi / 3;
      final dx = cos(angle) * 55;
      final dy = sin(angle) * 55;
      paint.color = _a;
      c.drawCircle(Offset(dx, dy), 3, paint);
    }
    c.restore();

    // Avatar circle (warmPrimary fill)
    paint.style = PaintingStyle.fill;
    paint.color = _p;
    c.drawCircle(Offset(cx, cy + 5), 38, paint);
    // Head (white inner circle)
    paint.color = _w;
    c.drawCircle(Offset(cx, cy - 5), 14, paint);
    // Smile curve
    paint.color = _p;
    paint.strokeWidth = 2.5;
    paint.style = PaintingStyle.stroke;
    paint.strokeCap = StrokeCap.round;
    c.drawArc(
      Rect.fromCenter(center: Offset(cx, cy + 8), width: 18, height: 10),
      0,
      pi,
      false,
      paint,
    );
    paint.style = PaintingStyle.fill;

    // Settings gear upper-right (rotating)
    c.save();
    c.translate(cx + 65, cy - 30);
    c.rotate(_rotateVal(0.4));
    paint.color = _s;
    c.drawCircle(Offset.zero, 14, paint);
    for (var i = 0; i < 6; i++) {
      final angle = i * pi / 3;
      final tx = cos(angle) * 20;
      final ty = sin(angle) * 20;
      c.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset(tx, ty), width: 7, height: 7),
          const Radius.circular(2),
        ),
        paint,
      );
    }
    paint.color = _w;
    c.drawCircle(Offset.zero, 5, paint);
    c.restore();

    // Settings gear lower-left (rotating opposite)
    c.save();
    c.translate(cx - 70, cy + 45);
    c.rotate(-_rotateVal(0.35));
    paint.color = _a;
    c.drawCircle(Offset.zero, 10, paint);
    for (var i = 0; i < 4; i++) {
      final angle = i * pi / 2;
      final tx = cos(angle) * 15;
      final ty = sin(angle) * 15;
      c.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset(tx, ty), width: 6, height: 6),
          const Radius.circular(2),
        ),
        paint,
      );
    }
    paint.color = _w;
    c.drawCircle(Offset.zero, 4, paint);
    c.restore();

    // Heart at bottom-center (pulsing)
    final heartScale = _pulse(1.0);
    c.save();
    c.translate(cx, cy + 65);
    c.scale(heartScale, heartScale);
    final heart = Path()
      ..moveTo(0, 8)
      ..cubicTo(-13, -4, -13, -14, -6, -14)
      ..cubicTo(-3, -14, 0, -10, 0, -7)
      ..cubicTo(0, -10, 3, -14, 6, -14)
      ..cubicTo(13, -14, 13, -4, 0, 8)
      ..close();
    paint.color = _p;
    c.drawPath(heart, paint);
    c.restore();
  }

  @override
  bool shouldRepaint(covariant _RichIllustrationPainter old) =>
      old.scene != scene || old.t != t;
}
