class DiscoverCard {
  const DiscoverCard({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.score,
    this.imageUrl,
    this.category,
  });

  final String id;
  final String title;
  final String subtitle;
  final double score; // 0.0 - 5.0
  final String? imageUrl;
  final String? category;

  factory DiscoverCard.fromJson(Map<String, dynamic> json) {
    final title = (json['titleEn'] as String?) ?? (json['title'] as String?) ?? '';
    final subtitle = (json['summaryEn'] as String?) ?? (json['summaryZh'] as String?) ?? (json['subtitle'] as String?) ?? '';
    return DiscoverCard(
      id: (json['id'] as String?) ?? '',
      title: title,
      subtitle: subtitle,
      score: (json['score'] as num?)?.toDouble() ?? 0.0,
      imageUrl: json['imageUrl'] as String?,
      category: json['category'] as String?,
    );
  }

  DiscoverCard copyWith({
    String? id,
    String? title,
    String? subtitle,
    double? score,
    String? imageUrl,
    String? category,
  }) =>
      DiscoverCard(
        id: id ?? this.id,
        title: title ?? this.title,
        subtitle: subtitle ?? this.subtitle,
        score: score ?? this.score,
        imageUrl: imageUrl ?? this.imageUrl,
        category: category ?? this.category,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DiscoverCard &&
          id == other.id &&
          title == other.title &&
          subtitle == other.subtitle &&
          score == other.score;

  @override
  int get hashCode => Object.hash(id, title, subtitle, score);

  @override
  String toString() =>
      'DiscoverCard(id: $id, title: $title, score: $score)';
}
