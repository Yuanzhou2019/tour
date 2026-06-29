import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../l10n/generated/app_localizations.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.warmSurface,
      appBar: AppBar(
        backgroundColor: AppColors.warmSurface,
        title: Text(l10n.aboutTitle),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.s4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Icon(Icons.explore, size: 64, color: AppColors.warmPrimary),
            ),
            const SizedBox(height: AppSpacing.s4),
            Center(
              child: Text(l10n.aboutVersion,
                  style: AppTextTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.warmPrimaryDark,
                  )),
            ),
            const SizedBox(height: AppSpacing.s5),
            Text(l10n.aboutDescription,
                style: AppTextTheme.textTheme.bodyMedium!
                    .copyWith(color: AppColors.clay600, height: 1.6)),
          ],
        ),
      ),
    );
  }
}
