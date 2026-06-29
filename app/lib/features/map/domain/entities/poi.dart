class Poi {
  const Poi({
    required this.id,
    required this.name,
    required this.category,
    required this.distanceKm,
    required this.avgScore,
    this.lat,
    this.lng,
    this.address,
  });

  final String id;
  final String name;
  final String category; // attraction | dining | lodging | shopping
  final double distanceKm;
  final double avgScore; // 0.0 - 5.0
  final double? lat;
  final double? lng;
  final String? address;

  factory Poi.fromJson(Map<String, dynamic> json) {
    final name = (json['nameEn'] as String?) ?? (json['nameZh'] as String?) ?? (json['name'] as String?) ?? '';
    final address = (json['addressEn'] as String?) ?? (json['addressZh'] as String?) ?? (json['address'] as String?);
    return Poi(
      id: (json['id'] as String?) ?? '',
      name: name,
      category: (json['category'] as String?) ?? 'attraction',
      distanceKm: (json['distanceKm'] as num?)?.toDouble() ?? 0.0,
      avgScore: (json['avgScore'] as num?)?.toDouble() ?? 0.0,
      lat: (json['lat'] as num?)?.toDouble(),
      lng: (json['lng'] as num?)?.toDouble(),
      address: address,
    );
  }

  Poi copyWith({
    String? id,
    String? name,
    String? category,
    double? distanceKm,
    double? avgScore,
    double? lat,
    double? lng,
    String? address,
  }) =>
      Poi(
        id: id ?? this.id,
        name: name ?? this.name,
        category: category ?? this.category,
        distanceKm: distanceKm ?? this.distanceKm,
        avgScore: avgScore ?? this.avgScore,
        lat: lat ?? this.lat,
        lng: lng ?? this.lng,
        address: address ?? this.address,
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
