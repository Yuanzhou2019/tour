import 'package:flutter/material.dart';

import '../../../../l10n/generated/app_localizations.dart';
import '../../../../shared/pages/coming_soon_page.dart';

class YouPage extends StatelessWidget {
  const YouPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ComingSoonPage(
      title: AppLocalizations.of(context).youTitle,
    );
  }
}
