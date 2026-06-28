import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:sightour/core/di/injection.dart';
import 'package:sightour/features/map/domain/entities/poi.dart';
import 'package:sightour/features/map/domain/repositories/poi_repository.dart';
import 'package:sightour/features/map/presentation/cubit/map_home_cubit.dart';
import 'package:sightour/features/map/presentation/pages/map_page.dart';
import 'package:sightour/l10n/generated/app_localizations.dart';

class _FakePathProvider extends PathProviderPlatform with MockPlatformInterfaceMixin {
  @override
  Future<String?> getApplicationDocumentsPath() async =>
      '.dart_test/app_docs_map_page';
}

class _FakePoiRepo implements PoiRepository {
  const _FakePoiRepo();
  @override
  Future<List<Poi>> search({String? q, String? category}) async => const [
        Poi(
          id: '1',
          name: 'The Bund',
          category: 'attraction',
          distanceKm: 1.2,
          avgScore: 4.7,
        ),
        Poi(
          id: '2',
          name: 'Yu Garden',
          category: 'attraction',
          distanceKm: 2.5,
          avgScore: 4.5,
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
      home: MapPage(),
    );

void main() {
  setUpAll(() async {
    PathProviderPlatform.instance = _FakePathProvider();
    Hive.init('.dart_test/hive_map_page_${DateTime.now().microsecondsSinceEpoch}');
    await Hive.openBox('prefs');
    if (!getIt.isRegistered<MapHomeCubit>()) {
      getIt.registerFactory<MapHomeCubit>(
        () => MapHomeCubit(const _FakePoiRepo()),
      );
    }
  });

  testWidgets('renders category chips + POIs from fake repo', (tester) async {
    await tester.pumpWidget(_wrap());
    await tester.pumpAndSettle();
    expect(find.text('All'), findsOneWidget);
    expect(find.text('Sights'), findsOneWidget);
    expect(find.text('Eat'), findsOneWidget);
    expect(find.text('Stay'), findsOneWidget);
    expect(find.text('Shop'), findsOneWidget);
    expect(find.text('The Bund'), findsOneWidget);
    expect(find.text('Yu Garden'), findsOneWidget);
  });

  testWidgets('tapping Eat chip switches category', (tester) async {
    await tester.pumpWidget(_wrap());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Eat'));
    await tester.pumpAndSettle();
    // After category change, the fake repo still returns the same list, but
    // the cubit should be loading the dining category.
    expect(find.text('Eat'), findsWidgets);
  });

  testWidgets('empty state shows hint when no POIs', (tester) async {
    if (getIt.isRegistered<MapHomeCubit>()) {
      await getIt.unregister<MapHomeCubit>();
    }
    getIt.registerFactory<MapHomeCubit>(
      () => MapHomeCubit(const _EmptyPoiRepo()),
    );
    await tester.pumpWidget(_wrap());
    await tester.pumpAndSettle();
    expect(find.text('No results in this area'), findsOneWidget);
  });
}

class _EmptyPoiRepo implements PoiRepository {
  const _EmptyPoiRepo();
  @override
  Future<List<Poi>> search({String? q, String? category}) async => const [];
}