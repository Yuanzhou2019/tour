# Sightour 原型重构规范

> **日期**：2026-06-26
> **范围**：对现有 HTML 原型（12 屏）做迭代式重构，应对三类反馈问题
> **状态**：方向已批准 — Calm Tech 视觉风格 + 完整中英双语 + 布局规范化

---

## 1. 背景

第一版原型采用「Editorial Shanghai」风格：Fraunces 衬线字 + Manrope + JetBrains Mono，叠加刺眼的墨黑/纸白/朱砂红三色。利益相关方评审后识别出三类问题：

1. **视觉风格与受众错位** — 黑白红配色读起来像「异域东方风」，而非「值得信赖的国际工具」。外国来华游客需要的是沉稳可靠，而非文化猎奇。
2. **布局一致性问题** — 间距标尺不统一、底栏 Tab 在长列表屏遮挡内容、中文渲染下字重层级混乱。
3. **缺失中文版本** — PRD 承诺的中英双语在原型中不可见。

本规范定义重构方案。

---

## 2. 新美学方向 — 「Calm Tech」

参考词汇：Stripe · Linear · Wise · Airbnb（房东端）— 现代、克制、可信、国际感。

### 2.1 色彩系统

| 角色 | Token | 十六进制色 | 用途 |
| :--- | :--- | :--- | :--- |
| 主要文本 | `--slate-900` | `#1A2332` | 正文文本、主按钮、顶部导航 |
| 次要文本 | `--slate-700` | `#374151` | 浅色背景上的次级文本 |
| 三级文本 | `--slate-500` | `#6B7280` | 三级文本、说明文字、图标 |
| 品牌色 | `--blue-600` | `#2A4365` | 品牌点缀、链接、激活态 |
| 品牌浅色 | `--blue-50` | `#EEF2F7` | 激活态背景、轻微高亮 |
| 表面色 | `--ivory` | `#FAFAF7` | 应用背景 |
| 卡片色 | `--white` | `#FFFFFF` | 卡片表面、弹窗 |
| 边框 | `--line` | `#E5E7EB` | 卡片边框、分隔线 |
| 浅边框 | `--line-soft` | `#F3F4F6` | 浅色分隔线 |
| 点缀色 | `--sand-500` | `#D4A574` | 暖色点缀、徽章、高亮 |
| 点缀浅色 | `--sand-50` | `#FAF3E7` | 点缀背景 |
| 积极色 | `--sage-600` | `#5B8C5A` | 「是」标签、成功、已核验 |
| 积极浅色 | `--sage-50` | `#EEF5EC` | 积极背景 |
| 警示色 | `--amber-500` | `#D97706` | 「注意」标签 |
| 警示浅色 | `--amber-50` | `#FEF3E2` | 警示背景 |
| 风险色 | `--clay-600` | `#C2410C` | 「避雷」标签、错误 |
| 风险浅色 | `--clay-50` | `#FDF0E8` | 风险背景 |

**设计理由**：

- 用 slate/ivory 替代 ink/paper — 弱化「设计主张」，强化「可信工具」感。
- 品牌蓝克制使用 — 仅用于选中态和链接，不作大面积强调。
- 沙金色替代朱砂红 — 温暖但不「异域风」。
- sage/clay/amber 三个语义色承担状态信号，无需靠警示红。

### 2.2 字体系统

| 角色 | 英文字体 | 中文字体 | 字号档 |
| :--- | :--- | :--- | :--- |
| 标题 | Inter 600 | Noto Sans SC 600 | 32 / 28 / 24 |
| 小标题 | Inter 600 | Noto Sans SC 600 | 20 / 18 |
| 正文 | Inter 400 | Noto Sans SC 400 | 16 / 14 |
| 标签 | Inter 500 | Noto Sans SC 500 | 12 / 11（英文标签带 letter-spacing） |
| 数字 | Inter 600 tnum | Noto Sans SC 600 | 24 / 18 / 14 |

