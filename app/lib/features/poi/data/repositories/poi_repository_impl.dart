import 'package:injectable/injectable.dart';

import '../../../../core/network/dio_client.dart';
import '../../domain/entities/poi_detail.dart';
import '../../domain/repositories/poi_repository.dart';

@LazySingleton(as: PoiRepository)
class PoiRepositoryImpl implements PoiRepository {
  PoiRepositoryImpl(this._dioClient);

  final DioClient _dioClient;

  @override
  Future<PoiDetail> fetchDetail(String id) async {
    final response = await _dioClient.dio.get('/pois/$id');
    return PoiDetail.fromResponse(
        response.data as Map<String, dynamic>);
  }

  @override
  Future<PoiDetailReputation> fetchReputation(String id) async {
    final response =
        await _dioClient.dio.get('/pois/$id/reputation');
    return PoiDetailReputation.fromResponse(
        response.data as Map<String, dynamic>);
  }
}
