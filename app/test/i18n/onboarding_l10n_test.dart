import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sightour/l10n/generated/app_localizations.dart';

Future<AppLocalizations> _buildL10n(WidgetTester tester, Locale locale) async {
  late AppLocalizations l10n;
  await tester.pumpWidget(
    MaterialApp(
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Builder(builder: (ctx) {
        l10n = AppLocalizations.of(ctx);
        return const SizedBox.shrink();
      }),
    ),
  );
  return l10n;
}

void main() {
  testWidgets('EN: 32 onboarding keys', (tester) async {
    final l = await _buildL10n(tester, const Locale('en'));
    expect(l.commonNext, 'Next');
    expect(l.commonGetStarted, 'Get started');
    expect(l.onboardingWelcomeTitle, 'Welcome to Sightour');
    expect(l.onboardingWelcomeSubtitle, startsWith('Your private guide'));
    expect(l.onboardingFeaturesTitle, 'Everything you need, in one place');
    expect(l.onboardingFeaturesPrepareTitle, 'Prepare before you fly');
    expect(l.onboardingFeaturesPrepareDesc, contains('Visa'));
    expect(l.onboardingFeaturesMapTitle, 'Map that respects you');
    expect(l.onboardingFeaturesMapDesc, contains('honest read'));
    expect(l.onboardingFeaturesDiscoverTitle, contains('actually good'));
    expect(l.onboardingFeaturesDiscoverDesc, contains('Curated lists'));
    expect(l.onboardingFeaturesToolsTitle, contains('offline'));
    expect(l.onboardingFeaturesToolsDesc, contains('Wi-Fi'));
    expect(l.onboardingSettingsTitle, 'Quick setup');
    expect(l.onboardingSettingsSubtitle, contains('tailor'));
    expect(l.onboardingSettingsLanguage, 'Language');
    expect(l.onboardingSettingsTheme, 'Appearance');
    expect(l.onboardingSettingsCountry, contains('passport'));
    expect(l.onboardingSettingsUnit, 'Units');
    expect(l.onboardingSettingsCountryHint, 'Select your country');
    expect(l.privacyTitle, 'Privacy & terms');
    expect(l.privacyIntro, contains('visitors'));
    expect(l.privacyPoint1, contains('No account'));
    expect(l.privacyPoint2, contains('anonymous'));
    expect(l.privacyPoint3, contains('this device'));
    expect(l.privacyPoint4, contains('error reports'));
    expect(l.privacyPoint5, contains('anonymous'));
    expect(l.privacyPoint6, contains('full privacy'));
    expect(l.privacyAgree, contains('agree'));
    expect(l.privacyTermsAgree, contains('terms of service'));
    expect(l.privacyEnter, 'Enter Sightour');
  });

  testWidgets('ZH: 32 onboarding keys', (tester) async {
    final l = await _buildL10n(tester, const Locale('zh'));
    expect(l.commonNext, '下一步');
    expect(l.commonGetStarted, '开始使用');
    expect(l.onboardingWelcomeTitle, '欢迎使用 Sightour');
    expect(l.onboardingFeaturesPrepareTitle, '行前准备');
    expect(l.onboardingFeaturesMapTitle, '尊重你的地图');
    expect(l.onboardingFeaturesDiscoverTitle, contains('发现'));
    expect(l.onboardingFeaturesToolsTitle, contains('离线'));
    expect(l.onboardingSettingsTitle, '快速设置');
    expect(l.privacyTitle, '隐私与服务条款');
    expect(l.privacyAgree, contains('同意'));
    expect(l.privacyTermsAgree, contains('同意'));
    expect(l.privacyEnter, '进入 Sightour');
  });
}
