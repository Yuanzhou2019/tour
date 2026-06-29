# Sightour 范围裁剪：纯中国入境信息工具 MVP

> **截至**：2026-06-28
> **目的**：把当前 MVP 计划中的 C2C / B2C 平台性功能剔除，**重新定义"纯中国入境工具"**的最小必做集合
> **基准文档**：
> - 完整 MVP 计划：`docs/superpowers/plans/2026-06-26-sightour-mvp.md`（39 Task）
> - PRD 原文：`Sightour.MD`（明确"无交易、无 C2C 撮合"）
> - 当前进度快照：`docs/progress-snapshot-2026-06-28.md`

---

## 0. 范围裁剪原则

### 0.1 保留（纯信息工具属性）

✅ **PGC 官方内容展示**（单向输出，非社交）
✅ **官方榜单 / 评分 / 标签**（编辑产出，权威背书）
✅ **本地化辅助工具**（汇率 / 单位 / 时区 / 紧急 / 短语）
✅ **游客匿名反馈通道**（内容纠错，无用户身份）
✅ **多语言 / 多主题 / 离线缓存**（基础体验）

### 0.2 延后出第一阶段（C2C / B2C 平台性功能）

⏸ **C2C**：达人体系、UGC 评论、双视角评价、问答互助、信用分、IM 通讯
⏸ **B2C**：商家入驻、商家后台、商家评分申诉、付费推广
⏸ **平台撮合**：探店任务、订单系统、担保支付、佣金分账
⏸ **用户系统**：注册、登录、账号体系、用户分层、身份标识
⏸ **招募入口**：双语达人招募（计划 Task 14）— 这是 C2C 的种子入口，第一阶段不引入

> 这些功能**不是永久剔除**，仅是不在第一阶段做。后续阶段（v2 / v3 等）会基于第一阶段的市场反馈再评估。详见 §5。

### 0.3 延后到 v1.1+（有价值但非 v1 必做）

🟡 **高德地图 SDK 集成**（v1 用 POI 列表占位）
🟡 **离线包下载**（v1 全部走 Mock + Hive 缓存即可）
🟡 **第三方口碑引用**（TripAdvisor 公开星级 — 合规风险高，v1 不做）
🟡 **双人复核工作流**（v1 简化为单编辑，v1.1 引入副审核）
🟡 **暗色模式完整支持**（v1 浅色 + 跟系统即可）

---

## 1. v1 必做集合（端到端链路最小闭环）

按"用户操作 → 前端 → HTTP → 后端 → DB → Admin → PGC"全链路打通，最小必做 **7 大功能模块**。

### 1.1 Onboarding（首次启动）

| 链路 | 是否必做 | 备注 |
|---|---|---|
| 5 步引导（Welcome / Features / Setup / City Highlights / Privacy）| ✅ | 现状已完整 |
| 语言/主题/单位/国家/原因/城市 7 字段持久化 | ✅ | Hive 本地，不打网络 |
| 隐私同意页 | ✅ | 法务必走流程 |
| **不做**：注册、登录、用户身份 | ❌ | 纯匿名模式 |

**前端**：`features/onboarding/`（已实现 5 步流）
**后端**：无需接口（Hive 即可）
**Admin**：无需
**内容**：城市亮点 9 张卡片（中/英）已在 mock_data

### 1.2 Prepare 入境准备

| 子功能 | 是否必做 | 说明 |
|---|---|---|
| 政策卡片（按国家 + 入境原因） | ✅ | 必做 |
| 政策时间线视图 | ✅ | 必做 |
| 行前清单（勾选 + 进度环） | ✅ | 必做 |
| 政策详情页 `/prepare/policy/:id` | ✅ | 必做 |
| 离线包下载 | ❌ v1.1 | v1 内容小，无需下载 |
| 城市领事机构信息（附在政策卡） | ✅ | mock 已有 |

**前端**：
- `features/prepare/presentation/pages/prepare_page.dart`（已实现双视图）
- **新增** `features/prepare/presentation/pages/policy_detail_page.dart`
- **新增** `features/prepare/presentation/pages/checklist_page.dart`（独立清单页）

