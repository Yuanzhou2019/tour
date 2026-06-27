import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../widgets/onboarding_indicator.dart';
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
    final l = AppLocalizations.of(context);
    return Scaffold(
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
                ],
              ),
            ),
            OnboardingIndicator(count: 3, current: _page),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.s6),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_page < 2) {
                      _controller.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                      );
                    } else {
                      context.go('/onboarding/privacy');
                    }
                  },
                  child: Text(
                    _page < 2 ? l.commonNext : l.commonGetStarted,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
