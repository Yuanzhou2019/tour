import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../l10n/generated/app_localizations.dart';
import 'package:sightour/shared/components/skeleton.dart';
import '../../data/repositories/discover_repository_impl.dart';
import '../../domain/repositories/discover_repository.dart';
import '../../domain/entities/discover_card.dart';

class RankCategoryPage extends StatelessWidget {
  const RankCategoryPage({required this.category, super.key});

  final String category;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return FutureBuilder<List<DiscoverCard>>(
      future: _fetchCards(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: AppColors.warmSurface,
            appBar: AppBar(
              backgroundColor: AppColors.warmSurface,
              title: Text(l10n.rankTitle),
            ),
            body: const AppSkeletonList(count: 4),
          );
        }
        final cards = snapshot.data ?? [];
        return Scaffold(
          backgroundColor: AppColors.warmSurface,
          appBar: AppBar(
            backgroundColor: AppColors.warmSurface,
            title: Text(l10n.rankTitle),
          ),
          body: cards.isEmpty
              ? Center(
                  child: Text(l10n.rankEmpty,
                      style: AppTextTheme.textTheme.bodyMedium!
                          .copyWith(color: AppColors.slate500)),
                )
              : ListView(
                  padding: const EdgeInsets.all(AppSpacing.s4),
                  children: cards
                      .map((card) => _RankCard(card: card))
                      .toList(),
                ),
        );
      },
    );
  }

  Future<List<DiscoverCard>> _fetchCards() async {
    final repo = DiscoverRepositoryImpl(getIt());
    switch (category) {
      case 'authentic':
        return repo.authentic();
      case 'heads-up':
        return repo.headsUp();
      default:
        return repo.curated();
    }
  }
}

class _RankCard extends StatelessWidget {
  const _RankCard({required this.card});
  final DiscoverCard card;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.s3),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.warmPrimaryLight, AppColors.warmSurface],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: [
          BoxShadow(
            color: AppColors.warmPrimary.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.s4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(card.title,
                      style: AppTextTheme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.warmPrimaryDark,
                      )),
                ),
                Row(
                  children: [
                    const Icon(Icons.star,
                        size: 16, color: AppColors.warmPrimary),
                    const SizedBox(width: 4),
                    Text(card.score.toStringAsFixed(1),
                        style: AppTextTheme.textTheme.bodySmall!.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.warmPrimaryDark,
                        )),
                  ],
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.s2),
            Text(card.subtitle,
                style: AppTextTheme.textTheme.bodySmall!
                    .copyWith(color: AppColors.slate500)),
          ],
        ),
      ),
    );
  }
}

