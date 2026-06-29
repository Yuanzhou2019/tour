import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sightour/core/di/injection.dart';
import 'package:sightour/core/theme/app_colors.dart';
import 'package:sightour/core/theme/app_radius.dart';
import 'package:sightour/core/theme/app_spacing.dart';
import 'package:sightour/core/theme/app_text_styles.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../domain/entities/checklist_item.dart';
import '../../domain/entities/policy.dart';
import '../../domain/repositories/checklist_repository.dart';
import '../../domain/repositories/policy_repository.dart';
import '../cubit/prepare_home_cubit.dart';
import '../widgets/journey_banner.dart';
import '../widgets/policy_card.dart';
import 'package:sightour/shared/components/circular_progress_ring.dart';
import 'package:sightour/shared/components/flow_timeline.dart';
import 'package:sightour/shared/components/skeleton.dart';
import 'package:sightour/shared/components/toast.dart';

class PreparePage extends StatelessWidget {
  const PreparePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PrepareHomeCubit(
        getIt<PolicyRepository>(),
        getIt<ChecklistRepository>(),
      )..load(),
      child: const _PrepareView(),
    );
  }
}

class _PrepareView extends StatefulWidget {
  const _PrepareView();

  @override
  State<_PrepareView> createState() => _PrepareViewState();
}

class _PrepareViewState extends State<_PrepareView> {
  bool _showCards = true;

  static const _nodeIcons = [
    Icons.airplane_ticket,
    Icons.inventory_2_outlined,
    Icons.account_balance,
    Icons.home_outlined,
  ];

  List<FlowNodeData> _buildTimelineNodes(List<Policy> policies) {
    return List.generate(policies.length, (i) {
      final p = policies[i];
      return FlowNodeData(
        id: p.id,
        icon: _nodeIcons[i.clamp(0, _nodeIcons.length - 1)],
        title: p.title,
        subtitle: p.source,
        status: i == 0 ? FlowNodeStatus.current : FlowNodeStatus.completed,
        child: _PolicyDetail(policy: p),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.warmSurface,
      appBar: AppBar(
        backgroundColor: AppColors.warmSurface,
        title: BlocBuilder<PrepareHomeCubit, PrepareHomeState>(
          builder: (ctx, state) => Text(
            l10n.prepareTitle(state.country),
            style: AppTextTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.warmPrimaryDark,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined,
                color: AppColors.slate500),
            onPressed: () {},
          ),
        ],
      ),
      body: BlocBuilder<PrepareHomeCubit, PrepareHomeState>(
        builder: (ctx, state) {
          if (state.isLoading) {
            return const AppSkeletonList(count: 5);
          }
          if (state.error != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.s4),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.cloud_off,
                        size: 48, color: AppColors.slate300),
                    const SizedBox(height: AppSpacing.s3),
                    Text(
                      state.error!,
                      textAlign: TextAlign.center,
                      style: AppTextTheme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.clay600,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s4),
                    FilledButton(
                      onPressed: () =>
                          context.read<PrepareHomeCubit>().load(),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.warmPrimary,
                      ),
                      child: Text(l10n.commonRetry),
                    ),
                  ],
                ),
              ),
            );
          }

          final done = state.checklist.where((i) => i.done).length;
          final progress =
              state.checklist.isEmpty ? 0.0 : done / state.checklist.length;

          return ListView(
            padding: EdgeInsets.zero,
            children: [
              JourneyBanner(
                country: state.country,
                entryReason: 'Tourism',
                entryCity: 'SH',
                onCountryTap: () =>
                    ctx.showAppToast(message: l10n.prepareSwitchCountry),
                onReasonTap: () =>
                    ctx.showAppToast(message: l10n.prepareSwitchReason),
                onCityTap: () =>
                    ctx.showAppToast(message: l10n.prepareSwitchCity),
              ),
              if (state.policies.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.s6),
                  child: Text(
                    l10n.prepareNoPolicies(state.country),
                    textAlign: TextAlign.center,
                    style: AppTextTheme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.slate500,
                    ),
                  ),
                ),
              if (state.policies.isNotEmpty) ...[
                _ViewToggle(
                  showCards: _showCards,
                  onChanged: (v) => setState(() => _showCards = v),
                  l10n: l10n,
                ),
                if (_showCards)
                  _StageCardView(
                    policies: state.policies,
                    icons: _nodeIcons,
                  )
                else
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.s4,
                      AppSpacing.s4,
                      AppSpacing.s4,
                      0,
                    ),
                    child: FlowTimeline(
                      nodes: _buildTimelineNodes(state.policies),
                    ),
                  ),
              ],
              // --- Checklist section ---
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.s4,
                  AppSpacing.s6,
                  AppSpacing.s4,
                  0,
                ),
                child: Text(
                  l10n.prepareSectionChecklist,
                  style: AppTextTheme.textTheme.titleSmall?.copyWith(
                    color: AppColors.slate500,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.4,
                  ),
                ),
              ),
              if (state.checklist.isNotEmpty)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppSpacing.s4),
                  child: Row(
                    children: [
                      CircularProgressRing(progress: progress, size: 64),
                      const SizedBox(width: AppSpacing.s4),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                l10n.prepareChecklistDone(done, state.checklist.length),
                                style: AppTextTheme.textTheme.bodySmall
                                    ?.copyWith(color: AppColors.slate500),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: AppSpacing.s2),
              ...state.checklist.map(
                (i) => _ChecklistRow(item: i),
              ),
              // --- Offline downloads ---
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.s4,
                  AppSpacing.s6,
                  AppSpacing.s4,
                  0,
                ),
                child: Text(
                  l10n.prepareSectionDownloads,
                  style: AppTextTheme.textTheme.titleSmall?.copyWith(
                    color: AppColors.slate500,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.4,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.s4),
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.s4),
                  decoration: BoxDecoration(
                    color: AppColors.warmPrimaryLight,
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.download_outlined,
                          color: AppColors.warmPrimaryDark),
                      const SizedBox(width: AppSpacing.s3),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.prepareOfflineShanghai,
                              style: AppTextTheme.textTheme.titleSmall
                                  ?.copyWith(
                                color: AppColors.warmPrimaryDark,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              l10n.prepareOfflineShanghaiDesc,
                              style: AppTextTheme.textTheme.bodySmall
                                  ?.copyWith(color: AppColors.slate500),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_forward,
                            color: AppColors.warmPrimary),
                        onPressed: () => ctx.showAppToast(
                          message: l10n.prepareDownloadToast,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.s6),
            ],
          );
        },
      ),
    );
  }

}

