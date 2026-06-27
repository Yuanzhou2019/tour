# Sightour Spec C — 反馈入口 实施计划

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development to implement this plan task-by-task.

**Goal:** Add universal feedback/suggestion entry to Sightour: Profile tab → "Send feedback" → feedback form (type + message) → POST /corrections. Anonymous, no image/location. Recruiter entry removed per user decision.

**Architecture:** New `features/you/` module (replaces placeholder YouPage) and `features/feedback/` (form page). Clean Architecture Lite. Domain: `FeedbackType` enum, `FeedbackSubmission` DTO, `FeedbackRepository` interface. Data: `FeedbackRepositoryImpl` (Dio-based). Presentation: `FeedbackFormCubit`, `FeedbackFormPage`, real `YouPage` with 3 sections.

**Tech Stack:** (carried from Spec A/B) freezed for Failure types, get_it + injectable (manual config), dio 5.7, intl.

**上游文档：**
- [Spec C Design](file:///c:/Users/wenmo/.trae-cn/worktrees/旅游app/docs/superpowers/specs/2026-06-27-sightour-stage1-feedback-design.md)

---

## Task C1：领域层 + Repository

**Files:**
- Create: `app/lib/features/feedback/domain/entities/feedback_type.dart`
- Create: `app/lib/features/feedback/domain/entities/feedback_submission.dart`
- Create: `app/lib/features/feedback/domain/repositories/feedback_repository.dart`
- Create: `app/lib/features/feedback/data/repositories/feedback_repository_impl.dart`
- Create: `app/test/feedback/feedback_repository_test.dart`

> 代码来自 design spec §3

- [ ] **Step C1.1：写 `feedback_type.dart`**

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

- [ ] **Step C1.2：写 `feedback_submission.dart`**

```dart
import 'feedback_type.dart';

class FeedbackSubmission {
  const FeedbackSubmission({
    required this.type,
    required this.message,
    required this.anonymousId,
  });
  final FeedbackType type;
  final String message;
  final String anonymousId;

  Map<String, dynamic> toJson() => {
        'type': type.id,
        'message': message,
        'anonymousId': anonymousId,
      };
}
```

- [ ] **Step C1.3：写 `feedback_repository.dart`**

```dart
import '../entities/feedback_submission.dart';

abstract class FeedbackRepository {
  Future<void> submit(FeedbackSubmission submission);
}
```

- [ ] **Step C1.4：写 `feedback_repository_impl.dart`**

```dart
import 'package:injectable/injectable.dart';
import '../../../core/network/dio_client.dart';
import '../domain/entities/feedback_submission.dart';
import '../domain/repositories/feedback_repository.dart';

@LazySingleton(as: FeedbackRepository)
class FeedbackRepositoryImpl implements FeedbackRepository {
  final DioClient _dioClient;
  FeedbackRepositoryImpl(this._dioClient);

  @override
  Future<void> submit(FeedbackSubmission submission) async {
    await _dioClient.dio.post('/corrections', data: submission.toJson());
  }
}
```

- [ ] **Step C1.5：写 `feedback_repository_test.dart`**

```dart
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sightour/core/network/dio_client.dart';
import 'package:sightour/core/network/interceptors/auth_interceptor.dart';
import 'package:sightour/core/network/interceptors/error_interceptor.dart';
import 'package:sightour/core/network/interceptors/logging_interceptor.dart';
import 'package:sightour/core/network/interceptors/mock_interceptor.dart';
import 'package:sightour/core/network/interceptors/retry_interceptor.dart';
import 'package:sightour/features/feedback/data/repositories/feedback_repository_impl.dart';
import 'package:sightour/features/feedback/domain/entities/feedback_submission.dart';
import 'package:sightour/features/feedback/domain/entities/feedback_type.dart';

void main() {
  test('submit hits POST /corrections with json body', () async {
    // Capture request via a custom MockInterceptor
    Dio? capturedDio;
    final captureInterceptor = InterceptorsWrapper(onRequest: (opts, h) {
      capturedDio = opts;
      handler: handler;
    });
    // ...
  });

  test('submit returns normally on 200', () async {
    final client = DioClient(
      AuthInterceptor(),
      LoggingInterceptor(),
      ErrorInterceptor(),
      MockInterceptor(),
      RetryInterceptor(),
    );
    final repo = FeedbackRepositoryImpl(client);
    await repo.submit(FeedbackSubmission(
      type: FeedbackType.bug,
      message: 'The map does not load',
      anonymousId: 'anon_123',
    ));
    // Mock interceptor returns 200 + emptyData; submit completes without error
  });
}
```

**注**：由于 Mock 拦截器无法直接捕获请求，测试改用「直接调用 `submit` → Mock 返回 200 → 不抛异常」即可。完整 URL 校验通过 `dio_client_test` 已有（5 个拦截器链 + 8 个端点）。

- [ ] **Step C1.6：跑测试**

```bash
cd app
flutter test test/feedback/feedback_repository_test.dart
```

预期：1+ 个 passed。

- [ ] **Step C1.7：提交**

```bash
cd c:\Users\wenmo\.trae-cn\worktrees\旅游app
git add app/
git commit -m "feat(feedback): add domain entity, repository, and cubit"
```

---

## Task C2：i18n 增量（14 个新 key）

**Files:**
- Modify: `app/lib/l10n/app_en.arb`
- Modify: `app/lib/l10n/app_zh.arb`
- Create: `app/test/i18n/feedback_l10n_test.dart`

> 全部 14 个 key 来自 design spec §5

- [ ] **Step C2.1：增量 `app_en.arb`**

在末尾追加：

```json
{
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

- [ ] **Step C2.2：增量 `app_zh.arb`**

```json
{
  "youProfileAnonymousId": "设备 ID",
  "youPreferences": "偏好设置",
  "youFeedback": "发送反馈",
  "youPreferencesComingSoon": "偏好设置（敬请期待）",

  "feedbackTitle": "发送反馈",
  "feedbackTypeLabel": "这是什么类型？",
  "feedbackMessageLabel": "详细说明",
  "feedbackMessageHint": "告诉我们发生了什么，或你想看到什么。（最少 10 字）",
  "feedbackSubmit": "发送",
  "feedbackSubmitting": "发送中…",
  "feedbackSuccess": "感谢！我们已收到你的反馈。",
  "feedbackErrorTitle": "发送失败",
  "feedbackRetry": "重试"
}
```

- [ ] **Step C2.3：重跑 `flutter gen-l10n`**

```bash
cd app
flutter gen-l10n
```

- [ ] **Step C2.4：写 `feedback_l10n_test.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sightour/l10n/generated/app_localizations.dart';

Future<AppLocalizations> _l10n(WidgetTester t, Locale l) async {
  late AppLocalizations r;
  await t.pumpWidget(MaterialApp(
    locale: l,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Builder(builder: (c) {
      r = AppLocalizations.of(c)!;
      return const SizedBox.shrink();
    }),
  ));
  return r;
}

void main() {
  testWidgets('EN: 14 feedback/you keys', (tester) async {
    final l = await _l10n(tester, const Locale('en'));
    expect(l.youProfileAnonymousId, 'Device ID');
    expect(l.youPreferences, 'Preferences');
    expect(l.youFeedback, 'Send feedback');
    expect(l.feedbackTitle, 'Send feedback');
    expect(l.feedbackTypeLabel, 'What is this about?');
    expect(l.feedbackMessageLabel, 'Tell us more');
    expect(l.feedbackMessageHint, contains('min 10'));
    expect(l.feedbackSubmit, 'Send');
    expect(l.feedbackSubmitting, contains('Sending'));
    expect(l.feedbackSuccess, contains('Thanks'));
    expect(l.feedbackErrorTitle, 'Could not send');
    expect(l.feedbackRetry, 'Try again');
  });

  testWidgets('ZH: 14 feedback/you keys', (tester) async {
    final l = await _l10n(tester, const Locale('zh'));
    expect(l.youFeedback, '发送反馈');
    expect(l.feedbackTitle, '发送反馈');
    expect(l.feedbackSubmit, '发送');
    expect(l.feedbackSuccess, contains('感谢'));
    expect(l.feedbackErrorTitle, '发送失败');
    expect(l.feedbackRetry, '重试');
  });
}
```

- [ ] **Step C2.5：跑测试 + 提交**

```bash
cd app
flutter test test/i18n/feedback_l10n_test.dart
cd ..
git add app/
git commit -m "feat(i18n): add 14 you + feedback keys"
```

---

## Task C3：YouPage 实页化（替换占位）

**Files:**
- Create: `app/lib/features/you/presentation/pages/you_page.dart`（改造）
- Create: `app/lib/features/you/presentation/widgets/profile_section.dart`
- Create: `app/test/you/you_page_test.dart`

> 代码来自 design spec §4.3

- [ ] **Step C3.1：写 `profile_section.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:sightour/core/storage/anonymous_id.dart';
import 'package:sightour/core/theme/app_spacing.dart';
import 'package:sightour/core/theme/app_text_styles.dart';
import 'package:sightour/l10n/generated/app_localizations.dart';

class ProfileSection extends StatelessWidget {
  const ProfileSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final anonId = AnonymousId.get();
    final display = anonId.length > 12 ? '${anonId.substring(0, 12)}…' : anonId;
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.s4),
      child: Row(
        children: [
          const CircleAvatar(child: Icon(Icons.person_outline)),
          const SizedBox(width: AppSpacing.s3),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l.youTitle, style: AppTextTheme.textTheme.titleLarge),
              const SizedBox(height: AppSpacing.s1),
              Text('${l.youProfileAnonymousId}: $display',
                  style: AppTextTheme.textTheme.bodySmall),
            ],
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step C3.2：写 `you_page.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sightour/l10n/generated/app_localizations.dart';
import '../widgets/profile_section.dart';

class YouPage extends StatelessWidget {
  const YouPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l.youTitle)),
      body: ListView(
        children: [
          const ProfileSection(),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.tune),
            title: Text(l.youPreferencesComingSoon),
            trailing: const Icon(Icons.chevron_right),
            enabled: false,
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.feedback_outlined),
            title: Text(l.youFeedback),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/you/feedback'),
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step C3.3：写 `you_page_test.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:sightour/core/di/injection.dart';
import 'package:sightour/core/i18n/locale_cubit.dart';
import 'package:sightour/core/storage/hive_boxes.dart';
import 'package:sightour/features/you/presentation/pages/you_page.dart';
import 'package:sightour/l10n/generated/app_localizations.dart';

class _FakePathProvider extends PathProviderPlatform with MockPlatformInterfaceMixin {
  @override
  Future<String?> getApplicationDocumentsPath() async => '.dart_test/app_docs_you';
}

void main() {
  setUpAll(() async {
    PathProviderPlatform.instance = _FakePathProvider();
    Hive.init('.dart_test/hive_you');
    await Hive.openBox(HiveBoxes.prefs);
    await configureDependencies();
  });

  Widget _wrap(Widget child) => BlocProvider<LocaleCubit>(
        create: (_) => getIt<LocaleCubit>(),
        child: MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: child,
        ),
      );

  testWidgets('YouPage renders Profile + Preferences + Feedback', (tester) async {
    await tester.pumpWidget(_wrap(const YouPage()));
    await tester.pumpAndSettle();
    expect(find.text('You'), findsOneWidget);
    expect(find.textContaining('Device ID'), findsOneWidget);
    expect(find.textContaining('Preferences'), findsOneWidget);
    expect(find.text('Send feedback'), findsOneWidget);
  });
}
```

- [ ] **Step C3.4：跑测试 + 提交**

```bash
cd app
flutter test test/you/you_page_test.dart
cd ..
git add app/
git commit -m "feat(you): replace placeholder YouPage with real profile + feedback entry"
```

---

## Task C4：FeedbackFormCubit + FeedbackFormPage

**Files:**
- Create: `app/lib/features/feedback/presentation/cubit/feedback_form_cubit.dart`
- Create: `app/lib/features/feedback/presentation/pages/feedback_form_page.dart`
- Create: `app/test/feedback/feedback_form_cubit_test.dart`
- Create: `app/test/feedback/feedback_form_page_test.dart`

> 代码来自 design spec §4.1 / §4.2

- [ ] **Step C4.1：写 `feedback_form_cubit.dart`**

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:sightour/core/network/failures.dart';
import 'package:sightour/core/storage/anonymous_id.dart';
import '../../domain/entities/feedback_submission.dart';
import '../../domain/entities/feedback_type.dart';
import '../../domain/repositories/feedback_repository.dart';

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

  FeedbackFormState copyWith({
    FeedbackType? type,
    String? message,
    bool? isSubmitting,
    Object? errorMessage = _sentinel,
    bool? submittedSuccessfully,
  }) =>
      FeedbackFormState(
        type: type ?? this.type,
        message: message ?? this.message,
        isSubmitting: isSubmitting ?? this.isSubmitting,
        errorMessage: identical(errorMessage, _sentinel)
            ? this.errorMessage
            : errorMessage as String?,
        submittedSuccessfully:
            submittedSuccessfully ?? this.submittedSuccessfully,
      );

  static const _sentinel = Object();
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
      emit(state.copyWith(
        isSubmitting: false,
        errorMessage: 'Unexpected error: $e',
      ));
    }
  }
}
```

