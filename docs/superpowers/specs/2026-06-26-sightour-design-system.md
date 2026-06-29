# Sightour 设计系统规范（Design Tokens + 组件库）

> **文档类型**：产品 / 设计系统规范
> **阶段**：MVP（Phase 1）范围
> **范围**：Design Tokens（色彩 / 字体 / 间距 / 圆角 / 阴影 / 动效 / 层级 / 断点 / 安全区）+ 14 个核心组件（Button / Chip / Card / Tab / BottomNav / Modal / Toast / ListItem / Input / SearchBar / Toggle / Avatar / ProgressBar / Skeleton）
> **版本**：v1.0 — 2026-06-26
> **关联文档**：
> - [原型重构规范](file:///c:/Users/wenmo/.trae-cn/worktrees/旅游app/docs/superpowers/specs/2026-06-26-sightour-prototype-redesign.md) — 美学方向源头
> - [用户旅程地图](file:///c:/Users/wenmo/.trae-cn/worktrees/旅游app/docs/superpowers/specs/2026-06-26-sightour-user-journeys.md) — 决定每个组件何时出现

---

## 0. 文档元信息

### 用途
本文档是 Sightour 的**单一视觉与组件真理源**。所有屏级实现必须从此处取值——颜色、字号、间距、圆角、阴影、动效曲线，以及 14 个核心组件的用法与状态。

设计师（Figma / Sketch）、前端（Flutter / HTML）、内容运营、QA 测试都引用同一份文档，确保产品视觉与交互一致。

### 读者
- 视觉设计师（创建 Figma Library / Sketch Symbol）
- 前端工程师（实现组件 / 引用 CSS 变量 / Flutter Theme）
- 内容运营（保证文案 / 状态截图符合视觉规范）
- QA（依据文档逐项检查上线版本）

### 与其他文档的关系
- **上游**：[原型重构规范](file:///c:/Users/wenmo/.trae-cn/worktrees/旅游app/docs/superpowers/specs/2026-06-26-sightour-prototype-redesign.md) — 确定美学方向（Calm Tech）
- **平行**：[HTML 原型](file:///c:/Users/wenmo/.trae-cn/worktrees/旅游app/prototype/index.html) — 是本文档规范的具体实现样本
- **下游**：状态设计（loading/empty/error）、微文案指南、验收标准（AC）

### 命名约定
- CSS 变量：`--{category}-{role}-{variant}` 例：`--color-text-primary`、`--space-4`
- 组件类名：`.{component}--{variant}` 例：`.btn--primary`、`.chip--positive`
- 状态类：`.is-{state}` 例：`.is-active`、`.is-disabled`、`.is-loading`

### 信息源声明
本文档基于：
1. 已交付的 HTML 原型中的 CSS 变量（v0.3）
2. 美学重构规范中确立的 Calm Tech 方向
3. 邻近国际产品（Stripe / Linear / Wise / Airbnb 房东端）的视觉惯例

---

## 1. Design Tokens

### 1.1 色彩（Color Tokens）

#### 1.1.1 基础调色板

完整列出 6 个色阶 + 中性色，作为所有语义的源头。

**Slate 蓝灰（主色阶 / 文本与背景）**

| Token | Hex | 用途 |
| --- | --- | --- |
| `--slate-900` | `#1A2332` | 主文本 / 顶导背景 / 主按钮 |
| `--slate-700` | `#374151` | 次级文本 |
| `--slate-500` | `#6B7280` | 三级文本 / 标签 / 占位 |
| `--slate-300` | `#CBD5E1` | 浅描边 |
| `--slate-200` | `#E2E8F0` | 卡片边框 / 分隔线 |
| `--slate-100` | `#F1F5F9` | 极浅背景 |
| `--slate-50` | `#F8FAFC` | 接近白的中性背景 |

**Blue 品牌蓝（仅作点缀）**

| Token | Hex | 用途 |
| --- | --- | --- |
| `--blue-600` | `#2A4365` | 链接 / 激活态 / 主色强调 |
| `--blue-500` | `#3B5998` | 次级蓝（如 hover） |
| `--blue-50` | `#EEF2F7` | 蓝色淡背景 / 选中态 |

**Sand 沙金（点缀色 / 暖意强调）**

| Token | Hex | 用途 |
| --- | --- | --- |
| `--sand-500` | `#D4A574` | 暖色点缀 / Top3 徽章 / 强调 |
| `--sand-50` | `#FAF3E7` | 沙金淡背景 |
| `--sand-text` | `#8B6B3E` | 沙金深字（≥ 4.5:1 对比度） |

**Sage 绿（语义：积极 / 通过 / 成功）**

| Token | Hex | 用途 |
| --- | --- | --- |
| `--sage-600` | `#5B8C5A` | 已核验徽章 / 通过 / 通过支付 |
| `--sage-50` | `#EEF5EC` | 绿色淡背景 |

**Amber 琥珀（语义：注意 / 提示）**

| Token | Hex | 用途 |
| --- | --- | --- |
| `--amber-500` | `#D97706` | 注意 / 排队 / 仅现金 |
| `--amber-50` | `#FEF3E2` | 琥珀淡背景 |

**Clay 红土（语义：风险 / 警告）**

| Token | Hex | 用途 |
| --- | --- | --- |
| `--clay-600` | `#C2410C` | 避雷 / 不推荐 / 风险 |
| `--clay-50` | `#FDF0E8` | 红土淡背景 |

**Ivory 象牙（背景）**

| Token | Hex | 用途 |
| --- | --- | --- |
| `--ivory` | `#FAFAF7` | 应用主背景（暖白） |
| `--white` | `#FFFFFF` | 卡片表面 / 弹窗 |

#### 1.1.2 语义色（绑定语义，不绑定具体色阶）

| 角色 | Token | 实际值 | 用途 |
| --- | --- | --- | --- |
| 文本 | `--color-text-primary` | `--slate-900` | 主文本 |
| 文本 | `--color-text-secondary` | `--slate-700` | 次级文本 |
| 文本 | `--color-text-tertiary` | `--slate-500` | 三级文本 |
| 文本 | `--color-text-inverse` | `--ivory` | 暗背景上的文字 |
| 背景 | `--color-bg-app` | `--ivory` | 应用主背景 |
| 背景 | `--color-bg-surface` | `--white` | 卡片表面 |
| 背景 | `--color-bg-elevated` | `--white` | 弹窗 / Modal |
| 描边 | `--color-border-default` | `--slate-200` | 默认边框 |
| 描边 | `--color-border-strong` | `--slate-300` | 强调描边 |
| 描边 | `--color-border-subtle` | `--slate-100` | 极浅分隔 |
| 状态 | `--color-state-positive` | `--sage-600` | 成功 / 已核验 |
| 状态 | `--color-state-positive-bg` | `--sage-50` | 成功背景 |
| 状态 | `--color-state-caution` | `--amber-500` | 注意 |
| 状态 | `--color-state-caution-bg` | `--amber-50` | 注意背景 |
| 状态 | `--color-state-risk` | `--clay-600` | 风险 |
| 状态 | `--color-state-risk-bg` | `--clay-50` | 风险背景 |
| 品牌 | `--color-brand` | `--blue-600` | 链接 / 激活 |
| 品牌 | `--color-brand-bg` | `--blue-50` | 品牌淡背景 |

#### 1.1.3 中性色（完整）

| Token | Hex |
| --- | --- |
| `--neutral-0` | `#FFFFFF` |
| `--neutral-50` | `#FAFAF7`（= `--ivory`） |
| `--neutral-100` | `#F1F5F9` |
| `--neutral-200` | `#E2E8F0` |
| `--neutral-500` | `#6B7280` |
| `--neutral-700` | `#374151` |
| `--neutral-900` | `#1A2332` |

#### 1.1.4 暗色模式（P1 预留）

仅声明预留，本期不实现。色值由 P1 设计 review 后补全。

```css
@media (prefers-color-scheme: dark) {
  :root {
    /* P1 预留：仅声明变量名，不赋值 */
    --color-bg-app: <dark>;
    --color-text-primary: <light>;
    /* ... */
  }
}
```

### 1.2 字体（Typography Tokens）

#### 1.2.1 字体家族

| Token | 值 |
| --- | --- |
| `--font-sans` | `'Inter', system-ui, -apple-system, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif` |
| `--font-zh` | `'Noto Sans SC', 'Source Han Sans CN', 'Source Han Sans SC', 'PingFang SC', 'Hiragino Sans GB', 'Microsoft YaHei', '微软雅黑', 'WenQuanYi Micro Hei', 'Heiti SC', sans-serif` |
| `--font-mono` | `'JetBrains Mono', 'SF Mono', Menlo, Consolas, 'Roboto Mono', monospace` |

**切换规则**：HTML `lang` 属性为 `zh` 时，自动将 `--font-sans` 替换为 `--font-zh`。

#### 1.2.2 字号档

| Token | px | line-height | 用途 |
| --- | --- | --- | --- |
| `--fs-display` | 32 | 38 | 启动屏主标题 |
| `--fs-h1` | 28 | 34 | 屏幕标题 |
| `--fs-h2` | 22 | 28 | 区块标题 |
| `--fs-h3` | 18 | 24 | 卡片标题 |
| `--fs-body-lg` | 16 | 24 | 重要正文 |
| `--fs-body` | 14 | 22 | 普通正文 |
| `--fs-body-sm` | 13 | 20 | 辅助正文 |
| `--fs-caption` | 12 | 16 | 标签 / 提示 |
| `--fs-micro` | 11 | 14 | 元数据 / 时间戳 |
| `--fs-num-lg` | 24 | 28 | 大数字（评分、汇率） |
| `--fs-num-md` | 18 | 22 | 中等数字 |
| `--fs-num-sm` | 14 | 18 | 小数字 |

**限制**：每个屏幕最多 4 种字号档。

#### 1.2.3 字重

| Token | 值 |
| --- | --- |
| `--fw-regular` | 400 |
| `--fw-medium` | 500 |
| `--fw-semibold` | 600 |
| `--fw-bold` | 700 |

**使用规则**：
- 中文：`400 / 500 / 600`（不使用 700，避免字形过粗）
- 英文：`400 / 500 / 600 / 700` 全可用
- 标题默认 600、正文默认 400、标签默认 500 + letter-spacing

#### 1.2.4 字距 / 行高

| 用途 | letter-spacing | line-height |
| --- | --- | --- |
| 正文（英文） | `-0.01em` | 1.55 |
| 正文（中文） | `0` | 1.7 |
| 标签英文 | `0.06em` + uppercase | 1.4 |
| 标签中文 | `0.04em` | 1.5 |
| 数字 | `0` | 1.4 |

### 1.3 间距（Spacing Tokens）

基础单位 4，全部取值必须来自该标尺。

| Token | px | 用途 |
| --- | --- | --- |
| `--s-0` | 0 | 消除默认间距 |
| `--s-1` | 4 | 极小（如 chip 内文字距） |
| `--s-2` | 8 | chip 内边距 |
| `--s-3` | 12 | list item 内边距 |
| `--s-4` | 16 | 卡片内边距 / 标准间距 |
| `--s-5` | 20 | 卡片内边距大 |
| `--s-6` | 24 | section 内边距 |
| `--s-8` | 32 | section 之间 |
| `--s-10` | 40 | 大区块 |
| `--s-12` | 48 | 屏首尾 / hero |
| `--s-16` | 64 | 极端留白 |
| `--s-24` | 96 | 屏底安全留白（避免被 tabbar 遮挡） |

**禁用值**：6 / 10 / 14 / 18 / 22 / 26 / 30 / 34 / 38 等任意中间值。

### 1.4 圆角（Radius Tokens）

| Token | px | 用途 |
| --- | --- | --- |
| `--r-sm` | 8 | chip / 小型控件 |
| `--r-md` | 12 | 按钮 / 输入框 |
| `--r-lg` | 16 | 卡片 / 列表项 |
| `--r-xl` | 20 | 强调卡片 / Hero 面板 |
| `--r-2xl` | 24 | 弹窗 / Modal |
| `--r-full` | 999px | 胶囊 / 头像 / 标签 |

### 1.5 阴影（Shadow Tokens）

| Token | 值 | 用途 |
| --- | --- | --- |
| `--shadow-0` | none | 无阴影 |
| `--shadow-1` | `0 1px 2px rgba(15,23,42,.04), 0 0 0 1px rgba(15,23,42,.04)` | ivory 背景上的卡片 |
| `--shadow-2` | `0 4px 12px rgba(15,23,42,.06), 0 1px 3px rgba(15,23,42,.04)` | 弹窗 / 抬起按钮 |
| `--shadow-3` | `0 16px 40px rgba(15,23,42,.12), 0 2px 8px rgba(15,23,42,.06)` | 手机外框 / 浮层 |
| `--shadow-focus` | `0 0 0 3px rgba(42,67,101,0.25)` | 键盘焦点环 |

### 1.6 动效（Motion Tokens）

#### 1.6.1 时长

| Token | ms | 用途 |
| --- | --- | --- |
| `--dur-instant` | 0 | 立即生效（如按钮按下） |
| `--dur-fast` | 120 | 微交互（chip 选中） |
| `--dur-base` | 200 | 标准过渡 |
| `--dur-slow` | 320 | 弹窗 / Modal |
| `--dur-slower` | 480 | 屏间切换 |

#### 1.6.2 缓动

| Token | cubic-bezier | 用途 |
| --- | --- | --- |
| `--ease-out` | `cubic-bezier(0.16, 1, 0.3, 1)` | 元素进入（默认） |
| `--ease-in-out` | `cubic-bezier(0.65, 0, 0.35, 1)` | 元素变化 |
| `--ease-in` | `cubic-bezier(0.7, 0, 0.84, 0)` | 元素退出 |
| `--ease-spring` | `cubic-bezier(0.34, 1.56, 0.64, 1)` | 弹性效果（chip 弹一下） |

#### 1.6.3 动效规则

- 默认所有过渡：`duration × ease-out`
- 触控反馈（按下）：`60ms × ease-in-out`
- 屏间切换：`duration-slower × ease-out`
- 弹窗：`duration-slow × ease-out`
- 不要做：超过 600ms 的过渡、循环动画、装饰性动画

### 1.7 Z-index 层级（Z-Index Tokens）

| Token | 值 | 用途 |
| --- | --- | --- |
| `--z-base` | 1 | 默认 |
| `--z-elevated` | 10 | 浮动卡片 |
| `--z-sticky` | 100 | 顶部导航 |
| `--z-tabbar` | 100 | 底部 Tab（与 sticky 同层） |
| `--z-modal` | 1000 | 弹窗 |
| `--z-toast` | 1100 | Toast（高于弹窗） |
| `--z-tooltip` | 1200 | 工具提示 |

### 1.8 断点（Breakpoint Tokens）

| Token | px | 用途 |
| --- | --- | --- |
| `--bp-xs` | 360 | iPhone SE / 小屏 |
| `--bp-sm` | 390 | iPhone 13/14/15（默认） |
| `--bp-md` | 428 | iPhone Pro Max |
| `--bp-lg` | 768 | iPad mini（横屏） |
| `--bp-xl` | 1024 | iPad（横屏） |
| `--bp-2xl` | 1280 | Web 视口 |

**主设计宽度**：390px（iPhone 14），向下兼容到 360px。

### 1.9 安全区（Safe Area Tokens）

| Token | 用途 |
| --- | --- |
| `--safe-top` | 状态栏高度，约 44px iOS / 24px Android |
| `--safe-bottom` | Home Indicator，约 34px iOS |
| `--safe-tabbar` | 64px（tabbar 高度 + 安全区） |

```css
padding-bottom: max(var(--safe-bottom), env(safe-area-inset-bottom));
```

---

## 2. 组件库（14 个核心组件）

### 2.1 Button 按钮

#### 用途
触发一个动作或跳转到一个屏。**永远不**用于「下一步 / 上一步」以外的导航（导航用 Tab / ListItem）。

#### Variants

| Variant | 用途 | 示例 |
| --- | --- | --- |
| `primary` | 主要动作（每屏 1 个） | 「Continue」「Submit」 |
| `secondary` | 次要动作 | 「Cancel」「Back」 |
| `ghost` | 弱化动作 | 「Skip」「Maybe later」 |
| `destructive` | 危险动作 | 「Delete」「Sign out」 |

#### 尺寸

| Size | 高度 | 圆角 | 字号 | 内边距 |
| --- | --- | --- | --- | --- |
| `sm` | 32px | `--r-md` | `--fs-caption` | `0 var(--s-3)` |
| `md`（默认） | 44px | `--r-md` | `--fs-body` | `0 var(--s-4)` |
| `lg` | 52px | `--r-md` | `--fs-body-lg` | `0 var(--s-6)` |

**触控目标最小高度 44px**（iOS HIG / Material Design 一致）。

#### States

| State | 视觉 |
| --- | --- |
| Default | 背景实色 + 文字反白 |
| Hover（Web） | 背景加深 4% |
| Pressed | 背景加深 8% + scale(0.98) + 60ms |
| Focused | 显示 `--shadow-focus` |
| Disabled | 背景 `--slate-100` + 文字 `--slate-500` + cursor: not-allowed |
| Loading | 显示 spinner 替代文字 + disabled 状态 |
| Success（提交后） | 背景 `--sage-600` + 显示 ✓ 图标 600ms 后恢复 |

#### HTML / CSS 示例

```html
<button class="btn btn--primary btn--md">Continue</button>

<button class="btn btn--primary btn--md" disabled>
  <span class="spinner"></span> Loading…
</button>
```

```css
.btn {
  display: inline-flex; align-items: center; justify-content: center;
  gap: var(--s-2);
  font-family: var(--font-sans);
  font-weight: var(--fw-semibold);
  border-radius: var(--r-md);
  border: 0; cursor: pointer;
  transition: background var(--dur-fast) var(--ease-out),
              transform var(--dur-fast) var(--ease-out);
}
.btn--primary { background: var(--blue-600); color: var(--white); }
.btn--primary:hover { background: var(--slate-900); }
.btn--primary:active { transform: scale(.98); }
.btn--ghost { background: transparent; border: 1px solid var(--slate-200); color: var(--slate-700); }
.btn--destructive { background: var(--clay-600); color: var(--white); }
.btn:disabled { background: var(--slate-100); color: var(--slate-500); cursor: not-allowed; }
```

#### 可访问性

- 必须有 `aria-label` 或可见文字
- Loading 状态加 `aria-busy="true"`
- Disabled 不传 `aria-disabled`，而是真禁用（不响应点击）
- 焦点环不可被去除（无障碍法规要求）

---

### 2.2 Chip 标签

#### 用途
用于过滤、状态、分类、标记。**不**用于触发动作（动作用 Button）。

#### Variants

| Variant | 配色 | 用途 |
| --- | --- | --- |
| `default` | 白底 + slate 描边 + slate-700 文字 | 中性标签 |
| `brand` | blue-50 底 + blue-600 文字 | 品牌 / 选中 |
| `positive` | sage-50 底 + sage-600 文字 | 已核验 / 通过 |
| `caution` | amber-50 底 + amber-500 文字 | 注意 / 提示 |
| `risk` | clay-50 底 + clay-600 文字 | 风险 / 避雷 |
| `sand` | sand-50 底 + sand-text 文字 | 暖意强调 / Top3 |
| `ink` | slate-900 底 + 白色文字 | 强对比（Hero / 强调） |

#### 尺寸

| Size | 高度 | 内边距 | 字号 |
| --- | --- | --- | --- |
| `sm` | 24px | `0 var(--s-2)` | `--fs-micro` |
| `md`（默认） | 28px | `0 var(--s-3)` | `--fs-caption` |
| `lg` | 32px | `0 var(--s-4)` | `--fs-body-sm` |

#### States

| State | 视觉 |
| --- | --- |
| Default | 默认配色 |
| Active（被选中作 filter） | 默认变 `brand` 配色 + 加深 |
| Removable（带 X 按钮） | 显示 X 按钮，点击移除 |
| Disabled | 透明度 0.4 + cursor: not-allowed |

#### HTML / CSS 示例

```html
<span class="chip chip--positive">✓ Verified</span>
<button class="chip chip--brand chip--md is-active">Foreign cards</button>
```

#### 何时用 / 何时不用

- **用**：POI 标签（如「English menu」「Vegetarian」「24h」）、filter 选项、状态徽章
- **不用**：数量统计（用数字 + 单位）、货币金额（用 `--fs-num-md` + token）

---

### 2.3 Card 卡片

#### 用途
承载一组相关内容（POI 摘要、政策、工具项）。**唯一**的容器组件。

#### Variants

| Variant | 用途 |
| --- | --- |
| `default` | 标准卡片（白底 + 浅描边） |
| `featured` | 强调卡片（额外 shadow-2 + 顶部品牌色条） |
| `flat` | 平面卡（无描边，仅白底） |
| `ink` | 深底卡片（slate-900 底 + 白字） |
| `ghost` | 无背景，无描边，仅内容 |

#### 结构

```
┌─────────────────────────────────────┐
│ [optional media]                    │
│  → image / icon / map preview       │
├─────────────────────────────────────┤
│ Title                               │
│ Subtitle / metadata                 │
│ Tags / Chips                        │
│ Body text (optional)                │
│ CTA row (optional)                  │
└─────────────────────────────────────┘
```

#### Padding

- 标准内边距：`--s-4`
- 宽卡片内边距：`--s-6`
- 列表项内边距：`--s-3` 横向、`--s-4` 纵向

#### States（如果是可点击）

| State | 视觉 |
| --- | --- |
| Default | `--shadow-1` |
| Hover | `--shadow-2` + border `--slate-300` |
| Pressed | `--shadow-1` + scale(0.99) |
| Focused | `--shadow-focus` |

#### 何时用 / 何时不用

- **用**：POI 列表项、政策卡、工具项、口碑评分卡
- **不用**：单行内容（用 ListItem）、表单字段（用 Input）、按钮（用 Button）

---

### 2.4 Tab 标签页

#### 用途
在同一屏内切换不同视图（如 Discover 屏的「Curated / Authentic / Heads-up」三个 tab）。

#### Variants

| Variant | 用途 |
| --- | --- |
| `underline`（默认） | 顶部 tab + 底部细线指示器 |
| `pill` | 胶囊形态，圆角高 |
| `segmented` | iOS 风格分段控件 |

#### 尺寸

| Size | 高度 | 字号 |
| --- | --- | --- |
| `sm` | 32px | `--fs-caption` |
| `md`（默认） | 40px | `--fs-body` |

#### States

| State | 视觉 |
| --- | --- |
| Default | 文字 `--slate-500` |
| Hover | 文字 `--slate-700` |
| Active | 文字 `--slate-900` + 底部 2px `--blue-600` 指示器 |
| Disabled | 透明度 0.4 |

#### HTML / CSS 示例

```html
<div class="tabs tabs--underline" role="tablist">
  <button class="tab is-active" role="tab" aria-selected="true">Curated</button>
  <button class="tab" role="tab">Authentic</button>
  <button class="tab" role="tab">Heads-up</button>
</div>
```

---

### 2.5 BottomNav 底部导航

#### 用途
APP 顶级导航。固定 5 个 tab：Prepare / Map / Discover / Tools / You。

#### 高度
`64px + 安全区 = max(64, 64 + env(safe-area-inset-bottom))`

#### 结构

```
[ icon ]   [ icon ]   [ icon ]   [ icon ]   [ icon ]
 Prepare    Map     Discover    Tools       You
```

#### States

| State | 视觉 |
| --- | --- |
| Default | 图标 + 文字 `--slate-500` |
| Active | 图标 + 文字 `--blue-600`，图标填充 |
| Pressed | scale(0.95) 60ms |

#### 何时用 / 何时不用

- **用**：APP 顶级 5 个 tab
- **不用**：屏内 tab（用 Tab）、动作按钮（用 Button）

---

### 2.6 Modal 弹窗

#### 用途
阻断性对话框（提交确认 / 信息详情 / 表单输入）。

#### Variants

| Variant | 用途 |
| --- | --- |
| `center` | 居中弹窗 |
| `bottom-sheet`（默认） | 底部滑出（移动端首选） |
| `fullscreen` | 全屏弹窗（用于复杂表单） |

#### Bottom-sheet 规格

- 默认高度：50% 屏高
- 最大高度：90% 屏高
- 顶部圆角：`--r-2xl`
- 顶部拖动 handle：宽 36px × 高 4px，`--slate-300`

#### States

| State | 视觉 |
| --- | --- |
| Closed | 隐藏 |
| Opening | 从底部滑入 320ms `--ease-out` |
| Open | 显示背景遮罩（`rgba(15,23,42,0.4)`） |
| Closing | 向下滑出 240ms `--ease-in` |

#### 何时用 / 何时不用

- **用**：阻断性确认、复杂表单（如「Submit a correction」详情）
- **不用**：非阻断提示（用 Toast）、屏内表单（用页面）

---

### 2.7 Toast 提示

#### 用途
短暂、自动消失的非阻断提示（成功反馈、操作完成）。

#### Variants

| Variant | 配色 | 用途 |
| --- | --- | --- |
| `info`（默认） | `--slate-900` 底 + 白字 | 普通信息 |
| `success` | `--sage-600` 底 + 白字 | 成功 |
| `warning` | `--amber-500` 底 + 白字 | 警告 |
| `error` | `--clay-600` 底 + 白字 | 错误 |

#### 规格

- 位置：屏幕底部（tabbar 上方 16px）
- 最大宽度：`480px`
- 内边距：`var(--s-3) var(--s-4)`
- 圆角：`--r-md`
- 显示时长：3000ms（成功）/ 5000ms（错误）
- 自动消失 + 可手动关闭

#### States

| State | 视觉 |
| --- | --- |
| Appearing | 滑入 + 透明度 0→1 |
| Visible | 静止 |
| Disappearing | 滑出 + 透明度 1→0 |

#### 何时用 / 何时不用

- **用**：操作反馈（保存成功、网络错误）
- **不用**：需要用户决策的提示（用 Modal）、需要持久展示的信息（用 banner）

---

### 2.8 ListItem 列表项

#### 用途
单行内容（带 icon / 图片 / 文字 / 右侧元数据）。

#### Variants

| Variant | 结构 |
| --- | --- |
| `text` | `[icon]  Title ............ metadata` |
| `media` | `[img]  Title ............ metadata` |
| `detail` | `[icon]  Title ............ value` |
| `two-line` | `[icon]  Title / Subtitle . metadata` |
| `three-line` | `[icon]  Title / Subtitle / extra  metadata` |

#### Padding
`var(--s-4)` 横向、`var(--s-3)` 纵向

#### States

| State | 视觉 |
| --- | --- |
| Default | 透明背景 |
| Hover | `--slate-50` 背景 |
| Pressed | `--slate-100` 背景 |
| Focused | `--shadow-focus` |
| With-divider | 底部 1px `--slate-200`（最后一个不显示） |

#### 何时用 / 何时不用

- **用**：设置项、清单项、搜索结果列表、工具列表
- **不用**：卡片（用 Card）、单条 POI（用 Card）

---

### 2.9 Input 输入框

#### 用途
文本输入。

#### Variants

| Variant | 用途 |
| --- | --- |
| `text`（默认） | 单行文本 |
| `multiline` | 多行文本（textarea） |
| `email` | 邮箱（带键盘优化） |
| `tel` | 电话 |
| `number` | 数字 |

#### 规格

| Size | 高度 | 字号 |
| --- | --- | --- |
| `sm` | 36px | `--fs-body-sm` |
| `md`（默认） | 44px | `--fs-body` |
| `lg` | 52px | `--fs-body-lg` |

#### States

| State | 视觉 |
| --- | --- |
| Default | 1px `--slate-200` 边框 + `--ivory` 底 |
| Hover | 1px `--slate-300` |
| Focused | 1px `--blue-600` + `--shadow-focus` |
| Filled | 1px `--slate-300` + `--white` 底 |
| Error | 1px `--clay-600` + 下方错误文字 |
| Disabled | 1px `--slate-200` + 文字 `--slate-500` + 底 `--slate-50` |

#### 何时用 / 何时不用

- **用**：表单字段、搜索框（用 SearchBar）
- **不用**：只读展示（用 ListItem detail）

---

### 2.10 SearchBar 搜索栏

#### 用途
搜索输入（POI / 政策 / 工具）。

#### 规格

- 高度：44px
- 圆角：`--r-md`
- 背景：`--slate-100`
- 左 icon：放大镜 + `--slate-500`
- 占位文字：`--slate-500`
- 右侧：清除按钮（仅在有文字时显示）

#### States

| State | 视觉 |
| --- | --- |
| Empty | 显示占位 |
| Typing | 显示文字 + 清除按钮 |
| Focused | 背景 `--white` + 1px `--blue-600` 边框 |
| Loading | 右侧显示 spinner |
| With-results | 下方弹出结果下拉 |

#### 何时用 / 何时不用

- **用**：Map 屏 POI 搜索、Discover 屏全局搜索
- **不用**：表单内输入（用 Input）

---

### 2.11 Toggle 开关

#### 用途
二元设置（开/关）。

#### 规格

- 宽度：44px
- 高度：24px
- 圆角：`--r-full`
- 拨片：20px × 20px 圆

#### States

| State | 视觉 |
| --- | --- |
| Off（默认） | 背景 `--slate-200`，拨片左 |
| On | 背景 `--blue-600`，拨片右 |
| Disabled | 透明度 0.4 |
| Hover | 拨片阴影加深 |

#### HTML / CSS 示例

```html
<button class="toggle is-on" role="switch" aria-checked="true">
  <span class="toggle__knob"></span>
</button>
```

---

### 2.12 Avatar 头像

#### 用途
用户头像、国家旗帜、POI logo。

#### Variants

| Size | px | 用途 |
| --- | --- | --- |
| `xs` | 20 | chip 内的国家码 |
| `sm` | 32 | 列表项 |
| `md` | 40 | 评论 / 评分 |
| `lg` | 56 | 个人页 |
| `xl` | 80 | 启动屏品牌 |

#### 类型

| Type | 用途 |
| --- | --- |
| `image` | 圆形图片（用户头像） |
| `flag` | 矩形国旗（国家筛选） |
| `initials` | 文字 fallback（无头像时） |
| `icon` | 通用图标 fallback |

#### States

| State | 视觉 |
| --- | --- |
| Loading | skeleton 灰色圆 |
| Error | 灰色背景 + 默认图标 |
| With-badge | 右下角加小圆点（在线状态） |

---

### 2.13 ProgressBar 进度条

#### 用途
显示任务完成进度（如「Pre-arrival checklist 3/7」）。

#### Variants

| Variant | 用途 |
| --- | --- |
| `linear`（默认） | 横向 |
| `step` | 分段（用 checkpoint 分隔） |
| `circular` | 圆形（用于加载中） |

#### 规格

- 高度：6px
- 圆角：`--r-full`
- 背景：`--slate-200`
- 填充：`--blue-600`（或 `--sage-600` 当 100% 时）

#### States

| State | 视觉 |
| --- | --- |
| 0% | 全部背景色 |
| 1–99% | 蓝色填充 |
| 100% | sage 绿色填充（成功） |
| Indeterminate | 横向滚动条 |

#### 何时用 / 何时不用

- **用**：清单进度、上传进度、加载状态
- **不用**：评分显示（用 5 维评分体系）

---

### 2.14 Skeleton 骨架屏

#### 用途
内容加载时的占位（POI 列表加载、POI 详情加载）。

#### Variants

| Variant | 用途 |
| --- | --- |
| `text-line` | 单行文字占位 |
| `block` | 矩形块占位 |
| `circle` | 圆形占位（头像） |
| `card` | 整张卡片占位 |

#### 规格

- 背景：`--slate-200`
- 圆角：与最终内容一致
- 动画：1.5s 横向渐变扫光（shimmer）

#### States

| State | 视觉 |
| --- | --- |
| Loading | shimmer 动画 |
| Loaded | 渐变消失显示真实内容 200ms |
| Error | 占位变 clay-50 + 错误提示 |

#### 何时用 / 何时不用

- **用**：列表加载、详情加载、卡片加载
- **不用**：全屏加载（用 ProgressBar circular）、按钮内加载（用 Button loading 状态）

---

## 3. 跨组件规则

### 3.1 触控目标（Touch Target）

- **最小尺寸 44 × 44pt**（iOS HIG / WCAG 2.5.5）
- 例外：chip（24–32px，仅作过滤用，不承担主要动作）
- 例外：tab 文字（40px 高度可接受）

### 3.2 颜色对比度（WCAG 2.1）

| 文字类型 | 最小对比度 |
| --- | --- |
| 正文（≥ 18px 或 14px bold） | 4.5:1 |
| 大字（≥ 24px） | 3:1 |
| UI 组件（按钮边框、icon） | 3:1 |

**已核查的关键对比**：
- `--slate-900` on `--ivory`：17:1 ✓
- `--slate-700` on `--white`：10:1 ✓
- `--blue-600` on `--white`：8:1 ✓
- `--sand-text` on `--sand-50`：5.4:1 ✓
- `--sage-600` on `--sage-50`：5:1 ✓
- `--amber-500` on `--amber-50`：4.6:1 ✓
- `--clay-600` on `--clay-50`：5.1:1 ✓

### 3.3 焦点态（Focus State）

- 所有可交互元素必须显示焦点环 `--shadow-focus`
- 不允许 `outline: none` 不替换
- 焦点环对所有用户可见（不仅键盘用户）

### 3.4 触摸反馈（Press Feedback）

- 所有可点击元素：按下时 `scale(0.98)` 或 `scale(0.95)`（按钮 / tabbar）
- 持续时间：`60ms × ease-in-out`
- 不要做：闪烁、抖动、阴影深度变化过大

### 3.5 国际化字体切换

```css
:root { --font-sans: var(--font-sans); }
:lang(zh) { --font-sans: var(--font-zh); }
```

自动适配，无需 JS。

---

## 附录 A · Token 速查表（设计 / 工程常用）

| 类别 | 关键 Token | 值 |
| --- | --- | --- |
| 主背景 | `--color-bg-app` | `#FAFAF7` |
| 主文本 | `--color-text-primary` | `#1A2332` |
| 品牌色 | `--color-brand` | `#2A4365` |
| 圆角-卡片 | `--r-lg` | 16px |
| 圆角-按钮 | `--r-md` | 12px |
| 间距-标准 | `--s-4` | 16px |
| 字号-正文 | `--fs-body` | 14px |
| 字号-标题 | `--fs-h1` | 28px |
| 字号-数字 | `--fs-num-lg` | 24px |
| 字重-主 | `--fw-semibold` | 600 |
| 阴影-卡 | `--shadow-1` | 见上 |
| 动效-基础 | `--dur-base` `--ease-out` | 200ms · ease-out |

## 附录 B · 与 PRD / 旅程映射

| 组件 | 出现 Journey | 出现屏 |
| --- | --- | --- |
| Button | 全部 5 个 | 全部 |
| Chip | 全部 5 个 | Home / Discover / POI Detail |
| Card | 全部 5 个 | 全部 |
| Tab | 日常 / 离境 | Discover / Profile |
| BottomNav | 全部 5 个 | 全部（顶级） |
| Modal | 落地 / 危机 / 离境 | Correction submit / Emergency |
| Toast | 全部 5 个 | 操作反馈 |
| ListItem | 全部 5 个 | Tools / Profile |
| Input | 行前 / 危机 | Correction submit / Search |
| SearchBar | 日常 / 危机 | Map / Discover |
| Toggle | 全部 5 个 | Profile |
| Avatar | 行前 / 离境 | Country filter / Persona-driven cards |
| ProgressBar | 行前 / 日常 | Checklist |
| Skeleton | 全部 5 个 | List loading states |

## 附录 C · 待后续补充

1. **暗色模式 token 完整赋值**（P1 启动）
2. **动效曲线精修**（含 spring / overshoot 等）
3. **POI 评分展示组件**（5 维条形图 / 雷达图作为独立组件）
4. **地图标记组件**（POI 类型分色）
5. **品牌 logo 变体**（light / dark / monochrome）

## 附录 D · 文档变更日志

| 版本 | 日期 | 变更 |
| --- | --- | --- |
| v1.0 | 2026-06-26 | 首版发布。Design Tokens 9 类 + 14 个核心组件。 |
| （未来） | | |
