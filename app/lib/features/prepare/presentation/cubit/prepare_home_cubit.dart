import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/checklist_item.dart';
import '../../domain/entities/policy.dart';
import '../../domain/repositories/checklist_repository.dart';
import '../../domain/repositories/policy_repository.dart';

class PrepareHomeState {
  const PrepareHomeState({
    this.policies = const [],
    this.checklist = const [],
    this.isLoading = false,
    this.error,
    this.country = 'US',
  });

  final List<Policy> policies;
  final List<ChecklistItem> checklist;
  final bool isLoading;
  final String? error;
  final String country;

  PrepareHomeState copyWith({
    List<Policy>? policies,
    List<ChecklistItem>? checklist,
    bool? isLoading,
    Object? error = _sentinel,
    String? country,
  }) =>
      PrepareHomeState(
        policies: policies ?? this.policies,
        checklist: checklist ?? this.checklist,
        isLoading: isLoading ?? this.isLoading,
        error: identical(error, _sentinel) ? this.error : error as String?,
        country: country ?? this.country,
      );

  static const _sentinel = Object();
}

@injectable
class PrepareHomeCubit extends Cubit<PrepareHomeState> {
  PrepareHomeCubit(this._policyRepo, this._checklistRepo)
      : super(const PrepareHomeState());

  /// Convenience helper for tests: skip DI and use no-op repos that return
  /// empty lists. Production code must use `getIt<PrepareHomeCubit>()` so
  /// the real MockInterceptor-backed repositories are wired in.
  // ignore: prefer_constructors_over_static_methods
  static PrepareHomeCubit forMock() =>
      PrepareHomeCubit(_NoopPolicyRepo(), _NoopChecklistRepo());

  final PolicyRepository _policyRepo;
  final ChecklistRepository _checklistRepo;

  Future<void> load({String? country}) async {
    if (country != null) emit(state.copyWith(country: country));
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final policies = await _policyRepo.fetchPolicies(state.country);
      final checklist = await _checklistRepo.fetchChecklist(state.country);
      emit(state.copyWith(
        policies: policies,
        checklist: checklist,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  void toggleItem(String id) {
    final updated = state.checklist
        .map((i) => i.id == id ? i.copyWith(done: !i.done) : i)
        .toList();
    emit(state.copyWith(checklist: updated));
  }
}

class _NoopPolicyRepo implements PolicyRepository {
  @override
  Future<List<Policy>> fetchPolicies(String country) async => const [];

  @override
  Future<Policy> fetchPolicyById(String id) async =>
      Policy(id: '', title: '', description: '', source: '', country: '');
}

class _NoopChecklistRepo implements ChecklistRepository {
  @override
  Future<List<ChecklistItem>> fetchChecklist(String country) async => const [];
}