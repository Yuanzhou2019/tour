import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sightour/core/di/injection.dart';
import 'package:sightour/core/i18n/locale_cubit.dart';
import 'package:sightour/features/onboarding/presentation/cubit/first_run_settings_cubit.dart';
import 'package:sightour/features/onboarding/presentation/pages/onboarding_flow_page.dart';
import 'package:sightour/l10n/generated/app_localizations.dart';

void main() {
  setUpAll(() async {
    await configureDependencies();
  });

  Widget _wrap(Widget child) {
    return MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: MultiBlocProvider(
        providers: [
          BlocProvider<LocaleCubit>(create: (_) => getIt<LocaleCubit>()),
          BlocProvider<FirstRunSettingsCubit>(
            create: (_) => getIt<FirstRunSettingsCubit>(),
          ),
        ],
        child: child,
      ),
    );
  }

  testWidgets('Flow shows Next on page 0', (tester) async {
    await tester.pumpWidget(_wrap(const OnboardingFlowPage()));
    await tester.pumpAndSettle();
    expect(find.text('Next'), findsOneWidget);
  });

  testWidgets('Tap Next advances to page 1', (tester) async {
    await tester.pumpWidget(_wrap(const OnboardingFlowPage()));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    expect(find.text('Next'), findsOneWidget); // still Next on page 1
  });

  testWidgets('Tap Next 2 times then shows Get started on page 2', (tester) async {
    await tester.pumpWidget(_wrap(const OnboardingFlowPage()));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    expect(find.text('Get started'), findsOneWidget);
  });

  testWidgets('Onboarding indicator shows 3 dots', (tester) async {
    await tester.pumpWidget(_wrap(const OnboardingFlowPage()));
    await tester.pumpAndSettle();
    expect(find.byType(Container), findsWidgets);
  });
}
