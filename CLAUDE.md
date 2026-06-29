# Sightour — Project Memory for AI Assistants

> 外籍入境一站式服务 APP（上海试点）。Flutter 客户端 + NestJS 后端 + React 后台 + PGC 内容生产 monorepo。
> 计划周期 8-10 周，分 4 阶段（脚手架 / 系统基础 / 核心业务 / 合规上架）。
> 规划文档：`docs/superpowers/plans/2026-06-26-sightour-mvp.md`

---

## 1. Git 代理（必须）

本项目推送 GitHub **必须**走代理，直连会被防火墙拦截（端口 443 超时）。

代理配置（已写入全局 git config，所有 push/fetch 自动走代理）：

| 类型 | 代理地址 |
| --- | --- |
| HTTP  | `http://localhost:9910` |
| HTTPS | `socks5h://localhost:9909` |
| Remote | `https://github.com/Yuanzhou2019/tour.git` |

查看：`git config --global --get http.proxy` / `git config --global --get https.proxy`
解除（仅在用户明确要求时）：`git config --global --unset http.proxy && git config --global --unset https.proxy`

⚠️ **不要执行** `git push` 不带 `origin main` 等明确参数；强制推送、reset --hard、clean -f、checkout . 一律需要用户明确确认。

---

## 2. 环境与命令

### 2.1 Windows PowerShell 注意

- aapt 路径含中文时会失败 → 编译/启动 Flutter **必须**在 `C:\sightour\app` 软链目录下执行（软链到当前 worktree `c:\Users\wenmo\.trae-cn\worktrees\旅游app\app`）。
- 终端 `cd` 不可靠，多步骤用 `;` 串行；`head`/`tail` 在 PowerShell 中不可用，改用 `Select-Object`。
- shell 默认 `powershell5`，所以 `which` 不可用 → 用 `Get-Command`。

### 2.2 常用命令模板

```powershell
# Flutter 分析 / 测试 / 构建
cd C:\sightour\app
flutter pub get
flutter gen-l10n
flutter analyze
flutter test
flutter build apk --debug

# 安装到模拟器 + 启动
& "$env:LOCALAPPDATA\Android\Sdk\platform-tools\adb.exe" install -r build\app\outputs\flutter-apk\app-debug.apk
& "$env:LOCALAPPDATA\Android\Sdk\platform-tools\adb.exe" shell pm clear com.sightour.sightour   # 清数据，回到 onboarding
& "$env:LOCALAPPDATA\Android\Sdk\platform-tools\adb.exe" shell monkey -p com.sightour.sightour -c android.intent.category.LAUNCHER 1

# 重启 APP（保留数据）
& "$env:LOCALAPPDATA\Android\Sdk\platform-tools\adb.exe" shell am force-stop com.sightour.sightour
& "$env:LOCALAPPDATA\Android\Sdk\platform-tools\adb.exe" shell monkey -p com.sightour.sightour -c android.intent.category.LAUNCHER 1
```

后端 / Admin 暂未启动（后端骨架尚无 controller 实现，前端当前用 Mock Interceptor 模拟数据）。

---

## 3. 仓库结构

```
sightour/
├── app/            Flutter APP（iOS / Android）— 110 个 .dart
├── backend/        NestJS API — 28 个 .ts
├── admin/          React + Ant Design Pro — 6 个 .tsx
├── content-ops/    PGC 内容生产模板（空壳）
├── deploy/         Docker Compose（postgres / redis / minio）
├── docs/           设计文档与实施计划
│   └── superpowers/
│       ├── plans/  2026-06-26-sightour-mvp.md（MVP 计划 39 Task）
│       └── specs/  设计规范（IA / 状态 / 架构 / 设计系统 / 人物角色 / 用户旅程 / 引导流 / UI 重设计）
└── prototype/      设计原型 HTML + fonts
```

### 3.1 Flutter feature 模块

