import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../core/tokens/app_tokens.dart';
import '../../core/utils/loyalty_rules.dart';
import '../../core/utils/product_visuals.dart';
import '../../data/mock/mock_catalog_data.dart';
import '../../data/models/coupon.dart';
import '../../data/models/loyalty.dart';
import '../../data/repositories/app_providers.dart';
import '../../shared/widgets/shared_widgets.dart';
import '../coupons/coupons_tab.dart';

class RewardsHubScreen extends ConsumerStatefulWidget {
  const RewardsHubScreen({super.key});

  @override
  ConsumerState<RewardsHubScreen> createState() => _RewardsHubScreenState();
}

class _RewardsHubScreenState extends ConsumerState<RewardsHubScreen> {
  int _segment = 0; // 0 = Loyalty, 1 = Coupons

  @override
  Widget build(BuildContext context) {
    final isAr = ref.watch(localeProvider).languageCode == 'ar';

    return Scaffold(
      appBar: AppBar(title: Text(isAr ? 'المكافآت والكوبونات' : 'Rewards')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.xs,
            ),
            child: SizedBox(
              width: double.infinity,
              child: SegmentedButton<int>(
                segments: [
                  ButtonSegment(
                    value: 0,
                    icon: Icon(PhosphorIcons.crownSimple()),
                    label: Text(isAr ? 'بطاقة الولاء' : 'Loyalty Card'),
                  ),
                  ButtonSegment(
                    value: 1,
                    icon: Icon(PhosphorIcons.ticket()),
                    label: Text(isAr ? 'الكوبونات والأختام' : 'Coupons & Stamps'),
                  ),
                ],
                selected: {_segment},
                onSelectionChanged: (s) => setState(() => _segment = s.first),
              ),
            ),
          ),
          Expanded(
            child: _segment == 0
                ? const _LoyaltyTab()
                : const CouponsTab(),
          ),
        ],
      ),
    );
  }
}

class _LoyaltyTab extends ConsumerWidget {
  const _LoyaltyTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAr = ref.watch(localeProvider).languageCode == 'ar';
    final colors = context.appColors;
    final loyaltyAsync = ref.watch(loyaltyProvider);
    final user = ref.watch(userProvider).valueOrNull;

