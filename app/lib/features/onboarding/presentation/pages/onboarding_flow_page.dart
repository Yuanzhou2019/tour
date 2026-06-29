import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../cubit/first_run_settings_cubit.dart';
import '../widgets/onboarding_stepper.dart';
import 'onboarding_city_highlights_page.dart';
import 'onboarding_features_page.dart';
import 'onboarding_settings_page.dart';
import 'onboarding_welcome_page.dart';

class OnboardingFlowPage extends StatefulWidget {
  const OnboardingFlowPage({super.key});

  @override
  State<OnboardingFlowPage> createState() => _OnboardingFlowPageState();
}

class _OnboardingFlowPageState extends State<OnboardingFlowPage> {
  final _controller = PageController();
  int _page = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocProvider<FirstRunSettingsCubit>(
      create: (_) => getIt<FirstRunSettingsCubit>(),
      child: Scaffold(
        backgroundColor: AppColors.warmSurface,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView(
                  controller: _controller,
                  onPageChanged: (i) => setState(() => _page = i),
                  children: const [
                    OnboardingWelcomePage(),
                    OnboardingFeaturesPage(),
                    OnboardingSettingsPage(),
                    OnboardingCityHighlightsPage(),
                  ],
                ),
              ),
              OnboardingStepper(
                count: 5,
                current: _page,
                labels: [
                  l10n.onboardingStepWelcome,
                  l10n.onboardingStepFeatures,
                  l10n.onboardingStepSetup,
                  l10n.onboardingStepHighlights,
                  l10n.onboardingStepPrivacy,
                ],
              ),
              const SizedBox(height: AppSpacing.s5),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s6),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: _page == 0
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: ElevatedButton(
                                onPressed: () {
                                  _controller.nextPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeOut,
                                  );
                                },
                                style: _warmButtonStyle(),
                                child: Text(
                                  l10n.commonGetStarted,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: AppSpacing.s2),
                            TextButton(
                              onPressed: () => context.go('/onboarding/privacy'),
                              child: Text(
                                l10n.commonSkip,
                                style: AppTextTheme.textTheme.labelLarge?.copyWith(
                                  color: AppColors.slate500,
                                ),
                              ),
                            ),
                          ],
                        )
                      : ElevatedButton(
                          onPressed: () {
                            if (_page < 3) {
                              _controller.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeOut,
                              );
                            } else {
                              context.go('/onboarding/privacy');
                            }
                          },
                          style: _warmButtonStyle(),
                          child: Text(
                            _page < 3 ? l10n.commonNext : l10n.commonContinue,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                ),
              ),
              const SizedBox(height: AppSpacing.s5),
            ],
          ),
        ),
      ),
    );
  }

  ButtonStyle _warmButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: AppColors.warmPrimary,
      disabledBackgroundColor: AppColors.slate200,
      foregroundColor: AppColors.white,
      disabledForegroundColor: AppColors.slate500,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      elevation: 0,
    );
  }
}