**后端**（v1 必做）：
- `GET /api/v1/policies?country=&reason=&city=`（真实读 DB）
- `GET /api/v1/policies/:id`
- `GET /api/v1/checklists?country=&reason=&city=`
- `PATCH /api/v1/checklists/:id/toggle`（勾选状态，需鉴权？v1 可走 anonymousId）

**DB Schema**（TypeORM Entity）：
- `Policy`（id, country, category, title_zh, title_en, content_zh, content_en, source_url, source_name, updated_at）
- `Checklist`（id, country, reason, city, title, items_json, order）

**Admin**（v1 必做）：
- Policy 列表 / 编辑（CRUD）
- Checklist 列表 / 编辑（CRUD）

**PGC**（运营必生产）：
- `backend/seeds/policies.json`（10 国 × 5 目的 = 50 条）
- `backend/seeds/checklists.json`（10 国 × 5 目的 = 50 条）

### 1.3 Map 地图（v1 简化为 POI 列表）

| 子功能 | 是否必做 | 说明 |
|---|---|---|
| POI 分类 chip（景点 / 餐饮 / 住宿 / 购物）| ✅ | 已实现 |
| POI 搜索 + 列表 | ✅ | 已实现 |
| POI 详情页 `/map/poi/:id` | ✅ | **必须做**（含评分、地址、标签、体验提示）|
| 口碑多维度评分页 `/map/poi/:id/reputation` | ✅ | 必做 |
| 高德地图 SDK（地图渲染、定位）| ❌ v1.1 | v1 仅 POI 列表 |
| 公共出行指南（地铁/高铁/打车）| ❌ v1.1 | v1 仅工具页短语 |

**前端**（必做）：
- `features/map/presentation/pages/map_page.dart`（已实现）
- **新增** `features/poi/presentation/pages/poi_detail_page.dart`
- **新增** `features/poi/presentation/pages/poi_reputation_page.dart`

**后端**（v1 必做）：
- `GET /api/v1/pois/search?q=&category=&city=`
- `GET /api/v1/pois/:id`
- `GET /api/v1/pois/:id/reputation`（5 维度评分 + 标签 + 体验提示）

**DB Schema**：
- `Poi`（id, name_zh, name_en, address_zh, address_en, lat, lng, category, city, contact, open_hours, image_urls, ...)
- `PoiReputation`（poi_id, overall_score, foreign_friendly, language_support, payment_ease, authenticity, value, official_verified, updated_at）
- `PoiTag`（poi_id, tag_key, tag_category: positive/warning/risk）

**Admin**（v1 必做）：
- POI 列表 / 编辑 / 批量导入
- 评分编辑（5 维度）
- 标签字典维护

**PGC**（运营必生产）：
- `backend/seeds/pois.json`（SH 15 / BJ 8 / GZ 7 = 30 个 POI）
- `backend/seeds/reputations.json`（30 条评分）
- `backend/seeds/tags.json`（标签字典）

### 1.4 Discover 探索

| 子功能 | 是否必做 | 说明 |
|---|---|---|
| 3 段 Tab（Curated / Authentic / Heads-up）| ✅ | 已实现 |
| 卡片渐变 + 错峰动画 | ✅ | 已实现 |
| 官方精选榜单 `/discover/:category` | ✅ | 必做（餐饮 / 购物 / 景点 / 场景 / 避坑）|

**前端**（必做）：
- `features/discover/presentation/pages/discover_page.dart`（已实现）
- **新增** `features/discover/presentation/pages/rank_category_page.dart`

**后端**（v1 必做）：
- `GET /api/v1/discover/curated`
- `GET /api/v1/discover/authentic`
- `GET /api/v1/discover/heads-up`
- `GET /api/v1/ranks/:category`
- `GET /api/v1/ranks/:category/:rankId`

**DB Schema**：
- `DiscoverCard`（id, category: curated/authentic/heads-up, title_zh, title_en, summary_zh, summary_en, image_url, related_poi_ids, order）
- `Rank`（id, category, title, items_json: [{poi_id, reason_zh, reason_en, order}], updated_at）

**Admin**（v1 必做）：
- Discover 卡片编辑
- Rank 榜单编辑（拖拽排序）

