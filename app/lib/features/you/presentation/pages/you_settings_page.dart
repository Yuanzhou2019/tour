import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sightour/core/i18n/locale_cubit.dart';
import 'package:sightour/core/theme/app_colors.dart';
import 'package:sightour/core/theme/app_radius.dart';
import 'package:sightour/core/theme/app_spacing.dart';
import 'package:sightour/core/theme/theme_cubit.dart';
import 'package:sightour/l10n/generated/app_localizations.dart';

class YouSettingsPage extends StatelessWidget {
  const YouSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context);
    final isZh = locale.languageCode == 'zh';

    return Scaffold(
      backgroundColor: AppColors.warmSurface,
      appBar: AppBar(
        backgroundColor: AppColors.warmSurface,
        elevation: 0,
        title: Text(
          l10n.youSettingsTitle,
          style: const TextStyle(
            color: AppColors.warmPrimaryDark,
            fontWeight: FontWeight.w700,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.warmPrimaryDark),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.s4),
        children: [
          // ---- Language Card ----
          _SettingsCard(
            icon: Icons.language_outlined,
            title: l10n.youSettingsLanguage,
            subtitle: isZh ? '中文' : 'English',
            child: Padding(
              padding: const EdgeInsets.only(top: AppSpacing.s3),
              child: Row(
                children: [
                  Expanded(child: _langChip(context, 'English', 'en', isZh)),
                  const SizedBox(width: AppSpacing.s3),
                  Expanded(child: _langChip(context, '中文', 'zh', isZh)),
                ],
              ),
            ),
          ),
          // ---- Theme Card ----
          _SettingsCard(
            icon: Icons.palette_outlined,
            title: l10n.youSettingsTheme,
            subtitle: l10n.youSettingsThemeSystem,
            child: Padding(
              padding: const EdgeInsets.only(top: AppSpacing.s3),
              child: BlocBuilder<ThemeCubit, ThemeMode>(
                builder: (ctx, mode) {
                  return Row(
                    children: [
                      Expanded(
                        child: _themeChip(
                          ctx,
                          l10n.youSettingsThemeSystem,
                          ThemeMode.system,
                          mode,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.s2),
                      Expanded(
                        child: _themeChip(
                          ctx,
                          l10n.youSettingsThemeLight,
                          ThemeMode.light,
                          mode,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.s2),
                      Expanded(
                        child: _themeChip(
                          ctx,
                          l10n.youSettingsThemeDark,
                          ThemeMode.dark,
                          mode,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          // ---- About Card ----
          _SettingsCard(
            icon: Icons.info_outline,
            title: l10n.youAboutTitle,
            subtitle: l10n.youAboutVersion,
            onTap: () {
              try {
                context.push('/full/about');
              } catch (_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.youAboutVersion)),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _langChip(
    BuildContext context,
    String label,
    String code,
    bool isZh,
  ) {
    final selected = isZh ? code == 'zh' : code == 'en';
    return _OptionChip(
      label: label,
      selected: selected,
      onTap: selected
          ? null
          : () => context.read<LocaleCubit>().setLocale(Locale(code)),
    );
  }

  Widget _themeChip(
    BuildContext context,
    String label,
    ThemeMode mode,
    ThemeMode current,
  ) {
    final selected = mode == current;
    return _OptionChip(
      label: label,
      selected: selected,
      onTap: () => context.read<ThemeCubit>().setMode(mode),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? child;
  final VoidCallback? onTap;

  const _SettingsCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.child,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.s3),
        padding: const EdgeInsets.all(AppSpacing.s4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: AppColors.warmPrimary.withValues(alpha: 0.15),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.warmPrimary.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.warmPrimary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: Icon(icon, color: AppColors.warmPrimary, size: 20),
                ),
                const SizedBox(width: AppSpacing.s3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.warmPrimaryDark,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.slate500,
                        ),
                      ),
                    ],
                  ),
                ),
                if (onTap != null)
                  const Icon(Icons.chevron_right, color: AppColors.slate500),
              ],
            ),
            if (child != null) child!,
          ],
        ),
      ),
    );
  }
}

class _OptionChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback? onTap;

  const _OptionChip({
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
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppColors.warmPrimary : AppColors.warmPrimaryLight,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: selected
                ? AppColors.warmPrimary
                : AppColors.warmPrimary.withValues(alpha: 0.3),
            width: selected ? 1.5 : 1,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            color: selected ? Colors.white : AppColors.warmPrimaryDark,
          ),
        ),
      ),
    );
  }
}