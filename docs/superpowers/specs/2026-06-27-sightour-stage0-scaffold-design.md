# Sightour 阶段零脚手架设计（Scaffold Design）

> **文档类型**：技术脚手架设计
> **阶段**：MVP 阶段零（基础搭建，Week 1）
> **范围**：MVP 计划 Task 1–5（Monorepo / Flutter APP / NestJS / Admin / CI）
> **版本**：v1.0 — 2026-06-27
> **作者**：Brainstorming 工作流输出
> **关联文档**：
> - [MVP 实施计划](file:///c:/Users/wenmo/.trae-cn/worktrees/旅游app/docs/superpowers/plans/2026-06-26-sightour-mvp.md) — 上游计划（Task 1–5）
> - [前端架构规范](file:///c:/Users/wenmo/.trae-cn/worktrees/旅游app/docs/superpowers/specs/2026-06-26-sightour-frontend-architecture.md) — 选型与目录骨架
> - [状态设计规范](file:///c:/Users/wenmo/.trae-cn/worktrees/旅游app/docs/superpowers/specs/2026-06-26-sightour-states-spec.md) — 下一阶段用
> - [设计系统](file:///c:/Users/wenmo/.trae-cn/worktrees/旅游app/docs/superpowers/specs/2026-06-26-sightour-design-system.md) — 主题 Token 来源

---

## 0. 文档元信息

### 用途
本设计定义 Sightour 项目阶段零（5 个 Task）的完整脚手架：仓库布局、Flutter APP、NestJS 后端、React Admin、CI 流水线。目的是**让下一阶段（系统基础 i18n/主题/路由/网络/存储）有可直接使用的工程底座**。

### 读者
- Flutter 工程师（主读者）
- 后端工程师（NestJS 部分）
- 全栈 / DevOps（CI 与 Monorepo 部分）

### 设计原则
1. **以 Architecture Spec 为准**：所有选型遵循 2026-06-26 的前端架构规范（freezed、hive_ce、get_it+injectable、Clean Architecture Lite）；MVP Plan 是更早的概览，作为范围参考。
2. **目录骨架一次到位**：阶段二直接开干 feature，不为迁移付出代价。
3. **可空跑不报错**：脚手架在本机可通过 `dart analyze` + `flutter test` + `npm install` 验证，不实现真实业务。
4. **业务零侵入**：所有占位都是 `// TODO stage-N` 注释，不写伪业务。

---

## 1. 已确认的关键决策（来自 Brainstorming）

| 决策点 | 选定 | 备选 | 理由 |
| --- | --- | --- | --- |
| 范围 | 阶段零 Task 1–5 | 阶段一 / 全部 MVP / 单切片 | 范围聚焦，可 1 周内交付可运行底座 |
| Git 策略 | 当前目录 `git init` + 提交已有 docs/ 与 prototype/ | 不初始化 / 跳过 git | 工作目录是 worktree 但当前非 git 仓库；先 init 再提交 |
| 验证深度 | Flutter 跑 `dart analyze` + `flutter test`；后端/Admin 跑 `npm install` | 完整 build / 含 iOS run | 用户在 Android 端测试；iOS 需 macOS 后续验证 |
| 脚手架范围 | 5 个 Task 全建（含后端/Admin/CI） | 仅 Flutter | 用户选「全部 5 个 Task」 |
| 技术栈 | 以 Architecture Spec 为准（hive_ce/freezed/get_it+injectable/intl/Clean Lite） | 严格按 MVP Plan / 极简 | Spec 比 Plan 更新且有 ADR |

---

## 2. Section 1 — 仓库布局与 Git

### 2.1 顶层目录结构

```
sightour/                          # 工作根目录
├── app/                            # Flutter APP（Task 2）
├── backend/                        # NestJS（Task 3）
├── admin/                          # React 后台（Task 4）
├── content-ops/                    # PGC 脚本（占位，README + 3 个子目录）
│   ├── poi-template/
│   ├── policy-template/
│   └── rank-template/
├── deploy/                         # 部署占位
│   └── docker-compose.yml          # 仅声明，未启动
├── docs/                           # 已有（specs + plans + 后续补 compliance/operations）
├── prototype/                      # 已有
├── .github/
│   └── workflows/                  # CI 3 个 workflow
├── .gitignore
├── .editorconfig
├── .gitattributes
└── README.md
```

### 2.2 Git 初始化步骤

1. `git init -b main`
2. 配置本地 `user.name` / `user.email`（**仅当缺失时**，使用 `git config user.name "Sightour Bot"` 与 `scaffold@sightour.local`，不修改全局配置）
3. 写 `.gitignore` / `.editorconfig` / `.gitattributes`
4. 首次 commit：`docs: import existing specs/plans and prototype`
5. 每完成一个 Task → 1 个 commit（conventional commit）

### 2.3 .gitignore 关键规则

- **Flutter**：`build/` `.dart_tool/` `.flutter-plugins` `.flutter-plugins-dependencies` `.packages` `.pub-cache/` `.pub/` `coverage/` `*.iml` `.idea/` `*.lock-info` `**/ios/Pods/` `**/ios/.symlinks/` `**/macos/Pods/` `**/macos/Flutter/ephemeral/`
- **Node**：`node_modules/` `dist/` `build/` `.env` `.env.*` `*.log` `coverage/` `.next/` `out/`
- **IDE**：`.vscode/`（保留 `extensions.json` 推荐）`.idea/`
- **OS**：`.DS_Store` `Thumbs.db` `desktop.ini`
- **Java 工具链**：`*.class` `*.jar` `hs_err_pid*`

### 2.4 .editorconfig 关键规则

```
root = true
[*]
charset = utf-8
end_of_line = lf
indent_style = space
indent_size = 2
insert_final_newline = true
trim_trailing_whitespace = true
[*.md]
trim_trailing_whitespace = false
[*.{dart,ts,tsx,js,jsx}]
quote_type = single
```

### 2.5 .gitattributes 关键规则

```
* text=auto eol=lf
*.png binary
*.jpg binary
*.jpeg binary
*.gif binary
*.ico binary
*.woff2 binary
*.ttf binary
*.otf binary
```

---

## 3. Section 2 — Flutter APP 脚手架（Task 2）

### 3.1 创建命令

```bash
flutter create app \
  --org com.sightour \
  --project-name sightour \
  --platforms=ios,android \
  --description "Sightour — Shanghai travel companion for foreign visitors"
```

预期产物：`app/pubspec.yaml`、`app/lib/main.dart`、`app/android/`、`app/ios/`、`app/test/widget_test.dart`、`app/analysis_options.yaml`、`app/.metadata`。

### 3.2 pubspec.yaml 依赖

**运行时依赖**（版本参考 Architecture Spec 附录 A，可根据 pub.dev 最新 stable 调整 minor）：

| 类别 | 包 | 版本约束 |
| --- | --- | --- |
| 状态管理 | `flutter_bloc` | `^8.1.6` |
| 状态管理 | `bloc` | `^8.1.4` |
| 状态管理 | `equatable` | `^2.0.5` |
| 路由 | `go_router` | `^14.2.0` |
| 网络 | `dio` | `^5.7.0` |
| 本地存储 | `hive_ce` | `^2.10.0` |
| 本地存储 | `hive_ce_flutter` | `^2.2.0` |
| 加密 | `flutter_secure_storage` | `^9.2.2` |
| 序列化 | `freezed_annotation` | `^2.4.4` |
| 序列化 | `json_annotation` | `^4.9.0` |
| 函数式 | `dartz` | `^0.10.1` |
| 国际化 | `intl` | `^0.19.0` |
| DI | `get_it` | `^7.7.0` |
| DI | `injectable` | `^2.5.0` |
| 日志 | `logger` | `^2.4.0` |
| 错误 | `sentry_flutter` | `^8.5.0` |
| 工具 | `package_info_plus` | latest |
| 工具 | `shared_preferences` | latest |
| 地图 | `amap_flutter_map` | `^3.0.0`（如失败降级 `^2.0.0`） |
| 地图 | `amap_flutter_location` | `^3.0.0` |
| UI | `cached_network_image` | `^3.4.0` |
| UI | `flutter_svg` | `^2.0.10` |

**dev_dependencies**：

| 包 | 版本 |
| --- | --- |
| `flutter_test` | sdk |
| `bloc_test` | `^9.1.7` |
| `mocktail` | `^1.0.4` |
| `build_runner` | `^2.4.13` |
| `freezed` | `^2.5.7` |
| `json_serializable` | `^6.8.0` |
| `injectable_generator` | `^2.6.2` |

**SDK 约束**：`sdk: '>=3.4.0 <4.0.0'`、`flutter: '>=3.24.0'`。

**assets 占位声明**（本阶段不创建文件，下一阶段补）：
```yaml
flutter:
  uses-material-design: true
  # assets:
  #   - assets/i18n/
  #   - assets/images/
  #   - assets/fonts/
  #   - assets/content/
```

### 3.3 lib 目录结构

按 Architecture Spec §2.2 一次到位建空目录（每层含 `.gitkeep` 占位）：

```
app/lib/
├── main.dart
├── app.dart
├── core/
│   ├── constants/
│   ├── errors/
│   ├── extensions/
│   ├── utils/
│   ├── di/
│   ├── router/
│   ├── theme/
│   ├── i18n/
│   ├── network/
│   ├── storage/
│   ├── offline/
│   ├── permissions/
│   └── analytics/
├── features/
│   ├── onboarding/{data,domain,presentation/bloc,presentation/pages,presentation/widgets}/
│   ├── prepare/{data,domain,presentation/bloc,presentation/pages,presentation/widgets}/
│   ├── map/{data,domain,presentation/bloc,presentation/pages,presentation/widgets}/
│   ├── discover/{data,domain,presentation/bloc,presentation/pages,presentation/widgets}/
│   ├── tools/{data,domain,presentation/bloc,presentation/pages,presentation/widgets}/
│   ├── you/{data,domain,presentation/bloc,presentation/pages,presentation/widgets}/
│   ├── poi/{data,domain,presentation/bloc,presentation/pages,presentation/widgets}/
│   ├── emergency/{data,domain,presentation/bloc,presentation/pages,presentation/widgets}/
│   └── correction/{data,domain,presentation/bloc,presentation/pages,presentation/widgets}/
├── shared/
│   ├── widgets/
│   ├── models/
│   └── mixins/
└── l10n/
```

> 备注：`.gitkeep` 仅用于本阶段以保留空目录，下一阶段实际写文件时删除。

### 3.4 analysis_options.yaml

按 Architecture Spec §13.1：

```yaml
analyzer:
  strong-mode:
    implicit-casts: false
    implicit-dynamic: false
  errors:
    invalid_annotation_target: ignore
  exclude:
    - "**/*.g.dart"
    - "**/*.freezed.dart"
    - "**/*.config.dart"

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

### 3.5 main.dart 占位

```dart
// lib/main.dart
import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'app.dart';
import 'core/di/injection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await configureDependencies();
  runApp(const SightourApp());
}
```

### 3.6 app.dart 占位

```dart
// lib/app.dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

class SightourApp extends StatelessWidget {
  const SightourApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Sightour',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      routerConfig: appRouter,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('zh')],
    );
  }
}
```

### 3.7 路由占位

`app/lib/core/router/app_router.dart`：

```dart
import 'package:go_router/go_router.dart';
import '../../features/onboarding/presentation/pages/home_page.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (_, __) => const HomePage(),
    ),
  ],
);
```

### 3.8 HomePage 占位

`app/lib/features/onboarding/presentation/pages/home_page.dart`（虽在 onboarding feature 下，但本阶段是占位）：

```dart
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sightour')),
      body: Center(
        child: FutureBuilder<PackageInfo>(
          future: PackageInfo.fromPlatform(),
          builder: (_, snap) {
            final v = snap.data?.version ?? '0.0.0';
            return Text(
              'Sightour scaffold ready · v$v',
              style: Theme.of(context).textTheme.titleMedium,
            );
          },
        ),
      ),
    );
  }
}
```

### 3.9 主题占位

`app/lib/core/theme/app_theme.dart`：

- `AppTheme.light()` / `AppTheme.dark()` 各返回一个 `ThemeData`（useMaterial3: true）
- 颜色取自 Architecture Spec §9.2 的 Token（slate900 / blue600 / sand500 / sage600 等），作为 `ColorScheme` 绑定
- 字号 / 间距 / 圆角暂用 Material 默认（下一阶段 Task 7 完善）

### 3.10 DI 占位

`app/lib/core/di/injection.dart`：

```dart
import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;

