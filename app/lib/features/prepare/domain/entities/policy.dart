class Policy {
  const Policy({
    required this.id,
    required this.title,
    required this.description,
    required this.source,
    required this.country,
    this.category,
    this.reason,
  });

  final String id;
  final String title;
  final String description;
  final String source;
  final String country;
  final String? category;
  final String? reason;

  factory Policy.fromJson(Map<String, dynamic> json) {
    final title = (json['titleEn'] as String?) ?? (json['title'] as String?) ?? '';
    final description = (json['contentEn'] as String?) ?? (json['contentZh'] as String?) ?? '';
    final source = (json['sourceName'] as String?) ?? (json['source'] as String?) ?? '';
    return Policy(
      id: (json['id'] as String?) ?? '',
      title: title,
      description: description,
      source: source,
      country: (json['country'] as String?) ?? '',
      category: json['category'] as String?,
      reason: json['reason'] as String?,
    );
  }

  Policy copyWith({
    String? id,
    String? title,
    String? description,
    String? source,
    String? country,
    String? category,
    String? reason,
  }) =>
      Policy(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        source: source ?? this.source,
        country: country ?? this.country,
        category: category ?? this.category,
        reason: reason ?? this.reason,
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
