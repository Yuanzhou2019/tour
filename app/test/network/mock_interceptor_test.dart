import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sightour/core/network/interceptors/mock_interceptor.dart';
import 'package:sightour/core/network/mock_data.dart';

void main() {
  late MockInterceptor mockInterceptor;
  late Dio dio;

  setUp(() {
    mockInterceptor = MockInterceptor();
    dio = Dio(BaseOptions(baseUrl: 'https://test.local'));
    dio.interceptors.add(mockInterceptor);
  });

  test('hits /policies and returns emptyData', () async {
    final res = await dio.get<dynamic>('/policies');
    expect(res.statusCode, 200);
    expect(res.data, MockData.emptyData);
  });

  test('hits /pois/search and returns emptyData', () async {
    final res = await dio.get<dynamic>('/pois/search');
    expect(res.data, MockData.emptyData);
  });

  test('hits POST /corrections and returns emptyData', () async {
    final res = await dio.post<dynamic>('/corrections', data: {});
    expect(res.data, MockData.emptyData);
  });

  test('unmatched path passes through', () async {
    mockInterceptor.simulateOffline = false;
    // /not-a-real-endpoint will not match and will be passed to next interceptor
    // which doesn't exist, so it'll be the network call itself.
    // We can't easily test the real network in a test, but we can check
    // that the interceptor does NOT short-circuit.
    final requestOptions = RequestOptions(path: '/not-real');
    final handler = _FakeHandler();
    await mockInterceptor.onRequest(requestOptions, handler);
    expect(handler.nextCalled, true);
  });

  test('simulateOffline rejects with connectionError', () async {
    mockInterceptor.simulateOffline = true;
    Object? caught;
    try {
      await dio.get<dynamic>('/policies');
    } catch (e) {
      caught = e;
    }
    expect(caught, isA<DioException>());
    expect((caught as DioException).type, DioExceptionType.connectionError);
  });
}

class _FakeHandler extends RequestInterceptorHandler {
  bool nextCalled = false;
  @override
  void next(RequestOptions requestOptions) {
    nextCalled = true;
    super.next(requestOptions);
  }
}
