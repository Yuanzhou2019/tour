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

  test('GET /policies returns country-specific entries', () async {
    final res = await dio.get<dynamic>(
      '/policies',
      queryParameters: {'country': 'US'},
    );
    expect(res.statusCode, 200);
    final data = res.data['data'] as List;
    expect(data, isNotEmpty);
    expect(data.first['id'], 'us-visa-free-30d');
    expect(data.first['country'], 'US');
  });

  test('GET /policies for RU includes visa-required policy', () async {
    final res = await dio.get<dynamic>(
      '/policies',
      queryParameters: {'country': 'RU'},
    );
    final data = res.data['data'] as List;
    expect(data.first['id'], 'ru-visa-required');
    expect(data.first['title'], contains('visa required'));
  });

  test('GET /policies for unknown country returns fallback card', () async {
    final res = await dio.get<dynamic>(
      '/policies',
      queryParameters: {'country': 'XX'},
    );
    final data = res.data['data'] as List;
    expect(data, hasLength(1));
    expect(data.first['id'], 'fallback-generic');
  });

  test('GET /policies appends reason overlay for education', () async {
    final res = await dio.get<dynamic>(
      '/policies',
      queryParameters: {'country': 'US', 'reason': 'education'},
    );
    final data = res.data['data'] as List;
    final ids = data.map((e) => e['id']).toList();
    expect(ids, contains('us-x1-visa'));
    expect(ids, contains('us-residence-permit-30d'));
  });

  test('GET /policies appends reason overlay for work', () async {
    final res = await dio.get<dynamic>(
      '/policies',
      queryParameters: {'country': 'DE', 'reason': 'work'},
    );
    final data = res.data['data'] as List;
    expect(data.map((e) => e['id']), contains('de-z-visa'));
  });

  test('GET /policies appends Q-visa overlay for family_visit', () async {
    final res = await dio.get<dynamic>(
      '/policies',
      queryParameters: {'country': 'GB', 'reason': 'family_visit'},
    );
    final data = res.data['data'] as List;
    expect(data.map((e) => e['id']), contains('gb-q-visa'));
  });

  test('GET /policies for tourism does NOT append overlay', () async {
    final res = await dio.get<dynamic>(
      '/policies',
      queryParameters: {'country': 'US', 'reason': 'tourism'},
    );
    final data = res.data['data'] as List;
    expect(data, hasLength(4));
    expect(data.map((e) => e['id']), isNot(contains('us-x1-visa')));
  });

  test('GET /policies localizes consular description per city', () async {
    final shRes = await dio.get<dynamic>(
      '/policies',
      queryParameters: {'country': 'US', 'city': 'SH'},
    );
    final bjRes = await dio.get<dynamic>(
      '/policies',
      queryParameters: {'country': 'US', 'city': 'BJ'},
    );
    final shConsular = (shRes.data['data'] as List)
        .firstWhere((e) => e['id'].toString().endsWith('-consular-contact'));
    final bjConsular = (bjRes.data['data'] as List)
        .firstWhere((e) => e['id'].toString().endsWith('-consular-contact'));
    expect(shConsular['description'], contains('上海'));
    expect(bjConsular['description'], contains('北京'));
  });

  test('GET /checklists adds visa-application row for RU only', () async {
    final usRes = await dio.get<dynamic>(
      '/checklists',
      queryParameters: {'country': 'US'},
    );
    final ruRes = await dio.get<dynamic>(
      '/checklists',
      queryParameters: {'country': 'RU'},
    );
    final usIds = (usRes.data['data'] as List).map((e) => e['id']).toList();
    final ruIds = (ruRes.data['data'] as List).map((e) => e['id']).toList();
    expect(usIds, isNot(contains('visa-application')));
    expect(ruIds, contains('visa-application'));
  });

  test('GET /checklists adds education overlays for education reason', () async {
    final res = await dio.get<dynamic>(
      '/checklists',
      queryParameters: {'country': 'US', 'reason': 'education'},
    );
    final ids = (res.data['data'] as List).map((e) => e['id']).toList();
    expect(ids, contains('university-documents'));
    expect(ids, contains('health-checkup'));
    expect(ids, contains('residence-permit-30d'));
  });

  test('GET /checklists adds PSB address row for Beijing', () async {
    final res = await dio.get<dynamic>(
      '/checklists',
      queryParameters: {'country': 'US', 'city': 'BJ'},
    );
    final ids = (res.data['data'] as List).map((e) => e['id']).toList();
    expect(ids, contains('bj-psb-address'));
  });

  test('GET /checklists adds other-city notice for EntryCity.other', () async {
    final res = await dio.get<dynamic>(
      '/checklists',
      queryParameters: {'country': 'US', 'city': 'OTHER'},
    );
    final ids = (res.data['data'] as List).map((e) => e['id']).toList();
    expect(ids, contains('other-city-notice'));
  });

  test('GET /pois/search returns POIs (defaults to Shanghai pool)', () async {
    final res = await dio.get<dynamic>('/pois/search');
    final data = res.data['data'] as List;
    expect(data.length, greaterThan(5));
    expect(data.first['id'], 'poi-bund');
  });

  test('GET /pois/search switches to Beijing pool when city=BJ', () async {
    final res = await dio.get<dynamic>(
      '/pois/search',
      queryParameters: {'city': 'BJ'},
    );
    final data = res.data['data'] as List;
    expect(data.map((p) => p['id']), contains('poi-forbidden-city'));
    expect(data.map((p) => p['id']), isNot(contains('poi-bund')));
  });

  test('GET /pois/search switches to Guangzhou pool when city=GZ', () async {
    final res = await dio.get<dynamic>(
      '/pois/search',
      queryParameters: {'city': 'GZ'},
    );
    final data = res.data['data'] as List;
    expect(data.map((p) => p['id']), contains('poi-canton-tower'));
  });

  test('GET /pois/search returns fallback card when city=OTHER', () async {
    final res = await dio.get<dynamic>(
      '/pois/search',
      queryParameters: {'city': 'OTHER'},
    );
    final data = res.data['data'] as List;
    expect(data, hasLength(1));
    expect(data.first['id'], 'poi-fallback');
  });

  test('GET /pois/search filters by category', () async {
    final res = await dio.get<dynamic>(
      '/pois/search',
      queryParameters: {'category': 'dining'},
    );
    final data = res.data['data'] as List;
    expect(data.every((p) => p['category'] == 'dining'), isTrue);
  });

  test('GET /pois/search filters by query', () async {
    final res = await dio.get<dynamic>(
      '/pois/search',
      queryParameters: {'q': 'bund'},
    );
    final data = res.data['data'] as List;
    expect(data, hasLength(1));
    expect(data.first['name'], contains('Bund'));
  });

  test('GET /discover/curated returns editor cards', () async {
    final res = await dio.get<dynamic>('/discover/curated');
    final data = res.data['data'] as List;
    expect(data.first['id'], 'cur-1');
  });

  test('GET /discover/heads-up returns alerts', () async {
    final res = await dio.get<dynamic>('/discover/heads-up');
    final data = res.data['data'] as List;
    expect(data, isNotEmpty);
    expect(data.first['id'], 'hu-1');
  });

  test('GET /tools/fx-rates returns rate object', () async {
    final res = await dio.get<dynamic>(
      '/tools/fx-rates',
      queryParameters: {'from': 'USD', 'to': 'CNY'},
    );
    final data = res.data['data'] as Map<String, dynamic>;
    expect(data['from'], 'USD');
    expect(data['to'], 'CNY');
    expect(data['rate'], 7.18);
  });

  test('GET /tools/fx-rates returns identity rate for same currency', () async {
    final res = await dio.get<dynamic>(
      '/tools/fx-rates',
      queryParameters: {'from': 'CNY', 'to': 'CNY'},
    );
    expect(res.data['data']['rate'], 1.0);
  });

  test('GET /me/preferences returns default object', () async {
    final res = await dio.get<dynamic>('/me/preferences');
    expect(res.data['data']['country'], 'US');
    expect(res.data['data']['unitSystem'], 'metric');
  });

  test('POST /corrections returns queued ack', () async {
    final res = await dio.post<dynamic>('/corrections', data: {'foo': 'bar'});
    expect(res.data['data']['status'], 'queued');
    expect(res.data['data']['reviewSlaHours'], 48);
  });

  test('unmatched path passes through', () async {
    mockInterceptor.simulateOffline = false;
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

  test('legacy MockData.emptyData constant remains available', () {
    expect(MockData.emptyData['data'], isEmpty);
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
