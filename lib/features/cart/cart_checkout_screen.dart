import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../core/tokens/app_tokens.dart';
import '../../core/utils/loyalty_rules.dart';
import '../../core/utils/product_visuals.dart';
import '../../data/models/cart_order.dart';
import '../../data/models/coupon.dart';
import '../../data/models/loyalty.dart';
import '../../data/models/product.dart';
import '../../data/repositories/app_providers.dart';
import '../../shared/widgets/shared_widgets.dart';

class CartCheckoutScreen extends ConsumerStatefulWidget {
  const CartCheckoutScreen({super.key});

  @override
  ConsumerState<CartCheckoutScreen> createState() => _CartCheckoutScreenState();
}

class _CartCheckoutScreenState extends ConsumerState<CartCheckoutScreen> {
  final _couponCtrl = TextEditingController();
  final _streetCtrl = TextEditingController(text: 'Street 9, Building 14');

  FulfillmentType _fulfillment = FulfillmentType.delivery;
  String _selectedArea = LoyaltyRules.deliveryFeesByArea.keys.first;
  PaymentMethod _payment = PaymentMethod.cod;
  CouponModel? _appliedCoupon;
  String? _couponError;
  bool _usePoints = false;
  double _pointsSlider = 0;
  bool _placingOrder = false;

