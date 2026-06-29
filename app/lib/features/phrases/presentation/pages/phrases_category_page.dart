import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../l10n/generated/app_localizations.dart';
import 'package:sightour/shared/components/skeleton.dart';
import '../../domain/repositories/phrases_repository.dart';
import '../cubit/phrases_cubit.dart';

class PhrasesCategoryPage extends StatelessWidget {
  const PhrasesCategoryPage({required this.category, super.key});

  final String category;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          PhrasesCubit(getIt<PhrasesRepository>())..loadByCategory(category),
      child: const _PhrasesCategoryView(),
    );
  }
}

class _PhrasesCategoryView extends StatelessWidget {
  const _PhrasesCategoryView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return BlocBuilder<PhrasesCubit, PhrasesState>(
      builder: (ctx, state) {
        return Scaffold(
          backgroundColor: AppColors.warmSurface,
          appBar: AppBar(
            backgroundColor: AppColors.warmSurface,
            title: Text(l10n.phrasesTitle),
          ),
          body: state.isLoading
              ? const AppSkeletonList(count: 5)
              : state.error != null
                  ? Center(
                      child: Text(state.error!,
                          style: AppTextTheme.textTheme.bodyMedium!
                              .copyWith(color: AppColors.clay600)),
                    )
                  : state.phrases.isEmpty
                      ? Center(
                          child: Text(l10n.phrasesEmpty,
                              style: AppTextTheme.textTheme.bodyMedium!
                                  .copyWith(color: AppColors.slate500)),
                        )
                      : ListView(
                          padding: const EdgeInsets.all(AppSpacing.s4),
                          children: state.phrases
                              .map((p) => _PhraseCard(phrase: p))
                              .toList(),
                        ),
        );
      },
    );
  }
}

class _PhraseCard extends StatelessWidget {
  const _PhraseCard({required this.phrase});
  final dynamic phrase; // Phrase

  @override
  Widget build(BuildContext context) {
    final isZh = Localizations.localeOf(context).languageCode == 'zh';
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.s3),
      padding: const EdgeInsets.all(AppSpacing.s4),
      decoration: BoxDecoration(
        color: AppColors.warmSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.slate200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(isZh ? phrase.zh : phrase.en,
              style: AppTextTheme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.clay600,
              )),
          const SizedBox(height: AppSpacing.s1),
          Text(phrase.pinyin,
              style: AppTextTheme.textTheme.bodySmall!
                  .copyWith(color: AppColors.slate500)),
        ],
      ),
    );
  }
}