**PGC**：
- `backend/seeds/discover.json`（3 类 × 4 张 = 12 张）
- `backend/seeds/ranks.json`（5 个榜单：餐饮 TOP20 / 购物 TOP10 / 景点 TOP15 / 场景 4 个 / 避坑 20 个）

### 1.5 Tools 实用工具

| 子功能 | 是否必做 | 说明 |
|---|---|---|
| 汇率换算 | ✅ | 必做 |
| 紧急联系卡 | ✅ | 必做（含 110/120/119 + 各国驻沪领事馆）|
| 常用语手册 | ✅ | 必做（5 类 × 10-20 条）|
| 单位换算（km/mi, °C/°F） | ✅ | 必做 |
| 时区工具 | ✅ | 必做 |
| 离线翻译 | ❌ | v1.1+（v1 用短语手册替代）|
| 离线包下载 | ❌ | v1.1 |

**前端**（必做）：
- `features/tools/presentation/pages/tools_page.dart`（已实现主页 + FX）
- **新增** `features/tools/presentation/pages/fx_page.dart`（独立汇率页）
- **新增** `features/emergency/presentation/pages/emergency_page.dart`
- **新增** `features/phrases/presentation/pages/phrases_index_page.dart`
- **新增** `features/phrases/presentation/pages/phrases_category_page.dart`

**后端**（v1 必做）：
- `GET /api/v1/tools/fx-rates?from=&to=`（静态汇率 + 时间戳）
- `GET /api/v1/emergency`（静态紧急号码 + 领事馆）
- `GET /api/v1/phrases`（按 category 返回）
- `GET /api/v1/phrases/:category`

**DB Schema**：
- `FxRate`（from_currency, to_currency, rate, updated_at）— 可走静态文件，不一定入库
- `EmergencyContact`（id, country, name_zh, name_en, phone, type: police/medical/fire/consulate）
- `Phrase`（id, category, en, zh, pinyin, audio_url）

**Admin**（v1 必做）：
- 紧急联系卡编辑
- 常用语编辑

**PGC**：
- `backend/seeds/emergency.json`（110/120/119 + 10 国领事馆）
- `backend/seeds/phrases.json`（5 类 × 15 条 = 75 条短语）

### 1.6 You 我的

| 子功能 | 是否必做 | 说明 |
|---|---|---|
| Profile（匿名 ID） | ✅ | 已实现 |
| Settings（语言 / 主题 / 单位） | ✅ | 已实现 |
| 反馈 / 内容纠错 | ✅ | 已实现 |
| 我的收藏 | ❌ v1.1 | 需要用户体系 |
| 历史记录 | ❌ v1.1 | 同上 |
| 关于 / 隐私政策全文 | ✅ | 必做（合规）|

**前端**（必做）：
- `features/you/presentation/pages/you_page.dart`（已实现）
- `features/you/presentation/pages/you_settings_page.dart`（已实现）
- **新增** `features/you/presentation/pages/about_page.dart`（/full/about）
- **新增** `features/you/presentation/pages/privacy_full_page.dart`（/full/privacy）

**后端**（v1 必做）：
- `POST /api/v1/corrections`（feedback 提交，写 DB）
- `GET /api/v1/corrections`（admin 用）

**DB Schema**：
- `Correction`（id, anonymous_id, type: content_error/policy/poi/other, target_id, message, contact_email, status: queued/reviewing/resolved/rejected, reviewer_id, created_at, updated_at）

**Admin**（v1 必做）：
- Correction 列表 / 审核 / 采纳 / 驳回

### 1.7 跨场景：设置与隐私

| 子功能 | 是否必做 | 说明 |
|---|---|---|
| 语言切换 EN / 中文 | ✅ | 已实现 |
| 主题切换 System / Light / Dark | ✅ | 已实现 |
| 单位切换 km / mi, °C / °F | ✅ | 已实现 |
| 隐私政策全文（中/英） | ✅ | 合规必做 |
| 关于页 | ✅ | 应用版本 / 开源协议 |
| 内容纠错入口 | ✅ | 在 About 内或独立 |

**全部走本地 Hive**，后端无需接口。

---

## 2. v1 必做 vs 现状差距（端到端视角）