Future<void> configureDependencies() async {
  // TODO(stage-1): register blocs, repositories, datasources
}
```

### 3.11 widget 测试

`app/test/widget_test.dart`（替换 flutter create 默认）：

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sightour/features/onboarding/presentation/pages/home_page.dart';

void main() {
  testWidgets('HomePage renders scaffold ready text', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: HomePage()),
    );
    await tester.pump();  // 让 FutureBuilder 完成
    expect(find.textContaining('Sightour scaffold ready'), findsOneWidget);
  });
}
```

### 3.12 Android 配置

- `app/android/app/build.gradle`：`minSdkVersion 26`、`targetSdkVersion 34`、`compileSdkVersion 34`
- 不引入高德 Key（占位注释）
- 权限：`INTERNET`（默认已有）、`ACCESS_FINE_LOCATION`（注释预留给地图）

### 3.13 iOS 配置

- `app/ios/Podfile`：`platform :ios, '14.0'`
- `app/ios/Runner/Info.plist`：
  - `CFBundleLocalizations = [en, zh-Hans]`
  - `NSLocationWhenInUseUsageDescription` 预填（占位英文文案）
  - 不引入高德 Key

---

## 4. Section 3 — 后端与 Admin 脚手架（Task 3 + Task 4）

### 4.1 NestJS 后端（`backend/`）

