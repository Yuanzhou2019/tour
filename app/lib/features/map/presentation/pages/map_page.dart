import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sightour/core/di/injection.dart';
import 'package:sightour/core/theme/app_colors.dart';
import 'package:sightour/core/theme/app_radius.dart';
import 'package:sightour/core/theme/app_spacing.dart';
import 'package:sightour/l10n/generated/app_localizations.dart';
import 'package:sightour/shared/components/animated_text_section.dart';
import 'package:sightour/shared/components/illustration_banner.dart';
import 'package:sightour/shared/components/search_bar.dart';
import 'package:sightour/shared/components/skeleton.dart';
import '../../domain/entities/poi.dart';
import '../cubit/map_home_cubit.dart';

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

  String _categoryLabel(AppLocalizations l10n, String cat) {
    switch (cat) {
      case 'all':
        return l10n.mapCategoryAll;
      case 'attraction':
        return l10n.mapCategoryAttraction;
      case 'dining':
        return l10n.mapCategoryDining;
      case 'lodging':
        return l10n.mapCategoryLodging;
      case 'shopping':
        return l10n.mapCategoryShopping;
      default:
        return cat;
    }
  }

  IconData _iconForCategory(String cat) {
    switch (cat) {
      case 'attraction':
        return Icons.attractions_outlined;
      case 'dining':
        return Icons.restaurant_outlined;
      case 'lodging':
        return Icons.hotel_outlined;
      case 'shopping':
        return Icons.shopping_bag_outlined;
      default:
        return Icons.location_on_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.warmSurface,
      body: BlocBuilder<MapHomeCubit, MapHomeState>(
        builder: (ctx, state) {
          return Column(
            children: [
              const IllustrationBanner(scene: OnboardingScene.map),
              AnimatedTextSection(
                title: l10n.mapTitle,
                subtitle: l10n.mapPageSubtitle,
              ),
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.s4,
                  vertical: AppSpacing.s2,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: AppSearchBar(
                  controller: _searchController,
                  placeholder: l10n.mapSearchHint,
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
                      _CategoryChip(
                        label: _categoryLabel(l10n, cat),
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
                        ? _EmptyState(text: l10n.mapEmpty)
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.s4,
                            ),
                            itemCount: state.pois.length,
                            itemBuilder: (_, i) => _PoiRow(
                              poi: state.pois[i],
                              iconForCategory: _iconForCategory,
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

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.warmPrimary : AppColors.warmPrimaryLight,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected
                ? AppColors.warmPrimary
                : AppColors.warmPrimary.withValues(alpha: 0.3),
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            color: selected ? Colors.white : AppColors.warmPrimaryDark,
          ),
        ),
      ),
    );
  }
}

class _PoiRow extends StatelessWidget {
  const _PoiRow({required this.poi, required this.iconForCategory});

  final Poi poi;
  final IconData Function(String) iconForCategory;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // TODO navigate to detail
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.s3),
        padding: const EdgeInsets.all(AppSpacing.s3),
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
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.warmPrimary.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                iconForCategory(poi.category),
                color: AppColors.warmPrimary,
                size: 24,
              ),
            ),
            const SizedBox(width: AppSpacing.s3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    poi.name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.warmPrimaryDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: AppColors.warmAccent,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${poi.avgScore.toStringAsFixed(1)} · ${poi.distanceKm.toStringAsFixed(1)} km',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.slate500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: AppColors.warmPrimary,
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: const BoxDecoration(
              color: AppColors.warmPrimaryLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.location_off,
              color: AppColors.warmPrimary,
              size: 36,
            ),
          ),
          const SizedBox(height: AppSpacing.s3),
          Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.slate500,
            ),
          ),
        ],
      ),
    );
  }
}
