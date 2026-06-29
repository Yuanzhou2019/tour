# Sightour 状态设计规范（States Spec）

> **文档类型**：产品 / UX 状态设计规范
> **阶段**：MVP（Phase 1）范围
> **范围**：6 个状态（loading / empty / error / success / offline / no-permission）× 5 个主屏（Prepare / Map / Discover / Tools / You）
> **版本**：v1.0 — 2026-06-26
> **关联文档**：
> - [用户旅程地图](file:///c:/Users/wenmo/.trae-cn/worktrees/旅游app/docs/superpowers/specs/2026-06-26-sightour-user-journeys.md) — 决定每屏何时进入何种状态
> - [设计系统规范](file:///c:/Users/wenmo/.trae-cn/worktrees/旅游app/docs/superpowers/specs/2026-06-26-sightour-design-system.md) — 状态所使用的视觉与组件

---

## 0. 文档元信息

### 用途
本文档定义 Sightour 在每个主屏的 6 个数据态下应该呈现什么、说什么、让用户做什么。

设计任何屏时必须同时设计其 6 个状态——只设计「数据加载好」的 happy path 是新人最常见的失误，会导致上线后 30% 的用户卡在失败/空态而流失。

### 读者
- 视觉设计师（Figma 每个屏需画 6 个状态变体）
- 前端工程师（每屏实现 6 个分支）
- QA 测试（每个屏 6 状态都需要测试用例）
- 内容运营（empty / error 文案的撰写）

### 6 个状态定义

| 状态 | 触发条件 | 持续时长 | 用户感受 |
| --- | --- | --- | --- |
| **Loading** | 数据请求中（API 调用 / 离线包解析 / 搜索） | < 200ms 不可见；200ms–2s 显示 skeleton；> 2s 显示 spinner + 文案 | 等待 |
| **Empty** | 请求成功但无数据（搜索无结果、清单全勾选、收藏空） | 持续到用户操作 | 空白 / 迷茫 |
| **Error** | 请求失败 / 解析失败 / 系统错误 | 持续到用户重试或离开 | 受挫 / 受困 |
| **Success** | 请求成功且有数据 | 持续显示数据 | 满足 |
| **Offline** | 无网络（飞行模式 / SIM 无信号 / WiFi 断开） | 持续到网络恢复 | 焦虑 |
| **No-permission** | 用户拒绝授予关键权限（定位 / 通知 / 相机） | 持续到用户授权或关闭 | 警觉 / 困惑 |

### 状态切换原则

1. **Loading → Success**：优先替换数据，淡出 skeleton（200ms `--ease-out`）。
2. **Loading → Error**：超过 2s 自动切换 Error 态，显示「Try again」。
3. **Success → Offline**：网络断开时 banner 顶部出现「You're offline」，数据保留。
4. **Success → Error**：罕见（如数据库损坏），显示「Something went wrong · Try again」。
5. **Empty ≠ Error**：空态不是错误，必须有正向文案引导（如「Try expanding your search」）。
6. **Offline 优先级最高**：任何屏在 Offline 时都显示 Offline 态而非 Loading / Error。

---

## 1. 通用状态框架

### 1.1 Loading（加载态）

#### 视觉
- **首屏加载**：显示 skeleton（与最终内容相同结构）。
- **列表加载**：列表项 skeleton × 5–8 条。
- **详情加载**：顶部 hero skeleton + 文字行 × 5。
- **操作加载**（如提交表单）：按钮内 spinner，文字替换为「Loading…」。
- **下拉刷新**：从顶部下拉指示器 + spinner。

#### 时长分级
| 时长 | 处理 |
| --- | --- |
| < 200ms | 不显示 loading（避免闪烁） |
| 200ms – 2s | Skeleton |
| 2s – 10s | Skeleton + 「This is taking longer than usual…」 |
| > 10s | Spinner + 「Still loading · Cancel」 |

#### 文案
- 默认无文案（仅 skeleton）。
- 超时显示「Still loading…」等温和文案，不指责用户或系统。
- 永远不用「Loading…」+ spinner 这种重复表述。

#### 动效
- Skeleton：shimmer 1.5s 循环。
- Spinner：rotate 1s 线性循环。

---

### 1.2 Empty（空态）

#### 视觉
- 中央插图（可选，朴素 SVG / icon）
- 主标题（一句话说明）
- 副标题（一句话解释为什么 + 怎么解决）
- 行动按钮（如「Try another search」）

#### 文案原则
- **永远不**用「No data」「No results」这种冷感文案。
- **永远**给一个动作（搜索词建议、回退、清除筛选）。
- 文案要让用户知道「不是 APP 坏了，是没有匹配项」。

#### 示例模板
```
🔍 [插图]

We couldn't find anything for "xxx"

Try a different keyword, or check the spelling.
[ Try popular searches ]
```

---

### 1.3 Error（错误态）

#### 视觉
- 中央插图（红色 / 错误主题）
- 主标题（用户语言说发生了什么）
- 副标题（解释为什么 + 怎么解决）
- 主行动按钮「Try again」
- 次行动按钮「Go back」

#### 文案原则
- **永远不**用「Error」「Failed」「Oops」这种技术语言。
- **永远**说「Something went wrong on our end」/ 「We couldn't reach the server」——把责任放平台身上。
- 提供具体的下一步动作。

#### 重试策略
| 失败次数 | 处理 |
| --- | --- |
| 第 1 次 | 自动重试（静默） |
| 第 2 次 | 自动重试（静默） |
| 第 3 次 | 显示「Try again」按钮 |
| 第 5 次 | 显示「Contact support」选项 |

#### 网络相关错误
- 文案：「We can't reach Sightour right now. Check your connection or try again.」
- 显示信号强度图标辅助判断。

---

### 1.4 Success（成功态）

#### 视觉
- 数据正常呈现。
- 部分场景需要辅助确认（提交成功、收藏成功）。

#### 操作反馈 Toast
| 触发动作 | Toast 文案（EN / 中） |
| --- | --- |
| 提交纠错 | 「Thanks — we'll review within 48 hours · 已收到，48 小时内审核」 |
| 收藏 POI | 「Saved to your list · 已收藏」 |
| 下载离线包 | 「Shanghai offline pack ready (240 MB) · 上海离线包已就绪」 |
| 标记清单完成 | 「All set · 已完成」 |

#### Toast 时长
- 成功：3000ms
- 错误：5000ms
- 用户操作完成型（收藏、勾选）：2000ms

---

### 1.5 Offline（离线态）

#### 视觉
- 顶部出现 offline banner（常驻）：
  ```
  ┌─────────────────────────────────┐
  │ ⚠ You're offline · 离线模式  │
  └─────────────────────────────────┘
  ```
- Banner 颜色：`--amber-50` 底 + `--amber-500` 文字
- 高度：36px，紧贴状态栏

#### 数据策略
- 离线时优先用本地缓存。
- 缓存命中：直接显示 Success 态（不显示 Offline banner？争议——本文档规定**显示** banner，因为透明度优先）。
- 缓存未命中：显示 Empty 态 + 文案「Will load when you're back online · 网络恢复后可查看」。

#### 何时检测 Offline
- 启动时检测：API 探测失败 → Offline。
- 运行时检测：网络请求连续 2 次失败 → Offline。
- 网络恢复：探测成功后等 1s 确认稳定 → 移除 banner。

#### 文案（按语言）
- EN:「You're offline · Showing cached content」
- 中:「离线模式 · 显示缓存内容」

---

### 1.6 No-permission（无权限态）

#### 视觉
- 全屏 / 半屏 overlay
- 中央插图（权限主题）
- 主标题（说明需要什么权限 + 为什么）
- 主行动按钮「Open Settings」
- 次行动按钮「Not now」

#### 三类权限的处理
| 权限 | 必需性 | 处理 |
| --- | --- | --- |
| 定位 | 必需（Map） | 首次进入 Map 时请求；拒绝后显示「Find places around you」可输入城市 |
| 通知 | 可选 | 首次设置清单推送时请求；拒绝后无影响 |
| 相机 | 可选 | POI 详情纠错时请求；拒绝后改用「Type your feedback instead」 |

#### 文案原则
- 说明**为什么**需要这个权限（不能只说「请允许位置权限」）。
- 提供**降级体验**而不是「必须授权才用」。
- 永远不弹窗式强制要求授权。

#### 权限被永久拒绝的处理
- 不再弹窗请求（系统策略）。
- 显示「Open Settings」按钮跳转到系统设置。

---

## 2. 屏级状态矩阵总览

| 屏 | Loading | Empty | Error | Success | Offline | No-permission |
| --- | :-: | :-: | :-: | :-: | :-: | :-: |
| Prepare (Home) | ✓ | ⚠ 部分 | ✓ | ✓ | ✓ | — |
| Map | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| Discover | ✓ | ⚠ 部分 | ✓ | ✓ | ✓ | — |
| Tools | — | — | — | ✓ | ✓ | — |
| You (Profile) | — | — | — | ✓ | — | ✓（通知） |

图例：✓ 必有 / ⚠ 部分屏 / — 不适用

---

## 3. 屏级详细状态定义

### 3.1 Prepare（Home 首页）

#### 3.1.1 Success（默认）
- 顶部品牌区：「Good morning · 早安」
- 国籍筛选 chip（持久可见）
- 3 张政策卡（按国籍筛选后显示）
- 行前清单（带进度条）
- 底部：「Download offline pack」CTA

#### 3.1.2 Loading
- **首次启动**：显示 5 个 skeleton 行（与最终政策卡同高）
- **切换国籍**：chip 切换时卡片区域 fade 200ms
- **清单勾选**：实时无 loading（本地操作）

#### 3.1.3 Empty
- 仅当用户国籍不在我们支持列表时显示（如某非洲国家）：
  ```
  🌍
  We don't have policy details for [country] yet
  
  Most travellers from your region need a tourist visa.
  Apply at your nearest Chinese embassy.
  
  [ Official visa guide (PDF) ]   [ Submit correction ]
  ```

#### 3.1.4 Error
- 政策数据加载失败：
  ```
  ⚠️
  We couldn't load the latest entry rules
  
  This might be temporary. Try again, or check the
  official source.
  
  [ Try again ]   [ Official policy source ]
  ```

#### 3.1.5 Offline
- 顶部 offline banner
- 政策卡：显示缓存版本 + 「Last updated 3 days ago」
- 清单：完全可勾选（本地）
- CTA：「Download offline pack」变 disabled，文案「Already up to date」

#### 3.1.6 No-permission
- 不适用（Home 不需要权限）

---

### 3.2 Map（地图与 POI 搜索）

#### 3.2.1 Success
- 顶部搜索栏 + 5 个筛选 chip
- 地图区域 + POI 标记
- 底部 POI 列表（可上滑全屏）

#### 3.2.2 Loading
- 首次进入：地图区域显示 map skeleton（浅灰矩形）+ 底部列表 5 个 skeleton 项
- POI 详情：底部 sheet 升起 skeleton（与 POI 详情同结构）
- 搜索中：搜索栏右侧 spinner，下方显示结果 skeleton

#### 3.2.3 Empty
- 搜索无结果：
  ```
  🔍
  
  No places match "[search keyword]"
  
  Try a broader keyword or clear your filters.
  
  [ Clear filters ]   [ Show all POIs ]
  ```
- 定位无 POI：地图上显示「No places found within 2km · Try a wider area」

#### 3.2.4 Error
- API 调用失败：
  ```
  ⚠️
  
  We can't load the map right now
  
  This might be a connection issue.
  
  [ Try again ]   [ Use last cached map ]
  ```
- 定位失败：
  ```
  📍
  
  We couldn't find your location
  
  Enable location services, or search for a place manually.
  
  [ Open Settings ]   [ Search manually ]
  ```

#### 3.2.5 Offline
- 顶部 offline banner
- 地图：显示缓存瓦片（上次下载区域）+ 标记「Cached area」
- 搜索：完全本地（命中离线包结果）
- 底部：「Search works offline · 离线可搜索」

#### 3.2.6 No-permission（定位被拒绝）
- 半屏 overlay：
  ```
  📍
  
  Find places near you
  
  Allow location access to see what's around you.
  You can still search for any place by name.
  
  [ Open Settings ]   [ Search by name ]
  ```
- 降级：默认搜索框聚焦，光标在搜索栏

---

### 3.3 Discover（榜单与口碑）

#### 3.3.1 Success
- 顶部：「Discover Shanghai」+ 3 个 tab（Curated / Authentic / Heads-up）
- 榜单头（深色 + sand 金 Top3 徽章）
- POI 列表卡片（带 5 维评分 + chips）

#### 3.3.2 Loading
- 首次进入：榜单头 skeleton + 列表 5 个 skeleton 卡
- 切换 tab：内容 fade 200ms（无 spinner，无 skeleton 重新出现）

#### 3.3.3 Empty
- 「All 200 POIs verified · try Curated instead」：
  ```
  📋
  
  Nothing in this category yet
  
  Our editors review 5 new places each month.
  Try another category in the meantime.
  
  [ View Curated ]   [ View Authentic ]
  ```

#### 3.3.4 Error
- 榜单加载失败：
  ```
  ⚠️
  
  We couldn't load the rankings
  
  Rankings are updated monthly. Try again, or view the
  last cached version.
  
  [ Try again ]   [ View cached ]
  ```

#### 3.3.5 Offline
- 顶部 offline banner
- 榜单头：显示缓存版本 + 「Last updated 12 days ago · Last verified Jun 14」
- 列表：完全可滚动
- 提示：「Rankings may be outdated offline · 离线榜单可能不是最新」

#### 3.3.6 No-permission
- 不适用（Discover 不需要权限）

---

### 3.4 Tools（实用工具集）

#### 3.4.1 Success
- 6 个工具卡片（汇率 / 紧急 / 常用语 / 离线包 / 设置 / 单位切换）
- 顶部：「Tools · 工具」

#### 3.4.2 Loading
- 不适用（工具是静态入口）

#### 3.4.3 Empty
- 不适用

#### 3.4.4 Error
- 汇率 API 失败（汇率子页）：
  ```
  ⚠️
  
  We can't get today's rates
  
  Showing yesterday's rates from cache.
  
  [ Refresh ]   [ Use cached (1.00 USD = 7.18 CNY) ]
  ```

#### 3.4.5 Offline
- 顶部 offline banner
- 汇率：显示「Last updated [date] · cached」
- 紧急：完全可用
- 常用语：完全可用
- 离线包：显示「Already downloaded · 已下载」

#### 3.4.6 No-permission
- 不适用

---

### 3.5 You（个人页 / Profile）

#### 3.5.1 Success
- 顶部：「You · 我的」
- Preferences section（语言 / 主题 / 单位）
- Get involved section（提交纠错 / 联系我们）
- Legal section（隐私政策 / 关于）

#### 3.5.2 Loading
- 不适用（Profile 是静态页面）

#### 3.5.3 Empty
- 不适用

#### 3.5.4 Error
- 不适用

#### 3.5.5 Offline
- 完全可用（全部为本地设置）

#### 3.5.6 No-permission（通知权限）
- 在 Toggle「政策变动推送」首次开启时：
  ```
  🔔
  
  Get notified about policy changes
  
  We send 1–2 push notifications per month,
  never for marketing.
  
  [ Allow notifications ]   [ Not now ]
  ```
- 用户拒绝后：toggle 关闭，但「Send anyway by email?」保留作为 fallback

---

## 4. 跨屏通用规则

### 4.1 Toast 通用规则

#### 出现位置
- 屏幕底部，tabbar 上方 16px
- 横向居中

#### 优先级
- 同时多个 toast：旧的先消失，新的排队
- Toast 不打断用户操作（用户可继续点击屏幕）

#### 自动消失
- 默认 3000ms（成功）/ 5000ms（错误）
- 用户点击 toast 立即消失
- 新 toast 出现时立即顶掉旧的

#### 文案语气（详见 [Microcopy & Tone of Voice](#)）
- 不指责用户
- 不说技术术语
- 提供下一步动作

### 4.2 错误码 → 用户语言映射

后端错误码 → 用户语言模板：

| 后端码 | 用户文案（EN / 中） |
| --- | --- |
| `NETWORK_TIMEOUT` | 「Connection timed out · 连接超时」 |
| `NETWORK_OFFLINE` | 「You're offline · 离线模式」 |
| `SERVER_500` | 「We can't reach our servers · 服务器暂时无法访问」 |
| `NOT_FOUND` | 「We couldn't find that · 未找到」 |
| `RATE_LIMITED` | 「Too many requests · 请稍后再试」 |
| `INVALID_INPUT` | 「Please check your input · 请检查输入」 |
| `INTERNAL_ERROR` | 「Something went wrong · 出错了」 |

### 4.3 错误恢复策略

| 场景 | 重试策略 |
| --- | --- |
| 网络错误 | 自动重试 3 次（间隔 1s / 2s / 4s） |
| 服务器 500 | 自动重试 2 次（间隔 2s / 5s） |
| 速率限制 | 不重试，按服务器指示时间 |
| 数据解析失败 | 不重试，记录错误到日志 |
| 用户操作错误 | 不重试，显示表单验证错误 |

### 4.4 Skeleton 与真实内容同步

加载完成后，skeleton 替换为真实内容时：
- 不闪烁（避免布局跳动）
- 不重置滚动位置
- 图片渐进式加载（先 blur 占位，再原图）

---

## 5. 无障碍（A11y）与本地化

### 5.1 屏幕阅读器（Screen Reader）

#### Loading 态
- 加 `aria-live="polite"` 让屏幕阅读器朗读「Loading」
- 加 `aria-busy="true"` 表示当前区域正在加载

#### Empty 态
- 主标题加 `role="heading" aria-level="2"`
- 行动按钮加 `aria-label`（不只是图标）

#### Error 态
- 错误内容加 `role="alert" aria-live="assertive"`
- 让屏幕阅读器立即朗读错误

#### Offline 态
- Banner 加 `role="status" aria-live="polite"`
- 网络恢复时朗读「Back online」

### 5.2 减少动效（Reduced Motion）

`@media (prefers-reduced-motion: reduce)` 时：
- Skeleton shimmer 关闭
- Spinner 旋转关闭
- 屏间切换改为即时（无淡入淡出）
- Toast 出现改为直接显示（无滑入）

### 5.3 国际化文案长度

- 中英文案长度差异约 ±30%
- 所有按钮预留足够宽度（最宽语言版本）
- Toast 最多 2 行（超出截断 + 「…」）
- Empty / Error 主标题 ≤ 30 字符（英文）/ 14 字（中文）

### 5.4 色盲友好

- 不只用颜色传达信息（如 chip 必须配合图标）
- 所有「风险 / 警示 / 成功」配色已通过色盲模拟测试
- 红色（clay）不单独使用，必带 ⚠️ 图标

---

## 6. 屏级测试用例模板

每个屏的 QA 测试必须覆盖以下矩阵：

```
[Test Case] Home - Empty State

[Pre-conditions]
- User language: English
- User nationality: [unsupported country]
- Offline pack: not downloaded
- App version: v1.0.0

[Steps]
1. Launch app
2. Skip onboarding (Guest mode)
3. Land on Prepare tab
4. Verify nationality chip shows [country]
5. Verify empty state shown:
   - Main title: "We don't have policy details..."
   - Subtitle: "Most travellers from your region..."
   - Primary button: "Official visa guide (PDF)"
   - Secondary button: "Submit correction"

[Expected Result]
- Empty state visible
- All buttons tappable
- No broken layout
- Screen reader announces main title

[Post-conditions]
- App remains on Prepare tab
- No data was cached
```

每个屏每个状态一个测试用例 = 5 屏 × 6 状态 = 30 个测试用例（部分屏状态少）。

---

## 附录 A · 状态图标库

| 状态 | 图标建议 | 颜色 | 来源 |
| --- | --- | --- | --- |
| Loading | spinner | `--slate-500` | 设计系统 |
| Empty | 放大镜 / 文件 | `--slate-300` | 设计系统 |
| Error | 警告三角 | `--clay-600` | 设计系统 |
| Success | ✓ 对勾 | `--sage-600` | 设计系统 |
| Offline | 离线云 | `--amber-500` | 设计系统 |
| No-permission | 锁 / 位置 | `--blue-500` | 设计系统 |

所有图标使用 [Lucide Icons](https://lucide.dev) 或同等开源 SVG 库。

---

## 附录 B · 状态切换流程图

```
                    ┌──────────────┐
                    │   启动 APP    │
                    └──────┬───────┘
                           │
                    ┌──────▼─────────┐
                    │  检测网络/权限  │
                    └──────┬─────────┘
                           │
        ┌──────────────────┼──────────────────┐
        │                  │                  │
   ┌────▼─────┐      ┌────▼─────┐      ┌────▼─────┐
   │ 离线      │      │ 在线     │      │ 无权限    │
   │ Offline  │      │ Online   │      │No-perm   │
   └────┬─────┘      └────┬─────┘      └────┬─────┘
        │                 │                  │
        │           ┌─────▼──────┐           │
        │           │ 请求数据    │           │
        │           └─────┬──────┘           │
        │                 │                  │
        │           ┌─────▼──────┐           │
        │           │ Loading    │           │
        │           │ (skeleton) │           │
        │           └─────┬──────┘           │
        │                 │                  │
        │     ┌───────────┼───────────┐      │
        │     │           │           │      │
        │  ┌──▼──┐   ┌────▼────┐  ┌───▼───┐  │
        │  │空  │   │ 错误     │  │ 成功   │  │
        │  │    │   │ Error   │  │Success│  │
        │  └──┬─┘   └────┬────┘  └───┬───┘  │
        │     │          │           │      │
        │     └──────────┴───────────┘      │
        │                                  │
        └──────────────┬───────────────────┘
                       │
                ┌──────▼───────┐
                │  用户操作     │
                │ (Retry/Back) │
                └──────────────┘
```

---

## 附录 C · 与各文档交叉引用

| 状态 | 关联文档 | 关联章节 |
| --- | --- | --- |
| Loading | 设计系统 §2.14 Skeleton | skeleton 组件规格 |
| Empty | 设计系统 §2.8 ListItem | 空列表样式 |
| Error | 用户旅程 §4 危机处理 | 错误恢复预期 |
| Success | 设计系统 §2.7 Toast | 操作反馈 |
| Offline | 用户旅程 §1 行前准备 1.3 | 离线包下载动机 |
| No-permission | 用户旅程 §2.2 机场到市区 | 定位失败降级 |

---

## 附录 D · 待后续补充

1. **P1 多语言扩展**（日语 / 韩语 / 阿拉伯语 RTL）的状态镜像
2. **P1 暗色模式下的 Error / Offline 配色**
3. **A/B 测试候选**：Error 态的措辞（「我们的错」vs「临时问题」vs「请重试」）
4. **微动效**：状态切换的过渡动画细节
5. **国际化错误码**：将后端错误码映射扩展到 8 种语言

---

## 附录 E · 文档变更日志

| 版本 | 日期 | 变更 |
| --- | --- | --- |
| v1.0 | 2026-06-26 | 首版发布。6 状态 × 5 主屏 + 通用框架 + 跨屏规则 + a11y。 |
| （未来） | | |
