import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../l10n/generated/app_localizations.dart';

class ComingSoonPage extends StatelessWidget {
  const ComingSoonPage({required this.title, super.key});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.hourglass_empty, size: 64, color: AppColors.slate300),
            const SizedBox(height: AppSpacing.s4),
            Text(
              AppLocalizations.of(context).commonComingSoon,
              style: AppTextTheme.textTheme.titleLarge,
            ),
          ],
        ),
      ),
    );
  }
}
