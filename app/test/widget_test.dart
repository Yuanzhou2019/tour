import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:sightour/app.dart';
import 'package:sightour/core/di/injection.dart';
import 'package:sightour/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:sightour/features/prepare/domain/entities/checklist_item.dart';
import 'package:sightour/features/prepare/domain/entities/policy.dart';
import 'package:sightour/features/prepare/domain/repositories/checklist_repository.dart';
import 'package:sightour/features/prepare/domain/repositories/policy_repository.dart';
import 'package:sightour/features/prepare/presentation/cubit/prepare_home_cubit.dart';

class _FakePathProvider extends PathProviderPlatform with MockPlatformInterfaceMixin {
  @override
  Future<String?> getApplicationDocumentsPath() async => '.dart_test/app_docs_widget';
  @override
  Future<String?> getTemporaryPath() async => '.dart_test/tmp_widget';
}

class _NoopPolicyRepo implements PolicyRepository {
  const _NoopPolicyRepo();
  @override
  Future<List<Policy>> fetchPolicies(String country) async => const [];
}

class _NoopChecklistRepo implements ChecklistRepository {
  const _NoopChecklistRepo();
  @override
  Future<List<ChecklistItem>> fetchChecklist(String country) async => const [];
}

void main() {
  setUpAll(() async {
    PathProviderPlatform.instance = _FakePathProvider();
    final testPath =
        '.dart_test/hive_widget_${DateTime.now().microsecondsSinceEpoch}';
    Hive.init(testPath);
    await Hive.openBox('prefs');
    await configureDependencies();
    // Skip onboarding redirect for the legacy widget test.
    await getIt<OnboardingRepository>().markCompleted();
    // Always override the real PrepareHomeCubit with a sync no-op so the
    // legacy widget test renders the page immediately without waiting on
    // the (mocked) dio requests to resolve.
    if (getIt.isRegistered<PrepareHomeCubit>()) {
      await getIt.unregister<PrepareHomeCubit>();
    }
    getIt.registerFactory<PrepareHomeCubit>(
      () => PrepareHomeCubit(
        const _NoopPolicyRepo(),
        const _NoopChecklistRepo(),
      ),
    );
  });

  testWidgets('SightourApp launches with Prepare tab and real content',
      (tester) async {
    await tester.pumpWidget(const SightourApp());
    await tester.pump();
    expect(find.text('Prepare · US'), findsOneWidget);
    expect(find.text('What you need to know'), findsOneWidget);
    expect(find.byType(BottomNavigationBar), findsOneWidget);
  });
}