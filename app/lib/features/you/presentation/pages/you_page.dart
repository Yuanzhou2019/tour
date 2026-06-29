import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sightour/core/theme/app_colors.dart';
import 'package:sightour/core/theme/app_radius.dart';
import 'package:sightour/core/theme/app_spacing.dart';
import 'package:sightour/l10n/generated/app_localizations.dart';
import 'package:sightour/shared/components/animated_text_section.dart';
import 'package:sightour/shared/components/illustration_banner.dart';
import '../widgets/profile_section.dart';

class YouPage extends StatelessWidget {
  const YouPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.warmSurface,
      body: ListView(
        children: [
          const IllustrationBanner(scene: OnboardingScene.you),
          AnimatedTextSection(
            title: l10n.youTitle,
            subtitle: l10n.youPageSubtitle,
          ),
          const ProfileSection(),
          const SizedBox(height: AppSpacing.s4),
          _YouActionCard(
            icon: Icons.settings_outlined,
            title: l10n.youSettings,
            subtitle: l10n.youSettingsSubtitle,
            onTap: () => context.push('/you/settings'),
          ),
          _YouActionCard(
            icon: Icons.feedback_outlined,
            title: l10n.youFeedback,
            subtitle: l10n.youFeedbackSubtitle,
            onTap: () => context.push('/you/feedback'),
          ),
          const SizedBox(height: AppSpacing.s6),
        ],
      ),
    );
  }
}

class _YouActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _YouActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.fromLTRB(
          AppSpacing.s4,
          0,
          AppSpacing.s4,
          AppSpacing.s3,
        ),
        padding: const EdgeInsets.all(AppSpacing.s4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: AppColors.warmPrimary.withValues(alpha: 0.15),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.warmPrimary.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.warmPrimary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Icon(icon, color: AppColors.warmPrimary, size: 24),
            ),
            const SizedBox(width: AppSpacing.s3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.warmPrimaryDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.slate500,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.slate500),
          ],
        ),
      ),
    );
  }
}