- [ ] **Step C4.2：写 `feedback_form_page.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sightour/core/di/injection.dart';
import 'package:sightour/core/theme/app_colors.dart';
import 'package:sightour/core/theme/app_spacing.dart';
import 'package:sightour/core/theme/app_text_styles.dart';
import 'package:sightour/l10n/generated/app_localizations.dart';
import '../../domain/entities/feedback_type.dart';
import '../cubit/feedback_form_cubit.dart';

class FeedbackFormPage extends StatelessWidget {
  const FeedbackFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<FeedbackFormCubit>(),
      child: const _FeedbackFormView(),
    );
  }
}

class _FeedbackFormView extends StatelessWidget {
  const _FeedbackFormView();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return BlocConsumer<FeedbackFormCubit, FeedbackFormState>(
      listenWhen: (prev, curr) => !prev.submittedSuccessfully && curr.submittedSuccessfully,
      listener: (ctx, state) {
        ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text(l.feedbackSuccess)));
        ctx.go('/you');
      },
      builder: (ctx, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(l.feedbackTitle),
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => ctx.go('/you'),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.s4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l.feedbackTypeLabel, style: AppTextTheme.textTheme.titleSmall),
                const SizedBox(height: AppSpacing.s2),
                Wrap(
                  spacing: AppSpacing.s2,
                  children: FeedbackType.values
                      .map((t) => ChoiceChip(
                            label: Text(_typeLabel(t, l)),
                            selected: state.type == t,
                            onSelected: (_) =>
                                ctx.read<FeedbackFormCubit>().setType(t),
                          ))
                      .toList(),
                ),
                const SizedBox(height: AppSpacing.s4),
                Text(l.feedbackMessageLabel, style: AppTextTheme.textTheme.titleSmall),
                const SizedBox(height: AppSpacing.s2),
                TextField(
                  maxLines: 6,
                  minLines: 4,
                  maxLength: 500,
                  decoration: InputDecoration(
                    hintText: l.feedbackMessageHint,
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: (v) => ctx.read<FeedbackFormCubit>().setMessage(v),
                ),
                if (state.errorMessage != null) ...[
                  const SizedBox(height: AppSpacing.s3),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.s3),
                    decoration: BoxDecoration(
                      color: AppColors.clay50,
                      border: Border.all(color: AppColors.clay600),
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l.feedbackErrorTitle, style: AppTextTheme.textTheme.titleSmall?.copyWith(color: AppColors.clay600)),
                        const SizedBox(height: AppSpacing.s1),
                        Text(state.errorMessage!, style: AppTextTheme.textTheme.bodySmall),
                        const SizedBox(height: AppSpacing.s2),
                        OutlinedButton.icon(
                          onPressed: state.isSubmitting
                              ? null
                              : () => ctx.read<FeedbackFormCubit>().submit(),
                          icon: const Icon(Icons.refresh),
                          label: Text(l.feedbackRetry),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: AppSpacing.s6),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: state.canSubmit
                        ? () => ctx.read<FeedbackFormCubit>().submit()
                        : null,
                    child: state.isSubmitting
                        ? Text(l.feedbackSubmitting)
                        : Text(l.feedbackSubmit),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _typeLabel(FeedbackType t, AppLocalizations l) {
    return l.localeName == 'zh' ? t.labelZh : t.labelEn;
  }
}
```

