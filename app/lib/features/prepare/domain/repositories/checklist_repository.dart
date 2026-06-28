import '../entities/checklist_item.dart';

abstract class ChecklistRepository {
  Future<List<ChecklistItem>> fetchChecklist(String country);
}