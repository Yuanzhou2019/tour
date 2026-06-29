import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

enum FlowNodeStatus { completed, current, pending }

class FlowNodeData {
  const FlowNodeData({
    required this.id,
    required this.icon,
    required this.title,
    this.subtitle,
    required this.child,
    this.status = FlowNodeStatus.completed,
  });

  final String id;
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget child;
  final FlowNodeStatus status;
}

class FlowTimeline extends StatefulWidget {
  const FlowTimeline({
    required this.nodes,
    this.expandedId,
    super.key,
  });

  final List<FlowNodeData> nodes;
  final String? expandedId;

  @override
  State<FlowTimeline> createState() => _FlowTimelineState();
}

class _FlowTimelineState extends State<FlowTimeline>
    with SingleTickerProviderStateMixin {
  late String _expandedId;
  late AnimationController _entranceController;

  @override
  void initState() {
    super.initState();
    _expandedId = widget.expandedId ?? widget.nodes.first.id;
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _entranceController.forward();
  }

  @override
  void dispose() {
    _entranceController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant FlowTimeline oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.expandedId != null && widget.expandedId != oldWidget.expandedId) {
      _expandedId = widget.expandedId!;
    }
  }

  void _toggle(String id) {
    setState(() {
      _expandedId = _expandedId == id ? '' : id;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(widget.nodes.length, (i) {
        final node = widget.nodes[i];
        final isLast = i == widget.nodes.length - 1;
        final isExpanded = _expandedId == node.id;
        final delay = i * 0.15;
        return AnimatedBuilder(
          animation: _entranceController,
          builder: (_, child) {
            final t = ((_entranceController.value - delay) / 0.7).clamp(0.0, 1.0);
            final curved = Curves.easeOutCubic.transform(t);
            return Opacity(
              opacity: curved,
              child: Transform.translate(
                offset: Offset(20 * (1 - curved), 0),
                child: child,
              ),
            );
          },
          child: _FlowNodeWidget(
            data: node,
            isExpanded: isExpanded,
            showLine: !isLast,
            isLast: isLast,
            onTap: () => _toggle(node.id),
          ),
        );
      }),
    );
  }
}

class _FlowNodeWidget extends StatelessWidget {
  const _FlowNodeWidget({
    required this.data,
    required this.isExpanded,
    required this.showLine,
    required this.isLast,
    required this.onTap,
  });

  final FlowNodeData data;
  final bool isExpanded;
  final bool showLine;
  final bool isLast;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 48,
          child: Column(
            children: [
              data.status == FlowNodeStatus.current
                  ? _PulseCircle(icon: data.icon)
                  : _NodeCircle(status: data.status, icon: data.icon),
              if (showLine)
                _ConnectingLine(
                  status: data.status,
                  nextStatus:
                      isLast ? FlowNodeStatus.pending : FlowNodeStatus.completed,
                ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.s2),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : AppSpacing.s4),
            child: _NodeContent(
              data: data,
              isExpanded: isExpanded,
              onTap: onTap,
            ),
          ),
        ),
      ],
    );
  }
}

class _PulseCircle extends StatefulWidget {
  const _PulseCircle({required this.icon});

  final IconData icon;

  @override
  State<_PulseCircle> createState() => _PulseCircleState();
}

class _PulseCircleState extends State<_PulseCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, child) {
        final scale = 1.0 + sin(_ctrl.value * 2 * pi) * 0.08;
        return Transform.scale(
          scale: scale,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [AppColors.warmPrimary, AppColors.warmSecondary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.warmPrimary.withValues(alpha: 0.35),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Icon(widget.icon, color: AppColors.white, size: 20),
          ),
        );
      },
    );
  }
}

class _NodeCircle extends StatelessWidget {
  const _NodeCircle({required this.status, required this.icon});

  final FlowNodeStatus status;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case FlowNodeStatus.current:
        return Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [AppColors.warmPrimary, AppColors.warmSecondary],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.warmPrimary.withValues(alpha: 0.35),
                blurRadius: 8,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Icon(icon, color: AppColors.white, size: 20),
        );
      case FlowNodeStatus.completed:
        return Container(
          width: 36,
          height: 36,
          margin: const EdgeInsets.symmetric(vertical: 2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [AppColors.warmPrimary, AppColors.warmSecondary],
            ),
          ),
          child: const Icon(Icons.check, color: AppColors.white, size: 18),
        );
      case FlowNodeStatus.pending:
        return Container(
          width: 36,
          height: 36,
          margin: const EdgeInsets.symmetric(vertical: 2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.slate300,
              width: 2,
            ),
          ),
          child: Icon(icon, color: AppColors.slate300, size: 20),
        );
    }
  }
}

class _ConnectingLine extends StatelessWidget {
  const _ConnectingLine({required this.status, required this.nextStatus});

  final FlowNodeStatus status;
  final FlowNodeStatus nextStatus;

  @override
  Widget build(BuildContext context) {
    final isDashed =
        status == FlowNodeStatus.pending || nextStatus == FlowNodeStatus.pending;
    final color = isDashed ? AppColors.slate300 : AppColors.warmSecondary;
    return CustomPaint(
      size: const Size(2, 36),
      painter: _LinePainter(color: color, dashed: isDashed),
    );
  }
}

class _LinePainter extends CustomPainter {
  const _LinePainter({required this.color, required this.dashed});

  final Color color;
  final bool dashed;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    if (!dashed) {
      canvas.drawLine(
        Offset(size.width / 2, 0),
        Offset(size.width / 2, size.height),
        paint,
      );
      return;
    }

    const dashHeight = 5.0;
    const gapHeight = 4.0;
    double y = 0;
    while (y < size.height) {
      final end = (y + dashHeight).clamp(0.0, size.height);
      canvas.drawLine(
        Offset(size.width / 2, y),
        Offset(size.width / 2, end),
        paint,
      );
      y += dashHeight + gapHeight;
    }
  }

  @override
  bool shouldRepaint(covariant _LinePainter old) =>
      color != old.color || dashed != old.dashed;
}

class _NodeContent extends StatelessWidget {
  const _NodeContent({
    required this.data,
    required this.isExpanded,
    required this.onTap,
  });

  final FlowNodeData data;
  final bool isExpanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: AppSpacing.s2,
              horizontal: AppSpacing.s1,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.title,
                        style: AppTextTheme.textTheme.titleSmall?.copyWith(
                          color: data.status == FlowNodeStatus.pending
                              ? AppColors.slate500
                              : AppColors.warmPrimaryDark,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                      if (data.subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          data.subtitle!,
                          style: AppTextTheme.textTheme.bodySmall?.copyWith(
                            color: AppColors.slate500,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                AnimatedRotation(
                  turns: isExpanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 300),
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    color: AppColors.slate500,
                    size: 22,
                  ),
                ),
              ],
            ),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOutCubic,
          alignment: Alignment.topCenter,
          child: isExpanded
              ? Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.s2),
                  child: data.child,
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}