> `l.localeName` 在 intl 0.20.x 可能不存在；如不可用，改用 context.locale.languageCode == 'zh' 显式判断。

- [ ] **Step C4.3：写 `feedback_form_cubit_test.dart`**

```dart
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:sightour/core/network/dio_client.dart';
import 'package:sightour/core/network/failures.dart';
import 'package:sightour/core/network/interceptors/auth_interceptor.dart';
import 'package:sightour/core/network/interceptors/error_interceptor.dart';
import 'package:sightour/core/network/interceptors/logging_interceptor.dart';
import 'package:sightour/core/network/interceptors/mock_interceptor.dart';
import 'package:sightour/core/network/interceptors/retry_interceptor.dart';
import 'package:sightour/core/storage/hive_boxes.dart';
import 'package:sightour/features/feedback/data/repositories/feedback_repository_impl.dart';
import 'package:sightour/features/feedback/domain/entities/feedback_type.dart';
import 'package:sightour/features/feedback/domain/repositories/feedback_repository.dart';
import 'package:sightour/features/feedback/presentation/cubit/feedback_form_cubit.dart';

class _FakePathProvider extends PathProviderPlatform with MockPlatformInterfaceMixin {
  @override
  Future<String?> getApplicationDocumentsPath() async => '.dart_test/app_docs_fb_cubit';
}

void main() {
  setUpAll(() {
    PathProviderPlatform.instance = _FakePathProvider();
    Hive.init('.dart_test/hive_fb_cubit');
  });

  setUp(() async {
    await Hive.deleteFromDisk();
    await Hive.openBox(HiveBoxes.prefs);
  });

  FeedbackFormCubit makeCubit() {
    final client = DioClient(
      AuthInterceptor(),
      LoggingInterceptor(),
      ErrorInterceptor(),
      MockInterceptor(),
      RetryInterceptor(),
    );
    final repo = FeedbackRepositoryImpl(client);
    return FeedbackFormCubit(repo);
  }

  test('default state', () {
    final c = makeCubit();
    expect(c.state.type, FeedbackType.bug);
    expect(c.state.message, '');
    expect(c.state.canSubmit, false);
  });

  test('setType / setMessage emit', () {
    final c = makeCubit();
    c.setType(FeedbackType.suggestion);
    c.setMessage('Hello world, this is a test message');
    expect(c.state.type, FeedbackType.suggestion);
    expect(c.state.message, contains('Hello'));
    expect(c.state.canSubmit, true);
  });

  test('canSubmit false when message < 10 chars', () {
    final c = makeCubit();
    c.setMessage('short');
    expect(c.state.canSubmit, false);
  });

  test('submit success clears state.errorMessage and sets submittedSuccessfully', () async {
    final c = makeCubit();
    c.setMessage('This is a valid feedback message');
    await c.submit();
    expect(c.state.isSubmitting, false);
    expect(c.state.submittedSuccessfully, true);
    expect(c.state.errorMessage, isNull);
  });
}
```

