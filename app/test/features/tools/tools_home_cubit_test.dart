import 'package:flutter_test/flutter_test.dart';
import 'package:sightour/features/tools/data/repositories/tools_repository_impl.dart';
import 'package:sightour/features/tools/presentation/cubit/tools_home_cubit.dart';

void main() {
  group('ToolsHomeCubit', () {
    test('default state has 6 tool entries', () {
      final c = ToolsHomeCubit(ToolsRepositoryImpl());
      expect(c.state.entries.length, 6);
      expect(c.state.entries.first.id, 'phrases');
    });

    test('entries include all 6 expected ids', () {
      final c = ToolsHomeCubit(ToolsRepositoryImpl());
      final ids = c.state.entries.map((e) => e.id).toSet();
      expect(ids, {
        'phrases',
        'emergency',
        'units',
        'timezone',
        'offline',
        'translate',
      });
    });
  });
}