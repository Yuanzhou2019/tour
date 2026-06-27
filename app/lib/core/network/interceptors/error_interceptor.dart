import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../failures.dart';

@lazySingleton
class ErrorInterceptor extends Interceptor {
  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) {
    final Failure failure;
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        failure = const Failure.network(NetworkFailureType.timeout);
        break;
      case DioExceptionType.connectionError:
        failure = const Failure.network(NetworkFailureType.noConnection);
        break;
      case DioExceptionType.badResponse:
        final status = err.response?.statusCode ?? 0;
        final code = (err.response?.data is Map)
            ? (err.response!.data as Map)['code'] as String?
            : null;
        failure = Failure.server(statusCode: status, code: code);
        break;
      case DioExceptionType.cancel:
      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
        failure = Failure.unknown(err.message ?? 'Unknown error');
        break;
    }
    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        type: err.type,
        error: failure,
        response: err.response,
        message: err.message,
      ),
    );
  }
}
