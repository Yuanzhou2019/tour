import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Sightour'**
  String get appTitle;

  /// No description provided for @tabPrepare.
  ///
  /// In en, this message translates to:
  /// **'Prepare'**
  String get tabPrepare;

  /// No description provided for @tabMap.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get tabMap;

  /// No description provided for @tabDiscover.
  ///
  /// In en, this message translates to:
  /// **'Discover'**
  String get tabDiscover;

  /// No description provided for @tabTools.
  ///
  /// In en, this message translates to:
  /// **'Tools'**
  String get tabTools;

  /// No description provided for @tabYou.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get tabYou;

  /// No description provided for @commonConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get commonConfirm;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonRetry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get commonRetry;

  /// No description provided for @commonError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get commonError;

  /// No description provided for @commonLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading…'**
  String get commonLoading;

  /// No description provided for @commonComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get commonComingSoon;

  /// No description provided for @commonOffline.
  ///
  /// In en, this message translates to:
  /// **'You\'re offline'**
  String get commonOffline;

  /// No description provided for @commonNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get commonNext;

  /// No description provided for @commonGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get commonGetStarted;

  /// No description provided for @prepareTitle.
  ///
  /// In en, this message translates to:
  /// **'Prepare · {nationality}'**
  String prepareTitle(String nationality);

  /// No description provided for @mapTitle.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get mapTitle;

  /// No description provided for @mapSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search places, addresses, transit'**
  String get mapSearchHint;

  /// No description provided for @discoverTitle.
  ///
  /// In en, this message translates to:
  /// **'Discover Shanghai'**
  String get discoverTitle;

  /// No description provided for @toolsTitle.
  ///
  /// In en, this message translates to:
  /// **'Tools'**
  String get toolsTitle;

  /// No description provided for @youTitle.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get youTitle;

  /// No description provided for @policyVisaFree.
  ///
  /// In en, this message translates to:
  /// **'30-day visa-free entry'**
  String get policyVisaFree;

  /// No description provided for @policyTransit.
  ///
  /// In en, this message translates to:
  /// **'240-hour visa-free transit'**
  String get policyTransit;

  /// No description provided for @onboardingWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Sightour'**
  String get onboardingWelcomeTitle;

  /// No description provided for @onboardingWelcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your private guide to Shanghai. Built for visitors, no account needed.'**
  String get onboardingWelcomeSubtitle;

  /// No description provided for @onboardingFeaturesTitle.
  ///
  /// In en, this message translates to:
  /// **'Everything you need, in one place'**
  String get onboardingFeaturesTitle;

  /// No description provided for @onboardingFeaturesPrepareTitle.
  ///
  /// In en, this message translates to:
  /// **'Prepare before you fly'**
  String get onboardingFeaturesPrepareTitle;

  /// No description provided for @onboardingFeaturesPrepareDesc.
  ///
  /// In en, this message translates to:
  /// **'Visa, currency, weather — answered in 30 seconds for your passport.'**
  String get onboardingFeaturesPrepareDesc;

  /// No description provided for @onboardingFeaturesMapTitle.
  ///
  /// In en, this message translates to:
  /// **'Map that respects you'**
  String get onboardingFeaturesMapTitle;

  /// No description provided for @onboardingFeaturesMapDesc.
  ///
  /// In en, this message translates to:
  /// **'Tap an attraction, get an honest read from local visitors.'**
  String get onboardingFeaturesMapDesc;

  /// No description provided for @onboardingFeaturesDiscoverTitle.
  ///
  /// In en, this message translates to:
  /// **'Discover what\'s actually good'**
  String get onboardingFeaturesDiscoverTitle;

  /// No description provided for @onboardingFeaturesDiscoverDesc.
  ///
  /// In en, this message translates to:
  /// **'Curated lists — not SEO-spam rankings.'**
  String get onboardingFeaturesDiscoverDesc;

  /// No description provided for @onboardingFeaturesToolsTitle.
  ///
  /// In en, this message translates to:
  /// **'Tools that work offline'**
  String get onboardingFeaturesToolsTitle;

  /// No description provided for @onboardingFeaturesToolsDesc.
  ///
  /// In en, this message translates to:
  /// **'Phrases, FX, emergency numbers — when Wi-Fi is dead.'**
  String get onboardingFeaturesToolsDesc;

  /// No description provided for @onboardingSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Quick setup'**
  String get onboardingSettingsTitle;

  /// No description provided for @onboardingSettingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We\'ll tailor Sightour to you. You can change any of this later.'**
  String get onboardingSettingsSubtitle;

  /// No description provided for @onboardingSettingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get onboardingSettingsLanguage;

  /// No description provided for @onboardingSettingsTheme.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get onboardingSettingsTheme;

  /// No description provided for @onboardingSettingsCountry.
  ///
  /// In en, this message translates to:
  /// **'Your passport country'**
  String get onboardingSettingsCountry;

  /// No description provided for @onboardingSettingsUnit.
  ///
  /// In en, this message translates to:
  /// **'Units'**
  String get onboardingSettingsUnit;

  /// No description provided for @onboardingSettingsCountryHint.
  ///
  /// In en, this message translates to:
  /// **'Select your country'**
  String get onboardingSettingsCountryHint;

  /// No description provided for @privacyTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy & terms'**
  String get privacyTitle;

  /// No description provided for @privacyIntro.
  ///
  /// In en, this message translates to:
  /// **'Sightour is built for visitors. Here\'s what we do — and don\'t do — with your data.'**
  String get privacyIntro;

  /// No description provided for @privacyPoint1.
  ///
  /// In en, this message translates to:
  /// **'No account, no login, no email required.'**
  String get privacyPoint1;

  /// No description provided for @privacyPoint2.
  ///
  /// In en, this message translates to:
  /// **'An anonymous device ID is generated to remember your settings. Nothing else.'**
  String get privacyPoint2;

  /// No description provided for @privacyPoint3.
  ///
  /// In en, this message translates to:
  /// **'Your checklist and favorites are stored on this device only.'**
  String get privacyPoint3;

  /// No description provided for @privacyPoint4.
  ///
  /// In en, this message translates to:
  /// **'You choose whether error reports include your location.'**
  String get privacyPoint4;

  /// No description provided for @privacyPoint5.
  ///
  /// In en, this message translates to:
  /// **'Correction submissions are anonymous unless you sign them.'**
  String get privacyPoint5;

  /// No description provided for @privacyPoint6.
  ///
  /// In en, this message translates to:
  /// **'Read the full privacy policy'**
  String get privacyPoint6;

  /// No description provided for @privacyAgree.
  ///
  /// In en, this message translates to:
  /// **'I have read and agree to the privacy policy'**
  String get privacyAgree;

  /// No description provided for @privacyTermsAgree.
  ///
  /// In en, this message translates to:
  /// **'I agree to the terms of service'**
  String get privacyTermsAgree;

  /// No description provided for @privacyEnter.
  ///
  /// In en, this message translates to:
  /// **'Enter Sightour'**
  String get privacyEnter;

  /// No description provided for @youProfileAnonymousId.
  ///
  /// In en, this message translates to:
  /// **'Device ID'**
  String get youProfileAnonymousId;

  /// No description provided for @youPreferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get youPreferences;

  /// No description provided for @youFeedback.
  ///
  /// In en, this message translates to:
  /// **'Send feedback'**
  String get youFeedback;

  /// No description provided for @youPreferencesComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Preferences (coming soon)'**
  String get youPreferencesComingSoon;

  /// No description provided for @feedbackTitle.
  ///
  /// In en, this message translates to:
  /// **'Send feedback'**
  String get feedbackTitle;

  /// No description provided for @feedbackTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'What is this about?'**
  String get feedbackTypeLabel;

  /// No description provided for @feedbackMessageLabel.
  ///
  /// In en, this message translates to:
  /// **'Tell us more'**
  String get feedbackMessageLabel;

  /// No description provided for @feedbackMessageHint.
  ///
  /// In en, this message translates to:
  /// **'Share what happened, or what you\'d like to see. (min 10 chars)'**
  String get feedbackMessageHint;

  /// No description provided for @feedbackSubmit.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get feedbackSubmit;

  /// No description provided for @feedbackSubmitting.
  ///
  /// In en, this message translates to:
  /// **'Sending…'**
  String get feedbackSubmitting;

  /// No description provided for @feedbackSuccess.
  ///
  /// In en, this message translates to:
  /// **'Thanks! We received your feedback.'**
  String get feedbackSuccess;

  /// No description provided for @feedbackErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Could not send'**
  String get feedbackErrorTitle;

  /// No description provided for @feedbackRetry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get feedbackRetry;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