| 模块 | v1 必做功能 | 前端已做 | 后端已做 | DB | Admin | PGC 内容 | 差距 |
|---|---|---|---|---|---|---|---|
| **Onboarding** | 5 步 | ✅ | n/a | n/a | n/a | ✅ mock | **完成** |
| **Prepare - 政策** | 卡片 + 时间线 + 详情页 | ✅ 卡片/时间线，❌ 详情 | ❌ stub | ❌ | ❌ | ✅ mock | **3 缺口** |
| **Prepare - 清单** | 主页 + 独立页 | ✅ 主页，❌ 独立页 | ❌ stub | ❌ | ❌ | ✅ mock | **3 缺口** |
| **Map - POI** | 列表 + 详情 | ✅ 列表，❌ 详情 | ❌ stub | ❌ | ❌ | ✅ mock | **3 缺口** |
| **Map - 口碑** | 5 维度评分页 | ❌ | ❌ stub | ❌ | ❌ | 🟡 mock 部分 | **4 缺口** |
| **Discover - 3 段** | 主页 | ✅ | ❌ 无模块 | ❌ | ❌ | ✅ mock | **3 缺口** |
| **Discover - 榜单** | 类别页 + 详情 | ❌ ComingSoon | ❌ 无模块 | ❌ | ❌ | ❌ | **5 缺口** |
| **Tools - FX** | 主页 + 独立页 | ✅ 主页，❌ 独立页 | ❌ 无模块 | ❌ | ❌ | ✅ mock | **3 缺口** |
| **Tools - 紧急** | 紧急卡 | ❌ ComingSoon | ❌ | ❌ | ❌ | 🟡 mock consular | **4 缺口** |
| **Tools - 短语** | 索引 + 分类 | ❌ ComingSoon | ❌ | ❌ | ❌ | ❌ | **5 缺口** |
| **Tools - 单位/时区** | 单元换算器 | ❌ 点工具卡仅 toast | n/a | n/a | n/a | n/a | **2 缺口** |
| **You - Settings** | 语言/主题/单位 | ✅ | n/a | n/a | n/a | n/a | **完成** |
| **You - 反馈** | 提交 + 审核 | ✅ 表单 | ❌ GET only | ❌ | ❌ | n/a | **2 缺口** |
| **You - About/Privacy** | 全文 | ❌ ComingSoon | n/a | n/a | n/a | ❌ | **2 缺口** |
| **Admin - 登录** | JWT 鉴权 | ❌ mock token | ❌ 无 auth | ❌ | 🟠 占位 | n/a | **3 缺口** |
| **Admin - POI/政策/榜单/纠错/紧急/短语 CRUD** | 5 大模块 | ❌ 占位 | n/a | ❌ | ❌ | n/a | **5 缺口** |
| **PGC seeds** | 4 类 JSON | n/a | n/a | n/a | n/a | ❌ | **4 缺口** |
| **TypeORM Entities** | 9 个 Entity | n/a | n/a | ❌ 0 个 | n/a | n/a | **9 缺口** |
| **CI e2e 测试** | 通过 | n/a | ❌ Hello World | n/a | n/a | n/a | **1 缺口** |

**总缺口**：约 **60 个端到端断点**。其中 16 个 P0 阻塞端到端打通（见进度快照 §7）。

---

## 3. v1 实现路线图（4 周冲刺）

### 3.1 第 1 周 — 后端骨架 + DB

| Day | 工作 | 完成后状态 |
|---|---|---|
| Day 1 | 9 个 TypeORM Entity（Policy / Checklist / Poi / PoiReputation / PoiTag / DiscoverCard / Rank / Correction / EmergencyContact / Phrase）| DB schema 落地 |
| Day 2 | Migration 脚本 + seed.ts 启动 idempotent 灌库 | 启动时自动建表+灌种子 |
| Day 2 | `policies.json` `checklists.json` `pois.json`（把 mock_data 转 seeds）| 30+50 条数据 |
| Day 3 | `reputations.json` `tags.json` `discover.json` `ranks.json` | 完整 PGC 数据 |
| Day 3 | `phrases.json` `emergency.json` `fx-rates.json` | 工具类种子 |
| Day 4 | PolicyService / ChecklistService / PoiService 接 Repository | 4 个 GET 端到端通 |
| Day 5 | DiscoverModule / ToolsModule（fx+emergency+phrases）新增 | 6 个 mock 端点全部转真后端 |

