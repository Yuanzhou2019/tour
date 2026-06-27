import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:sightour/core/di/injection.dart';
import 'package:sightour/core/network/dio_client.dart';
import 'package:sightour/core/network/interceptors/auth_interceptor.dart';
import 'package:sightour/core/network/interceptors/error_interceptor.dart';
import 'package:sightour/core/network/interceptors/logging_interceptor.dart';
import 'package:sightour/core/network/interceptors/mock_interceptor.dart';
import 'package:sightour/core/network/interceptors/retry_interceptor.dart';
import 'package:sightour/core/storage/hive_boxes.dart';
import 'package:sightour/features/feedback/data/repositories/feedback_repository_impl.dart';
import 'package:sightour/features/feedback/domain/repositories/feedback_repository.dart';
import 'package:sightour/features/feedback/presentation/cubit/feedback_form_cubit.dart';
import 'package:sightour/features/feedback/presentation/pages/feedback_form_page.dart';
import 'package:sightour/l10n/generated/app_localizations.dart';

class _FakePathProvider extends PathProviderPlatform with MockPlatformInterfaceMixin {
  @override
  Future<String?> getApplicationDocumentsPath() async => '.dart_test/app_docs_fb_page';
}

void main() {
  setUpAll(() async {
    PathProviderPlatform.instance = _FakePathProvider();
    Hive.init('.dart_test/hive_fb_page_${DateTime.now().microsecondsSinceEpoch}');
    await Hive.openBox(HiveBoxes.prefs);
    await configureDependencies();
    if (!getIt.isRegistered<FeedbackRepository>()) {
      final client = DioClient(
        AuthInterceptor(),
        LoggingInterceptor(),
        ErrorInterceptor(),
        MockInterceptor(),
        RetryInterceptor(),
      );
      getIt.registerLazySingleton<FeedbackRepository>(
        () => FeedbackRepositoryImpl(client),
      );
    }
    if (!getIt.isRegistered<FeedbackFormCubit>()) {
      getIt.registerFactory<FeedbackFormCubit>(
        () => FeedbackFormCubit(getIt<FeedbackRepository>()),
      );
    }
  });

  Widget _wrap() => const MaterialApp(
        locale: Locale('en'),
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: FeedbackFormPage(),
      );

  testWidgets('renders 4 type chips + message field + submit', (tester) async {
    await tester.pumpWidget(_wrap());
    await tester.pumpAndSettle();
    expect(find.text('Bug report'), findsOneWidget);
    expect(find.text('Wrong information'), findsOneWidget);
    expect(find.text('Suggestion'), findsOneWidget);
    expect(find.text('Other'), findsOneWidget);
    expect(find.text('Send'), findsOneWidget);
  });

  testWidgets('Submit disabled when message empty', (tester) async {
    await tester.pumpWidget(_wrap());
    await tester.pumpAndSettle();
    final btn = tester.widget<ElevatedButton>(find.widgetWithText(ElevatedButton, 'Send'));
    expect(btn.onPressed, isNull);
  });

  testWidgets('Type chip tap updates selected state', (tester) async {
    await tester.pumpWidget(_wrap());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Suggestion'));
    await tester.pumpAndSettle();
    final chip = tester.widget<ChoiceChip>(find.widgetWithText(ChoiceChip, 'Suggestion'));
    expect(chip.selected, true);
  });

  testWidgets('Entering > 10 chars enables submit', (tester) async {
    await tester.pumpWidget(_wrap());
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'this is a valid message');
    await tester.pumpAndSettle();
    final btn = tester.widget<ElevatedButton>(find.widgetWithText(ElevatedButton, 'Send'));
    expect(btn.onPressed, isNotNull);
  });
}