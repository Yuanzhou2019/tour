import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/discover_card.dart';
import '../../domain/repositories/discover_repository.dart';

enum DiscoverTab { curated, authentic, headsUp }

class DiscoverHomeState {
  const DiscoverHomeState({
    this.tab = DiscoverTab.curated,
    this.cards = const [],
    this.isLoading = false,
    this.error,
  });

  final DiscoverTab tab;
  final List<DiscoverCard> cards;
  final bool isLoading;
  final String? error;

  DiscoverHomeState copyWith({
    DiscoverTab? tab,
    List<DiscoverCard>? cards,
    bool? isLoading,
    Object? error = _sentinel,
  }) =>
      DiscoverHomeState(
        tab: tab ?? this.tab,
        cards: cards ?? this.cards,
        isLoading: isLoading ?? this.isLoading,
        error: identical(error, _sentinel) ? this.error : error as String?,
      );

  static const _sentinel = Object();
}

@injectable
class DiscoverHomeCubit extends Cubit<DiscoverHomeState> {
  DiscoverHomeCubit(this._repo) : super(const DiscoverHomeState());

  final DiscoverRepository _repo;

  Future<void> selectTab(DiscoverTab t) async {
    emit(state.copyWith(tab: t, isLoading: true, error: null));
    try {
      final cards = switch (t) {
        DiscoverTab.curated => await _repo.curated(),
        DiscoverTab.authentic => await _repo.authentic(),
        DiscoverTab.headsUp => await _repo.headsUp(),
      };
      emit(state.copyWith(cards: cards, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}