#### 4.1.1 创建命令

```bash
nest new backend --package-manager npm --skip-git
```

#### 4.1.2 核心依赖

**运行时**：

| 包 | 用途 |
| --- | --- |
| `@nestjs/typeorm` `typeorm` `pg` | ORM + PostgreSQL |
| `ioredis` | Redis 客户端 |
| `minio` | 对象存储 |
| `class-validator` `class-transformer` | DTO 校验 |
| `helmet` `compression` | 安全 / 压缩 |
| `@nestjs/jwt` `passport` `passport-jwt` | 鉴权（占位） |
| `@nestjs/swagger` | API 文档 |
| `@nestjs/terminus` | 健康检查 |
| `@nestjs/config` | 配置 |
| `rxjs` `reflect-metadata` | Nest 必需 |

**devDependencies**：

| 包 | 用途 |
| --- | --- |
| `@nestjs/cli` `@nestjs/schematics` `@nestjs/testing` | Nest 工具链 |
| `jest` `@types/jest` `ts-jest` `supertest` | 测试 |
| `@types/express` `@types/node` `@types/passport-jwt` | 类型 |
| `typescript` `ts-node` `ts-loader` `tsconfig-paths` | TS 工具链 |
| `prettier` `eslint` `@typescript-eslint/*` | 规范 |
| `source-map-support` `uuid` | 调试 / 工具 |

