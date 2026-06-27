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
}
