import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../storage/anonymous_id.dart';

@lazySingleton
class AuthInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    options.headers['X-Anonymous-Id'] = AnonymousId.get();
    handler.next(options);
  }
}
