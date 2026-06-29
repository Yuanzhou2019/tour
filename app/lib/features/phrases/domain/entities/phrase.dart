class Phrase {
  final String id;
  final String category;
  final String en;
  final String zh;
  final String pinyin;
  final int order;

  const Phrase({
    required this.id,
    required this.category,
    required this.en,
    required this.zh,
    required this.pinyin,
    required this.order,
  });

  factory Phrase.fromJson(Map<String, dynamic> json) => Phrase(
        id: json['id'] as String? ?? '',
        category: json['category'] as String? ?? '',
        en: json['en'] as String? ?? '',
        zh: json['zh'] as String? ?? '',
        pinyin: json['pinyin'] as String? ?? '',
        order: (json['order'] as num?)?.toInt() ?? 0,
      );
}