#### 4.1.3 目录结构

```
backend/src/
├── main.ts
├── app.module.ts
├── app.controller.ts           # / 通配
├── app.service.ts
├── common/
│   ├── filters/
│   ├── interceptors/
│   ├── guards/
│   └── decorators/
├── config/
│   ├── database.config.ts
│   ├── redis.config.ts
│   └── minio.config.ts
└── modules/
    ├── policy/{policy.module.ts,policy.controller.ts,policy.service.ts}/
    ├── poi/{poi.module.ts,poi.controller.ts,poi.service.ts}/
    ├── reputation/{reputation.module.ts,reputation.controller.ts,reputation.service.ts}/
    ├── checklist/{checklist.module.ts,checklist.controller.ts,checklist.service.ts}/
    ├── correction/{correction.module.ts,correction.controller.ts,correction.service.ts}/
    ├── user/{user.module.ts,user.controller.ts,user.service.ts}/
    ├── content-pack/{content-pack.module.ts,content-pack.controller.ts,content-pack.service.ts}/
    └── health/{health.module.ts,health.controller.ts}/
```

每个 controller 暴露一个 `GET /api/v1/<resource>` 返回 `{ data: [] }` 占位。

#### 4.1.4 app.module.ts

```typescript
@Module({
  imports: [
    ConfigModule.forRoot({ isGlobal: true }),
    TypeOrmModule.forRootAsync({
      inject: [ConfigService],
      useFactory: (c: ConfigService) => ({
        type: 'postgres',
        host: c.get('DB_HOST', 'localhost'),
        port: c.get('DB_PORT', 5432),
        username: c.get('DB_USER', 'sightour'),
        password: c.get('DB_PASS', 'sightour'),
        database: c.get('DB_NAME', 'sightour'),
        entities: [__dirname + '/**/*.entity{.ts,.js}'],
        synchronize: false,  // 显式迁移，dev 阶段不开 auto
        autoLoadEntities: true,
      }),
    }),
    TerminusModule,
    PolicyModule, PoiModule, ReputationModule, ChecklistModule,
    CorrectionModule, UserModule, ContentPackModule, HealthModule,
  ],
})
export class AppModule {}
```

