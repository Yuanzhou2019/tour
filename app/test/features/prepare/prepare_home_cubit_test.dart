import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:sightour/core/network/dio_client.dart';
import 'package:sightour/core/network/interceptors/auth_interceptor.dart';
import 'package:sightour/core/network/interceptors/error_interceptor.dart';
import 'package:sightour/core/network/interceptors/logging_interceptor.dart';
import 'package:sightour/core/network/interceptors/mock_interceptor.dart';
import 'package:sightour/core/network/interceptors/retry_interceptor.dart';
import 'package:sightour/core/storage/hive_boxes.dart';
import 'package:sightour/features/prepare/data/repositories/checklist_repository_impl.dart';
import 'package:sightour/features/prepare/data/repositories/policy_repository_impl.dart';
import 'package:sightour/features/prepare/domain/repositories/checklist_repository.dart';
import 'package:sightour/features/prepare/domain/repositories/policy_repository.dart';
import 'package:sightour/features/prepare/presentation/cubit/prepare_home_cubit.dart';

class _FakePathProvider extends PathProviderPlatform with MockPlatformInterfaceMixin {
  @override
  Future<String?> getApplicationDocumentsPath() async =>
      '.dart_test/app_docs_prepare_cubit';
}

void main() {
  setUpAll(() {
    PathProviderPlatform.instance = _FakePathProvider();
    Hive.init('.dart_test/hive_prepare_cubit_${DateTime.now().microsecondsSinceEpoch}');
  });

  setUp(() async {
    if (Hive.isBoxOpen(HiveBoxes.prefs)) {
      await Hive.box(HiveBoxes.prefs).close();
    }
    await Hive.openBox(HiveBoxes.prefs);
  });

  PrepareHomeCubit makeCubit() {
    final client = DioClient(
      AuthInterceptor(),
      LoggingInterceptor(),
      ErrorInterceptor(),
      MockInterceptor(),
      RetryInterceptor(),
    );
    final PolicyRepository policyRepo = PolicyRepositoryImpl(client);
    final ChecklistRepository checklistRepo = ChecklistRepositoryImpl(client);
    return PrepareHomeCubit(policyRepo, checklistRepo);
  }

  test('default state', () {
    final c = makeCubit();
    expect(c.state.country, 'US');
    expect(c.state.policies, isEmpty);
    expect(c.state.checklist, isEmpty);
    expect(c.state.isLoading, false);
    expect(c.state.error, isNull);
  });

  test('load() returns US policy cards via mock interceptor', () async {
    final c = makeCubit();
    await c.load();
    expect(c.state.isLoading, false);
    expect(c.state.error, isNull);
    expect(c.state.policies, isNotEmpty);
    expect(c.state.policies.first.id, 'us-visa-free-30d');
    expect(c.state.checklist, isNotEmpty);
  });

  test('load(country: "RU") switches to RU visa-required policy', () async {
    final c = makeCubit();
    await c.load(country: 'RU');
    expect(c.state.country, 'RU');
    expect(c.state.policies.first.id, 'ru-visa-required');
    // RU gets an extra checklist row for visa application lead time.
    expect(
      c.state.checklist.any((i) => i.id == 'visa-application'),
      isTrue,
    );
  });

  test('load(country: "XX") returns generic fallback policy', () async {
    final c = makeCubit();
    await c.load(country: 'XX');
    expect(c.state.policies, hasLength(1));
    expect(c.state.policies.first.id, 'fallback-generic');
  });

  test('toggleItem flips done state for known id', () async {
    final c = makeCubit();
    await c.load();
    final firstId = c.state.checklist.first.id;
    expect(c.state.checklist.first.done, isFalse);
    c.toggleItem(firstId);
    expect(c.state.checklist.first.done, isTrue);
  });

  test('toggleItem no-ops for unknown id', () async {
    final c = makeCubit();
    await c.load();
    final before = c.state.checklist;
    c.toggleItem('does-not-exist');
    expect(c.state.checklist, before);
  });
}
