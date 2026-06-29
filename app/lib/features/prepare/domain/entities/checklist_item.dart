class ChecklistItem {
  const ChecklistItem({
    required this.id,
    required this.title,
    required this.done,
    this.detail,
    this.officialUrl,
  });

  final String id;
  final String title;
  final bool done;
  final String? detail;
  final String? officialUrl;

  factory ChecklistItem.fromJson(Map<String, dynamic> json) {
    final title = (json['titleEn'] as String?) ?? (json['title'] as String?) ?? '';
    final detail = (json['detailEn'] as String?) ?? (json['detailZh'] as String?) ?? (json['detail'] as String?);
    return ChecklistItem(
      id: (json['id'] as String?) ?? '',
      title: title,
      done: json['done'] as bool? ?? false,
      detail: detail,
      officialUrl: json['officialUrl'] as String?,
    );
  }

  ChecklistItem copyWith({String? id, String? title, bool? done, String? detail, String? officialUrl}) =>
      ChecklistItem(
        id: id ?? this.id,
        title: title ?? this.title,
        done: done ?? this.done,
        detail: detail ?? this.detail,
        officialUrl: officialUrl ?? this.officialUrl,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChecklistItem &&
          id == other.id &&
          title == other.title &&
          done == other.done;

  @override
  int get hashCode => Object.hash(id, title, done);

  @override
  String toString() => 'ChecklistItem(id: $id, title: $title, done: $done)';
}
