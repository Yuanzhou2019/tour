import '../entities/discover_card.dart';

abstract class DiscoverRepository {
  Future<List<DiscoverCard>> curated();
  Future<List<DiscoverCard>> authentic();
  Future<List<DiscoverCard>> headsUp();
}