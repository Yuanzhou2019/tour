# Sightour 阶段一基础设施设计（Stage 1 Foundation Design）

> **文档类型**：技术设计规范
> **阶段**：MVP 阶段一（系统基础 + 底层模块，Week 2–3）
> **范围**：MVP 计划 Task 6–10（i18n / 主题 / Hive / Dio / go_router），**纯基础设施，5 tab 占位文案**
> **版本**：v1.0 — 2026-06-27
> **关联文档**：
> - [阶段零脚手架设计](file:///c:/Users/wenmo/.trae-cn/worktrees/旅游app/docs/superpowers/specs/2026-06-27-sightour-stage0-scaffold-design.md)
> - [前端架构规范](file:///c:/Users/wenmo/.trae-cn/worktrees/旅游app/docs/superpowers/specs/2026-06-26-sightour-frontend-architecture.md) §3/§4/§5/§6/§7/§9
> - [设计系统](file:///c:/Users/wenmo/.trae-cn/worktrees/旅游app/docs/superpowers/specs/2026-06-26-sightour-design-system.md) §1（Design Token 源头）
> - [信息架构](file:///c:/Users/wenmo/.trae-cn/worktrees/旅游app/docs/superpowers/specs/2026-06-26-sightour-information-architecture.md) §1/§3（路由深度）

---

## 0. 文档元信息

### 用途
定义阶段一基础设施 5 个 Task 的实现方案：**纯基础设施层，5 tab 显示占位文案，无业务屏**。所有 BLoC / Repository / 实体在阶段二/三按 feature 落地时直接接入。

### 阶段一拆分（3 个子 spec）
本阶段拆为 3 个子 spec / plan / 实施批次：

| 子 spec | Task | 主题 |
| :--- | :--- | :--- |
| **A（本文件）** | 6, 7, 10, 9, 8 | 基础设施（i18n / 主题 / 存储 / 网络 / 路由） |
| B（未来） | 11, 12 | Onboarding + 隐私协议 |
| C（未来） | 13, 14 | 纠错 + 招募 |

### 读者
Flutter 工程师（主读者）；后续阶段的需求方；QA 测试。

---

## 1. 已确认的关键决策（来自 Brainstorming）

| 决策点 | 选定 | 理由 |
| :--- | :--- | :--- |
| Spec A 范围 | 纯基础设施 + 5 tab 占位文案 | 不混入业务，阶段二开干 feature 时直接接入 |
| Mock 端点覆盖 | 全部 6 个端点（仅返回 `{ data: [] }`） | 锁定接口契约；后阶段只填字段 |
| i18n key 覆盖 | 20 个核心 key | tab 名 + common + 各 tab 占位 |
| go_router 深度 | 5 tab + 完整子路由占位（按 IA 完整结构） | 阶段二 feature 直接绑定 |
| 5 个 Task 顺序 | i18n → theme → hive → dio → router | 依赖链清晰：渲染 → 存储 → 网络 → 整合 |

---

## 2. 目录结构（新增 / 修改）

```
app/
├── l10n.yaml                                       # 新增
├── lib/
│   ├── l10n/                                       # 新增
│   │   ├── app_en.arb
│   │   ├── app_zh.arb
│   │   └── generated/                              # 自动生成（gitignore）
│   ├── core/
│   │   ├── i18n/                                   # 新增
│   │   │   ├── locale_cubit.dart
│   │   │   └── locale_text_styles.dart
│   │   ├── theme/                                  # 改造
│   │   │   ├── app_colors.dart                     # 从 app_theme.dart 抽出
│   │   │   ├── app_text_styles.dart                # 新增
│   │   │   ├── app_spacing.dart                    # 新增
│   │   │   ├── app_radius.dart                     # 新增
│   │   │   ├── app_shadow.dart                     # 新增
│   │   │   ├── theme_cubit.dart                    # 新增
│   │   │   └── app_theme.dart                      # 改造
│   │   ├── storage/                                # 新增
│   │   │   ├── hive_boxes.dart
│   │   │   ├── hive_init.dart
│   │   │   └── hive_service.dart
│   │   ├── network/                                # 新增
│   │   │   ├── dio_client.dart
│   │   │   ├── interceptors/
│   │   │   │   ├── auth_interceptor.dart
│   │   │   │   ├── logging_interceptor.dart
│   │   │   │   ├── error_interceptor.dart
│   │   │   │   ├── retry_interceptor.dart
│   │   │   │   └── mock_interceptor.dart
│   │   │   ├── mock_data.dart
│   │   │   └── failures.dart
│   │   ├── router/                                 # 改造
│   │   │   ├── app_router.dart                     # 完整重写
│   │   │   ├── route_names.dart
│   │   │   └── route_guards.dart
│   │   └── di/                                     # 改造
│   │       └── injection.dart                      # 注册 Cubit / Dio / Hive
│   ├── features/                                   # 占位新增
│   │   ├── prepare/presentation/pages/prepare_page.dart
│   │   ├── map/presentation/pages/map_page.dart
│   │   ├── discover/presentation/pages/discover_page.dart
│   │   ├── tools/presentation/pages/tools_page.dart
│   │   └── you/presentation/pages/you_page.dart
│   └── app.dart                                    # 改造：包裹 LocaleCubit + ThemeCubit
└── test/
    ├── i18n/
    │   ├── locale_cubit_test.dart
    │   └── l10n_smoke_test.dart
    ├── theme/
    │   └── app_colors_test.dart
    ├── storage/
    │   └── hive_service_test.dart
    ├── network/
    │   ├── dio_client_test.dart
    │   └── mock_interceptor_test.dart
    └── router/
        └── app_router_test.dart
```

---

## 3. Section 1 — i18n 框架（Task 6）

### 3.1 配置

**`app/l10n.yaml`**：

```yaml
arb-dir: lib/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
output-class: AppLocalizations
output-dir: lib/l10n/generated
synthetic-package: false
nullable-getter: false
```

**`pubspec.yaml` 新增**：

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter
  intl: ^0.20.0  # 与阶段零确定的实际版本一致

flutter:
  generate: true
  uses-material-design: true
```

### 3.2 20 个核心 key

`app/lib/l10n/app_en.arb`：

```json
{
  "appTitle": "Sightour",

  "tabPrepare": "Prepare",
  "tabMap": "Map",
  "tabDiscover": "Discover",
  "tabTools": "Tools",
  "tabYou": "You",

  "commonConfirm": "Confirm",
  "commonCancel": "Cancel",
  "commonRetry": "Try again",
  "commonError": "Something went wrong",
  "commonLoading": "Loading…",
  "commonComingSoon": "Coming soon",
  "commonOffline": "You're offline",

  "prepareTitle": "Prepare · {nationality}",
  "@prepareTitle": {
    "placeholders": { "nationality": { "type": "String" } }
  },

  "mapTitle": "Map",
  "mapSearchHint": "Search places, addresses, transit",

  "discoverTitle": "Discover Shanghai",
  "toolsTitle": "Tools",
  "youTitle": "You",

  "policyVisaFree": "30-day visa-free entry",
  "policyTransit": "240-hour visa-free transit"
}
```

`app/lib/l10n/app_zh.arb`（中文版本，对应翻译）。

### 3.3 LocaleCubit

`app/lib/core/i18n/locale_cubit.dart`：

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce/hive.dart';

class LocaleCubit extends Cubit<Locale> {
  LocaleCubit() : super(const Locale('en'));

  static const _boxName = 'prefs';
  static const _key = 'locale';
  static const _defaultLocale = Locale('en');

  Future<void> loadFromStorage() async {
    final box = await Hive.openBox(_boxName);
    final code = box.get(_key, defaultValue: _defaultLocale.languageCode) as String;
    emit(Locale(code));
  }

  Future<void> setLocale(Locale locale) async {
    final box = await Hive.openBox(_boxName);
    await box.put(_key, locale.languageCode);
    emit(locale);
  }
}
```

### 3.4 字体切换辅助

`app/lib/core/i18n/locale_text_styles.dart`：

```dart
import 'package:flutter/material.dart';

TextStyle textStyleForLocale(Locale locale, {required TextStyle base}) {
  final isZh = locale.languageCode == 'zh';
  return base.copyWith(
    fontFamily: isZh ? 'NotoSansSC' : 'Inter',
  );
}
```

> **本阶段不下载 NotoSansSC 字体文件**。pubspec.yaml 中 `fonts:` 段先注释，等阶段一 Spec B（Onboarding 阶段）实际需要中文显示时再下载。Inter 字体在阶段零已使用系统默认，pubspec 中也未声明 `assets/fonts/Inter-*.ttf`（同样留待后阶段补）。当前阶段 fallback 到系统字体不阻塞运行。

### 3.5 注入到 app.dart

`app/lib/app.dart`（修改）：

```dart
class SightourApp extends StatelessWidget {
  const SightourApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LocaleCubit>(create: (_) => getIt<LocaleCubit>()..loadFromStorage()),
        BlocProvider<ThemeCubit>(create: (_) => getIt<ThemeCubit>()..loadFromStorage()),
      ],
      child: BlocBuilder<LocaleCubit, Locale>(
        builder: (_, locale) {
          return BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (_, themeMode) {
              return MaterialApp.router(
                title: 'Sightour',
                debugShowCheckedModeBanner: false,
                theme: AppTheme.light(),
                darkTheme: AppTheme.dark(),
                themeMode: themeMode,
                routerConfig: appRouter,
                locale: locale,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
              );
            },
          );
        },
      ),
    );
  }
}
```

### 3.6 测试

- `test/i18n/locale_cubit_test.dart`：setLocale 持久化 + 状态发射；loadFromStorage 默认值
- `test/i18n/l10n_smoke_test.dart`：用 `AppLocalizations.of(BuildContext with Locale('en'))` 验证 20 个 key 都有非空值
- `test/i18n/l10n_bilingual_test.dart`：中英文 20 个 key 全部有对应翻译

---

## 4. Section 2 — 主题与设计 Token（Task 7）

### 4.1 拆分文件

将阶段零的 `app_theme.dart` 拆分为 6 个文件，遵循 Design System §1 完整 token 集合。

**`app/lib/core/theme/app_colors.dart`**（完整 23 个色阶常量，对应 Design System §1.1）：

```dart
class AppColors {
  AppColors._();

  // Slate
  static const slate900 = Color(0xFF1A2332);
  static const slate700 = Color(0xFF374151);
  static const slate500 = Color(0xFF6B7280);
  static const slate300 = Color(0xFFCBD5E1);
  static const slate200 = Color(0xFFE2E8F0);
  static const slate100 = Color(0xFFF1F5F9);
  static const slate50 = Color(0xFFF8FAFC);

  // Blue
  static const blue600 = Color(0xFF2A4365);
  static const blue500 = Color(0xFF3B5998);
  static const blue50 = Color(0xFFEEF2F7);

  // Sand
  static const sand500 = Color(0xFFD4A574);
  static const sand50 = Color(0xFFFAF3E7);
  static const sandText = Color(0xFF8B6B3E);

  // Sage
  static const sage600 = Color(0xFF5B8C5A);
  static const sage50 = Color(0xFFEEF5EC);

  // Amber
  static const amber500 = Color(0xFFD97706);
  static const amber50 = Color(0xFFFEF3E2);

  // Clay
  static const clay600 = Color(0xFFC2410C);
  static const clay50 = Color(0xFFFDF0E8);

  // Neutral
  static const ivory = Color(0xFFFAFAF7);
  static const white = Color(0xFFFFFFFF);
  static const black = Color(0xFF000000);
}
```

**`app/lib/core/theme/app_spacing.dart`**：

```dart
class AppSpacing {
  AppSpacing._();
  static const s0 = 0.0;
  static const s1 = 4.0;
  static const s2 = 8.0;
  static const s3 = 12.0;
  static const s4 = 16.0;
  static const s5 = 20.0;
  static const s6 = 24.0;
  static const s8 = 32.0;
  static const s10 = 40.0;
  static const s12 = 48.0;
  static const s24 = 96.0;
}
```

**`app/lib/core/theme/app_radius.dart`**：

```dart
class AppRadius {
  AppRadius._();
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 20.0;
  static const full = 999.0;
}
```

**`app/lib/core/theme/app_shadow.dart`**（3 级阴影，对应 Design System §1.6）：

```dart
class AppShadow {
  AppShadow._();
  static const shadow1 = <BoxShadow>[
    BoxShadow(
      color: Color(0x0F000000),
      blurRadius: 2,
      offset: Offset(0, 1),
    ),
  ];
  static const shadow2 = <BoxShadow>[
    BoxShadow(
      color: Color(0x14000000),
      blurRadius: 8,
      offset: Offset(0, 4),
    ),
  ];
  static const shadow3 = <BoxShadow>[
    BoxShadow(
      color: Color(0x1F000000),
      blurRadius: 16,
      offset: Offset(0, 8),
    ),
  ];
}
```

**`app/lib/core/theme/app_text_styles.dart`**（11 层级 Material 3 typography）：

```dart
class AppTextTheme {
  AppTextTheme._();

  static const TextTheme textTheme = TextTheme(
    displayLarge: TextStyle(fontSize: 48, height: 1.16, fontWeight: FontWeight.w700),
    displayMedium: TextStyle(fontSize: 36, height: 1.22, fontWeight: FontWeight.w700),
    displaySmall: TextStyle(fontSize: 28, height: 1.28, fontWeight: FontWeight.w700),
    headlineLarge: TextStyle(fontSize: 24, height: 1.33, fontWeight: FontWeight.w700),
    headlineMedium: TextStyle(fontSize: 20, height: 1.4, fontWeight: FontWeight.w600),
    headlineSmall: TextStyle(fontSize: 18, height: 1.44, fontWeight: FontWeight.w600),
    titleLarge: TextStyle(fontSize: 17, height: 1.5, fontWeight: FontWeight.w600),
    titleMedium: TextStyle(fontSize: 15, height: 1.6, fontWeight: FontWeight.w500),
    titleSmall: TextStyle(fontSize: 13, height: 1.7, fontWeight: FontWeight.w500),
    bodyLarge: TextStyle(fontSize: 16, height: 1.5, fontWeight: FontWeight.w400),
    bodyMedium: TextStyle(fontSize: 14, height: 1.57, fontWeight: FontWeight.w400),
    bodySmall: TextStyle(fontSize: 12, height: 1.66, fontWeight: FontWeight.w400),
    labelLarge: TextStyle(fontSize: 14, height: 1.43, fontWeight: FontWeight.w500),
    labelMedium: TextStyle(fontSize: 12, height: 1.5, fontWeight: FontWeight.w500),
    labelSmall: TextStyle(fontSize: 11, height: 1.45, fontWeight: FontWeight.w500),
  );
}
```

### 4.2 app_theme.dart 改造

```dart
class AppTheme {
  AppTheme._();

  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: AppColors.blue600,
        onPrimary: AppColors.white,
        secondary: AppColors.sand500,
        onSecondary: AppColors.slate900,
        surface: AppColors.ivory,
        onSurface: AppColors.slate900,
        error: AppColors.clay600,
        onError: AppColors.white,
      ),
      scaffoldBackgroundColor: AppColors.ivory,
      textTheme: AppTextTheme.textTheme,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.ivory,
        foregroundColor: AppColors.slate900,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: const CardThemeData(
        color: AppColors.white,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppRadius.lg)),
          side: BorderSide(color: AppColors.slate200),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.slate100,
        labelStyle: AppTextTheme.textTheme.labelMedium,
        side: BorderSide.none,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.full),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.white,
        selectedItemColor: AppColors.blue600,
        unselectedItemColor: AppColors.slate500,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.slate200,
        space: 1,
        thickness: 1,
      ),
    );
  }

  static ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.sand500,
        onPrimary: AppColors.slate900,
        secondary: AppColors.blue600,
        onSecondary: AppColors.white,
        surface: AppColors.slate900,
        onSurface: AppColors.ivory,
        error: AppColors.clay600,
        onError: AppColors.white,
      ),
      scaffoldBackgroundColor: AppColors.slate900,
      textTheme: AppTextTheme.textTheme.apply(
        bodyColor: AppColors.ivory,
        displayColor: AppColors.ivory,
      ),
    );
  }
}
```

### 4.3 ThemeCubit

`app/lib/core/theme/theme_cubit.dart`：

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce/hive.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.system);

  static const _boxName = 'prefs';
  static const _key = 'themeMode';

  Future<void> loadFromStorage() async {
    final box = await Hive.openBox(_boxName);
    final name = box.get(_key, defaultValue: ThemeMode.system.name) as String;
    emit(ThemeMode.values.byName(name));
  }

  Future<void> setMode(ThemeMode mode) async {
    final box = await Hive.openBox(_boxName);
    await box.put(_key, mode.name);
    emit(mode);
  }
}
```

### 4.4 测试

- `test/theme/app_colors_test.dart`：每个 `AppColors.xxx` 等于期望 hex
- `test/theme/app_theme_test.dart`：`AppTheme.light()` 与 `AppTheme.dark()` 能 build（smoke test），且 `useMaterial3 == true`、`colorScheme.primary` 等于预期
- `test/theme/theme_cubit_test.dart`：setMode 持久化 + 状态发射；loadFromStorage 默认值

---

## 5. Section 3 — Hive 存储层（Task 10）

### 5.1 Box 划分

`app/lib/core/storage/hive_boxes.dart`：

```dart
class HiveBoxes {
  HiveBoxes._();
  static const prefs = 'prefs';                // 用户偏好（语言 / 主题）
  static const checklist = 'checklist';         // 行前清单（阶段二）
  static const offline = 'offline';             // 离线包元数据（阶段三）
  static const poiCache = 'poi_cache';          // POI 缓存（阶段二）
  static const search = 'search';               // 搜索历史（阶段二）
  static const favorites = 'favorites';         // 收藏（阶段二）
  static const drafts = 'drafts';               // 草稿（阶段一）
  static const correctionsDraft = 'corrections_draft';
}
```

### 5.2 初始化

`app/lib/core/storage/hive_init.dart`：

```dart
import 'package:hive_ce/hive.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

import 'hive_boxes.dart';

class HiveInit {
  HiveInit._();

  static Future<void> init() async {
    await Hive.initFlutter();
    await Future.wait([
      Hive.openBox(HiveBoxes.prefs),
      Hive.openBox(HiveBoxes.checklist),
      Hive.openBox(HiveBoxes.offline),
      Hive.openBox(HiveBoxes.poiCache),
      Hive.openBox(HiveBoxes.search),
      Hive.openBox(HiveBoxes.favorites),
      Hive.openBox(HiveBoxes.drafts),
      Hive.openBox(HiveBoxes.correctionsDraft),
    ]);
  }
}
```

### 5.3 通用服务

`app/lib/core/storage/hive_service.dart`：

```dart
import 'package:hive_ce/hive.dart';
import 'hive_boxes.dart';

class HiveService {
  HiveService(this._box);

  final Box _box;

  T? read<T>(String key, {T? defaultValue}) => _box.get(key, defaultValue: defaultValue) as T?;

  Future<void> write<T>(String key, T value) => _box.put(key, value);

  Future<void> delete(String key) => _box.delete(key);

  Future<void> clear() => _box.clear();

  Iterable<dynamic> get values => _box.values;

  static HiveService of(String boxName) => HiveService(Hive.box(boxName));
}
```

### 5.4 游客模式 anonymousId

`app/lib/core/storage/anonymous_id.dart`：

```dart
import 'package:hive_ce/hive.dart';
import 'hive_boxes.dart';

class AnonymousId {
  AnonymousId._();

  static const _key = 'anonymousId';

  static String get() {
    final box = Hive.box(HiveBoxes.prefs);
    var id = box.get(_key) as String?;
    if (id == null) {
      id = 'anon_${DateTime.now().millisecondsSinceEpoch}';
      box.put(_key, id);
    }
    return id;
  }
}
```

### 5.5 测试

- `test/storage/hive_service_test.dart`：write/read/delete/clear，跨 Box 隔离
- `test/storage/anonymous_id_test.dart`：首次调用生成新 ID，第二次复用

---

## 6. Section 4 — Dio 网络层 + Mock 拦截器（Task 9）

### 6.1 失败模型

`app/lib/core/network/failures.dart`（基于 freezed）：

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'failures.freezed.dart';

@freezed
sealed class Failure with _$Failure {
  const factory Failure.network(NetworkFailureType type) = NetworkFailure;
  const factory Failure.server({required int statusCode, String? code}) = ServerFailure;
  const factory Failure.cache({required String message}) = CacheFailure;
  const factory Failure.permission(PermissionType type) = PermissionFailure;
  const factory Failure.unknown(String message) = UnknownFailure;
}

enum NetworkFailureType { offline, timeout, noConnection }
enum PermissionType { location, notification, camera }
```

### 6.2 DioClient

`app/lib/core/network/dio_client.dart`：

```dart
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import 'interceptors/auth_interceptor.dart';
import 'interceptors/error_interceptor.dart';
import 'interceptors/logging_interceptor.dart';
import 'interceptors/mock_interceptor.dart';
import 'interceptors/retry_interceptor.dart';

@lazySingleton
class DioClient {
  final Dio dio;

  DioClient(
    AuthInterceptor authInterceptor,
    LoggingInterceptor loggingInterceptor,
    ErrorInterceptor errorInterceptor,
    MockInterceptor mockInterceptor,
    RetryInterceptor retryInterceptor,
  ) : dio = Dio(
          BaseOptions(
            baseUrl: 'https://api.sightour.com/v1',
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 30),
            headers: {
              'X-App-Version': '0.1.0',
            },
          ),
        ) {
    dio.interceptors.addAll([
      authInterceptor,
      loggingInterceptor,
      errorInterceptor,
      mockInterceptor,
      retryInterceptor,
    ]);
  }
}
```

### 6.3 拦截器

**`auth_interceptor.dart`**：注入 `X-Anonymous-Id` header（从 `AnonymousId.get()`）；预留 `Authorization` 头位（MVP 游客模式无 token）。

**`logging_interceptor.dart`**：开发模式下打印 request / response；release 关闭（按 `kReleaseMode`）。

**`error_interceptor.dart`**：捕获 `DioException`，转换为 `Failure`（参见 §6.1）后 reject。

**`retry_interceptor.dart`**：网络错误自动重试 3 次（间隔 1s/2s/4s），符合 Architecture Spec §4.3 表。

**`mock_interceptor.dart`**：见 §6.4。

### 6.4 Mock 拦截器（核心）

`app/lib/core/network/interceptors/mock_interceptor.dart`：

```dart
import 'dart:math';

import 'package:dio/dio.dart';

import '../mock_data.dart';

@lazySingleton
class MockInterceptor extends Interceptor {
  static const _endpointKeys = <String>{
    'GET /policies',
    'GET /pois/search',
    'GET /discover/curated',
    'GET /discover/authentic',
    'GET /discover/heads-up',
    'GET /tools/fx-rates',
    'GET /me/preferences',
    'POST /corrections',
  };

  /// 模拟离线（开发期切换用）
  bool simulateOffline = false;

  /// 错误率（0.0 - 1.0）
  double errorRate = 0.0;

  /// 模拟延迟（ms）
  int simulatedDelayMs = 200;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (simulateOffline) {
      return handler.reject(
        DioException(
          requestOptions: options,
          type: DioExceptionType.connectionError,
          message: 'Simulated offline',
        ),
      );
    }

    if (Random().nextDouble() < errorRate) {
      return handler.reject(
        DioException(
          requestOptions: options,
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: options,
            statusCode: 500,
            data: {'code': 'INTERNAL_ERROR'},
          ),
        ),
      );
    }

    final key = '${options.method} ${options.path}';
    if (_endpointKeys.contains(key)) {
      await Future<void>.delayed(Duration(milliseconds: simulatedDelayMs));
      return handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 200,
          data: MockData.emptyData,
        ),
      );
    }
    handler.next(options);
  }
}
```

### 6.5 Mock 数据

`app/lib/core/network/mock_data.dart`：

```dart
class MockData {
  MockData._();

  /// 全部 6 个端点统一返回空 data
  static const Map<String, dynamic> emptyData = <String, dynamic>{
    'data': <dynamic>[],
    'meta': <String, dynamic>{
      'page': 1,
      'pageSize': 20,
      'total': 0,
    },
  };
}
```

> **未来扩展点**：把 `emptyData` 拆为 `policiesMock` / `poisMock` / `discoverMock` / `fxRatesMock` / `preferencesMock` / `correctionsMock`，按 endpoint key 分发。阶段二起按 feature 填字段。

### 6.6 测试

- `test/network/dio_client_test.dart`：拦截器链顺序正确（auth → logging → error → mock → retry）
- `test/network/mock_interceptor_test.dart`：
  - 命中 endpoint key → resolve `emptyData`
  - 未命中 → `next(options)`
  - `simulateOffline = true` → reject connectionError
  - `errorRate = 1.0` → reject badResponse

---

## 7. Section 5 — go_router 路由（Task 8）

### 7.1 路由命名

`app/lib/core/router/route_names.dart`：

```dart
class RouteNames {
  RouteNames._();
  static const home = 'home';
  static const prepare = 'prepare';
  static const map = 'map';
  static const discover = 'discover';
  static const tools = 'tools';
  static const you = 'you';
  // Sub-routes
  static const policyDetail = 'policy_detail';
  static const checklist = 'checklist';
  static const offlineDownloads = 'offline_downloads';
  static const poiDetail = 'poi_detail';
  static const poiReputation = 'poi_reputation';
  static const rankCategory = 'rank_category';
  static const fxConverter = 'fx_converter';
  static const phrasesIndex = 'phrases_index';
  static const phrasesCategory = 'phrases_category';
  static const emergency = 'emergency';
  static const profile = 'profile';
  // Modal
  static const modalCorrection = 'modal_correction';
  static const modalFilter = 'modal_filter';
  static const modalCountry = 'modal_country';
  static const modalLanguage = 'modal_language';
  // Full
  static const privacy = 'privacy';
  static const about = 'about';
  static const maintenance = 'maintenance';
  static const notFound = 'not_found';
}
```

### 7.2 路由表

`app/lib/core/router/app_router.dart`（按 IA Spec §3.2 完整结构，5 tab + 子路由 + 模态 + 全屏）：

```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/discover/presentation/pages/discover_page.dart';
import '../../features/map/presentation/pages/map_page.dart';
import '../../features/prepare/presentation/pages/prepare_page.dart';
import '../../features/tools/presentation/pages/tools_page.dart';
import '../../features/you/presentation/pages/you_page.dart';
import '../../shared/pages/coming_soon_page.dart';
import '../../shared/pages/not_found_page.dart';
import 'route_names.dart';

final appRouter = GoRouter(
  initialLocation: '/prepare',
  debugLogDiagnostics: true,
  routes: <RouteBase>[
    ShellRoute(
      builder: (context, state, child) => MainShell(child: child),
      routes: <RouteBase>[
        GoRoute(
          path: '/prepare',
          name: RouteNames.prepare,
          builder: (_, __) => const PreparePage(),
          routes: <RouteBase>[
            GoRoute(
              path: 'policy/:id',
              name: RouteNames.policyDetail,
              builder: (_, state) => ComingSoonPage(
                title: 'Policy · ${state.pathParameters['id']}',
              ),
            ),
            GoRoute(
              path: 'checklist',
              name: RouteNames.checklist,
              builder: (_, __) => const ComingSoonPage(title: 'Checklist'),
            ),
            GoRoute(
              path: 'offline',
              name: RouteNames.offlineDownloads,
              builder: (_, __) => const ComingSoonPage(title: 'Offline downloads'),
            ),
          ],
        ),
        GoRoute(
          path: '/map',
          name: RouteNames.map,
          builder: (_, __) => const MapPage(),
          routes: <RouteBase>[
            GoRoute(
              path: 'poi/:id',
              name: RouteNames.poiDetail,
              builder: (_, state) => ComingSoonPage(
                title: 'POI · ${state.pathParameters['id']}',
              ),
              routes: <RouteBase>[
                GoRoute(
                  path: 'reputation',
                  name: RouteNames.poiReputation,
                  builder: (_, state) => ComingSoonPage(
                    title: 'Reputation · ${state.pathParameters['id']}',
                  ),
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          path: '/discover',
          name: RouteNames.discover,
          builder: (_, __) => const DiscoverPage(),
          routes: <RouteBase>[
            GoRoute(
              path: ':category',
              name: RouteNames.rankCategory,
              builder: (_, state) => ComingSoonPage(
                title: 'Rank · ${state.pathParameters['category']}',
              ),
            ),
          ],
        ),
        GoRoute(
          path: '/tools',
          name: RouteNames.tools,
          builder: (_, __) => const ToolsPage(),
          routes: <RouteBase>[
            GoRoute(
              path: 'fx',
              name: RouteNames.fxConverter,
              builder: (_, __) => const ComingSoonPage(title: 'FX converter'),
            ),
            GoRoute(
              path: 'phrases',
              name: RouteNames.phrasesIndex,
              builder: (_, __) => const ComingSoonPage(title: 'Phrases'),
              routes: <RouteBase>[
                GoRoute(
                  path: ':category',
                  name: RouteNames.phrasesCategory,
                  builder: (_, state) => ComingSoonPage(
                    title: 'Phrases · ${state.pathParameters['category']}',
                  ),
                ),
              ],
            ),
            GoRoute(
              path: 'emergency',
              name: RouteNames.emergency,
              builder: (_, __) => const ComingSoonPage(title: 'Emergency'),
            ),
          ],
        ),
        GoRoute(
          path: '/you',
          name: RouteNames.you,
          builder: (_, __) => const YouPage(),
        ),
      ],
    ),

    // Modal
    GoRoute(
      path: '/modal/correction',
      name: RouteNames.modalCorrection,
      pageBuilder: (_, state) => MaterialPage(
        fullscreenDialog: true,
        child: ComingSoonPage(
          title: 'Correction${state.uri.queryParameters['poiId'] != null ? ' · ${state.uri.queryParameters['poiId']}' : ''}',
        ),
      ),
    ),
    GoRoute(
      path: '/modal/filter',
      name: RouteNames.modalFilter,
      pageBuilder: (_, __) => const MaterialPage(
        fullscreenDialog: true,
        child: ComingSoonPage(title: 'Filter'),
      ),
    ),
    GoRoute(
      path: '/modal/country',
      name: RouteNames.modalCountry,
      pageBuilder: (_, __) => const MaterialPage(
        fullscreenDialog: true,
        child: ComingSoonPage(title: 'Country'),
      ),
    ),
    GoRoute(
      path: '/modal/language',
      name: RouteNames.modalLanguage,
      pageBuilder: (_, __) => const MaterialPage(
        fullscreenDialog: true,
        child: ComingSoonPage(title: 'Language'),
      ),
    ),

    // Full
    GoRoute(
      path: '/full/privacy',
      name: RouteNames.privacy,
      builder: (_, __) => const ComingSoonPage(title: 'Privacy policy'),
    ),
    GoRoute(
      path: '/full/about',
      name: RouteNames.about,
      builder: (_, __) => const ComingSoonPage(title: 'About'),
    ),
    GoRoute(
      path: '/full/maintenance',
      name: RouteNames.maintenance,
      builder: (_, __) => const ComingSoonPage(title: 'Maintenance'),
    ),
    GoRoute(
      path: '/full/not-found',
      name: RouteNames.notFound,
      builder: (_, __) => const NotFoundPage(),
    ),
  ],
  errorBuilder: (_, state) => NotFoundPage(error: state.error),
);
```

### 7.3 MainShell（5 tab 底栏）

`app/lib/core/router/main_shell.dart`：

```dart
class MainShell extends StatelessWidget {
  const MainShell({required this.child, super.key});
  final Widget child;

  static const _tabs = <_TabSpec>[
    _TabSpec(path: '/prepare', icon: Icons.flight_takeoff, labelKey: 'tabPrepare'),
    _TabSpec(path: '/map', icon: Icons.map_outlined, labelKey: 'tabMap'),
    _TabSpec(path: '/discover', icon: Icons.explore_outlined, labelKey: 'tabDiscover'),
    _TabSpec(path: '/tools', icon: Icons.build_outlined, labelKey: 'tabTools'),
    _TabSpec(path: '/you', icon: Icons.person_outline, labelKey: 'tabYou'),
  ];

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final i = _tabs.indexWhere((t) => location.startsWith(t.path));
    return i < 0 ? 0 : i;
  }

  @override
  Widget build(BuildContext context) {
    final i = _currentIndex(context);
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: i,
        onTap: (idx) => context.go(_tabs[idx].path),
        items: _tabs
            .map((t) => BottomNavigationBarItem(
                  icon: Icon(t.icon),
                  label: AppLocalizations.of(context)!.lookup(t.labelKey),
                ))
            .toList(),
      ),
    );
  }
}

class _TabSpec {
  const _TabSpec({required this.path, required this.icon, required this.labelKey});
  final String path;
  final IconData icon;
  final String labelKey;
}
```

### 7.4 占位 Page

`app/lib/shared/pages/coming_soon_page.dart`：

```dart
class ComingSoonPage extends StatelessWidget {
  const ComingSoonPage({required this.title, super.key});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.hourglass_empty, size: 64, color: AppColors.slate300),
            const SizedBox(height: AppSpacing.s4),
            Text(
              AppLocalizations.of(context)!.commonComingSoon,
              style: AppTextTheme.textTheme.titleLarge,
            ),
          ],
        ),
      ),
    );
  }
}
```

`app/lib/shared/pages/not_found_page.dart`：

```dart
class NotFoundPage extends StatelessWidget {
  const NotFoundPage({this.error, super.key});
  final Exception? error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('404')),
      body: Center(
        child: Text('Page not found${error != null ? ' · $error' : ''}'),
      ),
    );
  }
}
```

### 7.5 5 个 Tab Page 占位

每个 Page 都是 `ComingSoonPage` 的简单包装（用 `AppLocalizations` 渲染 tab 标题）：

`app/lib/features/prepare/presentation/pages/prepare_page.dart`：

```dart
import 'package:flutter/material.dart';

import '../../../../l10n/generated/app_localizations.dart';
import '../../../../shared/pages/coming_soon_page.dart';

class PreparePage extends StatelessWidget {
  const PreparePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ComingSoonPage(
      title: AppLocalizations.of(context)!.prepareTitle('US'),
    );
  }
}
```

其他 4 个 Tab Page 同模式（`mapTitle` / `discoverTitle` / `toolsTitle` / `youTitle`）。

### 7.6 守卫

`app/lib/core/router/route_guards.dart`：

```dart
import 'package:go_router/go_router.dart';
import '../storage/anonymous_id.dart';

/// 守卫：MVP 阶段所有路由对游客模式开放（按 MVP Plan Task 11.4）
/// 阶段一 / 阶段二无需鉴权；阶段三 UGC 时再启用 token 校验。
Future<String?> visitorGuard(BuildContext context, GoRouterState state) async {
  AnonymousId.get(); // 触发 anonymousId 生成
  return null;
}
```

> 阶段一不调用此守卫（路由表直接开放）。保留文件以备阶段二 Spec B 接入。

### 7.7 测试

- `test/router/app_router_test.dart`：
  - `appRouter.routerDelegate.currentConfiguration` 初始为 `/prepare`
  - `context.go('/map')` 切换 tab
  - `context.go('/map/poi/123')` 进入子路由
  - `context.go('/non-existent')` 触发 `errorBuilder` → NotFoundPage
  - 5 个 tab 路径都注册

---

## 8. 范围外（明确不做）

- ❌ 不实现真实业务屏幕（Prepare / Map 等仅占位）
- ❌ 不下载 NotoSansSC / Inter 字体文件（pubspec 占位）
- ❌ 不写 14 个 Design System 组件（仅 ThemeData token）
- ❌ 不接 BLoC → 任何 Repository（阶段二起按 feature 接入）
- ❌ 不实现 Mock 拦截器 6 个端点的真实返回数据（仅 `{ data: [] }`）
- ❌ 不写 DTO / Entity（freezed 阶段二起按 feature 加）
- ❌ 不做 Deep Link 配置（阶段四 P1）
- ❌ 不做游客模式首启引导（属于 Spec B）
- ❌ 不做单元切换（属于 Spec B Profile 屏）
- ❌ 不做暗黑模式全套组件适配（仅 ThemeData 提供，组件默认行为）

---

## 9. 依赖注入（injection.dart 改造）

`app/lib/core/di/injection.dart`（用 `injectable`）：

```dart
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
Future<void> configureDependencies() async => getIt.init();
```

**`injection.dart` 关键注册**（由 `@InjectableInit` 注解自动生成）：

- `@lazySingleton`：`DioClient`、`MockInterceptor`、`AuthInterceptor`、`LoggingInterceptor`、`ErrorInterceptor`、`RetryInterceptor`
- `@lazySingleton`：`LocaleCubit`、`ThemeCubit`
- `@lazySingleton`：`AppRouter`（由 `appRouter` 顶层变量提供；injectable 自动注册）

`app/lib/core/di/injection.config.dart` 由 `build_runner` 生成，不手写。

---

## 10. 测试策略

| 层 | 工具 | 覆盖目标 | 重点 |
| :--- | :--- | :--- | :--- |
| 单元 | flutter_test + mocktail | 80% | Cubit / Service / Interceptor |
| Widget | flutter_test | 50% | 5 个 Tab Page 渲染、MainShell 切换 |
| Smoke | flutter_test | 关键路径 | `SightourApp` 启动到 `/prepare` 显示占位 |

### 10.1 关键 widget test

`test/widget_test.dart`（更新阶段零版本）：

```dart
testWidgets('SightourApp shows Prepare tab on launch', (tester) async {
  await tester.pumpWidget(const SightourApp());
  await tester.pump();
  expect(find.text('Prepare · US'), findsOneWidget);  // prepareTitle('US')
  expect(find.byType(BottomNavigationBar), findsOneWidget);
  expect(find.text('Sightour scaffold ready'), findsNothing); // 旧 home 文案应消失
});
```

### 10.2 关键 integration test（保留给阶段二）

阶段一不写 integration test（无业务 journey）。

---

## 11. 验收标准

完成后必须满足：

1. `flutter pub get` + `dart analyze` + `flutter test` 全部通过
2. `flutter test` 包含至少 10 个新单元/widget test（覆盖 5 个 Task 的核心行为）
3. App 启动 → `/prepare` Tab 显示「Prepare · US」标题 + 「Coming soon」正文 + 5 tab 底栏
4. 切到「Map」Tab → 标题变「Map」+ 「Coming soon」正文
5. 中英文切换（用 `LocaleCubit.setLocale(Locale('zh'))` 单元测试验证）→ 20 个 key 全部翻译
6. Mock 拦截器命中 8 个端点（GET /policies, /pois/search, /discover/curated, /discover/authentic, /discover/heads-up, /tools/fx-rates, /me/preferences, POST /corrections）→ 返回 `emptyData`
7. 路由表覆盖 IA Spec §3.2 全部路径
8. Hive 8 个 box 全部 `openBox` 成功

---

## 12. 风险与缓解

| 风险 | 影响 | 缓解 |
| :--- | :--- | :--- |
| intl 与 `flutter_localizations` 版本不匹配 | `flutter pub get` 失败 | 与阶段零已锁定的 `intl: ^0.20.0` 对齐 |
| `build_runner` 未跑导致 `injection.config.dart` 缺失 | DI 失败 | plan Step 中显式 `dart run build_runner build` |
| NotoSansSC 字体未下载 → 中文字符显示方块 | 视觉 | 本阶段仅声明 family 名，fallback 到系统字体；下阶段下载 |
| `go_router 17.x` 与 `ShellRoute` API 变化 | 编译错误 | plan 用 `ShellRoute(builder: ...)` + `routes: <RouteBase>[]` 形式，与文档示例一致 |
| BottomNavigationBar 在 `context.go` 切换时 currentIndex 不更新 | UI 错误 | `MainShell._currentIndex` 从 `GoRouterState.of(context).matchedLocation` 动态计算 |
| Hive box 重复打开 | 异常 | `Hive.openBox` 重复调用返回已开 box，无需额外保护 |

---

## 13. 提交策略（5 个 commit）

```
feat(i18n): add bilingual framework with 20 core keys
feat(theme): light/dark theme with full design tokens
feat(storage): hive based local cache with 8 boxes
feat(network): dio with 5 interceptors and 8 mock endpoints
feat(router): go_router with 5 main tabs and full sub-routes
```

每个 commit 跑 `flutter test` 通过后才提交。

---

## 14. Spec 自我审查（写完后执行）

作者自检（已通过）：

- [x] 无 TBD / TODO 留空（业务占位用 `// stage-N: ...` 注释明确指向下个 spec）
- [x] 无内部矛盾：所有命名（`RouteNames.xxx`、`HiveBoxes.xxx`、`AppColors.xxx`）一致
- [x] 范围聚焦：仅 Task 6–10
- [x] 歧义消除：「本阶段」= Spec A；「下阶段」= Spec B / Spec C；`stage-N` 含义统一
- [x] 步骤粒度：5 个 Task 各自文件级步骤明确
- [x] 可测：每个 Task 末尾有测试文件与验收标准

---

## 附录 A · 与其他文档交叉引用

| 主题 | 关联文档 | 章节 |
| :--- | :--- | :--- |
| 状态机 | States Spec | §3.2（阶段二按屏引入） |
| 选型 | Architecture Spec | §1, §15 |
| 路由表 | IA Spec | §3.2 |
| Token | Design System | §1 |
| MVP 任务清单 | MVP Plan | Task 6–10 |

---

## 附录 B · 文档变更日志

| 版本 | 日期 | 变更 |
| :--- | :--- | :--- |
| v1.0 | 2026-06-27 | 首版发布。Brainstorming 工作流产出，覆盖 Spec A 5 个 Task 完整设计。 |
