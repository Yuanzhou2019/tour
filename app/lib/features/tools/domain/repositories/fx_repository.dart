import '../entities/fx_rate.dart';

abstract class FxRepository {
  Future<FxRate> rate(String from, String to);
}