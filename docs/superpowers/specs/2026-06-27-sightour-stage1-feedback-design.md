# Sightour Spec C — 反馈入口设计

> **类型**：阶段一子 spec C
> **范围**：通用反馈/建议入口（替代原计划的「纠错 + 招募」）
> **依赖**：Spec A（基础设施）+ Spec B（Onboarding）
> **版本**：v1.0 — 2026-06-27

---

## 0. 范围

- ✅ Profile tab 添加「Send feedback」入口
- ✅ 反馈表单页：类型（bug / 内容错 / 建议 / 其他）+ 描述（多行）+ 可选邮箱（阶段三做，本阶段不显示）
- ✅ 提交调用 `POST /corrections`（Mock 拦截器已就绪）
- ✅ 提交成功 toast + 返回 Profile
- ✅ 提交失败：保留输入 + 重试按钮
- ❌ 招募入口（暂不需要，按用户决策）
- ❌ 图片上传（阶段三）
- ❌ 位置权限（阶段三）
- ❌ 反馈历史记录（阶段三）

---

## 1. 路由改动

在 `app/lib/core/router/app_router.dart` 现有的 `/you` 路由内增加子路由：

```dart
GoRoute(
  path: '/you',
  name: RouteNames.you,
  builder: (_, __) => const YouPage(),
  routes: <RouteBase>[
    GoRoute(
      path: 'feedback',
      name: RouteNames.feedback,
      builder: (_, __) => const FeedbackFormPage(),
    ),
  ],
),
```

`RouteNames.feedback` 加到 `route_names.dart`。

`/you/feedback` 是模态全屏页（`fullscreenDialog: true`），从 Profile 推入。

---

## 2. 目录结构

```
app/lib/features/
├── you/                                          # 新建模块
│   ├── domain/
│   │   ├── entities/
│   │   │   ├── feedback_type.dart                # 4 种类型 enum
│   │   │   └── feedback_submission.dart
│   │   └── repositories/
│   │       └── feedback_repository.dart
│   ├── data/
│   │   └── repositories/
│   │       └── feedback_repository_impl.dart
│   └── presentation/
│       ├── pages/
│       │   ├── you_page.dart                     # 改造（从占位变实页）
│       │   └── feedback_form_page.dart
│       ├── cubit/
│       │   └── feedback_form_cubit.dart
│       └── widgets/
│           ├── profile_section.dart
│           └── feedback_type_chip.dart
```

---

## 3. 领域层

### 3.1 `FeedbackType`

```dart
enum FeedbackType {
  bug('bug', 'Bug report', '应用问题'),
  contentError('content_error', 'Wrong information', '内容错误'),
  suggestion('suggestion', 'Suggestion', '建议'),
  other('other', 'Other', '其他');

  const FeedbackType(this.id, this.labelEn, this.labelZh);
  final String id;
  final String labelEn;
  final String labelZh;
}
```

### 3.2 `FeedbackSubmission`（DTO）

```dart
class FeedbackSubmission {
  const FeedbackSubmission({
    required this.type,
    required this.message,
    required this.anonymousId,
  });
  final FeedbackType type;
  final String message;
  final String anonymousId; // 来自 AnonymousId.get()

  Map<String, dynamic> toJson() => {
        'type': type.id,
        'message': message,
        'anonymousId': anonymousId,
      };
}
```

### 3.3 `FeedbackRepository`

```dart
abstract class FeedbackRepository {
  Future<void> submit(FeedbackSubmission submission);
}
```

### 3.4 `FeedbackRepositoryImpl`（调用 Dio → POST /corrections）

```dart
@LazySingleton(as: FeedbackRepository)
class FeedbackRepositoryImpl implements FeedbackRepository {
  final DioClient _dioClient;
  FeedbackRepositoryImpl(this._dioClient);

  @override
  Future<void> submit(FeedbackSubmission submission) async {
    await _dioClient.dio.post(
      '/corrections',
      data: submission.toJson(),
    );
    // Mock 拦截器返回 emptyData
    // 错误由 ErrorInterceptor 转换为 Failure 抛出
  }
}
```

