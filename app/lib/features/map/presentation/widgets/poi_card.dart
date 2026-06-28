import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/components/card.dart';
import '../../domain/entities/poi.dart';

class PoiCard extends StatelessWidget {
  const PoiCard({required this.poi, this.onTap, super.key});

  final Poi poi;
  final VoidCallback? onTap;

  IconData get _icon => switch (poi.category) {
        'dining' => Icons.restaurant,
        'lodging' => Icons.hotel,
        'shopping' => Icons.shopping_bag,
        _ => Icons.place_outlined,
      };

  String get _categoryLabel => switch (poi.category) {
        'attraction' => 'Sights',
        'dining' => 'Eat',
        'lodging' => 'Stay',
        'shopping' => 'Shop',
        _ => poi.category,
      };

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.sand50,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Icon(_icon, color: AppColors.sandText, size: 22),
          ),
          const SizedBox(width: AppSpacing.s3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  poi.name,
                  style: AppTextTheme.textTheme.titleMedium?.copyWith(
                    color: AppColors.slate900,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.s1),
                Text(
                  '$_categoryLabel · ${poi.distanceKm.toStringAsFixed(1)} km away',
                  style: AppTextTheme.textTheme.bodySmall?.copyWith(
                    color: AppColors.slate500,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              const Icon(Icons.star, size: 14, color: AppColors.amber500),
              const SizedBox(width: AppSpacing.s1),
              Text(
                poi.avgScore.toStringAsFixed(1),
                style: AppTextTheme.textTheme.labelMedium?.copyWith(
                  color: AppColors.slate700,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}