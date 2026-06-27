import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:sightour/core/di/injection.dart';
import 'package:sightour/core/i18n/locale_cubit.dart';
import 'package:sightour/core/storage/hive_boxes.dart';
import 'package:sightour/features/you/presentation/pages/you_page.dart';
import 'package:sightour/l10n/generated/app_localizations.dart';

class _FakePathProvider extends PathProviderPlatform with MockPlatformInterfaceMixin {
  @override
  Future<String?> getApplicationDocumentsPath() async => '.dart_test/app_docs_you';
}

void main() {
  setUpAll(() async {
    PathProviderPlatform.instance = _FakePathProvider();
    Hive.init('.dart_test/hive_you_${DateTime.now().microsecondsSinceEpoch}');
    await Hive.openBox(HiveBoxes.prefs);
    await configureDependencies();
  });

  Widget _wrap(Widget child) => BlocProvider<LocaleCubit>(
        create: (_) => getIt<LocaleCubit>(),
        child: MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: child,
        ),
      );

  testWidgets('YouPage renders Profile + Preferences + Feedback', (tester) async {
    await tester.pumpWidget(_wrap(const YouPage()));
    await tester.pumpAndSettle();
    expect(find.text('You'), findsWidgets);
    expect(find.textContaining('Device ID'), findsOneWidget);
    expect(find.textContaining('Preferences'), findsOneWidget);
    expect(find.text('Send feedback'), findsOneWidget);
  });
}