import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import 'interceptors/auth_interceptor.dart';
import 'interceptors/error_interceptor.dart';
import 'interceptors/logging_interceptor.dart';
import 'interceptors/mock_interceptor.dart';
import 'interceptors/retry_interceptor.dart';

@lazySingleton
class DioClient {
  final Dio dio;

  DioClient(
    AuthInterceptor authInterceptor,
    LoggingInterceptor loggingInterceptor,
    ErrorInterceptor errorInterceptor,
    MockInterceptor mockInterceptor,
    RetryInterceptor retryInterceptor,
  ) : dio = Dio(
          BaseOptions(
            baseUrl: 'https://api.sightour.com/v1',
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 30),
            headers: {
              'X-App-Version': '0.1.0',
            },
          ),
        ) {
    dio.interceptors.addAll([
      authInterceptor,
      loggingInterceptor,
      errorInterceptor,
      mockInterceptor,
      retryInterceptor,
    ]);
  }
}
