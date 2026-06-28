# Sightour Stage 2 — 4 核心 Tab + 14 Design System 组件 设计

> **类型**：阶段二（4 个核心业务 tab + 设计系统组件库）
> **范围**：MVP 计划 Task 15-22（4 tab 首页）+ 14 个 Design System 组件
> **依赖**：Stage 1（Spec A/B/C）+ Design Tokens（已就绪）
> **版本**：v1.0 — 2026-06-27

---

## 0. 范围

- ✅ 14 个 Design System 组件实现（基于 Design Tokens）
- ✅ Prepare 首页（policy list + checklist + offline downloads）
- ✅ Map 首页（无真地图，POI 列表 + 搜索）
- ✅ Discover 首页（curated list / authentic / heads-up tabs）
- ✅ Tools 首页（6 个工具入口 + FX 换算）
- ❌ POI 详情 / Policy 详情（留作阶段三）
- ❌ 真地图（amap 地图集成，留作阶段三）
- ❌ 实时数据后端（继续用 Mock 拦截器）

---

## 1. 14 个 Design System 组件

放在 `app/lib/shared/components/` 下，每个组件一个文件，**全部**使用 `core/theme/` 下的 tokens，**禁止**硬编码颜色 / 间距 / 字号。

### 1.1 Button

文件：`app/lib/shared/components/button.dart`

```dart
enum ButtonVariant { primary, secondary, ghost, destructive }
enum ButtonSize { sm, md, lg }

class AppButton extends StatelessWidget {
  const AppButton({
    required this.label,
    this.onPressed,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.md,
    this.loading = false,
    this.leadingIcon,
    super.key,
  });
  final String label;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final ButtonSize size;
  final bool loading;
  final IconData? leadingIcon;
  // ... 实现
}
```

- 高度：sm 32 / md 44 / lg 52
- Pressed：scale 0.98
- Disabled：`onPressed: null` 时禁用
- Loading：spinner 替代文字

### 1.2 Chip

文件：`app/lib/shared/components/chip.dart`

```dart
class AppChip extends StatelessWidget {
  const AppChip({
    required this.label,
    this.selected = false,
    this.onTap,
    this.leadingIcon,
    this.variant = ChipVariant.filter, // filter | input | choice
    super.key,
  });
  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final IconData? leadingIcon;
  final ChipVariant variant;
}
```

- 默认高度 32，Padding 8
- 圆角 8（`AppRadius.sm`）
- 选中：蓝底白字
- 未选：浅灰底深字

### 1.3 Card

文件：`app/lib/shared/components/card.dart`

```dart
class AppCard extends StatelessWidget {
  const AppCard({
    required this.child,
    this.variant = CardVariant.default_, // default | hero | flat
    this.onTap,
    this.padding,
    super.key,
  });
  final Widget child;
  final CardVariant variant;
  final VoidCallback? onTap;
  final EdgeInsets? padding;
}
```

- default：白底 + `--shadow-1` + 圆角 16
- hero：浅蓝底 + 圆角 20
- flat：白底 + `--slate-200` 描边 + 圆角 16
- onTap：ripple 效果

### 1.4 Tab

文件：`app/lib/shared/components/tabs.dart`

```dart
class AppSegmentedTab<T> extends StatelessWidget {
  const AppSegmentedTab({
    required this.tabs,    // List<(T, String)>
    required this.value,
    required this.onChanged,
    super.key,
  });
}
```

### 1.5 BottomNav

已在 `core/router/main_shell.dart` 用 `BottomNavigationBar` 实现。本阶段**保留现有实现**，但抽出 `AppTabBarItem` 数据类便于统一配置。

文件：`app/lib/shared/components/tab_bar.dart`

```dart
class AppTabBarItem {
  const AppTabBarItem({
    required this.path,
    required this.icon,
    required this.label,
    this.badge,
  });
  final String path;
  final IconData icon;
  final String label;
  final String? badge;
}
```

### 1.6 Modal

文件：`app/lib/shared/components/modal.dart`

```dart
Future<T?> showAppModal<T>(BuildContext ctx, {required Widget child, double initialChildSize = 0.5}) =>
    showModalBottomSheet<T>(...);
```

