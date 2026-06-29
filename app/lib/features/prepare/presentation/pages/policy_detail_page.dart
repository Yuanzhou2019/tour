import 'package:flutter/material.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../l10n/generated/app_localizations.dart';
import 'package:sightour/shared/components/skeleton.dart';
import '../../data/repositories/policy_repository_impl.dart';
import '../../domain/entities/policy.dart';
import '../../domain/repositories/policy_repository.dart';

class PolicyDetailPage extends StatelessWidget {
  const PolicyDetailPage({required this.policyId, super.key});

  final String policyId;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Policy>(
      future:
          PolicyRepositoryImpl(getIt()).fetchPolicyById(policyId),
      builder: (ctx, snapshot) {
        final l10n = AppLocalizations.of(ctx);
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: AppColors.warmSurface,
            appBar: AppBar(backgroundColor: AppColors.warmSurface),
            body: const AppSkeletonList(count: 3),
          );
        }
        if (snapshot.hasError || snapshot.data == null) {
          return Scaffold(
            backgroundColor: AppColors.warmSurface,
            appBar: AppBar(
              backgroundColor: AppColors.warmSurface,
              title: Text(l10n.policyDetailTitle),
            ),
            body: Center(
              child: Text(snapshot.error?.toString() ?? l10n.commonError,
                  style: AppTextTheme.textTheme.bodyMedium!
                      .copyWith(color: AppColors.clay600)),
            ),
          );
        }
        return _buildContent(ctx, l10n, snapshot.data!);
      },
    );
  }

  Widget _buildContent(BuildContext ctx, AppLocalizations l10n, Policy policy) {
    return Scaffold(
      backgroundColor: AppColors.warmSurface,
      appBar: AppBar(
        backgroundColor: AppColors.warmSurface,
        title: Text(l10n.policyDetailTitle),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.s4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.s4),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.warmPrimaryLight, AppColors.warmSurface],
                ),
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              child: Text(policy.title,
                  style: AppTextTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.warmPrimaryDark,
                  )),
            ),
            const SizedBox(height: AppSpacing.s5),
            Text(policy.description,
                style: AppTextTheme.textTheme.bodyMedium!
                    .copyWith(color: AppColors.clay600, height: 1.6)),
            if (policy.source.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.s5),
              Text(l10n.policyDetailSource,
                  style: AppTextTheme.textTheme.bodySmall!.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.slate500)),
              const SizedBox(height: AppSpacing.s1),
              Text(policy.source,
                  style: AppTextTheme.textTheme.bodySmall!
                      .copyWith(color: AppColors.slate500)),
            ],
          ],
        ),
      ),
    );
  }
}
