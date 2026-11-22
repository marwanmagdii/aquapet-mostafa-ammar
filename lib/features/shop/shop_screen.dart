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
    final cartCount = ref.watch(cartCountProvider);

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
          AppIconButton(
            icon: PhosphorIcons.slidersHorizontal(),
            tooltip: isAr ? 'تصفية وترتيب' : 'Filter & Sort',
            onPressed: () => _openFilterSheet(context, isAr),
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
                child: AppSearchField(
                  controller: _searchCtrl,
                  hint: isAr
                      ? 'ابحث عن أسماك، طعام، أحواض...'
                      : 'Search fish, food, tanks...',
                  onChanged: (_) => setState(() {}),
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
                          mainAxisExtent: 238,
                        ),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final product = filtered[index];
                          final isFav = favorites.contains(product.id);
                          final imageKey = GlobalKey();
                          return AppCard(
                            onTap: () => context.push('/product/${product.id}'),
                            padding: EdgeInsets.zero,
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
                                      start: 8,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 3,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.92),
                                          borderRadius: BorderRadius.circular(
                                            AppRadii.pill,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              width: 6,
                                              height: 6,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: product.hasStock
                                                    ? colors.success
                                                    : colors.danger,
                                              ),
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              product.hasStock
                                                  ? (isAr ? 'متوفر' : 'In Stock')
                                                  : (isAr ? 'نفد' : 'Out'),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelSmall
                                                  ?.copyWith(
                                                    color: colors.foreground,
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 10,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    PositionedDirectional(
                                      top: 6,
                                      end: 6,
                                      child: Material(
                                        color: Colors.white.withOpacity(0.9),
                                        shape: const CircleBorder(),
                                        child: InkWell(
                                          customBorder: const CircleBorder(),
                                          onTap: () => ref
                                              .read(favoritesProvider.notifier)
                                              .toggle(product.id),
                                          child: Padding(
                                            padding: const EdgeInsets.all(6),
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
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall
                                              ?.copyWith(
                                                fontWeight: FontWeight.w700,
                                              ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          product.isLiveFish
                                              ? (isAr
                                                  ? 'سمك حي • ${product.variants.first.label(isAr)}'
                                                  : 'Live fish • ${product.variants.first.label(isAr)}')
                                              : product.variants.first
                                                  .label(isAr),
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
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
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
                                                      fontWeight:
                                                          FontWeight.w800,
                                                    ),
                                              ),
                                            ),
                                            const SizedBox(width: 6),
                                            Material(
                                              color: colors.primary,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: InkWell(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                onTap: () {
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
                                                      imageUrl:
                                                          product.imageUrl,
                                                      imageAsset: ProductVisuals
                                                          .imageAssetForProduct(
                                                        product,
                                                      ),
                                                      icon: ProductVisuals
                                                          .iconForCategory(
                                                        product.category,
                                                      ),
                                                      gradientColors:
                                                          ProductVisuals
                                                              .colorsForProduct(
                                                        product,
                                                      ),
                                                    ),
                                                    onArrive: () => ref
                                                        .read(
                                                          cartProvider.notifier,
                                                        )
                                                        .addItem(
                                                          product.id,
                                                          product
                                                              .variants.first.id,
                                                        ),
                                                  );
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(7),
                                                  child: Icon(
                                                    PhosphorIcons.plus(),
                                                    size: 16,
                                                    color: colors.onPrimary,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
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
      showDragHandle: true,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isAr ? 'تصفية وترتيب' : 'Filter & Sort',
                    style: Theme.of(ctx).textTheme.titleLarge,
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
                  AppPrimaryButton(
                    label: isAr ? 'تطبيق' : 'Apply',
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
