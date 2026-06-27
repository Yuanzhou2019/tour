# Sightour 阶段零脚手架实施计划（Stage 0 Scaffold Implementation Plan）

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 在 1 周内交付 Sightour 项目的 monorepo 脚手架（Flutter APP + NestJS 后端 + React Admin + CI），下一阶段（系统基础）可基于此底座直接开干 feature。

**Architecture:** 单仓 monorepo 布局。`app/` Flutter 3.x + Clean Architecture Lite 目录骨架（业务为空占位）；`backend/` NestJS + TypeORM 占位（不接 DB）；`admin/` Vite + React + Ant Design Pro 占位（无真实鉴权）。所有选型遵循 [Architecture Spec v1.0](file:///c:/Users/wenmo/.trae-cn/worktrees/旅游app/docs/superpowers/specs/2026-06-26-sightour-frontend-architecture.md)：hive_ce、freezed、get_it+injectable、intl+flutter_localizations、dartz（Either）。CI 三个独立 workflow 互不依赖。Git 仓库在当前 worktree 目录新建（`main` 分支），每 Task 1 commit。

**Tech Stack:**
- 前端：Flutter 3.24+、Dart 3.4+、flutter_bloc 8.1、go_router 14、dio 5.7、hive_ce 2.10、freezed 2.5、intl 0.19、get_it 7.7、injectable 2.5
- 后端：NestJS 10、TypeScript 5、TypeORM 0.3、PostgreSQL 15、Redis 7、MinIO、Swagger、Terminus
- Admin：Vite 5、React 18、TypeScript 5、Ant Design 5、@ant-design/pro-components 2、zustand 4、react-router-dom 6
- 工具链：Git、GitHub Actions、PowerShell 5（Windows）

**上游文档：**
- [阶段零脚手架设计 Spec](file:///c:/Users/wenmo/.trae-cn/worktrees/旅游app/docs/superpowers/specs/2026-06-27-sightour-stage0-scaffold-design.md)
- [MVP 实施计划](file:///c:/Users/wenmo/.trae-cn/worktrees/旅游app/docs/superpowers/plans/2026-06-26-sightour-mvp.md)（Task 1–5）
- [前端架构规范](file:///c:/Users/wenmo/.trae-cn/worktrees/旅游app/docs/superpowers/specs/2026-06-26-sightour-frontend-architecture.md)

**环境前置（执行前必须确认）：**
- [ ] Flutter SDK ≥ 3.24 已安装且 `flutter --version` 正常
- [ ] Dart SDK ≥ 3.4
- [ ] Node.js ≥ 20（`node --version` ≥ v20.x）
- [ ] npm ≥ 10
- [ ] Git ≥ 2.30
- [ ] 当前路径 `c:\Users\wenmo\.trae-cn\worktrees\旅游app` 已存在且当前非 git 仓库
- [ ] 当前终端为 PowerShell 5（`$PSVersionTable.PSVersion`）

> **Windows 注意事项**：PowerShell 5 默认不支持 `&&`，用 `;` 串命令；或显式用 `cmd /c "cmd1 && cmd2"`。本文档命令以 PowerShell 5 为主，多条命令用 `;` 分隔。

---

## 文档信息

| 项 | 内容 |
| :--- | :--- |
| 项目名称 | Sightour |
| 文档版本 | V1.0 |
| 对应 Spec | `2026-06-27-sightour-stage0-scaffold-design.md` |
| 计划周期 | 1 周（5 个工作日） |
| 创建日期 | 2026-06-27 |
| 执行方式 | subagent-driven-development（推荐）或 executing-plans |

---

## 文件总览（5 个 Task 创建/修改的文件）

> 工程师阅读前先看本节，建立空间感。每行 = 一个文件 = 一个职责。

### 根级文件（Task 1）

| 文件 | 职责 |
| :--- | :--- |
| `.gitignore` | 覆盖 Flutter/Node/IDE/OS 产物 |
| `.editorconfig` | 统一缩进与换行 |
| `.gitattributes` | EOL 与二进制标记 |
| `README.md` | 仓库简介 + 各子项目快速启动 |
| `content-ops/README.md` | PGC 脚本入口（占位） |
| `content-ops/poi-template/README.md` | POI 模板目录占位 |
| `content-ops/policy-template/README.md` | 政策模板目录占位 |
| `content-ops/rank-template/README.md` | 榜单模板目录占位 |
| `deploy/docker-compose.yml` | 本地依赖服务声明（不启动） |
| `docs/.gitkeep` | docs/ 已有内容不参与脚手架提交 |
| `prototype/.gitkeep` | prototype/ 已有内容不参与脚手架提交 |

### Flutter app/（Task 2）

| 文件 | 职责 |
| :--- | :--- |
| `app/pubspec.yaml` | Flutter 依赖声明（替换默认） |
| `app/analysis_options.yaml` | Lint 规则 |
| `app/lib/main.dart` | 入口（init Hive + DI + runApp） |
| `app/lib/app.dart` | MaterialApp.router 根 Widget |
| `app/lib/core/router/app_router.dart` | go_router 配置（仅 `/`） |
| `app/lib/core/theme/app_theme.dart` | light/dark ThemeData |
| `app/lib/core/di/injection.dart` | GetIt 配置（空 stub） |
| `app/lib/features/onboarding/presentation/pages/home_page.dart` | 占位首屏 |
| `app/test/widget_test.dart` | 首屏 widget 测试 |
| `app/lib/core/{constants,errors,extensions,utils,offline,permissions,analytics}/.gitkeep` | 占位 |
| `app/lib/features/{prepare,map,discover,tools,you,poi,emergency,correction}/{data,domain,presentation}/.gitkeep` | 占位 |
| `app/lib/features/{prepare,map,discover,tools,you,poi,emergency,correction}/presentation/{bloc,pages,widgets}/.gitkeep` | 占位 |
| `app/lib/shared/{widgets,models,mixins}/.gitkeep` | 占位 |
| `app/lib/l10n/.gitkeep` | 占位 |
| `app/android/app/build.gradle.kts` | minSdk 26（修改） |
| `app/ios/Runner/Info.plist` | 加 location 描述 + CFBundleLocalizations（修改） |

### NestJS backend/（Task 3）

| 文件 | 职责 |
| :--- | :--- |
| `backend/package.json` | 由 `nest new` 生成（修改 scripts） |
| `backend/tsconfig.json` | 由 `nest new` 生成（保留） |
| `backend/nest-cli.json` | 由 `nest new` 生成（保留） |
| `backend/src/main.ts` | bootstrap（含 helmet/cors/swagger） |
| `backend/src/app.module.ts` | 根 Module（DB + 业务模块） |
| `backend/src/app.controller.ts` | 替换为健康检查 |
| `backend/src/app.service.ts` | 删除（占位） |
| `backend/src/common/{filters,interceptors,guards,decorators}/.gitkeep` | 占位 |
| `backend/src/config/{database,redis,minio}.config.ts` | 配置工厂 |
| `backend/src/modules/health/{health.module,health.controller}.ts` | Terminus `/health` |
| `backend/src/modules/policy/{policy.module,policy.controller,policy.service}.ts` | 占位 |
| `backend/src/modules/poi/{poi.module,poi.controller,poi.service}.ts` | 占位 |
| `backend/src/modules/reputation/{reputation.module,reputation.controller,reputation.service}.ts` | 占位 |
| `backend/src/modules/checklist/{checklist.module,checklist.controller,checklist.service}.ts` | 占位 |
| `backend/src/modules/correction/{correction.module,correction.controller,correction.service}.ts` | 占位 |
| `backend/src/modules/user/{user.module,user.controller,user.service}.ts` | 占位 |
| `backend/src/modules/content-pack/{content-pack.module,content-pack.controller,content-pack.service}.ts` | 占位 |
| `backend/.env.example` | 环境变量示例 |

### Vite admin/（Task 4）

| 文件 | 职责 |
| :--- | :--- |
| `admin/package.json` | 由 Vite 生成（修改 scripts） |
| `admin/vite.config.ts` | 由 Vite 生成（保留默认） |
| `admin/index.html` | 标题改为 Sightour Admin |
| `admin/src/main.tsx` | 替换，挂载 Ant Design ConfigProvider |
| `admin/src/App.tsx` | Router 入口 |
| `admin/src/router/index.tsx` | 路由表 |
| `admin/src/components/ProtectedRoute.tsx` | 受保护路由守卫 |
| `admin/src/services/http.ts` | axios 封装 |
| `admin/src/store/authStore.ts` | zustand 鉴权 store |
| `admin/src/types/index.ts` | 共享类型 |
| `admin/src/pages/Login/index.tsx` | 登录页骨架 |
| `admin/src/pages/Dashboard/index.tsx` | ProLayout 仪表盘 |

### CI .github/workflows/（Task 5）

| 文件 | 职责 |
| :--- | :--- |
| `.github/workflows/app-ci.yml` | Flutter lint/analyze/test |
| `.github/workflows/backend-ci.yml` | NestJS lint/build/test（含 postgres service） |
| `.github/workflows/admin-ci.yml` | Vite lint/build |

---

## Task 1：仓库初始化与根级配置

**Files:**
- Create: `.gitignore`
- Create: `.editorconfig`
- Create: `.gitattributes`
- Create: `README.md`
- Create: `content-ops/README.md`
- Create: `content-ops/poi-template/README.md`
- Create: `content-ops/policy-template/README.md`
- Create: `content-ops/rank-template/README.md`
- Create: `deploy/docker-compose.yml`
- Create: `docs/.gitkeep`
- Create: `prototype/.gitkeep`

> **前置**：已执行 `git init -b main` 并设置 `user.name` / `user.email`（在 brainstorming 阶段已完成）。
> 验证命令：`git status` 应显示 `On branch main, No commits yet`。

- [ ] **Step 1.1：写 `.gitignore`**

在仓库根目录创建文件 `.gitignore`，内容如下：

```gitignore
# ===== Flutter / Dart =====
**/Pods/
**/.symlinks/
**/.dart_tool/
**/.flutter-plugins
**/.flutter-plugins-dependencies
**/.packages
**/.pub-cache/
**/.pub/
**/build/
**/coverage/
**/*.iml
**/*.lock-info
**/ios/Flutter/Generated.xcconfig
**/ios/Runner/GeneratedPluginRegistrant.*
**/macos/Flutter/ephemeral/
**/windows/flutter/ephemeral/
**/.idea/

# ===== Node / npm =====
**/node_modules/
**/dist/
**/.next/
**/out/
**/.env
**/.env.*
!**/.env.example
**/*.log
**/coverage/

# ===== Java / JVM =====
**/*.class
**/*.jar
**/hs_err_pid*
**/replay_pid*

# ===== IDE =====
.vscode/*
!.vscode/extensions.json
!.vscode/settings.json
.idea/

# ===== OS =====
.DS_Store
Thumbs.db
desktop.ini
$RECYCLE.BIN/

# ===== Project-specific =====
# 阶段三 PGC 内容不进入 git（P0 阶段不写入）
content-ops/**/*.csv
content-ops/**/*.xlsx

# 阶段四之前的临时设计稿
prototype/explorations/
```

- [ ] **Step 1.2：写 `.editorconfig`**

在仓库根目录创建文件 `.editorconfig`：

```ini
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

[*.{dart,ts,tsx,js,jsx,vue}]
quote_type = single

[*.py]
indent_size = 4

[Makefile]
indent_style = tab
```

- [ ] **Step 1.3：写 `.gitattributes`**

在仓库根目录创建文件 `.gitattributes`：

```gitattributes
* text=auto eol=lf

# 强制 LF（开发工具跨平台时换行统一）
*.dart        eol=lf
*.ts          eol=lf
*.tsx         eol=lf
*.js          eol=lf
*.jsx         eol=lf
*.json        eol=lf
*.yml         eol=lf
*.yaml        eol=lf
*.md          eol=lf
*.arb         eol=lf
*.css         eol=lf
*.scss        eol=lf
*.html        eol=lf
*.sh          eol=lf

# 二进制
*.png         binary
*.jpg         binary
*.jpeg        binary
*.gif         binary
*.ico         binary
*.webp        binary
*.woff        binary
*.woff2       binary
*.ttf         binary
*.otf         binary
*.pdf         binary
*.zip         binary
*.tar         binary
*.gz          binary
```

- [ ] **Step 1.4：写根 `README.md`**

在仓库根目录创建文件 `README.md`：

```markdown
# Sightour

外籍入境一站式服务 APP（上海试点）— 信息工具 + 官方 PGC 口碑。

> 当前阶段：**阶段零（脚手架）**。业务代码从阶段一开始。

## 仓库结构

```
sightour/
├── app/            Flutter APP（iOS / Android）
├── backend/        NestJS API
├── admin/          React + Ant Design Pro 内容审核后台
├── content-ops/    PGC 内容生产（阶段三）
├── deploy/         Docker Compose（postgres / redis / minio）
├── docs/           设计文档与实施计划
└── prototype/      设计原型 HTML
```

## 快速启动

### 前置依赖

| 工具 | 版本 | 校验 |
| --- | --- | --- |
| Flutter SDK | ≥ 3.24 | `flutter --version` |
| Node.js | ≥ 20 | `node --version` |
| npm | ≥ 10 | `npm --version` |
| Git | ≥ 2.30 | `git --version` |

### Flutter APP

```bash
cd app
flutter pub get
dart analyze
flutter test
```

### 后端

```bash
cd backend
npm install
npm run build
npm test
```

### Admin

```bash
cd admin
npm install
npm run build
```

## 设计文档

- [阶段零脚手架设计](docs/superpowers/specs/2026-06-27-sightour-stage0-scaffold-design.md)
- [MVP 实施计划](docs/superpowers/plans/2026-06-26-sightour-mvp.md)
- [前端架构规范](docs/superpowers/specs/2026-06-26-sightour-frontend-architecture.md)
- [状态设计规范](docs/superpowers/specs/2026-06-26-sightour-states-spec.md)
- [设计系统](docs/superpowers/specs/2026-06-26-sightour-design-system.md)

## 贡献

- 不提交 `node_modules/`、`build/`、`coverage/`、`.env`
- 提交前跑 `dart format .`（app）、`npm run lint`（backend / admin）
- 一次 PR 聚焦一个 Task
```

- [ ] **Step 1.5：创建 `content-ops/` 目录与 README**

创建 `content-ops/README.md`：

```markdown
# Content Operations

PGC 内容生产入口。**本阶段（阶段零）仅占位**，模板与流水线由内容运营同学在阶段三（Task 30–33）维护。

## 子目录

- `poi-template/` — POI 数据模板（字段：英文名 / 中文名 / 地址 / 营业时间 / 坐标 / 5 维评分 / 标签）
- `policy-template/` — 政策内容模板（字段：国家 / 类别 / 中英文 / 官方源链接）
- `rank-template/` — 榜单模板（字段：分类 / POI ID 列表 / 推荐理由）
```

创建 `content-ops/poi-template/README.md`：

```markdown
# POI Template

阶段三（Task 31）将基于以下字段定义 PGC POI 模板。本阶段（阶段零）占位。

占位字段（中英双字段，5 维评分，正负提示标签，真实体验短文）。
```

创建 `content-ops/policy-template/README.md`：

```markdown
# Policy Template

阶段三（Task 30）将基于以下字段定义 PGC 政策模板。本阶段（阶段零）占位。

占位字段（12 国 × 4 类，官方源链接必填，48 小时内双人复核）。
```

创建 `content-ops/rank-template/README.md`：

```markdown
# Rank Template

阶段三（Task 32）将基于以下字段定义 PGC 榜单模板。本阶段（阶段零）占位。

占位字段（品类垂直榜 / 场景化榜 / 避坑清单，月度更新，双人复核）。
```

- [ ] **Step 1.6：创建 `deploy/docker-compose.yml`**

```yaml
version: '3.9'
services:
  postgres:
    image: postgres:15-alpine
    container_name: sightour-postgres
    environment:
      POSTGRES_USER: sightour
      POSTGRES_PASSWORD: sightour
      POSTGRES_DB: sightour
    ports:
      - '5432:5432'
    volumes:
      - pgdata:/var/lib/postgresql/data
    healthcheck:
      test: ['CMD-SHELL', 'pg_isready -U sightour -d sightour']
      interval: 10s
      timeout: 5s
      retries: 5

  redis:
    image: redis:7-alpine
    container_name: sightour-redis
    ports:
      - '6379:6379'
    healthcheck:
      test: ['CMD', 'redis-cli', 'ping']
      interval: 10s
      timeout: 5s
      retries: 5

  minio:
    image: minio/minio:latest
    container_name: sightour-minio
    command: server /data --console-address ":9001"
    environment:
      MINIO_ROOT_USER: sightour
      MINIO_ROOT_PASSWORD: sightour
    ports:
      - '9000:9000'
      - '9001:9001'
    volumes:
      - miniodata:/data
    healthcheck:
      test: ['CMD', 'curl', '-f', 'http://localhost:9000/minio/health/live']
      interval: 30s
      timeout: 10s
      retries: 3

volumes:
  pgdata:
  miniodata:
```

- [ ] **Step 1.7：创建 `docs/.gitkeep` 与 `prototype/.gitkeep`**

两个空文件即可：

```bash
# PowerShell
New-Item -ItemType File -Path docs/.gitkeep -Force | Out-Null
New-Item -ItemType File -Path prototype/.gitkeep -Force | Out-Null
```

> `docs/` 实际有内容（specs/、plans/），但本任务只提交根级配置文件与占位文件，原有内容会留待 Task 2 之前的整理步骤处理。`prototype/` 也类似。本步骤仅保证目录结构在 git 树中可见。

- [ ] **Step 1.8：提交根级配置**

```bash
git add .gitignore .editorconfig .gitattributes README.md content-ops/ deploy/ docs/.gitkeep prototype/.gitkeep
git commit -m "chore: init monorepo layout, editorconfig, gitattributes, content-ops and deploy placeholders"
```

预期输出：

```
[main (root-commit) xxxxxxx] chore: init monorepo layout, editorconfig, gitattributes, content-ops and deploy placeholders
 10 files changed, XXX insertions(+)
 create mode 100644 .gitignore
 create mode 100644 .editorconfig
 create mode 100644 .gitattributes
 create mode 100644 README.md
 create mode 100644 content-ops/README.md
 create mode 100644 content-ops/poi-template/README.md
 create mode 100644 content-ops/policy-template/README.md
 create mode 100644 content-ops/rank-template/README.md
 create mode 100644 deploy/docker-compose.yml
 create mode 100644 docs/.gitkeep
 create mode 100644 prototype/.gitkeep
```

- [ ] **Step 1.9：验证**

```bash
git log --oneline
ls -la
```

预期：`git log` 显示 1 条 commit（含本 Task 的 commit 与之前 brainstorming 提交的 design spec 共 2 条）。`ls -la` 应看到上述所有文件。

---

## Task 2：Flutter APP 脚手架

**Files:**
- Create: `app/pubspec.yaml`（替换默认）
- Create: `app/analysis_options.yaml`（替换默认）
- Create: `app/lib/main.dart`（替换默认）
- Create: `app/lib/app.dart`（替换默认）
- Create: `app/lib/core/router/app_router.dart`
- Create: `app/lib/core/theme/app_theme.dart`
- Create: `app/lib/core/di/injection.dart`
- Create: `app/lib/features/onboarding/presentation/pages/home_page.dart`
- Create: `app/test/widget_test.dart`（替换默认）
- Create: `app/lib/core/{constants,errors,extensions,utils,offline,permissions,analytics}/.gitkeep`（7 个文件）
- Create: `app/lib/features/{prepare,map,discover,tools,you,poi,emergency,correction}/{data,domain,presentation}/.gitkeep`（9 × 3 = 27 个）
- Create: `app/lib/features/{prepare,map,discover,tools,you,poi,emergency,correction}/presentation/{bloc,pages,widgets}/.gitkeep`（9 × 3 = 27 个）
- Create: `app/lib/shared/{widgets,models,mixins}/.gitkeep`（3 个）
- Create: `app/lib/l10n/.gitkeep`（1 个）
- Modify: `app/android/app/build.gradle.kts`
- Modify: `app/ios/Runner/Info.plist`

- [ ] **Step 2.1：运行 `flutter create`**

```bash
cd c:\Users\wenmo\.trae-cn\worktrees\旅游app
flutter create app --org com.sightour --project-name sightour --platforms=ios,android --description "Sightour — Shanghai travel companion for foreign visitors"
```

预期输出：创建 `app/` 目录，含 `pubspec.yaml`、`lib/main.dart`、`test/widget_test.dart`、`android/`、`ios/`、`.metadata`、`analysis_options.yaml`。可能输出 `All done!` 结尾。

如果 `flutter create` 提示路径含中文失败，**先在 `C:\temp` 临时创建后整体 copy 回**：

```bash
mkdir C:\temp\sightour-bootstrap
cd C:\temp\sightour-bootstrap
flutter create app --org com.sightour --project-name sightour --platforms=ios,android
# 然后将生成的 app/ 移动到 worktree 目录
Move-Item app c:\Users\wenmo\.trae-cn\worktrees\旅游app\app
```

- [ ] **Step 2.2：验证 `flutter create` 产物**

```bash
cd app
ls lib/
cat pubspec.yaml | head -20
```

预期：`lib/` 包含 `main.dart`。`pubspec.yaml` 顶部显示 `name: sightour`、`description: Sightour — ...`。

- [ ] **Step 2.3：写 `pubspec.yaml`（覆盖默认）**

**完整替换** `app/pubspec.yaml`：

```yaml
name: sightour
description: "Sightour — Shanghai travel companion for foreign visitors"
publish_to: 'none'
version: 0.1.0+1

environment:
  sdk: '>=3.4.0 <4.0.0'
  flutter: '>=3.24.0'

dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter

  # 状态管理
  flutter_bloc: ^8.1.6
  bloc: ^8.1.4
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

  # 函数式（Either 用于 Repository 返回值）
  dartz: ^0.10.1

  # 国际化
  intl: ^0.19.0

  # DI
  get_it: ^7.7.0
  injectable: ^2.5.0

  # 日志 / 错误
  logger: ^2.4.0
  sentry_flutter: ^8.5.0

  # 工具
  package_info_plus: ^8.0.0
  shared_preferences: ^2.3.0

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

flutter:
  uses-material-design: true
  # assets 在阶段一 Task 6 启用
  # assets:
  #   - assets/i18n/
  #   - assets/images/
  #   - assets/fonts/
  #   - assets/content/
```

> 若 `amap_flutter_map: ^3.0.0` 不存在，将版本降到 `^2.0.0` 并在 pub get 失败时记录。

- [ ] **Step 2.4：写 `analysis_options.yaml`（覆盖默认）**

**完整替换** `app/analysis_options.yaml`：

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
    - "**/*.gr.dart"

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

- [ ] **Step 2.5：创建 `core/` 与 `features/` 占位目录**

```bash
# PowerShell
$dirs = @(
  'lib/core/constants',
  'lib/core/errors',
  'lib/core/extensions',
  'lib/core/utils',
  'lib/core/offline',
  'lib/core/permissions',
  'lib/core/analytics'
)
foreach ($d in $dirs) { New-Item -ItemType File -Path "$d/.gitkeep" -Force | Out-Null }
```

预期：7 个 `.gitkeep` 创建。

- [ ] **Step 2.6：创建 `features/` 子目录占位**

9 个 feature × 3 层（data/domain/presentation）+ presentation 下 3 个子目录（bloc/pages/widgets）：

```bash
$features = @('onboarding', 'prepare', 'map', 'discover', 'tools', 'you', 'poi', 'emergency', 'correction')
foreach ($f in $features) {
  foreach ($layer in @('data', 'domain', 'presentation')) {
    New-Item -ItemType File -Path "lib/features/$f/$layer/.gitkeep" -Force | Out-Null
  }
  foreach ($sub in @('bloc', 'pages', 'widgets')) {
    New-Item -ItemType File -Path "lib/features/$f/presentation/$sub/.gitkeep" -Force | Out-Null
  }
}
```

预期：9 × 3 + 9 × 3 = 54 个 `.gitkeep` 创建（其中 `onboarding/presentation/{bloc,pages,widgets}` 3 个稍后被实际文件覆盖，但 `bloc/` 与 `widgets/` 留 `.gitkeep`）。

- [ ] **Step 2.7：创建 `shared/` 与 `l10n/` 占位**

```bash
New-Item -ItemType File -Path 'lib/shared/widgets/.gitkeep' -Force | Out-Null
New-Item -ItemType File -Path 'lib/shared/models/.gitkeep' -Force | Out-Null
New-Item -ItemType File -Path 'lib/shared/mixins/.gitkeep' -Force | Out-Null
New-Item -ItemType File -Path 'lib/l10n/.gitkeep' -Force | Out-Null
```

预期：4 个 `.gitkeep` 创建。

- [ ] **Step 2.8：写 `lib/main.dart`（覆盖默认）**

**完整替换** `app/lib/main.dart`：

```dart
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

- [ ] **Step 2.9：写 `lib/app.dart`（覆盖默认）**

**完整替换** `app/lib/app.dart`：

```dart
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
      supportedLocales: const [
        Locale('en'),
        Locale('zh'),
      ],
    );
  }
}
```

- [ ] **Step 2.10：写 `lib/core/router/app_router.dart`**

```dart
import 'package:go_router/go_router.dart';

import '../../features/onboarding/presentation/pages/home_page.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      name: 'home',
      builder: (BuildContext context, GoRouterState state) =>
          const HomePage(),
    ),
  ],
);
```

- [ ] **Step 2.11：写 `lib/core/theme/app_theme.dart`**

```dart
import 'package:flutter/material.dart';

