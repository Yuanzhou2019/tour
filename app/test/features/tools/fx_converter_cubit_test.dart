import 'package:flutter_test/flutter_test.dart';
import 'package:sightour/features/tools/domain/entities/fx_rate.dart';
import 'package:sightour/features/tools/domain/repositories/fx_repository.dart';
import 'package:sightour/features/tools/presentation/cubit/fx_converter_cubit.dart';

class _FakeFxRepo implements FxRepository {
  @override
  Future<FxRate> rate(String from, String to) async => FxRate(
        from: from,
        to: to,
        rate: 7.21,
        updatedAt: DateTime(2026, 6, 28),
      );
}

void main() {
  group('FxConverterCubit', () {
    test('default state has USD->CNY with 100.0 amount', () {
      final c = FxConverterCubit(_FakeFxRepo());
      expect(c.state.from, 'USD');
      expect(c.state.to, 'CNY');
      expect(c.state.amount, 100.0);
      expect(c.state.rate, isNull);
      expect(c.state.converted, 0.0);
    });

    test('load fetches rate and computes converted', () async {
      final c = FxConverterCubit(_FakeFxRepo());
      await c.load();
      expect(c.state.rate, isNotNull);
      expect(c.state.rate!.rate, 7.21);
      expect(c.state.converted, 721.0);
    });

    test('setAmount updates amount and conversion', () async {
      final c = FxConverterCubit(_FakeFxRepo());
      await c.load();
      c.setAmount(50);
      expect(c.state.amount, 50);
      expect(c.state.converted, closeTo(360.5, 0.01));
    });
  });
}