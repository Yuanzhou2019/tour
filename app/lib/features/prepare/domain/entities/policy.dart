class Policy {
  const Policy({
    required this.id,
    required this.title,
    required this.description,
    required this.source,
    required this.country,
  });

  final String id;
  final String title;
  final String description;
  final String source;
  final String country;

  factory Policy.fromJson(Map<String, dynamic> json) => Policy(
        id: json['id'] as String,
        title: json['title'] as String,
        description: json['description'] as String? ?? '',
        source: json['source'] as String? ?? '',
        country: json['country'] as String? ?? '',
      );

  Policy copyWith({
    String? id,
    String? title,
    String? description,
    String? source,
    String? country,
  }) =>
      Policy(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        source: source ?? this.source,
        country: country ?? this.country,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Policy &&
          id == other.id &&
          title == other.title &&
          description == other.description &&
          source == other.source &&
          country == other.country;

  @override
  int get hashCode =>
      Object.hash(id, title, description, source, country);

  @override
  String toString() => 'Policy(id: $id, title: $title, country: $country)';
}