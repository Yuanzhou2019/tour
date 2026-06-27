import 'dart:math';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../mock_data.dart';

@lazySingleton
class MockInterceptor extends Interceptor {
  static const _endpointKeys = <String>{
    'GET /policies',
    'GET /pois/search',
    'GET /discover/curated',
    'GET /discover/authentic',
    'GET /discover/heads-up',
    'GET /tools/fx-rates',
    'GET /me/preferences',
    'POST /corrections',
  };

  /// 模拟离线（开发期切换用）
  bool simulateOffline = false;

  /// 错误率（0.0 - 1.0）
  double errorRate = 0.0;

  /// 模拟延迟（ms）
  int simulatedDelayMs = 200;

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
          data: MockData.emptyData,
        ),
      );
    }
    handler.next(options);
  }
}
