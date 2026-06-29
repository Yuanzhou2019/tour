import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../l10n/generated/app_localizations.dart';

class PhrasesIndexPage extends StatelessWidget {
  const PhrasesIndexPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    final categories = [
      _Cat('customs', l10n.phrasesCategoryCustoms, Icons.flight_land),
      _Cat('taxi', l10n.phrasesCategoryTaxi, Icons.local_taxi),
      _Cat('dining', l10n.phrasesCategoryDining, Icons.restaurant),
      _Cat('shopping', l10n.phrasesCategoryShopping, Icons.shopping_bag),
      _Cat('medical', l10n.phrasesCategoryMedical, Icons.medical_services),
      _Cat('emergency', l10n.phrasesCategoryEmergency, Icons.warning_amber),
    ];

    return Scaffold(
      backgroundColor: AppColors.warmSurface,
      appBar: AppBar(
        backgroundColor: AppColors.warmSurface,
        title: Text(l10n.phrasesTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.s4),
        children: categories.map((cat) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.s3),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.warmPrimaryLight.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: Icon(cat.icon, color: AppColors.warmPrimaryDark),
                title: Text(cat.label,
                    style: AppTextTheme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.warmPrimaryDark,
                    )),
                trailing: const Icon(Icons.chevron_right,
                    color: AppColors.warmPrimaryDark),
                onTap: () => context.go('/tools/phrases/${cat.id}'),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _Cat {
  final String id;
  final String label;
  final IconData icon;
  const _Cat(this.id, this.label, this.icon);
}
