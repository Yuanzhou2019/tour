import 'package:injectable/injectable.dart';
import '../../../../core/network/dio_client.dart';
import '../../domain/entities/checklist_item.dart';
import '../../domain/repositories/checklist_repository.dart';

@LazySingleton(as: ChecklistRepository)
class ChecklistRepositoryImpl implements ChecklistRepository {
  ChecklistRepositoryImpl(this._dioClient);

  final DioClient _dioClient;

  @override
  Future<List<ChecklistItem>> fetchChecklist(String country) async {
    final response = await _dioClient.dio.get(
      '/checklists',
      queryParameters: {'country': country},
    );
    final raw = response.data['data'] as List? ?? [];
    return raw
        .map((e) => ChecklistItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}