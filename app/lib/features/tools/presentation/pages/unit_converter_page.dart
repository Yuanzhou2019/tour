import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../l10n/generated/app_localizations.dart';

class UnitConverterPage extends StatefulWidget {
  const UnitConverterPage({super.key});

  @override
  State<UnitConverterPage> createState() => _UnitConverterPageState();
}

class _UnitConverterPageState extends State<UnitConverterPage> {
  double _kmValue = 1.0;
  double _celsiusValue = 0.0;

  static const _kmToMi = 0.621371;
  static double _cToF(double c) => c * 9 / 5 + 32;
  static double _fToC(double f) => (f - 32) * 5 / 9;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.warmSurface,
      appBar: AppBar(
        backgroundColor: AppColors.warmSurface,
        title: Text(l10n.unitConverterTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.s4),
        children: [
          // Distance
          _SectionHeader(label: l10n.unitConverterKm),
          const SizedBox(height: AppSpacing.s3),
          Row(
            children: [
              Expanded(
                child: _InputField(
                  value: _kmValue.toString(),
                  label: l10n.unitConverterKm,
                  onChanged: (v) =>
                      setState(() => _kmValue = double.tryParse(v) ?? 0),
                ),
              ),
              const SizedBox(width: AppSpacing.s3),
              const Icon(Icons.arrow_forward, color: AppColors.slate300),
              const SizedBox(width: AppSpacing.s3),
              Expanded(
                child: _InputField(
                  value: (_kmValue * _kmToMi).toStringAsFixed(2),
                  label: l10n.unitConverterMi,
                  readOnly: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s6),

          // Temperature
          _SectionHeader(label: l10n.unitConverterC),
          const SizedBox(height: AppSpacing.s3),
          Row(
            children: [
              Expanded(
                child: _InputField(
                  value: _celsiusValue.toString(),
                  label: l10n.unitConverterC,
                  onChanged: (v) =>
                      setState(() => _celsiusValue = double.tryParse(v) ?? 0),
                ),
              ),
              const SizedBox(width: AppSpacing.s3),
              const Icon(Icons.arrow_forward, color: AppColors.slate300),
              const SizedBox(width: AppSpacing.s3),
              Expanded(
                child: _InputField(
                  value: _cToF(_celsiusValue).toStringAsFixed(1),
                  label: l10n.unitConverterF,
                  readOnly: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(label,
        style: AppTextTheme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w700,
          color: AppColors.slate500,
        ));
  }
}

class _InputField extends StatelessWidget {
  const _InputField({
    required this.value,
    required this.label,
    this.onChanged,
    this.readOnly = false,
  });
  final String value;
  final String label;
  final ValueChanged<String>? onChanged;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: readOnly,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.md)),
        filled: true,
        fillColor: AppColors.warmSurface,
        contentPadding: const EdgeInsets.all(AppSpacing.s3),
      ),
      controller: TextEditingController(text: value),
      onChanged: onChanged,
      style: AppTextTheme.textTheme.bodyLarge,
    );
  }
}
