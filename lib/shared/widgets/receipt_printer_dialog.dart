import 'dart:async';

import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../core/tokens/app_tokens.dart';
import '../../core/utils/product_visuals.dart';
import '../../data/models/cart_order.dart';
import 'app_buttons.dart';

enum ReceiptPrinterStage { processing, printing, complete }

/// Thermal receipt printer modal ported from the React ReceiptPrinter design:
/// transitions through `processing` -> stepped `printing` feed -> `complete`.
class ReceiptPrinterDialog extends StatefulWidget {
  const ReceiptPrinterDialog({
    super.key,
    required this.order,
    required this.isAr,
    required this.onTrackOrder,
  });

  final OrderModel order;
  final bool isAr;
  final VoidCallback onTrackOrder;

  static Future<void> show({
    required BuildContext context,
    required OrderModel order,
    required bool isAr,
    required VoidCallback onTrackOrder,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.65),
      builder: (_) => ReceiptPrinterDialog(
        order: order,
        isAr: isAr,
        onTrackOrder: onTrackOrder,
      ),
    );
  }

  @override
  State<ReceiptPrinterDialog> createState() => _ReceiptPrinterDialogState();
}

class _ReceiptPrinterDialogState extends State<ReceiptPrinterDialog>
    with TickerProviderStateMixin {
  ReceiptPrinterStage _stage = ReceiptPrinterStage.processing;
  late final AnimationController _spinCtrl;
  late final AnimationController _feedCtrl;
  late final Animation<double> _feedAnimation;
  Timer? _printTimer;
  Timer? _completeTimer;

  // Mirrors the React `printingTransformKeyframes` / `printingKeyframeTimes`
  // stepped thermal-printer feed curve (-1.0 -> 0.0).
  static final Animatable<double> _steppedFeedTween = TweenSequence<double>([
    TweenSequenceItem(tween: Tween(begin: -1.0, end: -0.91), weight: 7.5),
    TweenSequenceItem(tween: ConstantTween(-0.91), weight: 3.0),
    TweenSequenceItem(tween: Tween(begin: -0.91, end: -0.81), weight: 7.5),
    TweenSequenceItem(tween: ConstantTween(-0.81), weight: 3.0),
    TweenSequenceItem(tween: Tween(begin: -0.81, end: -0.70), weight: 7.5),
    TweenSequenceItem(tween: ConstantTween(-0.70), weight: 3.0),
    TweenSequenceItem(tween: Tween(begin: -0.70, end: -0.58), weight: 7.5),
    TweenSequenceItem(tween: ConstantTween(-0.58), weight: 3.0),
    TweenSequenceItem(tween: Tween(begin: -0.58, end: -0.45), weight: 7.5),
    TweenSequenceItem(tween: ConstantTween(-0.45), weight: 3.0),
    TweenSequenceItem(tween: Tween(begin: -0.45, end: -0.32), weight: 7.5),
    TweenSequenceItem(tween: ConstantTween(-0.32), weight: 3.0),
    TweenSequenceItem(tween: Tween(begin: -0.32, end: -0.20), weight: 7.5),
    TweenSequenceItem(tween: ConstantTween(-0.20), weight: 3.0),
    TweenSequenceItem(tween: Tween(begin: -0.20, end: -0.10), weight: 7.5),
    TweenSequenceItem(tween: ConstantTween(-0.10), weight: 3.0),
    TweenSequenceItem(tween: Tween(begin: -0.10, end: -0.03), weight: 7.5),
    TweenSequenceItem(tween: ConstantTween(-0.03), weight: 3.0),
    TweenSequenceItem(tween: Tween(begin: -0.03, end: 0.0), weight: 5.5),
  ]);

  @override
  void initState() {
    super.initState();
    _spinCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();

    _feedCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1750),
    );
    _feedAnimation = _steppedFeedTween.animate(_feedCtrl);

    _printTimer = Timer(const Duration(milliseconds: 850), () {
      if (!mounted) return;
      setState(() => _stage = ReceiptPrinterStage.printing);
      _feedCtrl.forward(from: 0);
      _completeTimer = Timer(const Duration(milliseconds: 1800), () {
        if (!mounted) return;
        _spinCtrl.stop();
        setState(() => _stage = ReceiptPrinterStage.complete);
      });
    });
  }

  @override
  void dispose() {
    _printTimer?.cancel();
    _completeTimer?.cancel();
    _spinCtrl.dispose();
    _feedCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isAr = widget.isAr;
    final colors = context.appColors;
    final isReceiptVisible = _stage != ReceiptPrinterStage.processing;

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 380),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Printer Machine Housing
              _PrinterMachine(
                stage: _stage,
                spinCtrl: _spinCtrl,
                orderId: widget.order.id,
                isAr: isAr,
                colors: colors,
              ),

              // Receipt Output Slot & Feeding Paper
              ClipRect(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isReceiptVisible)
                        Container(
                          height: 6,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withOpacity(0.45),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      AnimatedOpacity(
                        opacity: isReceiptVisible ? 1 : 0,
                        duration: const Duration(milliseconds: 160),
                        child: AnimatedBuilder(
                          animation: _feedAnimation,
                          builder: (context, child) {
                            final progress = _stage == ReceiptPrinterStage.complete
                                ? 0.0
                                : (_stage == ReceiptPrinterStage.printing
                                    ? _feedAnimation.value
                                    : -1.0);
                            return FractionalTranslation(
                              translation: Offset(0, progress),
                              child: child,
                            );
                          },
                          child: _ReceiptPaper(
                            order: widget.order,
                            isAr: isAr,
                            colors: colors,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              if (_stage == ReceiptPrinterStage.complete) ...[
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: AppSecondaryButton(
                        label: isAr ? 'إغلاق' : 'Close',
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      flex: 2,
                      child: AppPrimaryButton(
                        label: isAr ? 'متابعة الطلب' : 'Track Order',
                        onPressed: () {
                          Navigator.pop(context);
                          widget.onTrackOrder();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _PrinterMachine extends StatelessWidget {
  const _PrinterMachine({
    required this.stage,
    required this.spinCtrl,
    required this.orderId,
    required this.isAr,
    required this.colors,
  });

  final ReceiptPrinterStage stage;
  final AnimationController spinCtrl;
  final String orderId;
  final bool isAr;
  final AppColorsExtension colors;

  @override
  Widget build(BuildContext context) {
    final statusText = switch (stage) {
      ReceiptPrinterStage.processing =>
        isAr ? 'جاري معالجة طلبك...' : 'Processing your order',
      ReceiptPrinterStage.printing =>
        isAr ? 'جاري طباعة الإيصال...' : 'Printing your receipt',
      ReceiptPrinterStage.complete =>
        isAr ? 'تم تأكيد الطلب بنجاح' : 'Order complete',
    };

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 14),
      decoration: BoxDecoration(
        color: const Color(0xFF1F2429),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF313840), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.35),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'AQUAPET • POS',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: const Color(0xFF94A3B8),
                        letterSpacing: 1.1,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                Text(
                  '#$orderId',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: const Color(0xFFCBD5E1),
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),

          // OLED Screen
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFF0E1216),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFF283038)),
            ),
            child: Row(
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 180),
                  child: stage == ReceiptPrinterStage.complete
                      ? Icon(
                          PhosphorIcons.checkCircle(PhosphorIconsStyle.fill),
                          key: const ValueKey('complete'),
                          size: 20,
                          color: const Color(0xFF22C55E),
                        )
                      : RotationTransition(
                          key: const ValueKey('working'),
                          turns: spinCtrl,
                          child: Icon(
                            PhosphorIcons.circleNotch(PhosphorIconsStyle.bold),
                            size: 20,
                            color: const Color(0xFF94A3B8),
                          ),
                        ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 180),
                    transitionBuilder: (child, anim) => FadeTransition(
                      opacity: anim,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.2),
                          end: Offset.zero,
                        ).animate(anim),
                        child: child,
                      ),
                    ),
                    child: Align(
                      key: ValueKey(stage),
                      alignment: AlignmentDirectional.centerStart,
                      child: Text(
                        statusText,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: stage == ReceiptPrinterStage.complete
                                  ? const Color(0xFF86EFAC)
                                  : const Color(0xFFE2E8F0),
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Recessed Printer Output Slot
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            height: 8,
            decoration: BoxDecoration(
              color: const Color(0xFF090B0D),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: const Color(0xFF2D333B)),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReceiptPaper extends StatelessWidget {
  const _ReceiptPaper({
    required this.order,
    required this.isAr,
    required this.colors,
  });

  final OrderModel order;
  final bool isAr;
  final AppColorsExtension colors;

  @override
  Widget build(BuildContext context) {
    const ink = Color(0xFF1E293B);
    const mutedInk = Color(0xFF64748B);

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.22),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipPath(
        clipper: _ReceiptSerratedClipper(toothCount: 36, toothDepth: 5),
        child: Container(
          width: double.infinity,
          color: const Color(0xFFFAF9F5),
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
          child: DefaultTextStyle(
            style: const TextStyle(
              fontFamily: 'monospace',
              color: ink,
              fontSize: 12,
              height: 1.45,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  isAr ? 'أكوا بت • مصطفى عمار' : 'AQUAPET • MOSTAFA AMMAR',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                    letterSpacing: 0.6,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${isAr ? 'طلب' : 'ORDER'} #${order.id}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: mutedInk, fontSize: 11),
                ),
                const SizedBox(height: 10),
                const Text(
                  '--------------------------------',
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.clip,
                  style: TextStyle(color: mutedInk, letterSpacing: 1),
                ),
                const SizedBox(height: 8),
                ...order.items.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            '${item.quantity}x ${isAr ? item.nameAr : item.nameEn}',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          ProductVisuals.formatEgp(
                            item.unitPriceEgp * item.quantity,
                            isAr,
                          ),
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  '--------------------------------',
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.clip,
                  style: TextStyle(color: mutedInk, letterSpacing: 1),
                ),
                const SizedBox(height: 6),
                _ReceiptRow(
                  label: isAr ? 'المجموع الفرعي' : 'SUBTOTAL',
                  value: ProductVisuals.formatEgp(order.subtotalEgp, isAr),
                ),
                if (order.discountEgp > 0)
                  _ReceiptRow(
                    label: isAr ? 'الخصم' : 'DISCOUNT',
                    value: '-${ProductVisuals.formatEgp(order.discountEgp, isAr)}',
                    valueColor: colors.success,
                  ),
                _ReceiptRow(
                  label: isAr ? 'التوصيل' : 'DELIVERY',
                  value: order.deliveryFeeEgp == 0
                      ? (isAr ? 'مجاني' : 'FREE')
                      : ProductVisuals.formatEgp(order.deliveryFeeEgp, isAr),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isAr ? 'الإجمالي' : 'TOTAL',
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      ProductVisuals.formatEgp(order.totalEgp, isAr),
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                if (order.pointsEarned > 0) ...[
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: colors.primary.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      isAr
                          ? '+${order.pointsEarned} نقطة ولاء مكتسبة'
                          : '+${order.pointsEarned} LOYALTY POINTS EARNED',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: colors.primary,
                        fontWeight: FontWeight.w800,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 10),
                Text(
                  isAr ? 'شكراً لتسوقك من أكوا بت!' : 'THANK YOU FOR SHOPPING!',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: mutedInk,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ReceiptRow extends StatelessWidget {
  const _ReceiptRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Color(0xFF64748B))),
          Text(
            value,
            style: TextStyle(
              color: valueColor ?? const Color(0xFF1E293B),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReceiptSerratedClipper extends CustomClipper<Path> {
  _ReceiptSerratedClipper({
    this.toothCount = 36,
    this.toothDepth = 5,
  });

  final int toothCount;
  final double toothDepth;

  @override
  Path getClip(Size size) {
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height - toothDepth);

    final step = size.width / (toothCount * 2);
    for (var i = 0; i < toothCount * 2; i++) {
      final x = size.width - (i + 1) * step;
      final y = i.isEven ? size.height : size.height - toothDepth;
      path.lineTo(x, y);
    }
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant _ReceiptSerratedClipper oldClipper) =>
      oldClipper.toothCount != toothCount ||
      oldClipper.toothDepth != toothDepth;
}
