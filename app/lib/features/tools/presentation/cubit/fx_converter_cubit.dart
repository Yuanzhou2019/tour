import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/fx_rate.dart';
import '../../domain/repositories/fx_repository.dart';

class FxConverterState {
  const FxConverterState({
    this.amount = 100.0,
    this.rate,
    this.isLoading = false,
    this.error,
    this.from = 'USD',
    this.to = 'CNY',
  });

  final double amount;
  final FxRate? rate;
  final bool isLoading;
  final String? error;
  final String from;
  final String to;

  double get converted =>
      rate == null ? 0.0 : FxRate.convert(rate!, amount);

  FxConverterState copyWith({
    double? amount,
    Object? rate = _sentinel,
    bool? isLoading,
    Object? error = _sentinel,
    String? from,
    String? to,
  }) =>
      FxConverterState(
        amount: amount ?? this.amount,
        rate: identical(rate, _sentinel) ? this.rate : rate as FxRate?,
        isLoading: isLoading ?? this.isLoading,
        error: identical(error, _sentinel) ? this.error : error as String?,
        from: from ?? this.from,
        to: to ?? this.to,
      );

  static const _sentinel = Object();
}

@injectable
class FxConverterCubit extends Cubit<FxConverterState> {
  FxConverterCubit(this._repo) : super(const FxConverterState());

  /// Stage-2 mock factory: no repo, returns a fake rate USD->CNY = 7.20.
  factory FxConverterCubit.forMock() =>
      FxConverterCubit(_NoopFxRepo());

  final FxRepository _repo;

  Future<void> load({String? from, String? to}) async {
    final f = from ?? state.from;
    final t = to ?? state.to;
    emit(state.copyWith(isLoading: true, error: null, from: f, to: t));
    try {
      final rate = await _repo.rate(f, t);
      emit(state.copyWith(rate: rate, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  void setAmount(double v) => emit(state.copyWith(amount: v));
}

class _NoopFxRepo implements FxRepository {
  @override
  Future<FxRate> rate(String from, String to) async => FxRate(
        from: from,
        to: to,
        rate: 7.20, // mock USD->CNY
        updatedAt: DateTime.now(),
      );
}