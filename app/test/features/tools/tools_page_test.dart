import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:sightour/core/di/injection.dart';
import 'package:sightour/features/tools/domain/entities/fx_rate.dart';
import 'package:sightour/features/tools/domain/entities/tool_entry.dart';
import 'package:sightour/features/tools/domain/repositories/fx_repository.dart';
import 'package:sightour/features/tools/domain/repositories/tools_repository.dart';
import 'package:sightour/features/tools/presentation/cubit/fx_converter_cubit.dart';
import 'package:sightour/features/tools/presentation/cubit/tools_home_cubit.dart';
import 'package:sightour/features/tools/presentation/pages/tools_page.dart';
import 'package:sightour/l10n/generated/app_localizations.dart';

class _FakePathProvider extends PathProviderPlatform with MockPlatformInterfaceMixin {
  @override
  Future<String?> getApplicationDocumentsPath() async =>
      '.dart_test/app_docs_tools_page';
}

class _FakeFxRepo implements FxRepository {
  @override
  Future<FxRate> rate(String from, String to) async => FxRate(
        from: from,
        to: to,
        rate: 7.0,
        updatedAt: DateTime(2026, 6, 28),
      );
}

class _FakeToolsRepo implements ToolsRepository {
  @override
  List<ToolEntry> entries() => const [
        ToolEntry(
          id: 'phrases',
          title: 'Phrase book',
          subtitle: 'Border · Transport',
          icon: Icons.translate,
        ),
      ];
}

Widget _wrap() => const MaterialApp(
      locale: Locale('en'),
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: ToolsPage(),
    );

void main() {
  setUpAll(() async {
    PathProviderPlatform.instance = _FakePathProvider();
    Hive.init('.dart_test/hive_tools_page_${DateTime.now().microsecondsSinceEpoch}');
    await Hive.openBox('prefs');
    if (!getIt.isRegistered<FxConverterCubit>()) {
      getIt.registerFactory<FxConverterCubit>(() => FxConverterCubit(_FakeFxRepo()));
    }
    if (!getIt.isRegistered<ToolsHomeCubit>()) {
      getIt.registerFactory<ToolsHomeCubit>(() => ToolsHomeCubit(_FakeToolsRepo()));
    }
  });

  testWidgets('renders FX converter and tool entries', (tester) async {
    await tester.pumpWidget(_wrap());
    await tester.pumpAndSettle();
    expect(find.text('CURRENCY'), findsOneWidget);
    expect(find.text('ALL TOOLS'), findsOneWidget);
    expect(find.text('Live currency'), findsOneWidget);
    expect(find.text('Phrase book'), findsOneWidget);
  });

  testWidgets('tapping a tool entry shows coming soon toast', (tester) async {
    await tester.pumpWidget(_wrap());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Phrase book'));
    await tester.pump();
    expect(find.textContaining('coming soon'), findsOneWidget);
  });
}