class ChecklistItem {
  const ChecklistItem({
    required this.id,
    required this.title,
    required this.done,
  });

  final String id;
  final String title;
  final bool done;

  factory ChecklistItem.fromJson(Map<String, dynamic> json) => ChecklistItem(
        id: json['id'] as String,
        title: json['title'] as String,
        done: json['done'] as bool? ?? false,
      );

  ChecklistItem copyWith({String? id, String? title, bool? done}) =>
      ChecklistItem(
        id: id ?? this.id,
        title: title ?? this.title,
        done: done ?? this.done,
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