import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/di/injection.dart';
import 'core/i18n/locale_cubit.dart';
import 'core/network/interceptors/mock_interceptor.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_cubit.dart';
import 'l10n/generated/app_localizations.dart';

class SightourApp extends StatelessWidget {
  const SightourApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LocaleCubit>(create: (_) => getIt<LocaleCubit>()..loadFromStorage()),
        BlocProvider<ThemeCubit>(create: (_) => getIt<ThemeCubit>()..loadFromStorage()),
      ],
      child: BlocBuilder<LocaleCubit, Locale>(
        builder: (_, locale) {
          return BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (_, themeMode) {
              return BlocListener<LocaleCubit, Locale>(
                // Push the active locale into the mock interceptor so the
                // canned responses return Chinese strings when the user
                // switches to a `zh` locale. This is a no-op for the
                // real backend; only the dev mock layer uses it.
                listener: (_, activeLocale) {
                  getIt<MockInterceptor>().locale = activeLocale.languageCode;
                },
                child: MaterialApp.router(
                  title: 'Sightour',
                  debugShowCheckedModeBanner: false,
                  theme: AppTheme.light(),
                  darkTheme: AppTheme.dark(),
                  themeMode: themeMode,
                  routerConfig: appRouter,
                  locale: locale,
                  localizationsDelegates: AppLocalizations.localizationsDelegates,
                  supportedLocales: AppLocalizations.supportedLocales,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