#### 4.1.5 main.ts

```typescript
async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  app.use(helmet());
  app.use(compression());
  app.enableCors({ origin: true, credentials: true });
  app.useGlobalPipes(new ValidationPipe({ transform: true, whitelist: true }));
  app.setGlobalPrefix('api/v1');
  const config = new DocumentBuilder()
    .setTitle('Sightour API')
    .setVersion('0.1.0')
    .build();
  const document = SwaggerModule.createDocument(app, config);
  SwaggerModule.setup('api/docs', app, document);
  await app.listen(3000);
}
bootstrap();
```

#### 4.1.6 /health 端点

不接 DB，使用 `TerminusModule` 自带 `MemoryHealthIndicator`：

```typescript
@Controller('health')
export class HealthController {
  constructor(private health: HealthCheckService, private memory: MemoryHealthIndicator) {}

  @Get()
  @HealthCheck()
  check() {
    return this.health.check([
      () => this.memory.checkHeap('memory_heap', 200 * 1024 * 1024),
    ]);
  }
}
```

返回 `{ status: 'ok', info: { memory_heap: { status: 'up' } } }`。

#### 4.1.7 .env.example

```env
NODE_ENV=development
PORT=3000

DB_HOST=localhost
DB_PORT=5432
DB_USER=sightour
DB_PASS=sightour
DB_NAME=sightour

REDIS_HOST=localhost
REDIS_PORT=6379

MINIO_ENDPOINT=localhost
MINIO_PORT=9000
MINIO_ACCESS_KEY=sightour
MINIO_SECRET_KEY=sightour
MINIO_BUCKET=sightour

JWT_SECRET=changeme
```

### 4.2 React Admin 后台（`admin/`）

#### 4.2.1 创建命令

```bash
npm create vite@latest admin -- --template react-ts
```

#### 4.2.2 核心依赖

| 包 | 用途 |
| --- | --- |
| `react` `react-dom` | 框架 |
| `react-router-dom` | 路由 |
| `antd` | 组件库 |
| `@ant-design/icons` | 图标 |
| `@ant-design/pro-components` | ProLayout 等 |
| `axios` | HTTP |
| `zustand` | 状态 |

devDependencies：`typescript`、`vite`、`@vitejs/plugin-react`、`@types/react`、`@types/react-dom`、`eslint`、`prettier`、`@typescript-eslint/*`。

#### 4.2.3 目录结构

```
admin/src/
├── main.tsx
├── App.tsx
├── router/
│   └── index.tsx
├── pages/
│   ├── Login/
│   │   └── index.tsx
│   └── Dashboard/
│       └── index.tsx
├── components/
│   └── ProtectedRoute.tsx
├── services/
│   └── http.ts                  # axios 封装
├── store/
│   └── authStore.ts             # zustand 占位
└── types/
    └── index.ts
```

#### 4.2.4 App.tsx + Router

`/` 重定向 `/dashboard`（受保护）；`/login` 公开。`ProtectedRoute` 检查 `authStore.isAuthed`，未登录跳 `/login`。

