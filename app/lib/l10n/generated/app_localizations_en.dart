// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Sightour';

  @override
  String get tabPrepare => 'Prepare';

  @override
  String get tabMap => 'Map';

  @override
  String get tabDiscover => 'Discover';

  @override
  String get tabTools => 'Tools';

  @override
  String get tabYou => 'You';

  @override
  String get commonConfirm => 'Confirm';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonRetry => 'Try again';

  @override
  String get commonError => 'Something went wrong';

  @override
  String get commonLoading => 'Loading…';

  @override
  String get commonComingSoon => 'Coming soon';

  @override
  String get commonOffline => 'You\'re offline';

  @override
  String get commonNext => 'Next';

  @override
  String get commonGetStarted => 'Get started';

  @override
  String prepareTitle(String nationality) {
    return 'Prepare · $nationality';
  }

  @override
  String get mapTitle => 'Map';

  @override
  String get mapSearchHint => 'Search places, addresses, transit';

  @override
  String get discoverTitle => 'Discover Shanghai';

  @override
  String get toolsTitle => 'Tools';

  @override
  String get youTitle => 'You';

  @override
  String get policyVisaFree => '30-day visa-free entry';

  @override
  String get policyTransit => '240-hour visa-free transit';

  @override
  String get onboardingWelcomeTitle => 'Welcome to Sightour';

  @override
  String get onboardingWelcomeSubtitle =>
      'Your private guide to Shanghai. Built for visitors, no account needed.';

  @override
  String get onboardingFeaturesTitle => 'Everything you need, in one place';

  @override
  String get onboardingFeaturesPrepareTitle => 'Prepare before you fly';

  @override
  String get onboardingFeaturesPrepareDesc =>
      'Visa, currency, weather — answered in 30 seconds for your passport.';

  @override
  String get onboardingFeaturesMapTitle => 'Map that respects you';

  @override
  String get onboardingFeaturesMapDesc =>
      'Tap an attraction, get an honest read from local visitors.';

  @override
  String get onboardingFeaturesDiscoverTitle =>
      'Discover what\'s actually good';

  @override
  String get onboardingFeaturesDiscoverDesc =>
      'Curated lists — not SEO-spam rankings.';

  @override
  String get onboardingFeaturesToolsTitle => 'Tools that work offline';

  @override
  String get onboardingFeaturesToolsDesc =>
      'Phrases, FX, emergency numbers — when Wi-Fi is dead.';

  @override
  String get onboardingSettingsTitle => 'Quick setup';

  @override
  String get onboardingSettingsSubtitle =>
      'We\'ll tailor Sightour to you. You can change any of this later.';

  @override
  String get onboardingSettingsLanguage => 'Language';

  @override
  String get onboardingSettingsTheme => 'Appearance';

  @override
  String get onboardingSettingsCountry => 'Your passport country';

  @override
  String get onboardingSettingsUnit => 'Units';

  @override
  String get onboardingSettingsCountryHint => 'Select your country';

  @override
  String get privacyTitle => 'Privacy & terms';

  @override
  String get privacyIntro =>
      'Sightour is built for visitors. Here\'s what we do — and don\'t do — with your data.';

  @override
  String get privacyPoint1 => 'No account, no login, no email required.';

  @override
  String get privacyPoint2 =>
      'An anonymous device ID is generated to remember your settings. Nothing else.';

  @override
  String get privacyPoint3 =>
      'Your checklist and favorites are stored on this device only.';

  @override
  String get privacyPoint4 =>
      'You choose whether error reports include your location.';

  @override
  String get privacyPoint5 =>
      'Correction submissions are anonymous unless you sign them.';

  @override
  String get privacyPoint6 => 'Read the full privacy policy';

  @override
  String get privacyAgree => 'I have read and agree to the privacy policy';

  @override
  String get privacyTermsAgree => 'I agree to the terms of service';

  @override
  String get privacyEnter => 'Enter Sightour';

  @override
  String get youProfileAnonymousId => 'Device ID';

  @override
  String get youPreferences => 'Preferences';

  @override
  String get youFeedback => 'Send feedback';

  @override
  String get youPreferencesComingSoon => 'Preferences (coming soon)';

  @override
  String get feedbackTitle => 'Send feedback';

  @override
  String get feedbackTypeLabel => 'What is this about?';

  @override
  String get feedbackMessageLabel => 'Tell us more';

  @override
  String get feedbackMessageHint =>
      'Share what happened, or what you\'d like to see. (min 10 chars)';

  @override
  String get feedbackSubmit => 'Send';

  @override
  String get feedbackSubmitting => 'Sending…';

  @override
  String get feedbackSuccess => 'Thanks! We received your feedback.';

  @override
  String get feedbackErrorTitle => 'Could not send';

  @override
  String get feedbackRetry => 'Try again';
}