### 3.2 第 2 周 — Admin 后台 + 前端 P0 页面

| Day | 工作 |
|---|---|
| Day 1 | Admin JWT 鉴权（passport-jwt + 1 个种子管理员账号）|
| Day 2 | Admin POI 管理页（列表 + 编辑 + 批量导入 + 标签字典）|
| Day 3 | Admin Policy / Checklist / Discover / Rank 编辑页 |
| Day 4 | Admin Correction 审核页 + Emergency / Phrases 编辑页 |
| Day 5 | 前端：POI 详情页 / 政策详情页 / 清单独立页 |

### 3.3 第 3 周 — 前端 P0 页面 + 联通

| Day | 工作 |
|---|---|
| Day 1 | 前端：Discover 榜单页 / FX 独立页 / 紧急卡页 / 短语索引+分类页 |
| Day 2 | 前端：单位换算器 / 时区工具 |
| Day 3 | 前端：POI 口碑多维度评分页 / About / Privacy 全文 |
| Day 4 | 联调：关闭 MockInterceptor，启用真后端 |
| Day 5 | 修 bug，跑通 e2e 全链路 |

### 3.4 第 4 周 — 打磨 + 收尾

| Day | 工作 |
|---|---|
| Day 1-2 | 后端单测（每个 service 一组单测）+ 前端 widget test 补全 |
| Day 3 | e2e 测试：onboarding → 政策 → 清单勾选 → POI 详情 → 反馈提交 |
| Day 4 | 修 `backend/test/app.e2e-spec.ts` + 启用 admin-ci 严格 lint |
| Day 5 | 内部种子用户 5 人内测，收集反馈 |

---

## 4. v1.1 延后清单（v1 上线后立即启动）

| 优先级 | 功能 | 工作量 | 备注 |
|---|---|---|---|
| P0 | 高德地图 SDK 集成（地图渲染 + 定位 + 路径规划） | 2 周 | 需要申请 Key |
| P0 | 离线包下载（SH 内容包） | 1 周 | MinIO + 增量更新 |
| P1 | 第三方口碑引用（TripAdvisor 公开星级，仅引用不内嵌）| 1 周 | 法务前置 |
| P1 | 双人复核工作流（编辑 + 副审核） | 1 周 | Admin 改造 |
| P1 | 公共出行指南（地铁 / 高铁 / 打车图文） | 1 周 | 内容生产 |
| P2 | 暗色模式完整适配（所有页面） | 0.5 周 | 视觉细节 |
| P2 | 144h 过境免签专属引导流程 | 0.5 周 | 客群细分 |

---

## 5. 延后出第一阶段（不剔除，待后续阶段评估）

以下功能**不在第一阶段开发范围内**，但**不视为永久剔除**。后续阶段（v2 / v3 / 探店任务期等）会基于第一阶段的市场反馈、用户量、运营能力再评估是否引入。本节记录的是"第一阶段不做的原因"，供后续阶段决策时参考。

| 类别 | 第一阶段不做功能 | 第一阶段不做的原因 | 后续阶段评估要点 |
|---|---|---|---|
| **C2C** | 达人体系、UGC 评论、问答互助、信用分、IM 通讯 | 第一阶段定位是"纯信息工具"，C2C 涉及双向互动，合规与审核成本高 | 用户量达到 N 万 + 官方 PGC 覆盖饱和时评估 |
| **B2C** | 商家入驻、商家后台、商家评分申诉、付费推广 | 商业化会污染口碑客观性，与第一阶段"纯官方 PGC"冲突 | 第一阶段商业模型跑通后再评估 |
| **平台撮合** | 探店任务、订单、担保支付、佣金分账 | 涉及交易 + 支付牌照，第一阶段不持有此类资质 | 拿到支付牌照或与持牌方合作时评估 |
| **用户系统** | 注册、登录、账号体系、用户分层 | 第一阶段匿名游客模式更轻量，符合"一次性工具"心智 | 需要收藏 / 跨设备同步时引入 |
| **达人 / 招募** | 双语达人招募（Task 14）、种子储备 | 属 C2C 体系前置入口，第一阶段不引入 | C2C 启动时一并引入 |
| **支付 / 钱包** | 任何支付通道、余额、提现 | 第一阶段不涉及交易 | 平台撮合启动时引入 |
| **第三方 SDK 推广** | 广告 SDK、推送营销 SDK | 与"信息工具"定位不符 | 商业化阶段评估 |
| **内容商业化** | 软文、PR 推广位 | 与"纯官方 PGC"冲突 | 商业化阶段评估 |

