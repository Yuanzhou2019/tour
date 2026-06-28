import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/components/card.dart';
import '../../domain/entities/discover_card.dart';

class DiscoverCardWidget extends StatelessWidget {
  const DiscoverCardWidget({required this.card, this.onTap, super.key});

  final DiscoverCard card;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  card.title,
                  style: AppTextTheme.textTheme.titleMedium?.copyWith(
                    color: AppColors.slate900,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.s2),
              const Icon(Icons.star, size: 14, color: AppColors.amber500),
              const SizedBox(width: AppSpacing.s1),
              Text(
                card.score.toStringAsFixed(1),
                style: AppTextTheme.textTheme.labelMedium?.copyWith(
                  color: AppColors.slate700,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          if (card.subtitle.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.s1),
            Text(
              card.subtitle,
              style: AppTextTheme.textTheme.bodySmall?.copyWith(
                color: AppColors.slate500,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}