import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sightour/core/di/injection.dart';
import 'package:sightour/core/theme/app_colors.dart';
import 'package:sightour/core/theme/app_radius.dart';
import 'package:sightour/core/theme/app_spacing.dart';
import 'package:sightour/core/theme/app_text_styles.dart';
import 'package:sightour/features/prepare/domain/entities/checklist_item.dart';
import 'package:sightour/features/prepare/presentation/cubit/prepare_home_cubit.dart';
import 'package:sightour/features/prepare/presentation/widgets/policy_card.dart';
import 'package:sightour/l10n/generated/app_localizations.dart';
import 'package:sightour/shared/components/button.dart';
import 'package:sightour/shared/components/list_item.dart';
import 'package:sightour/shared/components/progress_bar.dart';
import 'package:sightour/shared/components/skeleton.dart';
import 'package:sightour/shared/components/toast.dart';

class PreparePage extends StatelessWidget {
  const PreparePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<PrepareHomeCubit>()..load(),
      child: const _PrepareView(),
    );
  }
}

class _PrepareView extends StatelessWidget {
  const _PrepareView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).prepareTitle('US')),
      ),
      body: BlocBuilder<PrepareHomeCubit, PrepareHomeState>(
        builder: (ctx, state) {
          if (state.isLoading) {
            return const AppSkeletonList(count: 4);
          }
          if (state.error != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.s4),
                child: Text(
                  state.error!,
                  style: AppTextTheme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.clay600,
                  ),
                ),
              ),
            );
          }
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.s4),
            children: [
              _CountryBadge(country: state.country),
              const SizedBox(height: AppSpacing.s4),
              const _SectionHeader(title: 'What you need to know'),
              if (state.policies.isEmpty)
                _EmptyHint(text: 'No policy info for ${state.country} yet'),
              ...state.policies.map(
                (p) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.s3),
                  child: PolicyCard(policy: p),
                ),
              ),
              const SizedBox(height: AppSpacing.s4),
              const _SectionHeader(title: 'Pre-arrival checklist'),
              ...state.checklist.map(
                (i) => _ChecklistRow(item: i),
              ),
              if (state.checklist.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.s3),
                _ChecklistProgress(items: state.checklist),
              ],
              const SizedBox(height: AppSpacing.s4),
              const _SectionHeader(title: 'Offline downloads'),
              AppListItem(
                leading: const Icon(Icons.download_outlined),
                title: 'Shanghai core pack',
                subtitle: '12 MB · maps + phrases + emergency',
                onTap: () => ctx.showAppToast(
                  message: 'Download will start soon',
                ),
              ),
              const SizedBox(height: AppSpacing.s6),
              Center(
                child: AppButton(
                  label: 'View all downloads',
                  variant: ButtonVariant.secondary,
                  onPressed: () => ctx.showAppToast(
                    message: 'Downloads page coming soon',
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _CountryBadge extends StatelessWidget {
  const _CountryBadge({required this.country});

  final String country;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s3,
        vertical: AppSpacing.s2,
      ),
      decoration: BoxDecoration(
        color: AppColors.blue50,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.public, size: 16, color: AppColors.blue600),
          const SizedBox(width: AppSpacing.s1),
          Text(
            'Passport · $country',
            style: AppTextTheme.textTheme.labelMedium?.copyWith(
              color: AppColors.blue600,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.s2),
      child: Text(
        title,
        style: AppTextTheme.textTheme.titleSmall?.copyWith(
          color: AppColors.slate500,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}

class _EmptyHint extends StatelessWidget {
  const _EmptyHint({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.s4),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: AppTextTheme.textTheme.bodyMedium?.copyWith(
          color: AppColors.slate500,
        ),
      ),
    );
  }
}

class _ChecklistRow extends StatelessWidget {
  const _ChecklistRow({required this.item});

  final ChecklistItem item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.s1),
      child: Row(
        children: [
          Checkbox(
            value: item.done,
            onChanged: (_) =>
                context.read<PrepareHomeCubit>().toggleItem(item.id),
          ),
          Expanded(
            child: Text(
              item.title,
              style: AppTextTheme.textTheme.bodyLarge?.copyWith(
                color: AppColors.slate900,
                decoration: item.done ? TextDecoration.lineThrough : null,
                decorationColor: AppColors.slate500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChecklistProgress extends StatelessWidget {
  const _ChecklistProgress({required this.items});

  final List<ChecklistItem> items;

  @override
  Widget build(BuildContext context) {
    final done = items.where((i) => i.done).length;
    final progress = items.isEmpty ? 0.0 : done / items.length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppProgressBar(value: progress),
        const SizedBox(height: AppSpacing.s1),
        Text(
          '$done / ${items.length} done',
          style: AppTextTheme.textTheme.bodySmall?.copyWith(
            color: AppColors.slate500,
          ),
        ),
      ],
    );
  }
}