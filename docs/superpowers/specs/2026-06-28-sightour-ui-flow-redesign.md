# Sightour UI 流程化重设计规范

> **文档类型**：UI/UX 设计规范
> **版本**：v1.0 — 2026-06-28
> **关联文档**：[onboarding-flow-spec](./2026-06-28-sightour-onboarding-flow-spec.md)

---

## 1. 设计目标

当前 Flutter 前端缺少流程化图表设计，大量文字难以让用户简单明了地理解入境到离境的整个过程，整体 UI 单调。

**改造范围：**
- Prepare Home 页面 → 纵向时间轴 + 手风琴政策卡片
- Onboarding 4 屏引导 → 横向进度 Stepper + 插画氛围

**视觉风格：**
- 暖色活力（落日橙/琥珀/金盏花）
- 插画风图标
- 混合式布局（纵向时间轴 + 展开卡片）

---

## 2. 新配色方案

在现有 `AppColors` 基础上扩展暖色体系：

| Token | 用途 | 颜色值 |
|---|---|---|
| `warmPrimary` | 主色 — 按钮、高亮、激活态 | `0xFFE8732A` |
| `warmPrimaryDark` | 深色 — 标题、强文字、已完成节点 | `0xFFC2571A` |
| `warmPrimaryLight` | 浅底色 — 卡片背景、chip | `0xFFFFF2E8` |
| `warmSecondary` | 辅助色 — 次要按钮、连接线 | `0xFFF4A261` |
| `warmAccent` | 强调色 — 进度条填充、高亮标签 | `0xFFF9C74F` |
| `warmSurface` | 页面底色 — 替代白底 | `0xFFFFFBFA` |

保留不变：`slate900`, `slate500`, `slate300`, `slate200`, `slate100`, `slate50`, `sage600`, `sage50`, `white`, `black`

---

## 3. Prepare Home 页面重设计

### 3.1 布局结构

```
AppBar: "Prepare" + 通知图标
  └── ListView
        ├── JourneyBanner（暖橙渐变 + 城市剪影 + 3 个 chip）
        ├── 时间轴区域
        │     ├── 节点1·签证（默认展开）
        │     │     ├── 实心圆 ● + 实线连接 ━━━
        │     │     └── 展开的 PolicyCard
        │     ├── 节点2·海关（收起）
        │     │     ├── 实心圆 ● + 实线连接 ━━━
        │     │     └── 一行摘要（点击展开）
        │     ├── 节点3·领事（默认展开）
        │     │     ├── 放大圆 ◉ + 脉冲动画 + 实线连接 ━━━
        │     │     └── 展开的 PolicyCard
        │     └── 节点4·居留（收起）
        │           ├── 空心圆 ○ + 虚线连接 ┅┅
        │           └── 一行摘要（点击展开）
        ├── 清单区域
        │     ├── Section header "Pre-arrival Checklist"
        │     ├── 圆形进度环 + "6/9 done"
        │     └── Checklist rows（checkbox + 文字）
        └── 离线下载横幅
```

### 3.2 新增组件

| 组件 | 文件路径 | 职责 |
|---|---|---|
| `FlowTimeline` | `lib/shared/components/flow_timeline.dart` | 时间轴容器，管理节点列表和连线绘制 |
| `FlowNode` | `lib/shared/components/flow_node.dart` | 单个节点：圆形指示器 + 图标 + 展开/收起卡片 |
| `JourneyBanner` | `lib/features/prepare/presentation/widgets/journey_banner.dart` | 顶部横幅：渐变背景 + 城市剪影 + 3 个 chip |
| `CircularProgressRing` | `lib/shared/components/circular_progress_ring.dart` | 圆形进度环（替代线性进度条） |

### 3.3 节点状态机

| 状态 | 圆形样式 | 连接线 | 卡片 |
|---|---|---|---|
| `completed` | 实心圆 `warmPrimary` + ✓ 图标 | 实线 `warmSecondary` | 收起（一行摘要） |
| `current` | 放大圆 `warmPrimary` + 脉冲光环 `warmAccent` | 实线 `warmSecondary` | 展开（完整政策卡） |
| `pending` | 空心圆 `slate300` | 虚线 `slate300` | 收起（一行摘要） |

### 3.4 交互规则

- 默认打开节点 1（签证），其余收起
- 点击任一节点 → 手风琴切换（同时只展开一个）
- 切换芯片 → 重新加载数据 + 节点全部恢复初始状态
- 节点展开/收起动画：300ms `Curves.easeOutCubic`

