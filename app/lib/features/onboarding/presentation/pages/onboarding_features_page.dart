import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../l10n/generated/app_localizations.dart';

class OnboardingFeaturesPage extends StatelessWidget {
  const OnboardingFeaturesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final features = <_FeatureItem>[
      _FeatureItem(
        icon: Icons.flight_takeoff,
        title: l.onboardingFeaturesPrepareTitle,
        desc: l.onboardingFeaturesPrepareDesc,
      ),
      _FeatureItem(
        icon: Icons.map_outlined,
        title: l.onboardingFeaturesMapTitle,
        desc: l.onboardingFeaturesMapDesc,
      ),
      _FeatureItem(
        icon: Icons.explore_outlined,
        title: l.onboardingFeaturesDiscoverTitle,
        desc: l.onboardingFeaturesDiscoverDesc,
      ),
      _FeatureItem(
        icon: Icons.build_outlined,
        title: l.onboardingFeaturesToolsTitle,
        desc: l.onboardingFeaturesToolsDesc,
      ),
    ];
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.s6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.onboardingFeaturesTitle,
            style: AppTextTheme.textTheme.headlineLarge,
          ),
          const SizedBox(height: AppSpacing.s6),
          Expanded(
            child: ListView.separated(
              itemCount: features.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: AppSpacing.s4),
              itemBuilder: (_, i) {
                final f = features[i];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppSpacing.s2,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(f.icon, color: AppColors.blue600, size: 28),
                      const SizedBox(width: AppSpacing.s3),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              f.title,
                              style: AppTextTheme.textTheme.titleLarge,
                            ),
                            const SizedBox(height: AppSpacing.s1),
                            Text(
                              f.desc,
                              style: AppTextTheme.textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureItem {
  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.desc,
  });
  final IconData icon;
  final String title;
  final String desc;
}
