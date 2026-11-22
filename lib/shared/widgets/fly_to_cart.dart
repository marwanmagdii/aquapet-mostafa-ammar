import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../core/tokens/app_tokens.dart';

/// Pure-Flutter fly-to-cart Bezier animation using GlobalKey + RenderBox + OverlayEntry.
abstract final class FlyToCartAnimation {
  static void run({
    required BuildContext context,
    required GlobalKey sourceKey,
    required GlobalKey targetKey,
    required TickerProvider vsync,
    required Widget flyingChild,
    VoidCallback? onArrive,
  }) {
    if (MediaQuery.disableAnimationsOf(context)) {
      onArrive?.call();
      return;
    }

    final sourceBox =
        sourceKey.currentContext?.findRenderObject() as RenderBox?;
    final targetBox =
        targetKey.currentContext?.findRenderObject() as RenderBox?;
    final overlay = Overlay.maybeOf(context, rootOverlay: true);

    if (sourceBox == null || targetBox == null || overlay == null) {
      onArrive?.call();
      return;
    }

    final startOrigin = sourceBox.localToGlobal(Offset.zero);
    final endOrigin = targetBox.localToGlobal(Offset.zero);

    final startCenter = startOrigin +
        Offset(sourceBox.size.width / 2, sourceBox.size.height / 2);
    final endCenter =
        endOrigin + Offset(targetBox.size.width / 2, targetBox.size.height / 2);

    // Quadratic Bezier control point lifted above the midpoint for a natural arc.
    final control = Offset(
      (startCenter.dx + endCenter.dx) / 2,
      math.min(startCenter.dy, endCenter.dy) - 96,
    );

    final controller = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 620),
    );
    final curved = CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    );

    const double baseSize = 72;
    late final OverlayEntry entry;

    entry = OverlayEntry(
      builder: (ctx) {
        return AnimatedBuilder(
          animation: curved,
          builder: (_, __) {
            final t = curved.value;
            final p1 = Offset.lerp(startCenter, control, t)!;
            final p2 = Offset.lerp(control, endCenter, t)!;
            final pos = Offset.lerp(p1, p2, t)!;

            final scale = (1.0 - (0.72 * t)).clamp(0.25, 1.0);
            final opacity = t > 0.85 ? ((1.0 - t) / 0.15).clamp(0.0, 1.0) : 1.0;

            return Positioned(
              left: pos.dx - (baseSize / 2),
              top: pos.dy - (baseSize / 2),
              child: IgnorePointer(
                child: Opacity(
                  opacity: opacity,
                  child: Transform.scale(
                    scale: scale,
                    child: SizedBox(
                      width: baseSize,
                      height: baseSize,
                      child: Material(
                        elevation: 6,
                        borderRadius: BorderRadius.circular(AppRadii.md),
                        clipBehavior: Clip.antiAlias,
                        child: flyingChild,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );

    overlay.insert(entry);

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        entry.remove();
        controller.dispose();
        onArrive?.call();
      }
    });

    controller.forward();
  }
}

/// Cart icon button that automatically bounces when [badgeCount] increases.
class BouncingCartButton extends StatefulWidget {
  const BouncingCartButton({
    super.key,
    required this.badgeCount,
    required this.tooltip,
    required this.onPressed,
  });

  final int badgeCount;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  State<BouncingCartButton> createState() => _BouncingCartButtonState();
}

class _BouncingCartButtonState extends State<BouncingCartButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 340),
    );
    _scale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 1.28)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 45,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.28, end: 0.94)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.94, end: 1.0)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 25,
      ),
    ]).animate(_controller);
  }

  @override
  void didUpdateWidget(covariant BouncingCartButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.badgeCount > oldWidget.badgeCount &&
        !MediaQuery.disableAnimationsOf(context)) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return ScaleTransition(
      scale: _scale,
      child: IconButton(
        tooltip: widget.tooltip,
        onPressed: widget.onPressed,
        constraints: const BoxConstraints(
          minWidth: AppSpacing.minTouchTarget,
          minHeight: AppSpacing.minTouchTarget,
        ),
        icon: Badge(
          isLabelVisible: widget.badgeCount > 0,
          label: Text('${widget.badgeCount}'),
          backgroundColor: colors.accent,
          textColor: colors.onAccent,
          child: Icon(
            PhosphorIcons.shoppingCart(),
            color: colors.foreground,
          ),
        ),
      ),
    );
  }
}
