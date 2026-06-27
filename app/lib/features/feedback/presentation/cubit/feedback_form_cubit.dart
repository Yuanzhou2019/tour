import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:sightour/core/network/failures.dart';
import 'package:sightour/core/storage/anonymous_id.dart';
import '../../domain/entities/feedback_submission.dart';
import '../../domain/entities/feedback_type.dart';
import '../../domain/repositories/feedback_repository.dart';

class FeedbackFormState {
  const FeedbackFormState({
    this.type = FeedbackType.bug,
    this.message = '',
    this.isSubmitting = false,
    this.errorMessage,
    this.submittedSuccessfully = false,
  });
  final FeedbackType type;
  final String message;
  final bool isSubmitting;
  final String? errorMessage;
  final bool submittedSuccessfully;

  bool get canSubmit => message.trim().length >= 10 && !isSubmitting;

  FeedbackFormState copyWith({
    FeedbackType? type,
    String? message,
    bool? isSubmitting,
    Object? errorMessage = _sentinel,
    bool? submittedSuccessfully,
  }) =>
      FeedbackFormState(
        type: type ?? this.type,
        message: message ?? this.message,
        isSubmitting: isSubmitting ?? this.isSubmitting,
        errorMessage: identical(errorMessage, _sentinel)
            ? this.errorMessage
            : errorMessage as String?,
        submittedSuccessfully:
            submittedSuccessfully ?? this.submittedSuccessfully,
      );

  static const _sentinel = Object();
}

@injectable
class FeedbackFormCubit extends Cubit<FeedbackFormState> {
  FeedbackFormCubit(this._repo) : super(const FeedbackFormState());
  final FeedbackRepository _repo;

  void setType(FeedbackType t) => emit(state.copyWith(type: t));
  void setMessage(String m) => emit(state.copyWith(message: m));

  Future<void> submit() async {
    if (!state.canSubmit) return;
    emit(state.copyWith(isSubmitting: true, errorMessage: null));
    try {
      final sub = FeedbackSubmission(
        type: state.type,
        message: state.message.trim(),
        anonymousId: AnonymousId.get(),
      );
      await _repo.submit(sub);
      emit(state.copyWith(isSubmitting: false, submittedSuccessfully: true));
    } on Failure catch (e) {
      emit(state.copyWith(isSubmitting: false, errorMessage: e.toString()));
    } catch (e) {
      emit(state.copyWith(
        isSubmitting: false,
        errorMessage: 'Unexpected error: $e',
      ));
    }
  }
}