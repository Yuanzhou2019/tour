import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sightour/core/di/injection.dart';
import 'package:sightour/core/theme/app_colors.dart';
import 'package:sightour/core/theme/app_radius.dart';
import 'package:sightour/core/theme/app_spacing.dart';
import 'package:sightour/core/theme/app_text_styles.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../domain/entities/discover_card.dart';
import '../cubit/discover_home_cubit.dart';
import 'package:sightour/shared/components/animated_text_section.dart';
import 'package:sightour/shared/components/illustration_banner.dart';
import 'package:sightour/shared/components/skeleton.dart';
import 'package:sightour/shared/components/tabs.dart';

class DiscoverPage extends StatelessWidget {
  const DiscoverPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<DiscoverHomeCubit>(),
      child: const _DiscoverView(),
    );
  }
}

class _DiscoverView extends StatefulWidget {
  const _DiscoverView();

  @override
  State<_DiscoverView> createState() => _DiscoverViewState();
}

class _DiscoverViewState extends State<_DiscoverView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<DiscoverHomeCubit>().selectTab(DiscoverTab.curated);
    });
  }

  String _labelFor(DiscoverTab t) {
    final l10n = AppLocalizations.of(context);
    switch (t) {
      case DiscoverTab.curated:
        return l10n.discoverTabCurated;
      case DiscoverTab.authentic:
        return l10n.discoverTabAuthentic;
      case DiscoverTab.headsUp:
        return l10n.discoverTabHeadsUp;
    }
  }

  IconData _iconFor(DiscoverTab t) {
    switch (t) {
      case DiscoverTab.curated:
        return Icons.explore_outlined;
      case DiscoverTab.authentic:
        return Icons.local_fire_department_outlined;
      case DiscoverTab.headsUp:
        return Icons.warning_amber_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.warmSurface,
      body: BlocBuilder<DiscoverHomeCubit, DiscoverHomeState>(
        builder: (ctx, state) {
          return ListView(
            padding: EdgeInsets.zero,
            children: [
              const IllustrationBanner(scene: OnboardingScene.discover),
              AnimatedTextSection(
                title: l10n.discoverTitle,
                subtitle: 'Curated lists and local picks',
                titleSize: 24,
              ),
              const SizedBox(height: AppSpacing.s4),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.s4,
                ),
                child: AppSegmentedTab<DiscoverTab>(
                  tabs: [
                    (DiscoverTab.curated, _labelFor(DiscoverTab.curated)),
                    (DiscoverTab.authentic, _labelFor(DiscoverTab.authentic)),
                    (DiscoverTab.headsUp, _labelFor(DiscoverTab.headsUp)),
                  ],
                  value: state.tab,
                  onChanged: ctx.read<DiscoverHomeCubit>().selectTab,
                ),
              ),
              const SizedBox(height: AppSpacing.s4),
              if (state.isLoading)
                const AppSkeletonList(count: 4)
              else if (state.cards.isEmpty)
                _EmptyState(message: l10n.discoverEmpty)
              else
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.s4,
                  ),
                  child: Column(
                    children: [
                      for (var i = 0; i < state.cards.length; i++)
                        Padding(
                          padding: const EdgeInsets.only(
                            bottom: AppSpacing.s3,
                          ),
                          child: TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0, end: 1),
                            duration: Duration(milliseconds: 400 + i * 60),
                            curve: Curves.easeOutCubic,
                            builder: (_, v, child) => Opacity(
                              opacity: v,
                              child: Transform.translate(
                                offset: Offset(0, (1 - v) * 20),
                                child: child,
                              ),
                            ),
                            child: _DiscoverRichCard(
                              card: state.cards[i],
                              icon: _iconFor(state.tab),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              const SizedBox(height: AppSpacing.s6),
            ],
          );
        },
      ),
    );
  }
}

class _DiscoverRichCard extends StatelessWidget {
  const _DiscoverRichCard({required this.card, required this.icon});

  final DiscoverCard card;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.warmPrimaryLight, AppColors.warmSurface],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: AppColors.warmPrimary.withValues(alpha: 0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.warmPrimary.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Stack(
          children: [
            // Decorative circle (top-right)
            Positioned(
              top: -22,
              right: -18,
              child: Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.warmPrimary.withValues(alpha: 0.1),
                ),
              ),
            ),
            // Decorative circle (bottom-left)
            Positioned(
              bottom: -18,
              left: -12,
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.warmAccent.withValues(alpha: 0.14),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.s4),
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          AppColors.warmPrimary,
                          AppColors.warmSecondary,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Icon(icon, color: AppColors.white, size: 26),
                  ),
                  const SizedBox(width: AppSpacing.s3),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          card.title,
                          style: AppTextTheme.textTheme.titleMedium?.copyWith(
                            color: AppColors.warmPrimaryDark,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (card.subtitle.isNotEmpty) ...[
                          const SizedBox(height: AppSpacing.s1),
                          Text(
                            card.subtitle,
                            style: AppTextTheme.textTheme.bodySmall?.copyWith(
                              color: AppColors.slate500,
                              fontSize: 13,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.s2),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.s2,
                      vertical: AppSpacing.s1,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.warmAccent.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(AppRadius.full),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.star,
                          size: 14,
                          color: AppColors.warmPrimaryDark,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          card.score.toStringAsFixed(1),
                          style: const TextStyle(
                            color: AppColors.warmPrimaryDark,
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s4,
        vertical: AppSpacing.s10,
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.warmPrimaryLight,
              ),
              child: const Icon(
                Icons.search_off,
                size: 40,
                color: AppColors.warmPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.s3),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextTheme.textTheme.bodyMedium?.copyWith(
                color: AppColors.slate500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
