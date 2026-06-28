import '../entities/tool_entry.dart';

abstract class ToolsRepository {
  List<ToolEntry> entries();
}