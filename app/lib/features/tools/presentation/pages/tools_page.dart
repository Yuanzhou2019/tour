import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sightour/core/di/injection.dart';
import 'package:sightour/core/theme/app_colors.dart';
import 'package:sightour/core/theme/app_spacing.dart';
import 'package:sightour/core/theme/app_text_styles.dart';
import 'package:sightour/features/tools/presentation/cubit/fx_converter_cubit.dart';
import 'package:sightour/features/tools/presentation/cubit/tools_home_cubit.dart';
import 'package:sightour/features/tools/presentation/widgets/fx_converter_card.dart';
import 'package:sightour/l10n/generated/app_localizations.dart';
import 'package:sightour/shared/components/list_item.dart';
import 'package:sightour/shared/components/toast.dart';

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

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l.toolsTitle)),
      body: BlocBuilder<ToolsHomeCubit, ToolsHomeState>(
        builder: (ctx, state) {
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.s4),
            children: [
              Text(
                'CURRENCY',
                style: AppTextTheme.textTheme.titleSmall?.copyWith(
                  color: AppColors.slate500,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.4,
                ),
              ),
              const SizedBox(height: AppSpacing.s2),
              const FxConverterCard(),
              const SizedBox(height: AppSpacing.s6),
              Text(
                'ALL TOOLS',
                style: AppTextTheme.textTheme.titleSmall?.copyWith(
                  color: AppColors.slate500,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.4,
                ),
              ),
              const SizedBox(height: AppSpacing.s2),
              for (final entry in state.entries) ...[
                AppListItem(
                  leading: Icon(entry.icon),
                  title: entry.title,
                  subtitle: entry.subtitle,
                  onTap: () => ctx.showAppToast(
                    message: '${entry.title} is coming soon',
                  ),
                ),
                const SizedBox(height: AppSpacing.s2),
              ],
            ],
          );
        },
      ),
    );
  }
}