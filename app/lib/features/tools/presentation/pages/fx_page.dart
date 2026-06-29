import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sightour/core/theme/app_colors.dart';
import 'package:sightour/core/theme/app_radius.dart';
import 'package:sightour/core/theme/app_spacing.dart';
import 'package:sightour/core/theme/app_text_styles.dart';

import '../../../../core/di/injection.dart';
import '../../../../l10n/generated/app_localizations.dart';
import 'package:sightour/shared/components/skeleton.dart';
import '../../domain/repositories/fx_repository.dart';
import '../cubit/fx_converter_cubit.dart';

class FxPage extends StatelessWidget {
  const FxPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          FxConverterCubit(getIt<FxRepository>())..load(),
      child: const _FxView(),
    );
  }
}

class _FxView extends StatelessWidget {
  const _FxView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return BlocBuilder<FxConverterCubit, FxConverterState>(
      builder: (ctx, state) {
        return Scaffold(
          backgroundColor: AppColors.warmSurface,
          appBar: AppBar(
            backgroundColor: AppColors.warmSurface,
            title: Text(l10n.fxTitle),
          ),
          body: state.isLoading
              ? const AppSkeletonList(count: 3)
              : Padding(
                  padding: const EdgeInsets.all(AppSpacing.s4),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.s4),
                        decoration: BoxDecoration(
                          color: AppColors.warmPrimaryLight.withValues(alpha: 0.3),
                          borderRadius:
                              BorderRadius.circular(AppRadius.lg),
                        ),
                        child: Column(
                          children: [
                            Text(l10n.toolsFxFrom,
                                style: AppTextTheme.textTheme.bodySmall!
                                    .copyWith(color: AppColors.slate500)),
                            const SizedBox(height: AppSpacing.s2),
                            Text(state.from,
                                style: AppTextTheme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.warmPrimaryDark,
                                )),
                            const SizedBox(height: AppSpacing.s3),
                            Text(l10n.toolsFxTo,
                                style: AppTextTheme.textTheme.bodySmall!
                                    .copyWith(color: AppColors.slate500)),
                            const SizedBox(height: AppSpacing.s2),
                            Text(state.to,
                                style: AppTextTheme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.warmPrimaryDark,
                                )),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.s5),
                      if (state.rate != null)
                        Text(
                          l10n.toolsFxRate(
                              state.from,
                              state.rate!.rate.toStringAsFixed(4),
                              state.to),
                          style: AppTextTheme.textTheme.titleSmall?.copyWith(
                            color: AppColors.warmPrimaryDark,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      if (state.error != null)
                        Text(state.error!,
                            style: AppTextTheme.textTheme.bodyMedium!
                                .copyWith(color: Colors.red.shade400)),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
