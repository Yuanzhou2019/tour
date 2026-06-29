# Sightour 项目进度快照

> **截至日期**：2026-06-28
> **评估视角**：用户操作 → Flutter Cubit/Repository → HTTP → NestJS Controller/Service → DB → Admin 后台 → PGC 内容生产（端到端全链路）
> **规划基准**：`docs/superpowers/plans/2026-06-26-sightour-mvp.md`（39 个 Task，4 阶段 8-10 周）
> **本文件为动态快照**，不写入 `CLAUDE.md`（长期记忆）；每次评估请新建 `docs/progress-snapshot-YYYY-MM-DD.md`。

---

## 0. 一句话结论

> **Sightour 当前是「前端壳 + Mock 数据 + 后端空壳」形态。**
> 5 个 Tab（Prepare / Map / Discover / Tools / You）有真实富 UI 页面、含动画、中英双语、离线 Hive 持久化，**但所有 HTTP 都被 `MockInterceptor` 截获**；后端 8 个 Controller 全是 `{data:[]}` 桩，0 Entity、0 Migration、0 seed.json；Admin 后台 1 个登录 + 1 个占位 Dashboard。**完全端到端跑通的特性数为 0**。

---

## 1. 链路状态总览

| 状态 | 数量 | 说明 |
| --- | --- | --- |
| ✅ **完全端到端**（DB 真实读写 + 前后端一致） | **0** | 无 |
| 🟡 **前端走 Mock**（后端只返空 / 接口不匹配） | **7** | onboarding(纯本地)、policy、checklist、discover、POI search、FX、feedback POST |
| 🟠 **前端占位**（页面有，但只展示静态/本地数据） | **2** | tools 工具卡、profile/settings |
| ❌ **完全未启动**（页面、接口、内容均无） | **5+** | transit、ranks、emergency、phrases、POI detail、correction、admin 5 大模块 |

---

## 2. 用户操作 → 端到端链路矩阵

### 2.1 onboarding（首次启动 + 隐私）

| 链路节点 | 实现位置 | 状态 |
|---|---|---|
| UI 5 步：Welcome / Features / Setup / CityHighlights / Privacy | `features/onboarding/presentation/pages/` | ✅ 富 UI + 动画 |
| Cubit：`FirstRunSettingsCubit` 7 个字段（语言/主题/单位/国家/原因/城市/完成位）| `features/onboarding/presentation/cubit/` | ✅ |
| 持久化：Hive box `prefs`（**不打网络**）| `core/storage/` | ✅ |
| HTTP：— | （未发起） | 🟠 设计选择 |
| 后端 `UserModule.list()` 存在但**前端不调** | `backend/src/modules/user/` | 🟠 空壳 |
| Admin：— | — | — |

### 2.2 prepare（政策 + 清单 + 离线）

| 链路节点 | 实现位置 | 状态 |
|---|---|---|
| UI：Cards/Timeline 双视图 + 时间线 + 圆环进度 + 城市横幅 | `features/prepare/presentation/pages/prepare_page.dart` | ✅ 富 UI + 动画 |
| Cubit：`PrepareHomeCubit.load() / toggleItem()` | `features/prepare/presentation/cubit/` | ✅ |
| HTTP `GET /policies?country=&reason=&city=` | `core/network/mock_interceptor.dart` | 🟡 **走 Mock** |
| HTTP `GET /checklists?...` | 同上 | 🟡 **走 Mock** |
| 后端 `PolicyController.list()` 返 `{data:[]}` | `backend/src/modules/policy/policy.controller.ts:6` 注释 `TODO(stage-2)` | 🟡 |
| 后端 `ChecklistController.list()` 返 `{data:[]}` | `backend/src/modules/checklist/checklist.service.ts:6` 同样 TODO | 🟡 |
| TypeORM Entity | — | ❌ |
| Migration | — | ❌ |
| Seeds：`mock_data.dart` 内置 10 国 × 3 城 × 5 目的 = 150 组合 + `mock_data_zh.dart` | `core/network/mock_data*.dart` | 🟡 |
| `/prepare/policy/:id` | `ComingSoonPage` | ❌ |
| `/prepare/checklist` | `ComingSoonPage` | ❌ |
| `/prepare/offline` | `ComingSoonPage` | ❌ |

### 2.3 map（POI 搜索/分类/详情）

