import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../core/tokens/app_tokens.dart';
import '../../core/utils/product_visuals.dart';
import '../../data/models/cart_order.dart';
import '../../data/repositories/app_providers.dart';
import '../../shared/widgets/shared_widgets.dart';

class OrdersScreen extends ConsumerWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAr = ref.watch(localeProvider).languageCode == 'ar';
    final colors = context.appColors;
    final ordersAsync = ref.watch(ordersProvider);

    return Scaffold(
      appBar: AppBar(title: Text(isAr ? 'طلباتي' : 'My Orders')),
      body: ordersAsync.when(
        loading: () => const AppLoadingState(),
        error: (_, __) => AppErrorState(
          message: isAr ? 'تعذر تحميل الطلبات' : 'Failed to load orders',
          retryLabel: isAr ? 'إعادة' : 'Retry',
          onRetry: () => ref.read(ordersProvider.notifier).load(),
        ),
        data: (orders) {
          if (orders.isEmpty) {
            return AppEmptyState(
              icon: PhosphorIcons.package(),
              title: isAr ? 'لا توجد طلبات بعد' : 'No orders yet',
              subtitle: isAr
                  ? 'ستظهر طلباتك وحالتها هنا'
                  : 'Your past and active orders will appear here',
              actionLabel: isAr ? 'تسوق الآن' : 'Start Shopping',
              onAction: () => context.go('/shop'),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: orders.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
            itemBuilder: (context, index) {
              final order = orders[index];
              final steps = order.fulfillmentType == FulfillmentType.pickup
                  ? [
                      OrderStatus.received,
                      OrderStatus.preparing,
                      OrderStatus.readyForPickup,
                      OrderStatus.delivered,
                    ]
                  : [
                      OrderStatus.received,
                      OrderStatus.preparing,
                      OrderStatus.outForDelivery,
                      OrderStatus.delivered,
                    ];
              final currentStep = steps.indexOf(order.status);

              return AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '#${order.id}',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        AppBadge(
                          label: _statusLabel(order.status, isAr),
                          tone: order.status == OrderStatus.delivered
                              ? AppBadgeTone.success
                              : AppBadgeTone.primary,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat.yMMMd(isAr ? 'ar' : 'en')
                          .format(order.createdAt),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: colors.mutedForeground,
                          ),
                    ),
                    const Divider(height: 20),
                    ...order.items.map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                '${item.quantity}x ${isAr ? item.nameAr : item.nameEn} (${isAr ? item.variantLabelAr : item.variantLabelEn})',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                            Text(
                              ProductVisuals.formatEgp(
                                item.unitPriceEgp * item.quantity,
                                isAr,
                              ),
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    // Timeline
                    Row(
                      children: List.generate(steps.length, (i) {
                        final active = i <= currentStep;
                        return Expanded(
                          child: Container(
                            margin: const EdgeInsetsDirectional.only(end: 4),
                            height: 6,
                            decoration: BoxDecoration(
                              color: active ? colors.primary : colors.muted,
                              borderRadius:
                                  BorderRadius.circular(AppRadii.pill),
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${isAr ? 'الإجمالي:' : 'Total:'} ${ProductVisuals.formatEgp(order.totalEgp, isAr)}',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        Row(
                          children: [
                            if (order.status != OrderStatus.delivered)
                              TextButton(
                                onPressed: () => ref
                                    .read(ordersProvider.notifier)
                                    .advanceStatus(order.id),
                                child: Text(
                                  isAr ? 'تحديث الحالة' : 'Advance',
                                ),
                              ),
                            const SizedBox(width: 4),
                            AppSecondaryButton(
                              label: isAr ? 'إعادة الطلب' : 'Reorder',
                              onPressed: () async {
                                for (final item in order.items) {
                                  await ref.read(cartProvider.notifier).addItem(
                                        item.productId,
                                        item.variantId,
                                        qty: item.quantity,
                                      );
                                }
                                if (context.mounted) context.push('/cart');
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _statusLabel(OrderStatus status, bool isAr) => switch (status) {
        OrderStatus.received => isAr ? 'تم الاستلام' : 'Received',
        OrderStatus.preparing => isAr ? 'جاري التجهيز' : 'Preparing',
        OrderStatus.outForDelivery => isAr ? 'في الطريق' : 'Out for Delivery',
        OrderStatus.readyForPickup =>
          isAr ? 'جاهز للاستلام' : 'Ready for Pickup',
        OrderStatus.delivered => isAr ? 'تم التسليم' : 'Delivered',
      };
}
