# Sightour Spec B — Onboarding + 隐私协议设计

> **类型**：阶段一子 spec B
> **范围**：MVP 计划 Task 11-12（Onboarding + 隐私协议 + 游客模式 + 单位切换）
> **依赖**：Spec A（基础设施）
> **版本**：v1.0 — 2026-06-27

---

## 0. 范围

- ✅ Onboarding 3 页（2 页功能介绍 + 1 页首启设置）
- ✅ 隐私协议 + 服务条款强制同意页
- ✅ 游客模式（不需登录，anonymousId 已在 Spec A 准备好）
- ✅ 首启设置：语言（沿用 LocaleCubit）+ 主题（沿用 ThemeCubit）+ 母国选择（新增）
- ✅ 单位切换（公制/英制，阶段三 POI 距离展示时用）
- ❌ 不做"重新走一遍 Onboarding"功能（阶段二 Profile 加）
- ❌ 不做账号注册/登录（阶段三）

---

## 1. 路由改动

新增路由（在 Spec A 路由表基础上）：

```dart
// 首次启动且未完成 onboarding
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
  ],
),
```

首次启动判断：
- `prefs` box 检查 `onboarding_completed`（默认 false）
- 应用启动时 `appRouter` 走 redirect：
  - 未完成 → `/onboarding`
  - 已完成 → `/prepare`（默认）

---

## 2. 目录结构

```
app/lib/
├── features/
│   └── onboarding/
│       ├── domain/
│       │   ├── entities/
│       │   │   ├── country.dart           # Country enum / model
│       │   │   └── unit_system.dart       # Metric/Imperial
│       │   └── repositories/
│       │       └── onboarding_repository.dart
│       ├── data/
│       │   ├── repositories/
│       │   │   └── onboarding_repository_impl.dart
│       │   └── datasources/
│       │       └── countries_data.dart    # 10 主流客源国
│       └── presentation/
│           ├── cubit/
│           │   ├── onboarding_cubit.dart  # current page / submit
│           │   └── first_run_settings_cubit.dart
│           ├── pages/
│           │   ├── onboarding_flow_page.dart       # 3 页 PageView
│           │   ├── onboarding_welcome_page.dart    # 第 1 页
│           │   ├── onboarding_features_page.dart   # 第 2 页
│           │   ├── onboarding_settings_page.dart   # 第 3 页
│           │   └── privacy_consent_page.dart       # 隐私同意
│           └── widgets/
│               ├── onboarding_indicator.dart       # 圆点指示器
│               ├── country_picker_tile.dart
│               └── unit_toggle.dart
```

---

## 3. 领域层

### 3.1 `Country`（10 个主流客源国）

`app/lib/features/onboarding/domain/entities/country.dart`：

```dart
enum Country {
  us('US', 'United States', '美国', '🇺🇸'),
  uk('GB', 'United Kingdom', '英国', '🇬🇧'),
  jp('JP', 'Japan', '日本', '🇯🇵'),
  kr('KR', 'South Korea', '韩国', '🇰🇷'),
  de('DE', 'Germany', '德国', '🇩🇪'),
  fr('FR', 'France', '法国', '🇫🇷'),
  au('AU', 'Australia', '澳大利亚', '🇦🇺'),
  ca('CA', 'Canada', '加拿大', '🇨🇦'),
  it('IT', 'Italy', '意大利', '🇮🇹'),
  ru('RU', 'Russia', '俄罗斯', '🇷🇺');

  const Country(this.iso2, this.nameEn, this.nameZh, this.flag);
  final String iso2;
  final String nameEn;
  final String nameZh;
  final String flag;
}
```

### 3.2 `UnitSystem`

```dart
enum UnitSystem {
  metric('Metric (km, °C)', '公制'),
  imperial('Imperial (mi, °F)', '英制');

  const UnitSystem(this.labelEn, this.labelZh);
  final String labelEn;
  final String labelZh;
}
```

### 3.3 `OnboardingRepository`

```dart
abstract class OnboardingRepository {
  bool isCompleted();
  Future<void> markCompleted();
  Future<FirstRunPreferences> loadFirstRunPreferences();
  Future<void> saveFirstRunPreferences(FirstRunPreferences prefs);
  Future<void> reset(); // for testing
}

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
```

### 3.4 `OnboardingRepositoryImpl`（基于 Hive）

