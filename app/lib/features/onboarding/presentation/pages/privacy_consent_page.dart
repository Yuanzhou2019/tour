import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../l10n/generated/app_localizations.dart';
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

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final points = <String>[
      l.privacyPoint1,
      l.privacyPoint2,
      l.privacyPoint3,
      l.privacyPoint4,
      l.privacyPoint5,
    ];
    return Scaffold(
      appBar: AppBar(title: Text(l.privacyTitle)),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.s4),
              child: Text(l.privacyIntro,
                  style: AppTextTheme.textTheme.bodyLarge),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(AppSpacing.s4),
                itemCount: points.length,
                itemBuilder: (_, i) => Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: AppSpacing.s2),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${i + 1}. ',
                          style: AppTextTheme.textTheme.bodyLarge),
                      Expanded(
                        child: Text(points[i],
                            style: AppTextTheme.textTheme.bodyLarge),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      const ComingSoonPage(title: 'Privacy Policy'),
                ),
              ),
              child: Text(l.privacyPoint6),
            ),
            const Divider(height: 1),
            CheckboxListTile(
              value: _privacyAgreed,
              onChanged: (v) => setState(() => _privacyAgreed = v ?? false),
              title: Text(l.privacyAgree),
              controlAffinity: ListTileControlAffinity.leading,
            ),
            CheckboxListTile(
              value: _termsAgreed,
              onChanged: (v) => setState(() => _termsAgreed = v ?? false),
              title: Text(l.privacyTermsAgree),
              controlAffinity: ListTileControlAffinity.leading,
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.s4),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _canEnter
                      ? () => context.go('/onboarding/complete')
                      : null,
                  child: Text(l.privacyEnter),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
