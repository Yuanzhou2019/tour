import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class RetryInterceptor extends Interceptor {
  static const _maxRetries = 3;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final attempt = (options.extra['retry_attempt'] as int?) ?? 0;
    if (attempt >= _maxRetries) {
      return handler.next(options);
    }
    try {
      final response = await Dio(BaseOptions(
        baseUrl: options.baseUrl,
        connectTimeout: options.connectTimeout,
        receiveTimeout: options.receiveTimeout,
      )).fetch<dynamic>(options);
      return handler.resolve(response);
    } on DioException catch (e) {
      if (_shouldRetry(e) && attempt + 1 < _maxRetries) {
        final next = options.copyWith(
          extra: {...options.extra, 'retry_attempt': attempt + 1},
        );
        final delay = Duration(seconds: 1 << attempt);
        await Future<void>.delayed(delay);
        return onRequest(next, handler);
      }
      return handler.reject(e);
    }
  }

  bool _shouldRetry(DioException e) {
    return e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout;
  }
}
