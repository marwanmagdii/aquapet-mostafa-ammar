import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/tokens/app_tokens.dart';
import '../../core/utils/product_visuals.dart';
import '../../data/models/product.dart';
import '../../data/models/reminder_tank.dart';
import '../../data/repositories/app_providers.dart';
import '../../shared/widgets/shared_widgets.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with TickerProviderStateMixin {
  final GlobalKey _cartKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final isAr = ref.watch(localeProvider).languageCode == 'ar';
    final colors = context.appColors;
    final userAsync = ref.watch(userProvider);
    final productsAsync = ref.watch(productsProvider);
    final remindersAsync = ref.watch(remindersProvider);
    final ordersAsync = ref.watch(ordersProvider);
    final cartCount = ref.watch(cartCountProvider);
    final now = ref.watch(appNowProvider);

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 56,
        leading: Padding(
          padding: const EdgeInsetsDirectional.only(start: AppSpacing.md),
          child: Center(
            child: ClipOval(
              child: Image.asset(
                'assets/images/app_logo.webp',
                width: 38,
                height: 38,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        title: userAsync.when(
          data: (user) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isAr ? 'أهلاً، ${user.name}' : 'Good day, ${user.name}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Text(
                isAr ? 'موسم هادئ لحوضك اليوم' : 'Calm water, happy fish',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colors.mutedForeground,
                    ),
              ),
            ],
          ),
          loading: () => const Text('AquaPet'),
          error: (_, __) => const Text('AquaPet'),
        ),
        actions: [
          AppIconButton(
            icon: PhosphorIcons.bookOpenText(),
            tooltip: AppLocalizations.of(context)!.blogTitle,
            onPressed: () => context.push('/blog'),
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
          message: isAr ? 'جاري تحضير المتجر...' : 'Loading AquaPet...',
        ),
        error: (err, _) => AppErrorState(
          message: isAr ? 'تعذر تحميل المنتجات' : 'Could not load products',
          retryLabel: isAr ? 'إعادة المحاولة' : 'Retry',
          onRetry: () => ref.invalidate(productsProvider),
        ),
        data: (products) {
          final lowFoodReminders = (remindersAsync.valueOrNull ?? const [])
              .where(
                (r) =>
                    r.isEnabled &&
                    r.type == ReminderType.foodRunOut &&
                    r.daysLeftAt(now) <= 5,
              )
              .toList();

          final bestSellers = products.where((p) => p.isBestSeller).toList();
          final newArrivals = products.where((p) => p.isNewArrival).toList();
          final orders = ordersAsync.valueOrNull ?? const [];

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(productsProvider);
              await ref.read(loyaltyProvider.notifier).load();
            },
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.md),
              children: [
                // 1. Horizontal Scrollable Ad Banner Carousel
                _AdBannerCarousel(isAr: isAr),

                // 2. Categories Row
                const SizedBox(height: AppSpacing.lg),
                _SectionHeader(
                  title: isAr ? 'التصنيفات' : 'Categories',
                  actionLabel: isAr ? 'الكل' : 'See all',
                  onAction: () => context.go('/shop'),
                ),
                const SizedBox(height: AppSpacing.sm),
                SizedBox(
                  height: 92,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: ProductCategory.values.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(width: AppSpacing.sm),
                    itemBuilder: (context, index) {
                      final cat = ProductCategory.values[index];
                      final catColor = ProductVisuals.colorForCategory(cat);
                      return AppCard(
                        onTap: () => context.go('/shop?cat=${cat.name}'),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                        child: SizedBox(
                          width: 78,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                  color: catColor.withOpacity(0.14),
                                  borderRadius:
                                      BorderRadius.circular(AppRadii.md),
                                ),
                                child: Icon(
                                  ProductVisuals.iconForCategory(cat),
                                  color: catColor,
                                  size: 22,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                ProductVisuals.categoryName(cat, isAr),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // 5. Best Sellers
                const SizedBox(height: AppSpacing.lg),
                _SectionHeader(
                  title: isAr ? 'الأكثر مبيعاً' : 'Best Sellers',
                  actionLabel: isAr ? 'تسوق' : 'Shop',
                  onAction: () => context.go('/shop'),
                ),
                const SizedBox(height: AppSpacing.sm),
                SizedBox(
                  height: 214,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: bestSellers.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(width: AppSpacing.sm),
                    itemBuilder: (context, index) => _HorizontalProductCard(
                      product: bestSellers[index],
                      isAr: isAr,
                      cartKey: _cartKey,
                      vsync: this,
                      onTap: () =>
                          context.push('/product/${bestSellers[index].id}'),
                    ),
                  ),
                ),

                // 6. New Arrivals
                if (newArrivals.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.lg),
                  _SectionHeader(
                    title: isAr ? 'وصل حديثاً' : 'New Arrivals',
                    actionLabel: isAr ? 'تسوق' : 'Shop',
                    onAction: () => context.go('/shop'),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  SizedBox(
                    height: 214,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: newArrivals.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(width: AppSpacing.sm),
                      itemBuilder: (context, index) => _HorizontalProductCard(
                        product: newArrivals[index],
                        isAr: isAr,
                        cartKey: _cartKey,
                        vsync: this,
                        onTap: () =>
                            context.push('/product/${newArrivals[index].id}'),
                      ),
                    ),
                  ),
                ],

                // 7. Quick Reorder from Past Orders
                if (orders.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.lg),
                  _SectionHeader(
                    title: isAr ? 'أعد الطلب سريعاً' : 'Quick Reorder',
                    actionLabel: isAr ? 'طلباتي' : 'Orders',
                    onAction: () => context.push('/orders'),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  ...orders.take(2).map(
                        (order) => Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                          child: AppCard(
                            onTap: () => context.push('/orders'),
                            child: Row(
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: colors.muted,
                                    borderRadius:
                                        BorderRadius.circular(AppRadii.md),
                                  ),
                                  child: Icon(
                                    PhosphorIcons.package(),
                                    color: colors.primary,
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.md),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '#${order.id} • ${ProductVisuals.formatEgp(order.totalEgp, isAr)}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall,
                                      ),
                                      Text(
                                        order.items
                                            .map((i) => isAr
                                                ? i.nameAr
                                                : i.nameEn)
                                            .join(', '),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
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
                                AppSecondaryButton(
                                  label: isAr ? 'إعادة' : 'Reorder',
                                  onPressed: () async {
                                    for (final item in order.items) {
                                      await ref
                                          .read(cartProvider.notifier)
                                          .addItem(
                                            item.productId,
                                            item.variantId,
                                            qty: item.quantity,
                                          );
                                    }
                                    if (context.mounted) {
                                      context.push('/cart');
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                ],
                // Quick Glance Strip (Loyalty + My Tank), Vets, Blog & Low Food Alert
                const SizedBox(height: AppSpacing.lg),
                _QuickGlanceStrip(isAr: isAr),
                const SizedBox(height: AppSpacing.sm),
                _TrustedVetsHomeCard(isAr: isAr),
                const SizedBox(height: AppSpacing.sm),
                _CareBlogHomeCard(isAr: isAr),
                if (lowFoodReminders.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.md),
                  _RunningLowAlert(
                    reminder: lowFoodReminders.first,
                    daysLeft: lowFoodReminders.first.daysLeftAt(now),
                    isAr: isAr,
                    onReorder: () {
                      final pid = lowFoodReminders.first.productId;
                      if (pid != null) {
                        context.push('/product/$pid');
                      } else {
                        context.go('/reminders');
                      }
                    },
                  ),
                ],
                const SizedBox(height: AppSpacing.md),
                _FollowShopSocialCard(isAr: isAr),
                const SizedBox(height: AppSpacing.xl),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _RunningLowAlert extends StatelessWidget {
  const _RunningLowAlert({
    required this.reminder,
    required this.daysLeft,
    required this.isAr,
    required this.onReorder,
  });

  final ReminderModel reminder;
  final int daysLeft;
  final bool isAr;
  final VoidCallback onReorder;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return AppCard(
      backgroundColor: colors.warningSurface,
      borderColor: colors.warning.withOpacity(0.4),
      child: Row(
        children: [
          Icon(PhosphorIcons.warning(), color: colors.warning, size: 26),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  reminder.title(isAr),
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Text(
                  isAr
                      ? 'متبقي حوالي $daysLeft أيام قبل النفاد'
                      : 'Running low: about $daysLeft days left',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          FilledButton(
            onPressed: onReorder,
            style: FilledButton.styleFrom(
              backgroundColor: colors.accent,
              foregroundColor: colors.onAccent,
              minimumSize: const Size(48, 40),
              padding: const EdgeInsets.symmetric(horizontal: 14),
            ),
            child: Text(isAr ? 'اطلب' : 'Reorder'),
          ),
        ],
      ),
    );
  }
}

class _AdBannerCarousel extends StatefulWidget {
  const _AdBannerCarousel({required this.isAr});

  final bool isAr;

  @override
  State<_AdBannerCarousel> createState() => _AdBannerCarouselState();
}

class _AdBannerCarouselState extends State<_AdBannerCarousel> {
  final PageController _controller = PageController(viewportFraction: 0.92);
  int _index = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isAr = widget.isAr;
    final colors = context.appColors;

    final ads = [
      (
        badge: isAr ? 'عرض خاص' : 'LIMITED OFFER',
        title: isAr ? 'خصم ٢٠٪ بكود FISH20' : '20% Off with FISH20',
        subtitle: isAr
            ? 'على طعام الأسماك والنباتات والفلاتر'
            : 'On fish food, live plants & filters',
        image: 'assets/images/banners/banner_1_offer.jpg',
        gradient: [colors.loyaltyGradientStart, colors.loyaltyGradientEnd],
        route: '/rewards',
      ),
      (
        badge: isAr ? 'وصل حديثاً' : 'NEW ARRIVALS',
        title: isAr ? 'أسماك البيتا والنيون تترا' : 'Betta & Neon Tetra Drop',
        subtitle: isAr
            ? 'توصيل آمن بعناية فائقة داخل القاهرة'
            : 'Careful live-fish delivery across Cairo',
        image: 'assets/images/banners/banner_2_betta.jpg',
        gradient: [const Color(0xFF0284C7), const Color(0xFF0D9488)],
        route: '/shop?cat=fish',
      ),
      (
        badge: isAr ? 'بطاقة الأختام' : 'STAMP CARD',
        title: isAr ? 'اشترِ ١٠ واحصل على ١ مجاناً' : 'Buy 10 Food Bags, Get 1 Free',
        subtitle: isAr
            ? 'اجمع أختامك مع كل طلب طعام أسماك'
            : 'Earn a free bag stamp on every food order',
        image: 'assets/images/banners/banner_3_stamps.jpg',
        gradient: [const Color(0xFFEA580C), const Color(0xFFD97706)],
        route: '/rewards',
      ),
      (
        badge: isAr ? 'أحواض كاملة' : 'AQUASCAPE',
        title: isAr ? 'أطقم أحواض وإضاءة LED' : 'Rimless Tanks & LED Kits',
        subtitle: isAr
            ? 'ابدأ حوضك الأول واحصل على ١٠٠ نقطة'
            : 'Start your tank & earn +100 bonus points',
        image: 'assets/images/banners/banner_4_tanks.jpg',
        gradient: [const Color(0xFF0F766E), const Color(0xFF059669)],
        route: '/shop?cat=tanks',
      ),
    ];

    return Column(
      children: [
        SizedBox(
          height: 154,
          child: PageView.builder(
            controller: _controller,
            padEnds: false,
            itemCount: ads.length,
            onPageChanged: (i) => setState(() => _index = i),
            itemBuilder: (context, i) {
              final ad = ads[i];
              return Padding(
                padding: const EdgeInsetsDirectional.only(end: AppSpacing.sm),
                child: Material(
                  borderRadius: BorderRadius.circular(AppRadii.xl),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () => context.go(ad.route),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(
                          ad.image,
                          fit: BoxFit.cover,
                        ),
                        DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: AlignmentDirectional.centerStart,
                              end: AlignmentDirectional.centerEnd,
                              colors: [
                                Colors.black.withOpacity(0.62),
                                Colors.black.withOpacity(0.36),
                                Colors.black.withOpacity(0.05),
                              ],
                              stops: const [0.0, 0.55, 1.0],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          child: FractionallySizedBox(
                            alignment: AlignmentDirectional.centerStart,
                            widthFactor: 0.72,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.38),
                                    borderRadius:
                                        BorderRadius.circular(AppRadii.pill),
                                  ),
                                  child: Text(
                                    ad.badge,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                        ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  ad.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  ad.subtitle,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: Colors.white.withOpacity(0.92),
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            ads.length,
            (i) => AnimatedContainer(
              duration: AppDurations.fast,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: _index == i ? 20 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: _index == i ? colors.primary : colors.border,
                borderRadius: BorderRadius.circular(AppRadii.pill),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.actionLabel,
    required this.onAction,
  });

  final String title;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        TextButton(onPressed: onAction, child: Text(actionLabel)),
      ],
    );
  }
}

class _FollowShopSocialCard extends StatelessWidget {
  const _FollowShopSocialCard({required this.isAr});

  final bool isAr;

  @override
  Widget build(BuildContext context) {
    final socials = [
      (
        icon: PhosphorIcons.youtubeLogo(PhosphorIconsStyle.fill),
        color: const Color(0xFFDC2626),
        label: 'YouTube',
        url: 'https://www.youtube.com/@Mostafa.3mmar',
      ),
      (
        icon: PhosphorIcons.facebookLogo(PhosphorIconsStyle.fill),
        color: const Color(0xFF1877F2),
        label: 'Facebook',
        url: 'https://www.facebook.com/darsh.ammar1',
      ),
      (
        icon: PhosphorIcons.instagramLogo(PhosphorIconsStyle.fill),
        color: const Color(0xFFE4405F),
        label: 'Instagram',
        url: 'https://www.instagram.com/darshammar/reels/',
      ),
      (
        icon: PhosphorIcons.tiktokLogo(PhosphorIconsStyle.fill),
        color: const Color(0xFF0F172A),
        label: 'TikTok',
        url: 'https://www.tiktok.com/discover/mostafa-ammar',
      ),
    ];

    return AppCard(
      child: Row(
        children: [
          ClipOval(
            child: Image.asset(
              'assets/images/app_logo.webp',
              width: 40,
              height: 40,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              isAr ? 'تابع مصطفى عمار' : 'Follow Mostafa Ammar',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          ...socials.map(
            (s) => Padding(
              padding: const EdgeInsetsDirectional.only(start: 4),
              child: Tooltip(
                message: s.label,
                child: Material(
                  color: s.color.withOpacity(0.10),
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () => launchUrl(
                      Uri.parse(s.url),
                      mode: LaunchMode.externalApplication,
                    ),
                    child: SizedBox(
                      width: 40,
                      height: 40,
                      child: Icon(s.icon, color: s.color, size: 20),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CareBlogHomeCard extends StatelessWidget {
  const _CareBlogHomeCard({required this.isAr});

  final bool isAr;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.appColors;
    return AppCard(
      onTap: () => context.push('/blog'),
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: colors.primary.withOpacity(0.12),
              borderRadius: BorderRadius.circular(AppRadii.md),
            ),
            child: Icon(
              PhosphorIcons.bookOpenText(),
              color: colors.primary,
              size: 22,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.blogTitle,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 2),
                Text(
                  l10n.blogSubtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colors.mutedForeground,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Icon(
            isAr ? PhosphorIcons.caretLeft() : PhosphorIcons.caretRight(),
            color: colors.mutedForeground,
          ),
        ],
      ),
    );
  }
}

class _TrustedVetsHomeCard extends StatelessWidget {
  const _TrustedVetsHomeCard({required this.isAr});

  final bool isAr;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.appColors;
    return AppCard(
      onTap: () => context.push('/vets'),
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: colors.successSurface,
              borderRadius: BorderRadius.circular(AppRadii.md),
            ),
            child: Icon(
              PhosphorIcons.stethoscope(),
              color: colors.success,
              size: 22,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.trustedVetsTitle,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 2),
                Text(
                  l10n.trustedVetsSubtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colors.mutedForeground,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Icon(
            isAr ? PhosphorIcons.caretLeft() : PhosphorIcons.caretRight(),
            color: colors.mutedForeground,
          ),
        ],
      ),
    );
  }
}

class _QuickGlanceStrip extends ConsumerWidget {
  const _QuickGlanceStrip({required this.isAr});

  final bool isAr;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final loyalty = ref.watch(loyaltyProvider).valueOrNull;
    final tanks = ref.watch(tanksProvider).valueOrNull ?? const [];

    return Row(
      children: [
        Expanded(
          child: AppCard(
            onTap: () => context.go('/rewards'),
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: colors.accent.withOpacity(0.14),
                    borderRadius: BorderRadius.circular(AppRadii.md),
                  ),
                  child: Icon(
                    PhosphorIcons.crownSimple(PhosphorIconsStyle.fill),
                    color: colors.accent,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isAr
                            ? '${loyalty?.balancePoints ?? 1240} نقطة'
                            : '${loyalty?.balancePoints ?? 1240} pts',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      Text(
                        isAr ? 'بطاقة الولاء' : 'Loyalty Card',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: colors.mutedForeground,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: AppCard(
            onTap: () => context.push('/tanks'),
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: colors.primary.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(AppRadii.md),
                  ),
                  child: Icon(
                    PhosphorIcons.drop(PhosphorIconsStyle.fill),
                    color: colors.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tanks.isNotEmpty
                            ? '${tanks.first.sizeLiters}L'
                            : (isAr ? 'أحواضي' : 'My Tanks'),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      Text(
                        tanks.isNotEmpty
                            ? '${tanks.first.fishCount} ${isAr ? 'سمكة' : 'fish'}'
                            : (isAr ? 'أضف حوضك' : 'Add a tank'),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: colors.mutedForeground,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _HorizontalProductCard extends ConsumerWidget {
  const _HorizontalProductCard({
    required this.product,
    required this.isAr,
    required this.cartKey,
    required this.vsync,
    required this.onTap,
  });

  final Product product;
  final bool isAr;
  final GlobalKey cartKey;
  final TickerProvider vsync;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final imageKey = GlobalKey();
    return SizedBox(
      width: 168,
      child: AppCard(
        onTap: onTap,
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ProductImagePlaceholder(
                  key: imageKey,
                  height: 112,
                  borderRadius: 0,
                  imageUrl: product.imageUrl,
                  imageAsset: ProductVisuals.imageAssetForProduct(product),
                  icon: ProductVisuals.iconForCategory(product.category),
                  gradientColors: ProductVisuals.colorsForProduct(product),
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
                      borderRadius: BorderRadius.circular(AppRadii.pill),
                    ),
                    child: Text(
                      ProductVisuals.categoryName(product.category, isAr),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: colors.foreground,
                            fontWeight: FontWeight.w700,
                            fontSize: 10,
                          ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name(isAr),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      product.isLiveFish
                          ? (isAr
                              ? 'سمك حي • ${product.variants.first.label(isAr)}'
                              : 'Live fish • ${product.variants.first.label(isAr)}')
                          : product.variants.first.label(isAr),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: product.isLiveFish
                                ? colors.warning
                                : colors.mutedForeground,
                          ),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Material(
                          color: colors.primary,
                          borderRadius: BorderRadius.circular(10),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: () {
                              FlyToCartAnimation.run(
                                context: context,
                                sourceKey: imageKey,
                                targetKey: cartKey,
                                vsync: vsync,
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
                                onArrive: () =>
                                    ref.read(cartProvider.notifier).addItem(
                                          product.id,
                                          product.variants.first.id,
                                        ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(7),
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
      ),
    );
  }
}
