import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../l10n/generated/app_localizations.dart';

class OnboardingWelcomePage extends StatelessWidget {
  const OnboardingWelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.s6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.travel_explore, size: 80, color: AppColors.blue600),
          const SizedBox(height: AppSpacing.s6),
          Text(
            l.onboardingWelcomeTitle,
            style: AppTextTheme.textTheme.displaySmall,
          ),
          const SizedBox(height: AppSpacing.s4),
          Text(
            l.onboardingWelcomeSubtitle,
            style: AppTextTheme.textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
