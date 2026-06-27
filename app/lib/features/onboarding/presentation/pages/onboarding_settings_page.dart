import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/i18n/locale_cubit.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/theme_cubit.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../domain/entities/country.dart';
import '../../domain/entities/unit_system.dart';
import '../cubit/first_run_settings_cubit.dart';

class OnboardingSettingsPage extends StatelessWidget {
  const OnboardingSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return BlocBuilder<FirstRunSettingsCubit, FirstRunSettingsState>(
      builder: (context, state) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.s6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l.onboardingSettingsTitle,
                style: AppTextTheme.textTheme.headlineLarge,
              ),
              const SizedBox(height: AppSpacing.s2),
              Text(
                l.onboardingSettingsSubtitle,
                style: AppTextTheme.textTheme.bodyMedium,
              ),
              const SizedBox(height: AppSpacing.s6),
              _SectionLabel(text: l.onboardingSettingsLanguage),
              const SizedBox(height: AppSpacing.s2),
              Wrap(
                spacing: AppSpacing.s2,
                children: [
                  _LanguageChip(
                    label: 'English',
                    locale: const Locale('en'),
                    selected: state.locale.languageCode == 'en',
                  ),
                  _LanguageChip(
                    label: '中文',
                    locale: const Locale('zh'),
                    selected: state.locale.languageCode == 'zh',
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.s6),
              _SectionLabel(text: l.onboardingSettingsTheme),
              const SizedBox(height: AppSpacing.s2),
              Wrap(
                spacing: AppSpacing.s2,
                children: [
                  _ThemeChip(
                    label: 'System',
                    mode: ThemeMode.system,
                    selected: state.themeMode == ThemeMode.system,
                  ),
                  _ThemeChip(
                    label: 'Light',
                    mode: ThemeMode.light,
                    selected: state.themeMode == ThemeMode.light,
                  ),
                  _ThemeChip(
                    label: 'Dark',
                    mode: ThemeMode.dark,
                    selected: state.themeMode == ThemeMode.dark,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.s6),
              _SectionLabel(text: l.onboardingSettingsCountry),
              const SizedBox(height: AppSpacing.s2),
              _CountryTile(state: state),
              const SizedBox(height: AppSpacing.s6),
              _SectionLabel(text: l.onboardingSettingsUnit),
              const SizedBox(height: AppSpacing.s2),
              Wrap(
                spacing: AppSpacing.s2,
                children: [
                  _UnitChip(
                    label: UnitSystem.metric.labelZh,
                    unit: UnitSystem.metric,
                    selected: state.unitSystem == UnitSystem.metric,
                  ),
                  _UnitChip(
                    label: UnitSystem.imperial.labelZh,
                    unit: UnitSystem.imperial,
                    selected: state.unitSystem == UnitSystem.imperial,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: AppTextTheme.textTheme.titleMedium);
  }
}

class _LanguageChip extends StatelessWidget {
  const _LanguageChip({
    required this.label,
    required this.locale,
    required this.selected,
  });
  final String label;
  final Locale locale;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) {
        context.read<FirstRunSettingsCubit>().setLocale(locale);
        context.read<LocaleCubit>().setLocale(locale);
      },
    );
  }
}

class _ThemeChip extends StatelessWidget {
  const _ThemeChip({
    required this.label,
    required this.mode,
    required this.selected,
  });
  final String label;
  final ThemeMode mode;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) {
        context.read<FirstRunSettingsCubit>().setTheme(mode);
        context.read<ThemeCubit>().setMode(mode);
      },
    );
  }
}

class _UnitChip extends StatelessWidget {
  const _UnitChip({
    required this.label,
    required this.unit,
    required this.selected,
  });
  final String label;
  final UnitSystem unit;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) =>
          context.read<FirstRunSettingsCubit>().setUnit(unit),
    );
  }
}

class _CountryTile extends StatelessWidget {
  const _CountryTile({required this.state});
  final FirstRunSettingsState state;

  Future<void> _openPicker(BuildContext context) async {
    final cubit = context.read<FirstRunSettingsCubit>();
    final picked = await showModalBottomSheet<Country>(
      context: context,
      builder: (sheetCtx) {
        return SafeArea(
          child: ListView(
            shrinkWrap: true,
            children: Country.values
                .map(
                  (c) => ListTile(
                    leading: Text(
                      c.flag,
                      style: const TextStyle(fontSize: 24),
                    ),
                    title: Text(c.nameEn),
                    subtitle: Text(c.nameZh),
                    trailing: c == state.country
                        ? const Icon(Icons.check)
                        : null,
                    onTap: () => Navigator.of(sheetCtx).pop(c),
                  ),
                )
                .toList(),
          ),
        );
      },
    );
    if (picked != null) {
      cubit.setCountry(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return InkWell(
      onTap: () => _openPicker(context),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s3,
          vertical: AppSpacing.s4,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).dividerColor),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Text(state.country.flag, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: AppSpacing.s2),
            Expanded(
              child: Text(
                '${state.country.nameEn} · ${state.country.nameZh}',
                style: AppTextTheme.textTheme.bodyLarge,
              ),
            ),
            Text(
              l.onboardingSettingsCountryHint,
              style: AppTextTheme.textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