```dart
class OnboardingRepositoryImpl implements OnboardingRepository {
  static const _kCompleted = 'onboarding_completed';
  static const _kCountry = 'first_run_country';
  static const _kUnit = 'first_run_unit';

  // 完成标记存在 prefs box
  @override
  bool isCompleted() {
    final box = Hive.box(HiveBoxes.prefs);
    return box.get(_kCompleted, defaultValue: false) as bool;
  }

  @override
  Future<void> markCompleted() async {
    final box = Hive.box(HiveBoxes.prefs);
    await box.put(_kCompleted, true);
  }

  @override
  Future<FirstRunPreferences> loadFirstRunPreferences() async {
    // 读取 LocaleCubit / ThemeCubit 当前值 + country + unit
    // 详见实现
  }

  // ...
}
```

---

## 4. 表现层

### 4.1 `OnboardingFlowPage`（3 页 PageView）

`app/lib/features/onboarding/presentation/pages/onboarding_flow_page.dart`：

```dart
class OnboardingFlowPage extends StatefulWidget {
  const OnboardingFlowPage({super.key});
  @override
  State<OnboardingFlowPage> createState() => _OnboardingFlowPageState();
}

class _OnboardingFlowPageState extends State<OnboardingFlowPage> {
  final _controller = PageController();
  int _page = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _controller,
                onPageChanged: (i) => setState(() => _page = i),
                children: const [
                  OnboardingWelcomePage(),   // 0
                  OnboardingFeaturesPage(),  // 1
                  OnboardingSettingsPage(),  // 2
                ],
              ),
            ),
            OnboardingIndicator(count: 3, current: _page),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.s6),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_page < 2) {
                      _controller.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                      );
                    } else {
                      context.go('/onboarding/privacy');
                    }
                  },
                  child: Text(
                    _page < 2
                        ? AppLocalizations.of(context)!.commonNext
                        : AppLocalizations.of(context)!.commonGetStarted,
                  ),
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

### 4.2 第 1 页：欢迎

```dart
class OnboardingWelcomePage extends StatelessWidget {
  const OnboardingWelcomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.s6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.travel_explore, size: 80, color: AppColors.blue600),
          const SizedBox(height: AppSpacing.s6),
          Text(
            AppLocalizations.of(context)!.onboardingWelcomeTitle,
            style: AppTextTheme.textTheme.displaySmall,
          ),
          const SizedBox(height: AppSpacing.s4),
          Text(
            AppLocalizations.of(context)!.onboardingWelcomeSubtitle,
            style: AppTextTheme.textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
```

### 4.3 第 2 页：4 大核心能力

4 行，每行 Icon + 标题 + 副标题：
- Prepare（行前准备）— `flight_takeoff`
- Map（地图）— `map_outlined`
- Discover（发现）— `explore_outlined`
- Tools（工具）— `build_outlined`

### 4.4 第 3 页：首启设置

- 语言选择（English / 中文 toggle）
- 主题选择（System / Light / Dark，3 按钮 segmented）
- 母国选择（10 个国家列表，full modal）
- 单位选择（公制 / 英制，2 按钮 segmented）

### 4.5 `FirstRunSettingsCubit`

```dart
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

  FirstRunSettingsState copyWith({...}) => ...;
}