中文态自动切换到 Noto Sans SC；中文字距收紧到 0（CJK 不需要正向 letter-spacing）。

### 2.3 间距标尺

基础 4。所有内外边距必须取自：

`4 · 8 · 12 · 16 · 20 · 24 · 32 · 40 · 48`

禁用值：6 / 10 / 14 / 18 / 22 / 26 / 30 / 34 / 38 等任意值。

### 2.4 圆角标尺

- `8` — Chip、小型控件
- `12` — 按钮、输入框
- `16` — 卡片、列表项
- `20` — 强调卡片、Hero 面板
- `full` — 胶囊、头像

### 2.5 阴影标尺

- `--shadow-1` — `0 1px 2px rgba(15,23,42,.04)` — ivory 背景上的卡片
- `--shadow-2` — `0 2px 8px rgba(15,23,42,.06)` — 弹窗、抬起按钮
- `--shadow-3` — `0 8px 24px rgba(15,23,42,.10)` — 手机外框

---

## 3. 布局修复

### 3.1 Tabbar 遮挡

Tabbar 定位 `bottom: 0`，`padding-bottom: 28px`（位于 Home Indicator 上方）。每个屏幕的内容强制 `padding-bottom: 96px`，确保最底下的列表项不被 Tabbar 遮挡。

### 3.2 间距规范化

所有卡片统一使用 `--radius-16` 和 `--space-16` 内边距。所有 section 标签统一 `--space-24` 垂直留白。

### 3.3 字体层级

每个屏幕三个文字层级：

- **H1** — 28px / 600，页面标题
- **Body** — 14px / 400，描述
- **Caption** — 11.5px / 500 + letter-spacing，标签

每个屏幕最多 4 种字号。

### 3.4 状态栏隔离

状态栏 `padding-top: 12px` + `padding-bottom: 8px` + 滚动时 1px 极细分割线。不再有「贴内容」感。

---

## 4. 双语实现

### 4.1 机制

每个可翻译的文本元素加 `data-i18n="key"`（或 `data-i18n-placeholder`、`data-i18n-title`）。单个 `i18n` JS 对象存放 EN 和 ZH 词典。切换语言时：

1. 更新 `document.documentElement.lang`
2. 遍历所有 `[data-i18n]` 节点替换 `textContent`
3. 切换 `--font-sans` CSS 变量，中文态加载 Noto Sans SC
4. 持久化到 `localStorage`

### 4.2 翻译范围

所有可见 UI 字符串：

- 导航标签（Prepare / Map / Discover / Tools / You → 行前 / 地图 / 发现 / 工具 / 我的）
- 屏幕标题与 CTA
- Chip 标签（Foreign cards → 支持外卡、English menu → 英文菜单 等）
- 状态消息（Verified → 已核验、Updated → 更新于）
- 备注面板（设计意图注释）

POI 名称样例保留英文（Ultraviolet、Lost Heaven），中文副标题并列展示 — 原型是面向国际用户的演示，不是中文接待用户视角。

### 4.3 切换位置

左侧导航栏顶部：`[ EN | 中 ]` 分段开关，跨屏持久化，首次访问默认 EN。

---

## 5. 实现要点

- 单文件输出：在原位重写 [prototype/index.html](file:///c:/Users/wenmo/.trae-cn/worktrees/旅游app/prototype/index.html)
- 除 Google Fonts 外不引入新外部依赖（Inter + Noto Sans SC）
- 保留 12 屏；保留所有功能性交互（屏切换、语言切换、Chip 选中、Tabbar 激活）
- 每次主要变更后用 `http://localhost:8765/` 浏览器预览验证

---

## 6. 验收标准

- [ ] 12 屏在配色和间距标尺上视觉一致
- [ ] 任意屏不被 Tabbar 遮挡
- [ ] 语言切换实时更新全部 UI 字符串
- [ ] 中文渲染使用 Noto Sans SC 且字距收紧
- [ ] 无纯黑、无朱砂红
- [ ] 底栏标签已本地化
