# Sightour 阶段一基础设施实施计划（Stage 1 Foundation Plan）

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 在阶段零脚手架之上实现 Sightour APP 的全部基础设施层（i18n + 主题 + 存储 + 网络 + 路由），5 个 tab 显示占位文案，Mock 拦截器桩 6 个端点。无业务屏幕（阶段二/三起按 feature 接入）。

**Architecture:** Clean Architecture Lite 在基础设施层的完整实现。`core/i18n`、`core/theme`、`core/storage`、`core/network`、`core/router` 五个横切模块用 Cubit 暴露状态，用 `get_it + injectable` 注入。`app.dart` 顶层 `MultiBlocProvider` 包裹两个全局 Cubit（`LocaleCubit` + `ThemeCubit`），动态驱动 `MaterialApp.router` 的 `locale` 与 `themeMode`。Dio 拦截器链：Auth → Logging → Error → Mock → Retry（按 Architecture Spec §6.2）。go_router `ShellRoute` 包裹 5 个一级 tab + IA Spec §3.2 完整子路由（占位 Page）。Hive 8 个 box 一次性 open。所有 Mock 端点统一返回 `MockData.emptyData` 锁接口契约。

**Tech Stack:**
- intl 0.20.0 + flutter_localizations（已锁定）
- freezed 3.x + freezed_annotation（已锁定）
- dio 5.7 + injectable 3.x（已锁定）
- hive_ce 2.10 + hive_ce_flutter 2.2（已锁定）
- get_it 9.x（已锁定）
- go_router 17.x（已锁定）
- build_runner（已锁定）