class _ViewToggle extends StatelessWidget {
  const _ViewToggle({required this.showCards, required this.onChanged, required this.l10n});

  final bool showCards;
  final ValueChanged<bool> onChanged;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s4,
        vertical: AppSpacing.s3,
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => onChanged(true),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: showCards ? AppColors.warmPrimary : Colors.transparent,
                  borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(AppRadius.full),
                  ),
                  border: Border.all(
                    color: showCards
                        ? AppColors.warmPrimary
                        : AppColors.warmPrimary.withValues(alpha: 0.4),
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  l10n.prepareViewCards,
                  style: TextStyle(
                    color: showCards ? AppColors.white : AppColors.warmPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => onChanged(false),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: !showCards ? AppColors.warmPrimary : Colors.transparent,
                  borderRadius: const BorderRadius.horizontal(
                    right: Radius.circular(AppRadius.full),
                  ),
                  border: Border.all(
                    color: !showCards
                        ? AppColors.warmPrimary
                        : AppColors.warmPrimary.withValues(alpha: 0.4),
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  l10n.prepareViewTimeline,
                  style: TextStyle(
                    color: !showCards ? AppColors.white : AppColors.warmPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StageCardView extends StatefulWidget {
  const _StageCardView({required this.policies, required this.icons});

  final List<Policy> policies;
  final List<IconData> icons;

  @override
  State<_StageCardView> createState() => _StageCardViewState();
}

class _StageCardViewState extends State<_StageCardView> {
  late final PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 420,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemCount: widget.policies.length,
            itemBuilder: (context, index) {
              final policy = widget.policies[index];
              final icon =
                  widget.icons[index.clamp(0, widget.icons.length - 1)];
              return _buildCard(policy, icon, index);
            },
          ),
        ),
        if (widget.policies.length > 1)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.s2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(widget.policies.length, (i) {
                final isActive = i == _currentPage;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: isActive ? 10 : 7,
                  height: isActive ? 10 : 7,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isActive
                        ? AppColors.warmPrimary
                        : AppColors.warmPrimaryLight,
                    border: isActive
                        ? null
                        : Border.all(
                            color:
                                AppColors.warmPrimary.withValues(alpha: 0.3),
                          ),
                  ),
                );
              }),
            ),
          ),
      ],
    );
  }

  Widget _buildCard(Policy policy, IconData icon, int index) {
    final desc = policy.description;
    final sentences = desc
        .split(RegExp(r'(?<=[.?!])\s+'))
        .where((s) => s.trim().isNotEmpty)
        .toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s4),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.s5),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.warmPrimaryLight, AppColors.warmSurface],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: AppColors.warmSecondary.withValues(alpha: 0.15),
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -20,
              right: -10,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.warmSecondary.withValues(alpha: 0.12),
                ),
              ),
            ),
            Positioned(
              bottom: 40,
              left: -15,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.warmAccent.withValues(alpha: 0.15),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${(index + 1).toString().padLeft(2, '0')}',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.w800,
                    color: AppColors.warmPrimary.withValues(alpha: 0.18),
                    height: 1,
                  ),
                ),
                const SizedBox(height: AppSpacing.s2),
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              AppColors.warmPrimary,
                              AppColors.warmSecondary,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Icon(icon, color: AppColors.white, size: 24),
                      ),
                      const SizedBox(height: AppSpacing.s3),
                      Text(
                        policy.title,
                        textAlign: TextAlign.center,
                        style: AppTextTheme.textTheme.titleMedium?.copyWith(
                          color: AppColors.warmPrimaryDark,
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                      ),
                      if (policy.source.isNotEmpty) ...[
                        const SizedBox(height: AppSpacing.s1),
                        Text(
                          policy.source,
                          textAlign: TextAlign.center,
                          style: AppTextTheme.textTheme.bodySmall?.copyWith(
                            color: AppColors.slate500,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.s4),
                Expanded(
                  child: SingleChildScrollView(
                    child: sentences.length <= 1
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 2),
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: AppColors.warmPrimary
                                      .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.lightbulb_outline,
                                  color: AppColors.warmPrimary,
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: AppSpacing.s3),
                              Expanded(
                                child: Text(
                                  desc,
                                  style: const TextStyle(
                                    color: AppColors.slate900,
                                    height: 1.55,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              for (var i = 0; i < sentences.length; i++)
                                Padding(
                                  padding: EdgeInsets.only(
                                    bottom: i < sentences.length - 1
                                        ? AppSpacing.s2
                                        : 0,
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin:
                                            const EdgeInsets.only(top: 6),
                                        width: 6,
                                        height: 6,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: i == 0
                                              ? AppColors.warmPrimary
                                              : AppColors.warmSecondary,
                                        ),
                                      ),
                                      const SizedBox(width: AppSpacing.s3),
                                      Expanded(
                                        child: Text(
                                          sentences[i].trim(),
                                          style: const TextStyle(
                                            color: AppColors.slate900,
                                            height: 1.5,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                  ),
                ),
                if (policy.source.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.s3),
                  Row(
                    children: [
                      const Icon(Icons.source_outlined,
                          size: 14, color: AppColors.slate500),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          policy.source,
                          style: const TextStyle(
                            color: AppColors.slate500,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PolicyDetail extends StatelessWidget {
  const _PolicyDetail({required this.policy});

  final Policy policy;

  @override
  Widget build(BuildContext context) {
    final desc = policy.description;
    final sentences = desc
        .split(RegExp(r'(?<=[.?!])\s+'))
        .where((s) => s.trim().isNotEmpty)
        .toList();

    return Container(
      padding: const EdgeInsets.all(AppSpacing.s4),
      decoration: BoxDecoration(
        color: AppColors.warmPrimaryLight,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: AppColors.warmSecondary.withValues(alpha: 0.18),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (sentences.length <= 1) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 2),
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.warmPrimary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.lightbulb_outline,
                    color: AppColors.warmPrimary,
                    size: 18,
                  ),
                ),
                const SizedBox(width: AppSpacing.s3),
                Expanded(
                  child: Text(
                    desc,
                    style: const TextStyle(
                      color: AppColors.slate900,
                      height: 1.55,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ] else ...[
            for (var i = 0; i < sentences.length; i++)
              Padding(
                padding: EdgeInsets.only(
                  bottom: i < sentences.length - 1 ? AppSpacing.s3 : 0,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 6),
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: i == 0
                            ? AppColors.warmPrimary
                            : AppColors.warmSecondary,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.s3),
                    Expanded(
                      child: Text(
                        sentences[i].trim(),
                        style: const TextStyle(
                          color: AppColors.slate900,
                          height: 1.5,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
          if (policy.source.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.s4),
            Row(
              children: [
                const Icon(Icons.source_outlined,
                    size: 14, color: AppColors.slate500),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    policy.source,
                    style: const TextStyle(
                      color: AppColors.slate500,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _ChecklistRow extends StatelessWidget {
  const _ChecklistRow({required this.item});

  final ChecklistItem item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s4,
        vertical: 2,
      ),
      child: InkWell(
        onTap: () =>
            context.read<PrepareHomeCubit>().toggleItem(item.id),
        borderRadius: BorderRadius.circular(AppRadius.sm),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.s1,
            horizontal: AppSpacing.s1,
          ),
          child: Row(
            children: [
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: item.done
                      ? AppColors.warmPrimary
                      : Colors.transparent,
                  border: Border.all(
                    color: item.done
                        ? AppColors.warmPrimary
                        : AppColors.slate300,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: item.done
                    ? const Icon(Icons.check,
                        size: 14, color: AppColors.white)
                    : null,
              ),
              const SizedBox(width: AppSpacing.s3),
              Expanded(
                child: Text(
                  item.title,
                  style: AppTextTheme.textTheme.bodyLarge?.copyWith(
                    color: item.done
                        ? AppColors.slate500
                        : AppColors.slate900,
                    decoration:
                        item.done ? TextDecoration.lineThrough : null,
                    decorationColor: AppColors.slate500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}