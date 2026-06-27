class MockData {
  MockData._();

  /// 全部 6 个端点统一返回空 data
  static const Map<String, dynamic> emptyData = <String, dynamic>{
    'data': <dynamic>[],
    'meta': <String, dynamic>{
      'page': 1,
      'pageSize': 20,
      'total': 0,
    },
  };
}
