import '../entities/feedback_submission.dart';

abstract class FeedbackRepository {
  Future<void> submit(FeedbackSubmission submission);
}