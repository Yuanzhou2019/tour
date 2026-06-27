import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sightour/features/onboarding/presentation/pages/privacy_consent_page.dart';
import 'package:sightour/l10n/generated/app_localizations.dart';

void main() {
  Widget _wrap(Widget child, {Locale locale = const Locale('en')}) =>
      MaterialApp(
        locale: locale,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: child,
      );

  testWidgets('Initial state: Enter button disabled', (tester) async {
    await tester.pumpWidget(_wrap(const PrivacyConsentPage()));
    await tester.pumpAndSettle();
    final btn = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'Enter Sightour'));
    expect(btn.onPressed, isNull);
  });

  testWidgets('Check both → Enter button enabled', (tester) async {
    await tester.pumpWidget(_wrap(const PrivacyConsentPage()));
    await tester.pumpAndSettle();
    await tester
        .tap(find.text('I have read and agree to the privacy policy'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('I agree to the terms of service'));
    await tester.pumpAndSettle();
    final btn = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'Enter Sightour'));
    expect(btn.onPressed, isNotNull);
  });

  testWidgets('ZH: 按钮文字 + 必勾选', (tester) async {
    await tester.pumpWidget(
      _wrap(const PrivacyConsentPage(), locale: const Locale('zh')),
    );
    await tester.pumpAndSettle();
    expect(find.text('隐私与服务条款'), findsOneWidget);
  });
}
