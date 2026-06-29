import 'package:injectable/injectable.dart';

import '../../../../core/network/dio_client.dart';
import '../../domain/entities/emergency_contact.dart';
import '../../domain/repositories/emergency_repository.dart';

@LazySingleton(as: EmergencyRepository)
class EmergencyRepositoryImpl implements EmergencyRepository {
  EmergencyRepositoryImpl(this._dioClient);

  final DioClient _dioClient;

  @override
  Future<List<EmergencyContact>> fetchAll() async {
    final response = await _dioClient.dio.get('/tools/emergency');
    final raw = response.data['data'] as List? ?? [];
    return raw
        .map((e) => EmergencyContact.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
