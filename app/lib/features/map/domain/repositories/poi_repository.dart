import '../entities/poi.dart';

abstract class PoiRepository {
  Future<List<Poi>> search({String? q, String? category});
}