#### 4.2.5 LoginPage 骨架

```tsx
// pages/Login/index.tsx
import { Form, Input, Button, Card, message } from 'antd';
import { useAuthStore } from '../../store/authStore';
import { useNavigate } from 'react-router-dom';

export default function LoginPage() {
  const navigate = useNavigate();
  const setAuth = useAuthStore(s => s.setAuth);

  const onFinish = (values: { username: string; password: string }) => {
    // TODO(stage-1): replace with real auth
    if (values.username && values.password) {
      setAuth({ username: values.username, token: 'mock-token' });
      message.success('Logged in (MVP mock)');
      navigate('/dashboard');
    }
  };

  return (
    <div style={{ minHeight: '100vh', display: 'flex', alignItems: 'center', justifyContent: 'center', background: '#f0f2f5' }}>
      <Card title="Sightour Admin · Login" style={{ width: 360 }}>
        <Form layout="vertical" onFinish={onFinish}>
          <Form.Item label="Username" name="username" rules={[{ required: true }]}>
            <Input />
          </Form.Item>
          <Form.Item label="Password" name="password" rules={[{ required: true }]}>
            <Input.Password />
          </Form.Item>
          <Form.Item>
            <Button type="primary" htmlType="submit" block>Sign in</Button>
          </Form.Item>
        </Form>
      </Card>
    </div>
  );
}
```

#### 4.2.6 DashboardPage 骨架

```tsx
// pages/Dashboard/index.tsx
import { ProLayout } from '@ant-design/pro-components';

export default function DashboardPage() {
  return (
    <ProLayout
      title="Sightour Admin"
      layout="mix"
      menu={{ defaultOpenAll: true }}
      location={{ pathname: '/dashboard' }}
      route={{
        path: '/dashboard',
        routes: [
          { path: '/dashboard', name: 'Overview' },
          { path: '/dashboard/poi', name: 'POI Management' },
          { path: '/dashboard/policy', name: 'Policy' },
          { path: '/dashboard/rank', name: 'Ranks' },
          { path: '/dashboard/correction', name: 'Corrections' },
        ],
      }}
    >
      <div style={{ padding: 24 }}>
        <h1>Sightour Admin · v0.1</h1>
        <p>Stage 0 scaffold. Modules wired in Stage 3 (Task 34).</p>
      </div>
    </ProLayout>
  );
}
```

侧边栏路由**只声明，不实现子页面**（业务在 Task 34）。

#### 4.2.7 authStore.ts

```ts
import { create } from 'zustand';
import { persist } from 'zustand/middleware';

type AuthState = {
  user: { username: string; token: string } | null;
  isAuthed: boolean;
  setAuth: (u: { username: string; token: string }) => void;
  clear: () => void;
};

export const useAuthStore = create<AuthState>()(
  persist(
    (set) => ({
      user: null,
      isAuthed: false,
      setAuth: (u) => set({ user: u, isAuthed: true }),
      clear: () => set({ user: null, isAuthed: false }),
    }),
    { name: 'sightour-admin-auth' },
  ),
);
```

### 4.3 PGC 内容生产占位

`content-ops/`：

```
content-ops/
├── README.md                     # 简介：阶段三 PGC 流水线入口
├── poi-template/README.md
├── policy-template/README.md
└── rank-template/README.md
```

每个 README 只写一段「**阶段三占位，模板将由内容运营同学在此维护**」。

### 4.4 Deploy 占位

`deploy/docker-compose.yml`：

```yaml
version: '3.9'
services:
  postgres:
    image: postgres:15-alpine
    environment:
      POSTGRES_USER: sightour
      POSTGRES_PASSWORD: sightour
      POSTGRES_DB: sightour
    ports: ['5432:5432']
    volumes: ['pgdata:/var/lib/postgresql/data']
  redis:
    image: redis:7-alpine
    ports: ['6379:6379']
  minio:
    image: minio/minio:latest
    command: server /data --console-address ":9001"
    environment:
      MINIO_ROOT_USER: sightour
      MINIO_ROOT_PASSWORD: sightour
    ports: ['9000:9000', '9001:9001']
    volumes: ['miniodata:/data']
volumes:
  pgdata:
  miniodata:
```

