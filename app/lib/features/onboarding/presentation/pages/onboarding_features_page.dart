import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../shared/components/animated_text_section.dart';
import '../../../../shared/components/illustration_banner.dart';

class OnboardingFeaturesPage extends StatelessWidget {
  const OnboardingFeaturesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      children: [
        const IllustrationBanner(scene: OnboardingScene.features),
        AnimatedTextSection(
          title: l10n.onboardingFeaturesTitle,
          subtitle: l10n.onboardingFeaturesSubtitle,
        ),
      ],
    );
  }
}
