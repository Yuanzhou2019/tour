# Sightour 信息架构（Information Architecture）

> **文档类型**：产品 / UX 信息架构规范
> **阶段**：MVP（Phase 1）范围
> **范围**：完整 2 级屏级树（5 主屏 + 子页）+ 全局导航模型 + 路由表
> **版本**：v1.0 — 2026-06-26
> **关联文档**：
> - [用户旅程地图](file:///c:/Users/wenmo/.trae-cn/worktrees/旅游app/docs/superpowers/specs/2026-06-26-sightour-user-journeys.md) — 决定屏与屏之间的连接方式
> - [设计系统规范](file:///c:/Users/wenmo/.trae-cn/worktrees/旅游app/docs/superpowers/specs/2026-06-26-sightour-design-system.md) — 屏所使用的组件

---

## 0. 文档元信息

### 用途
本文档定义 Sightour 完整的信息架构——所有屏的层级关系、入口位置、导航模型、路由命名。

设计任何新功能时，必须先在本文档中找到它的归属屏，再确认与相邻屏的连接关系。新功能绝不能孤立存在——它必须能回答：「用户从哪进？从哪出？跟谁相邻？」

### 读者
- 产品经理（功能归属仲裁）
- UX 设计师（屏间跳转与导航模式选择）
- 前端工程师（路由配置 / 页面注册 / deep link 处理）
- 内容运营（决定内容属于哪个子页）

### 与其他文档的关系
- **上游**：[用户画像](file:///c:/Users/wenmo/.trae-cn/worktrees/旅游app/docs/superpowers/specs/2026-06-26-sightour-personas.md)（who）+ [用户旅程地图](file:///c:/Users/wenmo/.trae-cn/worktrees/旅游app/docs/superpowers/specs/2026-06-26-sightour-user-journeys.md)（when）
- **平行**：[PRD §3](file:///c:/Users/wenmo/.trae-cn/worktrees/旅游app/Sightour.MD) — 功能模块
- **下游**：[设计系统](file:///c:/Users/wenmo/.trae-cn/worktrees/旅游app/docs/superpowers/specs/2026-06-26-sightour-design-system.md)（视觉）+ [状态设计规范](file:///c:/Users/wenmo/.trae-cn/worktrees/旅游app/docs/superpowers/specs/2026-06-26-sightour-states-spec.md)（每屏 6 状态）

### 设计原则

1. **5 个主 tab 固定不变** — 不能再加 tab，也不能再减
2. **主屏 = 屏级，子页 = 屏级或模态级** — 取决于内容深度
3. **POI Detail 是跨 tab 共享屏** — 地图与榜单都能进
4. **紧急与重要屏始终可触达** — Profile 不隐藏任何关键功能
5. **子页最多 2 层深** — 不允许 3 层以上，避免迷路

---

## 1. 完整屏级树

### 1.1 顶级结构

```
Sightour APP
├── Onboarding（首次启动，无 tab bar）
│   ├── Welcome
│   └── Language Selection
│
├── Main App（5 个固定 tab）
│   ├── 1. Prepare（行前）
│   ├── 2. Map（地图）
│   ├── 3. Discover（发现）
│   ├── 4. Tools（工具）
│   └── 5. You（我的）
│
├── Modal / Bottom Sheet（覆盖层，不在主导航中）
│   ├── Submit Correction（来自 POI Detail / Profile）
│   ├── Filter Sheet（来自 Map）
│   ├── Country Selector（来自 Prepare）
│   ├── Language Switcher（来自 Profile）
│   └── Emergency Contact Sheet（来自 Tools）
│
└── Full-screen Sub-pages（不属于主 tab 的全屏页）
    ├── Privacy Policy
    ├── About Sightour
    └── Maintenance / 404
```

### 1.2 屏级树详细（2 级深度）

#### Onboarding（首次启动）

```
Onboarding
├── Welcome（品牌介绍 + 价值主张）
└── Language Selection（语言选择）
```

#### 1. Prepare（行前）

```
Prepare（行前）
├── Home（政策卡 + 行前清单 + 国籍筛选）
├── Policy Detail（点击政策卡进入）
│   ├── 30-day visa-free
│   ├── 240-hour transit
│   └── Tourist visa guide
├── Pre-arrival Checklist（完整清单视图）
└── Offline Downloads（离线包管理）
```

#### 2. Map（地图）

```
Map（地图）
├── Search + POI List（默认屏）
├── POI Detail（点击 POI 进入）
│   ├── 基础信息（地址 / 营业时间 / 联系）
│   ├── 5-Dim Reputation（点击评分进入）
│   └── Reviews（仅显示第三方引用）
└── Filter Sheet（点击筛选 chip 打开）
```

#### 3. Discover（发现 / 榜单）

```
Discover（发现）
├── Curated Rank List（精选榜单）
├── Authentic List（地道推荐）
├── Heads-up（避坑预警）
└── POI Detail（与 Map 共享同一 POI Detail）
```

#### 4. Tools（工具）

```
Tools（工具）
├── Tools Hub（6 个工具入口）
├── Currency Converter（汇率换算）
├── Phrase Book（常用语手册）
│   ├── Customs / Border（入关）
│   ├── Taxi / Transport（交通）
│   ├── Dining（就餐）
│   ├── Medical（就医）
│   └── Emergency（紧急）
├── Emergency Contacts（紧急联系）
├── Offline Downloads（与 Prepare 共享）
└── Offline Phrase Pack Download（首次访问时）
```

#### 5. You（我的）

```
You（我的）
├── Profile（偏好 + 法律）
│   ├── Preferences section
│   │   ├── Language
│   │   ├── Appearance（light / dark）
│   │   └── Units（km / mi、°C / °F）
│   ├── Get involved section
│   │   ├── Submit a correction（→ 打开 Modal）
│   │   └── Contact us（邮件）
│   └── Legal section
│       ├── Privacy Policy（→ 全屏页）
│       └── About Sightour（→ 全屏页）
└── Modal
    └── Submit Correction Sheet
```

### 1.3 Modal 与 Bottom Sheet 列表

| Modal / Sheet | 触发位置 | 高度 | 内容深度 |
| --- | --- | --- | --- |
| Submit Correction | POI Detail · Submit a correction / Profile | bottom-sheet 90% | 完整表单 |
| Filter Sheet | Map · Filter chip | bottom-sheet 50% | 6 个筛选条件 |
| Country Selector | Prepare · Filter by nationality | bottom-sheet 70% | 12 国 + 「All」 |
| Language Switcher | Profile · Language | bottom-sheet 50% | EN / 中 + 自动检测 |
| Emergency Contact Sheet | Tools · Emergency · 单条联系 | modal center | 电话 + 地址 |

### 1.4 全屏页（不属于主 tab）

| 屏 | 触发位置 | 性质 |
| --- | --- | --- |
| Privacy Policy | Profile · Privacy Policy | 静态页 |
| About Sightour | Profile · About | 静态页 |
| Maintenance | 全局（仅维护期） | 阻断所有交互 |
| 404 / Not Found | deep link 失效时 | 兜底页 |

### 1.5 不计入 MVP 的屏（P1 / P2 预留）

| 屏 | 触发 | 阶段 |
| --- | --- | --- |
| Registration / Login | 触发条件未达 | P1 |
| User Profile（实名认证后） | 同上 | P1 |
| Submit Tip（UGC） | UGC 开启后 | P1 |
| Question Detail（轻量问答） | 同上 | P1 |
| Trip Detail | 自定义行程 | P1 |
| Task Detail | 探店任务 | P2 |
| Wallet | 任务收益 | P2 |
| IM Chat | 任务沟通 | P2 |

---

## 2. 全局导航模型

### 2.1 Bottom Tab Bar（底部主导航）

**5 个固定 tab，永不增减**：

```
┌──────────────────────────────────────────────┐
│ [ Prepare ]  [ Map ]  [ Discover ]           │
│ [ Tools  ]  [ You                          ] │
└──────────────────────────────────────────────┘
```

| # | Tab | Icon | 选中条件 | 备注 |
| :-: | --- | --- | --- | --- |
| 1 | Prepare | 文具图标 / 罗盘 | 默认选中 | 进入即显示 Home |
| 2 | Map | 地图图标 | 用户点击 | 每次进入都重新定位 |
| 3 | Discover | 钻石 / 列表图标 | 用户点击 | 保留上次 tab |
| 4 | Tools | 工具箱图标 | 用户点击 | 保留滚动位置 |
| 5 | You | 用户头像图标 | 用户点击 | 保留滚动位置 |

**Tab 切换行为**：
- 切 tab：屏间 200ms `--ease-out` 过渡（无滑动效果）
- 同一 tab 内导航：保留栈，可返回
- 长按 tab：滚到屏顶

### 2.2 Top App Bar（顶部栏）

**绝大多数屏无顶栏**（沉浸式设计），仅以下场景出现：

| 场景 | 顶栏内容 | 高度 |
| --- | --- | --- |
| Modal / 全屏子页 | 返回箭头 + 标题 | 44px |
| POI Detail | 关闭按钮 + Share + Save | 44px（半透明覆盖） |
| 隐私政策 / 关于 | 返回箭头 + 标题 | 44px |

**Onboarding 例外**：Welcome 屏无顶栏（沉浸），Language 屏有「Skip」按钮在右上。

### 2.3 Back 按钮（返回机制）

| 场景 | Back 行为 |
| --- | --- |
| 主屏内子页 | 返回父屏（栈式） |
| Modal / Sheet | 关闭 Modal，回到原屏 |
| 全屏子页（Privacy / About） | 返回 Profile |
| 跨 tab 跳转 | 返回原 tab，再点目标 tab |
| Onboarding | 不可返回（首次启动） |

**iOS 左滑手势 / Android 系统返回键**：与 UI Back 按钮完全一致。

### 2.4 屏内导航

#### ListItem 点击 → POI Detail
- 来源屏：Map / Discover / Search Results
- 跳转：底部 sheet 升起（90% 高）
- 返回：sheet 下拉关闭

#### Card 点击 → 详情
- Policy Card → Policy Detail（全屏子页）
- Checklist Item → 不跳转，仅勾选状态切换

#### Chip 点击 → 筛选 / 跳转
- Map filter chip → 打开 Filter Sheet
- Prepare country chip → 打开 Country Selector
- Discover tab chip → 切换 tab 内容（不离开屏）

### 2.5 跨 Tab 跳转

**原则**：尽量避免跨 tab 跳转。仅以下场景允许：

| 触发 | 跳转到 | 备注 |
| --- | --- | --- |
| Home 行前清单完成 → 跳转 | Map | 「View places near you」 |
| POI Detail → 查看地图位置 | Map | 单次跳转 + 高亮 |
| POI Detail 提交纠错后 → 返回 | POI Detail | 不跳到 Profile |
| Profile 删除离线包 → 跳回 | Prepare | 让用户重新下载 |

**禁止**：
- Prepare 自动跳 Map（用户没主动操作就跳 tab 是反模式）
- 任何屏跳到 Onboarding（首次启动后才不再出现）

### 2.6 Deep Link 支持（P1 预留）

```
sightour://poi/{poi-id}              → POI Detail
sightour://policy/{policy-id}         → Policy Detail
sightour://tool/fx                    → Currency Converter
sightour://tool/emergency             → Emergency Contacts
```

P1 阶段实现，P0 仅 route 名预留。

---

## 3. 路由表

### 3.1 路由命名规则

```
/{tab-name}                  → 主 tab 默认屏
/{tab-name}/{sub-page}       → 子页
/{tab-name}/{sub-page}/{id}   → 带 ID 的详情
/modal/{modal-name}           → Modal 屏
/full/{full-page-name}        → 全屏子页
/onboarding/{step}            → Onboarding 步骤
```

**命名规范**：
- 全小写
- 单词用 `-` 分隔（如 `pre-arrival-checklist`）
- 资源用单数（`poi` 不是 `pois`）
- 动态段用 `:` 前缀（如 `poi/:id`）

### 3.2 完整路由清单

#### Onboarding

| Route | 屏名 | 守卫 |
| --- | --- | --- |
| `/onboarding/welcome` | Welcome | 首次启动 |
| `/onboarding/language` | Language Selection | 首次启动 |

#### Prepare

| Route | 屏名 | 父 tab |
| --- | --- | --- |
| `/prepare` | Home（默认） | Prepare |
| `/prepare/policy/:id` | Policy Detail | Prepare |
| `/prepare/checklist` | Pre-arrival Checklist | Prepare |
| `/prepare/offline` | Offline Downloads | Prepare |

#### Map

| Route | 屏名 | 父 tab |
| --- | --- | --- |
| `/map` | Search + POI List | Map |
| `/map/poi/:id` | POI Detail | Map |
| `/map/poi/:id/reputation` | 5-Dim Reputation | Map |

#### Discover

| Route | 屏名 | 父 tab |
| --- | --- | --- |
| `/discover` | Curated List（默认） | Discover |
| `/discover/:category` | Authentic / Heads-up | Discover |
| `/discover/poi/:id` | POI Detail（共享） | Discover |

#### Tools

| Route | 屏名 | 父 tab |
| --- | --- | --- |
| `/tools` | Tools Hub | Tools |
| `/tools/fx` | Currency Converter | Tools |
| `/tools/phrases` | Phrase Book Index | Tools |
| `/tools/phrases/:category` | Phrase Book Detail | Tools |
| `/tools/emergency` | Emergency Contacts | Tools |

#### You

| Route | 屏名 | 父 tab |
| --- | --- | --- |
| `/you` | Profile | You |

#### Modal

| Route | 屏名 | 触发位置 |
| --- | --- | --- |
| `/modal/correction` | Submit Correction | POI / Profile |
| `/modal/filter` | Filter Sheet | Map |
| `/modal/country` | Country Selector | Prepare |
| `/modal/language` | Language Switcher | Profile |
| `/modal/emergency-contact` | Emergency Contact Detail | Tools |

#### Full-screen

| Route | 屏名 | 触发位置 |
| --- | --- | --- |
| `/full/privacy` | Privacy Policy | Profile |
| `/full/about` | About Sightour | Profile |
| `/full/maintenance` | Maintenance | 全局（维护期） |
| `/full/not-found` | 404 | 兜底 |

### 3.3 跳转策略

| 跳转类型 | 实现 | 例子 |
| --- | --- | --- |
| 同 tab 子页 | `push`（栈） | Map → POI Detail |
| 跨 tab 子页 | `replace`（替换栈） | Discover → POI Detail 时显示 Map tab |
| Modal | `present`（覆盖） | POI Detail → Correction |
| 全屏子页 | `push`（栈） | Profile → Privacy |
| Back | `pop` | 返回上一屏 |

### 3.4 错误兜底

| 情况 | 处理 |
| --- | --- |
| Route 不存在 | 跳 `/full/not-found` |
| POI ID 不存在 | POI Detail 显示「This place has been removed」+ 返回按钮 |
| 离线包损坏 | 提示「Offline pack is corrupted」+ 重新下载入口 |
| 主屏数据全坏 | 显示 Error 态（参考 States Spec） |

---

## 4. 屏级关系与流程图

### 4.1 父子关系总览

```
Prepare
├── Home ──── Policy Detail (push)
├── Home ──── Checklist (push)
├── Checklist ──── Home (pop)
└── Home ──── Offline (push)

Map
├── Search ──── POI Detail (push / bottom-sheet)
├── POI Detail ──── Reputation (push)
├── POI Detail ──── Correction (present modal)
└── POI Detail ──── Filter Sheet (present modal)

Discover
├── Curated ──── POI Detail (replace → 显示 Map tab)
├── Authentic ──── POI Detail (replace)
└── Heads-up ──── POI Detail (replace)

Tools
├── Hub ──── FX / Phrases / Emergency / Offline (push)
└── Phrases ──── Category Detail (push)

You
├── Profile ──── Privacy (push)
├── Profile ──── About (push)
├── Profile ──── Correction (present modal)
└── Profile ──── Language Switcher (present modal)
```

### 4.2 主流程图（用户视角）

```
┌─────────────────────────────────────────────┐
│ Onboarding (首次启动)                        │
│   Welcome → Language Selection              │
└──────────────────┬──────────────────────────┘
                   │
                   ↓
         ┌─────────────────┐
         │  Prepare (Tab1) │ ←── 默认入口
         └────────┬────────┘
                  │
     ┌────────────┼────────────┬────────────┐
     ↓            ↓            ↓            ↓
  Policy      Checklist     Offline    Country
  Detail                                 Selector
     │            │            │            │
     └────────────┴────────────┴────────────┘
                  │
                  ↓ (用户想找地方)
         ┌─────────────────┐
         │   Map (Tab2)    │
         └────────┬────────┘
                  │
       Filter Sheet（modal）
                  │
            POI Detail（push / sheet）
                  │
        ┌─────────┼─────────┐
        ↓         ↓         ↓
   Reputation Correction  Share/Save

         ┌─────────────────┐
         │ Discover (Tab3) │ ←── 用户浏览榜单
         └────────┬────────┘
                  │
            POI Detail（replace，跨 tab）

         ┌─────────────────┐
         │  Tools (Tab4)   │ ←── 紧急 / 查询
         └────────┬────────┘
                  │
        ┌─────────┼─────────┬─────────┐
        ↓         ↓         ↓         ↓
       FX     Phrases   Emergency  Offline

         ┌─────────────────┐
         │   You (Tab5)    │ ←── 偏好 / 提交纠错
         └────────┬────────┘
                  │
        ┌─────────┼─────────┐
        ↓         ↓         ↓
   Preferences  Submit  Privacy/About
               Correction
```

### 4.3 同级跳转原则

- **同 tab 子页**：栈式，可无限 Back
- **跨 tab 子页**：替换栈（保持主 tab 5 个不动），从 POI Detail 返回会回到原 tab
- **Modal**：覆盖栈，返回自动关闭 Modal
- **不共享 back stack**：跨 tab 跳转不会污染主 tab 历史

---

## 5. 屏级权限与可达性

### 5.1 未登录可访问（游客模式）

✅ 所有屏：MVP 阶段无登录，所有屏游客模式可访问。

### 5.2 需要权限才能访问

| 屏 | 权限 | 拒绝时降级 |
| --- | --- | --- |
| Map | 定位 | 可手动输入城市名 |
| Profile · 推送 Toggle | 通知 | toggle 关闭，保留「By email」 |
| Submit Correction · 上传图片 | 相机 / 相册 | 改用纯文字反馈 |

### 5.3 离线可访问

| 屏 | 离线可用性 | 备注 |
| --- | :-: | --- |
| Prepare Home | ✓ | 缓存政策卡 |
| Policy Detail | ✓ | 缓存 |
| Checklist | ✓ | 完全本地 |
| Map | △ | 缓存瓦片 + 缓存 POI |
| POI Detail | ✓ | 完全本地 |
| Discover 榜单 | ✓ | 月度更新 |
| Tools Hub | ✓ | 全静态 |
| Currency | ✓ | 缓存最新汇率 |
| Phrases | ✓ | 完全本地 |
| Emergency | ✓ | 完全本地 |
| Profile | ✓ | 完全本地 |
| Submit Correction | ✓ | 提交后入队，恢复网络后发送 |

---

## 6. 屏级元数据（用于设计 / 测试）

### 6.1 每屏元数据

| 屏名 | Route | 类型 | Tab | 父级 | 子级 | 模态触发 | 离线 |
| --- | --- | --- | :-: | --- | --- | --- | :-: |
| Welcome | `/onboarding/welcome` | page | — | — | Language | — | ✓ |
| Language | `/onboarding/language` | page | — | Welcome | — | — | ✓ |
| Prepare Home | `/prepare` | page | Prepare | — | Policy / Checklist / Offline | Country Selector | ✓ |
| Policy Detail | `/prepare/policy/:id` | page | Prepare | Prepare | — | — | ✓ |
| Pre-arrival Checklist | `/prepare/checklist` | page | Prepare | Prepare | — | — | ✓ |
| Offline Downloads | `/prepare/offline` | page | Prepare | Prepare | — | — | ✓ |
| Map Search | `/map` | page | Map | — | POI Detail | Filter | △ |
| POI Detail | `/map/poi/:id` | sheet | Map | Map Search | Reputation | Correction | ✓ |
| 5-Dim Reputation | `/map/poi/:id/reputation` | page | Map | POI Detail | — | — | ✓ |
| Discover Curated | `/discover` | page | Discover | — | POI Detail | — | ✓ |
| Discover Authentic | `/discover/authentic` | page | Discover | Discover | POI Detail | — | ✓ |
| Discover Heads-up | `/discover/heads-up` | page | Discover | Discover | POI Detail | — | ✓ |
| Tools Hub | `/tools` | page | Tools | — | FX / Phrases / Emergency / Offline | — | ✓ |
| Currency | `/tools/fx` | page | Tools | Tools | — | — | ✓ |
| Phrase Book Index | `/tools/phrases` | page | Tools | Tools | Category | — | ✓ |
| Phrase Book Detail | `/tools/phrases/:cat` | page | Tools | Phrase Book Index | — | — | ✓ |
| Emergency | `/tools/emergency` | page | Tools | Tools | — | Contact Sheet | ✓ |
| Profile | `/you` | page | You | — | Privacy / About | Correction / Language | ✓ |
| Privacy | `/full/privacy` | page | — | Profile | — | — | ✓ |
| About | `/full/about` | page | — | Profile | — | — | ✓ |
| Submit Correction | `/modal/correction` | modal | — | POI / Profile | — | — | ✓ |
| Filter Sheet | `/modal/filter` | modal | — | Map | — | — | ✓ |
| Country Selector | `/modal/country` | modal | — | Prepare | — | — | ✓ |
| Language Switcher | `/modal/language` | modal | — | Profile | — | — | ✓ |
| Emergency Contact Sheet | `/modal/emergency-contact` | modal | — | Tools Emergency | — | — | ✓ |
| Maintenance | `/full/maintenance` | page | — | — | — | — | ✓ |
| Not Found | `/full/not-found` | page | — | — | — | — | ✓ |

**屏总数**：27 个（21 page + 5 modal + 1 sheet 类型 = 27）

### 6.2 屏级命名规范（开发）

| 资源 | 单数 | 复数 | 例 |
| --- | --- | --- | --- |
| POI | `poi` | `pois` | `/map/poi/123` |
| Policy | `policy` | `policies` | `/prepare/policy/visa-free-30d` |
| Phrase | `phrase` | `phrases` | `/tools/phrases/medical` |
| Correction | `correction` | `corrections` | `/modal/correction` |

**资源 ID**：
- 数字 ID：`/map/poi/123`（数据库自增）
- 语义 ID：`/prepare/policy/visa-free-30d`（policy 用语义 ID，方便分享）

---

## 附录 A · 与现有原型的对应

| 原型屏 | 本文档对应 Route |
| --- | --- |
| Welcome | `/onboarding/welcome` |
| Language | `/onboarding/language` |
| Prepare Home | `/prepare` |
| Map + POI | `/map` + `/map/poi/:id` |
| POI Detail | `/map/poi/:id` |
| 5-Dim Reputation | `/map/poi/:id/reputation` |
| Curated Rank | `/discover` |
| Tools Hub | `/tools` |
| Currency | `/tools/fx` |
| Phrase Book | `/tools/phrases` + `/tools/phrases/:cat` |
| Emergency | `/tools/emergency` |
| Profile | `/you` |

**覆盖率**：12 / 27（44%）— 本文档包含原型尚未实现的屏（POI Reputation、Checklist 完整版、Discover 多个 tab 等），是完整蓝图而非现状快照。

---

## 附录 B · 屏级状态交叉引用

每屏的 6 状态由 [States Spec](file:///c:/Users/wenmo/.trae-cn/worktrees/旅游app/docs/superpowers/specs/2026-06-26-sightour-states-spec.md) 定义。本文档负责的是屏的「位置」与「连接」。

| 屏 | States Spec 章节 |
| --- | --- |
| Prepare Home | §3.1 |
| Map | §3.2 |
| Discover | §3.3 |
| Tools | §3.4 |
| Profile | §3.5 |

---

## 附录 C · 与 PRD 模块的对应

| PRD 模块 | 本文档对应子树 |
| --- | --- |
| §3.1 入境准备 | Prepare 子树 |
| §3.2 地图与出行 | Map 子树 |
| §3.3 目的地口碑 | Map.POI + Discover 子树 |
| §3.4 实用工具集 | Tools 子树 |
| §3.5 用户与账户 | You 子树 |
| §3.6 系统基础 | 全局（i18n / 单位切换 / 暗黑模式） |

---

## 附录 D · 待后续补充

1. **P1 Deep Link 实现细节**（Universal Links / App Links）
2. **P1 多语言扩展**（日 / 韩 / 阿）的 IA 镜像
3. **P2 任务模式子树**（Task / Wallet / IM 屏）
4. **用户自定义收藏的 IA 位置**（放 Map 顶部？新增 tab？）
5. **离线包子树**（城市切换后是否新增 tab？）

---

## 附录 E · 文档变更日志

| 版本 | 日期 | 变更 |
| --- | --- | --- |
| v1.0 | 2026-06-26 | 首版发布。27 屏完整 IA（21 page + 5 modal + 1 sheet）+ 5 tab 全局导航 + 完整路由表。 |
| （未来） | | |
