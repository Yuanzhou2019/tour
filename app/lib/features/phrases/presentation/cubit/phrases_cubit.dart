import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/phrase.dart';
import '../../domain/repositories/phrases_repository.dart';

class PhrasesState {
  final List<Phrase> phrases;
  final bool isLoading;
  final String? error;

  const PhrasesState({
    this.phrases = const [],
    this.isLoading = false,
    this.error,
  });

  PhrasesState copyWith({
    List<Phrase>? phrases,
    bool? isLoading,
    String? error,
  }) =>
      PhrasesState(
        phrases: phrases ?? this.phrases,
        isLoading: isLoading ?? this.isLoading,
        error: error,
      );
}

class PhrasesCubit extends Cubit<PhrasesState> {
  PhrasesCubit(this._repo) : super(const PhrasesState());

  final PhrasesRepository _repo;

  Future<void> loadByCategory(String category) async {
    emit(state.copyWith(isLoading: true));
    try {
      final phrases = await _repo.fetchByCategory(category);
      emit(state.copyWith(phrases: phrases, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}
