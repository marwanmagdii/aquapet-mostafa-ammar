import 'package:flutter/material.dart';

import '../../core/tokens/app_tokens.dart';

enum AppBadgeTone { primary, accent, success, warning, danger, neutral }

/// Compact status/category pill badge with >= 4.5:1 contrast.
class AppBadge extends StatelessWidget {
  const AppBadge({
    super.key,
    required this.label,
    this.tone = AppBadgeTone.primary,
    this.icon,
  });

  final String label;
  final AppBadgeTone tone;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final (Color bg, Color fg) = switch (tone) {
      AppBadgeTone.primary => (colors.primary.withOpacity(0.12), colors.primary),
      AppBadgeTone.accent => (colors.accent.withOpacity(0.14), colors.accent),
      AppBadgeTone.success => (colors.successSurface, colors.success),
      AppBadgeTone.warning => (colors.warningSurface, colors.warning),
      AppBadgeTone.danger => (colors.dangerSurface, colors.danger),
      AppBadgeTone.neutral => (colors.muted, colors.mutedForeground),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadii.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: fg),
            const SizedBox(width: 4),
          ],
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: fg,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
