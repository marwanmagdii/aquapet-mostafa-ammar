import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../core/tokens/app_tokens.dart';
import '../../core/utils/product_visuals.dart';
import '../../data/models/product.dart';
import '../../data/models/reminder_tank.dart';
import '../../data/repositories/app_providers.dart';
import '../../shared/widgets/shared_widgets.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  const ProductDetailScreen({super.key, required this.productId});

  final String productId;

  @override
  ConsumerState<ProductDetailScreen> createState() =>
      _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen>
    with TickerProviderStateMixin {
  final GlobalKey _cartKey = GlobalKey();
  final GlobalKey _heroImageKey = GlobalKey();
  int _selectedVariantIndex = 0;
  int _quantity = 1;
  bool _remindReorder = true;

  @override
  Widget build(BuildContext context) {
    final isAr = ref.watch(localeProvider).languageCode == 'ar';
    final colors = context.appColors;
    final productsAsync = ref.watch(productsProvider);
    final favorites = ref.watch(favoritesProvider);

    return productsAsync.when(
      loading: () => const Scaffold(body: AppLoadingState()),
      error: (_, __) => Scaffold(
        appBar: AppBar(),
        body: AppErrorState(
          message: isAr ? 'تعذر تحميل المنتج' : 'Could not load product',
          retryLabel: isAr ? 'إعادة' : 'Retry',
          onRetry: () => ref.invalidate(productsProvider),
        ),
      ),
      data: (products) {
        final product = products.cast<Product?>().firstWhere(
              (p) => p?.id == widget.productId,
              orElse: () => null,
            );
        if (product == null) {
          return Scaffold(
            appBar: AppBar(),
            body: AppEmptyState(
              icon: PhosphorIcons.fishSimple(),
              title: isAr ? 'المنتج غير موجود' : 'Product not found',
              subtitle: isAr ? 'ربما تم حذفه' : 'It may have been removed',
              actionLabel: isAr ? 'العودة للمتجر' : 'Back to Shop',
              onAction: () => context.go('/shop'),
            ),
          );
        }

        final variant = product.variants[
            _selectedVariantIndex.clamp(0, product.variants.length - 1)];
        final isFav = favorites.contains(product.id);
        final isFood = product.category == ProductCategory.food;

        return Scaffold(
          appBar: AppBar(
            actions: [
              AppIconButton(
                icon: isFav
                    ? PhosphorIcons.heart(PhosphorIconsStyle.fill)
                    : PhosphorIcons.heart(),
                color: isFav ? colors.danger : colors.foreground,
                tooltip: isAr ? 'المفضلة' : 'Favorite',
                onPressed: () =>
                    ref.read(favoritesProvider.notifier).toggle(product.id),
              ),
              BouncingCartButton(
                key: _cartKey,
                tooltip: isAr ? 'السلة' : 'Cart',
                badgeCount: ref.watch(cartCountProvider),
                onPressed: () => context.push('/cart'),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: [
              ProductImagePlaceholder(
                key: _heroImageKey,
                height: 230,
                iconSize: 76,
                borderRadius: AppRadii.xl,
                imageUrl: product.imageUrl,
                imageAsset: ProductVisuals.imageAssetForProduct(product),
                icon: ProductVisuals.iconForCategory(product.category),
                gradientColors: ProductVisuals.colorsForProduct(product),
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  AppBadge(
                    label:
                        ProductVisuals.categoryName(product.category, isAr),
                    tone: AppBadgeTone.primary,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  AppBadge(
                    label: variant.stock > 0
                        ? (isAr
                            ? 'متوفر (${variant.stock})'
                            : 'In Stock (${variant.stock})')
                        : (isAr ? 'غير متوفر' : 'Out of Stock'),
                    tone: variant.stock > 0
                        ? AppBadgeTone.success
                        : AppBadgeTone.danger,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                product.name(isAr),
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 6),
              Text(
                ProductVisuals.formatEgp(variant.priceEgp, isAr),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: colors.primary,
                    ),
              ),

              if (product.isLiveFish) ...[
                const SizedBox(height: AppSpacing.md),
                AppCard(
                  backgroundColor: colors.warningSurface,
                  borderColor: colors.warning.withOpacity(0.45),
                  child: Row(
                    children: [
                      Icon(PhosphorIcons.info(), color: colors.warning),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          isAr
                              ? 'أسماك حية: استلام من الفرع أو توصيل بعناية فائقة'
                              : 'Live fish: pickup or careful delivery',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: AppSpacing.lg),
              Text(
                isAr ? 'اختر الحجم / النوع' : 'Select Variant',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: List.generate(product.variants.length, (i) {
                  final v = product.variants[i];
                  return ChoiceChip(
                    label: Text(v.label(isAr)),
                    selected: i == _selectedVariantIndex,
                    onSelected: (_) =>
                        setState(() => _selectedVariantIndex = i),
                  );
                }),
              ),

              if (isFood) ...[
                const SizedBox(height: AppSpacing.lg),
                AppCard(
                  backgroundColor: colors.primary.withOpacity(0.06),
                  borderColor: colors.primary.withOpacity(0.25),
                  child: SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    secondary: Icon(
                      PhosphorIcons.bellRinging(),
                      color: colors.primary,
                    ),
                    title: Text(
                      isAr
                          ? 'ذكرني بإعادة الطلب قبل النفاد'
                          : 'Remind me to reorder',
                    ),
                    subtitle: Text(
                      isAr
                          ? 'يحسب المدة التقديرية لنفاد العبوة تلقائياً'
                          : 'Auto-estimates when this bag runs out',
                    ),
                    value: _remindReorder,
                    onChanged: (v) => setState(() => _remindReorder = v),
                  ),
                ),
              ],

              const SizedBox(height: AppSpacing.lg),
              Text(
                isAr ? 'الوصف' : 'Description',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                product.description(isAr),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colors.mutedForeground,
                      height: 1.5,
                    ),
              ),

              const SizedBox(height: AppSpacing.lg),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          PhosphorIcons.sparkle(),
                          color: colors.primary,
                          size: 20,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          isFood
                              ? (isAr ? 'نصائح التغذية' : 'Feeding Tips')
                              : (isAr ? 'نصائح العناية' : 'Care Tips'),
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      product.careTips(isAr),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: colors.mutedForeground,
                            height: 1.5,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
          bottomNavigationBar: SafeArea(
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: colors.surface,
                border: Border(top: BorderSide(color: colors.border)),
              ),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: colors.border),
                      borderRadius: BorderRadius.circular(AppRadii.md),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          constraints: const BoxConstraints(
                            minWidth: 44,
                            minHeight: 44,
                          ),
                          icon: Icon(PhosphorIcons.minus(), size: 18),
                          onPressed: _quantity > 1
                              ? () => setState(() => _quantity--)
                              : null,
                        ),
                        Text(
                          '$_quantity',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        IconButton(
                          constraints: const BoxConstraints(
                            minWidth: 44,
                            minHeight: 44,
                          ),
                          icon: Icon(PhosphorIcons.plus(), size: 18),
                          onPressed: () => setState(() => _quantity++),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: AppPrimaryButton(
                      label:
                          '${isAr ? 'أضف للسلة' : 'Add to Cart'} • ${ProductVisuals.formatEgp(variant.priceEgp * _quantity, isAr)}',
                      onPressed: variant.stock <= 0
                          ? null
                          : () {
                              FlyToCartAnimation.run(
                                context: context,
                                sourceKey: _heroImageKey,
                                targetKey: _cartKey,
                                vsync: this,
                                flyingChild: ProductImagePlaceholder(
                                  height: 72,
                                  width: 72,
                                  borderRadius: AppRadii.md,
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
                                onArrive: () async {
                                  await ref.read(cartProvider.notifier).addItem(
                                        product.id,
                                        variant.id,
                                        qty: _quantity,
                                      );
                                  if (isFood && _remindReorder) {
                                    final now = ref.read(appNowProvider);
                                    await ref
                                        .read(remindersProvider.notifier)
                                        .addReminder(
                                          ReminderModel(
                                            id: 'rem_${now.microsecondsSinceEpoch}',
                                            type: ReminderType.foodRunOut,
                                            titleEn:
                                                '${product.nameEn} (${variant.labelEn})',
                                            titleAr:
                                                '${product.nameAr} (${variant.labelAr})',
                                            isEnabled: true,
                                            createdAt: now,
                                            productId: product.id,
                                            bagGrams: (variant.grams ?? 100) *
                                                _quantity,
                                            dailyGrams: 3.5,
                                          ),
                                        );
                                  }
                                },
                              );
                            },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
