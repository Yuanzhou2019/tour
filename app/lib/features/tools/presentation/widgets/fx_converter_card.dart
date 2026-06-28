import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sightour/core/theme/app_colors.dart';
import 'package:sightour/core/theme/app_radius.dart';
import 'package:sightour/core/theme/app_spacing.dart';
import 'package:sightour/core/theme/app_text_styles.dart';
import 'package:sightour/features/tools/presentation/cubit/fx_converter_cubit.dart';
import 'package:sightour/shared/components/card.dart';

class FxConverterCard extends StatefulWidget {
  const FxConverterCard({super.key});

  @override
  State<FxConverterCard> createState() => _FxConverterCardState();
}

class _FxConverterCardState extends State<FxConverterCard> {
  late final TextEditingController _amountController;

  @override
  void initState() {
    super.initState();
    final initial = context.read<FxConverterCubit>().state.amount.toStringAsFixed(2);
    _amountController = TextEditingController(text: initial);
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FxConverterCubit, FxConverterState>(
      builder: (ctx, state) {
        final cubit = ctx.read<FxConverterCubit>();
        return AppCard(
          variant: AppCardVariant.hero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.currency_exchange,
                      color: AppColors.blue600, size: 20),
                  const SizedBox(width: AppSpacing.s2),
                  Text(
                    'Live currency',
                    style: AppTextTheme.textTheme.titleMedium?.copyWith(
                      color: AppColors.slate900,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  if (state.isLoading)
                    const SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.s3),
              _CurrencyRow(
                label: 'From',
                code: state.from,
                editable: true,
                controller: _amountController,
                onSubmitted: (v) {
                  final parsed = double.tryParse(v);
                  if (parsed != null) cubit.setAmount(parsed);
                },
              ),
              const SizedBox(height: AppSpacing.s2),
              Container(height: 1, color: AppColors.slate200),
              const SizedBox(height: AppSpacing.s2),
              _CurrencyRow(
                label: 'To',
                code: state.to,
                editable: false,
                value: state.converted.toStringAsFixed(2),
              ),
              if (state.error != null) ...[
                const SizedBox(height: AppSpacing.s2),
                Text(
                  state.error!,
                  style: AppTextTheme.textTheme.bodySmall?.copyWith(
                    color: AppColors.clay600,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _CurrencyRow extends StatelessWidget {
  const _CurrencyRow({
    required this.label,
    required this.code,
    required this.editable,
    this.value,
    this.controller,
    this.onSubmitted,
  });

  final String label;
  final String code;
  final bool editable;
  final String? value;
  final TextEditingController? controller;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s2,
            vertical: AppSpacing.s1,
          ),
          decoration: BoxDecoration(
            color: AppColors.blue50,
            borderRadius: BorderRadius.circular(AppRadius.full),
          ),
          child: Text(
            code,
            style: AppTextTheme.textTheme.labelMedium?.copyWith(
              color: AppColors.blue600,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.s3),
        Text(
          label,
          style: AppTextTheme.textTheme.bodySmall?.copyWith(
            color: AppColors.slate500,
          ),
        ),
        const Spacer(),
        if (editable)
          SizedBox(
            width: 120,
            child: TextField(
              controller: controller,
              textAlign: TextAlign.end,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                isCollapsed: true,
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 4),
              ),
              onSubmitted: onSubmitted,
            ),
          )
        else
          Text(
            value ?? '',
            style: AppTextTheme.textTheme.titleMedium?.copyWith(
              color: AppColors.slate900,
              fontWeight: FontWeight.w700,
            ),
          ),
      ],
    );
  }
}