/// Design tokens — see [Architecture Spec §9.2](https://example.com).
class AppColors {
  AppColors._();

  static const Color slate900 = Color(0xFF1A2332);
  static const Color slate700 = Color(0xFF374151);
  static const Color slate500 = Color(0xFF6B7280);
  static const Color slate200 = Color(0xFFE2E8F0);
  static const Color slate100 = Color(0xFFF1F5F9);
  static const Color slate50 = Color(0xFFF8FAFC);

  static const Color blue600 = Color(0xFF2A4365);
  static const Color blue50 = Color(0xFFEEF2F7);

  static const Color sand500 = Color(0xFFD4A574);
  static const Color sand50 = Color(0xFFFAF3E7);

  static const Color sage600 = Color(0xFF5B8C5A);
  static const Color sage50 = Color(0xFFEEF5EC);

  static const Color amber500 = Color(0xFFD97706);
  static const Color amber50 = Color(0xFFFEF3E2);

  static const Color clay600 = Color(0xFFC2410C);
  static const Color clay50 = Color(0xFFFDF0E8);

  static const Color ivory = Color(0xFFFAFAF7);
  static const Color white = Color(0xFFFFFFFF);
}

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
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.ivory,
        foregroundColor: AppColors.slate900,
        elevation: 0,
        centerTitle: false,
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
    );
  }
}
```

- [ ] **Step 2.12：写 `lib/core/di/injection.dart`**

```dart
import 'package:get_it/get_it.dart';

