class Poi {
  const Poi({
    required this.id,
    required this.name,
    required this.category,
    required this.distanceKm,
    required this.avgScore,
  });

  final String id;
  final String name;
  final String category; // attraction | dining | lodging | shopping
  final double distanceKm;
  final double avgScore; // 0.0 - 5.0

  factory Poi.fromJson(Map<String, dynamic> json) => Poi(
        id: json['id'] as String,
        name: json['name'] as String,
        category: json['category'] as String? ?? 'attraction',
        distanceKm: (json['distanceKm'] as num?)?.toDouble() ?? 0.0,
        avgScore: (json['avgScore'] as num?)?.toDouble() ?? 0.0,
      );

  Poi copyWith({
    String? id,
    String? name,
    String? category,
    double? distanceKm,
    double? avgScore,
  }) =>
      Poi(
        id: id ?? this.id,
        name: name ?? this.name,
        category: category ?? this.category,
        distanceKm: distanceKm ?? this.distanceKm,
        avgScore: avgScore ?? this.avgScore,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Poi &&
          id == other.id &&
          name == other.name &&
          category == other.category &&
          distanceKm == other.distanceKm &&
          avgScore == other.avgScore;

  @override
  int get hashCode =>
      Object.hash(id, name, category, distanceKm, avgScore);

  @override
  String toString() =>
      'Poi(id: $id, name: $name, category: $category, distance: $distanceKm)';
}