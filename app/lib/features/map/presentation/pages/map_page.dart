import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sightour/core/di/injection.dart';
import 'package:sightour/core/theme/app_colors.dart';
import 'package:sightour/core/theme/app_spacing.dart';
import 'package:sightour/core/theme/app_text_styles.dart';
import 'package:sightour/features/map/presentation/cubit/map_home_cubit.dart';
import 'package:sightour/features/map/presentation/widgets/poi_card.dart';
import 'package:sightour/l10n/generated/app_localizations.dart';
import 'package:sightour/shared/components/chip.dart';
import 'package:sightour/shared/components/search_bar.dart';
import 'package:sightour/shared/components/skeleton.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<MapHomeCubit>()..load(),
      child: const _MapView(),
    );
  }
}

class _MapView extends StatefulWidget {
  const _MapView();

  @override
  State<_MapView> createState() => _MapViewState();
}

class _MapViewState extends State<_MapView> {
  final _searchController = TextEditingController();

  static const _categories = <String>[
    'all',
    'attraction',
    'dining',
    'lodging',
    'shopping',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _categoryLabel(String cat) {
    switch (cat) {
      case 'all':
        return 'All';
      case 'attraction':
        return 'Sights';
      case 'dining':
        return 'Eat';
      case 'lodging':
        return 'Stay';
      case 'shopping':
        return 'Shop';
      default:
        return cat;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l.mapTitle)),
      body: BlocBuilder<MapHomeCubit, MapHomeState>(
        builder: (ctx, state) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.s4,
                  AppSpacing.s2,
                  AppSpacing.s4,
                  AppSpacing.s2,
                ),
                child: AppSearchBar(
                  controller: _searchController,
                  placeholder: l.mapSearchHint,
                  onSubmitted: (q) {
                    ctx.read<MapHomeCubit>().setQuery(q);
                    ctx.read<MapHomeCubit>().search();
                  },
                ),
              ),
              SizedBox(
                height: 44,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.s4,
                  ),
                  children: [
                    for (final cat in _categories) ...[
                      AppChip(
                        label: _categoryLabel(cat),
                        selected: state.category == cat,
                        onTap: () =>
                            ctx.read<MapHomeCubit>().setCategory(cat),
                      ),
                      const SizedBox(width: AppSpacing.s2),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.s3),
              Expanded(
                child: state.isLoading
                    ? const AppSkeletonList(count: 4)
                    : state.pois.isEmpty
                        ? Center(
                            child: Text(
                              'No results in this area',
                              style: AppTextTheme.textTheme.bodyMedium
                                  ?.copyWith(color: AppColors.slate500),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.s4,
                            ),
                            itemCount: state.pois.length,
                            itemBuilder: (_, i) => Padding(
                              padding:
                                  const EdgeInsets.only(bottom: AppSpacing.s3),
                              child: PoiCard(poi: state.pois[i]),
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