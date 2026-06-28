class FxRate {
  const FxRate({
    required this.from,
    required this.to,
    required this.rate,
    required this.updatedAt,
  });

  final String from;
  final String to;
  final double rate;
  final DateTime updatedAt;

  static double convert(FxRate r, double amount) => amount * r.rate;

  factory FxRate.fromJson(
    Map<String, dynamic> json, {
    required String from,
    required String to,
  }) =>
      FxRate(
        from: from,
        to: to,
        rate: (json['rate'] as num).toDouble(),
        updatedAt: DateTime.tryParse(json['updatedAt'] as String? ?? '') ??
            DateTime.now(),
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FxRate &&
          from == other.from &&
          to == other.to &&
          rate == other.rate &&
          updatedAt == other.updatedAt;

  @override
  int get hashCode => Object.hash(from, to, rate, updatedAt);

  @override
  String toString() => 'FxRate($from -> $to @ $rate)';
}