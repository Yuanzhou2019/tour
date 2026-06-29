import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../l10n/generated/app_localizations.dart';
import 'package:sightour/shared/components/skeleton.dart';
import '../../domain/entities/poi_detail.dart';
import '../../domain/repositories/poi_repository.dart';
import '../cubit/poi_detail_cubit.dart';

class PoiReputationPage extends StatelessWidget {
  const PoiReputationPage({required this.poiId, super.key});

  final String poiId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          PoiDetailCubit(getIt<PoiRepository>())
            ..loadReputation(poiId),
      child: const _PoiReputationView(),
    );
  }
}

class _PoiReputationView extends StatelessWidget {
  const _PoiReputationView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return BlocBuilder<PoiDetailCubit, PoiDetailState>(
      builder: (ctx, state) {
        if (state.status == PoiDetailStatus.loading) {
          return Scaffold(
            backgroundColor: AppColors.warmSurface,
            appBar: AppBar(
              backgroundColor: AppColors.warmSurface,
              title: Text(l10n.poiDetailViewReputation),
            ),
            body: const AppSkeletonList(count: 3),
          );
        }
        if (state.status == PoiDetailStatus.error) {
          return Scaffold(
            backgroundColor: AppColors.warmSurface,
            appBar: AppBar(backgroundColor: AppColors.warmSurface),
            body: Center(
              child: Text(state.error!,
                  style: AppTextTheme.textTheme.bodyMedium!
                      .copyWith(color: AppColors.clay600)),
            ),
          );
        }
        if (state.reputation == null) {
          return Scaffold(
            backgroundColor: AppColors.warmSurface,
            appBar: AppBar(backgroundColor: AppColors.warmSurface),
            body: Center(
              child: Text(l10n.commonError,
                  style: AppTextTheme.textTheme.bodyMedium!
                      .copyWith(color: AppColors.slate500)),
            ),
          );
        }
        return _buildContent(ctx, l10n, state.reputation!);
      },
    );
  }

  Widget _buildContent(
      BuildContext ctx, AppLocalizations l10n, PoiDetailReputation rep) {
    final isZh = Localizations.localeOf(ctx).languageCode == 'zh';
    final tips = isZh && rep.experienceTipsZh.isNotEmpty
        ? rep.experienceTipsZh
        : rep.experienceTipsEn;

    return Scaffold(
      backgroundColor: AppColors.warmSurface,
      appBar: AppBar(
        backgroundColor: AppColors.warmSurface,
        title: Text(l10n.poiDetailViewReputation),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.s4),
        children: [
          // Overall score
          _ScoreHeader(score: rep.overallScore.toStringAsFixed(1)),
          if (rep.officialVerified) ...[
            const SizedBox(height: AppSpacing.s3),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.verified,
                    color: AppColors.warmPrimary, size: 20),
                const SizedBox(width: AppSpacing.s1),
                Text(l10n.poiDetailVerified,
                    style: AppTextTheme.textTheme.bodySmall!
                        .copyWith(color: AppColors.warmPrimaryDark)),
              ],
            ),
          ],
          const SizedBox(height: AppSpacing.s6),

          // 5 dimension scores
          _DimensionBar(
            label: l10n.poiDetailCleanliness,
            score: rep.foreignFriendly,
          ),
          const SizedBox(height: AppSpacing.s4),
          _DimensionBar(
            label: l10n.poiDetailLanguage,
            score: rep.languageSupport,
          ),
          const SizedBox(height: AppSpacing.s4),
          _DimensionBar(
            label: l10n.poiDetailPayment,
            score: rep.paymentEase,
          ),
          const SizedBox(height: AppSpacing.s4),
          _DimensionBar(
            label: l10n.poiDetailAuthentic,
            score: rep.authenticity,
          ),
          const SizedBox(height: AppSpacing.s4),
          _DimensionBar(
            label: l10n.poiDetailValue,
            score: rep.value,
          ),
          const SizedBox(height: AppSpacing.s6),

          // Experience tips
          if (tips.isNotEmpty) ...[
            Text(l10n.poiDetailTips,
                style: AppTextTheme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.slate500,
                )),
            const SizedBox(height: AppSpacing.s3),
            ...tips.map((tip) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.s2),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.lightbulb_outline,
                          size: 16, color: AppColors.warmPrimary),
                      const SizedBox(width: AppSpacing.s2),
                      Expanded(
                        child: Text(tip,
                            style: AppTextTheme.textTheme.bodyMedium!
                                .copyWith(color: AppColors.clay600)),
                      ),
                    ],
                  ),
                )),
          ],

          // Updated at
          if (rep.updatedAt != null) ...[
            const SizedBox(height: AppSpacing.s6),
            Text('Updated: ${rep.updatedAt}',
                style: AppTextTheme.textTheme.bodySmall!
                    .copyWith(color: AppColors.slate300)),
          ],
        ],
      ),
    );
  }
}

class _ScoreHeader extends StatelessWidget {
  const _ScoreHeader({required this.score});
  final String score;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.s6, horizontal: AppSpacing.s4),
      decoration: BoxDecoration(
        color: AppColors.warmPrimaryLight.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        children: [
          Text(score,
              style: AppTextTheme.textTheme.displayMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: AppColors.warmPrimaryDark,
              )),
          Text('out of 5.0',
              style: AppTextTheme.textTheme.bodySmall!
                  .copyWith(color: AppColors.slate500)),
        ],
      ),
    );
  }
}

class _DimensionBar extends StatelessWidget {
  const _DimensionBar({required this.label, required this.score});
  final String label;
  final double score;

  @override
  Widget build(BuildContext context) {
    final pct = (score / 5.0).clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: AppTextTheme.textTheme.bodySmall!
                    .copyWith(color: AppColors.slate500)),
            Text(score.toStringAsFixed(1),
                style: AppTextTheme.textTheme.bodySmall!.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.warmPrimaryDark,
                )),
          ],
        ),
        const SizedBox(height: AppSpacing.s1),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          child: LinearProgressIndicator(
            value: pct,
            minHeight: 8,
            backgroundColor: AppColors.slate200,
            valueColor:
                const AlwaysStoppedAnimation<Color>(AppColors.warmPrimary),
          ),
        ),
      ],
    );
  }
}
