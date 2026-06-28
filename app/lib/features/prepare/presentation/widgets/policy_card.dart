import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/components/card.dart';
import '../../domain/entities/policy.dart';

class PolicyCard extends StatelessWidget {
  const PolicyCard({required this.policy, this.onTap, super.key});

  final Policy policy;
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
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.s2,
                  vertical: AppSpacing.s1,
                ),
                decoration: BoxDecoration(
                  color: AppColors.sand50,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: Text(
                  policy.country,
                  style: AppTextTheme.textTheme.labelSmall?.copyWith(
                    color: AppColors.sandText,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const Spacer(),
              const Icon(
                Icons.arrow_forward,
                size: 16,
                color: AppColors.slate500,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s3),
          Text(
            policy.title,
            style: AppTextTheme.textTheme.titleMedium?.copyWith(
              color: AppColors.slate900,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (policy.description.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.s1),
            Text(
              policy.description,
              style: AppTextTheme.textTheme.bodySmall?.copyWith(
                color: AppColors.slate500,
              ),
            ),
          ],
          if (policy.source.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.s3),
            Text(
              policy.source,
              style: AppTextTheme.textTheme.labelSmall?.copyWith(
                color: AppColors.slate500,
              ),
            ),
          ],
        ],
      ),
    );
  }
}