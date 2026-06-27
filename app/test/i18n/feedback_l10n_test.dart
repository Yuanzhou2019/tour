import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sightour/l10n/generated/app_localizations.dart';

Future<AppLocalizations> _l10n(WidgetTester t, Locale l) async {
  late AppLocalizations r;
  await t.pumpWidget(MaterialApp(
    locale: l,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Builder(builder: (c) {
      r = AppLocalizations.of(c);
      return const SizedBox.shrink();
    }),
  ));
  return r;
}

void main() {
  testWidgets('EN: feedback/you keys', (tester) async {
    final l = await _l10n(tester, const Locale('en'));
    expect(l.youProfileAnonymousId, 'Device ID');
    expect(l.youPreferences, 'Preferences');
    expect(l.youFeedback, 'Send feedback');
    expect(l.feedbackTitle, 'Send feedback');
    expect(l.feedbackTypeLabel, 'What is this about?');
    expect(l.feedbackMessageLabel, 'Tell us more');
    expect(l.feedbackMessageHint, contains('min 10'));
    expect(l.feedbackSubmit, 'Send');
    expect(l.feedbackSubmitting, contains('Sending'));
    expect(l.feedbackSuccess, contains('Thanks'));
    expect(l.feedbackErrorTitle, 'Could not send');
    expect(l.feedbackRetry, 'Try again');
  });

  testWidgets('ZH: feedback/you keys', (tester) async {
    final l = await _l10n(tester, const Locale('zh'));
    expect(l.youFeedback, '发送反馈');
    expect(l.feedbackTitle, '发送反馈');
    expect(l.feedbackSubmit, '发送');
    expect(l.feedbackSuccess, contains('感谢'));
    expect(l.feedbackErrorTitle, '发送失败');
    expect(l.feedbackRetry, '重试');
  });
}