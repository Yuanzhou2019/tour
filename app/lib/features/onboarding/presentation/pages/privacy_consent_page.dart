import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../shared/components/animated_text_section.dart';
import '../../../../shared/components/illustration_banner.dart';
import '../../../../shared/pages/coming_soon_page.dart';

class PrivacyConsentPage extends StatefulWidget {
  const PrivacyConsentPage({super.key});

  @override
  State<PrivacyConsentPage> createState() => _PrivacyConsentPageState();
}

class _PrivacyConsentPageState extends State<PrivacyConsentPage> {
  bool _privacyAgreed = false;
  bool _termsAgreed = false;

  bool get _canEnter => _privacyAgreed && _termsAgreed;

  List<({IconData icon, Color bg, String text})> _buildPrivacyCards(AppLocalizations l10n) {
    return [
      (icon: Icons.gps_off, bg: const Color(0xFFFFEDD5), text: l10n.privacyCardLocation),
      (icon: Icons.fingerprint, bg: const Color(0xFFFEF3C7), text: l10n.privacyCardAnonymous),
      (icon: Icons.phone_android, bg: const Color(0xFFFFE8D6), text: l10n.privacyCardLocal),
      (icon: Icons.delete_sweep, bg: const Color(0xFFFFF1F2), text: l10n.privacyCardClear),
      (icon: Icons.feedback_outlined, bg: const Color(0xFFF0F9FF), text: l10n.privacyCardFeedback),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final privacyCards = _buildPrivacyCards(l10n);
    return Scaffold(
      backgroundColor: AppColors.warmSurface,
      body: SafeArea(
        child: Column(
          children: [
            const IllustrationBanner(scene: OnboardingScene.privacy),
            AnimatedTextSection(
              title: l10n.privacyTitle,
              subtitle: l10n.privacySubtitle,
            ),
            const SizedBox(height: AppSpacing.s3),
            const Divider(height: 1),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(AppSpacing.s4),
                itemCount: privacyCards.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: AppSpacing.s3),
                itemBuilder: (_, i) {
                  final card = privacyCards[i];
                  return Container(
                    padding: const EdgeInsets.all(AppSpacing.s3),
                    decoration: BoxDecoration(
                      color: card.bg,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.warmPrimary.withValues(alpha: 0.12),
                          ),
                          child: Icon(card.icon,
                              color: AppColors.warmPrimary, size: 20),
                        ),
                        const SizedBox(width: AppSpacing.s3),
                        Expanded(
                          child: Text(
                            card.text,
                            style: TextStyle(
                              color: AppColors.slate900,
                              fontSize: 14,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      ComingSoonPage(title: l10n.privacyPolicyTitle),
                ),
              ),
              child: Text(
                l10n.privacyReadFull,
                style: TextStyle(
                  color: AppColors.warmPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Divider(height: 1),
            _ConsentCheckbox(
              value: _privacyAgreed,
              onChanged: (v) => setState(() => _privacyAgreed = v),
              label: l10n.privacyAgree,
            ),
            _ConsentCheckbox(
              value: _termsAgreed,
              onChanged: (v) => setState(() => _termsAgreed = v),
              label: l10n.privacyTermsAgree,
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.s4),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _canEnter
                      ? () => context.go('/onboarding/complete')
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.warmPrimary,
                    disabledBackgroundColor: AppColors.slate200,
                    foregroundColor: AppColors.white,
                    disabledForegroundColor: AppColors.slate500,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.full),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    l10n.privacyEnter,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
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

class _ConsentCheckbox extends StatelessWidget {
  const _ConsentCheckbox({
    required this.value,
    required this.onChanged,
    required this.label,
  });

  final bool value;
  final ValueChanged<bool> onChanged;
  final String label;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: value,
      onChanged: (v) => onChanged(v ?? false),
      title: Text(label, style: const TextStyle(fontSize: 14)),
      controlAffinity: ListTileControlAffinity.leading,
      activeColor: AppColors.warmPrimary,
      dense: true,
      visualDensity: VisualDensity.compact,
    );
  }
}
