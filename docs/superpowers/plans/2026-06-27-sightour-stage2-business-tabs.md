# Sightour Stage 2 — 4 核心 Tab + 14 DS 组件 实施计划

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development to implement this plan task-by-task.

**Goal:** Implement 14 Design System components + 4 tab home pages (Prepare/Map/Discover/Tools) using Mock data. All components use existing theme tokens. No real map yet, no detail sub-pages.

**Architecture:** Reuse Spec A's theme/network/storage/DI. New `app/lib/shared/components/` directory for 14 components. Each tab gets a `HomeCubit` (loading/empty/loaded) + page consuming shared components.

**Tech Stack:** (carried from Stage 1) freezed, get_it + injectable (manual config), dio 5.7, intl, cached_network_image, hive_ce.

**上游文档：**
- [Stage 2 Design](file:///c:/Users/wenmo/.trae-cn/worktrees/旅游app/docs/superpowers/specs/2026-06-27-sightour-stage2-business-tabs-design.md)

---

## Task D1：14 Design System 组件

**Files:** All under `app/lib/shared/components/` (create directory)

- Create: `app/lib/shared/components/button.dart` + `app/test/shared/components/button_test.dart`
- Create: `app/lib/shared/components/chip.dart` + `test/chip_test.dart`
- Create: `app/lib/shared/components/card.dart` + `test/card_test.dart`
- Create: `app/lib/shared/components/tabs.dart` + `test/tabs_test.dart`
- Create: `app/lib/shared/components/tab_bar.dart` (just data class)
- Create: `app/lib/shared/components/modal.dart`
- Create: `app/lib/shared/components/toast.dart` + `test/toast_test.dart`
- Create: `app/lib/shared/components/list_item.dart` + `test/list_item_test.dart`
- Create: `app/lib/shared/components/input.dart` + `test/input_test.dart`
- Create: `app/lib/shared/components/search_bar.dart` + `test/search_bar_test.dart`
- Create: `app/lib/shared/components/toggle.dart` + `test/toggle_test.dart`
- Create: `app/lib/shared/components/avatar.dart` + `test/avatar_test.dart`
- Create: `app/lib/shared/components/progress_bar.dart` + `test/progress_bar_test.dart`
- Create: `app/lib/shared/components/skeleton.dart` + `test/skeleton_test.dart`

> **所有组件**用 `core/theme/` 下的 tokens（`AppColors` / `AppSpacing` / `AppRadius` / `AppShadow` / `AppTextTheme`）。**禁止**硬编码颜色 / 间距 / 字号。

### 关键代码模式（每个组件 1 个 dart 文件 + 1 个测试文件）

#### Button 模板（其他组件类似）

```dart
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_text_styles.dart';

enum ButtonVariant { primary, secondary, ghost, destructive }
enum ButtonSize { sm, md, lg }

class AppButton extends StatelessWidget {
  const AppButton({
    required this.label,
    required this.onPressed,
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final disabled = onPressed == null;
    final sizeH = size == ButtonSize.sm ? 32.0 : size == ButtonSize.lg ? 52.0 : 44.0;
    final bg = switch (variant) {
      ButtonVariant.primary => disabled ? AppColors.slate100 : AppColors.slate900,
      ButtonVariant.secondary => AppColors.slate100,
      ButtonVariant.ghost => Colors.transparent,
      ButtonVariant.destructive => disabled ? AppColors.slate100 : AppColors.clay600,
    };
    final fg = switch (variant) {
      ButtonVariant.primary => AppColors.white,
      ButtonVariant.secondary => AppColors.slate700,
      ButtonVariant.ghost => AppColors.blue600,
      ButtonVariant.destructive => AppColors.white,
    };
    return SizedBox(
      height: sizeH,
      child: ElevatedButton(
        onPressed: loading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: fg,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          padding: size == ButtonSize.sm
              ? const EdgeInsets.symmetric(horizontal: AppSpacing.s3)
              : size == ButtonSize.lg
                  ? const EdgeInsets.symmetric(horizontal: AppSpacing.s6)
                  : const EdgeInsets.symmetric(horizontal: AppSpacing.s4),
        ),
        child: loading
            ? const SizedBox(
                width: 18, height: 18,
                child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.white))
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (leadingIcon != null) ...[
                    Icon(leadingIcon, size: 18),
                    const SizedBox(width: AppSpacing.s2),
                  ],
                  Text(label, style: AppTextTheme.textTheme.bodyLarge?.copyWith(color: fg, fontWeight: FontWeight.w600)),
                ],
              ),
      ),
    );
  }
}
```

#### 测试模板

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sightour/shared/components/button.dart';

void main() {
  Widget _wrap(Widget child) => MaterialApp(home: Scaffold(body: Center(child: child)));

  testWidgets('primary button renders label and is tappable', (tester) async {
    var tapped = false;
    await tester.pumpWidget(_wrap(AppButton(label: 'Continue', onPressed: () => tapped = true)));
    expect(find.text('Continue'), findsOneWidget);
    await tester.tap(find.text('Continue'));
    expect(tapped, true);
  });

  testWidgets('disabled button does not invoke onPressed', (tester) async {
    var tapped = false;
    await tester.pumpWidget(_wrap(AppButton(label: 'Continue', onPressed: null)));
    await tester.tap(find.text('Continue'));
    expect(tapped, false);
  });

  testWidgets('loading shows spinner', (tester) async {
    await tester.pumpWidget(_wrap(AppButton(label: 'Send', onPressed: () {}, loading: true)));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('all 3 sizes', (tester) async {
    for (final s in ButtonSize.values) {
      await tester.pumpWidget(_wrap(AppButton(label: 'X', onPressed: () {}, size: s)));
    }
  });
}
```

### 14 个组件最小化测试断言数

| 组件 | 断言数 |
| :--- | :--- |
| Button | 4（default/disabled/loading/leading icon） |
| Chip | 3（unselected/selected/leading icon） |
| Card | 4（default/hero/flat/onTap） |
| Tabs | 2（segmented renders/onChange） |
| Toast | 1（`showAppToast` 不抛异常） |
| ListItem | 3（1-line/2-line/3-line） |
| Input | 3（text typing/error/maxLength） |
| SearchBar | 2（input/cancel） |
| Toggle | 2（on/off） |
| Avatar | 3（initials/image fallback/size） |
| ProgressBar | 2（determinate/indeterminate） |
| Skeleton | 3（box/text/list） |

合计 **30 个测试**。

### 验收

- [ ] `cd app && dart analyze` — `No issues found!`
- [ ] `cd app && flutter test test/shared/components/` — 30 passed
- [ ] Commit: `feat(design-system): 14 reusable components`

---

## Task D2：Prepare 首页

**Files:**
- Create: `app/lib/features/prepare/data/repositories/policy_repository_impl.dart`
- Create: `app/lib/features/prepare/data/repositories/checklist_repository_impl.dart`
- Create: `app/lib/features/prepare/domain/entities/policy.dart`
- Create: `app/lib/features/prepare/domain/entities/checklist_item.dart`
- Create: `app/lib/features/prepare/domain/repositories/policy_repository.dart`
- Create: `app/lib/features/prepare/domain/repositories/checklist_repository.dart`
- Create: `app/lib/features/prepare/presentation/cubit/prepare_home_cubit.dart`
- Create: `app/lib/features/prepare/presentation/pages/prepare_page.dart`（替换占位）
- Create: `app/lib/features/prepare/presentation/widgets/policy_card.dart`
- Create: `app/test/features/prepare/prepare_home_cubit_test.dart`
- Create: `app/test/features/prepare/prepare_page_test.dart`

### 关键代码

#### Policy 实体

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
part 'policy.freezed.dart';
part 'policy.g.dart';

@freezed
class Policy with _$Policy {
  const factory Policy({
    required String id,
    required String title,
    required String description,
    required String source,
    required String country, // ISO2
  }) = _Policy;
  factory Policy.fromJson(Map<String, dynamic> json) => _$PolicyFromJson(json);
}
```

> **不跑 build_runner**（中文路径 AOT 失败），**手动写** `policy.freezed.dart` 和 `policy.g.dart`：

```dart
// policy.freezed.dart
class _$Policy implements Policy {
  const _$Policy({required this.id, required this.title, required this.description, required this.source, required this.country});
  @override final String id;
  @override final String title;
  @override final String description;
  @override final String source;
  @override final String country;
  @override String toString() => 'Policy(id: $id, title: $title, ...)';
  // copyWith / ==
}

abstract class _Policy implements Policy { ... }
```

或者更简单：**不用 freezed**，直接写普通 class：

```dart
class Policy {
  const Policy({required this.id, required this.title, required this.description, required this.source, required this.country});
  final String id;
  final String title;
  final String description;
  final String source;
  final String country;
  Policy copyWith({String? id, String? title, String? description, String? source, String? country}) =>
      Policy(
        id: id ?? this.id, title: title ?? this.title, description: description ?? this.description,
        source: source ?? this.source, country: country ?? this.country,
      );
  @override bool operator ==(Object other) => ...;
  @override int get hashCode => ...;
}
```

> **推荐用普通 class 写法**，避免 freezed 生成文件。Stage 1 也基本用普通 class。

#### ChecklistItem 实体

```dart
class ChecklistItem {
  const ChecklistItem({required this.id, required this.title, required this.done});
  final String id;
  final String title;
  final bool done;
  ChecklistItem copyWith({String? id, String? title, bool? done}) =>
      ChecklistItem(id: id ?? this.id, title: title ?? this.title, done: done ?? this.done);
}
```

#### PolicyRepositoryImpl

```dart
@LazySingleton(as: PolicyRepository)
class PolicyRepositoryImpl implements PolicyRepository {
  final DioClient _dioClient;
  PolicyRepositoryImpl(this._dioClient);
  @override
  Future<List<Policy>> fetchPolicies(String country) async {
    final response = await _dioClient.dio.get('/policies', queryParameters: {'country': country});
    final raw = response.data['data'] as List? ?? [];
    return raw.map((e) => Policy.fromJson(e as Map<String, dynamic>)).toList();
  }
}
```

#### PrepareHomeCubit

```dart
class PrepareHomeState {
  const PrepareHomeState({
    this.policies = const [],
    this.checklist = const [],
    this.isLoading = false,
    this.error,
    this.country = 'US',
  });
  final List<Policy> policies;
  final List<ChecklistItem> checklist;
  final bool isLoading;
  final String? error;
  final String country;
  // copyWith
}

@injectable
class PrepareHomeCubit extends Cubit<PrepareHomeState> {
  PrepareHomeCubit(this._policyRepo, this._checklistRepo) : super(const PrepareHomeState());
  final PolicyRepository _policyRepo;
  final ChecklistRepository _checklistRepo;

  Future<void> load({String? country}) async {
    if (country != null) emit(state.copyWith(country: country));
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final policies = await _policyRepo.fetchPolicies(state.country);
      final checklist = await _checklistRepo.fetchChecklist(state.country);
      emit(state.copyWith(policies: policies, checklist: checklist, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  void toggleItem(String id) {
    final updated = state.checklist.map((i) => i.id == id ? i.copyWith(done: !i.done) : i).toList();
    emit(state.copyWith(checklist: updated));
  }
}
```

#### PreparePage UI

```dart
class PreparePage extends StatefulWidget {
  const PreparePage({super.key});
  @override
  State<PreparePage> createState() => _PreparePageState();
}

class _PreparePageState extends State<PreparePage> {
  @override
  void initState() {
    super.initState();
    context.read<PrepareHomeCubit>().load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.prepareTitle)),
      body: BlocBuilder<PrepareHomeCubit, PrepareHomeState>(
        builder: (ctx, state) {
          if (state.isLoading) {
            return ListView(children: const [AppSkeletonList(count: 5)]);
          }
          if (state.error != null) {
            return Center(child: AppErrorView(message: state.error!));
          }
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.s4),
            children: [
              _CountryChips(),
              const SizedBox(height: AppSpacing.s4),
              _Section(title: 'Policies'),
              if (state.policies.isEmpty)
                AppEmptyView(title: 'No policies for ${state.country} yet')
              else
                ...state.policies.map((p) => PolicyCard(policy: p)),
              const SizedBox(height: AppSpacing.s4),
              _Section(title: 'Pre-arrival checklist'),
              ...state.checklist.map((i) => CheckboxListTile(
                value: i.done,
                onChanged: (_) => ctx.read<PrepareHomeCubit>().toggleItem(i.id),
                title: Text(i.title),
              )),
              AppProgressBar(value: state.checklist.where((i) => i.done).length / state.checklist.length),
              const SizedBox(height: AppSpacing.s4),
              _Section(title: 'Offline downloads'),
              AppListItem(
                leading: const Icon(Icons.download_outlined),
                title: 'Shanghai core pack',
                subtitle: '12 MB · maps + phrases + emergency',
                onTap: () => ctx.showAppToast(message: 'Download starting soon'),
              ),
            ],
          );
        },
      ),
    );
  }
}
```

> `AppErrorView` 和 `AppEmptyView` 可作额外小组件或就地实现。简单实现即可。

### 验收

- [ ] `dart analyze` — 0 issues
- [ ] `flutter test test/features/prepare/` — 6+ passed
- [ ] Commit: `feat(prepare): home page with policies, checklist, downloads`

---

## Task D3：Map 首页

**Files:**
- Create: `app/lib/features/map/data/repositories/poi_repository_impl.dart`
- Create: `app/lib/features/map/domain/entities/poi.dart`
- Create: `app/lib/features/map/domain/repositories/poi_repository.dart`
- Create: `app/lib/features/map/presentation/cubit/map_home_cubit.dart`
- Create: `app/lib/features/map/presentation/pages/map_page.dart`（替换占位）
- Create: `app/lib/features/map/presentation/widgets/poi_card.dart`
- Create: `app/test/features/map/map_home_cubit_test.dart`
- Create: `app/test/features/map/map_page_test.dart`

### POI 实体

```dart
class Poi {
  const Poi({required this.id, required this.name, required this.category, required this.distanceKm, required this.avgScore});
  final String id;
  final String name;
  final String category; // attraction | dining | lodging | shopping
  final double distanceKm;
  final double avgScore; // 0.0 - 5.0
}
```

### PoiRepositoryImpl

```dart
@LazySingleton(as: PoiRepository)
class PoiRepositoryImpl implements PoiRepository {
  final DioClient _dioClient;
  PoiRepositoryImpl(this._dioClient);
  @override
  Future<List<Poi>> search({String? q, String? category}) async {
    final response = await _dioClient.dio.get('/pois/search', queryParameters: {
      if (q != null && q.isNotEmpty) 'q': q,
      if (category != null) 'category': category,
    });
    final raw = response.data['data'] as List? ?? [];
    return raw.map((e) => Poi.fromJson(e as Map<String, dynamic>)).toList();
  }
}
```

### MapHomeCubit

```dart
class MapHomeState {
  const MapHomeState({
    this.pois = const [],
    this.isLoading = false,
    this.error,
    this.query = '',
    this.category = 'all',
  });
  final List<Poi> pois;
  final bool isLoading;
  final String? error;
  final String query;
  final String category; // all | attraction | dining | lodging | shopping
  // copyWith
}

@injectable
class MapHomeCubit extends Cubit<MapHomeState> {
  MapHomeCubit(this._repo) : super(const MapHomeState());
  final PoiRepository _repo;
  Future<void> load() async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final pois = await _repo.search(q: state.query, category: state.category == 'all' ? null : state.category);
      emit(state.copyWith(pois: pois, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
  void setQuery(String q) => emit(state.copyWith(query: q));
  void setCategory(String c) { emit(state.copyWith(category: c)); load(); }
  void search() => load();
}
```

### MapPage UI

```dart
class MapPage extends StatefulWidget {
  const MapPage({super.key});
  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final _searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    context.read<MapHomeCubit>().load();
  }
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l.mapTitle)),
      body: BlocBuilder<MapHomeCubit, MapHomeState>(
        builder: (ctx, state) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(AppSpacing.s4),
                child: AppSearchBar(
                  controller: _searchController,
                  placeholder: l.mapSearchHint,
                  onSubmitted: (q) { ctx.read<MapHomeCubit>().setQuery(q); ctx.read<MapHomeCubit>().search(); },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s4),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(children: [
                    for (final cat in const ['all', 'attraction', 'dining', 'lodging', 'shopping'])
                      Padding(
                        padding: const EdgeInsets.only(right: AppSpacing.s2),
                        child: AppChip(
                          label: l.forCategory(cat),
                          selected: state.category == cat,
                          onTap: () => ctx.read<MapHomeCubit>().setCategory(cat),
                        ),
                      ),
                  ]),
                ),
              ),
              const SizedBox(height: AppSpacing.s3),
              Expanded(
                child: state.isLoading
                    ? const AppSkeletonList(count: 4)
                    : state.pois.isEmpty
                        ? Center(child: Text(l.mapEmpty))
                        : ListView.builder(
                            itemCount: state.pois.length,
                            itemBuilder: (_, i) => PoiCard(poi: state.pois[i]),
                          ),
              ),
            ],
          );
        },
      ),
    );
  }
}
```

> `l.forCategory(cat)` 是新增扩展方法（见 i18n 部分）。

### 验收

- [ ] `dart analyze` — 0 issues
- [ ] `flutter test test/features/map/` — 5+ passed
- [ ] Commit: `feat(map): home page with POI list and search`

---

## Task D4：Discover 首页

**Files:**
- Create: `app/lib/features/discover/data/repositories/discover_repository_impl.dart`
- Create: `app/lib/features/discover/domain/entities/discover_card.dart`
- Create: `app/lib/features/discover/domain/repositories/discover_repository.dart`
- Create: `app/lib/features/discover/presentation/cubit/discover_home_cubit.dart`
- Create: `app/lib/features/discover/presentation/pages/discover_page.dart`（替换占位）
- Create: `app/lib/features/discover/presentation/widgets/discover_card_widget.dart`
- Create: `app/test/features/discover/discover_home_cubit_test.dart`
- Create: `app/test/features/discover/discover_page_test.dart`

### DiscoverCard 实体

```dart
class DiscoverCard {
  const DiscoverCard({required this.id, required this.title, required this.subtitle, required this.score});
  final String id;
  final String title;
  final String subtitle;
  final double score; // 0.0 - 5.0
}
```

### DiscoverRepositoryImpl

```dart
@LazySingleton(as: DiscoverRepository)
class DiscoverRepositoryImpl implements DiscoverRepository {
  final DioClient _dioClient;
  DiscoverRepositoryImpl(this._dioClient);
  @override
  Future<List<DiscoverCard>> curated() async => _fetch('/discover/curated');
  @override
  Future<List<DiscoverCard>> authentic() async => _fetch('/discover/authentic');
  @override
  Future<List<DiscoverCard>> headsUp() async => _fetch('/discover/heads-up');
  Future<List<DiscoverCard>> _fetch(String path) async {
    final response = await _dioClient.dio.get(path);
    final raw = response.data['data'] as List? ?? [];
    return raw.map((e) => DiscoverCard.fromJson(e as Map<String, dynamic>)).toList();
  }
}
```

### DiscoverHomeCubit

```dart
enum DiscoverTab { curated, authentic, headsUp }

class DiscoverHomeState {
  const DiscoverHomeState({this.tab = DiscoverTab.curated, this.cards = const [], this.isLoading = false, this.error});
  final DiscoverTab tab;
  final List<DiscoverCard> cards;
  final bool isLoading;
  final String? error;
  // copyWith
}

@injectable
class DiscoverHomeCubit extends Cubit<DiscoverHomeState> {
  DiscoverHomeCubit(this._repo) : super(const DiscoverHomeState());
  final DiscoverRepository _repo;
  Future<void> selectTab(DiscoverTab t) async {
    emit(state.copyWith(tab: t, isLoading: true));
    try {
      final cards = switch (t) {
        DiscoverTab.curated => await _repo.curated(),
        DiscoverTab.authentic => await _repo.authentic(),
        DiscoverTab.headsUp => await _repo.headsUp(),
      };
      emit(state.copyWith(cards: cards, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}
```

### DiscoverPage UI

```dart
class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});
  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DiscoverHomeCubit>().selectTab(DiscoverTab.curated);
    });
  }
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l.discoverTitle)),
      body: BlocBuilder<DiscoverHomeCubit, DiscoverHomeState>(
        builder: (ctx, state) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(AppSpacing.s4),
                child: AppSegmentedTab<DiscoverTab>(
                  tabs: [
                    (DiscoverTab.curated, l.discoverTabCurated),
                    (DiscoverTab.authentic, l.discoverTabAuthentic),
                    (DiscoverTab.headsUp, l.discoverTabHeadsUp),
                  ],
                  value: state.tab,
                  onChanged: ctx.read<DiscoverHomeCubit>().selectTab,
                ),
              ),
              Expanded(
                child: state.isLoading
                    ? const AppSkeletonList(count: 4)
                    : state.cards.isEmpty
                        ? Center(child: Text(l.discoverEmpty))
                        : ListView.builder(
                            itemCount: state.cards.length,
                            itemBuilder: (_, i) => DiscoverCardWidget(card: state.cards[i]),
                          ),
              ),
            ],
          );
        },
      ),
    );
  }
}
```

### 验收

- [ ] `dart analyze` — 0 issues
- [ ] `flutter test test/features/discover/` — 5+ passed
- [ ] Commit: `feat(discover): home page with 3 category tabs`

---

## Task D5：Tools 首页

**Files:**
- Create: `app/lib/features/tools/data/repositories/fx_repository_impl.dart`
- Create: `app/lib/features/tools/data/repositories/tools_repository_impl.dart`
- Create: `app/lib/features/tools/domain/entities/fx_rate.dart`
- Create: `app/lib/features/tools/domain/entities/tool_entry.dart`
- Create: `app/lib/features/tools/domain/repositories/fx_repository.dart`
- Create: `app/lib/features/tools/domain/repositories/tools_repository.dart`
- Create: `app/lib/features/tools/presentation/cubit/tools_home_cubit.dart`
- Create: `app/lib/features/tools/presentation/cubit/fx_converter_cubit.dart`
- Create: `app/lib/features/tools/presentation/pages/tools_page.dart`（替换占位）
- Create: `app/lib/features/tools/presentation/widgets/fx_converter_card.dart`
- Create: `app/test/features/tools/tools_home_cubit_test.dart`
- Create: `app/test/features/tools/fx_converter_cubit_test.dart`
- Create: `app/test/features/tools/tools_page_test.dart`

### 实体

```dart
class FxRate {
  const FxRate({required this.from, required this.to, required this.rate, required this.updatedAt});
  final String from;
  final String to;
  final double rate;
  final DateTime updatedAt;
  static double convert(FxRate r, double amount) => amount * r.rate;
}

class ToolEntry {
  const ToolEntry({required this.id, required this.title, required this.subtitle, required this.icon});
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
}
```

### FxRepositoryImpl

```dart
@LazySingleton(as: FxRepository)
class FxRepositoryImpl implements FxRepository {
  final DioClient _dioClient;
  FxRepositoryImpl(this._dioClient);
  @override
  Future<FxRate> rate(String from, String to) async {
    final response = await _dioClient.dio.get('/fx/rates', queryParameters: {'from': from, 'to': to});
    final data = response.data['data'] as Map<String, dynamic>?;
    if (data == null) throw Exception('No FX data');
    return FxRate(
      from: from, to: to, rate: (data['rate'] as num).toDouble(), updatedAt: DateTime.now(),
    );
  }
}
```

### FxConverterCubit

```dart
class FxConverterState {
  const FxConverterState({this.amount = 100.0, this.rate, this.isLoading = false, this.error, this.from = 'USD', this.to = 'CNY'});
  final double amount;
  final FxRate? rate;
  final bool isLoading;
  final String? error;
  final String from;
  final String to;
  double get converted => rate == null ? 0.0 : FxRate.convert(rate!, amount);
  // copyWith
}

@injectable
class FxConverterCubit extends Cubit<FxConverterState> {
  FxConverterCubit(this._repo) : super(const FxConverterState());
  final FxRepository _repo;
  Future<void> load({String? from, String? to}) async {
    final f = from ?? state.from;
    final t = to ?? state.to;
    emit(state.copyWith(isLoading: true, error: null, from: f, to: t));
    try {
      final rate = await _repo.rate(f, t);
      emit(state.copyWith(rate: rate, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
  void setAmount(double v) => emit(state.copyWith(amount: v));
}
```

### ToolsPage UI

```dart
class ToolsPage extends StatefulWidget {
  const ToolsPage({super.key});
  @override
  State<ToolsPage> createState() => _ToolsPageState();
}

class _ToolsPageState extends State<ToolsPage> {
  static const _tools = [
    ToolEntry(id: 'phrases', title: 'Phrase book', subtitle: 'Border · Transport · Dining · Medical', icon: Icons.translate),
    ToolEntry(id: 'emergency', title: 'Emergency contacts', subtitle: 'Police · Hospital · Embassy', icon: Icons.phone_in_talk),
    ToolEntry(id: 'units', title: 'Unit converter', subtitle: 'Length · Weight · Temperature', icon: Icons.swap_horiz),
    ToolEntry(id: 'timezone', title: 'Time zone', subtitle: 'US ET vs Shanghai CN', icon: Icons.public),
    ToolEntry(id: 'offline', title: 'Offline pack', subtitle: 'Maps + phrases, ready offline', icon: Icons.cloud_off),
    ToolEntry(id: 'translate', title: 'Translate assistant', subtitle: 'Camera + voice translate', icon: Icons.camera_alt),
  ];
  @override
  void initState() {
    super.initState();
    context.read<FxConverterCubit>().load();
  }
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l.toolsTitle)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.s4),
        children: [
          _Section(title: l.toolsFxTitle),
          const FxConverterCard(),
          const SizedBox(height: AppSpacing.s4),
          _Section(title: l.toolsAllTools),
          ..._tools.map((t) => AppListItem(
            leading: Icon(t.icon),
            title: t.title,
            subtitle: t.subtitle,
            onTap: () => context.showAppToast(message: l.toolsComingSoon),
          )),
        ],
      ),
    );
  }
}
```

### 验收

- [ ] `dart analyze` — 0 issues
- [ ] `flutter test test/features/tools/` — 7+ passed
- [ ] Commit: `feat(tools): home page with FX converter and tool entries`

---

## Task D6：i18n 增量（36 个新 key）

**Files:**
- Modify: `app/lib/l10n/app_en.arb`
- Modify: `app/lib/l10n/app_zh.arb`
- Create: `app/test/i18n/stage2_l10n_test.dart`

### 36 个 key 全部列出

```json
{
  "prepareTitle": "Prepare",
  "prepareSectionPolicies": "What you need to know",
  "prepareSectionChecklist": "Pre-arrival checklist",
  "prepareSectionDownloads": "Offline downloads",
  "prepareNoPolicies": "No policy info for {country} yet",
  "prepareDownloadToast": "Download will start soon",
  "prepareOfflineShanghai": "Shanghai core pack",
  "prepareOfflineShanghaiDesc": "12 MB · maps + phrases + emergency",
  "prepareChecklistPassport": "Passport valid 6+ months",
  "prepareChecklistCash": "Cash on hand (¥2000+)",
  "prepareChecklistEmergency": "Emergency contacts saved",
  "prepareChecklistOffline": "Offline pack downloaded",

  "mapTitle": "Map",
  "mapSearchHint": "Search attractions",
  "mapCategoryAll": "All",
  "mapCategoryAttraction": "Sights",
  "mapCategoryDining": "Eat",
  "mapCategoryLodging": "Stay",
  "mapCategoryShopping": "Shop",
  "mapEmpty": "No results in this area",
  "mapDistanceAway": "{km} km away",

  "discoverTitle": "Discover",
  "discoverTabCurated": "Curated",
  "discoverTabAuthentic": "Authentic",
  "discoverTabHeadsUp": "Heads-up",
  "discoverEmpty": "Nothing here yet",

  "toolsTitle": "Tools",
  "toolsFxTitle": "Live currency",
  "toolsFxFrom": "From",
  "toolsFxTo": "To",
  "toolsFxAmount": "Amount",
  "toolsFxRate": "1 {from} = {rate} {to}",
  "toolsAllTools": "All tools",
  "toolsComingSoon": "{tool} is coming soon",
  "toolsToolPhrases": "Phrase book",
  "toolsToolEmergency": "Emergency contacts",
  "toolsToolUnits": "Unit converter",
  "toolsToolTimezone": "Time zone",
  "toolsToolOffline": "Offline pack",
  "toolsToolTranslate": "Translate assistant"
}
```

中文版：每 key 对应中文翻译（plan 详细列出）。**en 必填，zh 必填**。

### 验收

- [ ] `flutter gen-l10n` 成功
- [ ] `flutter test test/i18n/stage2_l10n_test.dart` — 2 passed（en + zh 完整 36 个）
- [ ] Commit: `feat(i18n): 36 prepare/map/discover/tools keys`

---

## Task D7：路由 + DI 注入

**Files:**
- Modify: `app/lib/core/di/injection.config.dart`（手动补 10 个注册）
- Create: `app/test/router/stage2_routes_test.dart`

### 手动补 10 个注册到 injection.config.dart

```dart
// 在 init 方法中追加
gh.lazySingleton<PolicyRepository>(() => PolicyRepositoryImpl(getIt<DioClient>()));
gh.lazySingleton<ChecklistRepository>(() => ChecklistRepositoryImpl(getIt<DioClient>()));
gh.lazySingleton<PoiRepository>(() => PoiRepositoryImpl(getIt<DioClient>()));
gh.lazySingleton<DiscoverRepository>(() => DiscoverRepositoryImpl(getIt<DioClient>()));
gh.lazySingleton<FxRepository>(() => FxRepositoryImpl(getIt<DioClient>()));
gh.factory<PrepareHomeCubit>(() => PrepareHomeCubit(getIt<PolicyRepository>(), getIt<ChecklistRepository>()));
gh.factory<MapHomeCubit>(() => MapHomeCubit(getIt<PoiRepository>()));
gh.factory<DiscoverHomeCubit>(() => DiscoverHomeCubit(getIt<DiscoverRepository>()));
gh.factory<ToolsHomeCubit>(() => ToolsHomeCubit());
gh.factory<FxConverterCubit>(() => FxConverterCubit(getIt<FxRepository>()));
```

> ToolsHomeCubit（如果不需要 repo，可为空）。

### 验收

- [ ] `dart analyze` — 0 issues
- [ ] `flutter test test/router/stage2_routes_test.dart` — 4 passed（每个 tab 路由可达）
- [ ] Commit: `feat(di): register 10 stage 2 repositories and cubits`

---

## 最终验收

| # | 命令 | 期望 |
| :--- | :--- | :--- |
| 1 | `cd app && dart analyze` | `No issues found!` |
| 2 | `cd app && flutter test` | **100+ passed**（Stage 1 67 + Stage 2 40+） |
| 3 | `git log --oneline \| head -10` | 32 commits（spec/plan/Stage 1×3 sub-spec/Stage 2×7） |
| 4 | 模拟器：App → onboarding → 完成 → 4 tab 都渲染 | 看到 Prepare / Map / Discover / Tools 真实 UI |
| 5 | 真实 widget 验证：appRouter 5 tab | 全部可点击，骨架屏 + empty state 显示 |
