enum FeedbackType {
  bug('bug', 'Bug report', '应用问题'),
  contentError('content_error', 'Wrong information', '内容错误'),
  suggestion('suggestion', 'Suggestion', '建议'),
  other('other', 'Other', '其他');

  const FeedbackType(this.id, this.labelEn, this.labelZh);
  final String id;
  final String labelEn;
  final String labelZh;
}