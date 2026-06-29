import 'package:flutter/material.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../l10n/generated/app_localizations.dart';
import 'package:sightour/shared/components/skeleton.dart';
import '../../data/repositories/emergency_repository_impl.dart';
import '../../domain/entities/emergency_contact.dart';

class EmergencyPage extends StatelessWidget {
  const EmergencyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return FutureBuilder<List<EmergencyContact>>(
      future: EmergencyRepositoryImpl(getIt()).fetchAll(),
      builder: (ctx, snapshot) {
        final contacts = snapshot.data ?? [];
        return Scaffold(
          backgroundColor: AppColors.warmSurface,
          appBar: AppBar(
            backgroundColor: AppColors.warmSurface,
            title: Text(l10n.emergencyTitle),
          ),
          body: snapshot.connectionState == ConnectionState.waiting
              ? const AppSkeletonList(count: 5)
              : contacts.isEmpty
                  ? Center(
                      child: Text(l10n.emergencyEmpty,
                          style: AppTextTheme.textTheme.bodyMedium!
                              .copyWith(color: AppColors.slate500)),
                    )
                  : ListView(
                      padding: const EdgeInsets.all(AppSpacing.s4),
                      children: contacts.map((c) => _ContactCard(contact: c)).toList(),
                    ),
        );
      },
    );
  }
}

class _ContactCard extends StatelessWidget {
  const _ContactCard({required this.contact});
  final EmergencyContact contact;

  String _iconForType(String type) {
    switch (type) {
      case 'police':
        return 'police';
      case 'medical':
        return 'medical';
      case 'fire':
        return 'fire';
      case 'consulate':
        return 'consulate';
      default:
        return 'phone';
    }
  }

  IconData _iconDataForType(String type) {
    switch (type) {
      case 'police':
        return Icons.local_police;
      case 'medical':
        return Icons.medical_services;
      case 'fire':
        return Icons.fire_truck;
      case 'consulate':
        return Icons.account_balance;
      default:
        return Icons.phone;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isZh = Localizations.localeOf(context).languageCode == 'zh';
    final name = isZh && contact.nameZh.isNotEmpty ? contact.nameZh : contact.nameEn;
    final address =
        isZh && contact.addressZh != null ? contact.addressZh : contact.addressEn;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.s3),
      decoration: BoxDecoration(
        color: AppColors.warmSurface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.slate200),
      ),
      padding: const EdgeInsets.all(AppSpacing.s4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(_iconDataForType(contact.type),
                  size: 20, color: AppColors.warmPrimaryDark),
              const SizedBox(width: AppSpacing.s2),
              Expanded(
                child: Text(name,
                    style: AppTextTheme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.clay600,
                    )),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s2),
          Row(
            children: [
              const Icon(Icons.call, size: 16, color: AppColors.warmPrimary),
              const SizedBox(width: AppSpacing.s2),
              Text(contact.phone,
                  style: AppTextTheme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppColors.warmPrimaryDark,
                  )),
            ],
          ),
          if (address != null) ...[
            const SizedBox(height: AppSpacing.s1),
            Text(address,
                style: AppTextTheme.textTheme.bodySmall!
                    .copyWith(color: AppColors.slate500)),
          ],
        ],
      ),
    );
  }
}