---

## 4. Onboarding 引导流程重设计

### 4.1 统一布局模板

```
Scaffold
  ├── 插画氛围区（240px 高，屏专属插画）
  ├── 标题 + 副标题
  ├── 横向进度 Stepper
  │     ●━━━━●━━━━○━━━━○
  │   Welcome·Features·Setup·Privacy
  └── 底部按钮区
        ├── 主按钮（warmPrimary 圆角 pill）
        └── Skip 链接（仅 Welcome 屏）
```

### 4.2 4 屏专属内容

| 屏 | 路由 | 插画 | 标题 | 副标题 | 按钮文案 |
|---|---|---|---|---|---|
| Welcome | `/onboarding` | 🧳 行李箱+护照+目的地 | Welcome to Sightour | Your personal guide for China entry & beyond | Get started |
| Features | `/onboarding` (PageView) | 🗺 地图标志+清单拼贴 | Everything in one place | Visa, customs, embassies and local tips — offline | Next |
| Quick Setup | `/onboarding` (PageView) | ⚙ 齿轮+地球交互 | Tailor your journey | Tell us your passport, city and reason — we handle the rest | Next |
| Privacy | `/onboarding/privacy` | 🔒 盾牌+文件保护 | Your data, your choice | Stay in control. Everything works offline by design. | Enter Sightour |

### 4.3 横向 Stepper 组件

替换现有 `OnboardingIndicator` 点状指示器：

- **已完成节点**：实心圆 `warmPrimary` + 连线 `warmSecondary` + 文字 `slate500`
- **当前节点**：放大圆 + 外圈脉冲光环 `warmAccent` + 加粗文字 `warmPrimaryDark`
- **待定节点**：空心圆 `slate300` + 虚线 `slate300` + 淡文字 `slate300`
- 点击已完成节点支持回退

### 4.4 新增/修改组件

| 组件 | 文件路径 | 变更类型 |
|---|---|---|
| `OnboardingStepper` | `lib/features/onboarding/presentation/widgets/onboarding_stepper.dart` | **新增** |
| `IllustrationBanner` | `lib/shared/components/illustration_banner.dart` | **新增** |
| `OnboardingIndicator` | `lib/features/onboarding/presentation/widgets/onboarding_indicator.dart` | 替换为 Stepper |
| `OnboardingFlowPage` | `lib/features/onboarding/presentation/pages/onboarding_flow_page.dart` | 重新布局 |
| `OnboardingWelcomePage` | `lib/features/onboarding/presentation/pages/onboarding_welcome_page.dart` | 内容适配 |
| `OnboardingFeaturesPage` | `lib/features/onboarding/presentation/pages/onboarding_features_page.dart` | 内容适配 |
| `OnboardingSettingsPage` | `lib/features/onboarding/presentation/pages/onboarding_settings_page.dart` | 内容适配 |
| `PrivacyConsentPage` | `lib/features/onboarding/presentation/pages/privacy_consent_page.dart` | 内容适配 |

---

## 5. 视觉统一规范

| 元素 | Onboarding | Prepare Home |
|---|---|---|
| 背景色 | `warmSurface` | `warmSurface` |
| 主色 | `warmPrimary` | `warmPrimary` |
| 进度指示器 | 横向 Stepper（圆+线） | 纵向时间轴（圆+线） |
| 节点图标 | 插画氛围大图 | 插画小图标 |
| 按钮样式 | 圆角 pill `warmPrimary` | 圆角 pill `warmPrimary` |
| 卡片样式 | — | 展开/收起手风琴 |
| 圆角 | `AppRadius.lg` (16) | `AppRadius.lg` (16) |

---

## 6. 兜底设计

- **插画图标**：使用自定义 `CustomPainter` 绘制简约插画，不依赖外部图片资源，确保离线可用
- **城市剪影**：Beijing（故宫+长城轮廓）、Shanghai（东方明珠+外滩轮廓）、Guangzhou（广州塔轮廓）、Other（通用建筑轮廓）
- **动画**：全部使用 Flutter 内置动画（`AnimatedContainer`、`AnimatedOpacity`、`AnimatedPositioned`），不引入第三方动画库

---

## 7. 变更日志

| 版本 | 日期 | 变更 |
|---|---|---|
| v1.0 | 2026-06-28 | 首版发布。定义 Prepare Home 时间轴 + Onboarding Stepper 重设计方案。 |
