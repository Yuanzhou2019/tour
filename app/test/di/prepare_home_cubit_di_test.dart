import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:sightour/core/di/injection.dart';
import 'package:sightour/core/storage/hive_boxes.dart';
import 'package:sightour/features/prepare/presentation/cubit/prepare_home_cubit.dart';

class _FakePathProvider extends PathProviderPlatform with MockPlatformInterfaceMixin {
  @override
  Future<String?> getApplicationDocumentsPath() async =>
      '.dart_test/app_docs_di_smoke';
}

void main() {
  setUpAll(() async {
    PathProviderPlatform.instance = _FakePathProvider();
    Hive.init('.dart_test/hive_di_smoke_${DateTime.now().microsecondsSinceEpoch}');
    await Hive.openBox(HiveBoxes.prefs);
    await configureDependencies();
  });

  test('PrepareHomeCubit is registered after configureDependencies()', () {
    expect(getIt.isRegistered<PrepareHomeCubit>(), isTrue);
    // Resolving must NOT throw
    final c = getIt<PrepareHomeCubit>();
    expect(c, isNotNull);
  });
}
