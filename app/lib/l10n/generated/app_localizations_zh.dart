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
  String get commonNext => '下一步';

  @override
  String get commonGetStarted => '开始使用';

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

  @override
  String get onboardingWelcomeTitle => '欢迎使用 Sightour';

  @override
  String get onboardingWelcomeSubtitle => '为来沪游客打造的私人向导。无需注册账号。';

  @override
  String get onboardingFeaturesTitle => '一个 App，搞定一切';

  @override
  String get onboardingFeaturesPrepareTitle => '行前准备';

  @override
  String get onboardingFeaturesPrepareDesc => '签证、货币、天气 — 按你的护照 30 秒解答。';

  @override
  String get onboardingFeaturesMapTitle => '尊重你的地图';

  @override
  String get onboardingFeaturesMapDesc => '点景点，看本地游客的真实评价。';

  @override
  String get onboardingFeaturesDiscoverTitle => '发现真正的好地方';

  @override
  String get onboardingFeaturesDiscoverDesc => '精挑细选的榜单 — 不是 SEO 垃圾排名。';

  @override
  String get onboardingFeaturesToolsTitle => '离线也能用的工具';

  @override
  String get onboardingFeaturesToolsDesc => '短语、汇率、紧急电话 — Wi-Fi 断也不慌。';

  @override
  String get onboardingSettingsTitle => '快速设置';

  @override
  String get onboardingSettingsSubtitle => '按你的情况定制。随时可以在设置里改。';

  @override
  String get onboardingSettingsLanguage => '语言';

  @override
  String get onboardingSettingsTheme => '外观';

  @override
  String get onboardingSettingsCountry => '你的护照国家';

  @override
  String get onboardingSettingsUnit => '单位';

  @override
  String get onboardingSettingsCountryHint => '选择国家';

  @override
  String get privacyTitle => '隐私与服务条款';

  @override
  String get privacyIntro => 'Sightour 为游客而生。这是我们对数据做的事 — 和不做的。';

  @override
  String get privacyPoint1 => '无需账号、登录、邮箱。';

  @override
  String get privacyPoint2 => '仅生成匿名设备 ID 用来记你的设置。仅此而已。';

  @override
  String get privacyPoint3 => '你的清单和收藏只存在本机。';

  @override
  String get privacyPoint4 => '错误反馈是否带位置由你决定。';

  @override
  String get privacyPoint5 => '纠错提交默认匿名，除非你署名。';

  @override
  String get privacyPoint6 => '阅读完整隐私政策';

  @override
  String get privacyAgree => '我已阅读并同意隐私政策';

  @override
  String get privacyTermsAgree => '我同意服务条款';

  @override
  String get privacyEnter => '进入 Sightour';
}