| 链路节点 | 实现位置 | 状态 |
|---|---|---|
| UI：分类 Chip + 搜索框 + POI 渐变卡片 + 错峰动画 | `features/map/presentation/pages/map_page.dart` | ✅ 富 UI |
| Cubit：`MapHomeCubit.setCategory/setQuery` | `features/map/presentation/cubit/map_home_cubit.dart` | ✅ |
| HTTP `GET /pois/search?q=&category=&city=` | `mock_interceptor.dart` | 🟡 **走 Mock** |
| 后端 `PoiController.list()` 返 `{data:[]}` | `backend/src/modules/poi/poi.service.ts:6` 注释 TODO | 🟡 |
| 点 POI 详情：`// TODO navigate to detail`，**实际什么都不做** | `map_page.dart` | 🟠 |
| `/map/poi/:id` | `ComingSoonPage` | ❌ |
| `/map/poi/:id/reputation` | `ComingSoonPage` | ❌ |

### 2.4 discover（精选/本地/避坑）

| 链路节点 | 实现位置 | 状态 |
|---|---|---|
| UI：3 段 Tab + 渐变卡 + 错峰动画 | `features/discover/presentation/pages/discover_page.dart` | ✅ 富 UI |
| Cubit：`DiscoverHomeCubit.selectTab()` | `features/discover/presentation/cubit/` | ✅ |
| HTTP `GET /discover/curated` / `/authentic` / `/heads-up` | `mock_interceptor.dart` | 🟡 **走 Mock** |
| 后端 `discover/` 目录 | — | ❌ **后端根本没建这个模块** |
| `/discover/:category`（榜单详情） | `ComingSoonPage` | ❌ |

### 2.5 tools（工具集 + 汇率）

| 链路节点 | 实现位置 | 状态 |
|---|---|---|
| UI：货币换算卡 + 6 个工具网格 | `features/tools/presentation/pages/tools_page.dart` | ✅ 富 UI |
| FX Cubit：`FxConverterCubit.load()` → `FxRepositoryImpl.rate()` | `features/tools/presentation/cubit/` | 🟡 **走 Mock** |
| HTTP `GET /tools/fx-rates?from=&to=` | `mock_interceptor.dart` | 🟡 **走 Mock** |
| 后端 `tools/` 目录 | — | ❌ **后端根本没建这个模块** |
| 6 个工具卡：点击均弹 `l10n.toolsComingSoon` | `tools_home_cubit.dart` | 🟠 |
| `/tools/fx` | `ComingSoonPage` | ❌ |
| `/tools/phrases` | `ComingSoonPage` | ❌ |
| `/tools/emergency` | `ComingSoonPage` | ❌ |

### 2.6 you（个人中心 + 设置 + 反馈）

| 链路节点 | 实现位置 | 状态 |
|---|---|---|
| UI：IllustrationBanner + 渐变 ProfileSection + 2 张动作卡 | `features/you/presentation/pages/you_page.dart` | ✅ 富 UI |
| UI：3 张 Settings 卡片（语言/主题/关于） | `features/you/presentation/pages/you_settings_page.dart` | ✅ 富 UI |
| UI：暖色 Feedback 表单 | `features/feedback/presentation/pages/feedback_form_page.dart` | ✅ 富 UI |
| Locale/Theme Cubit：实时切换 + Hive 持久化 | `core/i18n/locale_cubit.dart` + `core/theme/theme_cubit.dart` | ✅ |
| Feedback 提交：`POST /corrections` | `mock_interceptor.dart` | 🟡 **走 Mock**（mock 返回 `{id, status: queued}`） |
| 后端 `CorrectionController`：**只有 GET，无 POST** | `backend/src/modules/correction/correction.controller.ts` | 🟡 **接口不匹配** |
| Admin 审核队列 | — | ❌ |

### 2.7 correction / emergency / poi detail / transit / ranks

| 模块 | 实现位置 | 状态 |
|---|---|---|
| `features/correction/` 全部 `.gitkeep`（无 repo/cubit/page） | — | ❌ |
| `features/emergency/` 全部 `.gitkeep` | — | ❌ |
| `features/poi/` 全部 `.gitkeep`（实体复用 `features/map/`） | — | ❌ |
| `/map/transit` 路由 | 路由表不存在 | ❌ |
| `/discover/rank/:category` | `ComingSoonPage` | ❌ |
| `/modal/correction?poiId=...` | `ComingSoonPage` | ❌ |

---

## 3. PGC 内容生产

| 链路节点 | 状态 |
| --- | --- |
| `content-ops/{poi,policy,rank}-template/README.md` | 🟠 空模板 |
| `seeds/*.json` 文件 | ❌ 不存在 |
| `backend/src/seeds/*` 灌库脚本 | ❌ 不存在 |
| TypeORM Entity 实体类 | ❌ 0 个 |
| Migration 迁移文件 | ❌ 0 个 |
| Mock 常量覆盖度 | 🟡 10 国政策 / 4 城 POI（SH 15 / BJ 8 / GZ 7 / OTHER 1）/ 3 类 discover 卡 / 7 货币对 / 18 项 checklist |

