import 'package:flutter_test/flutter_test.dart';
import 'package:sightour/core/network/dio_client.dart';
import 'package:sightour/core/network/interceptors/auth_interceptor.dart';
import 'package:sightour/core/network/interceptors/error_interceptor.dart';
import 'package:sightour/core/network/interceptors/logging_interceptor.dart';
import 'package:sightour/core/network/interceptors/mock_interceptor.dart';
import 'package:sightour/core/network/interceptors/retry_interceptor.dart';

void main() {
  test('DioClient has 5 app interceptors plus dio default (ImplyContentType)', () {
    final client = DioClient(
      AuthInterceptor(),
      LoggingInterceptor(),
      ErrorInterceptor(),
      MockInterceptor(),
      RetryInterceptor(),
    );
    // 5 app-defined interceptors + 1 built-in ImplyContentTypeInterceptor.
    expect(client.dio.interceptors.length, 6);
  });
}
