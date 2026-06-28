import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sightour/core/di/injection.dart';
import 'package:sightour/core/theme/app_colors.dart';
import 'package:sightour/core/theme/app_spacing.dart';
import 'package:sightour/core/theme/app_text_styles.dart';
import 'package:sightour/features/discover/presentation/cubit/discover_home_cubit.dart';
import 'package:sightour/features/discover/presentation/widgets/discover_card_widget.dart';
import 'package:sightour/l10n/generated/app_localizations.dart';
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
    switch (t) {
      case DiscoverTab.curated:
        return 'Curated';
      case DiscoverTab.authentic:
        return 'Authentic';
      case DiscoverTab.headsUp:
        return 'Heads-up';
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l.discoverTitle)),
      body: BlocBuilder<DiscoverHomeCubit, DiscoverHomeState>(
        builder: (ctx, state) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(AppSpacing.s4),
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
              Expanded(
                child: state.isLoading
                    ? const AppSkeletonList(count: 4)
                    : state.cards.isEmpty
                        ? Center(
                            child: Text(
                              'Nothing here yet',
                              style: AppTextTheme.textTheme.bodyMedium
                                  ?.copyWith(color: AppColors.slate500),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.s4,
                            ),
                            itemCount: state.cards.length,
                            itemBuilder: (_, i) => Padding(
                              padding:
                                  const EdgeInsets.only(bottom: AppSpacing.s3),
                              child: DiscoverCardWidget(card: state.cards[i]),
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