### 1.7 Toast

文件：`app/lib/shared/components/toast.dart`

```dart
void showAppToast(BuildContext ctx, {required String message, AppToastVariant variant = AppToastVariant.info}) { ... }

enum AppToastVariant { info, success, warning, error }
```

实现：用 `ScaffoldMessenger.showSnackBar`，配 4 种颜色的 background。

### 1.8 ListItem

文件：`app/lib/shared/components/list_item.dart`

```dart
class AppListItem extends StatelessWidget {
  const AppListItem({
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.showChevron = true,
    super.key,
  });
}
```

- 三种 variant：singleLine / twoLine / threeLine
- Padding: 12 horizontal, 16 vertical
- 圆角 16

### 1.9 Input

文件：`app/lib/shared/components/input.dart`

```dart
class AppInput extends StatelessWidget {
  const AppInput({
    required this.controller,
    required this.label,
    this.hint,
    this.maxLength,
    this.maxLines = 1,
    this.errorText,
    this.leadingIcon,
    super.key,
  });
}
```

- Border：默认 `--slate-200`，focused 时 `--blue-600`
- Error：边框 `--clay-600` + 错误提示

### 1.10 SearchBar

文件：`app/lib/shared/components/search_bar.dart`

```dart
class AppSearchBar extends StatelessWidget {
  const AppSearchBar({
    required this.controller,
    required this.placeholder,
    this.onChanged,
    this.onSubmitted,
    this.onCancel,
    super.key,
  });
}
```

- Search icon leading
- 圆角 999（full）
- Cancel 按钮（focused 时显示）

### 1.11 Toggle

文件：`app/lib/shared/components/toggle.dart`

```dart
class AppToggle extends StatelessWidget {
  const AppToggle({
    required this.value,
    required this.onChanged,
    this.label,
    super.key,
  });
}
```

### 1.12 Avatar

文件：`app/lib/shared/components/avatar.dart`

```dart
class AppAvatar extends StatelessWidget {
  const AppAvatar({
    this.imageUrl,
    this.initials,
    this.size = AvatarSize.md, // sm=32, md=40, lg=56
    this.status, // online | busy | away
    super.key,
  });
}
```

- 网络图用 `cached_network_image`（Spec A 已加）
- 文字 fallback：截首字母

### 1.13 ProgressBar

文件：`app/lib/shared/components/progress_bar.dart`

```dart
class AppProgressBar extends StatelessWidget {
  const AppProgressBar({
    this.value,           // 0.0 - 1.0, null = indeterminate
    this.height = 4.0,
    this.color,
    super.key,
  });
}
```

### 1.14 Skeleton

文件：`app/lib/shared/components/skeleton.dart`

```dart
class AppSkeleton extends StatefulWidget { ... }
class AppSkeletonBox extends StatelessWidget {
  // 矩形 skeleton
}
class AppSkeletonText extends StatelessWidget {
  // 单行文本 skeleton
}
class AppSkeletonList extends StatelessWidget {
  // 列表行 skeleton（用于 loading）
}
```

- 用 `AnimationController` 实现 shimmer 效果
- 圆角继承父容器

---

## 2. 4 个 Tab 首页

### 2.1 Prepare 首页（`/prepare`）

文件：`app/lib/features/prepare/presentation/pages/prepare_page.dart`（替换占位）

布局：
```
[ 顶栏 "Prepare" ]
[ 母国切换 chip 行 ]            ← 选 1 个国家
[ ─── 今日必办 ─── ]
[ Policy Card 1 ]               ← 政策卡（"Free 30-day visa" + 来源 + 详情箭头）
[ Policy Card 2 ]
[ Policy Card 3 ]
[ ─── 行前清单 ─── ]
[ Checklist: ☑ 护照有效期 6+ 月 ]
[ Checklist: ☐ 现金（人民币 2000+） ]
[ Checklist: ☐ 紧急联系（医院/使领馆） ]
[ Checklist: ☐ 离线包已下载 ]
[ ProgressBar: 1/4 已完成 ]
[ ─── 离线包 ─── ]
[ ListItem: 上海核心离线包（12 MB）下载 ]
```

