import 'package:flutter_test/flutter_test.dart';
import 'package:sightour/features/discover/domain/entities/discover_card.dart';
import 'package:sightour/features/discover/domain/repositories/discover_repository.dart';
import 'package:sightour/features/discover/presentation/cubit/discover_home_cubit.dart';

class _FakeDiscoverRepo implements DiscoverRepository {
  const _FakeDiscoverRepo();
  @override
  Future<List<DiscoverCard>> curated() async => const [
        DiscoverCard(id: 'c1', title: 'Curated 1', subtitle: 'Top picks', score: 4.8),
      ];

  @override
  Future<List<DiscoverCard>> authentic() async => const [
        DiscoverCard(id: 'a1', title: 'Authentic 1', subtitle: 'Local gems', score: 4.6),
      ];

  @override
  Future<List<DiscoverCard>> headsUp() async => const [
        DiscoverCard(id: 'h1', title: 'Heads-up 1', subtitle: 'Watch out', score: 4.2),
      ];
}

void main() {
  group('DiscoverHomeCubit', () {
    test('default state is curated tab', () {
      final c = DiscoverHomeCubit(const _FakeDiscoverRepo());
      expect(c.state.tab, DiscoverTab.curated);
      expect(c.state.cards, isEmpty);
      expect(c.state.isLoading, false);
    });

    test('selectTab loads correct endpoint', () async {
      final c = DiscoverHomeCubit(const _FakeDiscoverRepo());
      await c.selectTab(DiscoverTab.authentic);
      expect(c.state.tab, DiscoverTab.authentic);
      expect(c.state.cards.first.title, 'Authentic 1');
      expect(c.state.isLoading, false);
    });

    test('selectTab headsUp', () async {
      final c = DiscoverHomeCubit(const _FakeDiscoverRepo());
      await c.selectTab(DiscoverTab.headsUp);
      expect(c.state.tab, DiscoverTab.headsUp);
      expect(c.state.cards.first.title, 'Heads-up 1');
    });
  });
}