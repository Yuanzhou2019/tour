import 'package:injectable/injectable.dart';
import '../../../../core/network/dio_client.dart';
import '../../domain/entities/fx_rate.dart';
import '../../domain/repositories/fx_repository.dart';

@LazySingleton(as: FxRepository)
class FxRepositoryImpl implements FxRepository {
  FxRepositoryImpl(this._dioClient);

  final DioClient _dioClient;

  @override
  Future<FxRate> rate(String from, String to) async {
    final response = await _dioClient.dio.get(
      '/tools/fx-rates',
      queryParameters: {'from': from, 'to': to},
    );
    final data = response.data['data'] as Map<String, dynamic>?;
    if (data == null) {
      throw Exception('No FX data');
    }
    return FxRate.fromJson(data, from: from, to: to);
  }
}