- 数据：调用 `GET /policies?country=US` + `GET /checklist?country=US`
- Mock 拦截器返回空 data，UI 显示 `AppSkeletonList` (loading) → empty state
- i18n key：约 12 个

### 2.2 Map 首页（`/map`）

文件：`app/lib/features/map/presentation/pages/map_page.dart`（替换占位）

布局：
```
[ SearchBar "Search attractions" ]
[ 5 chip 行：All / 景点 / 餐饮 / 住宿 / 购物 ]
[ ─── 推荐 ─── ]
[ Card Hero: 周末市集（外滩源）3 km ]
[ Card: 豫园 ] [ Card: 田子坊 ]
[ Card: 上海博物馆 ] [ Card: 武康路 ]
[ Skeleton when loading ]
```

- 数据：调用 `GET /pois/search?q=&category=`
- 距你 X km：占位写死
- i18n key：约 6 个

### 2.3 Discover 首页（`/discover`）

文件：`app/lib/features/discover/presentation/pages/discover_page.dart`（替换占位）

布局：
```
[ 顶栏 "Discover" ]
[ AppSegmentedTab: Curated | Authentic | Heads-up ]
[ 滚动 ListView：
  [ Card Hero: Top 10 必看博物馆 ]
  [ Card: 5 家游客不熟的小笼馆 ]
  [ Card: 6 处避坑指南 ]
]
```

- 数据：3 个 mock endpoint
- i18n key：约 8 个

### 2.4 Tools 首页（`/tools`）

文件：`app/lib/features/tools/presentation/pages/tools_page.dart`（替换占位）

布局：
```
[ 顶栏 "Tools" ]
[ ─── 实时换算 ─── ]
[ Card: 货币换算（USD → CNY）]
  - AppInput: 100
  - 显示 720（示例汇率）
  - AppToggle: 自动根据母国
[ ─── 工具入口 ─── ]
[ ListItem: 常用语手册 → ]
[ ListItem: 紧急联系 → ]
[ ListItem: 单位换算 → ]
[ ListItem: 时区查询 → ]
[ ListItem: 离线包下载 → ]
[ ListItem: 翻译助手 → ]
```

- 货币换算：调用 `GET /fx/rates?from=USD&to=CNY`，本地 mock
- 6 个工具入口，下一阶段实现子页
- i18n key：约 10 个

---

## 3. i18n 增量（约 36 个新 key）

| Tab | key 数量 | 例子 |
| :--- | :--- | :--- |
| Prepare | 12 | `prepareTitle`, `policyVisa`, `policyVisaDesc`, `policySource`, `checklistTitle`, `checklistItemXxx`, `offlineDownloadsTitle` |
| Map | 6 | `mapTitle`, `mapSearchHint`, `mapCategoryAll`, `mapCategoryAttraction`, ... |
| Discover | 8 | `discoverTitle`, `discoverTabCurated`, `discoverTabAuthentic`, `discoverTabHeadsUp`, `discoverCard1Title`, ... |
| Tools | 10 | `toolsTitle`, `toolsFxTitle`, `toolsFxFrom`, `toolsFxTo`, `toolsTool1`, ..., `toolsTool6` |

中英双语，全在 plan §6 详细列出。

---

## 4. Mock 端点扩展

现有 8 个端点（Spec A）。本阶段不需要新加端点，全部用现有：
- `GET /policies?country=...` → 已存在
- `GET /checklist?country=...` → 已存在
- `GET /pois/search?q=...` → 已存在
- `GET /pois/categories` → 已存在
- `GET /discover/curated` → 已存在
- `GET /discover/authentic` → 已存在
- `GET /discover/heads-up` → 已存在
- `GET /fx/rates?from=...&to=...` → 已存在

Mock 全部返回 `{"data": []}`，UI 走 loading → empty 流程。

---

## 5. 依赖注入

`injection.config.dart`（手动补）注册：
- `PolicyRepository`（impl）+ `PolicyRepositoryImpl`
- `ChecklistRepository`（impl）+ `ChecklistRepositoryImpl`
- `PoiRepository`（impl）+ `PoiRepositoryImpl`
- `DiscoverRepository`（impl）+ `DiscoverRepositoryImpl`
- `FxRepository`（impl）+ `FxRepositoryImpl`
- `PrepareHomeCubit` / `MapHomeCubit` / `DiscoverHomeCubit` / `ToolsHomeCubit`

