import 'package:injectable/injectable.dart';
import '../../../../core/network/dio_client.dart';
import '../../domain/entities/poi.dart';
import '../../domain/repositories/poi_repository.dart';

@LazySingleton(as: PoiRepository)
class PoiRepositoryImpl implements PoiRepository {
  PoiRepositoryImpl(this._dioClient);

  final DioClient _dioClient;

  @override
  Future<List<Poi>> search({String? q, String? category}) async {
    final response = await _dioClient.dio.get(
      '/pois/search',
      queryParameters: {
        if (q != null && q.isNotEmpty) 'q': q,
        if (category != null) 'category': category,
      },
    );
    final raw = response.data['data'] as List? ?? [];
    return raw.map((e) => Poi.fromJson(e as Map<String, dynamic>)).toList();
  }
}