`DioClient` 已在 Spec A 实现。`@LazySingleton` 需在 `injection.config.dart` 注册 `FeedbackRepository` + `FeedbackRepositoryImpl`。若 build_runner 中文路径 AOT 失败（Spec B 时遇到过），手动补注册。

---

## 4. 表现层

### 4.1 `FeedbackFormCubit`

```dart
class FeedbackFormState {
  const FeedbackFormState({
    this.type = FeedbackType.bug,
    this.message = '',
    this.isSubmitting = false,
    this.errorMessage,
    this.submittedSuccessfully = false,
  });
  final FeedbackType type;
  final String message;
  final bool isSubmitting;
  final String? errorMessage;
  final bool submittedSuccessfully;

  bool get canSubmit => message.trim().length >= 10 && !isSubmitting;

  FeedbackFormState copyWith({...}) => ...;
}

@injectable
class FeedbackFormCubit extends Cubit<FeedbackFormState> {
  FeedbackFormCubit(this._repo) : super(const FeedbackFormState());
  final FeedbackRepository _repo;

  void setType(FeedbackType t) => emit(state.copyWith(type: t));
  void setMessage(String m) => emit(state.copyWith(message: m));

  Future<void> submit() async {
    if (!state.canSubmit) return;
    emit(state.copyWith(isSubmitting: true, errorMessage: null));
    try {
      final sub = FeedbackSubmission(
        type: state.type,
        message: state.message.trim(),
        anonymousId: AnonymousId.get(),
      );
      await _repo.submit(sub);
      emit(state.copyWith(isSubmitting: false, submittedSuccessfully: true));
    } on Failure catch (e) {
      emit(state.copyWith(isSubmitting: false, errorMessage: e.toString()));
    } catch (e) {
      emit(state.copyWith(isSubmitting: false, errorMessage: 'Unexpected error: $e'));
    }
  }
}
```

### 4.2 `FeedbackFormPage`

`StatefulWidget` + `BlocConsumer<FeedbackFormCubit, FeedbackFormState>`：

- 顶部 `AppBar`：标题 = `AppLocalizations.of(context)!.feedbackTitle` + 关闭按钮
- 类型选择：4 个 `ChoiceChip`（bug / 内容错 / 建议 / 其他）
- 描述输入：`TextField` `maxLines: 6` `minLines: 4`，placeholder = `feedbackMessageHint`
- 字符计数：右下角「$n / 500」，`maxLength: 500`
- 错误状态：底部红色 banner + Retry 按钮
- 提交按钮：底部固定，`state.canSubmit` 时启用，否则 disabled
- 成功：监听 `submittedSuccessfully` → `ScaffoldMessenger.showSnackBar` + `context.go('/you')`

### 4.3 `YouPage`（从占位改实页）

`StatelessWidget` 含 3 个区块：
1. **Profile section**：显示 anonymousId 前 12 位 + 母国（来自 FirstRunSettingsCubit，optional）
2. **Preferences section**：跳转 `/you/preferences`（阶段二做，本阶段显示「Coming soon」）
3. **Feedback section**：单行点击 → `context.push('/you/feedback')`

样式：每行 = `ListTile` + `Icons.feedback_outlined` + 标题 + `Icons.chevron_right`。

---

## 5. i18n 增量（8 个新 key）

```json
{
  "youTitle": "You",
  "youProfileAnonymousId": "Device ID",
  "youPreferences": "Preferences",
  "youFeedback": "Send feedback",
  "youPreferencesComingSoon": "Preferences (coming soon)",

  "feedbackTitle": "Send feedback",
  "feedbackTypeLabel": "What is this about?",
  "feedbackMessageLabel": "Tell us more",
  "feedbackMessageHint": "Share what happened, or what you'd like to see. (min 10 chars)",
  "feedbackSubmit": "Send",
  "feedbackSubmitting": "Sending…",
  "feedbackSuccess": "Thanks! We received your feedback.",
  "feedbackErrorTitle": "Could not send",
  "feedbackRetry": "Try again"
}
```

