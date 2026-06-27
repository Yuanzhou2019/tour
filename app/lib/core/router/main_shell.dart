import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/generated/app_localizations.dart';

class MainShell extends StatelessWidget {
  const MainShell({required this.child, super.key});
  final Widget child;

  static const _tabs = <_TabSpec>[
    _TabSpec(path: '/prepare', icon: Icons.flight_takeoff, labelKey: 'tabPrepare'),
    _TabSpec(path: '/map', icon: Icons.map_outlined, labelKey: 'tabMap'),
    _TabSpec(path: '/discover', icon: Icons.explore_outlined, labelKey: 'tabDiscover'),
    _TabSpec(path: '/tools', icon: Icons.build_outlined, labelKey: 'tabTools'),
    _TabSpec(path: '/you', icon: Icons.person_outline, labelKey: 'tabYou'),
  ];

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final i = _tabs.indexWhere((t) => location.startsWith(t.path));
    return i < 0 ? 0 : i;
  }

  String _labelFor(AppLocalizations l10n, String key) {
    switch (key) {
      case 'tabPrepare':
        return l10n.tabPrepare;
      case 'tabMap':
        return l10n.tabMap;
      case 'tabDiscover':
        return l10n.tabDiscover;
      case 'tabTools':
        return l10n.tabTools;
      case 'tabYou':
        return l10n.tabYou;
      default:
        return key;
    }
  }

  @override
  Widget build(BuildContext context) {
    final i = _currentIndex(context);
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: i,
        onTap: (idx) => context.go(_tabs[idx].path),
        items: _tabs
            .map((t) => BottomNavigationBarItem(
                  icon: Icon(t.icon),
                  label: _labelFor(l10n, t.labelKey),
                ))
            .toList(),
      ),
    );
  }
}

class _TabSpec {
  const _TabSpec({required this.path, required this.icon, required this.labelKey});
  final String path;
  final IconData icon;
  final String labelKey;
}
