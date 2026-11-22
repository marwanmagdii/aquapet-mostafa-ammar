import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

class _CouponsTabState extends ConsumerState<CouponsTab> {
  final _codeCtrl = TextEditingController();
  CouponStatus _statusFilter = CouponStatus.available;

  @override
  void dispose() {
    _codeCtrl.dispose();
    super.dispose();
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
            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    controller: _codeCtrl,
                    hint: isAr
                        ? 'أدخل كود مثل WELCOME10 أو FISH20'
                        : 'Try WELCOME10 or FISH20',
                    prefixIcon: PhosphorIcons.tag(),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                AppSecondaryButton(
                  label: isAr ? 'فحص' : 'Check',
                  onPressed: () {
                    final match = ref
                        .read(couponsProvider.notifier)
                        .findAvailableByCode(_codeCtrl.text);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          match != null
                              ? (isAr
                                  ? 'الكود ${match.code} متاح للاستخدام عند الدفع'
                                  : 'Coupon ${match.code} is valid for checkout!')
                              : (isAr
                                  ? 'الكود غير موجود أو غير متاح'
                                  : 'Coupon code not found or unavailable'),
                        ),
                      ),
                    );
                  },
                ),
              ],
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
