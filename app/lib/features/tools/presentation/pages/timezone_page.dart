import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../l10n/generated/app_localizations.dart';

class TimezonePage extends StatelessWidget {
  const TimezonePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final now = DateTime.now().toUtc();
    final cst = now.add(const Duration(hours: 8));

    return Scaffold(
      backgroundColor: AppColors.warmSurface,
      appBar: AppBar(
        backgroundColor: AppColors.warmSurface,
        title: Text(l10n.timezoneTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.s4),
        children: [
          Container(
            height: 120,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.warmPrimaryLight, AppColors.warmSurface],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.schedule, size: 32, color: AppColors.warmPrimary),
                  const SizedBox(height: 8),
                  Text(l10n.timezoneChina,
                      style: AppTextTheme.textTheme.titleSmall?.copyWith(
                        color: AppColors.warmPrimaryDark,
                      )),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.s5),
          _TimeCard(
            label: l10n.timezoneCST,
            time:
                '${cst.hour.toString().padLeft(2, '0')}:${cst.minute.toString().padLeft(2, '0')}',
            isActive: true,
          ),
          const SizedBox(height: AppSpacing.s3),
          _TimeCard(
            label: 'UTC',
            time:
                '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}',
            isActive: false,
          ),
        ],
      ),
    );
  }
}

class _TimeCard extends StatelessWidget {
  const _TimeCard({
    required this.label,
    required this.time,
    required this.isActive,
  });
  final String label;
  final String time;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s4),
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.warmPrimaryLight.withValues(alpha: 0.3)
            : AppColors.slate100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: AppTextTheme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: isActive
                    ? AppColors.warmPrimaryDark
                    : AppColors.slate500,
              )),
          Text(time,
              style: AppTextTheme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: isActive
                    ? AppColors.warmPrimaryDark
                    : AppColors.slate500,
              )),
        ],
      ),
    );
  }
}
