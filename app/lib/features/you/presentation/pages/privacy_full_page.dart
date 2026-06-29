import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../l10n/generated/app_localizations.dart';

class PrivacyFullPage extends StatelessWidget {
  const PrivacyFullPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.warmSurface,
      appBar: AppBar(
        backgroundColor: AppColors.warmSurface,
        title: Text(l10n.privacyFullTitle),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.s4),
        child: Text(l10n.privacyFullContent,
            style: AppTextTheme.textTheme.bodyMedium!
                .copyWith(color: AppColors.clay600, height: 1.6)),
      ),
    );
  }
}
