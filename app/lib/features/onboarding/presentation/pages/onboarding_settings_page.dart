import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/i18n/locale_cubit.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/theme_cubit.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../shared/components/animated_text_section.dart';
import '../../../../shared/components/illustration_banner.dart';
import '../../domain/entities/country.dart';
import '../../domain/entities/entry_city.dart';
import '../../domain/entities/entry_reason.dart';
import '../../domain/entities/unit_system.dart';
import '../cubit/first_run_settings_cubit.dart';

class OnboardingSettingsPage extends StatelessWidget {
  const OnboardingSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isZh = Localizations.localeOf(context).languageCode == 'zh';
    return BlocBuilder<FirstRunSettingsCubit, FirstRunSettingsState>(
      builder: (context, state) {
        return ListView(
          children: [
            const IllustrationBanner(scene: OnboardingScene.setup),
            AnimatedTextSection(
              title: l10n.onboardingSettingsTitle,
              subtitle: l10n.onboardingSettingsSubtitle,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.s6,
                AppSpacing.s6,
                AppSpacing.s6,
                0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionLabel(text: l10n.onboardingSettingsLanguage),
                  const SizedBox(height: AppSpacing.s2),
                  Wrap(
                    spacing: AppSpacing.s2,
                    children: [
                      _LanguageChip(
                        label: l10n.onboardingSettingsLanguageEn,
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
                  _SectionLabel(text: l10n.onboardingSettingsTheme),
                  const SizedBox(height: AppSpacing.s2),
                  Wrap(
                    spacing: AppSpacing.s2,
                    children: [
                      _ThemeChip(
                        label: l10n.onboardingSettingsThemeSystem,
                        mode: ThemeMode.system,
                        selected: state.themeMode == ThemeMode.system,
                      ),
                      _ThemeChip(
                        label: l10n.onboardingSettingsThemeLight,
                        mode: ThemeMode.light,
                        selected: state.themeMode == ThemeMode.light,
                      ),
                      _ThemeChip(
                        label: l10n.onboardingSettingsThemeDark,
                        mode: ThemeMode.dark,
                        selected: state.themeMode == ThemeMode.dark,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.s6),
                  _SectionLabel(text: l10n.onboardingSettingsCountry),
                  const SizedBox(height: AppSpacing.s2),
                  _CountryTile(state: state, l10n: l10n),
                  const SizedBox(height: AppSpacing.s6),
                  _SectionLabel(text: l10n.onboardingSettingsReason),
                  const SizedBox(height: AppSpacing.s2),
                  _EntryReasonPicker(state: state),
                  const SizedBox(height: AppSpacing.s6),
                  _SectionLabel(text: l10n.onboardingSettingsCity),
                  const SizedBox(height: AppSpacing.s2),
                  _EntryCityPicker(state: state),
                  if (state.entryCity == EntryCity.other) ...[
                    const SizedBox(height: AppSpacing.s2),
                    const _OtherCityNotice(),
                  ],
                  const SizedBox(height: AppSpacing.s6),
                  _SectionLabel(text: l10n.onboardingSettingsUnits),
                  const SizedBox(height: AppSpacing.s2),
                  Wrap(
                    spacing: AppSpacing.s2,
                    children: [
                      _UnitChip(
                        label: isZh ? UnitSystem.metric.labelZh : UnitSystem.metric.labelEn,
                        unit: UnitSystem.metric,
                        selected: state.unitSystem == UnitSystem.metric,
                      ),
                      _UnitChip(
                        label: isZh ? UnitSystem.imperial.labelZh : UnitSystem.imperial.labelEn,
                        unit: UnitSystem.imperial,
                        selected: state.unitSystem == UnitSystem.imperial,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.s8),
                ],
              ),
            ),
          ],
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
  const _CountryTile({required this.state, required this.l10n});
  final FirstRunSettingsState state;
  final AppLocalizations l10n;

  Future<void> _openPicker(BuildContext context) async {
    final cubit = context.read<FirstRunSettingsCubit>();
    final picked = await showModalBottomSheet<Country>(
      context: context,
      isScrollControlled: true,
      builder: (sheetCtx) {
        return SizedBox(
          height: MediaQuery.of(sheetCtx).size.height * 0.7,
          child: _CountryPickerSheet(selectedCountry: state.country),
        );
      },
    );
    if (picked != null) {
      cubit.setCountry(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isZh = Localizations.localeOf(context).languageCode == 'zh';
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
                isZh ? state.country.nameZh : state.country.nameEn,
                style: AppTextTheme.textTheme.bodyLarge,
              ),
            ),
            Text(
              l10n.onboardingSettingsCountryTap,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

class _CountryPickerSheet extends StatefulWidget {
  const _CountryPickerSheet({required this.selectedCountry});
  final Country selectedCountry;

  @override
  State<_CountryPickerSheet> createState() => _CountryPickerSheetState();
}

class _CountryPickerSheetState extends State<_CountryPickerSheet> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  String _query = '';
  final _letterKeys = <String, GlobalKey>{};

  List<String> get _allLetters {
    final letters = <String>{};
    for (final c in Country.values) {
      letters.add(c.nameEn[0].toUpperCase());
    }
    return letters.toList()..sort();
  }

  @override
  void initState() {
    super.initState();
    for (final letter in _allLetters) {
      _letterKeys[letter] = GlobalKey();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  List<Country> get _filtered {
    if (_query.isEmpty) return Country.values.toList();
    final q = _query.toLowerCase();
    return Country.values
        .where((c) => c.nameEn.toLowerCase().contains(q))
        .toList();
  }

  Map<String, List<Country>> get _grouped {
    final map = <String, List<Country>>{};
    for (final c in _filtered) {
      final letter = c.nameEn[0].toUpperCase();
      map.putIfAbsent(letter, () => []).add(c);
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    final grouped = _grouped;
    final showIndex = _query.isEmpty;

    final items = <Widget>[];
    for (final entry in grouped.entries) {
      final key = _letterKeys[entry.key]!;
      items.add(
        Container(
          key: key,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s3,
            vertical: AppSpacing.s1,
          ),
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          child: Text(
            entry.key,
            style: AppTextTheme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
      for (final c in entry.value) {
        items.add(
          ListTile(
            leading: Text(c.flag, style: const TextStyle(fontSize: 24)),
            title: Text(c.nameEn),
            subtitle: Text(c.nameZh),
            trailing: c == widget.selectedCountry
                ? const Icon(Icons.check)
                : null,
            onTap: () => Navigator.of(context).pop(c),
          ),
        );
      }
    }

    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.s3,
              AppSpacing.s3,
              AppSpacing.s3,
              AppSpacing.s2,
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (v) => setState(() => _query = v),
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.onboardingSettingsCountrySearchHint,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _query.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _query = '');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.s3,
                  vertical: AppSpacing.s2,
                ),
              ),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: ListView(
                    controller: _scrollController,
                    children: items,
                  ),
                ),
                if (showIndex)
                  Container(
                    width: 28,
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.s1,
                    ),
                    child: ListView(
                      children: _allLetters.map((letter) {
                        final hasGroup = grouped.containsKey(letter);
                        return GestureDetector(
                          onTap: hasGroup
                              ? () {
                                  final key = _letterKeys[letter];
                                  if (key?.currentContext != null) {
                                    Scrollable.ensureVisible(
                                      key!.currentContext!,
                                      alignment: 0,
                                      duration:
                                          const Duration(milliseconds: 300),
                                      curve: Curves.easeInOut,
                                    );
                                  }
                                }
                              : null,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: AppSpacing.s1 / 2,
                            ),
                            child: Text(
                              letter,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: hasGroup
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).disabledColor,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EntryReasonPicker extends StatelessWidget {
  const _EntryReasonPicker({required this.state});
  final FirstRunSettingsState state;

  @override
  Widget build(BuildContext context) {
    final isZh = Localizations.localeOf(context).languageCode == 'zh';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: AppSpacing.s2,
          runSpacing: AppSpacing.s2,
          children: [
            for (final r in EntryReason.values)
              ChoiceChip(
                avatar: Icon(_iconFor(r), size: 16),
                label: Text(isZh ? r.labelZh : r.labelEn),
                selected: state.entryReason == r,
                onSelected: (_) =>
                    context.read<FirstRunSettingsCubit>().setEntryReason(r),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.s2),
        Text(
          state.entryReason.description,
          style: AppTextTheme.textTheme.bodySmall
              ?.copyWith(color: AppColors.slate500),
        ),
      ],
    );
  }

  IconData _iconFor(EntryReason r) {
    switch (r) {
      case EntryReason.tourism:
        return Icons.travel_explore;
      case EntryReason.business:
        return Icons.business_center_outlined;
      case EntryReason.familyVisit:
        return Icons.family_restroom_outlined;
      case EntryReason.education:
        return Icons.school_outlined;
      case EntryReason.work:
        return Icons.work_outline;
    }
  }
}

class _EntryCityPicker extends StatelessWidget {
  const _EntryCityPicker({required this.state});
  final FirstRunSettingsState state;

  @override
  Widget build(BuildContext context) {
    final isZh = Localizations.localeOf(context).languageCode == 'zh';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: AppSpacing.s2,
          runSpacing: AppSpacing.s2,
          children: [
            for (final c in EntryCity.values)
              ChoiceChip(
                avatar: Icon(_iconFor(c), size: 16),
                label: Text(isZh ? c.nameZh : c.nameEn),
                selected: state.entryCity == c,
                onSelected: (_) =>
                    context.read<FirstRunSettingsCubit>().setEntryCity(c),
              ),
          ],
        ),
        if (state.entryCity.tagline != null) ...[
          const SizedBox(height: AppSpacing.s2),
          Text(
            state.entryCity.tagline!,
            style: AppTextTheme.textTheme.bodySmall
                ?.copyWith(color: AppColors.slate500),
          ),
        ],
      ],
    );
  }

  IconData _iconFor(EntryCity c) {
    switch (c) {
      case EntryCity.beijing:
        return Icons.account_balance_outlined;
      case EntryCity.shanghai:
        return Icons.location_city_outlined;
      case EntryCity.guangzhou:
        return Icons.sailing_outlined;
      case EntryCity.other:
        return Icons.more_horiz;
    }
  }
}

class _OtherCityNotice extends StatelessWidget {
  const _OtherCityNotice();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s3),
      decoration: BoxDecoration(
        color: AppColors.amber50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.amber500),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline,
            size: 18,
            color: AppColors.amber500,
          ),
          const SizedBox(width: AppSpacing.s2),
          Expanded(
            child: Text(
              l10n.onboardingSettingsOtherCityNotice,
              style: AppTextTheme.textTheme.bodySmall
                  ?.copyWith(color: AppColors.amber500),
            ),
          ),
        ],
      ),
    );
  }
}
