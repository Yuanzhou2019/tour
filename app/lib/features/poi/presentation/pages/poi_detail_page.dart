import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../l10n/generated/app_localizations.dart';
import 'package:sightour/shared/components/chip.dart';
import 'package:sightour/shared/components/skeleton.dart';
import '../../domain/entities/poi_detail.dart';
import '../cubit/poi_detail_cubit.dart';
import '../../../../core/di/injection.dart';
import '../../domain/repositories/poi_repository.dart';

class PoiDetailPage extends StatelessWidget {
  const PoiDetailPage({required this.poiId, super.key});

  final String poiId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          PoiDetailCubit(getIt<PoiRepository>())..load(poiId),
      child: const _PoiDetailView(),
    );
  }
}

class _PoiDetailView extends StatelessWidget {
  const _PoiDetailView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return BlocBuilder<PoiDetailCubit, PoiDetailState>(
      builder: (ctx, state) {
        if (state.status == PoiDetailStatus.loading) {
          return _buildLoading();
        }
        if (state.status == PoiDetailStatus.error) {
          return _buildError(ctx, l10n, state.error!);
        }
        if (state.detail == null) {
          return _buildEmpty(l10n);
        }
        return _buildContent(ctx, l10n, state.detail!);
      },
    );
  }

  Widget _buildLoading() {
    return Scaffold(
      backgroundColor: AppColors.warmSurface,
      appBar: AppBar(backgroundColor: AppColors.warmSurface),
      body: const AppSkeletonList(count: 5),
    );
  }

  Widget _buildError(
      BuildContext ctx, AppLocalizations l10n, String error) {
    return Scaffold(
      backgroundColor: AppColors.warmSurface,
      appBar: AppBar(backgroundColor: AppColors.warmSurface),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.s4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.cloud_off, size: 48, color: AppColors.slate300),
              const SizedBox(height: AppSpacing.s3),
              Text(error,
                  textAlign: TextAlign.center,
                  style: AppTextTheme.textTheme.bodyMedium!.copyWith(
                    color: AppColors.clay600,
                  )),
              const SizedBox(height: AppSpacing.s4),
              FilledButton(
                onPressed: () =>
                    ctx.read<PoiDetailCubit>().load(''),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.warmPrimary,
                ),
                child: Text(l10n.commonRetry),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmpty(AppLocalizations l10n) {
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

  Widget _buildContent(
      BuildContext ctx, AppLocalizations l10n, PoiDetail detail) {
    final isZh = Localizations.localeOf(ctx).languageCode == 'zh';
    final name = isZh && detail.nameZh.isNotEmpty
        ? detail.nameZh
        : detail.nameEn;
    final address =
        isZh && detail.addressZh.isNotEmpty ? detail.addressZh : detail.addressEn;
    final description = isZh && detail.descriptionZh != null
        ? detail.descriptionZh!
        : detail.descriptionEn ?? '';

    return Scaffold(
      backgroundColor: AppColors.warmSurface,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: AppColors.warmSurface,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(name,
                  style: AppTextTheme.textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.warmPrimaryDark,
                  )),
              background: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.warmPrimaryLight,
                      AppColors.warmSurface,
                    ],
                  ),
                ),
                child: const Center(
                  child: Icon(Icons.place, size: 64, color: AppColors.warmPrimary),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.s4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category chip
                  AppChip(label: detail.category, selected: true),
                  const SizedBox(height: AppSpacing.s4),

                  // Score
                  if (detail.reputation != null) ...[
                    _buildScoreRow(ctx, l10n, detail),
                    const SizedBox(height: AppSpacing.s4),
                  ],

                  // Reputation link
                  _ActionTile(
                    icon: Icons.star_half,
                    label: l10n.poiDetailViewReputation,
                    onTap: () => ctx.push('/map/poi/${detail.id}/reputation'),
                  ),
                  const SizedBox(height: AppSpacing.s5),

                  // Address
                  _SectionHeader(label: l10n.poiDetailAddress),
                  const SizedBox(height: AppSpacing.s2),
                  Text(address.isNotEmpty ? address : l10n.poiDetailNotAvailable,
                      style: AppTextTheme.textTheme.bodyMedium!
                          .copyWith(color: AppColors.slate700)),
                  const SizedBox(height: AppSpacing.s5),

                  // Description
                  if (description.isNotEmpty) ...[
                    _SectionHeader(label: l10n.poiDetailTitle),
                    const SizedBox(height: AppSpacing.s2),
                    Text(description,
                        style: AppTextTheme.textTheme.bodyMedium!
                            .copyWith(color: AppColors.clay600)),
                    const SizedBox(height: AppSpacing.s5),
                  ],

                  // Contact & Hours
                  if (detail.contact != null || detail.openHours != null) ...[
                    _SectionHeader(label: l10n.poiDetailContact),
                    const SizedBox(height: AppSpacing.s2),
                    if (detail.contact != null)
                      Text(detail.contact!,
                          style: AppTextTheme.textTheme.bodySmall!
                              .copyWith(color: AppColors.slate700)),
                    if (detail.openHours != null) ...[
                      const SizedBox(height: AppSpacing.s1),
                      Text(l10n.poiDetailHours,
                          style: AppTextTheme.textTheme.bodySmall!.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.slate500)),
                      Text(detail.openHours!,
                          style: AppTextTheme.textTheme.bodySmall!
                              .copyWith(color: AppColors.slate700)),
                    ],
                    const SizedBox(height: AppSpacing.s5),
                  ],

                  // Tags
                  if (detail.tags.isNotEmpty) ...[
                    _SectionHeader(label: ''),
                    Wrap(
                      spacing: AppSpacing.s2,
                      runSpacing: AppSpacing.s2,
                      children: detail.tags.map((tag) {
                        final label =
                            isZh && tag.labelZh.isNotEmpty ? tag.labelZh : tag.labelEn;
                        final bgColor = tag.category == 'positive'
                            ? AppColors.warmPrimaryLight
                            : tag.category == 'warning'
                                ? AppColors.slate100
                                : AppColors.clay50;
                        final textColor = tag.category == 'positive'
                            ? AppColors.warmPrimaryDark
                            : tag.category == 'warning'
                                ? AppColors.slate700
                                : AppColors.clay600;
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.s3,
                              vertical: AppSpacing.s1),
                          decoration: BoxDecoration(
                            color: bgColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(label,
                              style: AppTextTheme.textTheme.labelSmall!.copyWith(
                                color: textColor,
                              )),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: AppSpacing.s6),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreRow(
      BuildContext ctx, AppLocalizations l10n, PoiDetail detail) {
    final score = detail.reputation!.overallScore.toStringAsFixed(1);
    return Row(
      children: [
        const Icon(Icons.star, color: AppColors.warmPrimary, size: 22),
        const SizedBox(width: AppSpacing.s2),
        Text(l10n.poiDetailScore(score),
            style: AppTextTheme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.warmPrimaryDark,
            )),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(label,
        style: AppTextTheme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w700,
          color: AppColors.slate500,
          letterSpacing: 0.4,
        ));
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s4, vertical: AppSpacing.s3),
        decoration: BoxDecoration(
          color: AppColors.warmPrimaryLight.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.warmPrimaryDark),
            const SizedBox(width: AppSpacing.s3),
            Expanded(
              child: Text(label,
                  style: AppTextTheme.textTheme.bodyMedium!.copyWith(
                    color: AppColors.warmPrimaryDark,
                    fontWeight: FontWeight.w600,
                  )),
            ),
            const Icon(Icons.chevron_right,
                size: 20, color: AppColors.warmPrimaryDark),
          ],
        ),
      ),
    );
  }
}
