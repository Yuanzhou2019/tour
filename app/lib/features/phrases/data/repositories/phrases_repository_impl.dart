import 'package:injectable/injectable.dart';

import '../../../../core/network/dio_client.dart';
import '../../domain/entities/phrase.dart';
import '../../domain/repositories/phrases_repository.dart';

@LazySingleton(as: PhrasesRepository)
class PhrasesRepositoryImpl implements PhrasesRepository {
  PhrasesRepositoryImpl(this._dioClient);

  final DioClient _dioClient;

  @override
  Future<List<Phrase>> fetchByCategory(String category) async {
    final response = await _dioClient.dio.get(
      '/tools/phrases',
      queryParameters: {'category': category},
    );
    final raw = response.data['data'] as List? ?? [];
    return raw
        .map((e) => Phrase.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
