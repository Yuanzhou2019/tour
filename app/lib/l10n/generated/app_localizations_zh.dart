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
  String get prepareSectionPolicies => '你需要知道';

  @override
  String get prepareSectionChecklist => '行前清单';

  @override
  String get prepareSectionDownloads => '离线下载';

  @override
  String prepareNoPolicies(String country) {
    return '暂无 $country 的政策信息';
  }

  @override
  String get prepareDownloadToast => '下载即将开始';

  @override
  String get prepareOfflineShanghai => '上海核心包';

  @override
  String get prepareOfflineShanghaiDesc => '12 MB · 地图 + 短语 + 紧急联系';

  @override
  String get prepareChecklistPassport => '护照有效期 6 个月以上';

  @override
  String get prepareChecklistCash => '随身现金（¥2000+）';

  @override
  String get prepareChecklistEmergency => '已保存紧急联系方式';

  @override
  String get prepareChecklistOffline => '已下载离线包';

  @override
  String get mapTitle => '地图';

  @override
  String get mapPageSubtitle => '放心探索这座城市';

  @override
  String get mapSearchHint => '搜索地点、地址、交通';

  @override
  String get mapCategoryAll => '全部';

  @override
  String get mapCategoryAttraction => '景点';

  @override
  String get mapCategoryDining => '美食';

  @override
  String get mapCategoryLodging => '住宿';

  @override
  String get mapCategoryShopping => '购物';

  @override
  String get mapEmpty => '该区域暂无结果';

  @override
  String mapDistanceAway(String km) {
    return '距离 $km 公里';
  }

  @override
  String get discoverTitle => '发现上海';

  @override
  String get discoverTabCurated => '精选';

  @override
  String get discoverTabAuthentic => '本地';

  @override
  String get discoverTabHeadsUp => '提醒';

  @override
  String get discoverEmpty => '暂无内容';

  @override
  String get toolsTitle => '工具';

  @override
  String get toolsPageSubtitle => '所有工具离线可用，机场也无忧';

  @override
  String get toolsFxTitle => '实时汇率';

  @override
  String get toolsFxFrom => '从';

  @override
  String get toolsFxTo => '到';

  @override
  String get toolsFxAmount => '金额';

  @override
  String toolsFxRate(String from, String rate, String to) {
    return '1 $from = $rate $to';
  }

  @override
  String get toolsAllTools => '全部工具';

  @override
  String toolsComingSoon(String tool) {
    return '$tool 即将推出';
  }

  @override
  String get toolsToolPhrases => '常用短语';

  @override
  String get toolsToolEmergency => '紧急联系';

  @override
  String get toolsToolUnits => '单位换算';

  @override
  String get toolsToolTimezone => '时区';

  @override
  String get toolsToolOffline => '离线包';

  @override
  String get toolsToolTranslate => '翻译助手';

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

  @override
  String get youProfileAnonymousId => '设备 ID';

  @override
  String get youPreferences => '偏好设置';

  @override
  String get youFeedback => '发送反馈';

  @override
  String get youPreferencesComingSoon => '偏好设置（敬请期待）';

  @override
  String get youSettings => '设置';

  @override
  String get youSettingsTitle => '设置';

  @override
  String get youSettingsLanguage => '语言';

  @override
  String get youSettingsTheme => '外观';

  @override
  String get youSettingsThemeSystem => '跟随系统';

  @override
  String get youSettingsThemeLight => '浅色';

  @override
  String get youSettingsThemeDark => '深色';

  @override
  String get youAboutTitle => '关于';

  @override
  String get youAboutVersion => 'Sightour v0.1.0';

  @override
  String get feedbackTitle => '发送反馈';

  @override
  String get feedbackTypeLabel => '这是什么类型？';

  @override
  String get feedbackMessageLabel => '详细说明';

  @override
  String get feedbackMessageHint => '告诉我们发生了什么，或你想看到什么。（最少 10 字）';

  @override
  String get feedbackSubmit => '发送';

  @override
  String get feedbackSubmitting => '发送中…';

  @override
  String get feedbackSuccess => '感谢！我们已收到你的反馈。';

  @override
  String get feedbackErrorTitle => '发送失败';

  @override
  String get feedbackRetry => '重试';

  @override
  String get commonSkip => '跳过';

  @override
  String get commonContinue => '继续';

  @override
  String get onboardingStepWelcome => '欢迎';

  @override
  String get onboardingStepFeatures => '功能';

  @override
  String get onboardingStepSetup => '设置';

  @override
  String get onboardingStepHighlights => '亮点';

  @override
  String get onboardingStepPrivacy => '隐私';

  @override
  String get onboardingFeaturesSubtitle => '签证、海关、大使馆和\n本地贴士 — 离线可用';

  @override
  String get onboardingSettingsReason => '入境原因';

  @override
  String get onboardingSettingsCity => '首次入境城市';

  @override
  String get onboardingSettingsUnits => '单位';

  @override
  String get onboardingSettingsCountryTap => '点击切换';

  @override
  String get onboardingHighlightsShanghai => '发现上海';

  @override
  String get onboardingHighlightsBeijing => '发现北京';

  @override
  String get onboardingHighlightsGuangzhou => '发现广州';

  @override
  String get onboardingHighlightsDefault => '发现你的目的地';

  @override
  String get onboardingHighlightsShanghaiTag => '传统与现代交融的活力之都';

  @override
  String get onboardingHighlightsBeijingTag => '千年帝都的皇家气韵与现代活力';

  @override
  String get onboardingHighlightsGuangzhouTag => '江河入海的美食之都';

  @override
  String get onboardingHighlightsDefaultTag => '每一步都是新的探索';

  @override
  String get privacySubtitle => '完全掌控。\n一切设计为离线可用。';

  @override
  String get privacyCardLocation => '定位数据仅存于设备 — 绝不会上传';

  @override
  String get privacyCardAnonymous => '仅用匿名安装 ID 去重反馈';

  @override
  String get privacyCardLocal => '偏好设置保存在本地：语言、主题、国家';

  @override
  String get privacyCardClear => '随时在设置中清除所有本地数据';

  @override
  String get privacyCardFeedback => '反馈由我们的审核团队处理';

  @override
  String get privacyReadFull => '阅读完整政策';

  @override
  String get prepareViewCards => '卡片';

  @override
  String get prepareViewTimeline => '总览';

  @override
  String get prepareSwitchCountry => '切换国家';

  @override
  String get prepareSwitchReason => '切换原因';

  @override
  String get prepareSwitchCity => '切换城市';

  @override
  String get youProfileTitle => '我的';

  @override
  String youProfileIdLabel(String id) {
    return 'ID: $id';
  }

  @override
  String get journeyBannerSubtitle => '你的旅程';

  @override
  String get journeyBannerGreetingSH => '期待你的上海之旅';

  @override
  String get journeyBannerGreetingBJ => '期待你的北京之旅';

  @override
  String get journeyBannerGreetingGZ => '期待你的广州之旅';

  @override
  String get journeyBannerGreetingDefault => '期待你的中国之旅';

  @override
  String prepareChecklistDone(int done, int total) {
    return '$done / $total 已完成';
  }

  @override
  String get onboardingSettingsLanguageEn => 'English';

  @override
  String get onboardingSettingsThemeSystem => '跟随系统';

  @override
  String get onboardingSettingsThemeLight => '浅色';

  @override
  String get onboardingSettingsThemeDark => '深色';

  @override
  String get onboardingSettingsCountrySearchHint => '搜索国家…';

  @override
  String get onboardingSettingsOtherCityNotice =>
      '其他城市 v1 尚未覆盖。我们仍会针对你的护照展示国家级政策（签证、海关、大使馆），但离线包和城市专属 POI 仅支持北京、上海、广州。';

  @override
  String get privacyPolicyTitle => '隐私政策';

  @override
  String get highlightsMustSee => '必看景点';

  @override
  String get highlightsFood => '美食';

  @override
  String get highlightsCulture => '文化';

  @override
  String get youPageSubtitle => '你的数据，你的设备，你的选择';

  @override
  String get youSettingsSubtitle => '语言、外观与偏好';

  @override
  String get youFeedbackSubtitle => '帮助我们做得更好';

  @override
  String get poiDetailTitle => '详情';

  @override
  String get poiDetailAddress => '地址';

  @override
  String get poiDetailContact => '联系方式';

  @override
  String get poiDetailHours => '营业时间';

  @override
  String get poiDetailNotAvailable => '暂无信息';

  @override
  String get poiDetailViewReputation => '查看口碑评分';

  @override
  String poiDetailScore(String score) {
    return '评分: $score';
  }

  @override
  String get poiDetailCleanliness => '国际友好服务';

  @override
  String get poiDetailLanguage => '语言支持';

  @override
  String get poiDetailPayment => '支付便利';

  @override
  String get poiDetailAuthentic => '地道体验';

  @override
  String get poiDetailValue => '性价比';

  @override
  String get poiDetailTips => '体验提示';

  @override
  String get poiDetailVerified => '官方认证';

  @override
  String get policyDetailTitle => '政策详情';

  @override
  String get policyDetailSource => '来源';

  @override
  String get checklistTitle => '行前清单';

  @override
  String get checklistEmpty => '暂无符合条件的清单';

  @override
  String get rankTitle => '榜单';

  @override
  String get rankEmpty => '暂无榜单';

  @override
  String get fxTitle => '汇率换算';

  @override
  String get fxSubtitle => '实时汇率';

  @override
  String get unitConverterTitle => '单位换算';

  @override
  String get unitConverterKm => '公里';

  @override
  String get unitConverterMi => '英里';

  @override
  String get unitConverterC => '摄氏度';

  @override
  String get unitConverterF => '华氏度';

  @override
  String get timezoneTitle => '时区';

  @override
  String get timezoneChina => '中国标准时间';

  @override
  String get timezoneCST => 'CST (UTC+8)';

  @override
  String get emergencyTitle => '紧急联系方式';

  @override
  String get emergencyPolice => '警察';

  @override
  String get emergencyMedical => '急救';

  @override
  String get emergencyFire => '火警';

  @override
  String get emergencyConsulate => '领事馆';

  @override
  String get emergencyTouristHotline => '旅游热线';

  @override
  String get emergencyEmpty => '暂无紧急联系信息';

  @override
  String get phrasesTitle => '常用短语';

  @override
  String get phrasesCategoryCustoms => '海关';

  @override
  String get phrasesCategoryTaxi => '打车';

  @override
  String get phrasesCategoryDining => '就餐';

  @override
  String get phrasesCategoryMedical => '就医';

  @override
  String get phrasesCategoryEmergency => '紧急';

  @override
  String get phrasesCategoryShopping => '购物';

  @override
  String get phrasesEmpty => '该分类暂无短语';

  @override
  String get aboutTitle => '关于 Sightour';

  @override
  String get aboutVersion => 'Sightour v0.1.0';

  @override
  String get aboutDescription =>
      '你在中国旅行的私人向导。无需注册账号。\n\nSightour 是一个开源的、社区驱动的旅行助手，专注为来华国际游客提供诚实、精选的信息。';

  @override
  String get privacyFullTitle => '隐私政策';

  @override
  String get privacyFullContent => '隐私政策全文即将上线。';
}
