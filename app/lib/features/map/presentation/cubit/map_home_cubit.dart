import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/poi.dart';
import '../../domain/repositories/poi_repository.dart';

class MapHomeState {
  const MapHomeState({
    this.pois = const [],
    this.isLoading = false,
    this.error,
    this.query = '',
    this.category = 'all',
  });

  final List<Poi> pois;
  final bool isLoading;
  final String? error;
  final String query;
  final String category; // all | attraction | dining | lodging | shopping

  MapHomeState copyWith({
    List<Poi>? pois,
    bool? isLoading,
    Object? error = _sentinel,
    String? query,
    String? category,
  }) =>
      MapHomeState(
        pois: pois ?? this.pois,
        isLoading: isLoading ?? this.isLoading,
        error: identical(error, _sentinel) ? this.error : error as String?,
        query: query ?? this.query,
        category: category ?? this.category,
      );

  static const _sentinel = Object();
}

@injectable
class MapHomeCubit extends Cubit<MapHomeState> {
  MapHomeCubit(this._repo) : super(const MapHomeState());

  /// Stage-2 mock factory: no repo needed, returns empty POI list.
  factory MapHomeCubit.forMock() => MapHomeCubit(_NoopPoiRepo());

  final PoiRepository _repo;

  Future<void> load() async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final pois = await _repo.search(
        q: state.query.isEmpty ? null : state.query,
        category: state.category == 'all' ? null : state.category,
      );
      emit(state.copyWith(pois: pois, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  void setQuery(String q) => emit(state.copyWith(query: q));

  void setCategory(String c) {
    emit(state.copyWith(category: c));
    load();
  }

  void search() => load();
}

class _NoopPoiRepo implements PoiRepository {
  @override
  Future<List<Poi>> search({String? q, String? category}) async => const [];
}