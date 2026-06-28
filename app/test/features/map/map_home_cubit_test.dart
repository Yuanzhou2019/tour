import 'package:flutter_test/flutter_test.dart';
import 'package:sightour/features/map/domain/entities/poi.dart';
import 'package:sightour/features/map/domain/repositories/poi_repository.dart';
import 'package:sightour/features/map/presentation/cubit/map_home_cubit.dart';

class _FakePoiRepo implements PoiRepository {
  const _FakePoiRepo();
  @override
  Future<List<Poi>> search({String? q, String? category}) async => const [
        Poi(
          id: '1',
          name: 'Bund',
          category: 'attraction',
          distanceKm: 1.2,
          avgScore: 4.7,
        ),
        Poi(
          id: '2',
          name: 'Noodle shop',
          category: 'dining',
          distanceKm: 0.5,
          avgScore: 4.4,
        ),
      ];
}

void main() {
  group('MapHomeCubit', () {
    test('default state', () {
      final c = MapHomeCubit(const _FakePoiRepo());
      expect(c.state.pois, isEmpty);
      expect(c.state.query, '');
      expect(c.state.category, 'all');
      expect(c.state.isLoading, false);
    });

    test('load fetches POIs and clears loading', () async {
      final c = MapHomeCubit(const _FakePoiRepo());
      await c.load();
      expect(c.state.isLoading, false);
      expect(c.state.pois.length, 2);
      expect(c.state.pois.first.name, 'Bund');
    });

    test('setQuery updates query string', () {
      final c = MapHomeCubit(const _FakePoiRepo());
      c.setQuery('noodle');
      expect(c.state.query, 'noodle');
    });

    test('setCategory triggers load with category', () async {
      final c = MapHomeCubit(const _FakePoiRepo());
      c.setCategory('dining');
      // setCategory fires load() in the cubit; wait a tick for async resolution.
      await Future<void>.delayed(const Duration(milliseconds: 10));
      expect(c.state.category, 'dining');
      expect(c.state.isLoading, false);
    });
  });
}