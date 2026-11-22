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
        title: Text(isAr ? 'التذكيرات' : 'Reminders'),
        actions: [
          Padding(
            padding: const EdgeInsetsDirectional.only(end: 8),
            child: ActionChip(
              avatar: Icon(PhosphorIcons.drop(), size: 16),
              label: Text(isAr ? 'أحواضي' : 'My Tanks'),
              onPressed: () => context.push('/tanks'),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openAddReminderSheet(context, isAr),
        icon: Icon(PhosphorIcons.plus()),
        label: Text(isAr ? 'تذكير جديد' : 'Add Reminder'),
      ),
      body: Column(
        children: [
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
                    selected: _filter == null,
                    onSelected: (_) => setState(() => _filter = null),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.only(end: 8),
                  child: ChoiceChip(
                    label: Text(isAr ? 'مواعيد الإطعام' : 'Feeding'),
                    selected: _filter == ReminderType.feedingSchedule,
                    onSelected: (_) =>
                        setState(() => _filter = ReminderType.feedingSchedule),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.only(end: 8),
                  child: ChoiceChip(
                    label: Text(isAr ? 'مخزون الطعام' : 'Food Stock'),
                    selected: _filter == ReminderType.foodRunOut,
                    onSelected: (_) =>
                        setState(() => _filter = ReminderType.foodRunOut),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.only(end: 8),
                  child: ChoiceChip(
                    label: Text(isAr ? 'تغيير الماء' : 'Water Change'),
                    selected: _filter == ReminderType.waterChange,
                    onSelected: (_) =>
                        setState(() => _filter = ReminderType.waterChange),
                  ),
                ),
                ChoiceChip(
                  label: Text(isAr ? 'الفلتر' : 'Filter'),
                  selected: _filter == ReminderType.filterMedia,
                  onSelected: (_) =>
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
                        ? 'أضف تذكيراً لمواعيد الإطعام أو تغيير الماء'
                        : 'Add feeding schedules, food stock, or tank care reminders',
                    actionLabel: isAr ? 'إضافة تذكير' : 'Add Reminder',
                    onAction: () => _openAddReminderSheet(context, isAr),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.md,
                    AppSpacing.xs,
                    AppSpacing.md,
                    96,
                  ),
                  itemCount: items.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (context, index) {
                    final rem = items[index];
                    return _ReminderCard(
                      reminder: rem,
                      now: now,
                      isAr: isAr,
                      colors: colors,
                    );
                  },
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
    final bagGramsCtrl = TextEditingController(text: '250');
    final dailyGramsCtrl = TextEditingController(text: '4');
    TimeOfDay feedTime = const TimeOfDay(hour: 15, minute: 0);
    FeedingRepeatMode repeatMode = FeedingRepeatMode.daily;
    int intervalDays = 2;
    final selectedWeekdays = <int>{DateTime.sunday};

    showModalBottomSheet<void>(
      context: context,
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
                      isAr ? 'إضافة تذكير' : 'New Reminder',
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
                          onSelected: (_) =>
                              setModalState(() => type = ReminderType.foodRunOut),
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
                      label: isAr ? 'عنوان التذكير' : 'Reminder Title',
                      hint: type == ReminderType.feedingSchedule
                          ? (isAr ? 'إطعام حوض الصالة' : 'Feed Living Room Tank')
                          : (isAr ? 'طعام أو صيانة' : 'Food or tank task'),
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
                            Text(isAr ? 'كل $intervalDays أيام' : 'Every $intervalDays days'),
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

                        await ref.read(remindersProvider.notifier).addReminder(
                              ReminderModel(
                                id: 'rem_${now.microsecondsSinceEpoch}',
                                type: type,
                                titleEn: title,
                                titleAr: title,
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
    final isLow = reminder.type == ReminderType.foodRunOut && daysLeft <= 5;

    final icon = switch (reminder.type) {
      ReminderType.feedingSchedule => PhosphorIcons.clock(),
      ReminderType.foodRunOut => PhosphorIcons.bowlFood(),
      ReminderType.waterChange => PhosphorIcons.drop(),
      ReminderType.filterMedia => PhosphorIcons.funnel(),
    };

    return AppCard(
      borderColor: isLow ? colors.warning : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: (isLow ? colors.warning : colors.primary)
                      .withOpacity(0.12),
                  borderRadius: BorderRadius.circular(AppRadii.md),
                ),
                child: Icon(
                  icon,
                  color: isLow ? colors.warning : colors.primary,
                ),
              ),
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
                      _subtitle(reminder, daysLeft, context),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: isLow
                                ? colors.warning
                                : colors.mutedForeground,
                          ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: reminder.isEnabled,
                onChanged: (v) => ref
                    .read(remindersProvider.notifier)
                    .toggleReminder(reminder.id, v),
              ),
            ],
          ),
          if (reminder.type == ReminderType.foodRunOut) ...[
            const SizedBox(height: AppSpacing.sm),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadii.pill),
              child: LinearProgressIndicator(
                minHeight: 8,
                value: reminder.remainingRatioAt(now),
                backgroundColor: colors.muted,
                color: isLow ? colors.warning : colors.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                if (reminder.productId != null)
                  Expanded(
                    child: AppPrimaryButton(
                      label: isAr ? 'إعادة الطلب' : 'Reorder',
                      onPressed: () =>
                          context.push('/product/${reminder.productId}'),
                    ),
                  ),
                if (reminder.productId != null)
                  const SizedBox(width: AppSpacing.sm),
                AppSecondaryButton(
                  label: isAr ? 'تأجيل ٣ أيام' : 'Snooze +3d',
                  onPressed: () => ref
                      .read(remindersProvider.notifier)
                      .snoozeReminder(reminder.id, days: 3),
                ),
              ],
            ),
          ] else ...[
            const SizedBox(height: AppSpacing.sm),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () =>
                      ref.read(remindersProvider.notifier).deleteReminder(reminder.id),
                  icon: Icon(PhosphorIcons.trash(), size: 16),
                  label: Text(isAr ? 'حذف' : 'Delete'),
                ),
                const SizedBox(width: AppSpacing.sm),
                AppSecondaryButton(
                  icon: PhosphorIcons.check(),
                  label: reminder.type == ReminderType.feedingSchedule
                      ? (isAr ? 'تم الإطعام' : 'Mark Fed')
                      : (isAr ? 'تم التنفيذ' : 'Mark Done'),
                  onPressed: () {
                    ref.read(remindersProvider.notifier).markDone(reminder.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          isAr ? 'تم التحديث بنجاح' : 'Marked as completed',
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ],
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
      final time = TimeOfDay(hour: r.feedHour, minute: r.feedMinute)
          .format(context);
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