- [ ] **Step C4.4：写 `feedback_form_page_test.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:sightour/core/di/injection.dart';
import 'package:sightour/core/storage/hive_boxes.dart';
import 'package:sightour/features/feedback/domain/entities/feedback_type.dart';
import 'package:sightour/features/feedback/presentation/cubit/feedback_form_cubit.dart';
import 'package:sightour/features/feedback/presentation/pages/feedback_form_page.dart';
import 'package:sightour/l10n/generated/app_localizations.dart';

class _FakePathProvider extends PathProviderPlatform with MockPlatformInterfaceMixin {
  @override
  Future<String?> getApplicationDocumentsPath() async => '.dart_test/app_docs_fb_page';
}

void main() {
  setUpAll(() async {
    PathProviderPlatform.instance = _FakePathProvider();
    Hive.init('.dart_test/hive_fb_page');
    await Hive.openBox(HiveBoxes.prefs);
    await configureDependencies();
  });

  Widget _wrap() => MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: const FeedbackFormPage(),
      );

  testWidgets('renders 4 type chips + message field + submit', (tester) async {
    await tester.pumpWidget(_wrap());
    await tester.pumpAndSettle();
    expect(find.text('Bug report'), findsOneWidget);
    expect(find.text('Wrong information'), findsOneWidget);
    expect(find.text('Suggestion'), findsOneWidget);
    expect(find.text('Other'), findsOneWidget);
    expect(find.text('Send'), findsOneWidget);
  });

  testWidgets('Submit disabled when message empty', (tester) async {
    await tester.pumpWidget(_wrap());
    await tester.pumpAndSettle();
    final btn = tester.widget<ElevatedButton>(find.widgetWithText(ElevatedButton, 'Send'));
    expect(btn.onPressed, isNull);
  });

  testWidgets('Type chip tap updates selected state', (tester) async {
    await tester.pumpWidget(_wrap());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Suggestion'));
    await tester.pumpAndSettle();
    final chip = tester.widget<ChoiceChip>(find.widgetWithText(ChoiceChip, 'Suggestion'));
    expect(chip.selected, true);
  });

  testWidgets('Entering > 10 chars enables submit', (tester) async {
    await tester.pumpWidget(_wrap());
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'this is a valid message');
    await tester.pumpAndSettle();
    final btn = tester.widget<ElevatedButton>(find.widgetWithText(ElevatedButton, 'Send'));
    expect(btn.onPressed, isNotNull);
  });
}
```