**上游文档：**
- [阶段一基础设施设计 Spec](file:///c:/Users/wenmo/.trae-cn/worktrees/旅游app/docs/superpowers/specs/2026-06-27-sightour-stage1-foundation-design.md)（所有代码均来自此 spec）
- [前端架构规范](file:///c:/Users/wenmo/.trae-cn/worktrees/旅游app/docs/superpowers/specs/2026-06-26-sightour-frontend-architecture.md)
- [信息架构](file:///c:/Users/wenmo/.trae-cn/worktrees/旅游app/docs/superpowers/specs/2026-06-26-sightour-information-architecture.md)
- [设计系统](file:///c:/Users/wenmo/.trae-cn/worktrees/旅游app/docs/superpowers/specs/2026-06-26-sightour-design-system.md)

**执行顺序**（基础设施优先，避免依赖反转）：
1. Task 6：i18n（无依赖）
2. Task 7：主题（无依赖）
3. Task 10：Hive（无依赖，但 i18n 的 LocaleCubit 依赖 prefs box）
4. Task 9：Dio + Mock 拦截器（依赖 Hive 用于缓存预留）
5. Task 8：go_router 完整结构（依赖 LocaleCubit + ThemeCubit + 5 个 Page）

---

## Task 6：i18n 框架

**Files:**
- Create: `app/l10n.yaml`
- Create: `app/lib/l10n/app_en.arb`
- Create: `app/lib/l10n/app_zh.arb`
- Create: `app/lib/core/i18n/locale_cubit.dart`
- Create: `app/lib/core/i18n/locale_text_styles.dart`
- Modify: `app/pubspec.yaml`
- Modify: `app/lib/app.dart`
- Create: `app/test/i18n/locale_cubit_test.dart`
- Create: `app/test/i18n/l10n_smoke_test.dart`

> **代码全部来自 design spec §3.2/§3.3/§3.4/§3.5**。执行时按行号区间读取 spec 文件复制代码。

- [ ] **Step 6.1：写 `app/l10n.yaml`**

```yaml
arb-dir: lib/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
output-class: AppLocalizations
output-dir: lib/l10n/generated
synthetic-package: false
nullable-getter: false
```

- [ ] **Step 6.2：写 `app/lib/l10n/app_en.arb`**

20 个 key，完整内容来自 spec §3.2（已直接列出）。

- [ ] **Step 6.3：写 `app/lib/l10n/app_zh.arb`**

20 个 key 中文翻译（与英文版同结构）。中文翻译要点：
- `appTitle`: "Sightour"
- `tabPrepare`: "行前"
- `tabMap`: "地图"
- `tabDiscover`: "发现"
- `tabTools`: "工具"
- `tabYou`: "我的"
- `commonConfirm`: "确认"
- `commonCancel`: "取消"
- `commonRetry`: "重试"
- `commonError`: "出错了"
- `commonLoading`: "加载中…"
- `commonComingSoon`: "敬请期待"
- `commonOffline`: "离线模式"
- `prepareTitle`: "行前准备 · {nationality}"
- `mapTitle`: "地图"
- `mapSearchHint`: "搜索地点、地址、交通"
- `discoverTitle`: "发现上海"
- `toolsTitle`: "工具"
- `youTitle`: "我的"
- `policyVisaFree`: "30 天免签入境"
- `policyTransit`: "240 小时过境免签"

- [ ] **Step 6.4：修改 `app/pubspec.yaml`**

在 `dependencies` 段确认：
```yaml
  flutter_localizations:
    sdk: flutter
  intl: ^0.20.0
```

在 `flutter:` 段添加 `generate: true`：
```yaml
flutter:
  generate: true
  uses-material-design: true
```

- [ ] **Step 6.5：跑 `flutter gen-l10n` 生成 AppLocalizations**

```bash
cd app
flutter gen-l10n
```

预期：在 `app/lib/l10n/generated/` 生成 `app_localizations.dart` 与 `app_localizations_en.dart` / `app_localizations_zh.dart`。

- [ ] **Step 6.6：写 `app/lib/core/i18n/locale_cubit.dart`**

完整代码来自 spec §3.3。

- [ ] **Step 6.7：写 `app/lib/core/i18n/locale_text_styles.dart`**

```dart
import 'package:flutter/material.dart';

TextStyle textStyleForLocale(Locale locale, {required TextStyle base}) {
  final isZh = locale.languageCode == 'zh';
  return base.copyWith(
    fontFamily: isZh ? 'NotoSansSC' : 'Inter',
  );
}
```

- [ ] **Step 6.8：写 `app/test/i18n/locale_cubit_test.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:sightour/core/i18n/locale_cubit.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class _FakePathProvider extends PathProviderPlatform with MockPlatformInterfaceMixin {
  @override
  Future<String?> getApplicationDocumentsPath() async => '.dart_test/app_docs';
  @override
  Future<String?> getTemporaryPath() async => '.dart_test/tmp';
}

void main() {
  setUpAll(() async {
    PathProviderPlatform.instance = _FakePathProvider();
    Hive.init('.dart_test/hive_locale');
  });

  setUp(() async {
    await Hive.deleteFromDisk();
  });

  test('default locale is en', () {
    final cubit = LocaleCubit();
    expect(cubit.state, const Locale('en'));
  });

  test('setLocale persists and emits', () async {
    final cubit = LocaleCubit();
    await cubit.setLocale(const Locale('zh'));
    expect(cubit.state, const Locale('zh'));
    final box = await Hive.openBox('prefs');
    expect(box.get('locale'), 'zh');
  });

  test('loadFromStorage reads persisted locale', () async {
    final box = await Hive.openBox('prefs');
    await box.put('locale', 'zh');
    final cubit = LocaleCubit();
    await cubit.loadFromStorage();
    expect(cubit.state, const Locale('zh'));
  });
}
```

> **注意**：若 `path_provider_platform_interface` 与 `plugin_platform_interface` 不在 `dev_dependencies`，则需要在 `pubspec.yaml` 添加：
> ```yaml
> dev_dependencies:
>   path_provider_platform_interface: ^2.1.0
>   plugin_platform_interface: ^2.1.0
> ```
> 否则测试报错 `MissingPluginException`。

- [ ] **Step 6.9：写 `app/test/i18n/l10n_smoke_test.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sightour/l10n/generated/app_localizations.dart';

void main() {
  testWidgets('AppLocalizations provides all 20 keys in en', (tester) async {
    late AppLocalizations l10n;
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (ctx) {
            l10n = AppLocalizations.of(ctx)!;
            return const SizedBox.shrink();
          },
        ),
      ),
    );
    expect(l10n.appTitle, 'Sightour');
    expect(l10n.tabPrepare, 'Prepare');
    expect(l10n.tabMap, 'Map');
    expect(l10n.tabDiscover, 'Discover');
    expect(l10n.tabTools, 'Tools');
    expect(l10n.tabYou, 'You');
    expect(l10n.commonConfirm, 'Confirm');
    expect(l10n.commonCancel, 'Cancel');
    expect(l10n.commonRetry, 'Try again');
    expect(l10n.commonError, 'Something went wrong');
    expect(l10n.commonLoading, 'Loading…');
    expect(l10n.commonComingSoon, 'Coming soon');
    expect(l10n.commonOffline, "You're offline");
    expect(l10n.prepareTitle('US'), 'Prepare · US');
    expect(l10n.mapTitle, 'Map');
    expect(l10n.mapSearchHint, 'Search places, addresses, transit');
    expect(l10n.discoverTitle, 'Discover Shanghai');
    expect(l10n.toolsTitle, 'Tools');
    expect(l10n.youTitle, 'You');
    expect(l10n.policyVisaFree, '30-day visa-free entry');
    expect(l10n.policyTransit, '240-hour visa-free transit');
  });

  testWidgets('AppLocalizations provides zh translations', (tester) async {
    late AppLocalizations l10n;
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('zh'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (ctx) {
            l10n = AppLocalizations.of(ctx)!;
            return const SizedBox.shrink();
          },
        ),
      ),
    );
    expect(l10n.appTitle, 'Sightour');
    expect(l10n.tabPrepare, '行前');
    expect(l10n.commonConfirm, '确认');
    expect(l10n.prepareTitle('美国'), '行前准备 · 美国');
  });
}
```

- [ ] **Step 6.10：跑 `dart analyze`**

```bash
cd app
dart analyze
```

预期：`No issues found!`。若有错则修复。

- [ ] **Step 6.11：跑 `flutter test`**

```bash
cd app
flutter test
```

预期：所有 Task 6 的测试通过（目前阶段零 1 个 + Task 6 新增 4 个 = 5 个 passed）。

- [ ] **Step 6.12：提交**

```bash
cd c:\Users\wenmo\.trae-cn\worktrees\旅游app
git add app/
git commit -m "feat(i18n): add bilingual framework with 20 core keys"
```

预期：1 commit。

---

## Task 7：主题与设计 Token

**Files:**
- Create: `app/lib/core/theme/app_colors.dart`
- Create: `app/lib/core/theme/app_spacing.dart`
- Create: `app/lib/core/theme/app_radius.dart`
- Create: `app/lib/core/theme/app_shadow.dart`
- Create: `app/lib/core/theme/app_text_styles.dart`
- Create: `app/lib/core/theme/theme_cubit.dart`
- Modify: `app/lib/core/theme/app_theme.dart`（重写，引用上面 5 个文件）
- Modify: `app/lib/app.dart`（接入 ThemeCubit）
- Create: `app/test/theme/app_colors_test.dart`
- Create: `app/test/theme/app_theme_test.dart`
- Create: `app/test/theme/theme_cubit_test.dart`

> **代码全部来自 design spec §4**。

- [ ] **Step 7.1：写 `app/lib/core/theme/app_colors.dart`**

23 个色阶常量，完整内容来自 spec §4.1。

- [ ] **Step 7.2：写 `app/lib/core/theme/app_spacing.dart`**

完整内容来自 spec §4.1。

- [ ] **Step 7.3：写 `app/lib/core/theme/app_radius.dart`**

完整内容来自 spec §4.1。

- [ ] **Step 7.4：写 `app/lib/core/theme/app_shadow.dart`**

完整内容来自 spec §4.1。

- [ ] **Step 7.5：写 `app/lib/core/theme/app_text_styles.dart`**

15 个 textTheme 层级，完整内容来自 spec §4.1。

- [ ] **Step 7.6：写 `app/lib/core/theme/theme_cubit.dart`**

完整内容来自 spec §4.3。

- [ ] **Step 7.7：重写 `app/lib/core/theme/app_theme.dart`**

完整内容来自 spec §4.2。注意：删除阶段零的 `AppColors` 类（本文件外移至 §7.1），新文件 `import 'app_colors.dart';` 等。

- [ ] **Step 7.8：写 `app/test/theme/app_colors_test.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sightour/core/theme/app_colors.dart';

void main() {
  test('slate900 equals #1A2332', () {
    expect(AppColors.slate900.toARGB32(), 0xFF1A2332);
  });
  test('blue600 equals #2A4365', () {
    expect(AppColors.blue600.toARGB32(), 0xFF2A4365);
  });
  test('sand500 equals #D4A574', () {
    expect(AppColors.sand500.toARGB32(), 0xFFD4A574);
  });
  test('sage600 equals #5B8C5A', () {
    expect(AppColors.sage600.toARGB32(), 0xFF5B8C5A);
  });
  test('amber500 equals #D97706', () {
    expect(AppColors.amber500.toARGB32(), 0xFFD97706);
  });
  test('clay600 equals #C2410C', () {
    expect(AppColors.clay600.toARGB32(), 0xFFC2410C);
  });
  test('ivory equals #FAFAF7', () {
    expect(AppColors.ivory.toARGB32(), 0xFFFAFAF7);
  });
}
```

> 若 `Color.toARGB32()` 在用户的 Flutter 版本不可用，替换为 `Color.value` 即可（但需 import `dart:ui`）。

- [ ] **Step 7.9：写 `app/test/theme/app_theme_test.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sightour/core/theme/app_colors.dart';
import 'package:sightour/core/theme/app_theme.dart';

void main() {
  test('AppTheme.light builds', () {
    final theme = AppTheme.light();
    expect(theme.useMaterial3, true);
    expect(theme.brightness, Brightness.light);
    expect(theme.colorScheme.primary, AppColors.blue600);
  });

  test('AppTheme.dark builds', () {
    final theme = AppTheme.dark();
    expect(theme.useMaterial3, true);
    expect(theme.brightness, Brightness.dark);
  });
}
```

- [ ] **Step 7.10：写 `app/test/theme/theme_cubit_test.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:sightour/core/theme/theme_cubit.dart';

class _FakePathProvider extends PathProviderPlatform with MockPlatformInterfaceMixin {
  @override
  Future<String?> getApplicationDocumentsPath() async => '.dart_test/app_docs_theme';
}

void main() {
  setUpAll(() async {
    PathProviderPlatform.instance = _FakePathProvider();
    Hive.init('.dart_test/hive_theme');
  });

  setUp(() async {
    await Hive.deleteFromDisk();
  });

  test('default is ThemeMode.system', () {
    final cubit = ThemeCubit();
    expect(cubit.state, ThemeMode.system);
  });

  test('setMode persists and emits', () async {
    final cubit = ThemeCubit();
    await cubit.setMode(ThemeMode.dark);
    expect(cubit.state, ThemeMode.dark);
    final box = await Hive.openBox('prefs');
    expect(box.get('themeMode'), 'dark');
  });
}
```

- [ ] **Step 7.11：跑 `dart analyze` + `flutter test`**

```bash
cd app
dart analyze
flutter test
```

预期：均 0 issues。`flutter test` 新增 5 个 passed（累计 10 个）。

- [ ] **Step 7.12：提交**

```bash
cd c:\Users\wenmo\.trae-cn\worktrees\旅游app
git add app/
git commit -m "feat(theme): light/dark theme with full design tokens"
```

---

## Task 10：Hive 存储层

**Files:**
- Create: `app/lib/core/storage/hive_boxes.dart`
- Create: `app/lib/core/storage/hive_init.dart`
- Create: `app/lib/core/storage/hive_service.dart`
- Create: `app/lib/core/storage/anonymous_id.dart`
- Modify: `app/lib/main.dart`（调用 `HiveInit.init()`）
- Create: `app/test/storage/hive_service_test.dart`
- Create: `app/test/storage/anonymous_id_test.dart`

> **代码全部来自 design spec §5**。

- [ ] **Step 10.1：写 `app/lib/core/storage/hive_boxes.dart`**

```dart
class HiveBoxes {
  HiveBoxes._();
  static const prefs = 'prefs';
  static const checklist = 'checklist';
  static const offline = 'offline';
  static const poiCache = 'poi_cache';
  static const search = 'search';
  static const favorites = 'favorites';
  static const drafts = 'drafts';
  static const correctionsDraft = 'corrections_draft';
}
```

- [ ] **Step 10.2：写 `app/lib/core/storage/hive_init.dart`**

完整内容来自 spec §5.2。

- [ ] **Step 10.3：写 `app/lib/core/storage/hive_service.dart`**

完整内容来自 spec §5.3。

- [ ] **Step 10.4：写 `app/lib/core/storage/anonymous_id.dart`**

完整内容来自 spec §5.4。

- [ ] **Step 10.5：修改 `app/lib/main.dart`**

```dart
import 'package:flutter/material.dart';
import 'app.dart';
import 'core/di/injection.dart';
import 'core/storage/hive_init.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveInit.init();
  await configureDependencies();
  runApp(const SightourApp());
}
```

- [ ] **Step 10.6：写 `app/test/storage/hive_service_test.dart`**

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:sightour/core/storage/hive_boxes.dart';
import 'package:sightour/core/storage/hive_service.dart';

class _FakePathProvider extends PathProviderPlatform with MockPlatformInterfaceMixin {
  @override
  Future<String?> getApplicationDocumentsPath() async => '.dart_test/app_docs_hive';
}

void main() {
  setUpAll(() async {
    PathProviderPlatform.instance = _FakePathProvider();
    Hive.init('.dart_test/hive_service');
  });

  setUp(() async {
    await Hive.deleteFromDisk();
    await Hive.openBox(HiveBoxes.prefs);
  });

  test('read default returns null', () {
    final svc = HiveService(Hive.box(HiveBoxes.prefs));
    expect(svc.read<String>('missing'), isNull);
  });

  test('write + read roundtrip', () async {
    final svc = HiveService(Hive.box(HiveBoxes.prefs));
    await svc.write('key', 'value');
    expect(svc.read<String>('key'), 'value');
  });

  test('delete removes key', () async {
    final svc = HiveService(Hive.box(HiveBoxes.prefs));
    await svc.write('key', 'value');
    await svc.delete('key');
    expect(svc.read<String>('key'), isNull);
  });
}
```

- [ ] **Step 10.7：写 `app/test/storage/anonymous_id_test.dart`**

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:sightour/core/storage/anonymous_id.dart';
import 'package:sightour/core/storage/hive_boxes.dart';

class _FakePathProvider extends PathProviderPlatform with MockPlatformInterfaceMixin {
  @override
  Future<String?> getApplicationDocumentsPath() async => '.dart_test/app_docs_anon';
}

void main() {
  setUpAll(() async {
    PathProviderPlatform.instance = _FakePathProvider();
    Hive.init('.dart_test/hive_anon');
  });

  setUp(() async {
    await Hive.deleteFromDisk();
    await Hive.openBox(HiveBoxes.prefs);
  });

  test('first call generates anon id', () {
    final id = AnonymousId.get();
    expect(id, startsWith('anon_'));
  });

  test('second call reuses same id', () {
    final id1 = AnonymousId.get();
    final id2 = AnonymousId.get();
    expect(id1, id2);
  });
}
```

- [ ] **Step 10.8：跑 `dart analyze` + `flutter test`**

```bash
cd app
dart analyze
flutter test
```

预期：0 issues。`flutter test` 累计 15+ passed。

- [ ] **Step 10.9：提交**

```bash
cd c:\Users\wenmo\.trae-cn\worktrees\旅游app
git add app/
git commit -m "feat(storage): hive based local cache with 8 boxes"
```

---

## Task 9：Dio 网络层 + Mock 拦截器

**Files:**
- Create: `app/lib/core/network/failures.dart`
- Create: `app/lib/core/network/failures.freezed.dart`（生成）
- Create: `app/lib/core/network/mock_data.dart`
- Create: `app/lib/core/network/dio_client.dart`
- Create: `app/lib/core/network/interceptors/auth_interceptor.dart`
- Create: `app/lib/core/network/interceptors/logging_interceptor.dart`
- Create: `app/lib/core/network/interceptors/error_interceptor.dart`
- Create: `app/lib/core/network/interceptors/retry_interceptor.dart`
- Create: `app/lib/core/network/interceptors/mock_interceptor.dart`
- Create: `app/test/network/mock_interceptor_test.dart`
- Create: `app/test/network/dio_client_test.dart`

> **代码全部来自 design spec §6**。`failures.freezed.dart` 由 `dart run build_runner build` 生成，不手写。

- [ ] **Step 9.1：写 `app/lib/core/network/failures.dart`**

完整内容来自 spec §6.1。

- [ ] **Step 9.2：跑 `build_runner` 生成 `failures.freezed.dart`**

```bash
cd app
dart run build_runner build --delete-conflicting-outputs
```

预期：在 `app/lib/core/network/` 生成 `failures.freezed.dart`。

- [ ] **Step 9.3：写 `app/lib/core/network/mock_data.dart`**

完整内容来自 spec §6.5。

- [ ] **Step 9.4：写 5 个 interceptor**

每个完整内容来自 spec §6.3：
- `auth_interceptor.dart`：注入 `X-Anonymous-Id`
- `logging_interceptor.dart`：dev only
- `error_interceptor.dart`：DioException → Failure
- `retry_interceptor.dart`：网络错误自动重试 3 次
- `mock_interceptor.dart`：spec §6.4 完整代码

- [ ] **Step 9.5：写 `app/lib/core/network/dio_client.dart`**

完整内容来自 spec §6.2。

- [ ] **Step 9.6：写 `app/test/network/mock_interceptor_test.dart`**

```dart
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sightour/core/network/interceptors/mock_interceptor.dart';
import 'package:sightour/core/network/mock_data.dart';

void main() {
  late MockInterceptor mockInterceptor;
  late Dio dio;

  setUp(() {
    mockInterceptor = MockInterceptor();
    dio = Dio(BaseOptions(baseUrl: 'https://test.local'));
    dio.interceptors.add(mockInterceptor);
  });

  test('hits /policies and returns emptyData', () async {
    final res = await dio.get<dynamic>('/policies');
    expect(res.statusCode, 200);
    expect(res.data, MockData.emptyData);
  });

  test('hits /pois/search and returns emptyData', () async {
    final res = await dio.get<dynamic>('/pois/search');
    expect(res.data, MockData.emptyData);
  });

  test('hits POST /corrections and returns emptyData', () async {
    final res = await dio.post<dynamic>('/corrections', data: {});
    expect(res.data, MockData.emptyData);
  });

  test('unmatched path passes through', () async {
    mockInterceptor.simulateOffline = false;
    // /not-a-real-endpoint will not match and will be passed to next interceptor
    // which doesn't exist, so it'll be the network call itself.
    // We can't easily test the real network in a test, but we can check
    // that the interceptor does NOT short-circuit.
    final requestOptions = RequestOptions(path: '/not-real');
    final handler = _FakeHandler();
    await mockInterceptor.onRequest(requestOptions, handler);
    expect(handler.nextCalled, true);
  });

  test('simulateOffline rejects with connectionError', () async {
    mockInterceptor.simulateOffline = true;
    Object? caught;
    try {
      await dio.get<dynamic>('/policies');
    } catch (e) {
      caught = e;
    }
    expect(caught, isA<DioException>());
    expect((caught as DioException).type, DioExceptionType.connectionError);
  });
}

class _FakeHandler extends RequestInterceptorHandler {
  bool nextCalled = false;
  @override
  void next(RequestOptions requestOptions) {
    nextCalled = true;
    super.next(requestOptions);
  }
}
```

- [ ] **Step 9.7：写 `app/test/network/dio_client_test.dart`**

```dart
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sightour/core/network/dio_client.dart';
import 'package:sightour/core/network/interceptors/auth_interceptor.dart';
import 'package:sightour/core/network/interceptors/error_interceptor.dart';
import 'package:sightour/core/network/interceptors/logging_interceptor.dart';
import 'package:sightour/core/network/interceptors/mock_interceptor.dart';
import 'package:sightour/core/network/interceptors/retry_interceptor.dart';

void main() {
  test('DioClient has 5 interceptors in correct order', () {
    final client = DioClient(
      AuthInterceptor(),
      LoggingInterceptor(),
      ErrorInterceptor(),
      MockInterceptor(),
      RetryInterceptor(),
    );
    expect(client.dio.interceptors.length, 5);
  });
}
```

- [ ] **Step 9.8：跑 `dart analyze` + `flutter test`**

```bash
cd app
dart analyze
flutter test
```

预期：0 issues。`flutter test` 累计 18+ passed。

- [ ] **Step 9.9：提交**

```bash
cd c:\Users\wenmo\.trae-cn\worktrees\旅游app
git add app/
git commit -m "feat(network): dio with 5 interceptors and 8 mock endpoints"
```

---

## Task 8：go_router 完整结构 + 5 Tab Page 占位

**Files:**
- Create: `app/lib/core/router/route_names.dart`
- Create: `app/lib/core/router/route_guards.dart`
- Modify: `app/lib/core/router/app_router.dart`（完整重写）
- Create: `app/lib/core/router/main_shell.dart`
- Create: `app/lib/shared/pages/coming_soon_page.dart`
- Create: `app/lib/shared/pages/not_found_page.dart`
- Create: `app/lib/features/prepare/presentation/pages/prepare_page.dart`
- Create: `app/lib/features/map/presentation/pages/map_page.dart`
- Create: `app/lib/features/discover/presentation/pages/discover_page.dart`
- Create: `app/lib/features/tools/presentation/pages/tools_page.dart`
- Create: `app/lib/features/you/presentation/pages/you_page.dart`
- Delete: `app/lib/features/onboarding/presentation/pages/home_page.dart`（不再使用）
- Modify: `app/lib/app.dart`（接入 LocaleCubit + ThemeCubit；上一步未做则在此做）
- Create: `app/test/router/app_router_test.dart`
- Modify: `app/test/widget_test.dart`（更新以验证 5 tab 启动）

> **代码全部来自 design spec §7**。

- [ ] **Step 8.1：写 `app/lib/core/router/route_names.dart`**

完整内容来自 spec §7.1。

- [ ] **Step 8.2：写 `app/lib/core/router/route_guards.dart`**

完整内容来自 spec §7.6。

- [ ] **Step 8.3：写 `app/lib/shared/pages/coming_soon_page.dart`**

完整内容来自 spec §7.4。

- [ ] **Step 8.4：写 `app/lib/shared/pages/not_found_page.dart`**

完整内容来自 spec §7.4。

- [ ] **Step 8.5：写 5 个 Tab Page**

每个都按 spec §7.5 模式：
- `prepare_page.dart` → `AppLocalizations.of(context)!.prepareTitle('US')`
- `map_page.dart` → `AppLocalizations.of(context)!.mapTitle`
- `discover_page.dart` → `AppLocalizations.of(context)!.discoverTitle`
- `tools_page.dart` → `AppLocalizations.of(context)!.toolsTitle`
- `you_page.dart` → `AppLocalizations.of(context)!.youTitle`

每个都是 `class XxxPage extends StatelessWidget { ... return ComingSoonPage(title: ...); }`。

- [ ] **Step 8.6：写 `app/lib/core/router/main_shell.dart`**

完整内容来自 spec §7.3。

- [ ] **Step 8.7：重写 `app/lib/core/router/app_router.dart`**

完整内容来自 spec §7.2（路由表覆盖 IA Spec §3.2 完整结构）。

- [ ] **Step 8.8：删除 `app/lib/features/onboarding/presentation/pages/home_page.dart`**

```bash
cd app
Remove-Item lib/features/onboarding/presentation/pages/home_page.dart
```

> `features/onboarding/` 整个目录在阶段二/三 B Spec 才有内容，阶段一 A 不再使用，删除 home_page.dart。`onboarding/` 目录本身保留（避免 `features/onboarding/` 整个消失）。

- [ ] **Step 8.9：重写 `app/lib/app.dart`**

完整内容来自 spec §3.5（`SightourApp` 包裹 `MultiBlocProvider` + 两个 `BlocBuilder`）。

- [ ] **Step 8.10：写 `app/test/router/app_router_test.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:sightour/core/router/app_router.dart';
import 'package:sightour/core/router/route_names.dart';

void main() {
  group('appRouter', () {
    test('initial location is /prepare', () {
      expect(appRouter.routerDelegate.currentConfiguration.uri.path, '/prepare');
    });

    test('all 5 tab paths are registered', () {
      final names = appRouter.configuration.routes
          .whereType<ShellRoute>()
          .expand((shell) => shell.routes)
          .map((r) => r.name)
          .toList();
      expect(names, contains(RouteNames.prepare));
      expect(names, contains(RouteNames.map));
      expect(names, contains(RouteNames.discover));
      expect(names, contains(RouteNames.tools));
      expect(names, contains(RouteNames.you));
    });
  });
}
```

- [ ] **Step 8.11：更新 `app/test/widget_test.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sightour/app.dart';

void main() {
  testWidgets('SightourApp launches with Prepare tab and Coming Soon content',
      (tester) async {
    await tester.pumpWidget(const SightourApp());
    await tester.pump();
    // Prepare title from AppLocalizations
    expect(find.text('Prepare · US'), findsOneWidget);
    // Coming soon body
    expect(find.text('Coming soon'), findsOneWidget);
    // Bottom nav with 5 tabs
    expect(find.byType(BottomNavigationBar), findsOneWidget);
  });
}
```

- [ ] **Step 8.12：跑 `dart analyze` + `flutter test`**

```bash
cd app
dart analyze
flutter test
```

预期：0 issues。`flutter test` 累计 20+ passed。

- [ ] **Step 8.13：提交**

```bash
cd c:\Users\wenmo\.trae-cn\worktrees\旅游app
git add app/
git commit -m "feat(router): go_router with 5 main tabs and full sub-routes"
```

---

## 最终验收

| # | 命令 | 期望 |
| :--- | :--- | :--- |
| 1 | `cd app && flutter pub get` | 成功 |
| 2 | `cd app && dart analyze` | `No issues found!` |
| 3 | `cd app && flutter test` | 20+ passed |
| 4 | `git log --oneline \| head -10` | 12 commits（spec/plan/Task1-5 + 5 Task 6-10） |
| 5 | `flutter test --coverage` | lcov.info 生成 |

**手动验证**（非测试，但需要确认）：
- [ ] 启动 App → Prepare tab 显示「Prepare · US」标题 + 「Coming soon」正文 + 5 tab 底栏
- [ ] 点 Map tab → 标题变「Map」
- [ ] 点 You tab → 标题变「You」
- [ ] 切到深链 `/map/poi/123` → 显示「POI · 123」+ Coming soon
- [ ] 切到不存在路径 `/xyz` → 显示 NotFoundPage