---

## 4. Admin 后台

| 链路节点 | 实现位置 | 状态 |
|---|---|---|
| Login 页面（未接后端 auth，TODO 注释） | `admin/src/pages/Login/index.tsx` | 🟠 |
| Dashboard 5 个菜单项（POI/Policy/Rank/Correction/Recruit），均指向同一占位页 | `admin/src/pages/Dashboard/index.tsx` | 🟠 |
| `services/http.ts` 存在但**零业务文件 import** | `admin/src/services/http.ts` | 🟠 |
| POI / Policy / Rank / Correction / Recruit 管理页 | — | ❌ |
| 双人复核工作流 | — | ❌ |
| 登录鉴权（JWT） | — | ❌ |

---

## 5. 基础设施

| 项 | 实现位置 | 状态 |
|---|---|---|
| `deploy/docker-compose.yml`（PostgreSQL 15 + Redis 7 + MinIO） | `deploy/` | ✅ |
| `backend/src/config/database.config.ts`（TypeORM 已配 PG 连接） | `backend/src/config/` | ✅（未连真服务）|
| `backend/src/config/redis.config.ts` | 同上 | ✅ |
| `backend/src/config/minio.config.ts` | 同上 | ✅ |
| `.github/workflows/app-ci.yml`（format/analyze/test + coverage）| `.github/workflows/` | ✅ |
| `.github/workflows/backend-ci.yml`（lint/build/test）| 同上 | ✅ |
| `.github/workflows/admin-ci.yml`（lint/build）| 同上 | ✅（lint 暂放行） |
| `backend/test/app.e2e-spec.ts` | 断言 `GET /` 返 `Hello World!` | 🟠 **会失败**（无 AppController） |
| 后端单测覆盖 | — | ❌ 0 |
| 前端 e2e / integration test | — | ❌ 0 |
| 前端单测文件数 | `app/test/` 44 个 | 🟡 全部本地 mock，零网络 |

---

## 6. 计划任务 vs 现状（按 plan Task 编号）

| Plan Task | 内容 | 现状 |
|---|---|---|
| 1-5 阶段零 | Monorepo / Flutter / NestJS / Admin / CI scaffold | ✅ 全部完成 |
| 6 | i18n 中英双语 | ✅ |
| 7 | 主题 Light/Dark | ✅ |
| 8 | 路由框架（GoRouter + 守卫） | ✅（28 条路由） |
| 9 | 网络层（Dio + 拦截器） | ✅（5 个拦截器） |
| 10 | 本地存储（Hive） | ✅（8 个 box 全部 open） |
| 11 | 首次启动流 | ✅（5 步完整） |
| 12 | 隐私政策与用户协议 | ✅（同意页） |
| 13 | 纠错入口 | 🟠 路由占位 `ComingSoonPage` |
| 14 | 达人招募预埋 | ❌ 仓库无此代码 |
| 15 | 政策查询 | 🟡 前端富 UI + Mock；后端 stub |
| 16 | 行前清单 | 🟡 同上 |
| 17 | 离线资源下载 | 🟠 占位 toast |
| 18 | 高德 SDK 接入 | ❌ 未开始 |
| 19 | POI 搜索/详情 | 🟡 搜索 OK；详情 `ComingSoonPage` |
| 20 | 地图口碑嵌入 | ❌ `/map/poi/:id/reputation` 占位 |
| 21 | 公共出行指南 | ❌ 路由不存在 |
| 22 | 口碑多维度评分 | ❌ 路由占位 |
| 23 | 标签体系 | ❌ |
| 24 | 官方精选榜单 | ❌ `/discover/:category` 占位 |
| 25 | 真实体验提示 | 🟡 含在 mock_data discover 中 |
| 26 | 第三方口碑引用 | ❌ |
| 27 | 汇率换算 | 🟡 前端 OK；后端无 tools 模块 |
| 28 | 紧急信息卡 | ❌ `/tools/emergency` 占位 |
| 29 | 常用语手册 | ❌ `/tools/phrases` 占位 |
| 30-33 | PGC 内容 seeds | 🟡 数据在 mock 常量，无 seed.json |
| 34 | 内容审核后台完整功能 | 🟠 Dashboard 占位 |
| 35 | 合规资质备案 | ❌ |
| 36 | 隐私与数据保护实施 | ❌ |
| 37 | 应用商店上架准备 | ❌ |
| 38 | 种子用户招募与冷启动 | ❌ |
| 39 | MVP 端到端联调与发布 | ❌ |

