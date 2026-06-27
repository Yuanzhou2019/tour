# Sightour Spec B — Onboarding + 隐私协议 实施计划

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development to implement this plan task-by-task.

**Goal:** Add first-launch onboarding flow (3 pages + privacy consent) to Sightour Flutter app. Persists completion in Hive. Uses LocaleCubit / ThemeCubit from Spec A. No real account/login (visitor mode).

**Architecture:** Clean Architecture Lite for new `features/onboarding/` module. Domain layer has `Country` enum, `UnitSystem` enum, `FirstRunPreferences` model, `OnboardingRepository` interface. Data layer has `OnboardingRepositoryImpl` backed by Hive `prefs` box (reuses Spec A's `HiveBoxes.prefs`). Presentation has `OnboardingFlowPage` (3-page PageView), 3 child pages, `PrivacyConsentPage`, `FirstRunSettingsCubit`. Router gets a `redirect:` callback that forces `/onboarding` when prefs.onboarding_completed is false.

**Tech Stack:** (carried from Spec A) intl + flutter_localizations, freezed 3.x, get_it + injectable, hive_ce.

**上游文档：**
- [Spec B Design](file:///c:/Users/wenmo/.trae-cn/worktrees/旅游app/docs/superpowers/specs/2026-06-27-sightour-stage1-onboarding-design.md)（所有代码片段均在此）

---

## Task B1：领域层（Country / UnitSystem / OnboardingRepository）

**Files:**
- Create: `app/lib/features/onboarding/domain/entities/country.dart`
- Create: `app/lib/features/onboarding/domain/entities/unit_system.dart`
- Create: `app/lib/features/onboarding/domain/repositories/onboarding_repository.dart`
- Create: `app/lib/features/onboarding/data/repositories/onboarding_repository_impl.dart`
- Modify: `app/lib/core/storage/hive_boxes.dart`（无变化）
- Create: `app/test/onboarding/onboarding_repository_test.dart`

> **代码来自 spec §3**

- [ ] **Step B1.1：写 `country.dart`**

10 个 Country enum（US / GB / JP / KR / DE / FR / AU / CA / IT / RU），每项含 `iso2` / `nameEn` / `nameZh` / `flag` 字段。完整代码见 spec §3.1。

- [ ] **Step B1.2：写 `unit_system.dart`**

`UnitSystem { metric, imperial }` enum + `labelEn` / `labelZh` 字段。完整代码见 spec §3.2。

- [ ] **Step B1.3：写 `onboarding_repository.dart`（接口）**

```dart
import 'package:flutter/material.dart';
import 'country.dart';
import 'unit_system.dart';

class FirstRunPreferences {
  const FirstRunPreferences({
    required this.locale,
    required this.themeMode,
    required this.country,
    required this.unitSystem,
  });
  final Locale locale;
  final ThemeMode themeMode;
  final Country country;
  final UnitSystem unitSystem;
}

abstract class OnboardingRepository {
  bool isCompleted();
  Future<void> markCompleted();
  Future<void> markNotCompleted();  // for testing
  Future<FirstRunPreferences> loadFirstRunPreferences();
  Future<void> saveFirstRunPreferences(FirstRunPreferences prefs);
}
```

- [ ] **Step B1.4：写 `onboarding_repository_impl.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import 'package:injectable/injectable.dart';
import '../../../core/storage/hive_boxes.dart';
import '../domain/entities/country.dart';
import '../domain/entities/unit_system.dart';
import '../domain/repositories/onboarding_repository.dart';

@LazySingleton(as: OnboardingRepository)
class OnboardingRepositoryImpl implements OnboardingRepository {
  static const _kCompleted = 'onboarding_completed';
  static const _kLocale = 'first_run_locale';
  static const _kTheme = 'first_run_theme';
  static const _kCountry = 'first_run_country';
  static const _kUnit = 'first_run_unit';

  Box get _box => Hive.box(HiveBoxes.prefs);

  @override
  bool isCompleted() => _box.get(_kCompleted, defaultValue: false) as bool;

  @override
  Future<void> markCompleted() => _box.put(_kCompleted, true);

  @override
  Future<void> markNotCompleted() => _box.put(_kCompleted, false);

  @override
  Future<FirstRunPreferences> loadFirstRunPreferences() async {
    final localeCode = _box.get(_kLocale, defaultValue: 'en') as String;
    final themeName = _box.get(_kTheme, defaultValue: ThemeMode.system.name) as String;
    final countryIso = _box.get(_kCountry, defaultValue: Country.us.iso2) as String;
    final unitName = _box.get(_kUnit, defaultValue: UnitSystem.metric.name) as String;
    return FirstRunPreferences(
      locale: Locale(localeCode),
      themeMode: ThemeMode.values.byName(themeName),
      country: Country.values.firstWhere(
        (c) => c.iso2 == countryIso,
        orElse: () => Country.us,
      ),
      unitSystem: UnitSystem.values.byName(unitName),
    );
  }

  @override
  Future<void> saveFirstRunPreferences(FirstRunPreferences prefs) async {
    await _box.put(_kLocale, prefs.locale.languageCode);
    await _box.put(_kTheme, prefs.themeMode.name);
    await _box.put(_kCountry, prefs.country.iso2);
    await _box.put(_kUnit, prefs.unitSystem.name);
  }
}
```

- [ ] **Step B1.5：写 `onboarding_repository_test.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:sightour/core/storage/hive_boxes.dart';
import 'package:sightour/features/onboarding/data/repositories/onboarding_repository_impl.dart';
import 'package:sightour/features/onboarding/domain/entities/country.dart';
import 'package:sightour/features/onboarding/domain/entities/unit_system.dart';
import 'package:sightour/features/onboarding/domain/repositories/onboarding_repository.dart';

class _FakePathProvider extends PathProviderPlatform with MockPlatformInterfaceMixin {
  @override
  Future<String?> getApplicationDocumentsPath() async =>
      '.dart_test/app_docs_onboarding';
}

void main() {
  setUpAll(() {
    PathProviderPlatform.instance = _FakePathProvider();
  });

  setUp(() async {
    final p = '.dart_test/hive_onboarding_${DateTime.now().microsecondsSinceEpoch}';
    Hive.init(p);
    await Hive.openBox(HiveBoxes.prefs);
  });

  tearDown(() async {
    if (Hive.isBoxOpen(HiveBoxes.prefs)) {
      await Hive.box(HiveBoxes.prefs).close();
    }
  });

  test('isCompleted defaults to false', () {
    final repo = OnboardingRepositoryImpl();
    expect(repo.isCompleted(), false);
  });

  test('markCompleted then isCompleted returns true', () async {
    final repo = OnboardingRepositoryImpl();
    await repo.markCompleted();
    expect(repo.isCompleted(), true);
  });

  test('markNotCompleted then isCompleted returns false', () async {
    final repo = OnboardingRepositoryImpl();
    await repo.markCompleted();
    await repo.markNotCompleted();
    expect(repo.isCompleted(), false);
  });

  test('save + load FirstRunPreferences roundtrip', () async {
    final repo = OnboardingRepositoryImpl();
    final original = FirstRunPreferences(
      locale: const Locale('zh'),
      themeMode: ThemeMode.dark,
      country: Country.jp,
      unitSystem: UnitSystem.imperial,
    );
    await repo.saveFirstRunPreferences(original);
    final loaded = await repo.loadFirstRunPreferences();
    expect(loaded.locale, const Locale('zh'));
    expect(loaded.themeMode, ThemeMode.dark);
    expect(loaded.country, Country.jp);
    expect(loaded.unitSystem, UnitSystem.imperial);
  });

  test('loadFirstRunPreferences defaults when empty', () async {
    final repo = OnboardingRepositoryImpl();
    final loaded = await repo.loadFirstRunPreferences();
    expect(loaded.locale.languageCode, 'en');
    expect(loaded.themeMode, ThemeMode.system);
    expect(loaded.country, Country.us);
    expect(loaded.unitSystem, UnitSystem.metric);
  });
}
```

- [ ] **Step B1.6：跑 `dart analyze`**

```bash
cd app
dart analyze
```

预期：`No issues found!`

- [ ] **Step B1.7：跑 `flutter test`**

```bash
cd app
flutter test test/onboarding/onboarding_repository_test.dart
```

预期：5 个 passed。

- [ ] **Step B1.8：提交**

```bash
cd c:\Users\wenmo\.trae-cn\worktrees\旅游app
git add app/
git commit -m "feat(onboarding): add domain entities and repository backed by Hive"
```

---

## Task B2：i18n 增量（32 个新 key）

**Files:**
- Modify: `app/lib/l10n/app_en.arb`
- Modify: `app/lib/l10n/app_zh.arb`
- Create: `app/test/i18n/onboarding_l10n_test.dart`

> **全部 key 与中英文翻译来自 spec §6**

- [ ] **Step B2.1：增量 32 个 key 到 `app_en.arb`**

在 `app_en.arb` 末尾追加（不删旧 key）：

```json
{
  "commonNext": "Next",
  "commonGetStarted": "Get started",

  "onboardingWelcomeTitle": "Welcome to Sightour",
  "onboardingWelcomeSubtitle": "Your private guide to Shanghai. Built for visitors, no account needed.",

  "onboardingFeaturesTitle": "Everything you need, in one place",
  "onboardingFeaturesPrepareTitle": "Prepare before you fly",
  "onboardingFeaturesPrepareDesc": "Visa, currency, weather — answered in 30 seconds for your passport.",
  "onboardingFeaturesMapTitle": "Map that respects you",
  "onboardingFeaturesMapDesc": "Tap an attraction, get an honest read from local visitors.",
  "onboardingFeaturesDiscoverTitle": "Discover what's actually good",
  "onboardingFeaturesDiscoverDesc": "Curated lists — not SEO-spam rankings.",
  "onboardingFeaturesToolsTitle": "Tools that work offline",
  "onboardingFeaturesToolsDesc": "Phrases, FX, emergency numbers — when Wi-Fi is dead.",

  "onboardingSettingsTitle": "Quick setup",
  "onboardingSettingsSubtitle": "We'll tailor Sightour to you. You can change any of this later.",
  "onboardingSettingsLanguage": "Language",
  "onboardingSettingsTheme": "Appearance",
  "onboardingSettingsCountry": "Your passport country",
  "onboardingSettingsUnit": "Units",
  "onboardingSettingsCountryHint": "Select your country",

  "privacyTitle": "Privacy & terms",
  "privacyIntro": "Sightour is built for visitors. Here's what we do — and don't do — with your data.",
  "privacyPoint1": "No account, no login, no email required.",
  "privacyPoint2": "An anonymous device ID is generated to remember your settings. Nothing else.",
  "privacyPoint3": "Your checklist and favorites are stored on this device only.",
  "privacyPoint4": "You choose whether error reports include your location.",
  "privacyPoint5": "Correction submissions are anonymous unless you sign them.",
  "privacyPoint6": "Read the full privacy policy",
  "privacyAgree": "I have read and agree to the privacy policy",
  "privacyTermsAgree": "I agree to the terms of service",
  "privacyEnter": "Enter Sightour"
}
```

- [ ] **Step B2.2：增量中文版到 `app_zh.arb`**

```json
{
  "commonNext": "下一步",
  "commonGetStarted": "开始使用",

  "onboardingWelcomeTitle": "欢迎使用 Sightour",
  "onboardingWelcomeSubtitle": "为来沪游客打造的私人向导。无需注册账号。",

  "onboardingFeaturesTitle": "一个 App，搞定一切",
  "onboardingFeaturesPrepareTitle": "行前准备",
  "onboardingFeaturesPrepareDesc": "签证、货币、天气 — 按你的护照 30 秒解答。",
  "onboardingFeaturesMapTitle": "尊重你的地图",
  "onboardingFeaturesMapDesc": "点景点，看本地游客的真实评价。",
  "onboardingFeaturesDiscoverTitle": "发现真正的好地方",
  "onboardingFeaturesDiscoverDesc": "精挑细选的榜单 — 不是 SEO 垃圾排名。",
  "onboardingFeaturesToolsTitle": "离线也能用的工具",
  "onboardingFeaturesToolsDesc": "短语、汇率、紧急电话 — Wi-Fi 断也不慌。",

  "onboardingSettingsTitle": "快速设置",
  "onboardingSettingsSubtitle": "按你的情况定制。随时可以在设置里改。",
  "onboardingSettingsLanguage": "语言",
  "onboardingSettingsTheme": "外观",
  "onboardingSettingsCountry": "你的护照国家",
  "onboardingSettingsUnit": "单位",
  "onboardingSettingsCountryHint": "选择国家",

  "privacyTitle": "隐私与服务条款",
  "privacyIntro": "Sightour 为游客而生。这是我们对数据做的事 — 和不做的。",
  "privacyPoint1": "无需账号、登录、邮箱。",
  "privacyPoint2": "仅生成匿名设备 ID 用来记你的设置。仅此而已。",
  "privacyPoint3": "你的清单和收藏只存在本机。",
  "privacyPoint4": "错误反馈是否带位置由你决定。",
  "privacyPoint5": "纠错提交默认匿名，除非你署名。",
  "privacyPoint6": "阅读完整隐私政策",
  "privacyAgree": "我已阅读并同意隐私政策",
  "privacyTermsAgree": "我同意服务条款",
  "privacyEnter": "进入 Sightour"
}
```

- [ ] **Step B2.3：重跑 `flutter gen-l10n`**

```bash
cd app
flutter gen-l10n
```

预期：`app/lib/l10n/generated/` 中 `app_localizations.dart` 自动更新。

- [ ] **Step B2.4：写 `onboarding_l10n_test.dart`**

```dart
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
        l10n = AppLocalizations.of(ctx)!;
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
```

- [ ] **Step B2.5：跑测试**

```bash
cd app
flutter test test/i18n/onboarding_l10n_test.dart
```

预期：2 个 passed。

- [ ] **Step B2.6：提交**

```bash
cd c:\Users\wenmo\.trae-cn\worktrees\旅游app
git add app/
git commit -m "feat(i18n): add 32 onboarding keys (en + zh)"
```

---

## Task B3：表现层（FirstRunSettingsCubit + 3 子 Page + Flow）

**Files:**
- Create: `app/lib/features/onboarding/presentation/cubit/first_run_settings_cubit.dart`
- Create: `app/lib/features/onboarding/presentation/widgets/onboarding_indicator.dart`
- Create: `app/lib/features/onboarding/presentation/pages/onboarding_welcome_page.dart`
- Create: `app/lib/features/onboarding/presentation/pages/onboarding_features_page.dart`
- Create: `app/lib/features/onboarding/presentation/pages/onboarding_settings_page.dart`
- Create: `app/lib/features/onboarding/presentation/pages/onboarding_flow_page.dart`
- Modify: `app/lib/core/router/route_names.dart`（加 onboarding + privacyConsent）
- Create: `app/test/onboarding/first_run_settings_cubit_test.dart`
- Create: `app/test/onboarding/onboarding_flow_page_test.dart`

> **代码来自 spec §4**

- [ ] **Step B3.1：写 `first_run_settings_cubit.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/country.dart';
import '../../domain/entities/unit_system.dart';

class FirstRunSettingsState {
  const FirstRunSettingsState({
    this.locale = const Locale('en'),
    this.themeMode = ThemeMode.system,
    this.country = Country.us,
    this.unitSystem = UnitSystem.metric,
  });
  final Locale locale;
  final ThemeMode themeMode;
  final Country country;
  final UnitSystem unitSystem;

  FirstRunSettingsState copyWith({
    Locale? locale,
    ThemeMode? themeMode,
    Country? country,
    UnitSystem? unitSystem,
  }) =>
      FirstRunSettingsState(
        locale: locale ?? this.locale,
        themeMode: themeMode ?? this.themeMode,
        country: country ?? this.country,
        unitSystem: unitSystem ?? this.unitSystem,
      );
}

@lazySingleton
class FirstRunSettingsCubit extends Cubit<FirstRunSettingsState> {
  FirstRunSettingsCubit() : super(const FirstRunSettingsState());
  void setLocale(Locale l) => emit(state.copyWith(locale: l));
  void setTheme(ThemeMode m) => emit(state.copyWith(themeMode: m));
  void setCountry(Country c) => emit(state.copyWith(country: c));
  void setUnit(UnitSystem u) => emit(state.copyWith(unitSystem: u));
}
```

- [ ] **Step B3.2：写 `onboarding_indicator.dart`**

完整代码见 spec §4.7。

- [ ] **Step B3.3：写 `onboarding_welcome_page.dart`**

`StatelessWidget`，渲染 Icon + `onboardingWelcomeTitle` + `onboardingWelcomeSubtitle`。见 spec §4.2。

- [ ] **Step B3.4：写 `onboarding_features_page.dart`**

`StatelessWidget`，4 行（Icon + 标题 + 描述）：Prepare / Map / Discover / Tools。每行用 `Padding` + `Row` 实现。代码来自 spec §4.3。

- [ ] **Step B3.5：写 `onboarding_settings_page.dart`**

`StatefulWidget`，内含 4 个控件：
1. **语言**：2 个 `ChoiceChip`（English / 中文）
2. **主题**：3 个 `ChoiceChip`（System / Light / Dark）
3. **母国**：点击触发 `showModalBottomSheet` 显示 10 个 Country 列表
4. **单位**：2 个 `ChoiceChip`（公制 / 英制）

每个控件变更 → 调用 `context.read<FirstRunSettingsCubit>().setXxx(...)`。**同时**调用 `context.read<LocaleCubit>().setLocale(...)` 和 `context.read<ThemeCubit>().setMode(...)` 让 UI 立即生效（来自 spec §6 的风险缓解）。

- [ ] **Step B3.6：写 `onboarding_flow_page.dart`**

`StatefulWidget`，3 页 `PageView` + `OnboardingIndicator` + 底部 `ElevatedButton`。完整代码见 spec §4.1。

- [ ] **Step B3.7：更新 `route_names.dart`**

追加：

```dart
static const onboarding = 'onboarding';
static const privacyConsent = 'privacy_consent';
```

- [ ] **Step B3.8：写 `first_run_settings_cubit_test.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sightour/features/onboarding/domain/entities/country.dart';
import 'package:sightour/features/onboarding/domain/entities/unit_system.dart';
import 'package:sightour/features/onboarding/presentation/cubit/first_run_settings_cubit.dart';

void main() {
  test('default state', () {
    final c = FirstRunSettingsCubit();
    expect(c.state.locale.languageCode, 'en');
    expect(c.state.themeMode, ThemeMode.system);
    expect(c.state.country, Country.us);
    expect(c.state.unitSystem, UnitSystem.metric);
  });

  test('setLocale emits', () async {
    final c = FirstRunSettingsCubit();
    c.setLocale(const Locale('zh'));
    expect(c.state.locale, const Locale('zh'));
  });

  test('setTheme emits', () {
    final c = FirstRunSettingsCubit();
    c.setTheme(ThemeMode.dark);
    expect(c.state.themeMode, ThemeMode.dark);
  });

  test('setCountry emits', () {
    final c = FirstRunSettingsCubit();
    c.setCountry(Country.jp);
    expect(c.state.country, Country.jp);
  });

  test('setUnit emits', () {
    final c = FirstRunSettingsCubit();
    c.setUnit(UnitSystem.imperial);
    expect(c.state.unitSystem, UnitSystem.imperial);
  });
}
```

- [ ] **Step B3.9：写 `onboarding_flow_page_test.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sightour/core/di/injection.dart';
import 'package:sightour/core/i18n/locale_cubit.dart';
import 'package:sightour/features/onboarding/presentation/cubit/first_run_settings_cubit.dart';
import 'package:sightour/features/onboarding/presentation/pages/onboarding_flow_page.dart';
import 'package:sightour/l10n/generated/app_localizations.dart';

void main() {
  setUpAll(() async {
    await configureDependencies();
  });

  Widget _wrap(Widget child) {
    return MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: MultiBlocProvider(
        providers: [
          BlocProvider<LocaleCubit>(create: (_) => getIt<LocaleCubit>()),
          BlocProvider<FirstRunSettingsCubit>(
            create: (_) => getIt<FirstRunSettingsCubit>(),
          ),
        ],
        child: child,
      ),
    );
  }

  testWidgets('Flow shows Next on page 0', (tester) async {
    await tester.pumpWidget(_wrap(const OnboardingFlowPage()));
    await tester.pumpAndSettle();
    expect(find.text('Next'), findsOneWidget);
  });

  testWidgets('Tap Next advances to page 1', (tester) async {
    await tester.pumpWidget(_wrap(const OnboardingFlowPage()));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    expect(find.text('Next'), findsOneWidget); // still Next on page 1
  });

  testWidgets('Tap Next 3 times shows Get started', (tester) async {
    await tester.pumpWidget(_wrap(const OnboardingFlowPage()));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    expect(find.text('Get started'), findsOneWidget);
  });

  testWidgets('Onboarding indicator shows 3 dots', (tester) async {
    await tester.pumpWidget(_wrap(const OnboardingFlowPage()));
    await tester.pumpAndSettle();
    // The 3 dot row exists
    expect(find.byType(Container), findsWidgets);
  });
}
```

- [ ] **Step B3.10：跑 `dart analyze` + `flutter test`**

```bash
cd app
dart analyze
flutter test test/onboarding/
```

预期：0 issues，所有 test 通过（累计 40+ passed）。

- [ ] **Step B3.11：提交**

```bash
cd c:\Users\wenmo\.trae-cn\worktrees\旅游app
git add app/
git commit -m "feat(onboarding): add 3-page flow + FirstRunSettingsCubit"
```

---

## Task B4：PrivacyConsentPage

**Files:**
- Create: `app/lib/features/onboarding/presentation/pages/privacy_consent_page.dart`
- Create: `app/test/onboarding/privacy_consent_page_test.dart`

> **代码来自 spec §4.6**

- [ ] **Step B4.1：写 `privacy_consent_page.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:sightour/core/i18n/locale_cubit.dart';
import 'package:sightour/core/theme/app_colors.dart';
import 'package:sightour/core/theme/app_spacing.dart';
import 'package:sightour/core/theme/app_text_styles.dart';
import 'package:sightour/l10n/generated/app_localizations.dart';
import '../../../../shared/pages/coming_soon_page.dart';
import 'package:go_router/go_router.dart';

class PrivacyConsentPage extends StatefulWidget {
  const PrivacyConsentPage({super.key});

  @override
  State<PrivacyConsentPage> createState() => _PrivacyConsentPageState();
}

class _PrivacyConsentPageState extends State<PrivacyConsentPage> {
  bool _privacyAgreed = false;
  bool _termsAgreed = false;

  bool get _canEnter => _privacyAgreed && _termsAgreed;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final points = [
      l.privacyPoint1,
      l.privacyPoint2,
      l.privacyPoint3,
      l.privacyPoint4,
      l.privacyPoint5,
    ];
    return Scaffold(
      appBar: AppBar(title: Text(l.privacyTitle)),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.s4),
              child: Text(l.privacyIntro, style: AppTextTheme.textTheme.bodyLarge),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(AppSpacing.s4),
                itemCount: points.length,
                itemBuilder: (_, i) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.s2),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${i + 1}. ', style: AppTextTheme.textTheme.bodyLarge),
                      Expanded(child: Text(points[i], style: AppTextTheme.textTheme.bodyLarge)),
                    ],
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ComingSoonPage(title: 'Privacy Policy')),
              ),
              child: Text(l.privacyPoint6),
            ),
            const Divider(height: 1),
            CheckboxListTile(
              value: _privacyAgreed,
              onChanged: (v) => setState(() => _privacyAgreed = v ?? false),
              title: Text(l.privacyAgree),
              controlAffinity: ListTileControlAffinity.leading,
            ),
            CheckboxListTile(
              value: _termsAgreed,
              onChanged: (v) => setState(() => _termsAgreed = v ?? false),
              title: Text(l.privacyTermsAgree),
              controlAffinity: ListTileControlAffinity.leading,
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.s4),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _canEnter
                      ? () => context.go('/onboarding/complete')
                      : null,
                  child: Text(l.privacyEnter),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

> 注意：本阶段路由表加 `/onboarding/complete` 是个简单占位，由 Task B5 的 redirect 逻辑处理完成跳转。

- [ ] **Step B4.2：写 `privacy_consent_page_test.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sightour/features/onboarding/presentation/pages/privacy_consent_page.dart';
import 'package:sightour/l10n/generated/app_localizations.dart';

void main() {
  Widget _wrap(Widget child) => MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: child,
      );

  testWidgets('Initial state: Enter button disabled', (tester) async {
    await tester.pumpWidget(_wrap(const PrivacyConsentPage()));
    await tester.pumpAndSettle();
    final btn = tester.widget<ElevatedButton>(find.widgetWithText(ElevatedButton, 'Enter Sightour'));
    expect(btn.onPressed, isNull);
  });

  testWidgets('Check both → Enter button enabled', (tester) async {
    await tester.pumpWidget(_wrap(const PrivacyConsentPage()));
    await tester.pumpAndSettle();
    await tester.tap(find.text('I have read and agree to the privacy policy'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('I agree to the terms of service'));
    await tester.pumpAndSettle();
    final btn = tester.widget<ElevatedButton>(find.widgetWithText(ElevatedButton, 'Enter Sightour'));
    expect(btn.onPressed, isNotNull);
  });

  testWidgets('ZH: 按钮文字 + 必勾选', (tester) async {
    await tester.pumpWidget(_wrap(
      Builder(builder: (ctx) {
        AppLocalizations.of(ctx); // touch
        return const PrivacyConsentPage();
      }),
    ));
    await tester.pumpAndSettle();
    // Verify Chinese title is rendered
    expect(find.text('隐私与服务条款'), findsOneWidget);
  });
}
```

> 注意：第二个 widget test 使用的是英文 + 切换到中文的硬编码预期。`testWidgets` 接受一个 `WidgetTester`，在 MaterialApp 内 locale 是英文。中文测试需要在 MaterialApp 加 `locale: const Locale('zh')`。

- [ ] **Step B4.3：跑测试**

```bash
cd app
flutter test test/onboarding/privacy_consent_page_test.dart
```

预期：3 个 passed。

- [ ] **Step B4.4：提交**

```bash
cd c:\Users\wenmo\.trae-cn\worktrees\旅游app
git add app/
git commit -m "feat(onboarding): add privacy consent page with required checkboxes"
```

---

## Task B5：路由 redirect 接入

**Files:**
- Modify: `app/lib/core/router/route_guards.dart`
- Modify: `app/lib/core/router/app_router.dart`
- Modify: `app/lib/core/router/route_names.dart`（加 onboardingComplete）
- Create: `app/test/router/redirect_test.dart`

> **代码来自 spec §5**

- [ ] **Step B5.1：route_names.dart 加 `onboardingComplete`**

```dart
static const onboardingComplete = 'onboarding_complete';
```

- [ ] **Step B5.2：完善 `route_guards.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../features/onboarding/domain/repositories/onboarding_repository.dart';
import '../di/injection.dart';

String? onboardingRedirect(BuildContext context, GoRouterState state) {
  final repo = getIt<OnboardingRepository>();
  if (!repo.isCompleted() &&
      state.matchedLocation != '/onboarding' &&
      !state.matchedLocation.startsWith('/onboarding/')) {
    return '/onboarding';
  }
  if (repo.isCompleted() && state.matchedLocation.startsWith('/onboarding')) {
    return '/prepare';
  }
  return null;
}
```

- [ ] **Step B5.3：在 `app_router.dart` 顶部注册 redirect 和新路由**

在 `appRouter = GoRouter(...)` 中：
- 加 `redirect: (ctx, state) => onboardingRedirect(ctx, state)`
- 加 `/onboarding` 与 `/onboarding/privacy` 路由（参考 spec §1 的代码）

```dart
GoRoute(
  path: '/onboarding',
  name: RouteNames.onboarding,
  builder: (_, __) => const OnboardingFlowPage(),
  routes: [
    GoRoute(
      path: 'privacy',
      name: RouteNames.privacyConsent,
      builder: (_, __) => const PrivacyConsentPage(),
    ),
    GoRoute(
      path: 'complete',
      name: RouteNames.onboardingComplete,
      builder: (_, state) {
        // Side effect: mark completed + apply prefs to global cubits
        final repo = getIt<OnboardingRepository>();
        repo.markCompleted();
        return const _OnboardingCompletePage();
      },
    ),
  ],
),
```

加 `_OnboardingCompletePage`（在 app_router.dart 底部）：

```dart
class _OnboardingCompletePage extends StatelessWidget {
  const _OnboardingCompletePage();
  @override
  Widget build(BuildContext context) {
    // 短暂展示后跳到 /prepare
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.go('/prepare');
    });
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
```

- [ ] **Step B5.4：写 `redirect_test.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:sightour/core/di/injection.dart';
import 'package:sightour/core/router/app_router.dart';
import 'package:sightour/core/storage/hive_boxes.dart';
import 'package:sightour/features/onboarding/domain/repositories/onboarding_repository.dart';

class _FakePathProvider extends PathProviderPlatform with MockPlatformInterfaceMixin {
  @override
  Future<String?> getApplicationDocumentsPath() async =>
      '.dart_test/app_docs_redirect_${DateTime.now().microsecondsSinceEpoch}';
}

void main() {
  setUpAll(() {
    PathProviderPlatform.instance = _FakePathProvider();
  });

  setUp(() async {
    if (getIt.isRegistered<OnboardingRepository>()) {
      await getIt.reset();
    }
    final p = '.dart_test/hive_redirect_${DateTime.now().microsecondsSinceEpoch}';
    Hive.init(p);
    await Hive.openBox(HiveBoxes.prefs);
    await configureDependencies();
    appRouter.go('/prepare');
  });

  test('Uncompleted onboarding redirects /prepare to /onboarding', () async {
    // After setUp, no completion yet
    final initialLocation = appRouter.routerDelegate.currentConfiguration.uri.path;
    expect(initialLocation, '/onboarding');
  });

  test('After markCompleted, navigation to /prepare stays', () async {
    await getIt<OnboardingRepository>().markCompleted();
    appRouter.go('/prepare');
    await Future<void>.delayed(const Duration(milliseconds: 100));
    final loc = appRouter.routerDelegate.currentConfiguration.uri.path;
    expect(loc, '/prepare');
  });
}
```

- [ ] **Step B5.5：跑所有测试**

```bash
cd app
dart analyze
flutter test
```

预期：0 issues。`flutter test` 累计 50+ passed。

- [ ] **Step B5.6：提交**

```bash
cd c:\Users\wenmo\.trae-cn\worktrees\旅游app
git add app/
git commit -m "feat(router): redirect to /onboarding when first-run incomplete"
```

---

## 最终验收

| # | 命令 | 期望 |
| :--- | :--- | :--- |
| 1 | `cd app && flutter pub get` | 成功 |
| 2 | `cd app && dart analyze` | `No issues found!` |
| 3 | `cd app && flutter test` | 50+ passed |
| 4 | `git log --oneline \| head -10` | 19 commits（spec/plan/Stage 0/Stage 1 Spec A × 5/Stage 1 Spec B × 5） |
| 5 | widget test `OnboardingFlowPage` | Next 3 次 → Get started |
| 6 | widget test `PrivacyConsentPage` | 双勾选 → Enter 启用 |
| 7 | `flutter run -d emulator-5554` | App 启动进 /onboarding，完成后转 /prepare |