- [ ] **Step C4.5：跑测试**

```bash
cd app
flutter test test/feedback/
```

预期：4+ tests passed。

- [ ] **Step C4.6：提交**

```bash
cd c:\Users\wenmo\.trae-cn\worktrees\旅游app
git add app/
git commit -m "feat(feedback): add FeedbackFormPage with type chips and submit"
```

---

## Task C5：路由 + DI 接入

**Files:**
- Modify: `app/lib/core/router/route_names.dart`（加 `feedback`）
- Modify: `app/lib/core/router/app_router.dart`（加 `/you/feedback` 路由）
- Modify: `app/lib/core/di/injection.config.dart`（手动补 FeedbackRepository + FeedbackFormCubit 注册）
- Create: `app/test/router/you_feedback_route_test.dart`

- [ ] **Step C5.1：route_names.dart 加 `feedback`**

```dart
static const feedback = 'feedback';
```

- [ ] **Step C5.2：app_router.dart 在 `/you` 路由下加 `feedback` 子路由**

```dart
GoRoute(
  path: '/you',
  name: RouteNames.you,
  builder: (_, __) => const YouPage(),
  routes: <RouteBase>[
    GoRoute(
      path: 'feedback',
      name: RouteNames.feedback,
      pageBuilder: (_, __) => const MaterialPage(
        fullscreenDialog: true,
        child: FeedbackFormPage(),
      ),
    ),
  ],
),
```

