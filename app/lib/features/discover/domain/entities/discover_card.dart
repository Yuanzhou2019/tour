class DiscoverCard {
  const DiscoverCard({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.score,
  });

  final String id;
  final String title;
  final String subtitle;
  final double score; // 0.0 - 5.0

  factory DiscoverCard.fromJson(Map<String, dynamic> json) => DiscoverCard(
        id: json['id'] as String,
        title: json['title'] as String,
        subtitle: json['subtitle'] as String? ?? '',
        score: (json['score'] as num?)?.toDouble() ?? 0.0,
      );

  DiscoverCard copyWith({
    String? id,
    String? title,
    String? subtitle,
    double? score,
  }) =>
      DiscoverCard(
        id: id ?? this.id,
        title: title ?? this.title,
        subtitle: subtitle ?? this.subtitle,
        score: score ?? this.score,
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