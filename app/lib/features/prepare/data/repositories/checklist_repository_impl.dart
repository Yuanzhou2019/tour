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
    // Flatten: each checklist doc has an "items" array we need to extract
    final List<ChecklistItem> result = [];
    for (final doc in raw) {
      final items = (doc as Map<String, dynamic>)['items'] as List? ?? [];
      for (final item in items) {
        result.add(ChecklistItem.fromJson(item as Map<String, dynamic>));
      }
    }
    return result;
  }
}
