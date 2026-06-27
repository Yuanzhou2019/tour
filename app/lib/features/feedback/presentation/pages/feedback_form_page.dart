import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sightour/core/di/injection.dart';
import 'package:sightour/core/theme/app_colors.dart';
import 'package:sightour/core/theme/app_radius.dart';
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
    final l = AppLocalizations.of(context);
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