| 目录 | 状态 |
| --- | --- |
| `features/onboarding/` | 5 步流 + FirstRunSettingsCubit |
| `features/prepare/` | 卡片/总览双视图 + 时间线 + 清单 |
| `features/map/` | POI 搜索 + 分类 |
| `features/discover/` | 3 段 Tab |
| `features/tools/` | 工具集 + 汇率 |
| `features/you/` | Profile / Settings / Feedback |
| `features/feedback/` | 反馈表单 |
| `features/correction/` | **空**（.gitkeep） |
| `features/emergency/` | **空**（.gitkeep） |
| `features/poi/` | **空**（.gitkeep，实体复用 `features/map/`） |

### 3.2 后端 module

| 目录 | Controller | DB |
| --- | --- | --- |
| `health/policy/poi/reputation/user/` | ✅ 简单 stub | ❌ 返 `{data:[]}` |
| `checklist/correction/content-pack/` | .gitkeep 或仅 GET | ❌ |
| **无** `discover/` 目录 | ❌ 前端有 mock 但后端无模块 | — |
| **无** `tools/` 目录 | ❌ 前端有 mock 但后端无模块 | — |

### 3.3 路由（28 条，`app_router.dart`）

- 实际页面：onboarding / prepare / map / discover / tools / you / feedback / you_settings
- ComingSoon 占位：`/prepare/policy/:id` `/prepare/checklist` `/prepare/offline` `/map/poi/:id` `/map/poi/:id/reputation` `/discover/:category` `/tools/fx` `/tools/phrases` `/tools/emergency` `/modal/correction` 等 15+ 条

### 3.4 Mock 层

- `app/lib/core/network/interceptors/mock_interceptor.dart` 截获 9 个 method+path 组合直接返本地 JSON
- `mock_data.dart` + `mock_data_zh.dart` 双语硬编码（10 国政策 / 4 城 POI / 3 类 discover / 7 货币对 / 18 项 checklist）
- `DioClient.baseUrl='https://api.sightour.com/v1'` 仅为占位
- 当前所有 HTTP 走 Mock，不打真实网络

### 3.5 Admin

- 2 个页面（Login + Dashboard），5 个菜单项均指向同一占位页
- `services/http.ts` 存在但**零业务文件 import**
- 后端 auth 未实现

### 3.6 CI

- `.github/workflows/{app,backend,admin}-ci.yml` 三套 pipeline 已建
- `backend/test/app.e2e-spec.ts` **会失败**（断言 `GET /` 返 `Hello World!`，无 AppController）

### 3.7 PGC 内容

- `content-ops/{poi,policy,rank}-template/README.md` 空模板
- `seeds/*.json` **不存在**
- `backend/src/seeds/*` 灌库脚本 **不存在**
- TypeORM Entity 实体类 **0 个**（虽然 `database.config.ts` 已配 PG 连接）

---

## 4. 技术栈

- **前端**：Flutter 3.x、Dart 3.x、flutter_bloc、go_router、dio、hive、flutter_intl、sentry_flutter
- **后端**：NestJS、TypeScript、TypeORM、PostgreSQL 15、Redis、MinIO
- **后台**：React + Ant Design Pro + Vite + axios
- **地图**（待接入）：高德 SDK（含英文）
- **DevOps**：Docker（`deploy/docker-compose.yml`）、GitHub Actions

---

## 5. 仓库约定

- 提交规范：conventional commit（`feat:` / `fix:` / `refactor:` / `chore:` / `ci:` / `content:`）
- 提交前：`dart format .`（app）、`npm run lint`（backend / admin）
- 不提交：`node_modules/`、`build/`、`coverage/`、`.env`、`.dart_tool/`
- 中文文件名会被 `git add` 警告 CRLF/LF；如已 commit 可忽略，watch out for fs encoding
- 任务规划文档：`docs/superpowers/plans/`
- 设计规范：`docs/superpowers/specs/`
- **进度快照不放本文件**（动态信息，独立存档于 `docs/progress-*.md`）
