import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sightour/l10n/generated/app_localizations.dart';
import '../widgets/profile_section.dart';

class YouPage extends StatelessWidget {
  const YouPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l.youTitle)),
      body: ListView(
        children: [
          const ProfileSection(),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.tune),
            title: Text(l.youPreferencesComingSoon),
            trailing: const Icon(Icons.chevron_right),
            enabled: false,
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.feedback_outlined),
            title: Text(l.youFeedback),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/you/feedback'),
          ),
        ],
      ),
    );
  }
}