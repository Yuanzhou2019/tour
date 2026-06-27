import 'feedback_type.dart';

class FeedbackSubmission {
  const FeedbackSubmission({
    required this.type,
    required this.message,
    required this.anonymousId,
  });
  final FeedbackType type;
  final String message;
  final String anonymousId;

  Map<String, dynamic> toJson() => {
        'type': type.id,
        'message': message,
        'anonymousId': anonymousId,
      };
}