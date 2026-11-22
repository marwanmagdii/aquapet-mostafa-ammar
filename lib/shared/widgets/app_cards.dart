import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/tokens/app_tokens.dart';

/// Soft surface card with subtle aquatic border and optional tap handler.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.md),
    this.onTap,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius = AppRadii.lg,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final radius = BorderRadius.circular(borderRadius);
    final isLight = Theme.of(context).brightness == Brightness.light;

    return Container(
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: isLight
            ? const [
                BoxShadow(
                  color: Color(0x0A0F2A2E),
                  blurRadius: 14,
                  offset: Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Material(
        color: backgroundColor ?? colors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: radius,
          side: BorderSide(color: borderColor ?? colors.border),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          child: Padding(
            padding: padding,
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Offline-first product artwork: renders bundled local asset image when available
/// with a gradient + Phosphor icon fallback.
class ProductImagePlaceholder extends StatelessWidget {
  const ProductImagePlaceholder({
    super.key,
    required this.icon,
    required this.gradientColors,
    this.imageUrl,
    this.imageAsset,
    this.height = 120,
    this.width,
    this.borderRadius = AppRadii.md,
    this.iconSize = 44,
    this.badge,
  });

  final IconData icon;
  final List<Color> gradientColors;
  final String? imageUrl;
  final String? imageAsset;
  final double height;
  final double? width;
  final double borderRadius;
  final double iconSize;
  final Widget? badge;

  @override
  Widget build(BuildContext context) {
    Widget fallbackAsset() {
      if (imageAsset != null && imageAsset!.endsWith('.svg')) {
        return Padding(
          padding: const EdgeInsets.all(4),
          child: SvgPicture.asset(
            imageAsset!,
            fit: BoxFit.contain,
          ),
        );
      }
      if (imageAsset != null) {
        return Image.asset(
          imageAsset!,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Center(
            child: Icon(
              icon,
              size: iconSize,
              color: Colors.white.withOpacity(0.92),
            ),
          ),
        );
      }
      return Center(
        child: Icon(
          icon,
          size: iconSize,
          color: Colors.white.withOpacity(0.92),
        ),
      );
    }

    final hasVisual = imageUrl != null || imageAsset != null;

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        height: height,
        width: width ?? double.infinity,
        decoration: BoxDecoration(
          color: hasVisual ? Colors.white : null,
          border: hasVisual
              ? Border.all(color: context.appColors.border.withOpacity(0.6))
              : null,
          gradient: !hasVisual
              ? LinearGradient(
                  begin: AlignmentDirectional.topStart,
                  end: AlignmentDirectional.bottomEnd,
                  colors: gradientColors,
                )
              : null,
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (imageUrl != null && imageUrl!.isNotEmpty)
              Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return fallbackAsset();
                },
                errorBuilder: (_, __, ___) => fallbackAsset(),
              )
            else
              fallbackAsset(),
            if (badge != null)
              PositionedDirectional(
                top: AppSpacing.sm,
                start: AppSpacing.sm,
                child: badge!,
              ),
          ],
        ),
      ),
    );
  }
}
