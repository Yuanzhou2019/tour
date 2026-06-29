import 'dart:math';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../mock_data.dart';

@lazySingleton
class MockInterceptor extends Interceptor {
  static const _endpointKeys = <String>{
    'GET /policies',
    'GET /checklists',
    'GET /pois/search',
    'GET /discover/curated',
    'GET /discover/authentic',
    'GET /discover/heads-up',
    'GET /tools/fx-rates',
    'GET /me/preferences',
    'POST /corrections',
  };

  /// Simulate offline (dev-mode toggle).
  bool simulateOffline = false;

  /// Error rate (0.0 - 1.0) for randomly failing requests.
  double errorRate = 0.0;

  /// Simulated network latency in milliseconds.
  int simulatedDelayMs = 200;

  /// Current locale tag (e.g. `en`, `zh`, `zh-CN`). Updated by the app
  /// shell (typically from [LocaleCubit]) so the canned responses can be
  /// returned in the user's chosen language. Defaults to `en`.
  String locale = 'en';

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (simulateOffline) {
      return handler.reject(
        DioException(
          requestOptions: options,
          type: DioExceptionType.connectionError,
          message: 'Simulated offline',
        ),
      );
    }

    if (Random().nextDouble() < errorRate) {
      return handler.reject(
        DioException(
          requestOptions: options,
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: options,
            statusCode: 500,
            data: {'code': 'INTERNAL_ERROR'},
          ),
        ),
      );
    }

    final key = '${options.method} ${options.path}';
    if (_endpointKeys.contains(key)) {
      await Future<void>.delayed(Duration(milliseconds: simulatedDelayMs));
      return handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 200,
          data: MockData.responseFor(
            options.method,
            options.path,
            options.queryParameters,
            locale: locale,
          ),
        ),
      );
    }
    handler.next(options);
  }
}