**本阶段不启动**（用户机器上未必有 Docker）。

---

## 5. Section 4 — CI 流水线与验证

### 5.1 .github/workflows/

#### app-ci.yml

```yaml
name: app-ci
on:
  push:
    paths: ['app/**', '.github/workflows/app-ci.yml']
  pull_request:
    paths: ['app/**', '.github/workflows/app-ci.yml']
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          channel: stable
          cache: true
      - working-directory: app
        run: flutter pub get
      - working-directory: app
        run: dart format --set-exit-if-changed lib test
      - working-directory: app
        run: flutter analyze
      - working-directory: app
        run: flutter test --coverage
      - uses: actions/upload-artifact@v4
        with:
          name: coverage
          path: app/coverage/lcov.info
```

> `flutter build apk --debug` 不加入本阶段 CI（避免 10+ 分钟 build；下阶段再补）。

#### backend-ci.yml

```yaml
name: backend-ci
on:
  push:
    paths: ['backend/**', '.github/workflows/backend-ci.yml']
  pull_request:
    paths: ['backend/**', '.github/workflows/backend-ci.yml']
jobs:
  build:
    runs-on: ubuntu-latest
    services:
      postgres:
        image: postgres:15-alpine
        env:
          POSTGRES_USER: sightour
          POSTGRES_PASSWORD: sightour
          POSTGRES_DB: sightour_test
        ports: ['5432:5432']
        options: --health-cmd pg_isready --health-interval 10s --health-timeout 5s --health-retries 5
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with: { node-version: '20', cache: 'npm', cache-dependency-path: backend/package-lock.json }
      - working-directory: backend
        run: npm ci
      - working-directory: backend
        run: npm run lint
      - working-directory: backend
        run: npm run build
      - working-directory: backend
        run: npm test
        env:
          DB_HOST: localhost
          DB_PORT: 5432
          DB_USER: sightour
          DB_PASS: sightour
          DB_NAME: sightour_test
```

#### admin-ci.yml

```yaml
name: admin-ci
on:
  push:
    paths: ['admin/**', '.github/workflows/admin-ci.yml']
  pull_request:
    paths: ['admin/**', '.github/workflows/admin-ci.yml']
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with: { node-version: '20', cache: 'npm', cache-dependency-path: admin/package-lock.json }
      - working-directory: admin
        run: npm ci
      - working-directory: admin
        run: npm run lint
      - working-directory: admin
        run: npm run build
```

### 5.2 本机验证步骤

| # | 命令 | 期望 |
| --- | --- | --- |
| 1 | `cd app && flutter --version` | 3.24+ |
| 2 | `cd app && flutter pub get` | 0 errors, 生成 `pubspec.lock` |
| 3 | `cd app && dart analyze` | `No issues found!` |
| 4 | `cd app && flutter test` | `All tests passed!`（1 passed） |
| 5 | `cd backend && npm install` | 0 errors, 生成 `package-lock.json` |
| 6 | `cd admin && npm install` | 0 errors, 生成 `package-lock.json` |

不跑：
- `flutter run`（Windows 不可跑 iOS，Android 模拟器由用户后续开）
- `nest start` / `vite preview`（业务未实现）
- `docker compose up`（用户机器无 Docker）

### 5.3 提交策略（6 个 commit）

```
docs: import existing specs/plans and prototype
chore: init monorepo layout, .gitignore, .editorconfig
chore(scaffold): bootstrap flutter app
chore(scaffold): bootstrap nestjs backend
chore(scaffold): bootstrap vite admin console
ci: add github actions for app/backend/admin
```

每个 commit 粒度保持「可独立 revert / cherry-pick」。

---

## 6. 范围外（明确不做）

- ❌ 不接高德 Key（Map Kit Key）
- ❌ 不实现 `/health` 业务（仅内存健康检查）
- ❌ 不接真实 DB（TypeORM 配 localhost，运行时连不上不影响 build）
- ❌ 不写业务测试（仅 home_page_test）
- ❌ 不创建 ARB 文件（阶段一 Task 6）
- ❌ 不引入 feature 业务代码（仅空目录占位）
- ❌ 不配置 sentry DSN
- ❌ Admin 登录功能不做实际鉴权（前端 alert 占位）
- ❌ iOS / Android 真机或模拟器验证（用户后续）
- ❌ Docker compose 启动（用户机器无 Docker）
- ❌ 不写 README 内容到各子项目（仅根 README 简介）

