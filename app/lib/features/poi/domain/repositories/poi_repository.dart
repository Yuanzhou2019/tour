import '../entities/poi_detail.dart';

abstract class PoiRepository {
  Future<PoiDetail> fetchDetail(String id);
  Future<PoiDetailReputation> fetchReputation(String id);
}
