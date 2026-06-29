import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sightour/core/di/injection.dart';
import 'package:sightour/core/theme/app_colors.dart';
import 'package:sightour/core/theme/app_radius.dart';
import 'package:sightour/core/theme/app_spacing.dart';
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
    return BlocConsumer<FeedbackFormCubit, FeedbackFormState>(
      listenWhen: (prev, curr) =>
          !prev.submittedSuccessfully && curr.submittedSuccessfully,
      listener: (ctx, state) {
        ScaffoldMessenger.of(ctx).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(ctx).feedbackSuccess),
            backgroundColor: AppColors.warmPrimary,
          ),
        );
        ctx.go('/you');
      },
      builder: (ctx, state) {
        final l10n = AppLocalizations.of(ctx);
        final locale = Localizations.localeOf(ctx);
        final isZh = locale.languageCode == 'zh';
        return Scaffold(
          backgroundColor: AppColors.warmSurface,
          appBar: AppBar(
            backgroundColor: AppColors.warmSurface,
            elevation: 0,
            title: Text(
              l10n.feedbackTitle,
              style: const TextStyle(
                color: AppColors.warmPrimaryDark,
                fontWeight: FontWeight.w700,
              ),
            ),
            iconTheme: const IconThemeData(color: AppColors.warmPrimaryDark),
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
                // ---- Type ----
                Row(
                  children: [
                    Container(
                      width: 3,
                      height: 14,
                      decoration: BoxDecoration(
                        color: AppColors.warmPrimary,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.s2),
                    Text(
                      l10n.feedbackTypeLabel,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.warmPrimaryDark,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.s3),
                Wrap(
                  spacing: AppSpacing.s2,
                  runSpacing: AppSpacing.s2,
                  children: FeedbackType.values
                      .map((t) => _FeedbackTypeChip(
                            label: isZh ? t.labelZh : t.labelEn,
                            selected: state.type == t,
                            onTap: () =>
                                ctx.read<FeedbackFormCubit>().setType(t),
                          ))
                      .toList(),
                ),
                const SizedBox(height: AppSpacing.s5),
                // ---- Message ----
                Row(
                  children: [
                    Container(
                      width: 3,
                      height: 14,
                      decoration: BoxDecoration(
                        color: AppColors.warmPrimary,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.s2),
                    Text(
                      l10n.feedbackMessageLabel,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.warmPrimaryDark,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.s3),
                TextField(
                  maxLines: 6,
                  minLines: 4,
                  maxLength: 500,
                  style: const TextStyle(color: AppColors.warmPrimaryDark),
                  decoration: InputDecoration(
                    hintText: l10n.feedbackMessageHint,
                    hintStyle: const TextStyle(color: AppColors.slate500),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      borderSide: BorderSide(
                        color: AppColors.warmPrimary.withValues(alpha: 0.2),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      borderSide: BorderSide(
                        color: AppColors.warmPrimary.withValues(alpha: 0.2),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      borderSide: const BorderSide(
                        color: AppColors.warmPrimary,
                        width: 1.5,
                      ),
                    ),
                    counterStyle: const TextStyle(color: AppColors.slate500),
                  ),
                  onChanged: (v) =>
                      ctx.read<FeedbackFormCubit>().setMessage(v),
                ),
                if (state.errorMessage != null) ...[
                  const SizedBox(height: AppSpacing.s3),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.s3),
                    decoration: BoxDecoration(
                      color: AppColors.warmPrimaryLight,
                      border: Border.all(
                        color: AppColors.warmPrimary.withValues(alpha: 0.3),
                      ),
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.feedbackErrorTitle,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.warmPrimaryDark,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.s1),
                        Text(
                          state.errorMessage!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.slate700,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.s2),
                        OutlinedButton.icon(
                          onPressed: state.isSubmitting
                              ? null
                              : () => ctx.read<FeedbackFormCubit>().submit(),
                          icon: const Icon(Icons.refresh,
                              color: AppColors.warmPrimaryDark),
                          label: Text(
                            l10n.feedbackRetry,
                            style: const TextStyle(
                              color: AppColors.warmPrimaryDark,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              color: AppColors.warmPrimary,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(AppRadius.md),
                            ),
                          ),
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.warmPrimary,
                      disabledBackgroundColor: AppColors.slate200,
                      foregroundColor: Colors.white,
                      disabledForegroundColor: AppColors.slate500,
                      minimumSize: const Size(double.infinity, 52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(26),
                      ),
                      elevation: 0,
                    ),
                    child: state.isSubmitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            l10n.feedbackSubmit,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _FeedbackTypeChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FeedbackTypeChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.warmPrimary : AppColors.warmPrimaryLight,
          borderRadius: BorderRadius.circular(AppRadius.full),
          border: Border.all(
            color: selected
                ? AppColors.warmPrimary
                : AppColors.warmPrimary.withValues(alpha: 0.3),
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: selected ? Colors.white : AppColors.warmPrimaryDark,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}