class FirstRunSettingsCubit extends Cubit<FirstRunSettingsState> {
  FirstRunSettingsCubit() : super(const FirstRunSettingsState());
  void setLocale(Locale l) => emit(state.copyWith(locale: l));
  void setTheme(ThemeMode m) => emit(state.copyWith(themeMode: m));
  void setCountry(Country c) => emit(state.copyWith(country: c));
  void setUnit(UnitSystem u) => emit(state.copyWith(unitSystem: u));
}
```

### 4.6 `PrivacyConsentPage`

- 顶部：`AppLocalizations.of(context)!.privacyTitle`
- 中间 scrollable：6 段简短说明（每段 1 行）
  - 1. 我们不收集账号（游客模式）
  - 2. 仅匿名 ID（设备级别）
  - 3. 行前清单保存本地，不上传
  - 4. 错误反馈可选择附位置
  - 5. 纠错提交匿名
  - 6. 隐私政策全文可点
- 底部：必勾选 checkbox「我已阅读并同意」+ 「我同意服务条款」
- 「进入 Sightour」按钮：未勾选时 disabled

### 4.7 `OnboardingIndicator`（圆点指示器）

```dart
class OnboardingIndicator extends StatelessWidget {
  const OnboardingIndicator({required this.count, required this.current, super.key});
  final int count;
  final int current;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final active = i == current;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: AppSpacing.s1),
          width: active ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: active ? AppColors.blue600 : AppColors.slate300,
            borderRadius: BorderRadius.circular(AppRadius.full),
          ),
        );
      }),
    );
  }
}
```

---

## 5. 路由守卫（spec 阶段二就位，本阶段已可用）

`app/lib/core/router/route_guards.dart`：

```dart
String? onboardingRedirect(BuildContext context, GoRouterState state) {
  final repo = getIt<OnboardingRepository>();
  if (!repo.isCompleted() && state.matchedLocation != '/onboarding' &&
      !state.matchedLocation.startsWith('/onboarding/')) {
    return '/onboarding';
  }
  if (repo.isCompleted() && state.matchedLocation.startsWith('/onboarding')) {
    return '/prepare';
  }
  return null;
}
```

在 `appRouter` 的 `redirect:` 字段调用 `onboardingRedirect`。

---

## 6. i18n 增量

`app_en.arb` 新增（约 18 个 key）：

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

中文版同步翻译（每行末尾换中文）。新增总数 **32 个 key**。

---

## 7. 依赖注入

`injection.dart` 新增（`@lazySingleton`）：

- `OnboardingRepository`（实现 `OnboardingRepositoryImpl`）
- `FirstRunSettingsCubit`

Cubit 在 OnboardingSettingsPage 中通过 `BlocProvider` 局部注入，不放全局。

---

## 8. 测试

- `test/onboarding/onboarding_repository_test.dart`：`isCompleted / markCompleted / loadFirstRunPreferences / saveFirstRunPreferences / reset`
- `test/onboarding/first_run_settings_cubit_test.dart`：4 个 setter
- `test/onboarding/onboarding_flow_page_test.dart`：3 页 PageView 切换、底部按钮文案
- `test/onboarding/privacy_consent_page_test.dart`：必勾选时按钮 disabled → enabled
- `test/router/redirect_test.dart`：未完成 → /onboarding；已完成 → /prepare

---

## 9. 范围外

- ❌ 不做账号注册 / 登录
- ❌ 不做「重新走一遍 Onboarding」（下个 Spec 调整）
- ❌ 不做完整隐私政策全文（只放简版 + 「Read full」链接，链到占位 Page）
- ❌ 不做 unit system 实际换算（公制/英制只在 UI 显示标记，阶段三在 POI 距离显示时用）
- ❌ 不做「手机号 / 邮箱 / 实名」

---

## 10. 风险

| 风险 | 缓解 |
| --- | --- |
| 用户误关闭 App 后再次进入 onboarding | Hive prefs 持久化（已完成 `markCompleted`） |
| LocaleCubit / ThemeCubit 与 Onboarding 设置不同步 | OnboardingSettingsPage 直接调用 `LocaleCubit.setLocale` / `ThemeCubit.setMode`，立即生效 + 持久化 |
| 32 个新 i18n key 翻译不同步 | en / zh 同步写进 plan 测试 |
| 母国 enum 扩展性差 | 阶段二用 freezed Country model 替换；本阶段 10 个固定 enum 够用 |

---

## 11. 提交策略

```
feat(onboarding): add first-run settings + privacy consent
feat(router): redirect to /onboarding when prefs.onboarding_completed is false
test(onboarding): add 5 test files covering repository, cubit, flow, privacy, redirect
```

---

## 12. 自我审查

- [x] 无 TBD / TODO 留空
- [x] 范围聚焦：仅 Task 11-12
- [x] 命名一致：Country / UnitSystem / FirstRunPreferences
- [x] 与 Spec A 衔接：OnboardingRepository 复用 Hive `prefs` box
- [x] 测试覆盖：5 个测试文件
- [x] 范围外明确列出

---

## 附录 A · 关联文档

- [阶段一基础设施 Spec A](file:///c:/Users/wenmo/.trae-cn/worktrees/旅游app/docs/superpowers/specs/2026-06-27-sightour-stage1-foundation-design.md)
- [前端架构规范](file:///c:/Users/wenmo/.trae-cn/worktrees/旅游app/docs/superpowers/specs/2026-06-26-sightour-frontend-architecture.md)
- [信息架构](file:///c:/Users/wenmo/.trae-cn/worktrees/旅游app/docs/superpowers/specs/2026-06-26-sightour-information-architecture.md)
- [MVP Plan](file:///c:/Users/wenmo/.trae-cn/worktrees/旅游app/docs/superpowers/plans/2026-06-26-sightour-mvp.md) Task 11-12
