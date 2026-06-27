import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:sightour/core/router/app_router.dart';
import 'package:sightour/core/router/route_names.dart';
import 'package:sightour/l10n/generated/app_localizations.dart';

void main() {
  group('appRouter', () {
    testWidgets('initial location is /prepare', (tester) async {
      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: appRouter,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      );
      await tester.pump();
      expect(appRouter.routerDelegate.currentConfiguration.uri.path, '/prepare');
    });

    test('all 5 tab paths are registered', () {
      final names = appRouter.configuration.routes
          .whereType<ShellRoute>()
          .expand((shell) => shell.routes)
          .whereType<GoRoute>()
          .map((r) => r.name)
          .toList();
      expect(names, contains(RouteNames.prepare));
      expect(names, contains(RouteNames.map));
      expect(names, contains(RouteNames.discover));
      expect(names, contains(RouteNames.tools));
      expect(names, contains(RouteNames.you));
    });
  });
}
