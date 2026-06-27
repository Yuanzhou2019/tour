// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'Sightour';

  @override
  String get tabPrepare => '行前';

  @override
  String get tabMap => '地图';

  @override
  String get tabDiscover => '发现';

  @override
  String get tabTools => '工具';

  @override
  String get tabYou => '我的';

  @override
  String get commonConfirm => '确认';

  @override
  String get commonCancel => '取消';

  @override
  String get commonRetry => '重试';

  @override
  String get commonError => '出错了';

  @override
  String get commonLoading => '加载中…';

  @override
  String get commonComingSoon => '敬请期待';

  @override
  String get commonOffline => '离线模式';

  @override
  String prepareTitle(String nationality) {
    return '行前准备 · $nationality';
  }

  @override
  String get mapTitle => '地图';

  @override
  String get mapSearchHint => '搜索地点、地址、交通';

  @override
  String get discoverTitle => '发现上海';

  @override
  String get toolsTitle => '工具';

  @override
  String get youTitle => '我的';

  @override
  String get policyVisaFree => '30 天免签入境';

  @override
  String get policyTransit => '240 小时过境免签';
}