每个 Tab 一个 `HomeCubit`，管理该 Tab 首页 state（loading / loaded / empty / error）。

---

## 6. 测试

- `test/shared/components/button_test.dart`（4 variants × 3 sizes × 5 states = 60 断言）
- `test/shared/components/chip_test.dart`（selected / unselected / leading icon）
- `test/shared/components/card_test.dart`（default / hero / flat / onTap）
- `test/shared/components/list_item_test.dart`（1-2-3 line）
- `test/shared/components/input_test.dart`（text / error / max length）
- `test/shared/components/search_bar_test.dart`（text / cancel）
- `test/shared/components/toggle_test.dart`（on / off）
- `test/shared/components/avatar_test.dart`（image / initials / size）
- `test/shared/components/progress_bar_test.dart`（determinate / indeterminate）
- `test/shared/components/skeleton_test.dart`（box / text / list）
- `test/shared/components/tabs_test.dart`（segmented）
- `test/shared/components/toast_test.dart`（info / success / warning / error）
- `test/features/prepare/prepare_home_cubit_test.dart`
- `test/features/map/map_home_cubit_test.dart`
- `test/features/discover/discover_home_cubit_test.dart`
- `test/features/tools/tools_home_cubit_test.dart`
- `test/features/prepare/prepare_page_test.dart`
- `test/features/map/map_page_test.dart`
- `test/features/discover/discover_page_test.dart`
- `test/features/tools/tools_page_test.dart`

累计预计 **+40 个测试**。

---

## 7. 范围外

- ❌ POI 详情 / Policy 详情
- ❌ 真地图集成（amap）
- ❌ 实时数据 / 真实后端
- ❌ 离线包下载
- ❌ 路线规划
- ❌ 收藏 / 点赞

---

## 8. 风险

| 风险 | 缓解 |
| :--- | :--- |
| 14 个组件 = 工作量大 | 每组件 1 个 dart 文件 + 1 个测试文件，subagent 批量并行 |
| Mock 返回空 → 全屏空 | UI 必须实现 loading / empty 两种状态 |
| Design tokens 缺失（如 `--shadow-2`） | Spec A 已有 app_shadow.dart，subagent 缺什么补什么 |
| i18n key 36 个翻译不同步 | en / zh 同步写进 plan |
| `injection.config.dart` 中文路径 build_runner 失败 | 手动补（Spec B/C 已用此模式） |

---

## 9. 提交策略

```
feat(design-system): 14 reusable components
feat(prepare): home page with policies, checklist, downloads
feat(map): home page with POI list and search
feat(discover): home page with 3 category tabs
feat(tools): home page with FX converter and tool entries
feat(i18n): 36 prepare/map/discover/tools keys
```

---

## 10. 自我审查

- [x] 无 TBD / TODO 留空
- [x] 范围聚焦：仅 4 tab 首页 + 14 组件
- [x] 命名一致：所有组件 `App*` 前缀
- [x] 复用 Spec A：theme / network / storage / DI
- [x] 测试覆盖：组件 + Cubit + Page
- [x] 范围外明确列出
- [x] 14 组件文件命名 `app/lib/shared/components/{name}.dart`

---

## 附录 A · 关联文档

- [Design System 规范](file:///c:/Users/wenmo/.trae-cn/worktrees/旅游app/docs/superpowers/specs/2026-06-26-sightour-design-system.md)
- [信息架构](file:///c:/Users/wenmo/.trae-cn/worktrees/旅游app/docs/superpowers/specs/2026-06-26-sightour-information-architecture.md)
- [MVP Plan](file:///c:/Users/wenmo/.trae-cn/worktrees/旅游app/docs/superpowers/plans/2026-06-26-sightour-mvp.md) Task 15-22
- [Spec A 基础设施](file:///c:/Users/wenmo/.trae-cn/worktrees/旅游app/docs/superpowers/specs/2026-06-27-sightour-stage1-foundation-design.md)
