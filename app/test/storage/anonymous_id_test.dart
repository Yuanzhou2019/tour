import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:sightour/core/storage/anonymous_id.dart';
import 'package:sightour/core/storage/hive_boxes.dart';

class _FakePathProvider extends PathProviderPlatform with MockPlatformInterfaceMixin {
  @override
  Future<String?> getApplicationDocumentsPath() async => '.dart_test/app_docs_anon';
}

void main() {
  setUpAll(() async {
    PathProviderPlatform.instance = _FakePathProvider();
    Hive.init('.dart_test/hive_anon');
  });

  setUp(() async {
    await Hive.deleteFromDisk();
    await Hive.openBox(HiveBoxes.prefs);
  });

  test('first call generates anon id', () {
    final id = AnonymousId.get();
    expect(id, startsWith('anon_'));
  });

  test('second call reuses same id', () {
    final id1 = AnonymousId.get();
    final id2 = AnonymousId.get();
    expect(id1, id2);
  });
}
