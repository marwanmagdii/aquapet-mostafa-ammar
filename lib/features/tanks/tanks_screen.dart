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

class TanksScreen extends ConsumerWidget {
  const TanksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAr = ref.watch(localeProvider).languageCode == 'ar';
    final colors = context.appColors;
    final tanksAsync = ref.watch(tanksProvider);
    final products = ref.watch(productsProvider).valueOrNull ?? const <Product>[];

    return Scaffold(
      appBar: AppBar(title: Text(isAr ? 'أحواضي' : 'My Tanks')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openAddTankDialog(context, ref, isAr),
        icon: Icon(PhosphorIcons.plus()),
        label: Text(isAr ? 'إضافة حوض' : 'Add Tank'),
      ),
      body: tanksAsync.when(
        loading: () => const AppLoadingState(),
        error: (_, __) => AppErrorState(
          message: isAr ? 'تعذر تحميل الأحواض' : 'Could not load tanks',
          retryLabel: isAr ? 'إعادة' : 'Retry',
          onRetry: () => ref.read(tanksProvider.notifier).load(),
        ),
        data: (tanks) {
          if (tanks.isEmpty) {
            return AppEmptyState(
              icon: PhosphorIcons.drop(),
              title: isAr ? 'لا توجد أحواض بعد' : 'No tanks added yet',
              subtitle: isAr
                  ? 'أضف أول حوض لتحصل على ١٠٠ نقطة مكافأة وتوصيات مخصصة'
                  : 'Add your first tank for +100 bonus points and tailored product tips',
              actionLabel: isAr ? 'إضافة حوض' : 'Add Tank',
              onAction: () => _openAddTankDialog(context, ref, isAr),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.md,
              AppSpacing.md,
              96,
            ),
            itemCount: tanks.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
            itemBuilder: (context, index) {
              final tank = tanks[index];
              final suggested = products
                  .where((p) => p.waterType == tank.waterType)
                  .take(3)
                  .toList();

              return AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            tank.name,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        AppBadge(
                          label: tank.waterType == 'salt'
                              ? (isAr ? 'مياه مالحة' : 'Saltwater')
                              : (isAr ? 'مياه عذبة' : 'Freshwater'),
                          tone: AppBadgeTone.primary,
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${tank.sizeLiters}L • ${tank.fishCount} ${isAr ? 'سمكة' : 'fish'} (${tank.fishSummary})',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: colors.mutedForeground,
                          ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    AppBadge(
                      icon: PhosphorIcons.bowlFood(),
                      label: isAr
                          ? 'دليل الإطعام: ~${tank.recommendedDailyGrams.toStringAsFixed(1)} جم/يوم'
                          : 'Feeding guide: ~${tank.recommendedDailyGrams.toStringAsFixed(1)} g/day',
                      tone: AppBadgeTone.accent,
                    ),
                    if (suggested.isNotEmpty) ...[
                      const Divider(height: 24),
                      Text(
                        isAr ? 'منتجات مقترحة لهذا الحوض' : 'Suggested for this tank',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      SizedBox(
                        height: 42,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: suggested.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: AppSpacing.sm),
                          itemBuilder: (ctx, i) => ActionChip(
                            avatar: Icon(
                              ProductVisuals.iconForCategory(
                                suggested[i].category,
                              ),
                              size: 16,
                            ),
                            label: Text(suggested[i].name(isAr)),
                            onPressed: () =>
                                context.push('/product/${suggested[i].id}'),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _openAddTankDialog(BuildContext context, WidgetRef ref, bool isAr) {
    final nameCtrl = TextEditingController();
    final sizeCtrl = TextEditingController(text: '40');
    final fishCtrl = TextEditingController(text: 'Guppies, Corys');
    final countCtrl = TextEditingController(text: '6');
    String waterType = 'fresh';

    showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text(isAr ? 'إضافة حوض جديد' : 'Add Tank'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppTextField(
                  controller: nameCtrl,
                  label: isAr ? 'اسم الحوض' : 'Tank Name',
                  hint: isAr ? 'حوض المكتب' : 'Office Nano Tank',
                ),
                const SizedBox(height: AppSpacing.sm),
                AppTextField(
                  controller: sizeCtrl,
                  label: isAr ? 'الحجم (لتر)' : 'Size (Liters)',
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: AppSpacing.sm),
                SegmentedButton<String>(
                  segments: [
                    ButtonSegment(
                      value: 'fresh',
                      label: Text(isAr ? 'عذبة' : 'Fresh'),
                    ),
                    ButtonSegment(
                      value: 'salt',
                      label: Text(isAr ? 'مالحة' : 'Salt'),
                    ),
                  ],
                  selected: {waterType},
                  onSelectionChanged: (s) =>
                      setDialogState(() => waterType = s.first),
                ),
                const SizedBox(height: AppSpacing.sm),
                AppTextField(
                  controller: fishCtrl,
                  label: isAr ? 'أنواع الأسماك' : 'Fish Types',
                ),
                const SizedBox(height: AppSpacing.sm),
                AppTextField(
                  controller: countCtrl,
                  label: isAr ? 'عدد الأسماك' : 'Fish Count',
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(isAr ? 'إلغاء' : 'Cancel'),
            ),
            FilledButton(
              onPressed: () async {
                final tank = TankModel(
                  id: 'tank_${DateTime.now().microsecondsSinceEpoch}',
                  name: nameCtrl.text.trim().isEmpty
                      ? (isAr ? 'حوضي الجديد' : 'My New Tank')
                      : nameCtrl.text.trim(),
                  sizeLiters: int.tryParse(sizeCtrl.text) ?? 40,
                  waterType: waterType,
                  fishSummary: fishCtrl.text.trim(),
                  fishCount: int.tryParse(countCtrl.text) ?? 5,
                );
                await ref.read(tanksProvider.notifier).addTank(tank);
                if (ctx.mounted) Navigator.pop(ctx);
              },
              child: Text(isAr ? 'حفظ' : 'Save'),
            ),
          ],
        ),
      ),
    );
  }
}
