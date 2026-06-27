import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sightour/l10n/generated/app_localizations.dart';

void main() {
  testWidgets('AppLocalizations provides all 20 keys in en', (tester) async {
    late AppLocalizations l10n;
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (ctx) {
            l10n = AppLocalizations.of(ctx);
            return const SizedBox.shrink();
          },
        ),
      ),
    );
    expect(l10n.appTitle, 'Sightour');
    expect(l10n.tabPrepare, 'Prepare');
    expect(l10n.tabMap, 'Map');
    expect(l10n.tabDiscover, 'Discover');
    expect(l10n.tabTools, 'Tools');
    expect(l10n.tabYou, 'You');
    expect(l10n.commonConfirm, 'Confirm');
    expect(l10n.commonCancel, 'Cancel');
    expect(l10n.commonRetry, 'Try again');
    expect(l10n.commonError, 'Something went wrong');
    expect(l10n.commonLoading, 'Loading…');
    expect(l10n.commonComingSoon, 'Coming soon');
    expect(l10n.commonOffline, "You're offline");
    expect(l10n.prepareTitle('US'), 'Prepare · US');
    expect(l10n.mapTitle, 'Map');
    expect(l10n.mapSearchHint, 'Search places, addresses, transit');
    expect(l10n.discoverTitle, 'Discover Shanghai');
    expect(l10n.toolsTitle, 'Tools');
    expect(l10n.youTitle, 'You');
    expect(l10n.policyVisaFree, '30-day visa-free entry');
    expect(l10n.policyTransit, '240-hour visa-free transit');
  });

  testWidgets('AppLocalizations provides zh translations', (tester) async {
    late AppLocalizations l10n;
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('zh'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (ctx) {
            l10n = AppLocalizations.of(ctx);
            return const SizedBox.shrink();
          },
        ),
      ),
    );
    expect(l10n.appTitle, 'Sightour');
    expect(l10n.tabPrepare, '行前');
    expect(l10n.commonConfirm, '确认');
    expect(l10n.prepareTitle('美国'), '行前准备 · 美国');
  });
}
