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

  /// No description provided for @prepareSectionPolicies.
  ///
  /// In en, this message translates to:
  /// **'What you need to know'**
  String get prepareSectionPolicies;

  /// No description provided for @prepareSectionChecklist.
  ///
  /// In en, this message translates to:
  /// **'Pre-arrival checklist'**
  String get prepareSectionChecklist;

  /// No description provided for @prepareSectionDownloads.
  ///
  /// In en, this message translates to:
  /// **'Offline downloads'**
  String get prepareSectionDownloads;

  /// No description provided for @prepareNoPolicies.
  ///
  /// In en, this message translates to:
  /// **'No policy info for {country} yet'**
  String prepareNoPolicies(String country);

  /// No description provided for @prepareDownloadToast.
  ///
  /// In en, this message translates to:
  /// **'Download will start soon'**
  String get prepareDownloadToast;

  /// No description provided for @prepareOfflineShanghai.
  ///
  /// In en, this message translates to:
  /// **'Shanghai core pack'**
  String get prepareOfflineShanghai;

  /// No description provided for @prepareOfflineShanghaiDesc.
  ///
  /// In en, this message translates to:
  /// **'12 MB · maps + phrases + emergency'**
  String get prepareOfflineShanghaiDesc;

  /// No description provided for @prepareChecklistPassport.
  ///
  /// In en, this message translates to:
  /// **'Passport valid 6+ months'**
  String get prepareChecklistPassport;

  /// No description provided for @prepareChecklistCash.
  ///
  /// In en, this message translates to:
  /// **'Cash on hand (¥2000+)'**
  String get prepareChecklistCash;

  /// No description provided for @prepareChecklistEmergency.
  ///
  /// In en, this message translates to:
  /// **'Emergency contacts saved'**
  String get prepareChecklistEmergency;

  /// No description provided for @prepareChecklistOffline.
  ///
  /// In en, this message translates to:
  /// **'Offline pack downloaded'**
  String get prepareChecklistOffline;

  /// No description provided for @mapTitle.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get mapTitle;

  /// No description provided for @mapPageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Explore the city with confidence'**
  String get mapPageSubtitle;

  /// No description provided for @mapSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search places, addresses, transit'**
  String get mapSearchHint;

  /// No description provided for @mapCategoryAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get mapCategoryAll;

  /// No description provided for @mapCategoryAttraction.
  ///
  /// In en, this message translates to:
  /// **'Sights'**
  String get mapCategoryAttraction;

  /// No description provided for @mapCategoryDining.
  ///
  /// In en, this message translates to:
  /// **'Eat'**
  String get mapCategoryDining;

  /// No description provided for @mapCategoryLodging.
  ///
  /// In en, this message translates to:
  /// **'Stay'**
  String get mapCategoryLodging;

  /// No description provided for @mapCategoryShopping.
  ///
  /// In en, this message translates to:
  /// **'Shop'**
  String get mapCategoryShopping;

  /// No description provided for @mapEmpty.
  ///
  /// In en, this message translates to:
  /// **'No results in this area'**
  String get mapEmpty;

  /// No description provided for @mapDistanceAway.
  ///
  /// In en, this message translates to:
  /// **'{km} km away'**
  String mapDistanceAway(String km);

  /// No description provided for @discoverTitle.
  ///
  /// In en, this message translates to:
  /// **'Discover Shanghai'**
  String get discoverTitle;

  /// No description provided for @discoverTabCurated.
  ///
  /// In en, this message translates to:
  /// **'Curated'**
  String get discoverTabCurated;

  /// No description provided for @discoverTabAuthentic.
  ///
  /// In en, this message translates to:
  /// **'Authentic'**
  String get discoverTabAuthentic;

  /// No description provided for @discoverTabHeadsUp.
  ///
  /// In en, this message translates to:
  /// **'Heads-up'**
  String get discoverTabHeadsUp;

  /// No description provided for @discoverEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nothing here yet'**
  String get discoverEmpty;

  /// No description provided for @toolsTitle.
  ///
  /// In en, this message translates to:
  /// **'Tools'**
  String get toolsTitle;

  /// No description provided for @toolsPageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Everything works offline, even at the airport'**
  String get toolsPageSubtitle;

  /// No description provided for @toolsFxTitle.
  ///
  /// In en, this message translates to:
  /// **'Live currency'**
  String get toolsFxTitle;

  /// No description provided for @toolsFxFrom.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get toolsFxFrom;

  /// No description provided for @toolsFxTo.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get toolsFxTo;

  /// No description provided for @toolsFxAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get toolsFxAmount;

  /// No description provided for @toolsFxRate.
  ///
  /// In en, this message translates to:
  /// **'1 {from} = {rate} {to}'**
  String toolsFxRate(String from, String rate, String to);

  /// No description provided for @toolsAllTools.
  ///
  /// In en, this message translates to:
  /// **'All tools'**
  String get toolsAllTools;

  /// No description provided for @toolsComingSoon.
  ///
  /// In en, this message translates to:
  /// **'{tool} is coming soon'**
  String toolsComingSoon(String tool);

  /// No description provided for @toolsToolPhrases.
  ///
  /// In en, this message translates to:
  /// **'Phrase book'**
  String get toolsToolPhrases;

  /// No description provided for @toolsToolEmergency.
  ///
  /// In en, this message translates to:
  /// **'Emergency contacts'**
  String get toolsToolEmergency;

  /// No description provided for @toolsToolUnits.
  ///
  /// In en, this message translates to:
  /// **'Unit converter'**
  String get toolsToolUnits;

  /// No description provided for @toolsToolTimezone.
  ///
  /// In en, this message translates to:
  /// **'Time zone'**
  String get toolsToolTimezone;

  /// No description provided for @toolsToolOffline.
  ///
  /// In en, this message translates to:
  /// **'Offline pack'**
  String get toolsToolOffline;

  /// No description provided for @toolsToolTranslate.
  ///
  /// In en, this message translates to:
  /// **'Translate assistant'**
  String get toolsToolTranslate;

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

  /// No description provided for @youSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get youSettings;

  /// No description provided for @youSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get youSettingsTitle;

  /// No description provided for @youSettingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get youSettingsLanguage;

  /// No description provided for @youSettingsTheme.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get youSettingsTheme;

  /// No description provided for @youSettingsThemeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get youSettingsThemeSystem;

  /// No description provided for @youSettingsThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get youSettingsThemeLight;

  /// No description provided for @youSettingsThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get youSettingsThemeDark;

  /// No description provided for @youAboutTitle.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get youAboutTitle;

  /// No description provided for @youAboutVersion.
  ///
  /// In en, this message translates to:
  /// **'Sightour v0.1.0'**
  String get youAboutVersion;

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

  /// No description provided for @commonSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get commonSkip;

  /// No description provided for @commonContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get commonContinue;

  /// No description provided for @onboardingStepWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get onboardingStepWelcome;

  /// No description provided for @onboardingStepFeatures.
  ///
  /// In en, this message translates to:
  /// **'Features'**
  String get onboardingStepFeatures;

  /// No description provided for @onboardingStepSetup.
  ///
  /// In en, this message translates to:
  /// **'Setup'**
  String get onboardingStepSetup;

  /// No description provided for @onboardingStepHighlights.
  ///
  /// In en, this message translates to:
  /// **'Highlights'**
  String get onboardingStepHighlights;

  /// No description provided for @onboardingStepPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get onboardingStepPrivacy;

  /// No description provided for @onboardingFeaturesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Visa, customs, embassies and\nlocal tips — offline'**
  String get onboardingFeaturesSubtitle;

  /// No description provided for @onboardingSettingsReason.
  ///
  /// In en, this message translates to:
  /// **'Reason for entry'**
  String get onboardingSettingsReason;

  /// No description provided for @onboardingSettingsCity.
  ///
  /// In en, this message translates to:
  /// **'First-arrival city'**
  String get onboardingSettingsCity;

  /// No description provided for @onboardingSettingsUnits.
  ///
  /// In en, this message translates to:
  /// **'Units'**
  String get onboardingSettingsUnits;

  /// No description provided for @onboardingSettingsCountryTap.
  ///
  /// In en, this message translates to:
  /// **'Tap to change'**
  String get onboardingSettingsCountryTap;

  /// No description provided for @onboardingHighlightsShanghai.
  ///
  /// In en, this message translates to:
  /// **'Discover Shanghai'**
  String get onboardingHighlightsShanghai;

  /// No description provided for @onboardingHighlightsBeijing.
  ///
  /// In en, this message translates to:
  /// **'Discover Beijing'**
  String get onboardingHighlightsBeijing;

  /// No description provided for @onboardingHighlightsGuangzhou.
  ///
  /// In en, this message translates to:
  /// **'Discover Guangzhou'**
  String get onboardingHighlightsGuangzhou;

  /// No description provided for @onboardingHighlightsDefault.
  ///
  /// In en, this message translates to:
  /// **'Discover your destination'**
  String get onboardingHighlightsDefault;

  /// No description provided for @onboardingHighlightsShanghaiTag.
  ///
  /// In en, this message translates to:
  /// **'A vibrant blend of tradition and modernity awaits'**
  String get onboardingHighlightsShanghaiTag;

  /// No description provided for @onboardingHighlightsBeijingTag.
  ///
  /// In en, this message translates to:
  /// **'Where ancient imperial grandeur meets modern vitality'**
  String get onboardingHighlightsBeijingTag;

  /// No description provided for @onboardingHighlightsGuangzhouTag.
  ///
  /// In en, this message translates to:
  /// **'The culinary capital where rivers meet the sea'**
  String get onboardingHighlightsGuangzhouTag;

  /// No description provided for @onboardingHighlightsDefaultTag.
  ///
  /// In en, this message translates to:
  /// **'Adventure begins with every step'**
  String get onboardingHighlightsDefaultTag;

  /// No description provided for @privacySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Stay in control.\nEverything works offline by design.'**
  String get privacySubtitle;

  /// No description provided for @privacyCardLocation.
  ///
  /// In en, this message translates to:
  /// **'Location stays on your device — never leaves it'**
  String get privacyCardLocation;

  /// No description provided for @privacyCardAnonymous.
  ///
  /// In en, this message translates to:
  /// **'Only an anonymous install ID for feedback deduplication'**
  String get privacyCardAnonymous;

  /// No description provided for @privacyCardLocal.
  ///
  /// In en, this message translates to:
  /// **'Preferences stored locally: language, theme, country'**
  String get privacyCardLocal;

  /// No description provided for @privacyCardClear.
  ///
  /// In en, this message translates to:
  /// **'Clear all local data anytime from Settings'**
  String get privacyCardClear;

  /// No description provided for @privacyCardFeedback.
  ///
  /// In en, this message translates to:
  /// **'Feedback reviewed by our moderation team'**
  String get privacyCardFeedback;

  /// No description provided for @privacyReadFull.
  ///
  /// In en, this message translates to:
  /// **'Read full policy'**
  String get privacyReadFull;

  /// No description provided for @prepareViewCards.
  ///
  /// In en, this message translates to:
  /// **'Cards 卡片'**
  String get prepareViewCards;

  /// No description provided for @prepareViewTimeline.
  ///
  /// In en, this message translates to:
  /// **'Timeline 总览'**
  String get prepareViewTimeline;

  /// No description provided for @prepareSwitchCountry.
  ///
  /// In en, this message translates to:
  /// **'Switch country'**
  String get prepareSwitchCountry;

  /// No description provided for @prepareSwitchReason.
  ///
  /// In en, this message translates to:
  /// **'Switch reason'**
  String get prepareSwitchReason;

  /// No description provided for @prepareSwitchCity.
  ///
  /// In en, this message translates to:
  /// **'Switch city'**
  String get prepareSwitchCity;

  /// No description provided for @youProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get youProfileTitle;

  /// No description provided for @youProfileIdLabel.
  ///
  /// In en, this message translates to:
  /// **'ID: {id}'**
  String youProfileIdLabel(String id);

  /// No description provided for @journeyBannerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your journey'**
  String get journeyBannerSubtitle;

  /// No description provided for @journeyBannerGreetingSH.
  ///
  /// In en, this message translates to:
  /// **'Shanghai awaits'**
  String get journeyBannerGreetingSH;

  /// No description provided for @journeyBannerGreetingBJ.
  ///
  /// In en, this message translates to:
  /// **'Beijing awaits'**
  String get journeyBannerGreetingBJ;

  /// No description provided for @journeyBannerGreetingGZ.
  ///
  /// In en, this message translates to:
  /// **'Guangzhou awaits'**
  String get journeyBannerGreetingGZ;

  /// No description provided for @journeyBannerGreetingDefault.
  ///
  /// In en, this message translates to:
  /// **'China awaits'**
  String get journeyBannerGreetingDefault;

  /// No description provided for @prepareChecklistDone.
  ///
  /// In en, this message translates to:
  /// **'{done} / {total} done'**
  String prepareChecklistDone(int done, int total);

  /// No description provided for @onboardingSettingsLanguageEn.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get onboardingSettingsLanguageEn;

  /// No description provided for @onboardingSettingsThemeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get onboardingSettingsThemeSystem;

  /// No description provided for @onboardingSettingsThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get onboardingSettingsThemeLight;

  /// No description provided for @onboardingSettingsThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get onboardingSettingsThemeDark;

  /// No description provided for @onboardingSettingsCountrySearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search country...'**
  String get onboardingSettingsCountrySearchHint;

  /// No description provided for @onboardingSettingsOtherCityNotice.
  ///
  /// In en, this message translates to:
  /// **'Other cities are not yet covered in v1. We will still show the national-level policy (visa, customs, embassy) for your passport, but offline packs and city-specific POIs are only available for Beijing, Shanghai and Guangzhou.'**
  String get onboardingSettingsOtherCityNotice;

  /// No description provided for @privacyPolicyTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicyTitle;

  /// No description provided for @highlightsMustSee.
  ///
  /// In en, this message translates to:
  /// **'Must See'**
  String get highlightsMustSee;

  /// No description provided for @highlightsFood.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get highlightsFood;

  /// No description provided for @highlightsCulture.
  ///
  /// In en, this message translates to:
  /// **'Culture'**
  String get highlightsCulture;

  /// No description provided for @youPageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your data, your device, your choice'**
  String get youPageSubtitle;

  /// No description provided for @youSettingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Language, theme, and preferences'**
  String get youSettingsSubtitle;

  /// No description provided for @youFeedbackSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Help us improve Sightour'**
  String get youFeedbackSubtitle;

  /// No description provided for @poiDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get poiDetailTitle;

  /// No description provided for @poiDetailAddress.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get poiDetailAddress;

  /// No description provided for @poiDetailContact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get poiDetailContact;

  /// No description provided for @poiDetailHours.
  ///
  /// In en, this message translates to:
  /// **'Open hours'**
  String get poiDetailHours;

  /// No description provided for @poiDetailNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Not available'**
  String get poiDetailNotAvailable;

  /// No description provided for @poiDetailViewReputation.
  ///
  /// In en, this message translates to:
  /// **'View reputation'**
  String get poiDetailViewReputation;

  /// No description provided for @poiDetailScore.
  ///
  /// In en, this message translates to:
  /// **'Score: {score}'**
  String poiDetailScore(String score);

  /// No description provided for @poiDetailCleanliness.
  ///
  /// In en, this message translates to:
  /// **'Foreign-friendly service'**
  String get poiDetailCleanliness;

  /// No description provided for @poiDetailLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language support'**
  String get poiDetailLanguage;

  /// No description provided for @poiDetailPayment.
  ///
  /// In en, this message translates to:
  /// **'Payment ease'**
  String get poiDetailPayment;

  /// No description provided for @poiDetailAuthentic.
  ///
  /// In en, this message translates to:
  /// **'Authenticity'**
  String get poiDetailAuthentic;

  /// No description provided for @poiDetailValue.
  ///
  /// In en, this message translates to:
  /// **'Value for money'**
  String get poiDetailValue;

  /// No description provided for @poiDetailTips.
  ///
  /// In en, this message translates to:
  /// **'Experience tips'**
  String get poiDetailTips;

  /// No description provided for @poiDetailVerified.
  ///
  /// In en, this message translates to:
  /// **'Officially verified'**
  String get poiDetailVerified;

  /// No description provided for @policyDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Policy detail'**
  String get policyDetailTitle;

  /// No description provided for @policyDetailSource.
  ///
  /// In en, this message translates to:
  /// **'Source'**
  String get policyDetailSource;

  /// No description provided for @checklistTitle.
  ///
  /// In en, this message translates to:
  /// **'Pre-arrival checklist'**
  String get checklistTitle;

  /// No description provided for @checklistEmpty.
  ///
  /// In en, this message translates to:
  /// **'No checklist items for your selection'**
  String get checklistEmpty;

  /// No description provided for @rankTitle.
  ///
  /// In en, this message translates to:
  /// **'Rankings'**
  String get rankTitle;

  /// No description provided for @rankEmpty.
  ///
  /// In en, this message translates to:
  /// **'No rankings yet'**
  String get rankEmpty;

  /// No description provided for @fxTitle.
  ///
  /// In en, this message translates to:
  /// **'Currency converter'**
  String get fxTitle;

  /// No description provided for @fxSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Live exchange rates'**
  String get fxSubtitle;

  /// No description provided for @unitConverterTitle.
  ///
  /// In en, this message translates to:
  /// **'Unit converter'**
  String get unitConverterTitle;

  /// No description provided for @unitConverterKm.
  ///
  /// In en, this message translates to:
  /// **'Kilometers'**
  String get unitConverterKm;

  /// No description provided for @unitConverterMi.
  ///
  /// In en, this message translates to:
  /// **'Miles'**
  String get unitConverterMi;

  /// No description provided for @unitConverterC.
  ///
  /// In en, this message translates to:
  /// **'Celsius'**
  String get unitConverterC;

  /// No description provided for @unitConverterF.
  ///
  /// In en, this message translates to:
  /// **'Fahrenheit'**
  String get unitConverterF;

  /// No description provided for @timezoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Time zones'**
  String get timezoneTitle;

  /// No description provided for @timezoneChina.
  ///
  /// In en, this message translates to:
  /// **'China Standard Time'**
  String get timezoneChina;

  /// No description provided for @timezoneCST.
  ///
  /// In en, this message translates to:
  /// **'CST (UTC+8)'**
  String get timezoneCST;

  /// No description provided for @emergencyTitle.
  ///
  /// In en, this message translates to:
  /// **'Emergency contacts'**
  String get emergencyTitle;

  /// No description provided for @emergencyPolice.
  ///
  /// In en, this message translates to:
  /// **'Police'**
  String get emergencyPolice;

  /// No description provided for @emergencyMedical.
  ///
  /// In en, this message translates to:
  /// **'Medical'**
  String get emergencyMedical;

  /// No description provided for @emergencyFire.
  ///
  /// In en, this message translates to:
  /// **'Fire'**
  String get emergencyFire;

  /// No description provided for @emergencyConsulate.
  ///
  /// In en, this message translates to:
  /// **'Consulate'**
  String get emergencyConsulate;

  /// No description provided for @emergencyTouristHotline.
  ///
  /// In en, this message translates to:
  /// **'Tourist hotline'**
  String get emergencyTouristHotline;

  /// No description provided for @emergencyEmpty.
  ///
  /// In en, this message translates to:
  /// **'No emergency contacts available'**
  String get emergencyEmpty;

  /// No description provided for @phrasesTitle.
  ///
  /// In en, this message translates to:
  /// **'Phrase book'**
  String get phrasesTitle;

  /// No description provided for @phrasesCategoryCustoms.
  ///
  /// In en, this message translates to:
  /// **'Customs'**
  String get phrasesCategoryCustoms;

  /// No description provided for @phrasesCategoryTaxi.
  ///
  /// In en, this message translates to:
  /// **'Taxi'**
  String get phrasesCategoryTaxi;

  /// No description provided for @phrasesCategoryDining.
  ///
  /// In en, this message translates to:
  /// **'Dining'**
  String get phrasesCategoryDining;

  /// No description provided for @phrasesCategoryMedical.
  ///
  /// In en, this message translates to:
  /// **'Medical'**
  String get phrasesCategoryMedical;

  /// No description provided for @phrasesCategoryEmergency.
  ///
  /// In en, this message translates to:
  /// **'Emergency'**
  String get phrasesCategoryEmergency;

  /// No description provided for @phrasesCategoryShopping.
  ///
  /// In en, this message translates to:
  /// **'Shopping'**
  String get phrasesCategoryShopping;

  /// No description provided for @phrasesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No phrases in this category'**
  String get phrasesEmpty;

  /// No description provided for @aboutTitle.
  ///
  /// In en, this message translates to:
  /// **'About Sightour'**
  String get aboutTitle;

  /// No description provided for @aboutVersion.
  ///
  /// In en, this message translates to:
  /// **'Sightour v0.1.0'**
  String get aboutVersion;

  /// No description provided for @aboutDescription.
  ///
  /// In en, this message translates to:
  /// **'Your private guide to China. Built for visitors, no account needed.\n\nSightour is an open-source, community-driven travel companion focused on providing honest, curated information for international travellers visiting China.'**
  String get aboutDescription;

  /// No description provided for @privacyFullTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyFullTitle;

  /// No description provided for @privacyFullContent.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy full text coming soon.'**
  String get privacyFullContent;
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
