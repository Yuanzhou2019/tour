import 'package:flutter/material.dart';
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

  /// Stage-2 mock factory: 6 hard-coded tool entries.
  factory ToolsHomeCubit.forMock() =>
      ToolsHomeCubit(_NoopToolsRepo());

  final ToolsRepository _repo;
}

class _NoopToolsRepo implements ToolsRepository {
  @override
  List<ToolEntry> entries() => const [
        ToolEntry(
          id: 'phrases',
          title: 'Phrase book',
          subtitle: 'Border · Transport · Dining · Medical',
          icon: Icons.translate,
        ),
        ToolEntry(
          id: 'emergency',
          title: 'Emergency contacts',
          subtitle: 'Police · Hospital · Embassy',
          icon: Icons.phone_in_talk,
        ),
        ToolEntry(
          id: 'units',
          title: 'Unit converter',
          subtitle: 'Length · Weight · Temperature',
          icon: Icons.swap_horiz,
        ),
        ToolEntry(
          id: 'timezone',
          title: 'Time zone',
          subtitle: 'US ET vs Shanghai CN',
          icon: Icons.public,
        ),
        ToolEntry(
          id: 'offline',
          title: 'Offline pack',
          subtitle: 'Maps + phrases, ready offline',
          icon: Icons.cloud_off,
        ),
        ToolEntry(
          id: 'translate',
          title: 'Translate assistant',
          subtitle: 'Camera + voice translate',
          icon: Icons.camera_alt,
        ),
      ];
}