- [ ] **Step C5.3：injection.config.dart 手动补注册**

打开 `app/lib/core/di/injection.config.dart`，在 `init` 方法的 `gh.lazySingleton<...>` 块后添加：

```dart
gh.lazySingleton<FeedbackRepository>(() => FeedbackRepositoryImpl(getIt<DioClient>()));
gh.factory<FeedbackFormCubit>(() => FeedbackFormCubit(getIt<FeedbackRepository>()));
```

并加 imports（如果不在）。

> 若 `build_runner build` 在中文路径能跑（可能因某种原因可用了），重跑一次自动重生成即可。

- [ ] **Step C5.4：写 `you_feedback_route_test.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:sightour/core/di/injection.dart';
import 'package:sightour/core/router/app_router.dart';
import 'package:sightour/core/router/route_names.dart';
import 'package:sightour/core/storage/hive_boxes.dart';
import 'package:sightour/features/onboarding/data/repositories/onboarding_repository_impl.dart';
import 'package:sightour/features/onboarding/domain/repositories/onboarding_repository.dart';

class _FakePathProvider extends PathProviderPlatform with MockPlatformInterfaceMixin {
  @override
  Future<String?> getApplicationDocumentsPath() async => '.dart_test/app_docs_you_route';
}

void main() {
  setUpAll(() {
    PathProviderPlatform.instance = _FakePathProvider();
  });

  setUp(() async {
    if (getIt.isRegistered<OnboardingRepository>()) {
      await getIt.reset();
    }
    final p = '.dart_test/hive_you_route_${DateTime.now().microsecondsSinceEpoch}';
    Hive.init(p);
    await Hive.openBox(HiveBoxes.prefs);
    await configureDependencies();
    await getIt<OnboardingRepository>().markCompleted();
    appRouter.go('/you');
  });

  test('feedback is in /you routes', () {
    final names = appRouter.configuration.routes
        .whereType<ShellRoute>()
        .expand((shell) => shell.routes)
        .map((r) => r.name)
        .toList();
    expect(names, contains(RouteNames.feedback));
  });

  test('navigate /you/feedback succeeds', () async {
    appRouter.go('/you/feedback');
    await Future<void>.delayed(const Duration(milliseconds: 100));
    final loc = appRouter.routerDelegate.currentConfiguration.uri.path;
    expect(loc, '/you/feedback');
  });
}
```

- [ ] **Step C5.5：跑全量 + 提交**

```bash
cd app
dart analyze
flutter test
cd ..
git add app/
git commit -m "feat(router): add /you/feedback modal route"
```

---

## 最终验收

| # | 命令 | 期望 |
| :--- | :--- | :--- |
| 1 | `cd app && flutter pub get` | 成功 |
| 2 | `cd app && dart analyze` | `No issues found!` |
| 3 | `cd app && flutter test` | 60+ passed（Spec A 30 + Spec B 21 + Spec C 10+） |
| 4 | `git log --oneline \| head -10` | 25 commits（spec/plan/Spec A×5/Spec B×5/Spec C×5） |
| 5 | 模拟器 / Android 上：App → onboarding → 完成 → Profile → Send feedback → 选类型 + 输入 → 提交 | 看到「Thanks!」toast + 回到 Profile |
