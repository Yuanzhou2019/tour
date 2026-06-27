import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_ce/hive.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:sightour/core/di/injection.dart';
import 'package:sightour/core/router/route_guards.dart';
import 'package:sightour/core/storage/hive_boxes.dart';
import 'package:sightour/features/onboarding/domain/repositories/onboarding_repository.dart';

class _FakePathProvider extends PathProviderPlatform with MockPlatformInterfaceMixin {
  @override
  Future<String?> getApplicationDocumentsPath() async =>
      '.dart_test/app_docs_redirect_${DateTime.now().microsecondsSinceEpoch}';
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
        '.dart_test/hive_redirect_${DateTime.now().microsecondsSinceEpoch}';
    Hive.init(p);
    await Hive.openBox(HiveBoxes.prefs);
    await configureDependencies();
  }

  test('Uncompleted onboarding: redirect /prepare → /onboarding', () async {
    await _setup();
    final state = _StubState('/prepare');
    final result = onboardingRedirect(_StubContext(), state);
    expect(result, '/onboarding');
  });

  test('Completed onboarding: no redirect for /prepare', () async {
    await _setup();
    await getIt<OnboardingRepository>().markCompleted();
    final state = _StubState('/prepare');
    final result = onboardingRedirect(_StubContext(), state);
    expect(result, isNull);
  });
}

class _StubContext implements BuildContext {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _StubState implements GoRouterState {
  _StubState(this.matchedLocation);

  @override
  final String matchedLocation;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
