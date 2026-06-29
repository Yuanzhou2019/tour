# Sightour — Project Memory for AI Assistants

> 外籍入境一站式服务 APP（上海试点）。Flutter 客户端 + NestJS 后端 + React 后台 + PGC 内容生产 monorepo。
> 计划周期 8-10 周，分 4 阶段（脚手架 / 系统基础 / 核心业务 / 合规上架）。

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

## 3. 进度评估（截至 2026-06-28）

> **端到端数据链视角**：用户操作 → Flutter Cubit/Repository → HTTP → NestJS Controller/Service → DB → Admin 后台 → PGC 内容生产。

### 3.1 链路状态总览

| 状态 | 数量 | 说明 |
| --- | --- | --- |
| ✅ **完全端到端**（DB 真实读写 + 前后端一致） | **0** | 无 |
| 🟡 **前端走 Mock**（后端只返空 / 接口不匹配） | **7** | onboarding(纯本地)、policy、checklist、discover、POI search、FX、feedback POST |
| 🟠 **前端占位**（页面有，但只展示静态/本地数据） | **2** | tools 工具卡、profile/settings |
| ❌ **完全未启动**（页面、接口、内容均无） | **5+** | transit、ranks、emergency、phrases、POI detail、correction、admin 模块、5 大 Admin CRUD |

> **一句话结论**：Sightour 目前是「**前端壳 + Mock 数据 + 后端空壳**」的形态。5 个 Tab 全部有真实页面/交互/动画/中英双语，**但所有 HTTP 都被 MockInterceptor 截获**；后端 8 个 Controller 全是 `{data:[]}` 桩，0 Entity、0 Migration、0 seed.json；Admin 1 个登录 + 1 个占位 Dashboard。

### 3.2 用户操作 → 端到端链路矩阵

#### 3.2.1 onboarding（首次启动 + 隐私）
| 链路 | 状态 |
|---|---|
| UI：5 步 Onboarding（Welcome/Features/Setup/CityHighlights/Privacy）| ✅ 富 UI + 动画 |
| Cubit：`FirstRunSettingsCubit` 7 个字段（语言/主题/单位/国家/原因/城市/完成位）| ✅ |
| 持久化：Hive box `prefs`（**不打网络**）| ✅ |
| 后端：`UserModule.list()` 存在但**前端不调** | 🟠 空壳 |
| Admin：— | — |

#### 3.2.2 prepare（政策 + 清单 + 离线）
| 链路 | 状态 |
|---|---|
| UI：Cards/Timeline 双视图 + 时间线 + 圆环进度 | ✅ 富 UI + 动画 |
| Cubit：`PrepareHomeCubit.load() / toggleItem()` | ✅ |
| HTTP：`GET /policies?country=&reason=&city=` + `GET /checklists?...` | 🟡 **走 Mock** |
| 后端：`PolicyController.list()` + `ChecklistController.list()` 均返 `{data:[]}` | 🟡 |
| DB：❌ 无 TypeORM Entity | ❌ |
| Seeds：`mock_data.dart` 内置 10 国 × 3 城 × 5 目的 = 150 组合 | 🟡 |
| `/prepare/policy/:id` `/prepare/checklist` `/prepare/offline` | ❌ ComingSoon |

#### 3.2.3 map（POI 搜索/分类/详情）
| 链路 | 状态 |
|---|---|
| UI：分类 Chip + 搜索 + POI 列表 | ✅ 富 UI |
| Cubit：`MapHomeCubit.setCategory/setQuery` | ✅ |
| HTTP：`GET /pois/search?q=&category=&city=` | 🟡 **走 Mock** |
| 后端：`PoiController.list()` 返 `{data:[]}` | 🟡 |
| 点 POI 详情：`// TODO navigate to detail`，**实际什么都不做** | 🟠 |
| `/map/poi/:id` `/map/poi/:id/reputation` | ❌ ComingSoon |

#### 3.2.4 discover（精选/本地/避坑）
| 链路 | 状态 |
|---|---|
| UI：3 段 Tab + 渐变卡 + 错峰动画 | ✅ 富 UI |
| Cubit：`DiscoverHomeCubit.selectTab()` | ✅ |
| HTTP：`GET /discover/{curated,authentic,heads-up}` | 🟡 **走 Mock** |
| 后端：**`backend/src/modules/` 无 discover 目录** | ❌ **后端根本没建这个模块** |
| `/discover/:category`（榜单） | ❌ ComingSoon |

