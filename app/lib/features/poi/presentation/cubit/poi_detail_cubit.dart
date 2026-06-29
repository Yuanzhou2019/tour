import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/poi_detail.dart';
import '../../domain/repositories/poi_repository.dart';

enum PoiDetailStatus { initial, loading, success, error }

class PoiDetailState {
  final PoiDetailStatus status;
  final PoiDetail? detail;
  final PoiDetailReputation? reputation;
  final String? error;

  const PoiDetailState({
    this.status = PoiDetailStatus.initial,
    this.detail,
    this.reputation,
    this.error,
  });

  PoiDetailState copyWith({
    PoiDetailStatus? status,
    PoiDetail? detail,
    PoiDetailReputation? reputation,
    Object? error = _sentinel,
  }) =>
      PoiDetailState(
        status: status ?? this.status,
        detail: detail ?? this.detail,
        reputation: reputation ?? this.reputation,
        error: identical(error, _sentinel) ? this.error : error as String?,
      );

  static const _sentinel = Object();
}

@injectable
class PoiDetailCubit extends Cubit<PoiDetailState> {
  PoiDetailCubit(this._repo) : super(const PoiDetailState());

  final PoiRepository _repo;

  Future<void> load(String id) async {
    emit(state.copyWith(status: PoiDetailStatus.loading));
    try {
      final detail = await _repo.fetchDetail(id);
      emit(state.copyWith(
        status: PoiDetailStatus.success,
        detail: detail,
        reputation: detail.reputation,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: PoiDetailStatus.error,
        error: e.toString(),
      ));
    }
  }

  Future<void> loadReputation(String id) async {
    emit(state.copyWith(status: PoiDetailStatus.loading));
    try {
      final reputation = await _repo.fetchReputation(id);
      emit(state.copyWith(
        status: PoiDetailStatus.success,
        reputation: reputation,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: PoiDetailStatus.error,
        error: e.toString(),
      ));
    }
  }
}
