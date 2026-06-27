import 'package:injectable/injectable.dart';
import '../../../../core/network/dio_client.dart';
import '../../domain/entities/feedback_submission.dart';
import '../../domain/repositories/feedback_repository.dart';

@LazySingleton(as: FeedbackRepository)
class FeedbackRepositoryImpl implements FeedbackRepository {
  final DioClient _dioClient;
  FeedbackRepositoryImpl(this._dioClient);

  @override
  Future<void> submit(FeedbackSubmission submission) async {
    await _dioClient.dio.post('/corrections', data: submission.toJson());
  }
}