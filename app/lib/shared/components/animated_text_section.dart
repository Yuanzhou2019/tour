import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

/// Staggered fade+slide entrance animation for title + subtitle text blocks.
/// Used across all onboarding pages to make text areas visually dynamic.
class AnimatedTextSection extends StatefulWidget {
  const AnimatedTextSection({
    required this.title,
    required this.subtitle,
    this.titleColor,
    this.subtitleColor,
    this.titleSize = 26,
    super.key,
  });

  final String title;
  final String subtitle;
  final Color? titleColor;
  final Color? subtitleColor;
  final double titleSize;

  @override
  State<AnimatedTextSection> createState() => _AnimatedTextSectionState();
}

class _AnimatedTextSectionState extends State<AnimatedTextSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _titleFade;
  late Animation<double> _subtitleFade;
  late Animation<Offset> _titleSlide;
  late Animation<Offset> _subtitleSlide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _titleFade = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    );
    _subtitleFade = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.25, 0.85, curve: Curves.easeOut),
    );
    _titleSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOutCubic),
    ));
    _subtitleSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.25, 0.85, curve: Curves.easeOutCubic),
    ));
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s6),
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (_, __) {
          return Column(
            children: [
              const SizedBox(height: AppSpacing.s4),
              FadeTransition(
                opacity: _titleFade,
                child: SlideTransition(
                  position: _titleSlide,
                  child: Text(
                    widget.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: widget.titleColor ?? AppColors.warmPrimaryDark,
                      fontWeight: FontWeight.w700,
                      fontSize: widget.titleSize,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.s2),
              FadeTransition(
                opacity: _subtitleFade,
                child: SlideTransition(
                  position: _subtitleSlide,
                  child: Text(
                    widget.subtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: widget.subtitleColor ?? AppColors.slate500,
                      height: 1.4,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
