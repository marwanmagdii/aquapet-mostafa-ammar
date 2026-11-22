import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../core/tokens/app_tokens.dart';
import '../../core/utils/loyalty_rules.dart';
import '../../data/models/coupon.dart';
import '../../data/repositories/app_providers.dart';
import '../../shared/widgets/shared_widgets.dart';

class CouponsTab extends ConsumerStatefulWidget {
  const CouponsTab({super.key});

  @override
  ConsumerState<CouponsTab> createState() => _CouponsTabState();
}

class _CouponsTabState extends ConsumerState<CouponsTab>
    with SingleTickerProviderStateMixin {
  final _codeCtrl = TextEditingController();
  late final AnimationController _shakeCtrl;
  CouponStatus _statusFilter = CouponStatus.available;
  String? _codeError;

  @override
  void initState() {
    super.initState();
    _shakeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );
  }

  @override
  void dispose() {
    _shakeCtrl.dispose();
    _codeCtrl.dispose();
    super.dispose();
  }

  void _checkCoupon(bool isAr, AppColorsExtension colors) {
    final match = ref
        .read(couponsProvider.notifier)
        .findAvailableByCode(_codeCtrl.text);
    if (match == null) {
      final msg = isAr
          ? 'الكود غير موجود أو غير متاح'
          : 'Coupon code not found or unavailable';
      setState(() => _codeError = msg);
      _shakeCtrl.forward(from: 0);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: colors.danger,
          content: Text(msg),
        ),
      );
      return;
    }
    setState(() => _codeError = null);
    _showCouponCelebrationDialog(context, match, isAr, colors);
  }

  void _showCouponCelebrationDialog(
    BuildContext context,
    CouponModel coupon,
    bool isAr,
    AppColorsExtension colors,
  ) {
    final discountLabel = coupon.type == CouponType.percent
        ? '${coupon.value.toInt()}% ${isAr ? 'خصم' : 'OFF'}'
        : '${coupon.value.toInt()} ${isAr ? 'ج.م خصم' : 'EGP OFF'}';

    showDialog<void>(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.xl),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 84,
                    height: 84,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          colors.success.withOpacity(0.22),
                          colors.accent.withOpacity(0.18),
                        ],
                      ),
                    ),
                  )
                      .animate(onPlay: (c) => c.repeat(reverse: true))
                      .scale(
                        begin: const Offset(0.95, 0.95),
                        end: const Offset(1.08, 1.08),
                        duration: 900.ms,
                      ),
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colors.success,
                    ),
                    child: Icon(
                      PhosphorIcons.confetti(PhosphorIconsStyle.fill),
                      size: 32,
                      color: Colors.white,
                    ),
                  )
                      .animate()
                      .scale(
                        begin: const Offset(0.3, 0.3),
                        end: const Offset(1, 1),
                        duration: 420.ms,
                        curve: Curves.elasticOut,
                      )
                      .shake(hz: 3, duration: 380.ms),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                isAr ? 'مبروك! الكود صالح' : 'Hooray! Coupon Unlocked',
                textAlign: TextAlign.center,
                style: Theme.of(ctx).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: colors.success,
                    ),
              ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.2, end: 0),
              const SizedBox(height: 6),
              Text(
                isAr
                    ? 'تهانينا! يمكنك استخدام هذا الكود الآن عند إتمام الطلب.'
                    : 'Congratulations! Your discount is ready to use at checkout.',
                textAlign: TextAlign.center,
                style: Theme.of(ctx).textTheme.bodyMedium?.copyWith(
                      color: colors.mutedForeground,
                    ),
              ),
              const SizedBox(height: AppSpacing.md),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm + 4,
                ),
                decoration: BoxDecoration(
                  color: colors.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(AppRadii.lg),
                  border: Border.all(
                    color: colors.primary.withOpacity(0.35),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      discountLabel,
                      style: Theme.of(ctx).textTheme.headlineSmall?.copyWith(
                            color: colors.primary,
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    const SizedBox(height: 4),
                    AppBadge(
                      label: coupon.code,
                      tone: AppBadgeTone.accent,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      coupon.condition(isAr),
                      textAlign: TextAlign.center,
                      style: Theme.of(ctx).textTheme.bodySmall?.copyWith(
                            color: colors.mutedForeground,
                          ),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 180.ms).scale(
                    begin: const Offset(0.92, 0.92),
                    end: const Offset(1, 1),
                    duration: 300.ms,
                  ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                  Expanded(
                    child: AppSecondaryButton(
                      label: isAr ? 'حسناً' : 'Awesome',
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: AppPrimaryButton(
                      label: isAr ? 'للسلة الآن' : 'Use in Cart',
                      onPressed: () {
                        Navigator.pop(ctx);
                        context.push('/cart');
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isAr = ref.watch(localeProvider).languageCode == 'ar';
    final colors = context.appColors;
    final couponsAsync = ref.watch(couponsProvider);
    final stamps = ref.watch(stampsProvider);

    return couponsAsync.when(
      loading: () => const AppLoadingState(),
      error: (_, __) => AppErrorState(
        message: isAr ? 'تعذر تحميل الكوبونات' : 'Could not load coupons',
        retryLabel: isAr ? 'إعادة' : 'Retry',
        onRetry: () => ref.read(couponsProvider.notifier).load(),
      ),
      data: (coupons) {
        final filtered =
            coupons.where((c) => c.status == _statusFilter).toList();

        return ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            // Add / Test Coupon Code
            AnimatedBuilder(
              animation: _shakeCtrl,
              builder: (context, child) {
                final dx = math.sin(_shakeCtrl.value * math.pi * 4) *
                    8 *
                    (1 - _shakeCtrl.value);
                return Transform.translate(
                  offset: Offset(dx, 0),
                  child: child,
                );
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: AppTextField(
                      controller: _codeCtrl,
                      hint: isAr
                          ? 'أدخل كود مثل WELCOME10 أو FISH20'
                          : 'Try WELCOME10 or FISH20',
                      prefixIcon: PhosphorIcons.tag(),
                      errorText: _codeError,
                      onChanged: (_) {
                        if (_codeError != null) {
                          setState(() => _codeError = null);
                        }
                      },
                      onSubmitted: (_) => _checkCoupon(isAr, colors),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: AppSecondaryButton(
                      label: isAr ? 'فحص' : 'Check',
                      onPressed: () => _checkCoupon(isAr, colors),
                    ),
                  ),
                ],
              ),
            ),

            // Stamp Card
            const SizedBox(height: AppSpacing.md),
            AppCard(
              backgroundColor: colors.primary.withOpacity(0.06),
              borderColor: colors.primary.withOpacity(0.25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isAr
                            ? 'بطاقة أختام طعام الأسماك'
                            : 'Fish Food Stamp Card',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      AppBadge(
                        label: '$stamps / ${LoyaltyRules.stampsForFreeBag}',
                        tone: AppBadgeTone.primary,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isAr
                        ? 'اشترِ ١٠ أكياس طعام واحصل على كيس مجاني'
                        : 'Buy 10 fish food bags, get 1 free',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colors.mutedForeground,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                    ),
                    itemCount: LoyaltyRules.stampsForFreeBag,
                    itemBuilder: (context, i) {
                      final filled = i < stamps;
                      return AnimatedContainer(
                        duration: AppDurations.normal,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: filled ? colors.primary : colors.surface,
                          border: Border.all(
                            color: filled ? colors.primary : colors.border,
                            width: 1.5,
                          ),
                        ),
                        child: Icon(
                          PhosphorIcons.fishSimple(
                            filled
                                ? PhosphorIconsStyle.fill
                                : PhosphorIconsStyle.regular,
                          ),
                          size: 20,
                          color: filled ? Colors.white : colors.mutedForeground,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            // Status Tabs
            const SizedBox(height: AppSpacing.md),
            SegmentedButton<CouponStatus>(
              segments: [
                ButtonSegment(
                  value: CouponStatus.available,
                  label: Text(isAr ? 'متاحة' : 'Available'),
                ),
                ButtonSegment(
                  value: CouponStatus.used,
                  label: Text(isAr ? 'مستخدمة' : 'Used'),
                ),
                ButtonSegment(
                  value: CouponStatus.expired,
                  label: Text(isAr ? 'منتهية' : 'Expired'),
                ),
              ],
              selected: {_statusFilter},
              onSelectionChanged: (s) =>
                  setState(() => _statusFilter = s.first),
            ),

            const SizedBox(height: AppSpacing.md),
            if (filtered.isEmpty)
              AppEmptyState(
                icon: PhosphorIcons.ticket(),
                title: isAr ? 'لا توجد كوبونات هنا' : 'No coupons here',
                subtitle: isAr
                    ? 'اكسب كوبونات جديدة من استبدال النقاط أو العروض'
                    : 'Redeem points or collect food stamps to unlock coupons',
              )
            else
              ...filtered.map(
                (coupon) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: AppCard(
                    child: Row(
                      children: [
                        Container(
                          width: 68,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: coupon.status == CouponStatus.available
                                ? colors.accent.withOpacity(0.14)
                                : colors.muted,
                            borderRadius: BorderRadius.circular(AppRadii.md),
                          ),
                          child: Column(
                            children: [
                              Text(
                                coupon.type == CouponType.percent
                                    ? '${coupon.value.toInt()}%'
                                    : '${coupon.value.toInt()}',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      color: coupon.status ==
                                              CouponStatus.available
                                          ? colors.accent
                                          : colors.mutedForeground,
                                    ),
                              ),
                              Text(
                                coupon.type == CouponType.percent
                                    ? (isAr ? 'خصم' : 'OFF')
                                    : (isAr ? 'ج.م' : 'EGP'),
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                coupon.title(isAr),
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                coupon.condition(isAr),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(color: colors.mutedForeground),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${coupon.code} • ${isAr ? 'ينتهي' : 'Exp:'} ${DateFormat.MMMd(isAr ? 'ar' : 'en').format(coupon.expiresAt)}',
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                            ],
                          ),
                        ),
                        AppIconButton(
                          icon: PhosphorIcons.qrCode(),
                          tooltip: isAr ? 'عرض QR' : 'Show QR',
                          onPressed: () => _showQrDialog(context, coupon, isAr),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  void _showQrDialog(BuildContext context, CouponModel coupon, bool isAr) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(coupon.code, textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 180,
              height: 180,
              child: QrImageView(data: coupon.code),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              isAr ? 'أظهر هذا الكود للكاشير' : 'Show this QR to the cashier',
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(isAr ? 'إغلاق' : 'Close'),
          ),
        ],
      ),
    );
  }
}
