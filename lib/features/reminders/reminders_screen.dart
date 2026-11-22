import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../core/tokens/app_tokens.dart';
import '../../data/models/reminder_tank.dart';
import '../../data/repositories/app_providers.dart';
import '../../shared/widgets/shared_widgets.dart';

class RemindersScreen extends ConsumerStatefulWidget {
  const RemindersScreen({super.key});

  @override
  ConsumerState<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends ConsumerState<RemindersScreen> {
  ReminderType? _filter;

  @override
  Widget build(BuildContext context) {
    final isAr = ref.watch(localeProvider).languageCode == 'ar';
    final colors = context.appColors;
    final remindersAsync = ref.watch(remindersProvider);
    final now = ref.watch(appNowProvider);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 64,
        title: Text(
          isAr ? 'التذكيرات' : 'Reminders',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsetsDirectional.only(end: 12),
            child: OutlinedButton.icon(
              onPressed: () => context.push('/tanks'),
              icon: Icon(PhosphorIcons.drop(), size: 18),
              label: Text(isAr ? 'أحواضي' : 'My Tanks'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(48, 44),
                padding: const EdgeInsets.symmetric(horizontal: 14),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openAddReminderSheet(context, isAr),
        tooltip: isAr ? 'إضافة تذكير' : 'Add Reminder',
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
        child: Icon(PhosphorIcons.plus(PhosphorIconsStyle.bold)),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              children: [
                _FilterPill(
                  label: isAr ? 'الكل' : 'All',
                  selected: _filter == null,
                  onTap: () => setState(() => _filter = null),
                ),
                _FilterPill(
                  label: isAr ? 'مواعيد الإطعام' : 'Feeding',
                  selected: _filter == ReminderType.feedingSchedule,
                  onTap: () =>
                      setState(() => _filter = ReminderType.feedingSchedule),
                ),
                _FilterPill(
                  label: isAr ? 'مخزون الطعام' : 'Food Stock',
                  selected: _filter == ReminderType.foodRunOut,
                  onTap: () =>
                      setState(() => _filter = ReminderType.foodRunOut),
                ),
                _FilterPill(
                  label: isAr ? 'تغيير الماء' : 'Water Change',
                  selected: _filter == ReminderType.waterChange,
                  onTap: () =>
                      setState(() => _filter = ReminderType.waterChange),
                ),
                _FilterPill(
                  label: isAr ? 'الفلتر' : 'Filter',
                  selected: _filter == ReminderType.filterMedia,
                  onTap: () =>
                      setState(() => _filter = ReminderType.filterMedia),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Expanded(
            child: remindersAsync.when(
              loading: () => const AppLoadingState(),
              error: (_, __) => AppErrorState(
                message:
                    isAr ? 'تعذر تحميل التذكيرات' : 'Could not load reminders',
                retryLabel: isAr ? 'إعادة' : 'Retry',
                onRetry: () => ref.read(remindersProvider.notifier).load(),
              ),
              data: (reminders) {
                final items = _filter == null
                    ? reminders
                    : reminders.where((r) => r.type == _filter).toList();

                if (items.isEmpty) {
                  return AppEmptyState(
                    icon: PhosphorIcons.bell(),
                    title: isAr ? 'لا توجد تذكيرات' : 'No reminders yet',
                    subtitle: isAr
                        ? 'اضغط على + لإضافة تذكير جديد'
                        : 'Tap + to add a feeding or tank reminder',
                    actionLabel: isAr ? 'إضافة تذكير' : 'Add Reminder',
                    onAction: () => _openAddReminderSheet(context, isAr),
                  );
                }

                const orderedTypes = [
                  ReminderType.feedingSchedule,
                  ReminderType.foodRunOut,
                  ReminderType.waterChange,
                  ReminderType.filterMedia,
                ];
                final sections = [
                  for (final t in orderedTypes)
                    if (items.any((r) => r.type == t))
                      (
                        type: t,
                        reminders: items.where((r) => r.type == t).toList(),
                      ),
                ];

                return ListView(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.md,
                    AppSpacing.xs,
                    AppSpacing.md,
                    88,
                  ),
                  children: [
                    for (var s = 0; s < sections.length; s++) ...[
                      if (s > 0) const SizedBox(height: AppSpacing.lg),
                      _CategoryHeader(
                        type: sections[s].type,
                        count: sections[s].reminders.length,
                        isAr: isAr,
                        colors: colors,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      for (var i = 0;
                          i < sections[s].reminders.length;
                          i++) ...[
                        if (i > 0) const SizedBox(height: AppSpacing.sm),
                        _ReminderCard(
                          reminder: sections[s].reminders[i],
                          now: now,
                          isAr: isAr,
                          colors: colors,
                        ),
                      ],
                    ],
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _openAddReminderSheet(BuildContext context, bool isAr) {
    ReminderType type = ReminderType.feedingSchedule;
    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final bagGramsCtrl = TextEditingController(text: '250');
    final dailyGramsCtrl = TextEditingController(text: '4');
    TimeOfDay feedTime = const TimeOfDay(hour: 15, minute: 0);
    FeedingRepeatMode repeatMode = FeedingRepeatMode.daily;
    int intervalDays = 2;
    final selectedWeekdays = <int>{DateTime.sunday};

    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.sm,
                AppSpacing.lg,
                MediaQuery.of(ctx).viewInsets.bottom + AppSpacing.lg,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isAr ? 'إضافة تذكير جديد' : 'New Reminder',
                      style: Theme.of(ctx).textTheme.titleLarge,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ChoiceChip(
                          label: Text(isAr ? 'إطعام الأسماك' : 'Feed Fish'),
                          selected: type == ReminderType.feedingSchedule,
                          onSelected: (_) => setModalState(
                            () => type = ReminderType.feedingSchedule,
                          ),
                        ),
                        ChoiceChip(
                          label: Text(isAr ? 'نفاد الطعام' : 'Food Run-out'),
                          selected: type == ReminderType.foodRunOut,
                          onSelected: (_) => setModalState(
                            () => type = ReminderType.foodRunOut,
                          ),
                        ),
                        ChoiceChip(
                          label: Text(isAr ? 'تغيير الماء' : 'Water Change'),
                          selected: type == ReminderType.waterChange,
                          onSelected: (_) => setModalState(() {
                            type = ReminderType.waterChange;
                            intervalDays = 7;
                          }),
                        ),
                        ChoiceChip(
                          label: Text(isAr ? 'الفلتر' : 'Filter Media'),
                          selected: type == ReminderType.filterMedia,
                          onSelected: (_) => setModalState(() {
                            type = ReminderType.filterMedia;
                            intervalDays = 30;
                          }),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AppTextField(
                      controller: titleCtrl,
                      label: isAr ? 'اسم التذكير' : 'Reminder Name',
                      hint: type == ReminderType.feedingSchedule
                          ? (isAr
                              ? 'مثال: إطعام سعد وسعدية'
                              : 'e.g. Feed Saad & Saadia')
                          : (isAr ? 'طعام أو صيانة' : 'Food or tank task'),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    AppTextField(
                      controller: descCtrl,
                      maxLines: 3,
                      label: isAr
                          ? 'الوصف / تعليمات العناية (اختياري)'
                          : 'Description / Care Instructions (optional)',
                      hint: isAr
                          ? 'مثال: رشة صغيرة من الطعام في الحوض الكبير، لا تُكثر'
                          : 'e.g. Give one small pinch in the living room tank...',
                    ),
                    const SizedBox(height: AppSpacing.md),
                    if (type == ReminderType.feedingSchedule) ...[
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(PhosphorIcons.clock()),
                        title: Text(isAr ? 'وقت الإطعام' : 'Feeding Time'),
                        trailing: Text(
                          feedTime.format(ctx),
                          style: Theme.of(ctx).textTheme.titleMedium,
                        ),
                        onTap: () async {
                          final picked = await showTimePicker(
                            context: ctx,
                            initialTime: feedTime,
                          );
                          if (picked != null) {
                            setModalState(() => feedTime = picked);
                          }
                        },
                      ),
                      Text(
                        isAr ? 'التكرار' : 'Repeat',
                        style: Theme.of(ctx).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: [
                          ChoiceChip(
                            label: Text(isAr ? 'كل يوم' : 'Every day'),
                            selected: repeatMode == FeedingRepeatMode.daily,
                            onSelected: (_) => setModalState(
                              () => repeatMode = FeedingRepeatMode.daily,
                            ),
                          ),
                          ChoiceChip(
                            label: Text(isAr ? 'كل عدة أيام' : 'Every N days'),
                            selected:
                                repeatMode == FeedingRepeatMode.everyNDays,
                            onSelected: (_) => setModalState(
                              () => repeatMode = FeedingRepeatMode.everyNDays,
                            ),
                          ),
                          ChoiceChip(
                            label: Text(isAr ? 'أيام محددة' : 'Weekdays'),
                            selected: repeatMode == FeedingRepeatMode.weekdays,
                            onSelected: (_) => setModalState(
                              () => repeatMode = FeedingRepeatMode.weekdays,
                            ),
                          ),
                        ],
                      ),
                      if (repeatMode == FeedingRepeatMode.everyNDays) ...[
                        const SizedBox(height: AppSpacing.sm),
                        Row(
                          children: [
                            Text(
                              isAr
                                  ? 'كل $intervalDays أيام'
                                  : 'Every $intervalDays days',
                            ),
                            Expanded(
                              child: Slider(
                                min: 2,
                                max: 7,
                                divisions: 5,
                                value: intervalDays.toDouble(),
                                onChanged: (v) => setModalState(
                                  () => intervalDays = v.round(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                      if (repeatMode == FeedingRepeatMode.weekdays) ...[
                        const SizedBox(height: AppSpacing.sm),
                        Wrap(
                          spacing: 6,
                          children: [
                            for (final d in [
                              (DateTime.sunday, isAr ? 'أحد' : 'Sun'),
                              (DateTime.monday, isAr ? 'إثنين' : 'Mon'),
                              (DateTime.tuesday, isAr ? 'ثلاثاء' : 'Tue'),
                              (DateTime.wednesday, isAr ? 'أربعاء' : 'Wed'),
                              (DateTime.thursday, isAr ? 'خميس' : 'Thu'),
                              (DateTime.friday, isAr ? 'جمعة' : 'Fri'),
                              (DateTime.saturday, isAr ? 'سبت' : 'Sat'),
                            ])
                              FilterChip(
                                label: Text(d.$2),
                                selected: selectedWeekdays.contains(d.$1),
                                onSelected: (sel) {
                                  setModalState(() {
                                    if (sel) {
                                      selectedWeekdays.add(d.$1);
                                    } else if (selectedWeekdays.length > 1) {
                                      selectedWeekdays.remove(d.$1);
                                    }
                                  });
                                },
                              ),
                          ],
                        ),
                      ],
                    ] else if (type == ReminderType.foodRunOut) ...[
                      Row(
                        children: [
                          Expanded(
                            child: AppTextField(
                              controller: bagGramsCtrl,
                              label: isAr ? 'وزن العبوة (جم)' : 'Bag size (g)',
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: AppTextField(
                              controller: dailyGramsCtrl,
                              label: isAr
                                  ? 'الاستهلاك اليومي (جم)'
                                  : 'Daily amount (g)',
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                    ] else ...[
                      Row(
                        children: [
                          Text(
                            isAr
                                ? 'كل $intervalDays يوم'
                                : 'Every $intervalDays days',
                          ),
                          Expanded(
                            child: Slider(
                              min: 3,
                              max: 45,
                              value: intervalDays.toDouble(),
                              onChanged: (v) => setModalState(
                                () => intervalDays = v.round(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: AppSpacing.lg),
                    AppPrimaryButton(
                      label: isAr ? 'حفظ التذكير' : 'Save Reminder',
                      onPressed: () async {
                        final now = ref.read(appNowProvider);
                        final defaultTitle = switch (type) {
                          ReminderType.feedingSchedule =>
                            isAr ? 'إطعام الأسماك' : 'Feed Fish',
                          ReminderType.foodRunOut =>
                            isAr ? 'مخزون طعام الأسماك' : 'Fish Food Stock',
                          ReminderType.waterChange =>
                            isAr ? 'تغيير ٢٥٪ من الماء' : '25% Water Change',
                          ReminderType.filterMedia =>
                            isAr ? 'صيانة الفلتر' : 'Filter Maintenance',
                        };
                        final title = titleCtrl.text.trim().isEmpty
                            ? defaultTitle
                            : titleCtrl.text.trim();
                        final desc = descCtrl.text.trim();

                        await ref.read(remindersProvider.notifier).addReminder(
                              ReminderModel(
                                id: 'rem_${now.microsecondsSinceEpoch}',
                                type: type,
                                titleEn: title,
                                titleAr: title,
                                descriptionEn: desc.isEmpty ? null : desc,
                                descriptionAr: desc.isEmpty ? null : desc,
                                isEnabled: true,
                                createdAt: now,
                                bagGrams: int.tryParse(bagGramsCtrl.text) ?? 250,
                                dailyGrams:
                                    double.tryParse(dailyGramsCtrl.text) ?? 4.0,
                                intervalDays: intervalDays,
                                lastCompletedAt: now,
                                feedHour: feedTime.hour,
                                feedMinute: feedTime.minute,
                                repeatMode: repeatMode,
                                weekdays: selectedWeekdays.toList()..sort(),
                              ),
                            );
                        if (ctx.mounted) Navigator.pop(ctx);
                      },
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

class _CategoryHeader extends StatelessWidget {
  const _CategoryHeader({
    required this.type,
    required this.count,
    required this.isAr,
    required this.colors,
  });

  final ReminderType type;
  final int count;
  final bool isAr;
  final AppColorsExtension colors;

  @override
  Widget build(BuildContext context) {
    final (icon, title, catColor) = switch (type) {
      ReminderType.feedingSchedule => (
          PhosphorIcons.clock(PhosphorIconsStyle.fill),
          isAr ? 'مواعيد الإطعام' : 'Feeding Schedule',
          colors.primary,
        ),
      ReminderType.foodRunOut => (
          PhosphorIcons.bowlFood(PhosphorIconsStyle.fill),
          isAr ? 'مخزون الطعام' : 'Food Stock',
          const Color(0xFFEA580C),
        ),
      ReminderType.waterChange => (
          PhosphorIcons.drop(PhosphorIconsStyle.fill),
          isAr ? 'تغيير الماء' : 'Water Care',
          const Color(0xFF0284C7),
        ),
      ReminderType.filterMedia => (
          PhosphorIcons.funnel(PhosphorIconsStyle.fill),
          isAr ? 'صيانة الفلتر' : 'Filter Maintenance',
          const Color(0xFF4F46E5),
        ),
    };

    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: catColor.withOpacity(0.14),
            borderRadius: BorderRadius.circular(AppRadii.sm),
          ),
          child: Icon(icon, size: 18, color: catColor),
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
        ),
        const SizedBox(width: AppSpacing.xs),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: colors.muted,
            borderRadius: BorderRadius.circular(AppRadii.pill),
          ),
          child: Text(
            '$count',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: colors.mutedForeground,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ),
      ],
    );
  }
}

class _FilterPill extends StatelessWidget {
  const _FilterPill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Padding(
      padding: const EdgeInsetsDirectional.only(end: 8),
      child: ChoiceChip(
        label: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
            color: selected ? colors.onPrimary : colors.foreground,
          ),
        ),
        selected: selected,
        selectedColor: colors.primary,
        showCheckmark: false,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        onSelected: (_) => onTap(),
      ),
    );
  }
}

class _ReminderCard extends ConsumerWidget {
  const _ReminderCard({
    required this.reminder,
    required this.now,
    required this.isAr,
    required this.colors,
  });

  final ReminderModel reminder;
  final DateTime now;
  final bool isAr;
  final AppColorsExtension colors;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final daysLeft = reminder.daysLeftAt(now);
    final isPaused = !reminder.isEnabled;
    final isLow =
        !isPaused && reminder.type == ReminderType.foodRunOut && daysLeft <= 5;
    final isFeeding = reminder.type == ReminderType.feedingSchedule;
    final isFedToday = !isPaused && isFeeding && reminder.isFedTodayAt(now);
    final isNotFed = !isPaused && isFeeding && !isFedToday;
    final isDueNow = !isPaused &&
        (reminder.type == ReminderType.waterChange ||
            reminder.type == ReminderType.filterMedia) &&
        daysLeft <= 0;
    final isUrgentRed = isNotFed || isDueNow;

    final Color accentColor = isPaused
        ? colors.mutedForeground
        : isUrgentRed
            ? colors.danger
            : isFedToday
                ? colors.success
                : isLow
                    ? colors.warning
                    : colors.primary;

    final icon = switch (reminder.type) {
      ReminderType.feedingSchedule => PhosphorIcons.clock(),
      ReminderType.foodRunOut => PhosphorIcons.bowlFood(),
      ReminderType.waterChange => PhosphorIcons.drop(),
      ReminderType.filterMedia => PhosphorIcons.funnel(),
    };

    final typeLabel = switch (reminder.type) {
      ReminderType.feedingSchedule => isFedToday
          ? (isAr ? 'تم الإطعام اليوم' : 'Fed Today')
          : isNotFed
              ? (isAr ? 'لم يتم الإطعام' : 'Not Fed Yet')
              : (isAr ? 'إطعام' : 'Feeding'),
      ReminderType.foodRunOut =>
        isLow ? (isAr ? 'أوشك على النفاد' : 'Running Low') : (isAr ? 'مخزون الطعام' : 'Food Stock'),
      ReminderType.waterChange =>
        isDueNow ? (isAr ? 'مطلوب الآن' : 'Due Now') : (isAr ? 'تغيير الماء' : 'Water Care'),
      ReminderType.filterMedia =>
        isDueNow ? (isAr ? 'مطلوب الآن' : 'Due Now') : (isAr ? 'الفلتر' : 'Filter'),
    };

    final badgeTone = isPaused
        ? AppBadgeTone.neutral
        : isUrgentRed
            ? AppBadgeTone.danger
            : isFedToday
                ? AppBadgeTone.success
                : isLow
                    ? AppBadgeTone.warning
                    : AppBadgeTone.primary;

    final desc = reminder.description(isAr);

    return AppCard(
      onTap: () => _openReminderDetailSheet(context, ref, daysLeft),
      padding: const EdgeInsets.all(AppSpacing.md),
      backgroundColor: isPaused
          ? colors.muted
          : isUrgentRed
              ? colors.danger.withOpacity(0.11)
              : isFedToday
                  ? colors.success.withOpacity(0.11)
                  : isLow
                      ? colors.warning.withOpacity(0.13)
                      : colors.primary.withOpacity(0.04),
      borderColor: isPaused
          ? colors.border
          : isUrgentRed
              ? colors.danger
              : isFedToday
                  ? colors.success
                  : isLow
                      ? colors.warning
                      : colors.primary.withOpacity(0.35),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppBadge(
                label: typeLabel,
                tone: badgeTone,
              ),
              const Spacer(),
              Text(
                reminder.isEnabled
                    ? (isAr ? 'مفعّل' : 'Active')
                    : (isAr ? 'متوقف' : 'Paused'),
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: reminder.isEnabled
                          ? colors.primary
                          : colors.mutedForeground,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(width: 6),
              Switch(
                value: reminder.isEnabled,
                onChanged: (v) => ref
                    .read(remindersProvider.notifier)
                    .toggleReminder(reminder.id, v),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.14),
                  borderRadius: BorderRadius.circular(AppRadii.md),
                ),
                child: Icon(
                  icon,
                  size: 24,
                  color: accentColor,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reminder.title(isAr),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: isPaused ? colors.mutedForeground : null,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _subtitle(reminder, daysLeft, context),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: isPaused
                                ? colors.mutedForeground
                                : isUrgentRed
                                    ? colors.danger
                                    : isLow
                                        ? colors.warning
                                        : colors.foreground.withOpacity(0.8),
                          ),
                    ),
                    if (desc != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        desc,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: colors.mutedForeground,
                              height: 1.35,
                            ),
                      ),
                    ],
                  ],
                ),
              ),
              Icon(
                isAr ? PhosphorIcons.caretLeft() : PhosphorIcons.caretRight(),
                size: 16,
                color: colors.mutedForeground,
                textDirection: TextDirection.ltr,
              ),
            ],
          ),
          if (reminder.type == ReminderType.foodRunOut) ...[
            const SizedBox(height: AppSpacing.md),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadii.pill),
              child: LinearProgressIndicator(
                minHeight: 10,
                value: reminder.remainingRatioAt(now),
                backgroundColor: colors.muted,
                color: isPaused
                    ? colors.mutedForeground.withOpacity(0.45)
                    : isLow
                        ? colors.warning
                        : colors.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                if (reminder.productId != null)
                  Expanded(
                    child: FilledButton.icon(
                      icon: Icon(PhosphorIcons.shoppingCart()),
                      label: Text(isAr ? 'اطلب الآن' : 'Reorder Now'),
                      style: FilledButton.styleFrom(
                        backgroundColor: isLow ? colors.warning : colors.primary,
                      ),
                      onPressed: isPaused
                          ? null
                          : () => context.push('/product/${reminder.productId}'),
                    ),
                  ),
                if (reminder.productId != null)
                  const SizedBox(width: AppSpacing.sm),
                AppSecondaryButton(
                  label: isAr ? 'تأجيل ٣ أيام' : 'Snooze +3d',
                  onPressed: isPaused
                      ? null
                      : () => ref
                          .read(remindersProvider.notifier)
                          .snoozeReminder(reminder.id, days: 3),
                ),
              ],
            ),
          ] else ...[
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    icon: Icon(PhosphorIcons.checkCircle(PhosphorIconsStyle.fill)),
                    label: Text(
                      reminder.type == ReminderType.feedingSchedule
                          ? (isAr ? 'تم الإطعام اليوم' : 'Mark Fed')
                          : (isAr ? 'تم التنفيذ' : 'Mark Done'),
                    ),
                    style: FilledButton.styleFrom(
                      backgroundColor: isUrgentRed
                          ? colors.danger
                          : isFedToday
                              ? colors.success
                              : colors.primary,
                    ),
                    onPressed: isPaused
                        ? null
                        : () {
                            ref
                                .read(remindersProvider.notifier)
                                .markDone(reminder.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: colors.success,
                                content: Text(
                                  isAr
                                      ? 'تم التحديث بنجاح'
                                      : 'Marked as completed',
                                ),
                              ),
                            );
                          },
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                AppIconButton(
                  icon: PhosphorIcons.trash(),
                  color: colors.danger,
                  tooltip: isAr ? 'حذف' : 'Delete',
                  onPressed: () => _confirmDelete(context, ref),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isAr ? 'حذف التذكير؟' : 'Delete Reminder?'),
        content: Text(
          isAr
              ? 'هل أنت متأكد من حذف "${reminder.title(true)}"؟'
              : 'Remove "${reminder.title(false)}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(isAr ? 'إلغاء' : 'Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(backgroundColor: colors.danger),
            child: Text(isAr ? 'حذف' : 'Delete'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(remindersProvider.notifier).deleteReminder(reminder.id);
    }
  }

  void _openReminderDetailSheet(
    BuildContext context,
    WidgetRef ref,
    int daysLeft,
  ) {
    final desc = reminder.description(isAr);
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.xs,
            AppSpacing.lg,
            AppSpacing.lg,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      reminder.title(isAr),
                      style: Theme.of(ctx).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                  ),
                  IconButton(
                    tooltip: isAr ? 'تعديل' : 'Edit',
                    icon: Icon(PhosphorIcons.pencilSimple()),
                    onPressed: () {
                      Navigator.pop(ctx);
                      _openEditReminderSheet(context, ref);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                _subtitle(reminder, daysLeft, ctx),
                style: Theme.of(ctx).textTheme.bodyMedium?.copyWith(
                      color: colors.primary,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: AppSpacing.md),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: colors.muted,
                  borderRadius: BorderRadius.circular(AppRadii.lg),
                  border: Border.all(color: colors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          PhosphorIcons.note(PhosphorIconsStyle.duotone),
                          size: 18,
                          color: colors.primary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          isAr
                              ? 'تعليمات العناية والوصف'
                              : 'Care Instructions & Notes',
                          style: Theme.of(ctx).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      desc ??
                          (isAr
                              ? 'لا يوجد وصف مضاف بعد. اضغط على "تعديل الاسم والوصف" لإضافة تعليمات واضحة لأي شخص يساعدك.'
                              : 'No description added yet. Tap "Edit Name & Notes" to add clear instructions for anyone helping care for your tank.'),
                      style: Theme.of(ctx).textTheme.bodyMedium?.copyWith(
                            color: desc != null
                                ? colors.foreground
                                : colors.mutedForeground,
                            height: 1.5,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                  Expanded(
                    child: AppSecondaryButton(
                      icon: PhosphorIcons.pencilSimple(),
                      label: isAr ? 'تعديل الاسم والوصف' : 'Edit Name & Notes',
                      onPressed: () {
                        Navigator.pop(ctx);
                        _openEditReminderSheet(context, ref);
                      },
                    ),
                  ),
                  if (reminder.type != ReminderType.foodRunOut &&
                      reminder.isEnabled) ...[
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: AppPrimaryButton(
                        icon: PhosphorIcons.checkCircle(PhosphorIconsStyle.fill),
                        label: reminder.type == ReminderType.feedingSchedule
                            ? (isAr ? 'تم الإطعام' : 'Mark Fed')
                            : (isAr ? 'تم التنفيذ' : 'Mark Done'),
                        onPressed: () {
                          ref
                              .read(remindersProvider.notifier)
                              .markDone(reminder.id);
                          Navigator.pop(ctx);
                        },
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openEditReminderSheet(BuildContext context, WidgetRef ref) {
    final titleCtrl = TextEditingController(text: reminder.title(isAr));
    final descCtrl = TextEditingController(
      text: reminder.description(isAr) ?? '',
    );

    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.xs,
            AppSpacing.lg,
            MediaQuery.of(ctx).viewInsets.bottom + AppSpacing.lg,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isAr ? 'تعديل التذكير' : 'Edit Reminder',
                style: Theme.of(ctx).textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                controller: titleCtrl,
                label: isAr ? 'اسم التذكير' : 'Reminder Name',
                hint: isAr ? 'مثال: إطعام سعد وسعدية' : 'e.g. Feed Saad & Saadia',
              ),
              const SizedBox(height: AppSpacing.sm),
              AppTextField(
                controller: descCtrl,
                maxLines: 3,
                label: isAr ? 'الوصف / تعليمات العناية' : 'Description / Notes',
                hint: isAr
                    ? 'اكتب التعليمات لمن لا يعرف نظام الحوض...'
                    : 'Write clear instructions for anyone helping...',
              ),
              const SizedBox(height: AppSpacing.lg),
              AppPrimaryButton(
                label: isAr ? 'حفظ التعديلات' : 'Save Changes',
                onPressed: () async {
                  final nextTitle = titleCtrl.text.trim();
                  if (nextTitle.isEmpty) return;
                  await ref
                      .read(remindersProvider.notifier)
                      .updateReminderDetails(
                        reminder.id,
                        title: nextTitle,
                        description: descCtrl.text,
                      );
                  if (ctx.mounted) Navigator.pop(ctx);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _subtitle(ReminderModel r, int daysLeft, BuildContext context) {
    if (r.type == ReminderType.foodRunOut) {
      return isAr
          ? 'الطعام المتبقي: حوالي $daysLeft أيام'
          : 'Food left: about $daysLeft days';
    }
    if (r.type == ReminderType.feedingSchedule) {
      final time =
          TimeOfDay(hour: r.feedHour, minute: r.feedMinute).format(context);
      final repeat = switch (r.repeatMode) {
        FeedingRepeatMode.daily => isAr ? 'يومياً' : 'Every day',
        FeedingRepeatMode.everyNDays =>
          isAr ? 'كل ${r.intervalDays} أيام' : 'Every ${r.intervalDays} days',
        FeedingRepeatMode.weekdays => _weekdayLabels(r.weekdays),
      };
      return '$time • $repeat';
    }
    return isAr
        ? 'الموعد القادم خلال $daysLeft أيام'
        : 'Due in $daysLeft days';
  }

  String _weekdayLabels(List<int> days) {
    final map = isAr
        ? {
            1: 'إثنين',
            2: 'ثلاثاء',
            3: 'أربعاء',
            4: 'خميس',
            5: 'جمعة',
            6: 'سبت',
            7: 'أحد',
          }
        : {
            1: 'Mon',
            2: 'Tue',
            3: 'Wed',
            4: 'Thu',
            5: 'Fri',
            6: 'Sat',
            7: 'Sun',
          };
    return days.map((d) => map[d] ?? '').join(', ');
  }
}