  @override
  void dispose() {
    _couponCtrl.dispose();
    _streetCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isAr = ref.watch(localeProvider).languageCode == 'ar';
    final colors = context.appColors;
    final cartAsync = ref.watch(cartProvider);
    final productsAsync = ref.watch(productsProvider);
    final loyaltyAsync = ref.watch(loyaltyProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(isAr ? 'سلة التسوق والدفع' : 'Cart & Checkout'),
        actions: [
          if ((cartAsync.valueOrNull ?? const []).isNotEmpty)
            AppIconButton(
              icon: PhosphorIcons.trash(),
              tooltip: isAr ? 'إفراغ السلة' : 'Clear Cart',
              onPressed: () => ref.read(cartProvider.notifier).clear(),
            ),
        ],
      ),
      body: cartAsync.when(
        loading: () => const AppLoadingState(),
        error: (_, __) => AppErrorState(
          message: isAr ? 'تعذر تحميل السلة' : 'Failed to load cart',
          retryLabel: isAr ? 'إعادة' : 'Retry',
          onRetry: () => ref.read(cartProvider.notifier).load(),
        ),
        data: (cartItems) {
          if (cartItems.isEmpty) {
            return AppEmptyState(
              icon: PhosphorIcons.shoppingCart(),
              title: isAr ? 'سلتك فارغة' : 'Your cart is empty',
              subtitle: isAr
                  ? 'أضف أسماكاً أو طعاماً أو مستلزمات لتبدأ طلبك'
                  : 'Add fish, food, or aquarium supplies to get started',
              actionLabel: isAr ? 'تصفح المتجر' : 'Browse Shop',
              onAction: () => context.go('/shop'),
            );
          }

          final products = productsAsync.valueOrNull ?? const <Product>[];
          final productMap = {for (final p in products) p.id: p};

          double subtotal = 0;
          final resolved = <(CartItem, Product, ProductVariant)>[];
          for (final item in cartItems) {
            final product = productMap[item.productId];
            if (product == null) continue;
            final variant = product.variants.firstWhere(
              (v) => v.id == item.variantId,
              orElse: () => product.variants.first,
            );
            subtotal += variant.priceEgp * item.quantity;
            resolved.add((item, product, variant));
          }

          final couponDiscount = _appliedCoupon?.computeDiscount(subtotal) ?? 0;
          final availablePoints =
              loyaltyAsync.valueOrNull?.balancePoints ?? 0;
          final maxRedeemablePoints = availablePoints
              .clamp(0, ((subtotal - couponDiscount) * 10).floor());
          final pointsToUse = _usePoints
              ? _pointsSlider.round().clamp(0, maxRedeemablePoints)
              : 0;
          final pointsDiscount = LoyaltyRules.pointsToEgp(pointsToUse);
          final totalDiscount =
              (couponDiscount + pointsDiscount).clamp(0.0, subtotal);

          final deliveryFee = _fulfillment == FulfillmentType.delivery
              ? (LoyaltyRules.deliveryFeesByArea[_selectedArea] ?? 40)
              : 0.0;
          final total = (subtotal - totalDiscount + deliveryFee).clamp(0.0, 999999.0);
          final tier = loyaltyAsync.valueOrNull?.tier ?? LoyaltyTier.bronze;
          final pointsToEarn =
              LoyaltyRules.calculateEarnedPoints(total, tier.multiplier);

          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  children: [
                    // Cart Items (swipe to remove)
                    ...resolved.map((entry) {
                      final (item, product, variant) = entry;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: Dismissible(
                          key: ValueKey('${item.productId}_${item.variantId}'),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            alignment: AlignmentDirectional.centerEnd,
                            padding: const EdgeInsetsDirectional.only(end: 20),
                            decoration: BoxDecoration(
                              color: colors.danger,
                              borderRadius: BorderRadius.circular(AppRadii.lg),
                            ),
                            child: Icon(
                              PhosphorIcons.trash(),
                              color: Colors.white,
                            ),
                          ),
                          onDismissed: (_) => ref
                              .read(cartProvider.notifier)
                              .updateQuantity(item.productId, item.variantId, 0),
                          child: AppCard(
                            padding: const EdgeInsets.all(AppSpacing.sm),
                            child: Row(
                              children: [
                                ProductImagePlaceholder(
                                  width: 68,
                                  height: 68,
                                  iconSize: 28,
                                  imageUrl: product.imageUrl,
                                  imageAsset:
                                      ProductVisuals.imageAssetForProduct(
                                    product,
                                  ),
                                  icon: ProductVisuals.iconForCategory(
                                    product.category,
                                  ),
                                  gradientColors:
                                      ProductVisuals.colorsForProduct(product),
                                ),
                                const SizedBox(width: AppSpacing.md),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.name(isAr),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall,
                                      ),
                                      Text(
                                        variant.label(isAr),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                              color: colors.mutedForeground,
                                            ),
                                      ),
                                      if (product.isLiveFish)
                                        Text(
                                          isAr
                                              ? 'سمك حي: استلام أو توصيل خاص'
                                              : 'Live fish: pickup or careful delivery',
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelSmall
                                              ?.copyWith(color: colors.warning),
                                        ),
                                      const SizedBox(height: 4),
                                      Text(
                                        ProductVisuals.formatEgp(
                                          variant.priceEgp * item.quantity,
                                          isAr,
                                        ),
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelLarge
                                            ?.copyWith(color: colors.primary),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        PhosphorIcons.minusCircle(),
                                        size: 22,
                                      ),
                                      onPressed: () => ref
                                          .read(cartProvider.notifier)
                                          .updateQuantity(
                                            item.productId,
                                            item.variantId,
                                            item.quantity - 1,
                                          ),
                                    ),
                                    Text('${item.quantity}'),
                                    IconButton(
                                      icon: Icon(
                                        PhosphorIcons.plusCircle(),
                                        size: 22,
                                      ),
                                      onPressed: () => ref
                                          .read(cartProvider.notifier)
                                          .updateQuantity(
                                            item.productId,
                                            item.variantId,
                                            item.quantity + 1,
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),

                    // Fulfillment
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      isAr ? 'طريقة الاستلام' : 'Fulfillment',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    SegmentedButton<FulfillmentType>(
                      segments: [
                        ButtonSegment(
                          value: FulfillmentType.delivery,
                          icon: Icon(PhosphorIcons.truck()),
                          label: Text(isAr ? 'توصيل' : 'Delivery'),
                        ),
                        ButtonSegment(
                          value: FulfillmentType.pickup,
                          icon: Icon(PhosphorIcons.storefront()),
                          label: Text(isAr ? 'استلام من المتجر' : 'Store Pickup'),
                        ),
                      ],
                      selected: {_fulfillment},
                      onSelectionChanged: (s) =>
                          setState(() => _fulfillment = s.first),
                    ),

                    if (_fulfillment == FulfillmentType.delivery) ...[
                      const SizedBox(height: AppSpacing.md),
                      DropdownButtonFormField<String>(
                        value: _selectedArea,
                        decoration: InputDecoration(
                          labelText: isAr ? 'المنطقة' : 'Delivery Area',
                          prefixIcon: Icon(PhosphorIcons.mapPin()),
                        ),
                        items: LoyaltyRules.deliveryFeesByArea.entries
                            .map(
                              (e) => DropdownMenuItem(
                                value: e.key,
                                child: Text(
                                  '${e.key} (${ProductVisuals.formatEgp(e.value, isAr)})',
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (v) {
                          if (v != null) setState(() => _selectedArea = v);
                        },
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      AppTextField(
                        controller: _streetCtrl,
                        label: isAr ? 'العنوان بالتفصيل' : 'Street Address',
                        prefixIcon: PhosphorIcons.house(),
                      ),
                    ],

                    // Coupon & Points
                    const SizedBox(height: AppSpacing.lg),
                    AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isAr ? 'الكوبونات والنقاط' : 'Discounts & Points',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Row(
                            children: [
                              Expanded(
                                child: AppTextField(
                                  controller: _couponCtrl,
                                  hint: isAr
                                      ? 'كود الخصم (مثل FISH20)'
                                      : 'Coupon code (e.g. FISH20)',
                                ),
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              AppSecondaryButton(
                                label: isAr ? 'تطبيق' : 'Apply',
                                onPressed: () {
                                  final found = ref
                                      .read(couponsProvider.notifier)
                                      .findAvailableByCode(_couponCtrl.text);
                                  setState(() {
                                    if (found == null) {
                                      _couponError = isAr
                                          ? 'الكود غير صالح أو غير متاح'
                                          : 'Invalid or unavailable coupon';
                                      _appliedCoupon = null;
                                    } else if (subtotal < found.minOrderEgp) {
                                      _couponError = isAr
                                          ? 'الحد الأدنى ${found.minOrderEgp.toInt()} ج.م'
                                          : 'Min order ${found.minOrderEgp.toInt()} EGP';
                                      _appliedCoupon = null;
                                    } else {
                                      _couponError = null;
                                      _appliedCoupon = found;
                                    }
                                  });
                                },
                              ),
                            ],
                          ),
                          if (_couponError != null) ...[
                            const SizedBox(height: 6),
                            Text(
                              _couponError!,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: colors.danger),
                            ),
                          ],
                          if (_appliedCoupon != null) ...[
                            const SizedBox(height: 8),
                            AppBadge(
                              label:
                                  '${_appliedCoupon!.code}: -${ProductVisuals.formatEgp(couponDiscount, isAr)}',
                              tone: AppBadgeTone.success,
                            ),
                          ],
                          if (maxRedeemablePoints > 0) ...[
                            const Divider(height: 24),
                            SwitchListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(
                                isAr
                                    ? 'استخدام النقاط ($availablePoints نقطة متاحة)'
                                    : 'Use Points ($availablePoints pts available)',
                              ),
                              subtitle: _usePoints
                                  ? Text(
                                      isAr
                                          ? 'خصم ${ProductVisuals.formatEgp(pointsDiscount, isAr)} ($pointsToUse نقطة)'
                                          : '-${ProductVisuals.formatEgp(pointsDiscount, isAr)} ($pointsToUse pts)',
                                    )
                                  : null,
                              value: _usePoints,
                              onChanged: (v) {
                                setState(() {
                                  _usePoints = v;
                                  if (v && _pointsSlider == 0) {
                                    _pointsSlider =
                                        maxRedeemablePoints.toDouble();
                                  }
                                });
                              },
                            ),
                            if (_usePoints)
                              Slider(
                                min: 0,
                                max: maxRedeemablePoints.toDouble(),
                                value: _pointsSlider.clamp(
                                  0,
                                  maxRedeemablePoints.toDouble(),
                                ),
                                onChanged: (v) =>
                                    setState(() => _pointsSlider = v),
                              ),
                          ],
                        ],
                      ),
                    ),

                    // Payment method (mock)
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      isAr ? 'طريقة الدفع (تجريبي)' : 'Payment Method (Mock)',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      children: PaymentMethod.values.map((m) {
                        final label = switch (m) {
                          PaymentMethod.cod =>
                            isAr ? 'الدفع عند الاستلام' : 'Cash on Delivery',
                          PaymentMethod.card => isAr ? 'بطاقة بنكية' : 'Card',
                          PaymentMethod.instaPay => 'InstaPay',
                          PaymentMethod.vodafoneCash => 'Vodafone Cash',
                        };
                        return ChoiceChip(
                          label: Text(label),
                          selected: _payment == m,
                          onSelected: (_) => setState(() => _payment = m),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                  ],
                ),
              ),

              // Summary + Place Order
              SafeArea(
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: colors.surface,
                    border: Border(top: BorderSide(color: colors.border)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _SummaryRow(
                        label: isAr ? 'المجموع الفرعي' : 'Subtotal',
                        value: ProductVisuals.formatEgp(subtotal, isAr),
                      ),
                      if (totalDiscount > 0)
                        _SummaryRow(
                          label: isAr ? 'الخصم' : 'Discount',
                          value:
                              '-${ProductVisuals.formatEgp(totalDiscount, isAr)}',
                          valueColor: colors.success,
                        ),
                      _SummaryRow(
                        label: isAr ? 'التوصيل' : 'Delivery',
                        value: deliveryFee == 0
                            ? (isAr ? 'مجاني' : 'Free')
                            : ProductVisuals.formatEgp(deliveryFee, isAr),
                      ),
                      const Divider(height: 16),
                      _SummaryRow(
                        label: isAr ? 'الإجمالي' : 'Total',
                        value: ProductVisuals.formatEgp(total, isAr),
                        isBold: true,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      AppPrimaryButton(
                        isLoading: _placingOrder,
                        label: isAr
                            ? 'تأكيد الطلب • اكسب +$pointsToEarn نقطة'
                            : 'Place Order • Earn +$pointsToEarn pts',
                        onPressed: () => _placeOrder(
                          context: context,
                          isAr: isAr,
                          resolved: resolved,
                          subtotal: subtotal,
                          totalDiscount: totalDiscount,
                          deliveryFee: deliveryFee,
                          total: total,
                          pointsToEarn: pointsToEarn,
                          pointsToUse: pointsToUse,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _placeOrder({
    required BuildContext context,
    required bool isAr,
    required List<(CartItem, Product, ProductVariant)> resolved,
    required double subtotal,
    required double totalDiscount,
    required double deliveryFee,
    required double total,
    required int pointsToEarn,
    required int pointsToUse,
  }) async {
    setState(() => _placingOrder = true);
    final now = ref.read(appNowProvider);
    final orderId = 'AQ-${1050 + (now.millisecond % 899)}';

    final lineItems = resolved
        .map(
          (e) => OrderLineItem(
            productId: e.$2.id,
            variantId: e.$3.id,
            nameEn: e.$2.nameEn,
            nameAr: e.$2.nameAr,
            variantLabelEn: e.$3.labelEn,
            variantLabelAr: e.$3.labelAr,
            unitPriceEgp: e.$3.priceEgp,
            quantity: e.$1.quantity,
            grams: e.$3.grams,
          ),
        )
        .toList();

    final order = OrderModel(
      id: orderId,
      createdAt: now,
      items: lineItems,
      subtotalEgp: subtotal,
      discountEgp: totalDiscount,
      deliveryFeeEgp: deliveryFee,
      totalEgp: total,
      pointsEarned: pointsToEarn,
      pointsUsed: pointsToUse,
      fulfillmentType: _fulfillment,
      paymentMethod: _payment,
      status: OrderStatus.received,
      addressSummary: _fulfillment == FulfillmentType.delivery
          ? '$_selectedArea, ${_streetCtrl.text.trim()}'
          : null,
      couponCode: _appliedCoupon?.code,
    );

    await ref.read(ordersProvider.notifier).placeOrder(order);
    if (pointsToUse > 0) {
      await ref.read(loyaltyProvider.notifier).spendPoints(
            points: pointsToUse,
            titleEn: 'Redeemed on Order #$orderId',
            titleAr: 'استخدام في الطلب #$orderId',
          );
    }
    if (pointsToEarn > 0) {
      await ref.read(loyaltyProvider.notifier).addPoints(
            points: pointsToEarn,
            titleEn: 'Earned from Order #$orderId',
            titleAr: 'مكتسبة من الطلب #$orderId',
          );
    }
    if (_appliedCoupon != null) {
      await ref.read(couponsProvider.notifier).markUsed(_appliedCoupon!.id);
    }

    // Stamp card: count food bags purchased
    final foodBags = resolved
        .where((e) => e.$2.category == ProductCategory.food)
        .fold<int>(0, (sum, e) => sum + e.$1.quantity);
    if (foodBags > 0) {
      await ref.read(stampsProvider.notifier).addFoodBagStamps(foodBags);
    }

    await ref.read(cartProvider.notifier).clear();

    if (!mounted) return;
    setState(() => _placingOrder = false);
    await showDialog<void>(
      context: this.context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        icon: Icon(
          PhosphorIcons.checkCircle(PhosphorIconsStyle.fill),
          color: context.appColors.success,
          size: 48,
        ),
        title: Text(isAr ? 'تم تأكيد طلبك!' : 'Order Placed!'),
        content: Text(
          isAr
              ? 'رقم الطلب #$orderId\nاكتسبت +$pointsToEarn نقطة ولاء.'
              : 'Order #$orderId confirmed.\nYou earned +$pointsToEarn loyalty points!',
          textAlign: TextAlign.center,
        ),
        actions: [
          AppPrimaryButton(
            label: isAr ? 'متابعة الطلب' : 'Track Order',
            onPressed: () {
              Navigator.pop(ctx);
              context.go('/orders');
            },
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.isBold = false,
  });

  final String label;
  final String value;
  final Color? valueColor;
  final bool isBold;

  @override
  Widget build(BuildContext context) {
    final style = isBold
        ? Theme.of(context).textTheme.titleMedium
        : Theme.of(context).textTheme.bodyMedium;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text(
            value,
            style: style?.copyWith(
              color: valueColor,
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