---

## 7. 关键未完成项（按 P0/P1/P2 优先级）

### P0（必须立刻做，否则端到端不通）

1. **后端 TypeORM Entity + PG 持久化**（替换所有 `{data:[]}` 桩）
   - 需要文件：`backend/src/modules/{policy,poi,reputation,checklist,correction,user,content-pack}/entities/*.entity.ts`（约 10 个）
   - 影响：所有后端 endpoint 读真实数据
2. **后端 `POST /corrections` 补全**（feedback 表单真能落地）
3. **后端 `discover` 模块**（与前端 3 个 GET 对齐）
4. **后端 `tools` 模块**（fx-rates）
5. **PGC seeds 文件 + 灌库脚本**：
   - `backend/seeds/policies.json`（10 国 × 多类目）
   - `backend/seeds/pois.json`（SH 15 / BJ 8 / GZ 7 + 标签 + 评分）
   - `backend/seeds/ranks.json`（餐饮 / 购物 / 景点 / 场景 / 避坑）
   - `backend/seeds/phrases.json`（入关 / 打车 / 就餐 / 就医 / 紧急）
   - `backend/src/seeds/seed.ts` 启动时 idempotent 灌入
6. **前端缺失页面**：POI 详情、紧急卡、常用语、公共出行指南

### P1（业务完整性）

7. Admin 5 大管理模块 + 双人复核工作流（Task 34）
8. 6 个工具卡实现（Phrases / Emergency / Units / Timezone / Offline / Translate）
9. 紧急联系电话、POI 详情、口碑多维度评分页
10. 后端单测 + 前端集成测试
11. e2e 测试覆盖 onboarding → prepare → feedback 全链路
12. 修 `backend/test/app.e2e-spec.ts`（当前 `GET /` 返 `Hello World!` 与实现不一致）

### P2（合规与发布）

13. `/full/privacy` `/full/about` 实现（隐私政策全文）
14. ICP 备案 / 软著申请 / 商店资料
15. 内容冷启动招募（海外渠道 + 国内社群）
16. 修 e2e 测试 + 启用 admin-ci 严格 lint

---

## 8. 数字摘要

| 指标 | 数值 |
| --- | --- |
| Flutter `.dart` 文件 | 110 |
| 后端 `.ts` 文件 | 28 |
| Admin `.tsx` 文件 | 6 |
| Flutter Repository 接口 | 8 |
| Flutter Repository 实现 | 8（全部走 Mock） |
| 真实打到 `api.sightour.com` 的 HTTP 请求 | 0 |
| NestJS Controllers | 8 |
| NestJS 端点读 DB | 0（全是 `{data:[]}`） |
| TypeORM Entity | 0 |
| Migration 文件 | 0 |
| `seeds/*.json` | 0 |
| Admin 页面 | 2（Login + Dashboard） |
| Admin 调后端业务文件 | 0 |
| Flutter test 文件 | 44（全部本地 mock） |
| 后端 test 文件 | 1（`app.e2e-spec.ts`，会失败）|
| `.github/workflows/*.yml` | 3 |
| 路由数（go_router）| 28 |
| 已实现页面 | 8（onboarding / prepare / map / discover / tools / you / feedback / you_settings） |
| ComingSoon 占位页 | 15+ |
| `ComingSoon` 模块 | correction / emergency / poi / 部分 prepare / 部分 tools |

---

## 9. 下一步建议

### 推荐第一周冲刺（解锁 4 个 P0）

| Day | 工作 | 完成后状态 |
| --- | --- | --- |
| Day 1-2 | TypeORM Entity 全套 + Migration | 后端 endpoint 仍返空，但 DB schema 落地 |
| Day 2-3 | `seed.ts` + 4 个 seeds.json | 灌库后端能返真实数据 |
| Day 3-4 | PolicyService / ChecklistService / PoiService 接入 Repository | 4 个 GET 端到端通 |
| Day 4 | Discover module + Tools (FX) module 补全 | 6 个 mock 端点全部转真后端 |
| Day 5 | `POST /corrections` + Admin Login 鉴权 | feedback 链路 + Admin 可登录 |
| Day 5 | 修 `app.e2e-spec.ts` | CI 转绿 |

### 后续两周（P1）

- POI 详情 / 紧急卡 / 常用语 / 公共出行 4 个 Flutter 页面
- Admin 5 大管理页（CRUD + 双人复核）
- 完整测试（后端单测 + 前端 integration_test）

### 再后续（P2）

- 高德 SDK 集成
- 政策 + POI + 榜单 PGC 内容全量生产（运营主导，代码辅助）
- ICP / 软著 / 商店上架材料
