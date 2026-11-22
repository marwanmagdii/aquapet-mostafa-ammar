import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../core/tokens/app_tokens.dart';
import '../../core/utils/product_visuals.dart';
import '../../data/models/product.dart';
import '../../data/repositories/app_providers.dart';
import '../../shared/widgets/shared_widgets.dart';

enum _ShopSort { featured, priceLowHigh, priceHighLow }

class ShopScreen extends ConsumerStatefulWidget {
  const ShopScreen({super.key, this.initialCategory});

  final String? initialCategory;

  @override
  ConsumerState<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends ConsumerState<ShopScreen>
    with TickerProviderStateMixin {
  final GlobalKey _cartKey = GlobalKey();
  final _searchCtrl = TextEditingController();
  ProductCategory? _selectedCategory;
  bool _inStockOnly = false;
  bool _favoritesOnly = false;
  double _maxPrice = 5000;
  _ShopSort _sort = _ShopSort.featured;

  @override
  void initState() {
    super.initState();
    _syncCategory(widget.initialCategory);
  }

  @override
  void didUpdateWidget(covariant ShopScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialCategory != oldWidget.initialCategory) {
      _syncCategory(widget.initialCategory);
    }
  }

  void _syncCategory(String? raw) {
    if (raw == null || raw.isEmpty) return;
    for (final cat in ProductCategory.values) {
      if (cat.name == raw) {
        _selectedCategory = cat;
        break;
      }
    }
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isAr = ref.watch(localeProvider).languageCode == 'ar';
    final colors = context.appColors;
    final productsAsync = ref.watch(productsProvider);
    final favorites = ref.watch(favoritesProvider);
    final cartItems = ref.watch(cartProvider).valueOrNull ?? const [];
    final cartCount = ref.watch(cartCountProvider);
    final hasActiveFilters =
        _inStockOnly || _maxPrice < 5000 || _sort != _ShopSort.featured;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 64,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isAr ? 'المتجر' : 'Shop',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: isAr ? 0 : -0.4,
                  ),
            ),
            productsAsync.maybeWhen(
              data: (items) => Text(
                isAr ? '${items.length} منتج متاح' : '${items.length} curated items',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colors.mutedForeground,
                    ),
              ),
              orElse: () => const SizedBox.shrink(),
            ),
          ],
        ),
        actions: [
          AppIconButton(
            icon: _favoritesOnly
                ? PhosphorIcons.heart(PhosphorIconsStyle.fill)
                : PhosphorIcons.heart(),
            color: _favoritesOnly ? colors.danger : colors.foreground,
            tooltip: isAr ? 'المفضلة' : 'Favorites',
            onPressed: () => setState(() => _favoritesOnly = !_favoritesOnly),
          ),
          BouncingCartButton(
            key: _cartKey,
            tooltip: isAr ? 'السلة' : 'Cart',
            badgeCount: cartCount,
            onPressed: () => context.push('/cart'),
          ),
          const SizedBox(width: AppSpacing.xs),
        ],
      ),
      body: productsAsync.when(
        loading: () => AppLoadingState(
          message: isAr ? 'جاري تحميل المنتجات...' : 'Loading catalog...',
        ),
        error: (_, __) => AppErrorState(
          message: isAr ? 'تعذر تحميل المتجر' : 'Failed to load shop',
          retryLabel: isAr ? 'إعادة المحاولة' : 'Retry',
          onRetry: () => ref.invalidate(productsProvider),
        ),
        data: (allProducts) {
          final query = _searchCtrl.text.trim().toLowerCase();
          var filtered = allProducts.where((p) {
            if (_selectedCategory != null && p.category != _selectedCategory) {
              return false;
            }
            if (_inStockOnly && !p.hasStock) return false;
            if (_favoritesOnly && !favorites.contains(p.id)) return false;
            if (p.startingPrice > _maxPrice) return false;
            if (query.isNotEmpty) {
              final haystack =
                  '${p.nameEn} ${p.nameAr} ${p.descriptionEn} ${p.descriptionAr}'
                      .toLowerCase();
              if (!haystack.contains(query)) return false;
            }
            return true;
          }).toList();

          switch (_sort) {
            case _ShopSort.featured:
              break;
            case _ShopSort.priceLowHigh:
              filtered.sort((a, b) => a.startingPrice.compareTo(b.startingPrice));
            case _ShopSort.priceHighLow:
              filtered.sort((a, b) => b.startingPrice.compareTo(a.startingPrice));
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  AppSpacing.xs,
                  AppSpacing.md,
                  AppSpacing.sm,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: AppSearchField(
                        controller: _searchCtrl,
                        hint: isAr
                            ? 'ابحث عن أسماك، طعام، أحواض...'
                            : 'Search fish, food, tanks...',
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    _FilterButton(
                      hasActiveFilters: hasActiveFilters,
                      tooltip: isAr ? 'تصفية وترتيب' : 'Filter & Sort',
                      onTap: () => _openFilterSheet(context, isAr),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 44,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.only(end: 8),
                      child: ChoiceChip(
                        label: Text(isAr ? 'الكل' : 'All'),
                        selected: _selectedCategory == null,
                        onSelected: (_) =>
                            setState(() => _selectedCategory = null),
                      ),
                    ),
                    ...ProductCategory.values.map(
                      (cat) => Padding(
                        padding: const EdgeInsetsDirectional.only(end: 8),
                        child: ChoiceChip(
                          label: Text(ProductVisuals.categoryName(cat, isAr)),
                          selected: _selectedCategory == cat,
                          onSelected: (_) =>
                              setState(() => _selectedCategory = cat),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Expanded(
                child: filtered.isEmpty
                    ? AppEmptyState(
                        icon: PhosphorIcons.magnifyingGlass(),
                        title: isAr ? 'لا توجد منتجات مطابقة' : 'No products found',
                        subtitle: isAr
                            ? 'جرب تغيير البحث أو الفلاتر'
                            : 'Try adjusting your search or filters',
                        actionLabel: isAr ? 'إعادة ضبط' : 'Reset Filters',
                        onAction: () => setState(() {
                          _searchCtrl.clear();
                          _selectedCategory = null;
                          _inStockOnly = false;
                          _favoritesOnly = false;
                          _maxPrice = 5000;
                          _sort = _ShopSort.featured;
                        }),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 230,
                          mainAxisSpacing: AppSpacing.md,
                          crossAxisSpacing: AppSpacing.md,
                          mainAxisExtent: 282,
                        ),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final product = filtered[index];
                          final defaultVariant = product.variants.first;
                          final isFav = favorites.contains(product.id);
                          final qtyInCart = cartItems
                              .where(
                                (item) =>
                                    item.productId == product.id &&
                                    item.variantId == defaultVariant.id,
                              )
                              .fold<int>(0, (sum, item) => sum + item.quantity);
                          final imageKey = GlobalKey();
                          return AppCard(
                            onTap: () => context.push('/product/${product.id}'),
                            padding: EdgeInsets.zero,
                            borderColor: qtyInCart > 0
                                ? colors.primary.withOpacity(0.55)
                                : null,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(
                                  children: [
                                    ProductImagePlaceholder(
                                      key: imageKey,
                                      height: 124,
                                      borderRadius: 0,
                                      imageUrl: product.imageUrl,
                                      imageAsset:
                                          ProductVisuals.imageAssetForProduct(
                                        product,
                                      ),
                                      icon: ProductVisuals.iconForCategory(
                                        product.category,
                                      ),
                                      gradientColors:
                                          ProductVisuals.colorsForProduct(
                                        product,
                                      ),
                                    ),
                                    PositionedDirectional(
                                      top: 8,
                                      end: 8,
                                      child: Material(
                                        color: Colors.white.withOpacity(0.92),
                                        elevation: 1,
                                        shape: const CircleBorder(),
                                        child: InkWell(
                                          customBorder: const CircleBorder(),
                                          onTap: () => ref
                                              .read(favoritesProvider.notifier)
                                              .toggle(product.id),
                                          child: Padding(
                                            padding: const EdgeInsets.all(7),
                                            child: Icon(
                                              isFav
                                                  ? PhosphorIcons.heart(
                                                      PhosphorIconsStyle.fill,
                                                    )
                                                  : PhosphorIcons.heart(),
                                              color: isFav
                                                  ? colors.danger
                                                  : colors.foreground,
                                              size: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                      10,
                                      8,
                                      10,
                                      10,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product.name(isAr),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall
                                              ?.copyWith(
                                                fontWeight: FontWeight.w700,
                                                height: 1.2,
                                              ),
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          product.isLiveFish
                                              ? (isAr
                                                  ? 'سمك حي • ${defaultVariant.label(isAr)}'
                                                  : 'Live fish • ${defaultVariant.label(isAr)}')
                                              : defaultVariant.label(isAr),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelSmall
                                              ?.copyWith(
                                                color: product.isLiveFish
                                                    ? colors.warning
                                                    : colors.mutedForeground,
                                              ),
                                        ),
                                        const Spacer(),
                                        Text(
                                          ProductVisuals.formatEgp(
                                            product.startingPrice,
                                            isAr,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall
                                              ?.copyWith(
                                                color: colors.primary,
                                                fontWeight: FontWeight.w800,
                                                fontSize: 15,
                                              ),
                                        ),
                                        const SizedBox(height: 8),
                                        _AddOrStepperButton(
                                          qty: qtyInCart,
                                          isAr: isAr,
                                          onAddFirst: () {
                                            FlyToCartAnimation.run(
                                              context: context,
                                              sourceKey: imageKey,
                                              targetKey: _cartKey,
                                              vsync: this,
                                              flyingChild:
                                                  ProductImagePlaceholder(
                                                height: 72,
                                                width: 72,
                                                borderRadius: AppRadii.md,
                                                imageUrl: product.imageUrl,
                                                imageAsset: ProductVisuals
                                                    .imageAssetForProduct(
                                                  product,
                                                ),
                                                icon: ProductVisuals
                                                    .iconForCategory(
                                                  product.category,
                                                ),
                                                gradientColors: ProductVisuals
                                                    .colorsForProduct(
                                                  product,
                                                ),
                                              ),
                                              onArrive: () => ref
                                                  .read(cartProvider.notifier)
                                                  .addItem(
                                                    product.id,
                                                    defaultVariant.id,
                                                  ),
                                            );
                                          },
                                          onIncrement: () => ref
                                              .read(cartProvider.notifier)
                                              .addItem(
                                                product.id,
                                                defaultVariant.id,
                                              ),
                                          onDecrement: () => ref
                                              .read(cartProvider.notifier)
                                              .updateQuantity(
                                                product.id,
                                                defaultVariant.id,
                                                qtyInCart - 1,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _openFilterSheet(BuildContext context, bool isAr) {
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isAr ? 'تصفية وترتيب' : 'Filter & Sort',
                          style: Theme.of(ctx).textTheme.titleLarge,
                        ),
                        TextButton(
                          onPressed: () {
                            setModalState(() {
                              _inStockOnly = false;
                              _maxPrice = 5000;
                              _sort = _ShopSort.featured;
                              _selectedCategory = null;
                              _favoritesOnly = false;
                            });
                            setState(() {});
                          },
                          child: Text(isAr ? 'إعادة ضبط' : 'Reset'),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(isAr ? 'المتوفر فقط' : 'In stock only'),
                      value: _inStockOnly,
                      onChanged: (v) {
                        setModalState(() => _inStockOnly = v);
                        setState(() {});
                      },
                    ),
                    Text(
                      isAr
                          ? 'الحد الأقصى للسعر: ${_maxPrice.toInt()} ج.م'
                          : 'Max price: ${_maxPrice.toInt()} EGP',
                    ),
                    Slider(
                      min: 100,
                      max: 5000,
                      divisions: 49,
                      value: _maxPrice,
                      onChanged: (v) {
                        setModalState(() => _maxPrice = v);
                        setState(() {});
                      },
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      isAr ? 'الترتيب' : 'Sort by',
                      style: Theme.of(ctx).textTheme.titleSmall,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Wrap(
                      spacing: 8,
                      children: [
                        ChoiceChip(
                          label: Text(isAr ? 'المميز' : 'Featured'),
                          selected: _sort == _ShopSort.featured,
                          onSelected: (_) {
                            setModalState(() => _sort = _ShopSort.featured);
                            setState(() {});
                          },
                        ),
                        ChoiceChip(
                          label: Text(isAr ? 'الأقل سعراً' : 'Price: Low-High'),
                          selected: _sort == _ShopSort.priceLowHigh,
                          onSelected: (_) {
                            setModalState(() => _sort = _ShopSort.priceLowHigh);
                            setState(() {});
                          },
                        ),
                        ChoiceChip(
                          label: Text(isAr ? 'الأعلى سعراً' : 'Price: High-Low'),
                          selected: _sort == _ShopSort.priceHighLow,
                          onSelected: (_) {
                            setModalState(() => _sort = _ShopSort.priceHighLow);
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Row(
                      children: [
                        Expanded(
                          child: AppSecondaryButton(
                            label: isAr ? 'إعادة ضبط' : 'Reset',
                            onPressed: () {
                              setModalState(() {
                                _inStockOnly = false;
                                _maxPrice = 5000;
                                _sort = _ShopSort.featured;
                                _selectedCategory = null;
                                _favoritesOnly = false;
                              });
                              setState(() {});
                            },
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          flex: 2,
                          child: AppPrimaryButton(
                            label: isAr ? 'تطبيق' : 'Apply',
                            onPressed: () => Navigator.pop(ctx),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _FilterButton extends StatelessWidget {
  const _FilterButton({
    required this.hasActiveFilters,
    required this.tooltip,
    required this.onTap,
  });

  final bool hasActiveFilters;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Tooltip(
      message: tooltip,
      child: Material(
        color: hasActiveFilters
            ? colors.primary.withOpacity(0.10)
            : colors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.lg),
          side: BorderSide(
            color: hasActiveFilters ? colors.primary : colors.border,
            width: hasActiveFilters ? 1.5 : 1,
          ),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadii.lg),
          child: SizedBox(
            width: 48,
            height: 48,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  PhosphorIcons.slidersHorizontal(),
                  size: 20,
                  color: hasActiveFilters ? colors.primary : colors.foreground,
                ),
                if (hasActiveFilters)
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: colors.accent,
                        shape: BoxShape.circle,
                        border: Border.all(color: colors.surface, width: 1.5),
                      ),
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

class _AddOrStepperButton extends StatelessWidget {
  const _AddOrStepperButton({
    required this.qty,
    required this.isAr,
    required this.onAddFirst,
    required this.onIncrement,
    required this.onDecrement,
  });

  final int qty;
  final bool isAr;
  final VoidCallback onAddFirst;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 220),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      child: qty <= 0
          ? SizedBox(
              key: const ValueKey('add_btn'),
              width: double.infinity,
              height: 38,
              child: Material(
                color: colors.primary,
                borderRadius: BorderRadius.circular(AppRadii.pill),
                child: InkWell(
                  onTap: onAddFirst,
                  borderRadius: BorderRadius.circular(AppRadii.pill),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        PhosphorIcons.plus(PhosphorIconsStyle.bold),
                        size: 15,
                        color: colors.onPrimary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        isAr ? 'أضف للسلة' : 'Add',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: colors.onPrimary,
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : Container(
              key: const ValueKey('stepper_btn'),
              height: 38,
              padding: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: colors.primary.withOpacity(0.10),
                borderRadius: BorderRadius.circular(AppRadii.pill),
                border: Border.all(
                  color: colors.primary.withOpacity(0.45),
                  width: 1.2,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Material(
                    color: Colors.transparent,
                    shape: const CircleBorder(),
                    child: InkWell(
                      onTap: onDecrement,
                      customBorder: const CircleBorder(),
                      child: SizedBox(
                        width: 32,
                        height: 32,
                        child: Icon(
                          qty == 1
                              ? PhosphorIcons.trash()
                              : PhosphorIcons.minus(PhosphorIconsStyle.bold),
                          size: 15,
                          color: qty == 1 ? colors.danger : colors.primary,
                        ),
                      ),
                    ),
                  ),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 160),
                    child: Text(
                      '$qty',
                      key: ValueKey(qty),
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: colors.primary,
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                  ),
                  Material(
                    color: colors.primary,
                    shape: const CircleBorder(),
                    child: InkWell(
                      onTap: onIncrement,
                      customBorder: const CircleBorder(),
                      child: SizedBox(
                        width: 30,
                        height: 30,
                        child: Icon(
                          PhosphorIcons.plus(PhosphorIconsStyle.bold),
                          size: 15,
                          color: colors.onPrimary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
