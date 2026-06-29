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
  String get prepareSectionPolicies => 'What you need to know';

  @override
  String get prepareSectionChecklist => 'Pre-arrival checklist';

  @override
  String get prepareSectionDownloads => 'Offline downloads';

  @override
  String prepareNoPolicies(String country) {
    return 'No policy info for $country yet';
  }

  @override
  String get prepareDownloadToast => 'Download will start soon';

  @override
  String get prepareOfflineShanghai => 'Shanghai core pack';

  @override
  String get prepareOfflineShanghaiDesc => '12 MB · maps + phrases + emergency';

  @override
  String get prepareChecklistPassport => 'Passport valid 6+ months';

  @override
  String get prepareChecklistCash => 'Cash on hand (¥2000+)';

  @override
  String get prepareChecklistEmergency => 'Emergency contacts saved';

  @override
  String get prepareChecklistOffline => 'Offline pack downloaded';

  @override
  String get mapTitle => 'Map';

  @override
  String get mapPageSubtitle => 'Explore the city with confidence';

  @override
  String get mapSearchHint => 'Search places, addresses, transit';

  @override
  String get mapCategoryAll => 'All';

  @override
  String get mapCategoryAttraction => 'Sights';

  @override
  String get mapCategoryDining => 'Eat';

  @override
  String get mapCategoryLodging => 'Stay';

  @override
  String get mapCategoryShopping => 'Shop';

  @override
  String get mapEmpty => 'No results in this area';

  @override
  String mapDistanceAway(String km) {
    return '$km km away';
  }

  @override
  String get discoverTitle => 'Discover Shanghai';

  @override
  String get discoverTabCurated => 'Curated';

  @override
  String get discoverTabAuthentic => 'Authentic';

  @override
  String get discoverTabHeadsUp => 'Heads-up';

  @override
  String get discoverEmpty => 'Nothing here yet';

  @override
  String get toolsTitle => 'Tools';

  @override
  String get toolsPageSubtitle =>
      'Everything works offline, even at the airport';

  @override
  String get toolsFxTitle => 'Live currency';

  @override
  String get toolsFxFrom => 'From';

  @override
  String get toolsFxTo => 'To';

  @override
  String get toolsFxAmount => 'Amount';

  @override
  String toolsFxRate(String from, String rate, String to) {
    return '1 $from = $rate $to';
  }

  @override
  String get toolsAllTools => 'All tools';

  @override
  String toolsComingSoon(String tool) {
    return '$tool is coming soon';
  }

  @override
  String get toolsToolPhrases => 'Phrase book';

  @override
  String get toolsToolEmergency => 'Emergency contacts';

  @override
  String get toolsToolUnits => 'Unit converter';

  @override
  String get toolsToolTimezone => 'Time zone';

  @override
  String get toolsToolOffline => 'Offline pack';

  @override
  String get toolsToolTranslate => 'Translate assistant';

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
  String get youSettings => 'Settings';

  @override
  String get youSettingsTitle => 'Settings';

  @override
  String get youSettingsLanguage => 'Language';

  @override
  String get youSettingsTheme => 'Appearance';

  @override
  String get youSettingsThemeSystem => 'System';

  @override
  String get youSettingsThemeLight => 'Light';

  @override
  String get youSettingsThemeDark => 'Dark';

  @override
  String get youAboutTitle => 'About';

  @override
  String get youAboutVersion => 'Sightour v0.1.0';

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

  @override
  String get commonSkip => 'Skip';

  @override
  String get commonContinue => 'Continue';

  @override
  String get onboardingStepWelcome => 'Welcome';

  @override
  String get onboardingStepFeatures => 'Features';

  @override
  String get onboardingStepSetup => 'Setup';

  @override
  String get onboardingStepHighlights => 'Highlights';

  @override
  String get onboardingStepPrivacy => 'Privacy';

  @override
  String get onboardingFeaturesSubtitle =>
      'Visa, customs, embassies and\nlocal tips — offline';

  @override
  String get onboardingSettingsReason => 'Reason for entry';

  @override
  String get onboardingSettingsCity => 'First-arrival city';

  @override
  String get onboardingSettingsUnits => 'Units';

  @override
  String get onboardingSettingsCountryTap => 'Tap to change';

  @override
  String get onboardingHighlightsShanghai => 'Discover Shanghai';

  @override
  String get onboardingHighlightsBeijing => 'Discover Beijing';

  @override
  String get onboardingHighlightsGuangzhou => 'Discover Guangzhou';

  @override
  String get onboardingHighlightsDefault => 'Discover your destination';

  @override
  String get onboardingHighlightsShanghaiTag =>
      'A vibrant blend of tradition and modernity awaits';

  @override
  String get onboardingHighlightsBeijingTag =>
      'Where ancient imperial grandeur meets modern vitality';

  @override
  String get onboardingHighlightsGuangzhouTag =>
      'The culinary capital where rivers meet the sea';

  @override
  String get onboardingHighlightsDefaultTag =>
      'Adventure begins with every step';

  @override
  String get privacySubtitle =>
      'Stay in control.\nEverything works offline by design.';

  @override
  String get privacyCardLocation =>
      'Location stays on your device — never leaves it';

  @override
  String get privacyCardAnonymous =>
      'Only an anonymous install ID for feedback deduplication';

  @override
  String get privacyCardLocal =>
      'Preferences stored locally: language, theme, country';

  @override
  String get privacyCardClear => 'Clear all local data anytime from Settings';

  @override
  String get privacyCardFeedback => 'Feedback reviewed by our moderation team';

  @override
  String get privacyReadFull => 'Read full policy';

  @override
  String get prepareViewCards => 'Cards 卡片';

  @override
  String get prepareViewTimeline => 'Timeline 总览';

  @override
  String get prepareSwitchCountry => 'Switch country';

  @override
  String get prepareSwitchReason => 'Switch reason';

  @override
  String get prepareSwitchCity => 'Switch city';

  @override
  String get youProfileTitle => 'You';

  @override
  String youProfileIdLabel(String id) {
    return 'ID: $id';
  }

  @override
  String get journeyBannerSubtitle => 'Your journey';

  @override
  String get journeyBannerGreetingSH => 'Shanghai awaits';

  @override
  String get journeyBannerGreetingBJ => 'Beijing awaits';

  @override
  String get journeyBannerGreetingGZ => 'Guangzhou awaits';

  @override
  String get journeyBannerGreetingDefault => 'China awaits';

  @override
  String prepareChecklistDone(int done, int total) {
    return '$done / $total done';
  }

  @override
  String get onboardingSettingsLanguageEn => 'English';

  @override
  String get onboardingSettingsThemeSystem => 'System';

  @override
  String get onboardingSettingsThemeLight => 'Light';

  @override
  String get onboardingSettingsThemeDark => 'Dark';

  @override
  String get onboardingSettingsCountrySearchHint => 'Search country...';

  @override
  String get onboardingSettingsOtherCityNotice =>
      'Other cities are not yet covered in v1. We will still show the national-level policy (visa, customs, embassy) for your passport, but offline packs and city-specific POIs are only available for Beijing, Shanghai and Guangzhou.';

  @override
  String get privacyPolicyTitle => 'Privacy Policy';

  @override
  String get highlightsMustSee => 'Must See';

  @override
  String get highlightsFood => 'Food';

  @override
  String get highlightsCulture => 'Culture';

  @override
  String get youPageSubtitle => 'Your data, your device, your choice';

  @override
  String get youSettingsSubtitle => 'Language, theme, and preferences';

  @override
  String get youFeedbackSubtitle => 'Help us improve Sightour';

  @override
  String get poiDetailTitle => 'Details';

  @override
  String get poiDetailAddress => 'Address';

  @override
  String get poiDetailContact => 'Contact';

  @override
  String get poiDetailHours => 'Open hours';

  @override
  String get poiDetailNotAvailable => 'Not available';

  @override
  String get poiDetailViewReputation => 'View reputation';

  @override
  String poiDetailScore(String score) {
    return 'Score: $score';
  }

  @override
  String get poiDetailCleanliness => 'Foreign-friendly service';

  @override
  String get poiDetailLanguage => 'Language support';

  @override
  String get poiDetailPayment => 'Payment ease';

  @override
  String get poiDetailAuthentic => 'Authenticity';

  @override
  String get poiDetailValue => 'Value for money';

  @override
  String get poiDetailTips => 'Experience tips';

  @override
  String get poiDetailVerified => 'Officially verified';

  @override
  String get policyDetailTitle => 'Policy detail';

  @override
  String get policyDetailSource => 'Source';

  @override
  String get checklistTitle => 'Pre-arrival checklist';

  @override
  String get checklistEmpty => 'No checklist items for your selection';

  @override
  String get rankTitle => 'Rankings';

  @override
  String get rankEmpty => 'No rankings yet';

  @override
  String get fxTitle => 'Currency converter';

  @override
  String get fxSubtitle => 'Live exchange rates';

  @override
  String get unitConverterTitle => 'Unit converter';

  @override
  String get unitConverterKm => 'Kilometers';

  @override
  String get unitConverterMi => 'Miles';

  @override
  String get unitConverterC => 'Celsius';

  @override
  String get unitConverterF => 'Fahrenheit';

  @override
  String get timezoneTitle => 'Time zones';

  @override
  String get timezoneChina => 'China Standard Time';

  @override
  String get timezoneCST => 'CST (UTC+8)';

  @override
  String get emergencyTitle => 'Emergency contacts';

  @override
  String get emergencyPolice => 'Police';

  @override
  String get emergencyMedical => 'Medical';

  @override
  String get emergencyFire => 'Fire';

  @override
  String get emergencyConsulate => 'Consulate';

  @override
  String get emergencyTouristHotline => 'Tourist hotline';

  @override
  String get emergencyEmpty => 'No emergency contacts available';

  @override
  String get phrasesTitle => 'Phrase book';

  @override
  String get phrasesCategoryCustoms => 'Customs';

  @override
  String get phrasesCategoryTaxi => 'Taxi';

  @override
  String get phrasesCategoryDining => 'Dining';

  @override
  String get phrasesCategoryMedical => 'Medical';

  @override
  String get phrasesCategoryEmergency => 'Emergency';

  @override
  String get phrasesCategoryShopping => 'Shopping';

  @override
  String get phrasesEmpty => 'No phrases in this category';

  @override
  String get aboutTitle => 'About Sightour';

  @override
  String get aboutVersion => 'Sightour v0.1.0';

  @override
  String get aboutDescription =>
      'Your private guide to China. Built for visitors, no account needed.\n\nSightour is an open-source, community-driven travel companion focused on providing honest, curated information for international travellers visiting China.';

  @override
  String get privacyFullTitle => 'Privacy Policy';

  @override
  String get privacyFullContent => 'Privacy policy full text coming soon.';
}
