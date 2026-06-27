import 'package:flutter/material.dart';
import 'package:sightour/core/storage/anonymous_id.dart';
import 'package:sightour/core/theme/app_spacing.dart';
import 'package:sightour/core/theme/app_text_styles.dart';
import 'package:sightour/l10n/generated/app_localizations.dart';

class ProfileSection extends StatelessWidget {
  const ProfileSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final anonId = AnonymousId.get();
    final display = anonId.length > 12 ? '${anonId.substring(0, 12)}…' : anonId;
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.s4),
      child: Row(
        children: [
          const CircleAvatar(child: Icon(Icons.person_outline)),
          const SizedBox(width: AppSpacing.s3),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l.youTitle, style: AppTextTheme.textTheme.titleLarge),
              const SizedBox(height: AppSpacing.s1),
              Text('${l.youProfileAnonymousId}: $display',
                  style: AppTextTheme.textTheme.bodySmall),
            ],
          ),
        ],
      ),
    );
  }
}