    return loyaltyAsync.when(
      loading: () => const AppLoadingState(),
      error: (_, __) => AppErrorState(
        message: isAr ? 'تعذر تحميل النقاط' : 'Could not load loyalty points',
        retryLabel: isAr ? 'إعادة' : 'Retry',
        onRetry: () => ref.read(loyaltyProvider.notifier).load(),
      ),
      data: (loyalty) {
        final memberId = user?.memberId ?? 'AQP-482910';
        final referralCode = user?.referralCode ?? 'OMAR-AQUA';
        final tierTitle = switch (loyalty.tier) {
          LoyaltyTier.bronze => isAr ? 'برونزي • ١x' : 'Bronze • 1.0x',
          LoyaltyTier.silver => isAr ? 'فضي • ١.٢٥x' : 'Silver • 1.25x',
          LoyaltyTier.gold => isAr ? 'ذهبي • ١.٥x' : 'Gold • 1.5x',
        };
        final egpValue = LoyaltyRules.pointsToEgp(loyalty.balancePoints);

        return ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            // Hero Digital Loyalty Card
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadii.xl),
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: AlignmentDirectional.topStart,
                    end: AlignmentDirectional.bottomEnd,
                    colors: [
                      colors.loyaltyGradientStart,
                      colors.loyaltyGradientEnd,
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    PositionedDirectional(
                      top: -28,
                      end: -24,
                      child: Container(
                        width: 110,
                        height: 110,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.08),
                        ),
                      ),
                    ),
                    PositionedDirectional(
                      bottom: -36,
                      start: -18,
                      child: Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.06),
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'AQUAPET',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(
                                    color: Colors.white.withOpacity(0.9),
                                    letterSpacing: 1.5,
                                  ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius:
                                    BorderRadius.circular(AppRadii.pill),
                              ),
                              child: Text(
                                tierTitle,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    isAr
                                        ? '${loyalty.balancePoints} نقطة'
                                        : '${loyalty.balancePoints} Points',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium
                                        ?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                        ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    isAr
                                        ? 'تساوي ${ProductVisuals.formatEgp(egpValue, true)} خصم'
                                        : '= ${ProductVisuals.formatEgp(egpValue, false)} discount value',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          color: Colors.white.withOpacity(0.88),
                                        ),
                                  ),
                                  const SizedBox(height: AppSpacing.md),
                                  Text(
                                    'ID: $memberId',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium
                                        ?.copyWith(
                                          color: Colors.white.withOpacity(0.92),
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.circular(AppRadii.md),
                              ),
                              child: QrImageView(
                                data: memberId,
                                size: 92,
                                padding: EdgeInsets.zero,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Tier Progress
            const SizedBox(height: AppSpacing.md),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        loyalty.nextTierThreshold != null
                            ? (isAr
                                ? 'التقدم نحو الفئة التالية'
                                : 'Progress to Next Tier')
                            : (isAr ? 'أعلى فئة: ذهبي' : 'Top Tier: Gold'),
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      if (loyalty.nextTierThreshold != null)
                        Text(
                          '${loyalty.lifetimePoints} / ${loyalty.nextTierThreshold}',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadii.pill),
                    child: LinearProgressIndicator(
                      minHeight: 8,
                      value: loyalty.progressToNextTier,
                      backgroundColor: colors.muted,
                      color: colors.primary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    isAr
                        ? 'تكسب ١ نقطة لكل ١٠ ج.م • الفضية ١.٢٥x والذهبية ١.٥x'
                        : 'Earn 1 pt per 10 EGP • Silver 1.25x, Gold 1.5x',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colors.mutedForeground,
                        ),
                  ),
                ],
              ),
            ),

            // Referral Card
            const SizedBox(height: AppSpacing.md),
            AppCard(
              backgroundColor: colors.accent.withOpacity(0.08),
              borderColor: colors.accent.withOpacity(0.25),
              child: Row(
                children: [
                  Icon(PhosphorIcons.usersThree(), color: colors.accent),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isAr
                              ? 'ادعُ صديقاً واكسب ١٥٠ نقطة'
                              : 'Refer a friend & earn 150 pts',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        Text(
                          '${isAr ? 'كود الدعوة:' : 'Code:'} $referralCode',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  AppSecondaryButton(
                    label: isAr ? 'نسخ' : 'Copy',
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: referralCode));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            isAr ? 'تم نسخ كود الدعوة' : 'Referral code copied',
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            // Rewards Catalog
            const SizedBox(height: AppSpacing.lg),
            Text(
              isAr ? 'استبدال النقاط' : 'Redeem Points',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.sm),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 230,
                mainAxisSpacing: AppSpacing.sm,
                crossAxisSpacing: AppSpacing.sm,
                mainAxisExtent: 234,
              ),
              itemCount: MockCatalogData.rewards.length,
              itemBuilder: (context, index) {
                final reward = MockCatalogData.rewards[index];
                final canAfford = loyalty.balancePoints >= reward.pointsCost;
                return AppCard(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ProductImagePlaceholder(
                        height: 92,
                        imageUrl: reward.imageUrl,
                        imageAsset: reward.imageAsset,
                        icon: PhosphorIcons.gift(),
                        gradientColors: [colors.primary, colors.secondary],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          AppBadge(
                            label: isAr
                                ? '${reward.pointsCost} نقطة'
                                : '${reward.pointsCost} pts',
                            tone: canAfford
                                ? AppBadgeTone.accent
                                : AppBadgeTone.neutral,
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        reward.title(isAr),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        reward.subtitle(isAr),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: colors.mutedForeground,
                            ),
                      ),
                      const Spacer(),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: canAfford
                              ? () => _redeemReward(context, ref, reward, isAr)
                              : null,
                          style: FilledButton.styleFrom(
                            minimumSize: const Size(0, 36),
                            backgroundColor: colors.accent,
                          ),
                          child: Text(isAr ? 'استبدال' : 'Redeem'),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            // Points History
            const SizedBox(height: AppSpacing.lg),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isAr ? 'سجل النقاط' : 'Points History',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                if (loyalty.transactions.isNotEmpty)
                  AppBadge(
                    label: '${loyalty.transactions.length}',
                    tone: AppBadgeTone.neutral,
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            if (loyalty.transactions.isEmpty)
              AppEmptyState(
                icon: PhosphorIcons.clockCounterClockwise(),
                title: isAr ? 'لا توجد عمليات بعد' : 'No points history yet',
                subtitle: isAr
                    ? 'ستظهر النقاط المكتسبة والمستخدمة هنا'
                    : 'Earned and spent points will appear here',
              )
            else
              AppCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    for (var i = 0; i < loyalty.transactions.length; i++) ...[
                      if (i > 0) const Divider(height: 1),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: 12,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: loyalty.transactions[i].points >= 0
                                    ? colors.successSurface
                                    : colors.accent.withOpacity(0.14),
                                borderRadius:
                                    BorderRadius.circular(AppRadii.md),
                              ),
                              child: Icon(
                                loyalty.transactions[i].points >= 0
                                    ? PhosphorIcons.arrowUpRight()
                                    : PhosphorIcons.ticket(),
                                size: 20,
                                color: loyalty.transactions[i].points >= 0
                                    ? colors.success
                                    : colors.accent,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    loyalty.transactions[i].title(isAr),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    DateFormat.yMMMd(isAr ? 'ar' : 'en').format(
                                      loyalty.transactions[i].createdAt,
                                    ),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          color: colors.mutedForeground,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            AppBadge(
                              label: loyalty.transactions[i].points >= 0
                                  ? '+${loyalty.transactions[i].points} ${isAr ? 'نقطة' : 'pts'}'
                                  : '${loyalty.transactions[i].points} ${isAr ? 'نقطة' : 'pts'}',
                              tone: loyalty.transactions[i].points >= 0
                                  ? AppBadgeTone.success
                                  : AppBadgeTone.accent,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            const SizedBox(height: AppSpacing.xl),
          ],
        );
      },
    );
  }

  Future<void> _redeemReward(
    BuildContext context,
    WidgetRef ref,
    RewardItem reward,
    bool isAr,
  ) async {
    final ok = await ref.read(loyaltyProvider.notifier).spendPoints(
          points: reward.pointsCost,
          titleEn: 'Redeemed: ${reward.titleEn}',
          titleAr: 'استبدال: ${reward.titleAr}',
        );
    if (!ok) return;
    final now = ref.read(appNowProvider);
    final code = '${reward.couponCodePrefix}${now.millisecond}';
    await ref.read(couponsProvider.notifier).addCoupon(
          CouponModel(
            id: 'cpn_rwd_${now.microsecondsSinceEpoch}',
            code: code,
            titleEn: reward.titleEn,
            titleAr: reward.titleAr,
            conditionEn: reward.subtitleEn,
            conditionAr: reward.subtitleAr,
            type:
                reward.isFreeItem ? CouponType.freeItem : CouponType.fixed,
            value: reward.discountEgp,
            minOrderEgp: 0,
            expiresAt: now.add(const Duration(days: 60)),
            status: CouponStatus.available,
          ),
        );
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isAr
                ? 'تم الاستبدال! الكوبون $code مضاف لمحفظتك'
                : 'Redeemed! Coupon $code added to your wallet',
          ),
        ),
      );
    }
  }
}