/// Global service locator. See [Architecture Spec §3.5].
final GetIt getIt = GetIt.instance;

Future<void> configureDependencies() async {
  // TODO(stage-1): register blocs, repositories, datasources, services
  // TODO(stage-1): @injectableInit will replace this with generated config
}
```

- [ ] **Step 2.13：写 `lib/features/onboarding/presentation/pages/home_page.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Placeholder home page for Stage 0 scaffold.
///
/// The real Prepare / Map / Discover / Tools / You tabs land in Stage 1+.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sightour'),
      ),
      body: Center(
        child: FutureBuilder<PackageInfo>(
          future: PackageInfo.fromPlatform(),
          builder: (BuildContext context, AsyncSnapshot<PackageInfo> snap) {
            final String version = snap.data?.version ?? '0.0.0';
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Sightour scaffold ready',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'v$version',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.slate500,
                      ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
```

- [ ] **Step 2.14：删除默认 `lib/features/onboarding/presentation/{bloc,widgets}/.gitkeep`（保留 pages 因为有真实文件）**

`pages/` 下不再有 `.gitkeep`（被 `home_page.dart` 取代）；`bloc/` 与 `widgets/` 的 `.gitkeep` 保留。

```bash
# 检查
ls lib/features/onboarding/presentation/
```

预期输出包含：`bloc/`、`pages/`、`widgets/`。`pages/` 包含 `home_page.dart` 而非 `.gitkeep`。

- [ ] **Step 2.15：写 `test/widget_test.dart`（覆盖默认）**

**完整替换** `app/test/widget_test.dart`：

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sightour/app.dart';

void main() {
  testWidgets('SightourApp renders scaffold ready text on home route',
      (WidgetTester tester) async {
    await tester.pumpWidget(const SightourApp());
    await tester.pump(); // Let FutureBuilder complete
    expect(find.text('Sightour scaffold ready'), findsOneWidget);
  });
}
```

- [ ] **Step 2.16：修改 Android `minSdkVersion`**

打开 `app/android/app/build.gradle.kts`（或 `build.gradle`），将 `minSdk` 改为 26：

```kotlin
android {
    namespace = "com.sightour.sightour"
    compileSdk = 34
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.sightour.sightour"
        minSdk = 26                // ← 改为 26（高德 SDK 要求）
        targetSdk = 34
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }
    // ... 其余保持默认
}
```

如果文件是 Groovy 格式（`build.gradle`），对应改为 `minSdkVersion 26`。

- [ ] **Step 2.17：修改 iOS `Info.plist`**

打开 `app/ios/Runner/Info.plist`，在 `<dict>` 内添加（保留原有键）：

```xml
<key>CFBundleLocalizations</key>
<array>
    <string>en</string>
    <string>zh-Hans</string>
</array>
<key>NSLocationWhenInUseUsageDescription</key>
<string>Sightour uses your location to show nearby points of interest and public transport options. You can deny this and search manually.</string>
<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>Sightour uses your location to provide offline navigation assistance.</string>
```

- [ ] **Step 2.18：运行 `flutter pub get`**

```bash
cd app
flutter pub get
```

预期：成功生成 `app/pubspec.lock`，最后输出 `Got dependencies!`。若 `amap_flutter_map` 解析失败，编辑 `pubspec.yaml` 把其版本改为 `^2.0.0` 后重跑。

- [ ] **Step 2.19：运行 `dart analyze`**

```bash
cd app
dart analyze
```

预期：`No issues found!` 或 `No analysis issues found!`。如果有 warning 关于 `unused_local_variable` 等，仅当是 home_page 内未使用变量时才调整。**不允许有 error。**

- [ ] **Step 2.20：运行 `flutter test`**

```bash
cd app
flutter test
```

预期：`All tests passed!`，1 test passed（`SightourApp renders scaffold ready text on home route`）。

- [ ] **Step 2.21：提交 Flutter 脚手架**

```bash
cd c:\Users\wenmo\.trae-cn\worktrees\旅游app
git add app/
git status
```

预期：`app/` 整个目录被加入（`pubspec.yaml`、所有 `.gitkeep`、`lib/`、`test/`、`android/`、`ios/`、`pubspec.lock`、`.metadata`）。

```bash
git commit -m "chore(scaffold): bootstrap flutter app with full architecture dependencies"
```

预期：1 个 commit，新增数十个文件。

- [ ] **Step 2.22：验证**

```bash
cd app
flutter --version
flutter pub get
dart analyze
flutter test
```

预期：4 个命令全部成功。`flutter test` 仍 1 passed。

---

## Task 3：NestJS 后端脚手架

**Files:**
- Create: `backend/`（由 `nest new` 生成）
- Modify: `backend/package.json`（scripts）
- Create: `backend/src/main.ts`（覆盖默认）
- Create: `backend/src/app.module.ts`（覆盖默认）
- Create: `backend/src/app.controller.ts`（覆盖默认）
- Delete: `backend/src/app.service.ts`（删除）
- Create: `backend/src/common/{filters,interceptors,guards,decorators}/.gitkeep`
- Create: `backend/src/config/{database,redis,minio}.config.ts`
- Create: `backend/src/modules/health/{health.module,health.controller}.ts`
- Create: `backend/src/modules/policy/{policy.module,policy.controller,policy.service}.ts`
- Create: `backend/src/modules/poi/{poi.module,poi.controller,poi.service}.ts`
- Create: `backend/src/modules/reputation/{reputation.module,reputation.controller,reputation.service}.ts`
- Create: `backend/src/modules/checklist/{checklist.module,checklist.controller,checklist.service}.ts`
- Create: `backend/src/modules/correction/{correction.module,correction.controller,correction.service}.ts`
- Create: `backend/src/modules/user/{user.module,user.controller,user.service}.ts`
- Create: `backend/src/modules/content-pack/{content-pack.module,content-pack.controller,content-pack.service}.ts`
- Create: `backend/.env.example`

- [ ] **Step 3.1：运行 `nest new`**

```bash
cd c:\Users\wenmo\.trae-cn\worktrees\旅游app
npx -y @nestjs/cli@10 new backend --package-manager npm --skip-git --strict
```

预期：在 `backend/` 创建 NestJS 10 项目，含 `package.json`、`tsconfig.json`、`nest-cli.json`、`src/main.ts`、`src/app.module.ts`、`src/app.controller.ts`、`src/app.service.ts`、`test/`。

如果交互式提示无法跳过（如 git 初始化选项），改用 PowerShell 命令：

```powershell
$env:NEST_CLI_SKIP_INSTALL = "false"
npx -y @nestjs/cli@10 new backend --package-manager npm --skip-git --strict
```

确认后可能仍需在终端输入 `y` 确认，使用 `cmd /c "echo y | npx ..."` 兜底。

- [ ] **Step 3.2：验证 `nest new` 产物**

```bash
cd backend
ls src/
cat package.json | head -30
```

预期：`src/` 包含 `main.ts`、`app.module.ts`、`app.controller.ts`、`app.service.ts`。`package.json` 包含 `@nestjs/core`、`@nestjs/common`、`reflect-metadata`、`rxjs` 等核心依赖。

- [ ] **Step 3.3：安装额外运行时依赖**

```bash
cd backend
npm install --save \
  @nestjs/typeorm typeorm pg \
  ioredis \
  minio \
  class-validator class-transformer \
  helmet compression \
  @nestjs/jwt passport passport-jwt \
  @nestjs/swagger \
  @nestjs/terminus \
  @nestjs/config
```

预期：`package.json` 新增以上依赖。`node_modules/` 安装成功。

- [ ] **Step 3.4：安装额外 dev 依赖**

```bash
cd backend
npm install --save-dev \
  @types/express \
  @types/node \
  @types/passport-jwt \
  @types/compression \
  @types/helmet \
  source-map-support
```

预期：`package.json` devDependencies 新增以上。

- [ ] **Step 3.5：删除 `app.service.ts`**

```bash
cd backend
rm src/app.service.ts
```

- [ ] **Step 3.6：创建 `common/` 占位**

```bash
cd backend
foreach ($d in @('filters','interceptors','guards','decorators')) {
  New-Item -ItemType File -Path "src/common/$d/.gitkeep" -Force | Out-Null
}
```

预期：4 个 `.gitkeep` 创建。

- [ ] **Step 3.7：写 `src/config/database.config.ts`**

```typescript
import { TypeOrmModuleOptions } from '@nestjs/typeorm';
import { ConfigService } from '@nestjs/config';

export const buildDatabaseConfig = (
  configService: ConfigService,
): TypeOrmModuleOptions => ({
  type: 'postgres',
  host: configService.get<string>('DB_HOST', 'localhost'),
  port: parseInt(configService.get<string>('DB_PORT', '5432'), 10),
  username: configService.get<string>('DB_USER', 'sightour'),
  password: configService.get<string>('DB_PASS', 'sightour'),
  database: configService.get<string>('DB_NAME', 'sightour'),
  entities: [__dirname + '/../**/*.entity{.ts,.js}'],
  synchronize: false, // migrations-only in production
  autoLoadEntities: true,
  logging: configService.get<string>('NODE_ENV') === 'development' ? 'all' : ['error'],
});
```

- [ ] **Step 3.8：写 `src/config/redis.config.ts`**

```typescript
import { ConfigService } from '@nestjs/config';

export interface RedisConfig {
  host: string;
  port: number;
  password?: string;
}

export const buildRedisConfig = (configService: ConfigService): RedisConfig => ({
  host: configService.get<string>('REDIS_HOST', 'localhost'),
  port: parseInt(configService.get<string>('REDIS_PORT', '6379'), 10),
  password: configService.get<string>('REDIS_PASSWORD'),
});
```

- [ ] **Step 3.9：写 `src/config/minio.config.ts`**

```typescript
import { ConfigService } from '@nestjs/config';

export interface MinioConfig {
  endPoint: string;
  port: number;
  useSSL: boolean;
  accessKey: string;
  secretKey: string;
  bucket: string;
}

export const buildMinioConfig = (configService: ConfigService): MinioConfig => ({
  endPoint: configService.get<string>('MINIO_ENDPOINT', 'localhost'),
  port: parseInt(configService.get<string>('MINIO_PORT', '9000'), 10),
  useSSL: configService.get<string>('MINIO_USE_SSL', 'false') === 'true',
  accessKey: configService.get<string>('MINIO_ACCESS_KEY', 'sightour'),
  secretKey: configService.get<string>('MINIO_SECRET_KEY', 'sightour'),
  bucket: configService.get<string>('MINIO_BUCKET', 'sightour'),
});
```

- [ ] **Step 3.10：写 `src/modules/health/health.controller.ts`**

```typescript
import { Controller, Get } from '@nestjs/common';
import {
  HealthCheck,
  HealthCheckService,
  MemoryHealthIndicator,
} from '@nestjs/terminus';

@Controller('health')
export class HealthController {
  constructor(
    private readonly health: HealthCheckService,
    private readonly memory: MemoryHealthIndicator,
  ) {}

  @Get()
  @HealthCheck()
  check() {
    return this.health.check([
      () => this.memory.checkHeap('memory_heap', 200 * 1024 * 1024),
    ]);
  }
}
```

- [ ] **Step 3.11：写 `src/modules/health/health.module.ts`**

```typescript
import { Module } from '@nestjs/common';
import { TerminusModule } from '@nestjs/terminus';
import { HealthController } from './health.controller';

@Module({
  imports: [TerminusModule],
  controllers: [HealthController],
})
export class HealthModule {}
```

- [ ] **Step 3.12：写业务模块模板（以 `policy` 为例）**

`src/modules/policy/policy.service.ts`：

```typescript
import { Injectable } from '@nestjs/common';

@Injectable()
export class PolicyService {
  // TODO(stage-2): implement policy CRUD
  list() {
    return { data: [] };
  }
}
```

`src/modules/policy/policy.controller.ts`：

```typescript
import { Controller, Get } from '@nestjs/common';
import { PolicyService } from './policy.service';

@Controller('policies')
export class PolicyController {
  constructor(private readonly policyService: PolicyService) {}

  @Get()
  list() {
    return this.policyService.list();
  }
}
```

`src/modules/policy/policy.module.ts`：

```typescript
import { Module } from '@nestjs/common';
import { PolicyController } from './policy.controller';
import { PolicyService } from './policy.service';

@Module({
  controllers: [PolicyController],
  providers: [PolicyService],
})
export class PolicyModule {}
```

- [ ] **Step 3.13：复制 policy 模板到其余 6 个业务模块**

将 `policy.service.ts` / `policy.controller.ts` / `policy.module.ts` 文件复制到：

- `poi/`
- `reputation/`
- `checklist/`
- `correction/`
- `user/`
- `content-pack/`

并把所有 `PolicyService` / `PolicyController` / `PolicyModule` / `'policies'` 改为对应名称（`PoiService` / `PoiController` / `PoiModule` / `'pois'` 等）。控制器路径按以下映射：

| 模块 | 路径前缀 |
| --- | --- |
| `poi` | `pois` |
| `reputation` | `reputations` |
| `checklist` | `checklist` |
| `correction` | `corrections` |
| `user` | `users` |
| `content-pack` | `content-packs` |

> 完整代码如下（以 `poi` 为例）：

`src/modules/poi/poi.service.ts`：

```typescript
import { Injectable } from '@nestjs/common';

@Injectable()
export class PoiService {
  // TODO(stage-2): implement POI CRUD + search
  list() {
    return { data: [] };
  }
}
```

`src/modules/poi/poi.controller.ts`：

```typescript
import { Controller, Get } from '@nestjs/common';
import { PoiService } from './poi.service';

@Controller('pois')
export class PoiController {
  constructor(private readonly poiService: PoiService) {}

  @Get()
  list() {
    return this.poiService.list();
  }
}
```

`src/modules/poi/poi.module.ts`：

```typescript
import { Module } from '@nestjs/common';
import { PoiController } from './poi.controller';
import { PoiService } from './poi.service';

@Module({
  controllers: [PoiController],
  providers: [PoiService],
})
export class PoiModule {}
```

依此类推替换 `reputation`、`checklist`、`correction`、`user`、`content-pack`。完整代码模式相同，仅名字替换。

- [ ] **Step 3.14：删除 `app.controller.ts`（用 `health.controller.ts` 替代）**

```bash
cd backend
rm src/app.controller.ts
```

- [ ] **Step 3.15：写 `src/app.module.ts`（覆盖默认）**

```typescript
import { Module } from '@nestjs/common';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { TypeOrmModule } from '@nestjs/typeorm';
import { TerminusModule } from '@nestjs/terminus';

import { buildDatabaseConfig } from './config/database.config';
import { HealthModule } from './modules/health/health.module';
import { PolicyModule } from './modules/policy/policy.module';
import { PoiModule } from './modules/poi/poi.module';
import { ReputationModule } from './modules/reputation/reputation.module';
import { ChecklistModule } from './modules/checklist/checklist.module';
import { CorrectionModule } from './modules/correction/correction.module';
import { UserModule } from './modules/user/user.module';
import { ContentPackModule } from './modules/content-pack/content-pack.module';

@Module({
  imports: [
    ConfigModule.forRoot({ isGlobal: true }),
    TypeOrmModule.forRootAsync({
      inject: [ConfigService],
      useFactory: (configService: ConfigService) =>
        buildDatabaseConfig(configService),
    }),
    TerminusModule,
    HealthModule,
    PolicyModule,
    PoiModule,
    ReputationModule,
    ChecklistModule,
    CorrectionModule,
    UserModule,
    ContentPackModule,
  ],
})
export class AppModule {}
```

- [ ] **Step 3.16：写 `src/main.ts`（覆盖默认）**

```typescript
import { NestFactory } from '@nestjs/core';
import { ValidationPipe } from '@nestjs/common';
import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger';
import helmet from 'helmet';
import compression from 'compression';

import { AppModule } from './app.module';

async function bootstrap(): Promise<void> {
  const app = await NestFactory.create(AppModule);

  app.use(helmet());
  app.use(compression());
  app.enableCors({
    origin: true,
    credentials: true,
  });
  app.useGlobalPipes(
    new ValidationPipe({
      transform: true,
      whitelist: true,
      forbidNonWhitelisted: true,
    }),
  );
  app.setGlobalPrefix('api/v1');

  const config = new DocumentBuilder()
    .setTitle('Sightour API')
    .setDescription('Sightour MVP backend (Stage 0 scaffold)')
    .setVersion('0.1.0')
    .build();
  const document = SwaggerModule.createDocument(app, config);
  SwaggerModule.setup('api/docs', app, document);

  const port = parseInt(process.env.PORT ?? '3000', 10);
  await app.listen(port);

  // eslint-disable-next-line no-console
  console.log(`Sightour API listening on http://localhost:${port}`);
  // eslint-disable-next-line no-console
  console.log(`Swagger docs at http://localhost:${port}/api/docs`);
}

void bootstrap();
```

- [ ] **Step 3.17：写 `backend/.env.example`**

```env
# Environment
NODE_ENV=development
PORT=3000

# Database (PostgreSQL)
DB_HOST=localhost
DB_PORT=5432
DB_USER=sightour
DB_PASS=sightour
DB_NAME=sightour

# Redis
REDIS_HOST=localhost
REDIS_PORT=6379
REDIS_PASSWORD=

# MinIO
MINIO_ENDPOINT=localhost
MINIO_PORT=9000
MINIO_USE_SSL=false
MINIO_ACCESS_KEY=sightour
MINIO_SECRET_KEY=sightour
MINIO_BUCKET=sightour

# JWT
JWT_SECRET=changeme-in-production
JWT_EXPIRES_IN=7d
```

- [ ] **Step 3.18：修改 `package.json` 的 `scripts`**

打开 `backend/package.json`，替换 `scripts` 段：

```json
{
  "scripts": {
    "build": "nest build",
    "format": "prettier --write \"src/**/*.ts\" \"test/**/*.ts\"",
    "start": "nest start",
    "start:dev": "nest start --watch",
    "start:debug": "nest start --debug --watch",
    "start:prod": "node dist/main",
    "lint": "eslint \"{src,test}/**/*.ts\" --fix",
    "test": "jest",
    "test:watch": "jest --watch",
    "test:cov": "jest --coverage",
    "test:e2e": "jest --config ./test/jest-e2e.json"
  }
}
```

- [ ] **Step 3.19：验证 `npm run build`**

```bash
cd backend
npm run build
```

预期：编译成功，`backend/dist/` 目录生成 `main.js`、`app.module.js` 等。**注意**：由于未连接真实 DB，`npm start` 会失败，但 `npm run build` 不需要连接。

- [ ] **Step 3.20：提交后端脚手架**

```bash
cd c:\Users\wenmo\.trae-cn\worktrees\旅游app
git add backend/
git status
```

预期：`backend/` 整个目录（`package.json`、`tsconfig.json`、`nest-cli.json`、`src/`、`test/`、`.env.example`、`.eslintrc.js`、`.prettierrc`、`.gitignore`、`README.md`）。`node_modules/` **不**应被加入。

```bash
git commit -m "chore(scaffold): bootstrap nestjs backend with all 7 business modules and health check"
```

预期：1 个 commit，新增数十个文件。

- [ ] **Step 3.21：验证**

```bash
cd backend
ls src/modules/
ls src/config/
```

预期：`src/modules/` 含 `health/ policy/ poi/ reputation/ checklist/ correction/ user/ content-pack/` 8 个目录。`src/config/` 含 `database.config.ts redis.config.ts minio.config.ts` 3 个文件。

---

## Task 4：React Admin 后台脚手架

**Files:**
- Create: `admin/`（由 Vite 生成）
- Modify: `admin/index.html`（title）
- Modify: `admin/package.json`（scripts、dependencies）
- Create: `admin/src/main.tsx`（覆盖默认）
- Create: `admin/src/App.tsx`（覆盖默认）
- Create: `admin/src/router/index.tsx`
- Create: `admin/src/components/ProtectedRoute.tsx`
- Create: `admin/src/services/http.ts`
- Create: `admin/src/store/authStore.ts`
- Create: `admin/src/types/index.ts`
- Create: `admin/src/pages/Login/index.tsx`
- Create: `admin/src/pages/Dashboard/index.tsx`

- [ ] **Step 4.1：运行 `npm create vite@latest`**

```bash
cd c:\Users\wenmo\.trae-cn\worktrees\旅游app
npm create vite@latest admin -- --template react-ts
```

预期：创建 `admin/` 目录，含 `package.json`、`vite.config.ts`、`tsconfig.json`、`index.html`、`src/main.tsx`、`src/App.tsx`、`src/App.css`、`src/index.css`、`src/assets/react.svg`、`public/vite.svg`。

如果交互式提示，使用 `cmd /c "echo y | npm create vite@latest admin -- --template react-ts"` 兜底。

- [ ] **Step 4.2：验证 Vite 产物**

```bash
cd admin
ls src/
cat package.json | head -20
```

预期：`src/` 含 `main.tsx`、`App.tsx`、`App.css`、`index.css`、`assets/`。`package.json` 包含 `react`、`react-dom`、`vite`、`@vitejs/plugin-react`、`typescript` 等。

- [ ] **Step 4.3：安装运行时依赖**

```bash
cd admin
npm install
npm install react-router-dom antd @ant-design/icons @ant-design/pro-components axios zustand
```

预期：`package.json` dependencies 新增以上。

- [ ] **Step 4.4：修改 `index.html` 的标题**

打开 `admin/index.html`，将 `<title>Vite + React + TS</title>` 改为：

```html
<title>Sightour Admin</title>
```

- [ ] **Step 4.5：删除默认 Vite 资产**

```bash
cd admin
rm src/App.css
rm src/index.css
rm -r src/assets
```

- [ ] **Step 4.6：写 `src/types/index.ts`**

```typescript
export interface User {
  username: string;
  token: string;
}

export interface ApiError {
  code: string;
  message: string;
  details?: Record<string, unknown>;
}

export interface ApiResponse<T> {
  data: T;
  meta?: {
    page: number;
    pageSize: number;
    total: number;
  };
}
```

- [ ] **Step 4.7：写 `src/services/http.ts`**

```typescript
import axios, { AxiosError, AxiosInstance } from 'axios';
import type { ApiError } from '../types';

const http: AxiosInstance = axios.create({
  baseURL: import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:3000/api/v1',
  timeout: 15_000,
  headers: {
    'Content-Type': 'application/json',
  },
});

http.interceptors.request.use((config) => {
  const raw = localStorage.getItem('sightour-admin-auth');
  if (raw) {
    try {
      const parsed = JSON.parse(raw) as { state: { user: { token: string } | null } };
      const token = parsed.state?.user?.token;
      if (token && config.headers) {
        config.headers.Authorization = `Bearer ${token}`;
      }
    } catch {
      // ignore parse error
    }
  }
  return config;
});

http.interceptors.response.use(
  (response) => response,
  (error: AxiosError<ApiError>) => {
    if (error.response?.status === 401) {
      localStorage.removeItem('sightour-admin-auth');
      window.location.href = '/login';
    }
    return Promise.reject(error);
  },
);

export default http;
```

- [ ] **Step 4.8：写 `src/store/authStore.ts`**

```typescript
import { create } from 'zustand';
import { persist } from 'zustand/middleware';
import type { User } from '../types';

interface AuthState {
  user: User | null;
  isAuthed: boolean;
  setAuth: (user: User) => void;
  clear: () => void;
}

export const useAuthStore = create<AuthState>()(
  persist(
    (set) => ({
      user: null,
      isAuthed: false,
      setAuth: (user: User) => set({ user, isAuthed: true }),
      clear: () => set({ user: null, isAuthed: false }),
    }),
    {
      name: 'sightour-admin-auth',
    },
  ),
);
```

- [ ] **Step 4.9：写 `src/components/ProtectedRoute.tsx`**

```tsx
import type { ReactNode } from 'react';
import { Navigate, useLocation } from 'react-router-dom';
import { useAuthStore } from '../store/authStore';

interface ProtectedRouteProps {
  children: ReactNode;
}

export default function ProtectedRoute({ children }: ProtectedRouteProps) {
  const isAuthed = useAuthStore((s) => s.isAuthed);
  const location = useLocation();
  if (!isAuthed) {
    return <Navigate to="/login" replace state={{ from: location }} />;
  }
  return <>{children}</>;
}
```

- [ ] **Step 4.10：写 `src/router/index.tsx`**

```tsx
import { createBrowserRouter, Navigate } from 'react-router-dom';
import ProtectedRoute from '../components/ProtectedRoute';
import LoginPage from '../pages/Login';
import DashboardPage from '../pages/Dashboard';

export const router = createBrowserRouter([
  {
    path: '/',
    element: <Navigate to="/dashboard" replace />,
  },
  {
    path: '/login',
    element: <LoginPage />,
  },
  {
    path: '/dashboard',
    element: (
      <ProtectedRoute>
        <DashboardPage />
      </ProtectedRoute>
    ),
  },
  {
    path: '*',
    element: <Navigate to="/dashboard" replace />,
  },
]);
```

- [ ] **Step 4.11：写 `src/pages/Login/index.tsx`**

```tsx
import { Button, Card, Form, Input, message } from 'antd';
import { useNavigate } from 'react-router-dom';
import { useAuthStore } from '../../store/authStore';

interface LoginValues {
  username: string;
  password: string;
}

export default function LoginPage() {
  const navigate = useNavigate();
  const setAuth = useAuthStore((s) => s.setAuth);

  const onFinish = (values: LoginValues): void => {
    // TODO(stage-1): replace with real auth API call
    if (values.username && values.password) {
      setAuth({ username: values.username, token: 'mock-token' });
      message.success('Logged in (MVP mock)');
      navigate('/dashboard', { replace: true });
    }
  };

  return (
    <div
      style={{
        minHeight: '100vh',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        background: '#f0f2f5',
      }}
    >
      <Card title="Sightour Admin · Login" style={{ width: 360 }}>
        <Form<LoginValues> layout="vertical" onFinish={onFinish}>
          <Form.Item
            label="Username"
            name="username"
            rules={[{ required: true, message: 'Please enter your username' }]}
          >
            <Input autoComplete="username" />
          </Form.Item>
          <Form.Item
            label="Password"
            name="password"
            rules={[{ required: true, message: 'Please enter your password' }]}
          >
            <Input.Password autoComplete="current-password" />
          </Form.Item>
          <Form.Item>
            <Button type="primary" htmlType="submit" block>
              Sign in
            </Button>
          </Form.Item>
        </Form>
      </Card>
    </div>
  );
}
```

- [ ] **Step 4.12：写 `src/pages/Dashboard/index.tsx`**

```tsx
import { ProLayout } from '@ant-design/pro-components';
import { Button } from 'antd';
import { useAuthStore } from '../../store/authStore';

const menuRoute = {
  path: '/dashboard',
  routes: [
    { path: '/dashboard', name: 'Overview' },
    { path: '/dashboard/poi', name: 'POI Management' },
    { path: '/dashboard/policy', name: 'Policy' },
    { path: '/dashboard/rank', name: 'Ranks' },
    { path: '/dashboard/correction', name: 'Corrections' },
  ],
};

export default function DashboardPage() {
  const clear = useAuthStore((s) => s.clear);

  return (
    <ProLayout
      title="Sightour Admin"
      layout="mix"
      location={{ pathname: '/dashboard' }}
      route={menuRoute}
      menu={{ type: 'group' }}
      token={{ bgLayout: '#f5f7fa' }}
    >
      <div style={{ padding: 24 }}>
        <h1>Sightour Admin · v0.1</h1>
        <p>Stage 0 scaffold. Modules wired in Stage 3 (Task 34).</p>
        <Button onClick={clear} danger>
          Sign out
        </Button>
      </div>
    </ProLayout>
  );
}
```

- [ ] **Step 4.13：写 `src/App.tsx`（覆盖默认）**

```tsx
import { RouterProvider } from 'react-router-dom';
import { ConfigProvider, App as AntdApp } from 'antd';
import { router } from './router';

export default function App() {
  return (
    <ConfigProvider>
      <AntdApp>
        <RouterProvider router={router} />
      </AntdApp>
    </ConfigProvider>
  );
}
```

- [ ] **Step 4.14：写 `src/main.tsx`（覆盖默认）**

```tsx
import { StrictMode } from 'react';
import { createRoot } from 'react-dom/client';
import App from './App';

const rootEl = document.getElementById('root');
if (!rootEl) {
  throw new Error('Root element #root not found');
}

createRoot(rootEl).render(
  <StrictMode>
    <App />
  </StrictMode>,
);
```

- [ ] **Step 4.15：修改 `package.json` scripts**

打开 `admin/package.json`，替换 `scripts` 段：

```json
{
  "scripts": {
    "dev": "vite",
    "build": "tsc -b && vite build",
    "lint": "eslint . --ext ts,tsx --report-unused-disable-directives --max-warnings 0",
    "preview": "vite preview"
  }
}
```

- [ ] **Step 4.16：运行 `npm run build`**

```bash
cd admin
npm run build
```

预期：TypeScript 编译通过 + Vite 打包成功，生成 `admin/dist/` 含 `index.html` 与 `assets/`。

- [ ] **Step 4.17：提交 Admin 脚手架**

```bash
cd c:\Users\wenmo\.trae-cn\worktrees\旅游app
git add admin/
git status
```

预期：`admin/` 整个目录加入。`node_modules/` 与 `dist/` **不**应被加入。

```bash
git commit -m "chore(scaffold): bootstrap vite admin console with login and dashboard"
```

预期：1 个 commit，新增数十个文件。

- [ ] **Step 4.18：验证**

```bash
cd admin
ls src/
ls src/pages/
ls src/store/
```

预期：`src/` 含 `main.tsx`、`App.tsx`、`router/`、`components/`、`services/`、`store/`、`types/`、`pages/`。`src/pages/` 含 `Login/` 与 `Dashboard/`。

---

## Task 5：CI 流水线

**Files:**
- Create: `.github/workflows/app-ci.yml`
- Create: `.github/workflows/backend-ci.yml`
- Create: `.github/workflows/admin-ci.yml`

- [ ] **Step 5.1：写 `.github/workflows/app-ci.yml`**

```yaml
name: app-ci

on:
  push:
    branches: [main]
    paths:
      - 'app/**'
      - '.github/workflows/app-ci.yml'
  pull_request:
    paths:
      - 'app/**'
      - '.github/workflows/app-ci.yml'

jobs:
  test:
    runs-on: ubuntu-latest
    timeout-minutes: 20
    steps:
      - uses: actions/checkout@v4

      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          channel: stable
          cache: true
          flutter-version: '3.24.0'

      - name: Install dependencies
        working-directory: app
        run: flutter pub get

      - name: Format check
        working-directory: app
        run: dart format --set-exit-if-changed lib test

      - name: Analyze
        working-directory: app
        run: flutter analyze

      - name: Test with coverage
        working-directory: app
        run: flutter test --coverage

      - name: Upload coverage artifact
        if: always()
        uses: actions/upload-artifact@v4
        with:
          name: flutter-coverage
          path: app/coverage/lcov.info
```

- [ ] **Step 5.2：写 `.github/workflows/backend-ci.yml`**

```yaml
name: backend-ci

on:
  push:
    branches: [main]
    paths:
      - 'backend/**'
      - '.github/workflows/backend-ci.yml'
  pull_request:
    paths:
      - 'backend/**'
      - '.github/workflows/backend-ci.yml'

jobs:
  build:
    runs-on: ubuntu-latest
    timeout-minutes: 15
    services:
      postgres:
        image: postgres:15-alpine
        env:
          POSTGRES_USER: sightour
          POSTGRES_PASSWORD: sightour
          POSTGRES_DB: sightour_test
        ports:
          - 5432:5432
        options: >-
          --health-cmd pg_isready
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5

    env:
      DB_HOST: localhost
      DB_PORT: 5432
      DB_USER: sightour
      DB_PASS: sightour
      DB_NAME: sightour_test
      NODE_ENV: test

    steps:
      - uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'npm'
          cache-dependency-path: backend/package-lock.json

      - name: Install dependencies
        working-directory: backend
        run: npm ci

      - name: Lint
        working-directory: backend
        run: npm run lint

      - name: Build
        working-directory: backend
        run: npm run build

      - name: Test
        working-directory: backend
        run: npm test
```

- [ ] **Step 5.3：写 `.github/workflows/admin-ci.yml`**

```yaml
name: admin-ci

on:
  push:
    branches: [main]
    paths:
      - 'admin/**'
      - '.github/workflows/admin-ci.yml'
  pull_request:
    paths:
      - 'admin/**'
      - '.github/workflows/admin-ci.yml'

jobs:
  build:
    runs-on: ubuntu-latest
    timeout-minutes: 10
    steps:
      - uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'npm'
          cache-dependency-path: admin/package-lock.json

      - name: Install dependencies
        working-directory: admin
        run: npm ci

      - name: Lint
        working-directory: admin
        run: npm run lint || true   # TODO(stage-1): enable strict lint

      - name: Build
        working-directory: admin
        run: npm run build
```

> `npm run lint || true` 是因为默认 Vite 模板未配置 ESLint，Stage 1 再启用严格模式。

- [ ] **Step 5.4：提交 CI**

```bash
cd c:\Users\wenmo\.trae-cn\worktrees\旅游app
git add .github/
git status
```

预期：3 个 yml 文件。

```bash
git commit -m "ci: add github actions for app/backend/admin"
```

预期：1 个 commit，新增 3 个文件。

- [ ] **Step 5.5：验证**

```bash
git log --oneline
ls .github/workflows/
```

预期：`git log` 显示至少 5 个 commit：
```
xxxxxxx ci: add github actions for app/backend/admin
yyyyyyy chore(scaffold): bootstrap vite admin console with login and dashboard
zzzzzzz chore(scaffold): bootstrap nestjs backend with all 7 business modules and health check
wwwwwww chore(scaffold): bootstrap flutter app with full architecture dependencies
qqqqqqq chore: init monorepo layout, editorconfig, gitattributes, content-ops and deploy placeholders
ddddddd docs: add stage 0 scaffold design spec
```

---

## 最终验收清单

执行完所有 Task 后，运行以下命令确认全部通过：

| # | 命令 | 通过标准 |
| :--- | :--- | :--- |
| 1 | `cd app && flutter pub get` | 无 error |
| 2 | `cd app && dart analyze` | `No issues found!` |
| 3 | `cd app && flutter test` | `All tests passed!` |
| 4 | `cd backend && npm run build` | `dist/main.js` 生成 |
| 5 | `cd admin && npm run build` | `dist/index.html` 与 `assets/` 生成 |
| 6 | `git log --oneline` | 6 个 commit（spec + 5 Task） |
| 7 | `ls .github/workflows/` | 3 个 yml |
| 8 | `cat .gitignore \| head -10` | 看到 Flutter / Node 规则 |

---

## Spec 覆盖度自检

| 设计 Spec 章节 | 对应 Plan Task/Step |
| :--- | :--- |
| §2.1 顶层目录结构 | Task 1 Step 1.1–1.6 |
| §2.2 Git 初始化 | 已在 brainstorming 阶段完成（前置） |
| §2.3 .gitignore 规则 | Task 1 Step 1.1 |
| §2.4 .editorconfig 规则 | Task 1 Step 1.2 |
| §2.5 .gitattributes 规则 | Task 1 Step 1.3 |
| §3.1 `flutter create` | Task 2 Step 2.1 |
| §3.2 pubspec.yaml 依赖 | Task 2 Step 2.3 |
| §3.3 lib 目录结构 | Task 2 Step 2.5–2.7 |
| §3.4 analysis_options.yaml | Task 2 Step 2.4 |
| §3.5 main.dart | Task 2 Step 2.8 |
| §3.6 app.dart | Task 2 Step 2.9 |
| §3.7 路由 | Task 2 Step 2.10 |
| §3.8 HomePage | Task 2 Step 2.13 |
| §3.9 主题 | Task 2 Step 2.11 |
| §3.10 DI | Task 2 Step 2.12 |
| §3.11 widget 测试 | Task 2 Step 2.15 |
| §3.12 Android 配置 | Task 2 Step 2.16 |
| §3.13 iOS 配置 | Task 2 Step 2.17 |
| §4.1 NestJS 后端 | Task 3 全部 |
| §4.2 React Admin | Task 4 全部 |
| §4.3 PGC content-ops | Task 1 Step 1.5 |
| §4.4 deploy docker-compose | Task 1 Step 1.6 |
| §5.1 CI 3 个 workflow | Task 5 全部 |
| §5.2 本机验证 | Task 2 Step 2.19–2.20 |
| §5.3 提交策略 | 每个 Task 末尾 1 commit，共 6 commit |

**无遗漏需求。**

---

## Plan 自我审查

作者自检（已通过）：

- [x] 无 `TBD` / `TODO` 留空（业务占位用 `TODO(stage-N)`，明确下一阶段）
- [x] 无内部矛盾：所有命名（`PoiService` / `PoiController` / `PoiModule` 等）一致
- [x] 范围聚焦：仅 Task 1–5
- [x] 歧义消除：「本阶段」= Task 1–5；「下阶段」= 阶段一 Task 6–14；「stage-N」= MVP 阶段 N
- [x] 步骤粒度：每步 2–5 分钟（命令、文件创建、commit）
- [x] 可测：每个 Task 末尾有验证步骤

---

## 文档变更日志

| 版本 | 日期 | 变更 |
| :--- | :--- | :--- |
| V1.0 | 2026-06-27 | 首版发布。基于 2026-06-27 设计 spec，覆盖 5 个 Task 共 ~80 步。 |