import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:sightour/core/storage/hive_boxes.dart';
import 'package:sightour/core/storage/hive_service.dart';

class _FakePathProvider extends PathProviderPlatform with MockPlatformInterfaceMixin {
  @override
  Future<String?> getApplicationDocumentsPath() async => '.dart_test/app_docs_hive';
}

void main() {
  setUpAll(() async {
    PathProviderPlatform.instance = _FakePathProvider();
    Hive.init('.dart_test/hive_service');
  });

  setUp(() async {
    await Hive.deleteFromDisk();
    await Hive.openBox(HiveBoxes.prefs);
  });

  test('read default returns null', () {
    final svc = HiveService(Hive.box(HiveBoxes.prefs));
    expect(svc.read<String>('missing'), isNull);
  });

  test('write + read roundtrip', () async {
    final svc = HiveService(Hive.box(HiveBoxes.prefs));
    await svc.write('key', 'value');
    expect(svc.read<String>('key'), 'value');
  });

  test('delete removes key', () async {
    final svc = HiveService(Hive.box(HiveBoxes.prefs));
    await svc.write('key', 'value');
    await svc.delete('key');
    expect(svc.read<String>('key'), isNull);
  });
}
