import 'package:flutter/material.dart';

import '../../../../l10n/generated/app_localizations.dart';
import '../../../../shared/pages/coming_soon_page.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ComingSoonPage(
      title: AppLocalizations.of(context).mapTitle,
    );
  }
}
