import 'package:flutter/material.dart';

import 'app.dart';
import 'core/di/injection.dart';
import 'core/network/dio_client.dart';
import 'core/network/interceptors/mock_interceptor.dart';
import 'core/storage/hive_init.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveInit.init();
  await configureDependencies();

  // --dart-define=USE_MOCK=false to hit the real backend.
  final useMock = const bool.fromEnvironment('USE_MOCK', defaultValue: true);
  if (!useMock) {
    getIt<MockInterceptor>().enabled = false;
    final apiBase = const String.fromEnvironment('API_BASE');
    if (apiBase.isNotEmpty) {
      getIt<DioClient>().dio.options.baseUrl = apiBase;
    }
  }

  runApp(const SightourApp());
}
