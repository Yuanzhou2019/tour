import 'package:injectable/injectable.dart';
import '../../../../core/network/dio_client.dart';
import '../../domain/entities/policy.dart';
import '../../domain/repositories/policy_repository.dart';

@LazySingleton(as: PolicyRepository)
class PolicyRepositoryImpl implements PolicyRepository {
  PolicyRepositoryImpl(this._dioClient);

  final DioClient _dioClient;

  @override
  Future<List<Policy>> fetchPolicies(String country) async {
    final response = await _dioClient.dio.get(
      '/policies',
      queryParameters: {'country': country},
    );
    final raw = response.data['data'] as List? ?? [];
    return raw
        .map((e) => Policy.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<Policy> fetchPolicyById(String id) async {
    final response = await _dioClient.dio.get('/policies/$id');
    final data = response.data['data'] as Map<String, dynamic>? ??
        response.data as Map<String, dynamic>;
    return Policy.fromJson(data);
  }
}