**后续阶段如何决策**：每个延后功能在引入前必须先回答 3 个问题：
1. 是否会改变产品定位（信息工具 → 平台）？
2. 是否引入新合规风险（支付牌照 / 用户隐私 / 境外平台引用）？
3. 是否会污染第一阶段建立的口碑客观性？

3 个问题答案均为"否"才可进入下一阶段计划。

---

## 6. 与原始计划的差异总结

| 原始 Task | v1 处理 |
|---|---|
| Task 1-13 阶段零+阶段一 | ✅ 全部保留 |
| Task 14 达人招募预埋 | ⏸ 延后出第一阶段 |
| Task 15 政策查询 | ✅ 保留 |
| Task 16 行前清单 | ✅ 保留 |
| Task 17 离线资源下载 | 🟡 延后 v1.1 |
| Task 18 高德 SDK 接入 | 🟡 延后 v1.1 |
| Task 19 POI 搜索/详情 | ✅ 保留（详情页在 v1）|
| Task 20 地图口碑嵌入 | ✅ 保留（评分页在 v1）|
| Task 21 公共出行指南 | 🟡 延后 v1.1 |
| Task 22 口碑多维度评分 | ✅ 保留 |
| Task 23 标签体系 | ✅ 保留 |
| Task 24 官方精选榜单 | ✅ 保留 |
| Task 25 真实体验提示 | ✅ 保留 |
| Task 26 第三方口碑引用 | 🟡 延后 v1.1 |
| Task 27 汇率换算 | ✅ 保留 |
| Task 28 紧急信息卡 | ✅ 保留 |
| Task 29 常用语手册 | ✅ 保留 |
| Task 30-33 PGC 内容 | ✅ 保留 |
| Task 34 Admin 完整功能 | ✅ 保留（v1 简化为单编辑）|
| Task 35-39 合规上架 | 🟡 阶段四保留 |
| 阶段二 P1 UGC 生态 | ⏸ 延后出第一阶段（第二阶段评估）|
| 阶段三 P2 探店任务 | ⏸ 延后出第一阶段（第三阶段评估）|

---

## 7. 验收标准（v1 发布门槛）

### 7.1 功能验收

- [ ] 7 大模块所有 P0 子功能可端到端走通（前端 + 真后端 + DB + Admin）
- [ ] 10 国 × 5 目的 × 3 城内容覆盖（policies / checklists / pois）
- [ ] 75 条短语 + 紧急联系卡 + 7 货币对 FX
- [ ] Discover 3 段 + 5 个榜单数据齐全
- [ ] Correction 提交 → Admin 审核 → 状态回流链路通

### 7.2 体验验收

- [ ] Onboarding 5 步流程无 bug
- [ ] 全部 5 个 Tab 在浅色 / 暗色下显示正常
- [ ] EN / 中文切换 0 漏译
- [ ] 冷启动 ≤ 2 秒

### 7.3 合规验收

- [ ] 隐私政策 / 用户协议中英文双版上线
- [ ] Correction 提交走 anonymousId，不收集用户身份
- [ ] Admin 登录 JWT 鉴权
- [ ] 无第三方广告 / 追踪 SDK

### 7.4 测试验收

- [ ] CI 全绿（app / backend / admin 三套 pipeline）
- [ ] 后端每个 service 至少 1 组单测
- [ ] 前端 e2e 跑通 onboarding → 政策 → 反馈链路
- [ ] `backend/test/app.e2e-spec.ts` 已修

---

## 8. 关键文件

- 原始 39 Task 计划：`docs/superpowers/plans/2026-06-26-sightour-mvp.md`
- 进度快照：`docs/progress-snapshot-2026-06-28.md`
- 本文件（v1 范围裁剪）：`docs/superpowers/plans/2026-06-28-sightour-mvp-pure-info-tool.md`
- 项目长期记忆：`CLAUDE.md`
