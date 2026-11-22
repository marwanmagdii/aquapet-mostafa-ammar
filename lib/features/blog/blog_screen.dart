import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../core/tokens/app_tokens.dart';
import '../../core/utils/product_visuals.dart';
import '../../data/models/blog_post.dart';
import '../../data/models/product.dart';
import '../../data/repositories/app_providers.dart';
import '../../shared/widgets/shared_widgets.dart';

class BlogListScreen extends ConsumerStatefulWidget {
  const BlogListScreen({super.key});

  @override
  ConsumerState<BlogListScreen> createState() => _BlogListScreenState();
}

class _BlogListScreenState extends ConsumerState<BlogListScreen> {
  final _searchCtrl = TextEditingController();
  String? _selectedCategoryEn;

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isAr = ref.watch(localeProvider).languageCode == 'ar';
    final colors = context.appColors;
    final postsAsync = ref.watch(blogPostsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.blogTitle),
            Text(
              l10n.blogSubtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colors.mutedForeground,
                  ),
            ),
          ],
        ),
      ),
      body: postsAsync.when(
        loading: () => const AppLoadingState(),
        error: (_, __) => AppErrorState(
          message: l10n.blogErrorMessage,
          retryLabel: l10n.vetsRetry,
          onRetry: () => ref.invalidate(blogPostsProvider),
        ),
        data: (posts) {
          if (posts.isEmpty) {
            return AppEmptyState(
              icon: PhosphorIcons.bookOpenText(),
              title: l10n.blogEmptyTitle,
              subtitle: l10n.blogEmptySubtitle,
            );
          }

          final categories = <(String en, String ar)>[];
          final seen = <String>{};
          for (final p in posts) {
            if (seen.add(p.categoryEn)) {
              categories.add((p.categoryEn, p.categoryAr));
            }
          }

          final query = _searchCtrl.text.trim().toLowerCase();
          final filtered = posts.where((p) {
            if (_selectedCategoryEn != null &&
                p.categoryEn != _selectedCategoryEn) {
              return false;
            }
            if (query.isNotEmpty) {
              final haystack =
                  '${p.titleEn} ${p.titleAr} ${p.summaryEn} ${p.summaryAr} ${p.authorName} ${p.categoryEn} ${p.categoryAr}'
                      .toLowerCase();
              if (!haystack.contains(query)) return false;
            }
            return true;
          }).toList();

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
                      ? 'ابحث في المقالات والأدلة...'
                      : 'Search care guides & articles...',
                  onChanged: (_) => setState(() {}),
                ),
              ),
              SizedBox(
                height: 44,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.only(end: 8),
                      child: ChoiceChip(
                        label: Text(isAr ? 'الكل' : 'All'),
                        selected: _selectedCategoryEn == null,
                        onSelected: (_) =>
                            setState(() => _selectedCategoryEn = null),
                      ),
                    ),
                    ...categories.map(
                      (cat) => Padding(
                        padding: const EdgeInsetsDirectional.only(end: 8),
                        child: ChoiceChip(
                          label: Text(isAr ? cat.$2 : cat.$1),
                          selected: _selectedCategoryEn == cat.$1,
                          onSelected: (_) =>
                              setState(() => _selectedCategoryEn = cat.$1),
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
                        title: isAr ? 'لا توجد مقالات مطابقة' : 'No matching guides',
                        subtitle: isAr
                            ? 'جرب كلمة بحث أخرى'
                            : 'Try another search term or category',
                        actionLabel: isAr ? 'إعادة ضبط' : 'Reset',
                        onAction: () => setState(() {
                          _searchCtrl.clear();
                          _selectedCategoryEn = null;
                        }),
                      )
                    : ListView(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  children: [
                    // Featured Hero Guide
                    AppCard(
                      onTap: () => context.push('/blog/${filtered.first.id}'),
                      padding: EdgeInsets.zero,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ProductImagePlaceholder(
                            height: 176,
                            borderRadius: 0,
                            imageUrl: filtered.first.imageUrl,
                            icon: PhosphorIcons.bookOpenText(),
                            gradientColors: [colors.primary, colors.secondary],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(AppSpacing.md),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    AppBadge(
                                      label: filtered.first.category(isAr),
                                      tone: AppBadgeTone.primary,
                                    ),
                                    const SizedBox(width: AppSpacing.sm),
                                    Text(
                                      '${filtered.first.readMinutes} ${l10n.blogMinRead}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall
                                          ?.copyWith(
                                            color: colors.mutedForeground,
                                          ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: AppSpacing.sm),
                                Text(
                                  filtered.first.title(isAr),
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  filtered.first.summary(isAr),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(color: colors.mutedForeground),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    ...filtered.skip(1).map(
                      (post) => Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: AppCard(
                          onTap: () => context.push('/blog/${post.id}'),
                          padding: const EdgeInsets.all(AppSpacing.sm),
                          child: Row(
                            children: [
                              ProductImagePlaceholder(
                                width: 88,
                                height: 88,
                                borderRadius: AppRadii.md,
                                imageUrl: post.imageUrl,
                                icon: PhosphorIcons.bookOpenText(),
                                gradientColors: [
                                  colors.primary,
                                  colors.secondary,
                                ],
                              ),
                              const SizedBox(width: AppSpacing.md),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        AppBadge(
                                          label: post.category(isAr),
                                          tone: AppBadgeTone.accent,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          '${post.readMinutes} ${l10n.blogMinRead}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelSmall
                                              ?.copyWith(
                                                color: colors.mutedForeground,
                                              ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      post.title(isAr),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      post.authorName,
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
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class BlogDetailScreen extends ConsumerWidget {
  const BlogDetailScreen({super.key, required this.postId});

  final String postId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final isAr = ref.watch(localeProvider).languageCode == 'ar';
    final colors = context.appColors;
    final postsAsync = ref.watch(blogPostsProvider);
    final products =
        ref.watch(productsProvider).valueOrNull ?? const <Product>[];

    return postsAsync.when(
      loading: () => const Scaffold(body: AppLoadingState()),
      error: (_, __) => Scaffold(
        appBar: AppBar(),
        body: AppErrorState(
          message: l10n.blogErrorMessage,
          retryLabel: l10n.vetsRetry,
          onRetry: () => ref.invalidate(blogPostsProvider),
        ),
      ),
      data: (posts) {
        final post = posts.cast<BlogPost?>().firstWhere(
              (p) => p?.id == postId,
              orElse: () => null,
            );
        if (post == null) {
          return Scaffold(
            appBar: AppBar(),
            body: AppEmptyState(
              icon: PhosphorIcons.bookOpenText(),
              title: l10n.blogEmptyTitle,
              subtitle: l10n.blogEmptySubtitle,
            ),
          );
        }

        final related = products
            .where((p) => post.relatedProductIds.contains(p.id))
            .toList();

        return Scaffold(
          appBar: AppBar(title: Text(post.category(isAr))),
          body: ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: [
              ProductImagePlaceholder(
                height: 210,
                borderRadius: AppRadii.xl,
                imageUrl: post.imageUrl,
                icon: PhosphorIcons.bookOpenText(),
                gradientColors: [colors.primary, colors.secondary],
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  AppBadge(
                    label: post.category(isAr),
                    tone: AppBadgeTone.primary,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    '${post.readMinutes} ${l10n.blogMinRead} • ${DateFormat.yMMMd(isAr ? 'ar' : 'en').format(post.publishedAt)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colors.mutedForeground,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                post.title(isAr),
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 4),
              Text(
                post.authorName,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: colors.primary,
                    ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                post.body(isAr),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      height: 1.65,
                    ),
              ),
              if (related.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.xl),
                Text(
                  l10n.blogRelatedProducts,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.sm),
                SizedBox(
                  height: 196,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: related.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(width: AppSpacing.sm),
                    itemBuilder: (context, i) {
                      final prod = related[i];
                      return SizedBox(
                        width: 154,
                        child: AppCard(
                          onTap: () => context.push('/product/${prod.id}'),
                          padding: const EdgeInsets.all(AppSpacing.sm),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ProductImagePlaceholder(
                                height: 96,
                                imageUrl: prod.imageUrl,
                                imageAsset:
                                    ProductVisuals.imageAssetForProduct(prod),
                                icon: ProductVisuals.iconForCategory(
                                  prod.category,
                                ),
                                gradientColors:
                                    ProductVisuals.colorsForProduct(prod),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                prod.name(isAr),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                              const Spacer(),
                              Text(
                                ProductVisuals.formatEgp(
                                  prod.startingPrice,
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
                      );
                    },
                  ),
                ),
              ],
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        );
      },
    );
  }
}
