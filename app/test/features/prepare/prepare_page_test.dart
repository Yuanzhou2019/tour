import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:sightour/core/di/injection.dart';
import 'package:sightour/features/prepare/domain/entities/checklist_item.dart';
import 'package:sightour/features/prepare/domain/entities/policy.dart';
import 'package:sightour/features/prepare/domain/repositories/checklist_repository.dart';
import 'package:sightour/features/prepare/domain/repositories/policy_repository.dart';
import 'package:sightour/features/prepare/presentation/cubit/prepare_home_cubit.dart';
import 'package:sightour/features/prepare/presentation/pages/prepare_page.dart';
import 'package:sightour/l10n/generated/app_localizations.dart';

class _FakePathProvider extends PathProviderPlatform with MockPlatformInterfaceMixin {
  @override
  Future<String?> getApplicationDocumentsPath() async =>
      '.dart_test/app_docs_prepare_page';
}

class _FakePolicyRepo implements PolicyRepository {
  const _FakePolicyRepo();
  @override
  Future<List<Policy>> fetchPolicies(String country) async => [
        Policy(
          id: '1',
          title: 'Visa-free 30 days',
          description: 'US passport holders',
          source: 'gov.cn',
          country: country,
        ),
      ];
}

class _FakeChecklistRepo implements ChecklistRepository {
  const _FakeChecklistRepo();
  @override
  Future<List<ChecklistItem>> fetchChecklist(String country) async => const [
        ChecklistItem(id: 'a', title: 'Passport', done: false),
        ChecklistItem(id: 'b', title: 'Cash', done: true),
      ];
}

Widget _wrap() => MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: const PreparePage(),
    );

void main() {
  setUpAll(() async {
    PathProviderPlatform.instance = _FakePathProvider();
    Hive.init('.dart_test/hive_prepare_page_${DateTime.now().microsecondsSinceEpoch}');
    await Hive.openBox('prefs');
    if (!getIt.isRegistered<PrepareHomeCubit>()) {
      getIt.registerFactory<PrepareHomeCubit>(
        () => PrepareHomeCubit(
          const _FakePolicyRepo(),
          const _FakeChecklistRepo(),
        ),
      );
    }
  });

  testWidgets('renders all sections with seeded data', (tester) async {
    await tester.pumpWidget(_wrap());
    await tester.pumpAndSettle();
    expect(find.text('What you need to know'), findsOneWidget);
    expect(find.text('Pre-arrival checklist'), findsOneWidget);
    expect(find.text('Offline downloads'), findsOneWidget);
    expect(find.text('Visa-free 30 days'), findsOneWidget);
    expect(find.text('Passport'), findsOneWidget);
    expect(find.text('Cash'), findsOneWidget);
  });

  testWidgets('toggling checklist item updates progress text', (tester) async {
    await tester.pumpWidget(_wrap());
    await tester.pumpAndSettle();
    expect(find.text('1 / 2 done'), findsOneWidget);
    final checkboxes = find.byType(Checkbox);
    expect(checkboxes, findsNWidgets(2));
    await tester.tap(checkboxes.first);
    await tester.pumpAndSettle();
    expect(find.text('2 / 2 done'), findsOneWidget);
  });
}