中文版（同步翻译）：
- `youTitle`: "我的"
- `youProfileAnonymousId`: "设备 ID"
- `youPreferences`: "偏好设置"
- `youFeedback`: "发送反馈"
- `youPreferencesComingSoon`: "偏好设置（敬请期待）"
- `feedbackTitle`: "发送反馈"
- `feedbackTypeLabel`: "这是什么类型？"
- `feedbackMessageLabel`: "详细说明"
- `feedbackMessageHint`: "告诉我们发生了什么，或你想看到什么。（最少 10 字）"
- `feedbackSubmit`: "发送"
- `feedbackSubmitting`: "发送中…"
- `feedbackSuccess`: "感谢！我们已收到你的反馈。"
- `feedbackErrorTitle`: "发送失败"
- `feedbackRetry`: "重试"

共 14 个新 key。

---

## 6. 依赖注入

`injection.config.dart`（或 `feedback_repository_impl.dart`）注册：

- `FeedbackRepository`（实现 `FeedbackRepositoryImpl`，由 `DioClient` 注入）
- `FeedbackFormCubit`（由 `FeedbackRepository` 注入）

Spec B 时 build_runner 中文路径 AOT 失败 → 手动补注册。**继续按手动补**。

---

## 7. 测试

- `test/feedback/feedback_repository_test.dart`：`submit` 调用 Dio → POST /corrections
- `test/feedback/feedback_form_cubit_test.dart`：setType / setMessage / submit 成功 / submit 失败 / canSubmit 边界（message 长度 < 10）
- `test/feedback/feedback_form_page_test.dart`：类型 chip 切换、字符计数、提交按钮 enable/disable
- `test/you/you_page_test.dart`：YouPage 渲染 3 个 section
- `test/router/you_feedback_route_test.dart`：`/you/feedback` 路由可访问

---

## 8. 范围外

- ❌ 招募入口
- ❌ 反馈历史
- ❌ 图片上传
- ❌ 位置权限
- ❌ 邮箱字段（阶段三）
- ❌ 反馈管理后台

---

## 9. 风险

| 风险 | 缓解 |
| --- | --- |
| Mock 拦截器目前对所有 endpoint 返回空 data，POST /corrections 也返回空 | Spec A 已就绪，本阶段无影响 |
| 错误提示文案不友好 | Failure 类型已分层（network / server / unknown），错误信息可读 |
| 用户在弱网下提交失败 | 表单内容保留在 Cubit state（不重置），可重试 |
| Dio 调用未等待 | `submit()` 用 `await`，UI 用 isSubmitting 锁按钮 |

---

## 10. 提交策略

```
feat(feedback): add domain entity, repository, and cubit
feat(i18n): add 14 you + feedback keys
feat(you): replace placeholder YouPage with real profile + feedback entry
feat(feedback): add FeedbackFormPage with type chips and submit
feat(router): add /you/feedback modal route
test(feedback): add 5 test files
```

---

## 11. 自我审查

- [x] 无 TBD / TODO 留空
- [x] 范围聚焦：仅反馈入口
- [x] 命名一致：FeedbackType / FeedbackSubmission / FeedbackRepository
- [x] 与 Spec A 衔接：复用 DioClient + Mock 拦截器
- [x] 与 Spec B 衔接：复用 AnonymousId + Hive prefs
- [x] 测试覆盖：5 个测试文件
- [x] 范围外明确列出

---

## 附录 A · 关联文档

- [阶段一基础设施 Spec A](file:///c:/Users/wenmo/.trae-cn/worktrees/旅游app/docs/superpowers/specs/2026-06-27-sightour-stage1-foundation-design.md)
- [Spec B Onboarding](file:///c:/Users/wenmo/.trae-cn/worktrees/旅游app/docs/superpowers/specs/2026-06-27-sightour-stage1-onboarding-design.md)
- [前端架构规范](file:///c:/Users/wenmo/.trae-cn/worktrees/旅游app/docs/superpowers/specs/2026-06-26-sightour-frontend-architecture.md)
- [MVP Plan](file:///c:/Users/wenmo/.trae-cn/worktrees/旅游app/docs/superpowers/plans/2026-06-26-sightour-mvp.md) Task 13（纠错，现改为反馈）
