# Sightour 前端架构规范（Flutter）

> **文档类型**：技术架构规范
> **阶段**：MVP（Phase 1）范围
> **技术栈**：Flutter 3.x + Dart 3.x
> **版本**：v1.0 — 2026-06-26
> **关联文档**：
> - [用户画像](file:///c:/Users/wenmo/.trae-cn/worktrees/旅游app/docs/superpowers/specs/2026-06-26-sightour-personas.md) — 决定状态机复杂度
> - [用户旅程地图](file:///c:/Users/wenmo/.trae-cn/worktrees/旅游app/docs/superpowers/specs/2026-06-26-sightour-user-journeys.md) — 决定路由与屏间跳转
> - [信息架构](file:///c:/Users/wenmo/.trae-cn/worktrees/旅游app/docs/superpowers/specs/2026-06-26-sightour-information-architecture.md) — 决定屏与路由名
> - [设计系统](file:///c:/Users/wenmo/.trae-cn/worktrees/旅游app/docs/superpowers/specs/2026-06-26-sightour-design-system.md) — 决定主题与组件实现
> - [状态设计规范](file:///c:/Users/wenmo/.trae-cn/worktrees/旅游app/docs/superpowers/specs/2026-06-26-sightour-states-spec.md) — 决定每屏的状态机

---

## 0. 文档元信息

### 用途
本文档定义 Sightour 前端的完整技术架构——技术栈选型理由、项目结构、状态管理、路由、本地存储、网络层（含 Mock）、i18n、离线包、主题集成、错误处理、性能、测试。

**所有 Mock 接口必须用本文档定义的模式实现**，未来切真实后端时只换 Dio Interceptor 即可。

### 读者
- Flutter 工程师（主读者）
- 架构师（决策 review）
- 后端工程师（理解前端数据契约）
- QA（理解状态机与测试策略）

### 与其他文档的关系

- **本文档是产品文档的技术实现层**
- 上游：所有产品 spec（persona / journey / IA / design system / states）
- 下游：具体代码、PR review、CI 流水线
- 平行：[NestJS 后端架构](待写) / [OpenAPI 规范](待写)

---

## 1. 技术栈选型

### 1.1 核心技术栈

| 类别 | 选型 | 版本 | 理由 |
| --- | --- | --- | --- |
| 框架 | Flutter | 3.24+ | 跨端（iOS / Android / 后续可 Web）、单一代码库 |
| 语言 | Dart | 3.5+ | Flutter 默认，强类型 + null safety |
| 状态管理 | flutter_bloc | 8.1+ | 业务逻辑可测试、团队熟悉、明确的状态机 |
| 路由 | go_router | 14+ | 声明式、支持 deep link、嵌套路由 |
| 网络 | dio | 5.7+ | 拦截器机制成熟、易扩展 Mock |
| 本地存储 | hive_ce | 2.10+ | 纯 Dart、无原生依赖、加密可选 |
| 国际化 | intl + flutter_localizations | latest | 官方方案、支持复杂复数规则 |
| 序列化 | freezed + json_serializable | 2.5+ / 6.8+ | 不可变模型、联合类型（状态机核心） |
| 依赖注入 | get_it + injectable | 7.7+ / 4.0+ | 编译期检查、测试友好 |
| 日志 | logger | 2.4+ | 格式化输出、release 关闭 |
| 错误追踪 | sentry_flutter | 8+ | release 监控 |
| 地图 | 高德官方 Flutter SDK | 3.0+ | 合规、官方维护（见 §9.2） |
| 加密 | pointycastle | 3.9+ | 离线包加密、敏感数据 |

### 1.2 选型决策记录（ADR）

#### ADR-001：为什么选 flutter_bloc 而非 Provider / Riverpod

- **决策**：BLoC 8.x
- **理由**：
  - 业务逻辑（state machine）天然契合 — 我们有 6 个屏级状态 × 5 个主屏 = 30 个状态机
  - 团队有 BLoC 经验
  - 事件 + 状态分离便于 QA 写测试用例
- **拒绝**：Provider（缺乏事件驱动）、Riverpod（学习曲线）、GetX（反模式）

#### ADR-002：为什么选 go_router 而非 auto_route

- **决策**：go_router 14.x
- **理由**：
  - Flutter 官方维护
  - 支持嵌套路由 + 守卫 + redirect
  - 与 deep link 集成最简洁
- **拒绝**：auto_route（学习曲线、生成代码量大）

#### ADR-003：为什么选 dio 而非 http

- **决策**：dio 5.x
- **理由**：
  - 拦截器机制可一行代码切换 Mock 与真实 API
  - FormData / 上传 / 取消 token 内置
  - 错误模型比 http 丰富
- **拒绝**：http（拦截器需手写）

#### ADR-004：为什么选 hive 而非 shared_preferences / sqflite

- **决策**：hive_ce 2.x
- **理由**：
  - 离线包存储（MB 级数据）比 sqflite 简单
  - 启动速度极快（< 50ms 打开）
  - 不依赖原生（shared_preferences 仅适合 KB 级）
- **拒绝**：sqflite（需要 schema 迁移）、isar（与 hive 比无显著优势）

#### ADR-005：为什么选 freezed 而非手写 model

- **决策**：freezed 2.5+
- **理由**：
  - 自动 `copyWith` / `==` / `hashCode`
  - **联合类型（Union Types）**是状态机核心（Sealed class）
  - 不可变模型避免共享状态 bug
- **拒绝**：手写（样板代码、容易写错）

### 1.3 平台版本要求

| 平台 | 最低版本 | 推荐版本 | 备注 |
| --- | --- | --- | --- |
| iOS | 14.0 | 16+ | 支持 95% 中国市场 |
| Android | 8.0 (API 26) | 12+ (API 31) | 高德 SDK 最低要求 |
| Web（P2 预留） | Chrome 100+ | — | 不在 MVP 范围 |

---

## 2. 项目结构

### 2.1 顶层 Monorepo 布局

```
sightour/
├── app/                        # Flutter APP
│   ├── lib/
│   ├── test/
│   ├── android/
│   ├── ios/
│   ├── pubspec.yaml
│   └── README.md
├── backend/                    # NestJS API（P0 仅 Mock，无需实现）
├── admin/                      # React 审核后台（未来）
├── content-ops/                # PGC 内容生产（未来）
├── docs/                       # 全部文档
│   └── superpowers/
│       ├── plans/              # 实施计划
│       └── specs/              # 各 Spec
├── tools/                      # 内部工具脚本
└── README.md
```

### 2.2 Flutter 内部 lib 结构

```
app/lib/
├── main.dart                   # 入口
├── app.dart                    # 顶层 App Widget
│
├── core/                       # 跨业务通用
│   ├── constants/              # 静态常量
│   ├── errors/                 # 错误模型
│   ├── extensions/             # Dart 扩展
│   ├── utils/                  # 工具函数
│   ├── di/                     # 依赖注入配置
│   ├── router/                 # go_router 配置
│   ├── theme/                  # 主题与设计 Token
│   ├── i18n/                   # 国际化
│   ├── network/                # Dio + Mock 拦截器
│   ├── storage/                # Hive 封装
│   ├── offline/                # 离线包管理
│   ├── permissions/            # 权限处理
│   └── analytics/              # 埋点
│
├── features/                   # 业务功能（按 IA 5 Tab 切分）
│   ├── onboarding/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── prepare/                # Tab 1
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── map/                    # Tab 2
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── discover/               # Tab 3
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── tools/                  # Tab 4
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── you/                    # Tab 5
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── poi/                    # 跨 tab 共享：POI Detail / Reputation
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── emergency/              # 跨屏：紧急联系
│   └── correction/             # 跨屏：纠错
│
├── shared/                     # 跨 feature 共享 UI 组件
│   ├── widgets/                # 自定义 Widget
│   ├── models/                 # 跨 feature 数据模型
│   └── mixins/
│
└── l10n/                       # 翻译文件（ARB）
    ├── app_en.arb
    └── app_zh.arb
```

### 2.3 Feature 内部 3 层结构（Clean Architecture Lite）

```
features/map/
├── data/
│   ├── datasources/            # 远程 / 本地数据源
│   │   ├── map_remote_data_source.dart
│   │   └── map_local_data_source.dart
│   ├── models/                 # DTO / 持久化模型
│   │   └── poi_model.dart
│   └── repositories/           # 仓库实现
│       └── map_repository_impl.dart
│
├── domain/
│   ├── entities/               # 业务实体（不可变）
│   │   └── poi.dart
│   ├── repositories/           # 仓库接口
│   │   └── map_repository.dart
│   └── usecases/               # 业务用例
│       ├── search_poi.dart
│       └── get_poi_detail.dart
│
└── presentation/
    ├── bloc/                   # 状态机
    │   ├── map_bloc.dart
    │   ├── map_event.dart
    │   └── map_state.dart
    ├── pages/                  # 屏级 Page
    │   └── map_page.dart
    └── widgets/                # 屏内组件
        ├── poi_card.dart
        └── filter_sheet.dart
```

**依赖方向**：
```
presentation → domain ← data
              ↑
           shared / core
```

**关键原则**：
- presentation 不知道 data 存在
- data 不知道 presentation 存在
- domain 是中心，不依赖任何外层
- 跨 feature 只能通过 shared 或 domain 接口通信

### 2.4 命名约定

| 类别 | 命名 | 例 |
| --- | --- | --- |
| 文件 | snake_case | `map_repository_impl.dart` |
| 类 | PascalCase | `MapRepositoryImpl` |
| 变量 / 函数 | camelCase | `getPoiDetail()` |
| 常量 | SCREAMING_SNAKE | `MAX_RETRY_COUNT` |
| 私有 | _ 前缀 | `_internalState` |
| BLoC | `{Name}Bloc` | `MapBloc` |
| Event | `{Name}Event` (sealed) | `MapLoaded`、`FilterChanged` |
| State | `{Name}State` (sealed) | `MapInitial`、`MapLoading`、`MapSuccess`、`MapError` |
| 仓库 | `{Name}Repository` | `MapRepository` |
| DTO | `{Name}Model` | `PoiModel` |
| 实体 | `{Name}` | `Poi` |

---

## 3. 状态管理（BLoC）

### 3.1 模式

每个屏对应 1 个 BLoC，状态用 **Sealed Class**（freezed 联合类型）表达 6 状态。

```dart
// map_state.dart
@freezed
sealed class MapState with _$MapState {
  const factory MapState.initial() = MapInitial;
  const factory MapState.loading() = MapLoading;
  const factory MapState.success({
    required List<Poi> pois,
    required LatLng center,
    String? activeFilter,
  }) = MapSuccess;
  const factory MapState.empty({required String query}) = MapEmpty;
  const factory MapState.error({
    required String message,
    required ErrorType type,
    VoidCallback? onRetry,
  }) = MapError;
  const factory MapState.offline({
    required List<Poi> cachedPois,
    required DateTime lastSyncAt,
  }) = MapOffline;
  const factory MapState.noPermission({
    required PermissionType permission,
  }) = MapNoPermission;
}
```

### 3.2 6 状态对应 States Spec

每屏 6 状态必须严格映射 [States Spec](file:///c:/Users/wenmo/.trae-cn/worktrees/旅游app/docs/superpowers/specs/2026-06-26-sightour-states-spec.md)：

| 状态 | sealed class 分支 |
| --- | --- |
| Loading | `MapLoading` |
| Empty | `MapEmpty` |
| Error | `MapError` |
| Success | `MapSuccess` |
| Offline | `MapOffline` |
| No-permission | `MapNoPermission` |

### 3.3 事件驱动

```dart
@freezed
sealed class MapEvent with _$MapEvent {
  const factory MapEvent.loaded() = MapLoaded;
  const factory MapEvent.searchChanged(String query) = MapSearchChanged;
  const factory MapEvent.filterChanged(String filter) = MapFilterChanged;
  const factory MapEvent.poiTapped(String id) = MapPoiTapped;
  const factory MapEvent.refreshed() = MapRefreshed;
  const factory MapEvent.permissionGranted() = MapPermissionGranted;
}
```

### 3.4 BLoC 模板（每个 feature 复用）

```dart
class MapBloc extends Bloc<MapEvent, MapState> {
  final GetPois _getPois;
  final NetworkInfo _networkInfo;

  MapBloc({
    required GetPois getPois,
    required NetworkInfo networkInfo,
  })  : _getPois = getPois,
        _networkInfo = networkInfo,
        super(const MapState.initial()) {
    on<MapLoaded>(_onLoaded);
    on<MapSearchChanged>(_onSearchChanged, transformer: debounce(300.ms));
    on<MapFilterChanged>(_onFilterChanged);
    on<MapRefreshed>(_onRefreshed);
  }

  Future<void> _onLoaded(MapLoaded event, Emitter<MapState> emit) async {
    emit(const MapState.loading());
    final isOnline = await _networkInfo.isConnected;
    if (!isOnline) {
      final cached = await _localDataSource.getCachedPois();
      return emit(MapState.offline(cachedPois: cached, lastSyncAt: ...));
    }
    final result = await _getPois();
    result.fold(
      (failure) => emit(MapState.error(message: failure.message, ...)),
      (pois) => pois.isEmpty
          ? emit(const MapState.empty(query: ''))
          : emit(MapState.success(pois: pois, ...)),
    );
  }
  // ... 其他 handler
}
```

### 3.5 跨 BLoC 通信

**原则**：BLoC 不直接引用其他 BLoC。通过：

1. **Repository 共享**（读）
2. **Stream subscription**（监听）
3. **BlocListener**（响应）

**禁止**：BLoC 内部 import 另一个 BLoC。

---

## 4. 路由（go_router）

### 4.1 路由配置

完整路由表映射自 [IA 文档](file:///c:/Users/wenmo/.trae-cn/worktrees/旅游app/docs/superpowers/specs/2026-06-26-sightour-information-architecture.md) §3.2。

```dart
// core/router/app_router.dart
final appRouter = GoRouter(
  initialLocation: '/onboarding/welcome',
  redirect: _authRedirect,        // 守卫：游客模式 / 登录模式
  refreshListenable: _rootBloc,   // 监听登录状态变化
  routes: [
    // Onboarding
    GoRoute(
      path: '/onboarding/welcome',
      builder: (_, __) => const WelcomePage(),
    ),
    GoRoute(
      path: '/onboarding/language',
      builder: (_, __) => const LanguagePage(),
    ),

    // Main App Shell (Bottom Tab)
    ShellRoute(
      builder: (_, __, child) => MainShell(child: child),
      routes: [
        GoRoute(
          path: '/prepare',
          builder: (_, __) => const PreparePage(),
          routes: [
            GoRoute(
              path: 'policy/:id',
              builder: (_, state) => PolicyDetailPage(
                policyId: state.pathParameters['id']!,
              ),
            ),
            GoRoute(
              path: 'checklist',
              builder: (_, __) => const ChecklistPage(),
            ),
            GoRoute(
              path: 'offline',
              builder: (_, __) => const OfflineDownloadsPage(),
            ),
          ],
        ),
        GoRoute(
          path: '/map',
          builder: (_, __) => const MapPage(),
          routes: [
            GoRoute(
              path: 'poi/:id',
              builder: (_, state) => PoiDetailPage(
                poiId: state.pathParameters['id']!,
              ),
              routes: [
                GoRoute(
                  path: 'reputation',
                  builder: (_, state) => ReputationPage(
                    poiId: state.pathParameters['id']!,
                  ),
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          path: '/discover',
          builder: (_, __) => const DiscoverPage(),
          routes: [
            GoRoute(
              path: ':category',
              builder: (_, state) => DiscoverListPage(
                category: state.pathParameters['category']!,
              ),
            ),
          ],
        ),
        GoRoute(
          path: '/tools',
          builder: (_, __) => const ToolsPage(),
          routes: [
            GoRoute(
              path: 'fx',
              builder: (_, __) => const FxPage(),
            ),
            GoRoute(
              path: 'phrases',
              builder: (_, __) => const PhraseIndexPage(),
              routes: [
                GoRoute(
                  path: ':category',
                  builder: (_, state) => PhraseDetailPage(
                    category: state.pathParameters['category']!,
                  ),
                ),
              ],
            ),
            GoRoute(
              path: 'emergency',
              builder: (_, __) => const EmergencyPage(),
            ),
          ],
        ),
        GoRoute(
          path: '/you',
          builder: (_, __) => const ProfilePage(),
        ),
      ],
    ),

    // Modal
    GoRoute(
      path: '/modal/correction',
      pageBuilder: (_, state) => ModalBottomSheetPage(
        child: CorrectionSheet(poiId: state.uri.queryParameters['poiId']),
      ),
    ),
    GoRoute(
      path: '/modal/filter',
      pageBuilder: (_, state) => ModalBottomSheetPage(
        child: const FilterSheet(),
      ),
    ),
    GoRoute(
      path: '/modal/country',
      pageBuilder: (_, state) => ModalBottomSheetPage(
        child: const CountrySelectorSheet(),
      ),
    ),
    GoRoute(
      path: '/modal/language',
      pageBuilder: (_, state) => ModalBottomSheetPage(
        child: const LanguageSwitcherSheet(),
      ),
    ),

    // Full screen
    GoRoute(
      path: '/full/privacy',
      builder: (_, __) => const PrivacyPage(),
    ),
    GoRoute(
      path: '/full/about',
      builder: (_, __) => const AboutPage(),
    ),
    GoRoute(
      path: '/full/maintenance',
      builder: (_, __) => const MaintenancePage(),
    ),
    GoRoute(
      path: '/full/not-found',
      builder: (_, __) => const NotFoundPage(),
    ),
  ],
  errorBuilder: (_, state) => NotFoundPage(error: state.error),
);
```

### 4.2 路由跳转 API

```dart
// 统一跳转服务（推荐封装）
class AppNavigator {
  static void toPolicyDetail(BuildContext context, String id) {
    context.go('/prepare/policy/$id');
  }
  static void toPoiDetail(BuildContext context, String id) {
    context.push('/map/poi/$id');
  }
  static void toReputation(BuildContext context, String id) {
    context.push('/map/poi/$id/reputation');
  }
  static void openFilter(BuildContext context) {
    context.push('/modal/filter');
  }
  static void openCountrySelector(BuildContext context) {
    context.push('/modal/country');
  }
  // ... 所有跳转统一管理
}
```

**禁止**：业务代码直接调用 `context.push('/...')`，必须通过 `AppNavigator` 封装。

### 4.3 守卫（Redirect）

```dart
Future<String?> _authRedirect(BuildContext context, GoRouterState state) async {
  final isFirstLaunch = await _storage.isFirstLaunch();
  final isOnboarding = state.matchedLocation.startsWith('/onboarding');
  
  if (isFirstLaunch && !isOnboarding) return '/onboarding/welcome';
  if (!isFirstLaunch && isOnboarding) return '/prepare';
  return null;
}
```

---

## 5. 本地存储（Hive）

### 5.1 数据分类

| 数据 | 存储 | 加密 | 同步策略 |
| --- | --- | --- | --- |
| 用户偏好（语言 / 单位 / 主题） | Hive | 否 | 实时 |
| 行前清单勾选状态 | Hive | 否 | 实时 |
| 离线包元数据 | Hive | 是 | 进入 App 时 |
| 离线包数据 | 文件系统 | 是 | 进入 App 时 |
| POI 缓存 | Hive | 否 | 后台同步 |
| 搜索历史 | Hive | 否 | 实时 |
| 收藏列表 | Hive | 否 | 实时 |
| 草稿（纠错表单） | Hive | 否 | 实时 |
| 用户 token / session | FlutterSecureStorage | 是 | 实时 |

### 5.2 Box 命名

```dart
// core/storage/hive_boxes.dart
class HiveBoxes {
  static const prefs = 'prefs';           // 用户偏好
  static const checklist = 'checklist';   // 行前清单
  static const offline = 'offline';       // 离线包元数据
  static const poiCache = 'poi_cache';    // POI 缓存
  static const search = 'search';         // 搜索历史
  static const favorites = 'favorites';   // 收藏
  static const drafts = 'drafts';         // 草稿
}
```

### 5.3 Model 适配

```dart
// features/poi/data/models/poi_model.dart
@HiveType(typeId: 1)
class PoiModel extends HiveObject {
  @HiveField(0) String id;
  @HiveField(1) String nameEn;
  @HiveField(2) String nameZh;
  @HiveField(3) String category;
  @HiveField(4) double rating;
  @HiveField(5) double lat;
  @HiveField(6) double lng;
  @HiveField(7) List<String> tags;
  // ...
}
```

### 5.4 Repository 写本地优先策略

```dart
class MapRepositoryImpl implements MapRepository {
  final MapRemoteDataSource _remote;
  final MapLocalDataSource _local;
  final NetworkInfo _network;

  @override
  Future<List<Poi>> getPois() async {
    if (await _network.isConnected) {
      try {
        final remote = await _remote.getPois();
        await _local.cachePois(remote);  // 写本地
        return remote;
      } catch (e) {
        // 远端失败，回退本地
        return _local.getCachedPois();
      }
    }
    return _local.getCachedPois();
  }
}
```

---

## 6. 网络层（dio + Mock）

### 6.1 Dio 配置

```dart
// core/network/dio_client.dart
@lazySingleton
class DioClient {
  late final Dio dio;

  DioClient(this._mockInterceptor) {
    dio = Dio(BaseOptions(
      baseUrl: 'https://api.sightour.com/v1',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Accept-Language': 'en',
        'X-App-Version': '1.0.0',
      },
    ));
    dio.interceptors.addAll([
      _AuthInterceptor(),
      _LoggingInterceptor(),  // dev only
      _ErrorInterceptor(),
      _MockInterceptor(),     // P0 阶段：所有请求都先到这里
      _RetryInterceptor(maxRetries: 3),
    ]);
  }
}
```

### 6.2 Mock 拦截器实现

**所有接口都用 Mock 实现，命中以下规则**：

```dart
// core/network/mock_interceptor.dart
@lazySingleton
class MockInterceptor extends Interceptor {
  final Map<String, dynamic> _mockResponses = {
    // ===== Policies =====
    '/policies': MockResponse(
      data: MockData.policiesByNationality,
      delay: 200.ms,
    ),
    // regex: '/policies/.*'
    
    // ===== POIs =====
    '/pois/search': MockResponse(
      data: MockData.poisSearch,
      delay: 300.ms,
    ),
    // '/pois/:id'
    // '/pois/:id/reputation'
    
    // ===== Discover =====
    '/discover/curated': MockResponse(
      data: MockData.curatedList,
      delay: 250.ms,
    ),
    // '/discover/authentic'
    // '/discover/heads-up'
    
    // ===== Tools =====
    '/tools/fx-rates': MockResponse(
      data: MockData.fxRates,
      delay: 150.ms,
    ),
    // '/tools/phrases'
    // '/tools/emergency-contacts'
    
    // ===== User =====
    '/me/preferences': MockResponse(
      data: MockData.userPreferences,
      delay: 100.ms,
    ),
    // '/corrections' (POST)
  };
  
  // 模拟离线
  bool _simulateOffline = false;
  // 模拟错误率
  double _errorRate = 0.0;
  
  @override
  Future onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    if (_simulateOffline) {
      return handler.reject(DioException(
        requestOptions: options,
        type: DioExceptionType.connectionError,
        message: 'You are offline',
      ));
    }
    
    // 模拟错误
    if (Random().nextDouble() < _errorRate) {
      return handler.reject(DioException(
        requestOptions: options,
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: options,
          statusCode: 500,
          data: {'code': 'INTERNAL_ERROR'},
        ),
      ));
    }
    
    final mock = _findMock(options);
    if (mock == null) {
      return handler.next(options);
    }
    
    // 模拟延迟
    await Future.delayed(mock.delay);
    
    return handler.resolve(Response(
      requestOptions: options,
      statusCode: 200,
      data: mock.data,
    ));
  }
  
  // 支持 DevTools 切换（开发期）
  void setSimulateOffline(bool value) => _simulateOffline = value;
  void setErrorRate(double rate) => _errorRate = rate;
}
```

### 6.3 Mock 数据组织

```dart
// core/network/mock_data.dart
class MockData {
  static Map<String, dynamic> get policiesByNationality => {
    'policies': [
      {
        'id': 'visa-free-30d',
        'title': '30-day visa-free entry',
        'subtitle': 'Mutual & unilateral agreements',
        'summary': 'Stay up to 30 days...',
        'applies_to': ['TH', 'FR', 'DE', 'AU', 'NZ', 'JP', 'KR'],
        'source_url': 'https://www.nia.gov.cn/...',
        'updated_at': '2026-06-15',
      },
      {
        'id': 'transit-240h',
        'title': '240-hour visa-free transit',
        'subtitle': 'For transit passengers',
        'applies_to': ['*'],
        ...
      },
      // ...
    ],
  };
  
  static Map<String, dynamic> get poisSearch => { ... };
  static Map<String, dynamic> get curatedList => { ... };
  static Map<String, dynamic> get fxRates => {
    'base': 'USD',
    'rates': {'CNY': 7.18, 'EUR': 0.92, 'JPY': 151.0},
    'updated_at': '2026-06-26T00:00:00Z',
  };
}
```

### 6.4 切换真实后端

```dart
// core/di/network_module.dart
@module
abstract class NetworkModule {
  @lazySingleton
  Interceptor mockInterceptor(MockInterceptor impl) => impl;
  
  // 未来切换真实后端时：
  // 1. 移除 mockInterceptor 注册
  // 2. 添加真实 AuthInterceptor
  // 3. baseUrl 改为真实环境
  // 4. 数据源 DTO 不变
}
```

### 6.5 错误处理

```dart
// core/network/error_interceptor.dart
class _ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final failure = _mapToFailure(err);
    handler.reject(DioException(
      requestOptions: err.requestOptions,
      error: failure,
      type: err.type,
    ));
  }
  
  Failure _mapToFailure(DioException err) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkFailure.timeout();
      case DioExceptionType.connectionError:
        return const NetworkFailure.offline();
      case DioExceptionType.badResponse:
        return ServerFailure.fromCode(err.response?.statusCode);
      default:
        return UnknownFailure(err.message ?? 'Unknown error');
    }
  }
}
```

---

## 7. 国际化（intl）

### 7.1 配置

```dart
// core/i18n/app_localizations.dart
class AppLocalizations {
  static const supportedLocales = [
    Locale('en'),
    Locale('zh'),
  ];
  
  static const delegates = [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];
}
```

### 7.2 ARB 文件示例

```json
// l10n/app_en.arb
{
  "appTitle": "Sightour",
  "onboardingWelcome": "Travel smarter in China",
  "@onboardingWelcome": {
    "description": "Shown on welcome screen"
  },
  "filterByNationality": "Filter by nationality",
  "policyVisaFree": "30-day visa-free entry",
  "policyTransit": "240-hour visa-free transit",
  "policyStandard": "Tourist visa guide",
  "emptyNoPois": "No places match \"{query}\"",
  "@emptyNoPois": {
    "placeholders": {
      "query": {"type": "String"}
    }
  }
}
```

```json
// l10n/app_zh.arb
{
  "appTitle": "Sightour",
  "onboardingWelcome": "在中国聪明旅行",
  "filterByNationality": "按国籍筛选",
  "policyVisaFree": "30 天免签入境",
  "policyTransit": "240 小时过境免签",
  "policyStandard": "旅游签证指引",
  "emptyNoPois": "没有匹配「{query}」的地点"
}
```

### 7.3 字体切换

```dart
// core/i18n/locale_text_styles.dart
TextStyle textStyleForLocale(BuildContext context, {double? fontSize}) {
  final locale = Localizations.localeOf(context);
  final isZh = locale.languageCode == 'zh';
  return TextStyle(
    fontSize: fontSize ?? 14,
    fontFamily: isZh ? 'NotoSansSC' : 'Inter',
  );
}
```

---

## 8. 离线包管理

### 8.1 离线包结构

```
{app_documents}/offline/
├── shanghai/
│   ├── manifest.json          # 元信息
│   ├── pois.json              # POI 数据
│   ├── phrases.json           # 常用语
│   ├── policies.json          # 政策
│   ├── emergency.json         # 紧急联系
│   ├── tiles/                 # 地图瓦片
│   │   ├── 12/
│   │   ├── 13/
│   │   └── ...
│   └── checksum.txt
└── index.json                  # 所有城市索引
```

### 8.2 Manifest

```json
{
  "city": "shanghai",
  "version": "2026.06.26",
  "size_bytes": 251658240,
  "poi_count": 200,
  "phrase_count": 120,
  "tile_zoom_levels": [12, 13, 14, 15],
  "checksum_sha256": "abc123...",
  "downloaded_at": "2026-06-26T10:00:00Z"
}
```

### 8.3 离线服务

```dart
// core/offline/offline_service.dart
@lazySingleton
class OfflineService {
  final Dio _dio;
  final HiveInterface _storage;
  
  /// 检查是否已下载某城市
  bool isDownloaded(String city) { ... }
  
  /// 下载离线包
  Stream<DownloadProgress> download(String city) async* {
    // 1. 下载 manifest
    final manifest = await _downloadManifest(city);
    
    // 2. 下载 POI / 短语 / 政策 JSON
    yield* _downloadJson('pois', manifest);
    
    // 3. 下载地图瓦片
    yield* _downloadTiles(manifest);
    
    // 4. 校验 checksum
    if (!_verifyChecksum(manifest)) {
      throw OfflineException('Checksum mismatch');
    }
    
    // 5. 写入 Hive
    await _storage.markDownloaded(city, manifest);
  }
  
  /// 删除离线包
  Future<void> remove(String city) async {
    final dir = Directory('${_appDocs.path}/offline/$city');
    if (dir.existsSync()) await dir.delete(recursive: true);
    await _storage.markRemoved(city);
  }
  
  /// 加载离线数据（仓库优先调用此方法）
  Future<T?> load<T>(String city, String key) async {
    if (!isDownloaded(city)) return null;
    final file = File('${_appDocs.path}/offline/$city/$key.json');
    if (!file.existsSync()) return null;
    final json = jsonDecode(await file.readAsString());
    return json as T;
  }
}
```

### 8.4 离线策略

| 数据 | 离线 | 来源 |
| --- | --- | --- |
| POI | ✓ | 离线包 + 实时缓存 |
| 地图瓦片 | ✓ | 离线包 |
| 常用语 | ✓ | 离线包 |
| 政策 | ✓ | 离线包 + 7 天缓存 |
| 紧急联系 | ✓ | 离线包 |
| 汇率 | △ | 离线包 + 24h 缓存 |
| 榜单 | △ | 离线包 + 月度更新 |
| 搜索 | ✓ | 完全本地 |

---

## 9. 主题与设计系统集成

### 9.1 主题结构

```dart
// core/theme/app_theme.dart
class AppTheme {
  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: AppColors.brand,
        onPrimary: AppColors.white,
        surface: AppColors.ivory,
        onSurface: AppColors.textPrimary,
        error: AppColors.risk,
        // ...
      ),
      textTheme: AppTextTheme.of(context),  // 见下
      spacing: AppSpacing.of(context),       // 见下
      radius: AppRadius.of(context),         // 见下
      shadow: AppShadow.of(context),         // 见下
      components: AppComponents.of(context), // 见下
    );
  }
  
  static ThemeData dark() {
    // P1 预留
  }
}
```

### 9.2 Token 映射

把 [设计系统](file:///c:/Users/wenmo/.trae-cn/worktrees/旅游app/docs/superpowers/specs/2026-06-26-sightour-design-system.md) §1 的所有 CSS 变量翻译为 Dart 常量：

```dart
// core/theme/tokens.dart
class AppColors {
  static const slate900 = Color(0xFF1A2332);
  static const slate700 = Color(0xFF374151);
  static const slate500 = Color(0xFF6B7280);
  static const slate200 = Color(0xFFE2E8F0);
  static const slate100 = Color(0xFFF1F5F9);
  static const slate50  = Color(0xFFF8FAFC);
  
  static const blue600 = Color(0xFF2A4365);
  static const blue50  = Color(0xFFEEF2F7);
  
  static const sand500 = Color(0xFFD4A574);
  static const sand50  = Color(0xFFFAF3E7);
  static const sandText = Color(0xFF8B6B3E);
  
  static const sage600 = Color(0xFF5B8C5A);
  static const sage50  = Color(0xFFEEF5EC);
  
  static const amber500 = Color(0xFFD97706);
  static const amber50  = Color(0xFFFEF3E2);
  
  static const clay600 = Color(0xFFC2410C);
  static const clay50  = Color(0xFFFDF0E8);
  
  static const ivory = Color(0xFFFAFAF7);
  static const white = Color(0xFFFFFFFF);
  
  // 语义色（绑定）
  static const textPrimary = slate900;
  static const textSecondary = slate700;
  static const textTertiary = slate500;
  static const brand = blue600;
  static const positive = sage600;
  // ...
}

class AppSpacing {
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

class AppRadius {
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 20.0;
  static const full = 999.0;
}

class AppShadow {
  static const shadow1 = [
    BoxShadow(
      color: Color(0x0F000000),
      blurRadius: 2,
      offset: Offset(0, 1),
    ),
  ];
  // ...
}
```

### 9.3 字体加载

```yaml
# pubspec.yaml
flutter:
  fonts:
    - family: Inter
      fonts:
        - asset: assets/fonts/Inter-Regular.ttf
        - asset: assets/fonts/Inter-Medium.ttf
          weight: 500
        - asset: assets/fonts/Inter-SemiBold.ttf
          weight: 600
        - asset: assets/fonts/Inter-Bold.ttf
          weight: 700
    - family: NotoSansSC
      fonts:
        - asset: assets/fonts/NotoSansSC-Regular.otf
        - asset: assets/fonts/NotoSansSC-Medium.otf
          weight: 500
        - asset: assets/fonts/NotoSansSC-Bold.otf
          weight: 700
```

---

## 10. 错误处理

### 10.1 失败模型

```dart
// core/errors/failures.dart
@freezed
sealed class Failure with _$Failure {
  const factory Failure.network(NetworkFailureType type) = NetworkFailure;
  const factory Failure.server({required int statusCode, String? code}) = ServerFailure;
  const factory Failure.cache({required String message}) = CacheFailure;
  const factory Failure.permission(PermissionType type) = PermissionFailure;
  const factory Failure.unknown(String message) = UnknownFailure;
}

enum NetworkFailureType { offline, timeout, noConnection }
```

### 10.2 Repository 返回 Either

```dart
abstract class MapRepository {
  Future<Either<Failure, List<Poi>>> getPois();
  Future<Either<Failure, Poi>> getPoiDetail(String id);
}
```

### 10.3 BLoC 处理 Failure

```dart
final result = await _repository.getPois();
result.fold(
  (failure) {
    if (failure is NetworkFailure && failure.type == NetworkFailureType.offline) {
      return emit(MapState.offline(cachedPois: ..., lastSyncAt: ...));
    }
    return emit(MapState.error(
      message: _mapFailureToMessage(failure),
      type: _mapFailureToErrorType(failure),
      onRetry: () => add(const MapEvent.refreshed()),
    ));
  },
  (pois) => emit(MapState.success(pois: pois, ...)),
);
```

### 10.4 UI 层映射

```dart
// presentation/pages/map_page.dart
Widget _buildBody(MapState state) {
  return switch (state) {
    MapInitial() => const SizedBox.shrink(),
    MapLoading() => const MapSkeleton(),
    MapSuccess(:final pois) => MapContent(pois: pois),
    MapEmpty(:final query) => EmptyPoisView(query: query),
    MapError(:final message, :final onRetry) => ErrorView(message: message, onRetry: onRetry),
    MapOffline(:final cachedPois, :final lastSyncAt) => OfflineMapView(cachedPois: cachedPois, lastSyncAt: lastSyncAt),
    MapNoPermission(:final permission) => NoPermissionView(permission: permission),
  };
}
```

---

## 11. 性能与启动

### 11.1 启动流程

```dart
// main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _bootstrap();
  runApp(const SightourApp());
}

Future<void> _bootstrap() async {
  // 1. 初始化 Hive（< 50ms）
  await Hive.initFlutter();
  await Hive.openBoxes([...]);
  
  // 2. 初始化 DI（< 100ms）
  await configureDependencies();
  
  // 3. 预加载字体
  await Future.wait([
    loadAppFonts(),
  ]);
  
  // 4. 读取用户偏好（同步，可 < 10ms）
  final prefs = await _prefsRepo.getPreferences();
  await _localeController.set(prefs.language);
}
```

### 11.2 启动时间目标

| 阶段 | 目标 | 实测 |
| --- | --- | --- |
| 冷启动到首屏 | < 1500ms | TBD |
| 首屏到可交互 | < 500ms | TBD |
| 离线包下载（240MB） | < 60s on WiFi | TBD |

### 11.3 性能预算

| 指标 | 目标 |
| --- | --- |
| 屏间切换 | < 200ms |
| 列表滚动 FPS | 60fps |
| 内存占用 | < 200MB |
| APK 大小 | < 50MB |
| 离线包大小 | < 250MB |

### 11.4 性能优化

- **图片缓存**：cached_network_image
- **长列表**：ListView.builder + itemExtent
- **动效**：用 AnimatedSwitcher 避免 rebuild
- **日志**：release 关闭 debug 日志
- **代码分割**：按 feature 拆包（Flutter deferred components）

---

## 12. 测试策略

### 12.1 三层测试

| 层 | 工具 | 覆盖率目标 | 重点 |
| --- | --- | --- | --- |
| 单元 | flutter_test | 80% | BLoC、UseCase、Repository |
| Widget | flutter_test | 60% | Page 级组件 |
| 集成 | integration_test | 关键路径 | 5 个核心 Journey |

### 12.2 BLoC 测试模板

```dart
// test/features/map/presentation/bloc/map_bloc_test.dart
void main() {
  late MapBloc bloc;
  late MockMapRepository mockRepo;
  late MockNetworkInfo mockNetwork;

  setUp(() {
    mockRepo = MockMapRepository();
    mockNetwork = MockNetworkInfo();
    bloc = MapBloc(
      getPois: GetPois(mockRepo),
      networkInfo: mockNetwork,
    );
  });

  blocTest<MapBloc, MapState>(
    'emits [loading, success] when MapLoaded and data available',
    build: () {
      when(() => mockNetwork.isConnected).thenAnswer((_) async => true);
      when(() => mockRepo.getPois()).thenAnswer(
        (_) async => Right([tPoi1, tPoi2]),
      );
      return bloc;
    },
    act: (b) => b.add(const MapEvent.loaded()),
    expect: () => [
      const MapState.loading(),
      MapState.success(pois: [tPoi1, tPoi2], ...),
    ],
  );
}
```

### 12.3 Widget 测试

```dart
testWidgets('MapPage shows skeleton when loading', (tester) async {
  await tester.pumpWidget(
    BlocProvider(
      create: (_) => mockMapBloc..emit(const MapState.loading()),
      child: const MaterialApp(home: MapPage()),
    ),
  );
  expect(find.byType(MapSkeleton), findsOneWidget);
});
```

### 12.4 集成测试

每个 Journey 一个集成测试：

```dart
// integration_test/journey_1_pre_arrival_test.dart
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  
  testWidgets('Journey 1: Pre-arrival preparation', (tester) async {
    await tester.pumpWidget(const SightourApp());
    
    // 1. 启动 → Onboarding
    expect(find.text('Travel smarter in China'), findsOneWidget);
    
    // 2. 进入语言选择
    await tester.tap(find.text('Get started'));
    await tester.pumpAndSettle();
    expect(find.text('English'), findsOneWidget);
    
    // 3. 选语言 → 进入 Prepare
    await tester.tap(find.text('English'));
    await tester.pumpAndSettle();
    expect(find.text('Filter by nationality'), findsOneWidget);
    
    // ... 验证完整流程
  });
}
```

---

## 13. 代码规范与 CI

### 13.1 Lint 规则

```yaml
# analysis_options.yaml
analyzer:
  strong-mode:
    implicit-casts: false
    implicit-dynamic: false
  errors:
    invalid_annotation_target: ignore
  exclude:
    - "**/*.g.dart"
    - "**/*.freezed.dart"
    
linter:
  rules:
    - always_declare_return_types
    - avoid_print
    - avoid_relative_lib_imports
    - prefer_const_constructors
    - prefer_const_declarations
    - prefer_final_locals
    - sort_child_properties_last
    - unawaited_futures
    - use_super_parameters
```

### 13.2 Pre-commit Hooks

```yaml
# .pre-commit-config.yaml
repos:
  - repo: local
    hooks:
      - id: format
        name: Format
        entry: dart format
        language: system
        types: [dart]
      - id: analyze
        name: Analyze
        entry: dart analyze
        language: system
        types: [dart]
      - id: test
        name: Unit tests
        entry: flutter test
        language: system
        types: [dart]
```

### 13.3 CI 流水线（GitHub Actions）

```yaml
# .github/workflows/ci.yml
name: CI
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: dart format --set-exit-if-changed lib test
      - run: flutter analyze
      - run: flutter test --coverage
      - uses: codecov/codecov-action@v3
```

---

## 14. 安全与隐私

### 14.1 隐私合规

| 要求 | 实现 |
| --- | --- |
| 最小权限申请 | 定位 / 通知 / 相机，仅在需要时申请 |
| 用户可关闭定位 | Map 屏「Search by name」降级方案 |
| 离线包不包含 PII | 离线包中 POI 数据无用户标识 |
| 日志脱敏 | 释放版本不打印用户输入 |

### 14.2 数据安全

| 数据 | 保护 |
| --- | --- |
| 离线包 | AES-256 加密存储 |
| Token | FlutterSecureStorage（Keychain / Keystore） |
| 草稿 | 明文（不含敏感） |
| 日志 | dev 详细，release 仅 error |

### 14.3 网络安全

- 强制 HTTPS
- 证书锁定（生产环境）
- 请求签名（P0 Mock 阶段可略）

---

## 15. 关键设计决策汇总

| 决策 | 理由 | 替代方案 |
| --- | --- | --- |
| BLoC | 状态机契合、团队熟悉 | Provider / Riverpod |
| go_router | 官方维护、deep link 友好 | auto_route |
| dio | 拦截器易切 Mock → Real | http |
| hive | 启动快、纯 Dart | sqflite / isar |
| freezed | Sealed class = 状态机 | 手写 |
| 高德 Flutter SDK | 合规、官方维护 | Google Maps |
| Clean Architecture Lite | 业务可测、依赖清晰 | MVC / MVVM |

---

## 附录 A · 关键依赖清单

```yaml
# pubspec.yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter
  
  # 状态管理
  flutter_bloc: ^8.1.6
  equatable: ^2.0.5
  
  # 路由
  go_router: ^14.2.0
  
  # 网络
  dio: ^5.7.0
  
  # 本地存储
  hive_ce: ^2.10.0
  hive_ce_flutter: ^2.2.0
  flutter_secure_storage: ^9.2.2
  
  # 序列化
  freezed_annotation: ^2.4.4
  json_annotation: ^4.9.0
  
  # 国际化
  intl: ^0.19.0
  
  # 工具
  logger: ^2.4.0
  get_it: ^7.7.0
  injectable: ^2.5.0
  sentry_flutter: ^8.5.0
  
  # 地图（高德）
  amap_flutter_map: ^3.0.0
  amap_flutter_location: ^3.0.0
  
  # UI
  cached_network_image: ^3.4.0
  flutter_svg: ^2.0.10
  
dev_dependencies:
  flutter_test:
    sdk: flutter
  bloc_test: ^9.1.7
  mocktail: ^1.0.4
  build_runner: ^2.4.13
  freezed: ^2.5.7
  json_serializable: ^6.8.0
  injectable_generator: ^2.6.2
  integration_test:
    sdk: flutter
```

---

## 附录 B · 屏 → BLoC → Repository 映射

| 屏 | BLoC | Repository | 关键 UseCase |
| --- | --- | --- | --- |
| Welcome | OnboardingBloc | OnboardingRepository | CompleteOnboarding |
| Language | LanguageBloc | PreferencesRepository | SetLanguage |
| Prepare Home | PrepareHomeBloc | PolicyRepository | GetPoliciesByNationality |
| Policy Detail | PolicyDetailBloc | PolicyRepository | GetPolicyById |
| Checklist | ChecklistBloc | ChecklistRepository | GetChecklist / ToggleItem |
| Map | MapBloc | MapRepository | SearchPois / GetNearbyPois |
| POI Detail | PoiDetailBloc | PoiRepository | GetPoiDetail |
| Reputation | ReputationBloc | PoiRepository | GetPoiReputation |
| Discover | DiscoverBloc | DiscoverRepository | GetRankedList |
| Tools Hub | (无状态) | — | — |
| FX | FxBloc | FxRepository | GetRates / Convert |
| Phrases | PhrasesBloc | PhraseRepository | GetPhrases |
| Emergency | EmergencyBloc | EmergencyRepository | GetContacts |
| Profile | ProfileBloc | PreferencesRepository | GetPreferences / UpdatePref |
| Correction | CorrectionBloc | CorrectionRepository | SubmitCorrection |

**总计**：14 个 BLoC、12 个 Repository

---

## 附录 C · 与各文档交叉引用

| 主题 | 关联文档 | 章节 |
| --- | --- | --- |
| 屏清单 | IA | §1 |
| 路由表 | IA | §3 |
| 6 状态 | States Spec | §1 |
| 设计 Token | Design System | §1 |
| 组件库 | Design System | §2 |
| Persona | Personas | 全部 |
| Journey | User Journeys | 全部 |
| Mock 数据 | 本文档 §6 | — |

---

## 附录 D · Mock 数据集规划

为支撑完整功能，Mock 数据集需包含：

| 数据集 | 数量 | 文件 |
| --- | --- | --- |
| POI（上海） | 200 条 | `mock/pois.json` |
| POI 评分 | 200 × 5 维 = 1000 | 嵌入 pois.json |
| 5 维评分详情 | 200 条 | `mock/poi_reputations.json` |
| Discover 榜单 | 3 分类 × 50 条 = 150 | `mock/discover.json` |
| 政策 | 12 国 × 4 类 = 48 | `mock/policies.json` |
| 常用语 | 5 类 × 30 = 150 | `mock/phrases.json` |
| 紧急联系 | 12 类别 | `mock/emergency.json` |
| 汇率 | 12 币种 | `mock/fx_rates.json` |
| 行前清单 | 7 项 | `mock/checklist.json` |
| 用户偏好 | 1 套默认值 | `mock/preferences.json` |

**Mock 文件位置**：`app/lib/core/network/mock/`

---

## 附录 E · 待后续补充

1. **P1 暗色模式完整 Token**（设计系统已有 §1.1.4 预留）
2. **P1 Deep Link 配置**（Universal Links / App Links）
3. **后端 NestJS 架构**（独立文档）
4. **CI/CD 详细配置**（TestFlight / Google Play 自动发布）
5. **监控与告警**（Sentry 配置、崩溃率阈值）
6. **A/B 测试框架**（Firebase Remote Config / 自建）

---

## 附录 F · 文档变更日志

| 版本 | 日期 | 变更 |
| --- | --- | --- |
| v1.0 | 2026-06-26 | 首版发布。15 节完整前端架构 + Mock 数据集规划。 |
| （未来） | | |
