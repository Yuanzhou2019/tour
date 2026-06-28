import 'package:injectable/injectable.dart';
import '../../../../core/network/dio_client.dart';
import '../../domain/entities/discover_card.dart';
import '../../domain/repositories/discover_repository.dart';

@LazySingleton(as: DiscoverRepository)
class DiscoverRepositoryImpl implements DiscoverRepository {
  DiscoverRepositoryImpl(this._dioClient);

  final DioClient _dioClient;

  @override
  Future<List<DiscoverCard>> curated() => _fetch('/discover/curated');

  @override
  Future<List<DiscoverCard>> authentic() => _fetch('/discover/authentic');

  @override
  Future<List<DiscoverCard>> headsUp() => _fetch('/discover/heads-up');

  Future<List<DiscoverCard>> _fetch(String path) async {
    final response = await _dioClient.dio.get(path);
    final raw = response.data['data'] as List? ?? [];
    return raw
        .map((e) => DiscoverCard.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}