---

## 7. 风险与缓解

| 风险 | 影响 | 缓解 |
| --- | --- | --- |
| `flutter create` 在含中文路径下可能产生 warn | 脚手架生成受阻 | 在 `app/` 相对路径下执行；如失败改用 ASCII 子目录别名 `app/`（已用） |
| `amap_flutter_map: ^3.0.0` 不存在最新版 | pub get 失败 | 降级到 `^2.0.0`；本阶段不调用 Map 也不影响 |
| `nest new` 需交互 | 阻塞 CI | `--package-manager npm --skip-git` + `--strict` 跳过交互 |
| 高德 SDK Android 需配置 maven 仓库 | 编译错误 | 在 `android/build.gradle` 添加 `maven { url 'https://maven.aliyun.com/repository/public' }` |
| TypeORM `synchronize: true` 在生产风险 | 数据丢失 | 本阶段显式置 `false`；下阶段用 migrations |
| `injectable_generator` 与 freezed 顺序冲突 | build_runner 异常 | 在 `build.yaml` 中声明 order：先 freezed 后 injectable |
| Windows 路径下 `git config --global` 风险 | 全局污染 | 严格用 `--local` 或不写 |
| `npm install` 网络问题（中国大陆） | 阻塞 | 文档建议在 `.npmrc` 配置淘宝镜像；本设计文档不强制 |

---

## 8. 验收标准

完成后必须满足：

1. `app/` `backend/` `admin/` 三个子项目均已创建且 `package.json` / `pubspec.yaml` 存在
2. `app/lib/` 目录树与本文档 §3.3 一致（含 `.gitkeep`）
3. `dart analyze` 输出 0 issues
4. `flutter test` 输出 `All tests passed!`
5. `npm install` 在 `backend/` 与 `admin/` 均成功
6. `.github/workflows/` 含 3 个 yml 文件
7. 根目录 `.gitignore` / `.editorconfig` / `.gitattributes` 存在
8. `git log` 至少有 6 个 commit，message 符合 conventional commit
9. 根 `README.md` 简要列出 monorepo 结构 + 各子项目快速启动命令

---

## 9. 后续阶段预告

阶段零完成后，下一站是阶段一（Task 6–14）：i18n 框架、主题与暗黑模式、go_router 5 Tab、Dio + Mock 拦截器、Hive 封装、游客模式、隐私协议、纠错入口、达人招募入口。届时本设计文档将被「Sightour 阶段一系统基础设计」取代。

---

## 10. Spec 自我审查（写完后执行）

作者自检项（已通过）：

- [x] 无 `TBD` / `TODO` 占位（业务占位明确标 `TODO(stage-N)`）
- [x] 无内部矛盾：依赖版本与 Architecture Spec 附录 A 一致；目录结构与 §2.2 一致
- [x] 范围聚焦：仅 Task 1–5，未越界写阶段一
- [x] 歧义消除：所有「本阶段」明确指阶段零；所有「下阶段」指阶段一
- [x] 验收标准可度量：5 个量化指标

---

## 附录 A · 与其他文档交叉引用

| 主题 | 关联文档 | 章节 |
| --- | --- | --- |
| 选型 | Architecture Spec | §1, §15 |
| 目录结构 | Architecture Spec | §2 |
| 状态机 | States Spec | §1, §3（下一阶段） |
| 设计 Token | Design System | §1（下一阶段主题详细化） |
| 任务清单 | MVP Plan | 阶段零 Task 1–5 |
| CI | MVP Plan | Task 5 |

---

## 附录 B · 文档变更日志

| 版本 | 日期 | 变更 |
| --- | --- | --- |
| v1.0 | 2026-06-27 | 首版发布。Brainstorming 工作流产出，覆盖阶段零 5 个 Task 完整脚手架设计。 |
