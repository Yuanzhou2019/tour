import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

enum AvatarSize { sm, md, lg }

class AppAvatar extends StatelessWidget {
  const AppAvatar({
    this.imageUrl,
    this.initials,
    this.size = AvatarSize.md,
    super.key,
  });

  final String? imageUrl;
  final String? initials;
  final AvatarSize size;

  double get _diameter => switch (size) {
        AvatarSize.sm => 32.0,
        AvatarSize.md => 40.0,
        AvatarSize.lg => 56.0,
      };

  @override
  Widget build(BuildContext context) {
    final dim = _diameter;
    final fontSize = switch (size) {
      AvatarSize.sm => 12.0,
      AvatarSize.md => 14.0,
      AvatarSize.lg => 20.0,
    };
    return Container(
      width: dim,
      height: dim,
      decoration: BoxDecoration(
        color: AppColors.blue50,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.slate200, width: 1),
      ),
      alignment: Alignment.center,
      clipBehavior: Clip.antiAlias,
      child: imageUrl != null && imageUrl!.isNotEmpty
          ? Image.network(
              imageUrl!,
              width: dim,
              height: dim,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _initialsView(initials, fontSize),
            )
          : _initialsView(initials, fontSize),
    );
  }

  Widget _initialsView(String? text, double fontSize) {
    final fallback = (initials == null || initials!.isEmpty)
        ? '·'
        : initials!.characters.first.toUpperCase();
    return Text(
      fallback,
      style: AppTextTheme.textTheme.labelLarge?.copyWith(
        color: AppColors.blue600,
        fontWeight: FontWeight.w700,
        fontSize: fontSize,
      ),
    );
  }
}