#### 3.2.5 tools（工具集 + 汇率）
| 链路 | 状态 |
|---|---|
| UI：货币换算卡 + 6 个工具网格 | ✅ 富 UI |
| FX Cubit：`FxConverterCubit.load()` → `FxRepositoryImpl.rate()` | 🟡 **走 Mock** |
| HTTP：`GET /tools/fx-rates?from=&to=` | 🟡 后端**无 `tools/` 模块** |
| 6 个工具卡：点击均弹 `l10n.toolsComingSoon` | 🟠 |
| `/tools/fx` `/tools/phrases` `/tools/emergency` | ❌ ComingSoon |

#### 3.2.6 you（个人中心 + 设置 + 反馈）
| 链路 | 状态 |
|---|---|
| UI：ProfileSection + 动作卡 + Settings 卡片 + Feedback 表单 | ✅ 富 UI |
| Locale/Theme Cubit：实时切换 + Hive 持久化 | ✅ |
| Feedback 提交：`POST /corrections` | 🟡 **走 Mock**（mock 返回 queued） |
| 后端 `CorrectionController`：**只有 GET，无 POST** | 🟡 **接口不匹配** |
| Admin 审核队列 | ❌ 未实现 |

#### 3.2.7 correction / emergency / poi detail / transit / ranks
| 模块 | 状态 |
|---|---|
| `features/correction/` 全部 `.gitkeep`（无 repo/cubit/page）| ❌ |
| `features/emergency/` 全部 `.gitkeep` | ❌ |
| `features/poi/` 全部 `.gitkeep`（实体复用 `features/map/`） | ❌ |
| `/map/transit` 路由根本不存在 | ❌ |
| `/discover/rank/:category` 是 ComingSoon | ❌ |

### 3.3 PGC 内容生产

| 链路 | 状态 |
|---|---|
| `content-ops/{poi,policy,rank}-template/README.md` | 🟠 空模板 |
| `seeds/*.json` | ❌ 不存在 |
| `backend/src/seeds/*` 灌库脚本 | ❌ 不存在 |
| TypeORM Entity 实体类 | ❌ 0 个 |
| Migration 迁移文件 | ❌ 0 个 |
| Mock 常量覆盖度 | 🟡 10 国政策 / 4 城 POI（SH 15/BJ 8/GZ 7）/ 3 类 discover 卡 / 7 货币对 / 18 项 checklist |

### 3.4 Admin 后台

| 链路 | 状态 |
|---|---|
| `Login` 页面（未接后端 auth，TODO 注释）| 🟠 |
| `Dashboard` 5 个菜单项（POI/Policy/Rank/Correction/Recruit），均指向同一占位页 | 🟠 |
| `services/http.ts` 存在但**零业务文件 import** | 🟠 |
| POI / Policy / Rank / Correction / Recruit 管理页 | ❌ |
| 双人复核工作流 | ❌ |

### 3.5 基础设施

| 项 | 状态 |
|---|---|
| `deploy/docker-compose.yml`（PostgreSQL 15 + Redis 7 + MinIO） | ✅ |
| `backend/src/config/{database,redis,minio}.config.ts` | ✅（TypeORM 已配，未连真服务）|
| `.github/workflows/app-ci.yml`（format/analyze/test + coverage）| ✅ |
| `.github/workflows/backend-ci.yml`（lint/build/test）| ✅ |
| `.github/workflows/admin-ci.yml`（lint/build）| ✅（lint 暂放行）|
| `backend/test/app.e2e-spec.ts` | 🟠 **会失败**（断言 `GET /` 返 `Hello World!`，无 AppController）|
| 后端单测覆盖 | ❌ 0 |
| 前端 e2e / integration test | ❌ 0 |

### 3.6 关键未完成项（按 P0/P1 优先级）

**P0（必须立刻做，否则端到端不通）**
1. 后端 TypeORM Entity + PG 持久化（替换所有 `{data:[]}` 桩）
2. 后端 `POST /corrections` 补全
3. 后端 `discover` 模块（与前端 3 个 GET 对齐）
4. 后端 `tools` 模块（fx-rates）
5. PGC seeds 文件：policies.json / pois.json / ranks.json / phrases.json + 灌库脚本
6. 前端：POI 详情页、紧急卡、常用语、公共出行指南

**P1（业务完整性）**
7. Admin 5 大管理模块 + 双人复核
8. 6 个工具卡实现（Phrases / Emergency / Units / Timezone / Offline / Translate）
9. 紧急联系电话、POI 详情、口碑多维度评分页
10. 后端单测 + 前端集成测试
11. e2e 测试覆盖 onboarding→prepare→feedback 全链路

**P2（合规与发布）**
12. `/full/privacy` `/full/about` 实现（隐私政策全文）
13. ICP / 软著 / 商店资料
14. 内容冷启动招募（海外渠道 + 国内社群）

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
