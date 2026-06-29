import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sightour/core/di/injection.dart';
import 'package:sightour/core/theme/app_colors.dart';
import 'package:sightour/core/theme/app_radius.dart';
import 'package:sightour/core/theme/app_spacing.dart';
import 'package:sightour/core/theme/app_text_styles.dart';
import 'package:sightour/l10n/generated/app_localizations.dart';
import 'package:sightour/shared/components/animated_text_section.dart';
import 'package:sightour/shared/components/illustration_banner.dart';
import 'package:sightour/shared/components/toast.dart';
import '../cubit/fx_converter_cubit.dart';
import '../cubit/tools_home_cubit.dart';
import '../widgets/fx_converter_card.dart';

class ToolsPage extends StatelessWidget {
  const ToolsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<ToolsHomeCubit>()),
        BlocProvider(create: (_) => getIt<FxConverterCubit>()..load()),
      ],
      child: const _ToolsView(),
    );
  }
}

class _ToolsView extends StatelessWidget {
  const _ToolsView();

  static const _gridRowHeight = 140.0;
  static const _gridCrossSpacing = 12.0;
  static const _gridMainSpacing = 12.0;

  double _gridHeightFor(int toolCount) {
    if (toolCount == 0) return 0;
    final rows = (toolCount / 2).ceil();
    return rows * _gridRowHeight + (rows - 1) * _gridMainSpacing;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.warmSurface,
      body: BlocBuilder<ToolsHomeCubit, ToolsHomeState>(
        builder: (ctx, state) {
          final tools = state.entries;
          return ListView(
            padding: EdgeInsets.zero,
            children: [
              const IllustrationBanner(scene: OnboardingScene.tools),
              AnimatedTextSection(
                title: l10n.toolsTitle,
                subtitle: l10n.toolsPageSubtitle,
                titleSize: 24,
              ),
              const SizedBox(height: AppSpacing.s4),
              const _SectionHeader(title: 'Currency', icon: Icons.swap_horiz),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.s4,
                ),
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.s4),
                  decoration: BoxDecoration(
                    color: AppColors.warmPrimaryLight,
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
                  child: const FxConverterCard(),
                ),
              ),
              const SizedBox(height: AppSpacing.s6),
              const _SectionHeader(title: 'All tools', icon: Icons.apps_rounded),
              if (tools.isEmpty)
                const _ToolsEmptyState()
              else
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.s4,
                  ),
                  child: SizedBox(
                    height: _gridHeightFor(tools.length),
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: _gridCrossSpacing,
                        mainAxisSpacing: _gridMainSpacing,
                        childAspectRatio: 1.3,
                      ),
                      itemCount: tools.length,
                      itemBuilder: (_, i) {
                        final entry = tools[i];
                        return TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0, end: 1),
                          duration: Duration(milliseconds: 400 + i * 60),
                          curve: Curves.easeOutCubic,
                          builder: (_, v, child) => Opacity(
                            opacity: v,
                            child: Transform.translate(
                              offset: Offset(0, (1 - v) * 16),
                              child: child,
                            ),
                          ),
                          child: _ToolCard(
                            icon: entry.icon,
                            title: entry.title,
                            subtitle: entry.subtitle,
                            onTap: () => ctx.showAppToast(
                              message: l10n.toolsComingSoon(entry.title),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              const SizedBox(height: AppSpacing.s8),
            ],
          );
        },
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;

  const _SectionHeader({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.s4,
        AppSpacing.s6,
        AppSpacing.s4,
        AppSpacing.s3,
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.warmPrimary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Icon(icon, size: 18, color: AppColors.warmPrimary),
          ),
          const SizedBox(width: AppSpacing.s3),
          Text(
            title,
            style: AppTextTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.warmPrimaryDark,
            ),
          ),
        ],
      ),
    );
  }
}

class _ToolCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ToolCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.s3),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.warmPrimaryLight, AppColors.warmSurface],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: AppColors.warmPrimary.withValues(alpha: 0.15),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.warmPrimary.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.warmPrimary.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.warmPrimary, size: 24),
            ),
            const SizedBox(height: AppSpacing.s3),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.warmPrimaryDark,
              ),
            ),
            const SizedBox(height: AppSpacing.s1),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.slate500,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _ToolsEmptyState extends StatelessWidget {
  const _ToolsEmptyState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s4,
        vertical: AppSpacing.s6,
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
                Icons.handyman_outlined,
                size: 40,
                color: AppColors.warmPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.s3),
            Text(
              'All tools are coming soon',
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