import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_ce/hive.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:sightour/core/di/injection.dart';
import 'package:sightour/core/router/app_router.dart';
import 'package:sightour/core/router/route_names.dart';
import 'package:sightour/core/storage/hive_boxes.dart';
import 'package:sightour/features/discover/presentation/cubit/discover_home_cubit.dart';
import 'package:sightour/features/map/presentation/cubit/map_home_cubit.dart';
import 'package:sightour/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:sightour/features/prepare/presentation/cubit/prepare_home_cubit.dart';
import 'package:sightour/features/tools/presentation/cubit/fx_converter_cubit.dart';
import 'package:sightour/features/tools/presentation/cubit/tools_home_cubit.dart';

class _FakePathProvider extends PathProviderPlatform with MockPlatformInterfaceMixin {
  @override
  Future<String?> getApplicationDocumentsPath() async =>
      '.dart_test/app_docs_stage2_routes';
}

void main() {
  setUpAll(() {
    PathProviderPlatform.instance = _FakePathProvider();
  });

  Future<void> _setup() async {
    if (getIt.isRegistered<OnboardingRepository>()) {
      await getIt.reset();
    }
    final p =
        '.dart_test/hive_stage2_routes_${DateTime.now().microsecondsSinceEpoch}';
    Hive.init(p);
    await Hive.openBox(HiveBoxes.prefs);
    await configureDependencies();
    await getIt<OnboardingRepository>().markCompleted();
  }

  test('Prepare/Map/Discover/Tools cubits are registered in DI', () async {
    await _setup();
    expect(getIt.isRegistered<PrepareHomeCubit>(), isTrue);
    expect(getIt.isRegistered<MapHomeCubit>(), isTrue);
    expect(getIt.isRegistered<DiscoverHomeCubit>(), isTrue);
    expect(getIt.isRegistered<ToolsHomeCubit>(), isTrue);
    expect(getIt.isRegistered<FxConverterCubit>(), isTrue);
  });

  test('Prepare/Map/Discover/Tools tab names are in router config', () async {
    await _setup();
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
  });

  test('Prepare route is registered at /prepare', () {
    final route = appRouter.configuration.routes
        .whereType<ShellRoute>()
        .expand((shell) => shell.routes)
        .whereType<GoRoute>()
        .where((r) => r.path == '/prepare')
        .firstOrNull;
    expect(route, isNotNull);
    expect(route!.name, RouteNames.prepare);
  });

  test('Map route is registered at /map', () {
    final route = appRouter.configuration.routes
        .whereType<ShellRoute>()
        .expand((shell) => shell.routes)
        .whereType<GoRoute>()
        .where((r) => r.path == '/map')
        .firstOrNull;
    expect(route, isNotNull);
    expect(route!.name, RouteNames.map);
  });

  test('Discover route is registered at /discover', () {
    final route = appRouter.configuration.routes
        .whereType<ShellRoute>()
        .expand((shell) => shell.routes)
        .whereType<GoRoute>()
        .where((r) => r.path == '/discover')
        .firstOrNull;
    expect(route, isNotNull);
    expect(route!.name, RouteNames.discover);
  });

  test('Tools route is registered at /tools', () {
    final route = appRouter.configuration.routes
        .whereType<ShellRoute>()
        .expand((shell) => shell.routes)
        .whereType<GoRoute>()
        .where((r) => r.path == '/tools')
        .firstOrNull;
    expect(route, isNotNull);
    expect(route!.name, RouteNames.tools);
  });
}