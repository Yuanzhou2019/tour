import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../l10n/generated/app_localizations.dart';
import 'package:sightour/shared/components/circular_progress_ring.dart';
import 'package:sightour/shared/components/skeleton.dart';
import '../../domain/entities/checklist_item.dart';
import '../../domain/repositories/checklist_repository.dart';
import '../../domain/repositories/policy_repository.dart';
import '../cubit/prepare_home_cubit.dart';

class ChecklistPage extends StatelessWidget {
  const ChecklistPage({required this.country, super.key});

  final String country;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          PrepareHomeCubit(getIt<PolicyRepository>(), getIt<ChecklistRepository>())
            ..load(country: country),
      child: const _ChecklistView(),
    );
  }
}

class _ChecklistView extends StatelessWidget {
  const _ChecklistView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return BlocBuilder<PrepareHomeCubit, PrepareHomeState>(
      builder: (ctx, state) {
        final done = state.checklist.where((i) => i.done).length;
        final total = state.checklist.length;
        final progress = total == 0 ? 0.0 : done / total;

        return Scaffold(
          backgroundColor: AppColors.warmSurface,
          appBar: AppBar(
            backgroundColor: AppColors.warmSurface,
            title: Text(l10n.checklistTitle),
          ),
          body: state.isLoading
              ? const AppSkeletonList(count: 5)
              : state.error != null
                  ? Center(
                      child: Text(state.error!,
                          style: AppTextTheme.textTheme.bodyMedium!
                              .copyWith(color: AppColors.clay600)),
                    )
                  : state.checklist.isEmpty
                      ? Center(
                          child: Text(l10n.checklistEmpty,
                              style: AppTextTheme.textTheme.bodyMedium!
                                  .copyWith(color: AppColors.slate500)),
                        )
                      : ListView(
                          padding: const EdgeInsets.all(AppSpacing.s4),
                          children: [
                            Center(
                              child: Column(
                                children: [
                                  CircularProgressRing(
                                      progress: progress, size: 80),
                                  const SizedBox(height: AppSpacing.s3),
                                  Text(
                                      l10n.prepareChecklistDone(done, total),
                                      style: AppTextTheme.textTheme.bodySmall!
                                          .copyWith(color: AppColors.slate500)),
                                ],
                              ),
                            ),
                            const SizedBox(height: AppSpacing.s5),
                            ...state.checklist.map(
                              (item) => _ChecklistRow(item: item),
                            ),
                          ],
                        ),
        );
      },
    );
  }
}

class _ChecklistRow extends StatelessWidget {
  const _ChecklistRow({required this.item});
  final ChecklistItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.s2),
      decoration: BoxDecoration(
        color: AppColors.warmSurface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.slate200),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.md),
        onTap: () => context.read<PrepareHomeCubit>().toggleItem(item.id),
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.s4, vertical: AppSpacing.s3),
          child: Row(
            children: [
              Icon(
                item.done ? Icons.check_circle : Icons.radio_button_unchecked,
                color: item.done ? AppColors.warmPrimary : AppColors.slate300,
                size: 24,
              ),
              const SizedBox(width: AppSpacing.s3),
              Expanded(
                child: Text(
                  item.title,
                  style: AppTextTheme.textTheme.bodyMedium!.copyWith(
                    color: item.done ? AppColors.slate500 : AppColors.clay600,
                    decoration: item.done ? TextDecoration.lineThrough : null,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
