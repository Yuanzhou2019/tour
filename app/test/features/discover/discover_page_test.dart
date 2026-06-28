import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:sightour/core/di/injection.dart';
import 'package:sightour/features/discover/domain/entities/discover_card.dart';
import 'package:sightour/features/discover/domain/repositories/discover_repository.dart';
import 'package:sightour/features/discover/presentation/cubit/discover_home_cubit.dart';
import 'package:sightour/features/discover/presentation/pages/discover_page.dart';
import 'package:sightour/l10n/generated/app_localizations.dart';

class _FakePathProvider extends PathProviderPlatform with MockPlatformInterfaceMixin {
  @override
  Future<String?> getApplicationDocumentsPath() async =>
      '.dart_test/app_docs_discover_page';
}

class _FakeDiscoverRepo implements DiscoverRepository {
  const _FakeDiscoverRepo();
  @override
  Future<List<DiscoverCard>> curated() async => const [
        DiscoverCard(id: 'c1', title: 'Top 5 museums', subtitle: 'Handpicked', score: 4.8),
      ];

  @override
  Future<List<DiscoverCard>> authentic() async => const [
        DiscoverCard(id: 'a1', title: 'Hidden noodle bars', subtitle: 'Local', score: 4.6),
      ];

  @override
  Future<List<DiscoverCard>> headsUp() async => const [
        DiscoverCard(id: 'h1', title: 'Crowd alerts', subtitle: 'Heads up', score: 4.2),
      ];
}

class _EmptyDiscoverRepo implements DiscoverRepository {
  const _EmptyDiscoverRepo();
  @override
  Future<List<DiscoverCard>> curated() async => const [];
  @override
  Future<List<DiscoverCard>> authentic() async => const [];
  @override
  Future<List<DiscoverCard>> headsUp() async => const [];
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
      home: DiscoverPage(),
    );

void main() {
  setUpAll(() async {
    PathProviderPlatform.instance = _FakePathProvider();
    Hive.init('.dart_test/hive_discover_page_${DateTime.now().microsecondsSinceEpoch}');
    await Hive.openBox('prefs');
    if (!getIt.isRegistered<DiscoverHomeCubit>()) {
      getIt.registerFactory<DiscoverHomeCubit>(
        () => DiscoverHomeCubit(const _FakeDiscoverRepo()),
      );
    }
  });

  testWidgets('renders segmented tabs + initial curated card', (tester) async {
    await tester.pumpWidget(_wrap());
    await tester.pumpAndSettle();
    expect(find.text('Curated'), findsOneWidget);
    expect(find.text('Authentic'), findsOneWidget);
    expect(find.text('Heads-up'), findsOneWidget);
    expect(find.text('Top 5 museums'), findsOneWidget);
  });

  testWidgets('tapping Authentic switches tab and loads authentic cards',
      (tester) async {
    await tester.pumpWidget(_wrap());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Authentic'));
    await tester.pumpAndSettle();
    expect(find.text('Hidden noodle bars'), findsOneWidget);
  });

  testWidgets('empty state shows hint when no cards', (tester) async {
    if (getIt.isRegistered<DiscoverHomeCubit>()) {
      await getIt.unregister<DiscoverHomeCubit>();
    }
    getIt.registerFactory<DiscoverHomeCubit>(
      () => DiscoverHomeCubit(const _EmptyDiscoverRepo()),
    );
    await tester.pumpWidget(_wrap());
    await tester.pumpAndSettle();
    expect(find.text('Nothing here yet'), findsOneWidget);
  });
}