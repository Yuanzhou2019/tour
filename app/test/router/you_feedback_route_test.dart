import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_ce/hive.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:sightour/core/di/injection.dart';
import 'package:sightour/core/router/app_router.dart';
import 'package:sightour/core/router/route_names.dart';
import 'package:sightour/core/storage/hive_boxes.dart';
import 'package:sightour/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:sightour/l10n/generated/app_localizations.dart';

class _FakePathProvider extends PathProviderPlatform with MockPlatformInterfaceMixin {
  @override
  Future<String?> getApplicationDocumentsPath() async => '.dart_test/app_docs_you_route';
}

void main() {
  setUpAll(() {
    PathProviderPlatform.instance = _FakePathProvider();
  });

  setUp(() async {
    if (getIt.isRegistered<OnboardingRepository>()) {
      await getIt.reset();
    }
    final p = '.dart_test/hive_you_route_${DateTime.now().microsecondsSinceEpoch}';
    Hive.init(p);
    await Hive.openBox(HiveBoxes.prefs);
    await configureDependencies();
    await getIt<OnboardingRepository>().markCompleted();
    appRouter.go('/you');
  });

  test('feedback is in /you routes', () {
    final names = appRouter.configuration.routes
        .whereType<ShellRoute>()
        .expand((shell) => shell.routes)
        .whereType<GoRoute>()
        .expand((r) => [r, ...r.routes.whereType<GoRoute>()])
        .map((r) => r.name)
        .toList();
    expect(names, contains(RouteNames.feedback));
  });

  testWidgets('navigate /you/feedback succeeds', (tester) async {
    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: appRouter,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    );
    await tester.pumpAndSettle();
    appRouter.go('/you/feedback');
    await tester.pumpAndSettle();
    final loc = appRouter.routerDelegate.currentConfiguration.uri.path;
    expect(loc, '/you/feedback');
  });
}