import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/tool_entry.dart';
import '../../domain/repositories/tools_repository.dart';

class ToolsHomeState {
  const ToolsHomeState({this.entries = const []});
  final List<ToolEntry> entries;

  ToolsHomeState copyWith({List<ToolEntry>? entries}) =>
      ToolsHomeState(entries: entries ?? this.entries);
}

@injectable
class ToolsHomeCubit extends Cubit<ToolsHomeState> {
  ToolsHomeCubit(this._repo) : super(const ToolsHomeState()) {
    emit(state.copyWith(entries: _repo.entries()));
  }

  final ToolsRepository _repo;
}