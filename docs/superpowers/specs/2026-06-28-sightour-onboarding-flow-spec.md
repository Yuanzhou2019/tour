# Sightour 新用户流程 & 出入境核心流程规范（Onboarding & Entry-Exit Core Flow Spec）

> **文档类型**：产品 / UX 流程规范
> **阶段**：MVP（Phase 1）范围
> **范围**：① 首次启动 onboarding 4 屏全流程 ② 出入境相关政策的核心决策树与屏级映射 ③ mock 数据契约
> **版本**：v1.1 — 2026-06-28（Quick Setup 增补入境原因 + 入境城市两个维度，详见 §1.2.3 / §5）
> **关联文档**：
> - [用户旅程地图](file:///c:/Users/wenmo/.trae-cn/worktrees/旅游app/docs/superpowers/specs/2026-06-26-sightour-user-journeys.md) — 决定 onboarding 屏何时触发、分支逻辑
> - [信息架构](file:///c:/Users/wenmo/.trae-cn/worktrees/旅游app/docs/superpowers/specs/2026-06-26-sightour-information-architecture.md) — 屏级树、路由表
> - [状态设计规范](file:///c:/Users/wenmo/.trae-cn/worktrees/旅游app/docs/superpowers/specs/2026-06-26-sightour-states-spec.md) — 每屏 6 状态视觉
> - [用户画像](file:///c:/Users/wenmo/.trae-cn/worktrees/旅游app/docs/superpowers/specs/2026-06-26-sightour-personas.md) — Emma / James / Lin Wei 三类画像对照

---

## 0. 文档元信息

### 用途

本文档定义两件相互交织的事：

1. **新用户从打开应用到进入主界面的完整动作链**——四屏 onboarding（Welcome → Features → Quick Setup → Privacy）如何衔接、每屏交付什么价值、何时结束。
2. **出入境核心流程**——从「我能不能去」到「落地后 24 小时」之间的 4 个决策节点：签证资格 → 海关申报 → 领事援助 → 居留登记。这些决策点不是抽象的合规步骤，而是直接驱动 Prepare 屏的卡片内容、清单条目和紧急入口。

本文档是屏级 spec 与代码实现的桥梁。任何 onboarding 屏的文案变化、any policy card 字段的增减都必须先在本文档登记，再进入设计与开发。

### 读者

- **产品经理** — 流程优先级、跳过/必走节点的判断
- **内容运营** — 政策原文链接、海关提示、领事馆联系方式的更新 SOP
- **前端工程师** — onboarding 屏的实现、状态机、持久化时机
- **后端 / 数据** — `/policies`、`/checklists` 的契约

### 与 MVP 边界的关系

- **不做账号注册**：MVP 阶段所有用户都是「匿名游客」（用 [Anonymous ID](file:///c:/Users/wenmo/.trae-cn/worktrees/旅游app/app/lib/core/storage/anonymous_id.dart) 区分）。所谓「注册进入 app」=「完成 onboarding 4 屏后第一次进入主界面」。
- **不做支付 / 订阅**：onboarding 不引入付费墙。
- **不做精准定位请求**：定位权限请求推迟到用户首次进入 Map 屏时（详见 [States Spec §1.6](file:///c:/Users/wenmo/.trae-cn/worktrees/旅游app/docs/superpowers/specs/2026-06-26-sightour-states-spec.md#16-no-permission无权限态)）。

### 信息源声明

Onboarding 的 4 屏顺序来自 2026-06-26 信息架构与设计系统规范；出入境核心流程的字段来自中国国家移民管理局公开公告 + 各护照国的官方中国领事页（travel.state.gov / gov.uk / mofa.go.jp / mofa.go.kr 等），数据快照截止 2026-04。

---

## 1. 完整新用户流程

### 1.1 总体视角

```
┌──────────────────────────────────────────────────────────────────┐
│ App cold launch                                                   │
│   ↓                                                                │
│ SplashScreen (200ms) → Onboarding Welcome                          │
│   ↓ Next                                                            │
│ Onboarding Features  →  Onboarding Quick Setup                     │
│   ↓ Get started                                                     │
│ Privacy & Consent (必须双勾) → Enter Sightour                       │
│   ↓                                                                │
│ Prepare Home（首屏 = 默认 tab = 国籍已预选 = 政策已就位）             │
│   ↓                                                                │
│ Map / Discover / Tools / You 按需跳转                                │
└──────────────────────────────────────────────────────────────────┘
```

**单一成功指标**：从应用商店点击「打开」到 Prepare 首屏出现「30-day visa-free / 海关申报 / 领事援助」3 张政策卡的中位耗时 ≤ 5 秒（在线场景），首屏 LCP ≤ 1.5 秒。

### 1.2 屏级详情

#### 1.2.1 Onboarding · Welcome

| 维度 | 内容 |
| --- | --- |
| **目的** | 30 秒内让用户判断「这 APP 是不是我要的」 |
| **入口** | App 冷启动；或 `onboardingCompleted == false` 时的 redirect |
| **核心元素** | 品牌标识 + 一句话价值主张 + 3 行 sub-copy + 「Get started」按钮 |
| **价值主张文案（EN）** | "Travel smarter in Shanghai — visa, customs, embassy and discovery, all in one place. No booking. No commission. Just info." |
| **价值主张文案（中）** | "为来沪游客打造的私人向导——签证、海关、领事馆、口碑，一个 APP 查完。不下单，不抽佣，只提供信息。" |
| **互动** | 「Get started」单按钮；无返回箭头（首次启动） |
| **退出条件** | 点击 Get started → 进入 Features 屏 |
| **A11y** | 品牌区 `role="img"`；主标题 `role="heading" aria-level="1"` |
| **状态** | 无 Loading/Empty/Error（静态屏），仅 Success |

#### 1.2.2 Onboarding · Features

| 维度 | 内容 |
| --- | --- |
| **目的** | 让用户在 10 秒内理解 4 个 tab 各自解决什么 |
| **核心元素** | 4 个 feature 行：Prepare / Map / Discover / Tools（You 不列在 onboarding，因为是静态页） |
| **每行内容** | icon + 标题 + 一句话描述；横向不滚动，单列竖排 |
| **描述约束** | ≤ 14 字（中文）/ ≤ 7 词（英文），与 [设计系统 typography token](file:///c:/Users/wenmo/.trae-cn/worktrees/旅游app/docs/superpowers/specs/2026-06-26-sightour-design-system.md) 对齐 |
| **互动** | 底部「Next」按钮 |
| **退出条件** | Next → 进入 Quick Setup |
| **状态** | Success（静态） |

#### 1.2.3 Onboarding · Quick Setup（首屏价值兑现点）

| 维度 | 内容 |
| --- | --- |
| **目的** | 收集 6 个足以让 Prepare 首屏马上可用的偏好：语言 / 主题 / 国籍 / 入境原因 / 入境城市 / 单位 |
| **核心元素** | 6 个 section + 一个底部「Get started」按钮 |
| **必选** | 国籍（country）+ 入境原因（entryReason）+ 入境城市（entryCity）—— 三者联合决定 4 张政策卡 + 行前清单 + POI 池 |
| **可后置** | 语言 / 主题 / 单位（系统默认兜底） |
| **互动** | 每选一个 chip 立即写入 [FirstRunSettingsCubit](file:///c:/Users/wenmo/.trae-cn/worktrees/旅游app/app/lib/features/onboarding/presentation/cubit/first_run_settings_cubit.dart)，UI 实时反映 |
| **退出条件** | 点击 Get started → 进入 Privacy & Consent |
| **持久化时机** | **不**在 onboarding 中持久化；进入主界面后才统一写入 Hive（避免用户进入 Privacy 后放弃 → 设置全空） |
| **状态** | Success（静态）；国籍选择器为 modal/bottom-sheet |

##### 1.2.3.1 6 个 Section 的字段与候选值

| Section | 字段 | 候选值 | 默认 | 持久化 key |
| --- | --- | --- | --- | --- |
| Language | locale | `en` / `zh` | `en`（系统语言若是中文则降级 `zh`） | `first_run_locale` |
| Theme | themeMode | `system` / `light` / `dark` | `system` | `first_run_theme` |
| Home country (passport) | country | 10 个 ISO-2 代码（[Country enum](file:///c:/Users/wenmo/.trae-cn/worktrees/旅游app/app/lib/features/onboarding/domain/entities/country.dart)） | `US` | `first_run_country` |
| Reason for entry | entryReason | `tourism` / `business` / `family_visit` / `education` / `work`（[EntryReason enum](file:///c:/Users/wenmo/.trae-cn/worktrees/旅游app/app/lib/features/onboarding/domain/entities/entry_reason.dart)） | `tourism` | `first_run_entry_reason` |
| First-arrival city | entryCity | `BJ` / `SH` / `GZ` / `OTHER`（[EntryCity enum](file:///c:/Users/wenmo/.trae-cn/worktrees/旅游app/app/lib/features/onboarding/domain/entities/entry_city.dart)） | `SH` | `first_run_entry_city` |
| Units | unitSystem | `metric` / `imperial` | `metric`（仅当 country == US 时默认 imperial） | `first_run_unit` |

##### 1.2.3.2 Reason for entry 与 First-arrival city 的扩展逻辑

**入境原因（EntryReason）—— 5 选 1**：

| 值 | 何时触发额外卡片 | 何时插入额外清单条目 |
| --- | --- | --- |
| `tourism` | 无（30 天免签已覆盖） | 无 |
| `business` | 无（30 天免签已覆盖） | 无 |
| `family_visit` | 追加 Q 探亲签证卡（适用于本国 + 中国 PR 家庭成员） | 邀请信携带 |
| `education` | 追加 X1/X2 学生签证卡 + 30 天内办居留许可卡 | JW202/JW201 携带 + 24h 内指定医院体检 + 30 天内 PSB 预约 |
| `work` | 追加 Z 工作签证 + 居留许可卡 | 工作许可通知携带 + 30 天内 PSB 预约 |

**入境城市（EntryCity）—— 4 选 1**：

| 值 | 是否 v1 启动城市 | POI 池 | 政策卡的领事馆地址本地化 | 清单特殊条目 |
| --- | :-: | --- | --- | --- |
| `BJ` Beijing / 北京 | ✓ | 故宫 / 颐和园 / 长城 / 王府井 / 三里屯 / 大董烤鸭 | 北京 朝阳区安家楼路 55 号 + 010-8531-3000 | 北京 PSB 地址（东城区安定门东大街2号） |
| `SH` Shanghai / 上海 | ✓ | 外滩 / 豫园 / 陆家嘴 / 田子坊 / 半岛酒店 / 佳家汤包 | 上海 淮海中路 1469 号 + 021-8011-2400 | （无额外条目，PSB 由酒店注册链路处理） |
| `GZ` Guangzhou / 广州 | ✓ | 广州塔 / 陈家祠 / 沙面岛 / 陶陶居 / 太古汇 | 广州 珠江新城华就路 43 号 + 020-3814-5000 | 广州 PSB 地址（天河区中山大道中803号） |
| `OTHER` 其他城市 | ✗（占位提示） | 1 张 fallback POI（"No offline POIs for this city yet"） | 不追加 | 「Find the local PSB address for your first-arrival city once you land」 |

**Other 占位提示**：选择 OTHER 时，Quick Setup 屏上紧贴 chip 下显示一条 amber 提示条：

> Other cities are not yet covered in v1. We will still show the national-level policy (visa, customs, embassy) for your passport, but offline packs and city-specific POIs are only available for Beijing, Shanghai and Guangzhou.

该提示只在选择 OTHER 后出现；切换回 BJ/SH/GZ 时立即隐藏。

**注意**：MVP 阶段不请求定位、通知、相机权限；这 3 项推迟到对应屏首次进入。

#### 1.2.4 Privacy & Consent（强制门槛）

| 维度 | 内容 |
| --- | --- |
| **目的** | 法律合规 + 让用户知道数据用在哪 |
| **核心元素** | 5 条说明 + 「Privacy Policy」链接（Coming Soon）+ 2 个勾选框 + 「Enter Sightour」按钮 |
| **硬规则** | 2 个勾选都打勾之前，「Enter Sightour」disabled（灰色，不可点） |
| **5 条说明文案** | 见 [privacy_consent_page.dart](file:///c:/Users/wenmo/.trae-cn/worktrees/旅游app/app/lib/features/onboarding/presentation/pages/privacy_consent_page.dart) 行 22-28；不重复展开 |
| **持久化时机** | 点击「Enter Sightour」时一次性写入：(a) `onboarding_completed = true` (b) FirstRunPreferences 全 4 个字段 |
| **退出条件** | 仅可前进；首次启动不允许返回 |
| **状态** | Success（静态） |

#### 1.2.5 进入主界面

点击「Enter Sightour」后执行：
1. `OnboardingRepository.markCompleted()` → 写入 Hive `prefs` box
2. `OnboardingRepository.saveFirstRunPreferences(prefs)` → 写入 4 个偏好
3. `router.redirect('/prepare')` → 进入 Prepare Home

**关键时序**：第 1、2 步是 fire-and-forget（Hive 写入 < 10ms）。第 3 步立即触发，避免用户看到空白屏。如果 Hive 写入失败，不阻断导航，但下次冷启动会再次进入 onboarding。

---

## 2. 首次进入 Prepare Home 的契约

### 2.1 路由进入 Prepare Home 时同时触发的数据请求

```
Prepare Home mount
   ├── GET /policies?country=<cubit.country>&reason=<cubit.entryReason>&city=<cubit.entryCity>
   │     期望返回 3–6 张卡片（visa / customs / consular / residence + reason overlay）
   ├── GET /checklists?country=<同上>&reason=<同上>&city=<同上>
   │     期望返回 8–13 条行前清单（含 reason / city 专属条目）
   └── (并行) 探测网络状态 → 决定 Offline banner 是否显示
```

### 2.2 Prepare Home 在 5 个状态下的呈现（速查）

| 状态 | 触发 | 顶部 | 中段（卡片） | 底部（清单） | CTA |
| --- | :-: | --- | --- | --- | --- |
| **Loading** | 首屏 / 切换国籍 / 切换原因 / 切换城市 | Skeleton × 5（card 高度） | skeleton | skeleton | skeleton button |
| **Success** | 数据返回且非空 | 国籍 chip：🇺🇸 Passport · US  · 入境原因 chip · 城市 chip | 3 张政策卡 + reason overlay | 清单 + 进度条 | Download offline pack |
| **Empty** | 数据返回且空 | 同上 | 「We don't have policy details for [country]」+ 官方源链接 | 清单照常显示 | 「Submit correction」 |
| **Error** | API 失败 | 同上 + Retry | 「We couldn't load the latest entry rules」+ 「Try again」 | 缓存版本（若有） | retry |
| **Offline** | 飞行模式 / SIM 无信号 | ⚠ You're offline banner | 缓存政策卡 + 「Last updated X days ago」 | 清单本地可勾 | 「Already up to date」 |
| **No-permission** | — | — | — | — | —（不适用） |

> 详细文案 / 视觉规则见 [States Spec §3.1](file:///c:/Users/wenmo/.trae-cn/worktrees/旅游app/docs/superpowers/specs/2026-06-26-sightour-states-spec.md#31-preparehome-首页)。本文档不重复。

### 2.3 切换任意三维（nationality / reason / city）= 触发新的「出入境核心流程」

用户在 Prepare 顶部 3 个 chip 切换任一维度时，等同于触发一次新的政策检索。这与首次进入的行为完全一致：

- **政策卡列表**会按 `country + reason` 合并重算（reason overlay 按 §1.2.3.2 的扩展表追加）
- **清单条目**会按 `country + reason + city` 三维合并（详见 §5.3）
- **POI 池**会按 city 切换（`SH` / `BJ` / `GZ` / `OTHER` 的离线包内容）
- **UI 框架**（chip / 卡片样式 / 清单行）保持不变

切换 country 与切换 reason 都会刷新 `/policies` 与 `/checklists`；切换 city 仅在原因与国家不变时是「单纯换离线包」。

---

## 3. 出入境核心流程（Entry-Exit Core Flow）

### 3.1 4 个决策节点的串联

```
┌─────────────────────────────────────────────────────────────────────┐
│ Pre-departure          Border          In-country        Departure  │
│ (行前)                 (边境)           (在境内)          (离境)      │
│                                                                       │
│  ① 签证资格 ───▶  ② 海关申报 ───▶  ③ 领事援助 ───▶ ④ 居留登记    │
│  (visa)            (customs)        (consular)       (residence)    │
└─────────────────────────────────────────────────────────────────────┘
```

每个节点在 APP 中有固定的承载位置：

| 节点 | 政策卡 ID 前缀 | 是否出现在 Prepare Home 顶部 | 是否出现在行前清单 |
| :-: | :-: | :-: | :-: |
| ① 签证资格 | `*-visa-*` | ✓ | ✓（如需申请签证则有专项条目） |
| ② 海关申报 | `*-customs-*` | ✓ | △（仅红线提醒） |
| ③ 领事援助 | `*-consular-*` | ✓ | ✓（保存至主屏步骤） |
| ④ 居留登记 | `*-residence-*` | ✓（首 3 张之外） | ✓（抵达后 24h 内确认） |

### 3.2 节点 ① · 签证资格自查

#### 决策树

```
用户护照国 X ─┬─ X ∈ {US, GB, JP, KR, DE, FR, AU, CA, IT}
              │     → 单方面免签 30 天（旅游 / 商务 / 家庭）
              │     → 显示「30-day visa-free」卡
              │     → 清单不含签证申请条目
              │
              ├─ X = RU
              │     → 需提前办理 L 签证（旅游签证）
              │     → 显示「Tourist visa required」卡
              │     → 清单插入「Apply at least 4 weeks before」条目
              │
              └─ X ∉ 上述清单
                    → 显示「No policy details yet」fallback 卡
                    → 卡片 CTA 跳 nia.gov.cn 官方源
                    → 清单保留通用项（不显示签证条目）
```

#### 政策卡字段（必须填全）

| 字段 | 必填 | 示例 |
| --- | :-: | --- |
| `id` | ✓ | `us-visa-free-30d` |
| `title` | ✓ | "30-day visa-free entry" |
| `description` | ✓ | 含停留天数 / 适用目的 / 是否可延期 / 提前申请 |
| `source` | ✓ | 含发布机构 + 公告日期；URL 必须真实可点 |
| `country` | ✓ | ISO-2 代码；fallback 时为空字符串 |

### 3.3 节点 ② · 海关申报（红 / 绿通道）

#### 何时强制走红色通道（不论国籍）

- 携带现金 ≥ 5,000 USD 等值（人民币 20,000 或等值外币）
- 携带动物 / 植物 / 土壤 / 种子
- 携带 > 20 支香烟 / > 50 支雪茄 / > 400 支烟丝
- 携带 > 1.5L 酒精饮料
- 携带 > 5,000 USD 价值的自用物品（海关争议线）
- 携带职业样品 / 受 CITES 保护的动植物制品

#### 在 APP 中的体现

- **政策卡**：每条政策卡的 description 明确「Green channel if 低于 X / 没有限制物品」+ 「Red channel required for ...」
- **清单**：MVP 不强制要求清单条目，但卡片顶部 chip 用颜色提示（`slate-500`=绿、`amber-500`=注意、`clay-600`=必申报）
- **离线包**：海关申报规则必须能在离线包中找到（飞机降落时无网）

### 3.4 节点 ③ · 领事援助

#### 内容必须包含 3 段

1. **本地领事馆地址**（中英对照 + 地图入口）
2. **本地办公电话**（工作时间）+ **24h 全球紧急电话**（拨打方式）
3. **本国入境官网链接**（用于政策原文回查）

#### 在 APP 中的体现

- **政策卡**：3 行描述必须涵盖上述 3 段；不允许只放 1 个电话
- **清单条目**「Save your country's consular emergency number to your phone home screen」—— 该条目文案在所有国家一致
- **快速拨号**：未来 P1 阶段，政策卡的 description 末尾接「Call now」按钮直接调起系统拨号；MVP 阶段仅文本
- **离线可用**：领事卡完全本地缓存；这是危机 Journey 的最高 SLA 项（详见 [User Journeys §4.4](file:///c:/Users/wenmo/.trae-cn/worktrees/旅游app/docs/superpowers/specs/2026-06-26-sightour-user-journeys.md#4-journey--危机处理)）

### 3.5 节点 ④ · 居留登记（24 小时内）

#### 法规基础

中国《出境入境管理法》第 39 条：外国人在中国境内住宿（酒店、民宿、亲友家），应当于入住后 24 小时内由留宿人向当地公安机关申报。

#### 不同住宿场景的处理

| 住宿类型 | 谁登记 | 用户操作 | APP 提示 |
| --- | --- | --- | --- |
| 酒店 / 招待所 | 酒店前台自动登记 | 无 | 清单条目「Confirm hotel has registered within 24h」 |
| 民宿（爱彼迎等） | 房东登记 | 必要时给房东看地址 | 离线包中提供派出所地址查询 |
| 亲友家 | 户主登记 | 需主动 | 清单条目 + 派出所地址 |
| 学校宿舍（Lin Wei） | 学校外事办统一登记 | 无 | 24h 内学校代办 |

#### 在 APP 中的体现

- **政策卡**：第 4 张卡显示「Hotel auto-registration / 学校代办」等具体场景
- **清单条目**「Confirm the hotel has registered your stay with the local police station within 24h」—— 文案中性、不假设用户住酒店
- **空状态**：仅当用户切换到不支持的国家时显示 fallback 卡

### 3.6 跨节点的 SLA 与更新频率

| 节点 | 更新频率 | 谁负责 | 失败时降级 |
| --- | --- | --- | --- |
| ① 签证 | 季度 + 临时政策 | 内容运营 + 自动监控 | 显示「Last verified date」+ 官方源链接 |
| ② 海关 | 年度 | 内容运营 | 不变（法规稳定） |
| ③ 领事 | 半年度 | 内容运营 + 大使馆发布 | 立即推送 Push（如果用户启用） |
| ④ 居留 | 年度 | 内容运营 | 不变 |

> **P1 后续**：当用户启用推送 Toggle（详见 [States Spec §3.5.6](file:///c:/Users/wenmo/.trae-cn/worktrees/旅游app/docs/superpowers/specs/2026-06-26-sightour-states-spec.md#35-you个人页--profile)），系统级推送「节点 ③ 更新」与「节点 ① 临时暂停免签」两类。

---

## 4. Mock 数据契约（与代码同步）

### 4.1 端点 → 数据形态 速查

> 实现：[mock_data.dart](file:///c:/Users/wenmo/.trae-cn/worktrees/旅游app/app/lib/core/network/mock_data.dart) +
> [mock_interceptor.dart](file:///c:/Users/wenmo/.trae-cn/worktrees/旅游app/app/lib/core/network/interceptors/mock_interceptor.dart)

| Method + Path | Query 参数 | 返回 `data` 形态 | 来源方法 |
| --- | --- | --- | --- |
| `GET /policies` | `country=<ISO-2>`, `reason=<id>`, `city=<BJ|SH|GZ|OTHER>` | `List<Policy>` 3–6 条，含 visa/customs/consular/residence + reason overlay；领馆地址按 city 本地化 | `_policiesFor({countryIso, reasonId, cityId})` |
| `GET /checklists` | `country=`, `reason=`, `city=` | `List<ChecklistItem>` 8–13 条（按 country + reason + city 三维叠加） | `_checklistFor({countryIso, reasonId, cityId})` |
| `GET /pois/search` | `q?`, `category?`, `city?` | `List<Poi>` 0–15 条，按 city 路由离线池 + name 包含 + category 过滤 | `_poisFor({q, category, cityId})` |
| `GET /discover/curated` | — | `List<DiscoverCard>` 4 条 | `_discoverCurated()` |
| `GET /discover/authentic` | — | `List<DiscoverCard>` 3 条 | `_discoverAuthentic()` |
| `GET /discover/heads-up` | — | `List<DiscoverCard>` 4 条 | `_discoverHeadsUp()` |
| `GET /tools/fx-rates` | `from=<CCY>`, `to=<CCY>` | `Map` 单条 `FxRate`，含 `from/to/rate/updatedAt` | `_fxRateFor(from, to)` |
| `GET /me/preferences` | — | `Map` 单条 `Preferences`（country/locale/theme/unit/push） | `_preferences()` |
| `POST /corrections` | body 任意 | `Map` 单条 `{id, status:'queued', reviewSlaHours:48, message}` | `_correctionEcho()` |

### 4.2 政策字段命名硬约束

| 字段 | 类型 | 限制 |
| --- | --- | --- |
| `id` | String | kebab-case；国家前缀（如 `us-`）+ 节点（`visa-free-30d` / `customs-declare` / `consular-contact` / `residence-register`） |
| `title` | String | ≤ 40 字；不含 emoji；fallback 时使用「No policy details yet」 |
| `description` | String | ≤ 240 字；多语言版本允许（即 JP 政策卡 description 可含日文） |
| `source` | String | 格式「机构名 · 公告日期」，例如「China NIA · 2024-11」 |
| `country` | String | ISO-2 大写；fallback 时为空字符串 |

### 4.3 未支持国家的回退路径

任何 `country` 参数不在 10 国清单（US/GB/JP/KR/DE/FR/AU/CA/IT/RU）内时，必须返回 1 条 fallback 卡：
```
{
  "id": "fallback-generic",
  "title": "No policy details for this passport yet",
  "description": "Most travellers from your region need a tourist visa. "
                  "Apply at your nearest Chinese embassy or consulate.",
  "source": "www.nia.gov.cn (官方源) · Updated quarterly",
  "country": ""
}
```
**严禁**返回空数组——空数组会让 UI 进入 Error 态而非 Empty 态，回退是 Empty 态的合法内容。

### 4.4 离线 / 在线 / 错误的边界

| 场景 | mock 数据行为 |
| --- | --- |
| `MockInterceptor.simulateOffline = true` | 一律 reject DioException.connectionError |
| `MockInterceptor.errorRate > 0` | 随机比例返回 500 + `INTERNAL_ERROR` |
| `MockInterceptor.simulatedDelayMs = N` | 所有响应延迟 N ms（默认 200ms；测试可设为 0） |
| 端点未在 `_endpointKeys` 中 | pass-through，调用真实后端 |

---

## 5. 屏级状态 → 文案 → 数据矩阵（出入境相关屏的速查）

### 5.1 Prepare Home × 国籍 × 入境原因矩阵

| 国籍 | 原因 = tourism / business | 原因 = family_visit | 原因 = education | 原因 = work |
| --- | --- | --- | --- | --- |
| US / GB / JP / KR / DE / FR / AU / CA / IT | 4 张基础卡（visa-free / customs / consular / residence） | 5 张：基础 + Q 探亲签证 | 6 张：基础 + X1 学生签证 + 居留许可 30 天 | 5 张：基础 + Z 工作签证 |
| RU | 4 张（visa REQUIRED + 海关 + 领事 + 居留）+ 清单 visa-application | 5 张 + Q-visa | 6 张 + X1/X2 + 居留许可 | 5 张 + Z-visa |
| fallback | 1 张 fallback | 1 张 fallback | 1 张 fallback | 1 张 fallback |

### 5.2 行前清单条目对照（按三维叠加）

> 来源：[_checklistFor()](file:///c:/Users/wenmo/.trae-cn/worktrees/旅游app/app/lib/core/network/mock_data.dart) 实现

#### 5.2.1 通用条目（任何国家/原因/城市都包含）

| ID | 文案（EN） |
| --- | --- |
| `passport-validity` | Check passport has at least 6 months validity beyond entry date |
| `return-ticket` | Have proof of onward/return ticket |
| `hotel-booking` | Save hotel address in Chinese characters — show it to taxi drivers |
| `travel-insurance` | Buy travel insurance covering medical evacuation (recommended) |
| `offline-pack` | Download the offline pack for your first-arrival city before departure |
| `cash-mix` | Carry ¥500–¥1000 CNY cash for the first 24h |
| `phrases-saved` | Save at least 10 emergency phrases in Tools → Phrase book |
| `embassy-saved` | Save your country's consular emergency number to phone home screen |
| `24h-registration` | Confirm the hotel has registered your stay with the local police within 24h |

#### 5.2.2 国籍附加（country overlay）

| ID | 适用 | 文案 |
| --- | --- | --- |
| `visa-application` | 仅 RU | Apply for Chinese tourist (L) visa at least 4 weeks before departure |

#### 5.2.3 入境原因附加（reason overlay）

| ID | 适用 | 文案 |
| --- | --- | --- |
| `invitation-letter` | family_visit | Bring the Q-visa invitation letter from your family member in China |
| `university-documents` | education | Carry JW202 + JW201 admission forms (issued by your university) |
| `health-checkup` | education | Complete the mandatory health checkup at a designated hospital within 24h of arrival |
| `residence-permit-30d` | education / work | Book a PSB appointment within 30 days to convert X1 / Z visa to residence permit |
| `work-permit-notification` | work | Carry the Notification of Foreigner's Work Permit from your employer |

#### 5.2.4 入境城市附加（city overlay）

| ID | 适用 | 文案 |
| --- | --- | --- |
| `bj-psb-address` | city = BJ | Bookmark Beijing PSB Exit-Entry Administration (东城区安定门东大街2号) |
| `gz-psb-address` | city = GZ | Bookmark Guangzhou PSB Exit-Entry Administration (天河区中山大道中803号) |
| `other-city-notice` | city = OTHER | Find the local PSB (出入境管理局) address for your first-arrival city once you land |
| （无条目） | city = SH | 由酒店 24h 自动注册链路处理，不需额外清单条目 |

### 5.3 POI 池按城市矩阵

| 城市 | POI 数 | 标志性 POI |
| --- | :-: | --- |
| SH | 15 | The Bund · Yu Garden · Oriental Pearl · Tianzifang · Aman Shanghai |
| BJ | 8 | Forbidden City · Temple of Heaven · Great Wall (Mutianyu) · Summer Palace · Da Dong Roast Duck |
| GZ | 7 | Canton Tower · Chen Clan · Shamian · Baiyun Mountain · Tao Tao Ju |
| OTHER | 1 | fallback POI（"No offline POIs for this city yet"） |

### 5.4 三维 chip 切换时的过渡态

| 触发 | 时长 | 用户看到 |
| --- | --- | --- |
| 点击 nationality / reason / city chip | < 200ms | chip 立即换为新值 + 卡片 fade-out 200ms `--ease-out` |
| 切换后 200ms–1s | skeleton 替换真实卡片 |
| 切换后 > 2s | 显示 Error 态 + 「Try again」 |

**注意**：
- 切换 nationality 或 reason → 重新请求 `/policies` + `/checklists`
- 切换 city → 重新请求 `/policies` + `/checklists` + 触发离线包重下载（若是 SH↔BJ↔GZ 切换；OTHER 不下载）
- 离线包是城市级；切换护照不影响已下载的离线包

---

## 6. A11y / 本地化 / 错误处理（叠加在 States Spec 之上）

### 6.1 A11y

- Onboarding 4 屏的底部 CTA 必须有 `aria-label` 完整描述（不只靠文字）
- 国籍 chip 的图标旁必须有可读文本「United States · 美国」
- 行前清单的 checkbox 必须有 `aria-checked` 正确同步

### 6.2 i18n

- 政策卡 description 允许部分本地化（如 JP / KR / RU 政策卡可用本国语言）
- 政策卡 title 在 MVP 阶段仅 EN + 中（其他语言显示英文，附「（English available）」）
- 文案长度上限：title ≤ 40 字（EN）/ ≤ 14 字（中）；description ≤ 240 字（EN）/ ≤ 80 字（中）

### 6.3 错误恢复

| 失败 | 自动重试 | 显示给用户 |
| --- | :-: | --- |
| `/policies` 失败 | 2 次（间隔 2s / 5s） | Error 态 + Try again + 官方源链接 |
| `/checklists` 失败 | 同上 | 列表显示骨架 + 「Save your progress locally?」 |
| 二者同时失败 | — | 全屏 Error 态 + 「Open Settings」检查网络 |
| 网络恢复（探测） | 立即重发挂起请求 | 自动 fade-in 数据；Offline banner 消失 |

---

## 7. 流程图（一图看完）

### 7.1 Onboarding 总览

```
[SplashScreen]
   │ 200ms
   ▼
[Welcome] ──────Get started──────▶ [Features]
   ▲                                   │
   │ 不可返回                          │ Next
   │                                   ▼
[Privacy & Consent] ◀── Get started ── [Quick Setup]
   │ 双勾 + Enter
   ▼
[Prepare Home] ─── 国籍 chip 切换 ──▶ [Prepare Home 新数据]
   │
   ▼ (用户跳转)
[Map / Discover / Tools / You]
```

### 7.2 出入境核心流程 4 节点

```
[节点 ① 签证资格] ── visa-free ──▶ [节点 ② 海关申报]
       │                              │ green/red
       │ visa-required                 ▼
       ▼                         [节点 ③ 领事援助]
[Checklist + visa-application]         │
                                      │ 24h 内
                                      ▼
                                [节点 ④ 居留登记]
                                      │
                                      ▼
                                [Done → 离境 → 复用节点 ①]
```

---

## 8. 跨文档交叉引用

| 本文档章节 | 上游 | 下游 |
| --- | --- | --- |
| §1 onboarding 流程 | User Journeys §1 行前准备 | `OnboardingFlowPage` / `FirstRunSettingsCubit` 实现 |
| §2 Prepare 首屏契约 | IA Spec §1.2 Prepare 子树 | `PreparePage` / `PrepareHomeCubit` |
| §3 出入境 4 节点 | Personas §1 / §2 / §3 + User Journeys §1–§2 | `MockData._policyCatalog` |
| §4 Mock 数据契约 | States Spec §3.1 Prepare 的 6 状态 | `mock_interceptor.dart` 测试 |
| §5 屏级矩阵 | States Spec §3.1 + §3.5 | QA 测试用例（30 个） |

---

## 9. 待后续补充

1. **P1 多语言**（日 / 韩 / 阿 RTL）的政策卡镜像：JP / KR 已部分本地化，需扩展到全部 10 国。
2. **P1 推送策略细化**：节点 ③ 领事信息更新、节点 ① 临时暂停免签的推送时机与频次上限。
3. **P2 离线包粒度切换**：当前离线包是城市级；切到「国家 + 城市」二级结构以支持 Lin Wei 等长期停留者。
4. **危机 Journey 的 SLA 自动化**：领事信息每月自动监控 + 告警（详见 [User Journeys §4](file:///c:/Users/wenmo/.trae-cn/worktrees/旅游app/docs/superpowers/specs/2026-06-26-sightour-user-journeys.md#4-journey--危机处理)）。

---

## 附录 A · Onboarding 屏级元数据

| 屏 | Route | 父级 | 子级 | 持久化 | 离线 |
| --- | --- | --- | --- | --- | :-: |
| Welcome | `/onboarding/welcome` | — | Features | — | ✓ |
| Features | `/onboarding/features` | Welcome | Quick Setup | — | ✓ |
| Quick Setup | `/onboarding/settings` | Features | Privacy | `first_run_*` × 4（仅在 Privacy 通过后） | ✓ |
| Privacy & Consent | `/onboarding/privacy` | Quick Setup | — | `onboarding_completed` | ✓ |

## 附录 B · 出入境节点 → APP 元素 速查

| 节点 | 政策卡 | 清单条目 | 紧急入口 | 离线包内容 |
| --- | --- | --- | --- | --- |
| ① 签证资格 | 第 1 张 | RU 多 1 项 visa-application | — | 原文 URL + 官方源 |
| ② 海关申报 | 第 2 张 | — | — | 红/绿通道规则 |
| ③ 领事援助 | 第 3 张 | embassy-saved | Tools → Emergency | 完整地址 + 电话 |
| ④ 居留登记 | 第 4 张（可选） | 24h-registration | — | 派出所查询入口 |

## 附录 C · 文档变更日志

| 版本 | 日期 | 变更 |
| --- | --- | --- |
| v1.1 | 2026-06-28 | 增补 Quick Setup 两个新维度：① 入境原因（EntryReason 5 选 1） ② 入境城市（EntryCity 4 选 1）。同步扩展 mock_data.dart 的 policy/checklist/POI 数据契约（country + reason + city 三维），新增 EntryReason / EntryCity enum、FirstRunSettingsState 扩展、OnboardingSettingsPage 增 2 个 section。 |
| v1.0 | 2026-06-28 | 首版发布。新用户 onboarding 4 屏全流程 + 出入境 4 节点核心流程 + mock 数据契约 + 与 States Spec / IA Spec 交叉引用。 |
| （未来） | | |
