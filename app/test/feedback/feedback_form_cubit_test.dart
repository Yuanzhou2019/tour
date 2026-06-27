import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:sightour/core/network/dio_client.dart';
import 'package:sightour/core/network/interceptors/auth_interceptor.dart';
import 'package:sightour/core/network/interceptors/error_interceptor.dart';
import 'package:sightour/core/network/interceptors/logging_interceptor.dart';
import 'package:sightour/core/network/interceptors/mock_interceptor.dart';
import 'package:sightour/core/network/interceptors/retry_interceptor.dart';
import 'package:sightour/core/storage/hive_boxes.dart';
import 'package:sightour/features/feedback/data/repositories/feedback_repository_impl.dart';
import 'package:sightour/features/feedback/domain/entities/feedback_type.dart';
import 'package:sightour/features/feedback/presentation/cubit/feedback_form_cubit.dart';

class _FakePathProvider extends PathProviderPlatform with MockPlatformInterfaceMixin {
  @override
  Future<String?> getApplicationDocumentsPath() async => '.dart_test/app_docs_fb_cubit';
}

void main() {
  setUpAll(() {
    PathProviderPlatform.instance = _FakePathProvider();
    Hive.init('.dart_test/hive_fb_cubit_${DateTime.now().microsecondsSinceEpoch}');
  });

  setUp(() async {
    if (Hive.isBoxOpen(HiveBoxes.prefs)) {
      await Hive.box(HiveBoxes.prefs).close();
    }
    await Hive.openBox(HiveBoxes.prefs);
  });

  FeedbackFormCubit makeCubit() {
    final client = DioClient(
      AuthInterceptor(),
      LoggingInterceptor(),
      ErrorInterceptor(),
      MockInterceptor(),
      RetryInterceptor(),
    );
    final repo = FeedbackRepositoryImpl(client);
    return FeedbackFormCubit(repo);
  }

  test('default state', () {
    final c = makeCubit();
    expect(c.state.type, FeedbackType.bug);
    expect(c.state.message, '');
    expect(c.state.canSubmit, false);
  });

  test('setType / setMessage emit', () {
    final c = makeCubit();
    c.setType(FeedbackType.suggestion);
    c.setMessage('Hello world, this is a test message');
    expect(c.state.type, FeedbackType.suggestion);
    expect(c.state.message, contains('Hello'));
    expect(c.state.canSubmit, true);
  });

  test('canSubmit false when message < 10 chars', () {
    final c = makeCubit();
    c.setMessage('short');
    expect(c.state.canSubmit, false);
  });

  test('submit success clears state.errorMessage and sets submittedSuccessfully', () async {
    final c = makeCubit();
    c.setMessage('This is a valid feedback message');
    await c.submit();
    expect(c.state.isSubmitting, false);
    expect(c.state.submittedSuccessfully, true);
    expect(c.state.errorMessage, isNull);
  });
}