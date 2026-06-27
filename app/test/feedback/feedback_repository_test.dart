import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:sightour/core/network/dio_client.dart';
import 'package:sightour/core/network/interceptors/auth_interceptor.dart';
import 'package:sightour/core/network/interceptors/error_interceptor.dart';
import 'package:sightour/core/network/interceptors/logging_interceptor.dart';
import 'package:sightour/core/network/interceptors/mock_interceptor.dart';
import 'package:sightour/core/network/interceptors/retry_interceptor.dart';
import 'package:sightour/core/storage/hive_boxes.dart';
import 'package:sightour/features/feedback/data/repositories/feedback_repository_impl.dart';
import 'package:sightour/features/feedback/domain/entities/feedback_submission.dart';
import 'package:sightour/features/feedback/domain/entities/feedback_type.dart';

void main() {
  setUpAll(() {
    Hive.init('.dart_test/hive_fb_repo');
  });

  setUp(() async {
    if (Hive.isBoxOpen(HiveBoxes.prefs)) {
      await Hive.box(HiveBoxes.prefs).close();
    }
    await Hive.openBox(HiveBoxes.prefs);
  });

  test('submit returns normally on 200 (mock interceptor)', () async {
    final client = DioClient(
      AuthInterceptor(),
      LoggingInterceptor(),
      ErrorInterceptor(),
      MockInterceptor(),
      RetryInterceptor(),
    );
    final repo = FeedbackRepositoryImpl(client);
    await repo.submit(const FeedbackSubmission(
      type: FeedbackType.bug,
      message: 'The map does not load',
      anonymousId: 'anon_123',
    ));
    // No exception => pass
  });

  test('FeedbackSubmission.toJson emits expected keys', () {
    const s = FeedbackSubmission(
      type: FeedbackType.suggestion,
      message: 'Add offline mode',
      anonymousId: 'anon_xyz',
    );
    final j = s.toJson();
    expect(j['type'], 'suggestion');
    expect(j['message'], 'Add offline mode');
    expect(j['anonymousId'], 'anon_xyz');
  });

  test('FeedbackType ids are stable', () {
    expect(FeedbackType.bug.id, 'bug');
    expect(FeedbackType.contentError.id, 'content_error');
    expect(FeedbackType.suggestion.id, 'suggestion');
    expect(FeedbackType.other.id, 'other');
  });
}