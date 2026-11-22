import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/tokens/app_tokens.dart';
import '../../core/utils/loyalty_rules.dart';
import '../../core/utils/notification_service.dart';
import '../../data/models/user_profile.dart';
import '../../data/repositories/app_providers.dart';
import '../../shared/widgets/shared_widgets.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAr = ref.watch(localeProvider).languageCode == 'ar';
    final isDark = ref.watch(darkModeProvider);
    final colors = context.appColors;
    final userAsync = ref.watch(userProvider);
    final simulatedDays = ref.watch(simulatedDaysProvider);

    return Scaffold(
      appBar: AppBar(title: Text(isAr ? 'حسابي والإعدادات' : 'Profile')),
      body: userAsync.when(
        loading: () => const AppLoadingState(),
        error: (_, __) => AppErrorState(
          message: isAr ? 'تعذر تحميل الحساب' : 'Could not load profile',
          retryLabel: isAr ? 'إعادة' : 'Retry',
          onRetry: () => ref.read(userProvider.notifier).load(),
        ),
        data: (user) => ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            // Profile Header
            AppCard(
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: colors.primary.withOpacity(0.14),
                    child: Icon(
                      PhosphorIcons.user(PhosphorIconsStyle.fill),
                      color: colors.primary,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.name,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          '${user.phone} • ${user.memberId}',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: colors.mutedForeground),
                        ),
                      ],
                    ),
                  ),
                  AppIconButton(
                    icon: PhosphorIcons.pencilSimple(),
                    tooltip: isAr ? 'تعديل الحساب' : 'Edit Profile',
                    onPressed: () =>
                        _openEditProfileDialog(context, ref, user, isAr),
                  ),
                ],
              ),
            ),

            // App & Website QR Codes
            const SizedBox(height: AppSpacing.md),
            _ShareQrCard(isAr: isAr),

            const SizedBox(height: AppSpacing.md),
            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  ListTile(
                    leading: _ProfileIconBadge(
                      icon: PhosphorIcons.package(PhosphorIconsStyle.duotone),
                      color: const Color(0xFF0284C7),
                    ),
                    title: Text(isAr ? 'سجل الطلبات' : 'Order History'),
                    trailing: Icon(
                      isAr
                          ? PhosphorIcons.caretLeft()
                          : PhosphorIcons.caretRight(),
                      textDirection: TextDirection.ltr,
                    ),
                    onTap: () => context.push('/orders'),
                  ),
                  const Divider(),
                  ListTile(
                    leading: _ProfileIconBadge(
                      icon: PhosphorIcons.drop(PhosphorIconsStyle.duotone),
                      color: const Color(0xFF0891B2),
                    ),
                    title: Text(isAr ? 'أحواضي' : 'My Tanks'),
                    trailing: Icon(
                      isAr
                          ? PhosphorIcons.caretLeft()
                          : PhosphorIcons.caretRight(),
                      textDirection: TextDirection.ltr,
                    ),
                    onTap: () => context.push('/tanks'),
                  ),
                  const Divider(),
                  ListTile(
                    leading: _ProfileIconBadge(
                      icon: PhosphorIcons.stethoscope(PhosphorIconsStyle.duotone),
                      color: const Color(0xFF059669),
                    ),
                    title: Text(AppLocalizations.of(context)!.trustedVetsTitle),
                    subtitle: Text(
                      AppLocalizations.of(context)!.trustedVetsSubtitle,
                    ),
                    trailing: Icon(
                      isAr
                          ? PhosphorIcons.caretLeft()
                          : PhosphorIcons.caretRight(),
                      textDirection: TextDirection.ltr,
                    ),
                    onTap: () => context.push('/vets'),
                  ),
                  const Divider(),
                  ListTile(
                    leading: _ProfileIconBadge(
                      icon: PhosphorIcons.bookOpenText(PhosphorIconsStyle.duotone),
                      color: const Color(0xFF4F46E5),
                    ),
                    title: Text(AppLocalizations.of(context)!.blogTitle),
                    subtitle: Text(
                      AppLocalizations.of(context)!.blogSubtitle,
                    ),
                    trailing: Icon(
                      isAr
                          ? PhosphorIcons.caretLeft()
                          : PhosphorIcons.caretRight(),
                      textDirection: TextDirection.ltr,
                    ),
                    onTap: () => context.push('/blog'),
                  ),
                  const Divider(),
                  ListTile(
                    leading: _ProfileIconBadge(
                      icon: PhosphorIcons.mapPin(PhosphorIconsStyle.duotone),
                      color: const Color(0xFFEA580C),
                    ),
                    title: Text(isAr ? 'دفتر العناوين' : 'Address Book'),
                    subtitle: Text(
                      user.addresses.isEmpty
                          ? (isAr ? 'لا توجد عناوين' : 'No saved addresses')
                          : '${user.addresses.first.area} — ${user.addresses.first.street}',
                    ),
                    trailing: Icon(
                      isAr
                          ? PhosphorIcons.caretLeft()
                          : PhosphorIcons.caretRight(),
                      textDirection: TextDirection.ltr,
                    ),
                    onTap: () =>
                        _openAddressSheet(context, ref, user, isAr),
                  ),
                ],
              ),
            ),

            // Preferences
            const SizedBox(height: AppSpacing.md),
            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  ListTile(
                    leading: _ProfileIconBadge(
                      icon: PhosphorIcons.translate(PhosphorIconsStyle.duotone),
                      color: colors.primary,
                    ),
                    title: Text(isAr ? 'اللغة' : 'Language'),
                    subtitle: Text(isAr ? 'العربية (RTL)' : 'English (LTR)'),
                    trailing: FilledButton.tonal(
                      onPressed: () =>
                          ref.read(localeProvider.notifier).toggle(),
                      child: Text(isAr ? 'English' : 'العربية'),
                    ),
                  ),
                  const Divider(),
                  SwitchListTile(
                    secondary: _ProfileIconBadge(
                      icon: PhosphorIcons.moon(PhosphorIconsStyle.duotone),
                      color: const Color(0xFF6366F1),
                    ),
                    title: Text(isAr ? 'الوضع الداكن' : 'Dark Mode'),
                    value: isDark,
                    onChanged: (v) =>
                        ref.read(darkModeProvider.notifier).setDark(v),
                  ),
                  const Divider(),
                  SwitchListTile(
                    secondary: _ProfileIconBadge(
                      icon: PhosphorIcons.bell(PhosphorIconsStyle.duotone),
                      color: const Color(0xFFEA580C),
                    ),
                    title: Text(isAr ? 'إشعارات التذكير' : 'Notifications'),
                    value: user.notificationsEnabled,
                    onChanged: (v) =>
                        ref.read(userProvider.notifier).toggleNotifications(v),
                  ),
                ],
              ),
            ),

            // About the Shop
            const SizedBox(height: AppSpacing.md),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ClipOval(
                        child: Image.asset(
                          'assets/images/app_logo.webp',
                          width: 44,
                          height: 44,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isAr ? 'متجر مصطفى عمار للأسماك' : 'Mostafa Ammar Pet Shop',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            Text(
                              isAr
                                  ? '١٤ شارع ٩، المعادي، القاهرة • يومياً ١٠ ص - ١١ م'
                                  : '14 Street 9, Maadi, Cairo • Open daily 10 AM – 11 PM',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: colors.mutedForeground,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      Expanded(
                        child: AppSecondaryButton(
                          icon: PhosphorIcons.whatsappLogo(),
                          label: isAr ? 'واتساب' : 'WhatsApp',
                          onPressed: () => launchUrl(
                            Uri.parse('https://wa.me/201012345678'),
                            mode: LaunchMode.externalApplication,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: AppSecondaryButton(
                          icon: PhosphorIcons.mapTrifold(),
                          label: isAr ? 'الموقع' : 'Map',
                          onPressed: () => launchUrl(
                            Uri.parse(
                              'https://maps.google.com/?q=29.9602,31.2569',
                            ),
                            mode: LaunchMode.externalApplication,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _SocialLaunchButton(
                        icon: PhosphorIcons.youtubeLogo(PhosphorIconsStyle.fill),
                        color: const Color(0xFFDC2626),
                        tooltip: 'YouTube',
                        url: 'https://www.youtube.com/@Mostafa.3mmar',
                      ),
                      _SocialLaunchButton(
                        icon: PhosphorIcons.facebookLogo(PhosphorIconsStyle.fill),
                        color: const Color(0xFF1877F2),
                        tooltip: 'Facebook',
                        url: 'https://www.facebook.com/darsh.ammar1',
                      ),
                      _SocialLaunchButton(
                        icon: PhosphorIcons.instagramLogo(PhosphorIconsStyle.fill),
                        color: const Color(0xFFE4405F),
                        tooltip: 'Instagram',
                        url: 'https://www.instagram.com/darshammar/reels/',
                      ),
                      _SocialLaunchButton(
                        icon: PhosphorIcons.tiktokLogo(PhosphorIconsStyle.fill),
                        color: const Color(0xFF0F172A),
                        tooltip: 'TikTok',
                        url: 'https://www.tiktok.com/discover/mostafa-ammar',
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Demo Tools
            const SizedBox(height: AppSpacing.md),
            AppCard(
              backgroundColor: colors.muted.withOpacity(0.55),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isAr
                        ? 'أدوات التجربة (+$simulatedDays يوم محاكاة)'
                        : 'Demo Tools (+$simulatedDays simulated days)',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ActionChip(
                        avatar: Icon(PhosphorIcons.fastForward(), size: 16),
                        label: Text(
                          isAr ? 'محاكاة +٥ أيام' : 'Simulate 5 days later',
                        ),
                        onPressed: () async {
                          await ref
                              .read(simulatedDaysProvider.notifier)
                              .advanceDays(5);
                          await NotificationService.instance.showInstant(
                            id: 505,
                            title: isAr
                                ? 'تنبيه طعام الأسماك'
                                : 'Fish Food Running Low',
                            body: isAr
                                ? 'حان وقت التحقق من مخزون الطعام وإعادة الطلب!'
                                : 'Time to check your food stock & tap to reorder!',
                            payload: 'food_tetramin_flakes',
                          );
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  isAr
                                      ? 'تم تقديم التاريخ ٥ أيام وإرسال تنبيه تجريبي'
                                      : 'Advanced +5 days & triggered local notification',
                                ),
                              ),
                            );
                          }
                        },
                      ),
                      ActionChip(
                        avatar: Icon(PhosphorIcons.coins(), size: 16),
                        label: Text(isAr ? '+٢٠٠ نقطة تجريبية' : '+200 test pts'),
                        onPressed: () => ref
                            .read(loyaltyProvider.notifier)
                            .addPoints(
                              points: 200,
                              titleEn: 'Demo Bonus Points',
                              titleAr: 'نقاط تجريبية',
                            ),
                      ),
                      ActionChip(
                        avatar: Icon(PhosphorIcons.arrowCounterClockwise(), size: 16),
                        label: Text(isAr ? 'إعادة ضبط البيانات' : 'Reset Data'),
                        onPressed: () async {
                          await ref.read(localStorageProvider).clearAll();
                          await ref.read(simulatedDaysProvider.notifier).reset();
                          await ref.read(userProvider.notifier).load();
                          await ref.read(loyaltyProvider.notifier).load();
                          await ref.read(couponsProvider.notifier).load();
                          await ref.read(ordersProvider.notifier).load();
                          await ref.read(remindersProvider.notifier).load();
                          await ref.read(tanksProvider.notifier).load();
                          await ref.read(cartProvider.notifier).load();
                        },
                      ),
                      ActionChip(
                        avatar: Icon(PhosphorIcons.sparkle(), size: 16),
                        label: Text(
                          isAr ? 'البدء كأول مرة' : 'Start as First Time',
                        ),
                        onPressed: () async {
                          await ref.read(localStorageProvider).clearAll();
                          await ref.read(simulatedDaysProvider.notifier).reset();
                          await ref.read(userProvider.notifier).load();
                          await ref.read(loyaltyProvider.notifier).load();
                          await ref.read(couponsProvider.notifier).load();
                          await ref.read(ordersProvider.notifier).load();
                          await ref.read(remindersProvider.notifier).load();
                          await ref.read(tanksProvider.notifier).load();
                          await ref.read(cartProvider.notifier).load();
                          if (context.mounted) context.go('/');
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Hidden Cashier Demo trigger (long press on version)
            const SizedBox(height: AppSpacing.lg),
            Center(
              child: GestureDetector(
                onLongPress: () => context.push('/cashier'),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  child: Text(
                    isAr
                        ? 'الإصدار 1.0.0 • اضغط مطولاً لوضع الكاشير'
                        : 'Version 1.0.0 • Long-press for Cashier Demo',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colors.mutedForeground,
                        ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }

  void _openEditProfileDialog(
    BuildContext context,
    WidgetRef ref,
    UserProfile user,
    bool isAr,
  ) {
    final nameCtrl = TextEditingController(text: user.name);
    final phoneCtrl = TextEditingController(text: user.phone);
    DateTime? birthday = user.birthday;

    showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text(isAr ? 'تعديل الملف الشخصي' : 'Edit Profile'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppTextField(
                controller: nameCtrl,
                label: isAr ? 'الاسم' : 'Name',
              ),
              const SizedBox(height: AppSpacing.sm),
              AppTextField(
                controller: phoneCtrl,
                label: isAr ? 'الهاتف' : 'Phone',
              ),
              const SizedBox(height: AppSpacing.sm),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(isAr ? 'تاريخ الميلاد (+٥٠ نقطة)' : 'Birthday (+50 pts)'),
                subtitle: Text(
                  birthday == null
                      ? (isAr ? 'غير محدد' : 'Not set')
                      : '${birthday!.year}-${birthday!.month}-${birthday!.day}',
                ),
                trailing: Icon(PhosphorIcons.calendar()),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: ctx,
                    initialDate: birthday ?? DateTime(1998, 5, 12),
                    firstDate: DateTime(1940),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    setDialogState(() => birthday = picked);
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(isAr ? 'إلغاء' : 'Cancel'),
            ),
            FilledButton(
              onPressed: () async {
                await ref.read(userProvider.notifier).updateProfile(
                      name: nameCtrl.text,
                      phone: phoneCtrl.text,
                      birthday: birthday,
                    );
                if (ctx.mounted) Navigator.pop(ctx);
              },
              child: Text(isAr ? 'حفظ' : 'Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _openAddressSheet(
    BuildContext context,
    WidgetRef ref,
    UserProfile user,
    bool isAr,
  ) {
    final areaCtrl = TextEditingController(text: 'Maadi');
    final streetCtrl = TextEditingController();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.sm,
          AppSpacing.lg,
          MediaQuery.of(ctx).viewInsets.bottom + AppSpacing.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isAr ? 'العناوين المحفوظة' : 'Saved Addresses',
              style: Theme.of(ctx).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.sm),
            ...user.addresses.map(
              (a) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(PhosphorIcons.mapPin()),
                title: Text('${a.label} (${a.area})'),
                subtitle: Text(a.street),
                trailing: IconButton(
                  icon: Icon(PhosphorIcons.trash()),
                  onPressed: () {
                    ref.read(userProvider.notifier).removeAddress(a.id);
                    Navigator.pop(ctx);
                  },
                ),
              ),
            ),
            const Divider(height: 20),
            AppTextField(
              controller: areaCtrl,
              label: isAr ? 'المنطقة' : 'Area',
            ),
            const SizedBox(height: AppSpacing.sm),
            AppTextField(
              controller: streetCtrl,
              label: isAr ? 'الشارع والعمارة' : 'Street & Building',
            ),
            const SizedBox(height: AppSpacing.md),
            AppPrimaryButton(
              label: isAr ? 'إضافة عنوان' : 'Add Address',
              onPressed: () async {
                if (streetCtrl.text.trim().isEmpty) return;
                await ref.read(userProvider.notifier).addAddress(
                      UserAddress(
                        id: 'addr_${DateTime.now().microsecondsSinceEpoch}',
                        label: isAr ? 'عنوان' : 'Address',
                        area: areaCtrl.text.trim(),
                        street: streetCtrl.text.trim(),
                        isDefault: true,
                      ),
                    );
                if (ctx.mounted) Navigator.pop(ctx);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SocialLaunchButton extends StatelessWidget {
  const _SocialLaunchButton({
    required this.icon,
    required this.color,
    required this.tooltip,
    required this.url,
  });

  final IconData icon;
  final Color color;
  final String tooltip;
  final String url;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: color.withOpacity(0.10),
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: () => launchUrl(
            Uri.parse(url),
            mode: LaunchMode.externalApplication,
          ),
          child: SizedBox(
            width: 48,
            height: 48,
            child: Icon(
              icon,
              color: color,
              size: 24,
              textDirection: TextDirection.ltr,
            ),
          ),
        ),
      ),
    );
  }
}

/// Optional hidden Cashier Demo screen (long-press app version).
class CashierDemoScreen extends ConsumerStatefulWidget {
  const CashierDemoScreen({super.key});

  @override
  ConsumerState<CashierDemoScreen> createState() => _CashierDemoScreenState();
}

class _CashierDemoScreenState extends ConsumerState<CashierDemoScreen> {
  final _memberCtrl = TextEditingController(text: 'AQP-482910');
  final _amountCtrl = TextEditingController(text: '350');

  @override
  void dispose() {
    _memberCtrl.dispose();
    _amountCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isAr = ref.watch(localeProvider).languageCode == 'ar';
    final tier = ref.watch(loyaltyProvider).valueOrNull?.tier;
    final multiplier = tier?.multiplier ?? 1.0;

    return Scaffold(
      appBar: AppBar(title: Text(isAr ? 'وضع الكاشير (تجريبي)' : 'Cashier Demo')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTextField(
              controller: _memberCtrl,
              label: isAr ? 'رقم عضوية العميل' : 'Customer Member ID',
              prefixIcon: PhosphorIcons.qrCode(),
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              controller: _amountCtrl,
              label: isAr ? 'قيمة الفاتورة (ج.م)' : 'Purchase Amount (EGP)',
              keyboardType: TextInputType.number,
              prefixIcon: PhosphorIcons.receipt(),
            ),
            const SizedBox(height: AppSpacing.lg),
            AppPrimaryButton(
              label: isAr ? 'منح النقاط للعميل' : 'Award Points',
              onPressed: () async {
                final amount = double.tryParse(_amountCtrl.text) ?? 0;
                final pts =
                    LoyaltyRules.calculateEarnedPoints(amount, multiplier);
                if (pts <= 0) return;
                await ref.read(loyaltyProvider.notifier).addPoints(
                      points: pts,
                      titleEn: 'In-Store Purchase (${_memberCtrl.text})',
                      titleAr: 'شراء من الفرع (${_memberCtrl.text})',
                    );
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isAr
                            ? 'تمت إضافة +$pts نقطة للعميل'
                            : 'Awarded +$pts points to ${_memberCtrl.text}',
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileIconBadge extends StatelessWidget {
  const _ProfileIconBadge({
    required this.icon,
    required this.color,
  });

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: color.withOpacity(0.13),
        borderRadius: BorderRadius.circular(AppRadii.md),
      ),
      child: Icon(icon, size: 20, color: color),
    );
  }
}

class _ShareQrCard extends StatelessWidget {
  const _ShareQrCard({required this.isAr});

  final bool isAr;

  static const _mobileUrl = 'https://aquapet-flutter-mobile.vercel.app';
  static const _websiteUrl = 'https://aquapet-mostafa-ammar.vercel.app';

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _ProfileIconBadge(
                icon: PhosphorIcons.qrCode(PhosphorIconsStyle.duotone),
                color: colors.primary,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isAr ? 'مشاركة التطبيق والموقع (QR)' : 'App & Website QR',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    Text(
                      isAr
                          ? 'اضغط لتكبير الباركود أو نسخ الرابط'
                          : 'Tap to enlarge or copy link',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: colors.mutedForeground,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: _QrTile(
                  title: isAr ? 'تطبيق الموبايل' : 'Mobile App',
                  url: _mobileUrl,
                  icon: PhosphorIcons.deviceMobile(PhosphorIconsStyle.duotone),
                  accent: colors.primary,
                  isAr: isAr,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _QrTile(
                  title: isAr ? 'الموقع الإلكتروني' : 'Website',
                  url: _websiteUrl,
                  icon: PhosphorIcons.globe(PhosphorIconsStyle.duotone),
                  accent: const Color(0xFF0284C7),
                  isAr: isAr,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QrTile extends StatelessWidget {
  const _QrTile({
    required this.title,
    required this.url,
    required this.icon,
    required this.accent,
    required this.isAr,
  });

  final String title;
  final String url;
  final IconData icon;
  final Color accent;
  final bool isAr;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Material(
      color: colors.muted.withOpacity(0.65),
      borderRadius: BorderRadius.circular(AppRadii.lg),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadii.lg),
        onTap: () => _openPreview(context),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadii.lg),
            border: Border.all(color: colors.border),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppRadii.md),
                ),
                child: QrImageView(
                  data: url,
                  version: QrVersions.auto,
                  size: 86,
                  backgroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 15, color: accent),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openPreview(BuildContext context) {
    final colors = context.appColors;
    showDialog<void>(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.xl),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: Theme.of(ctx).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: AppSpacing.md),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppRadii.lg),
                  border: Border.all(color: colors.border),
                ),
                child: QrImageView(
                  data: url,
                  version: QrVersions.auto,
                  size: 210,
                  backgroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              SelectableText(
                url,
                textAlign: TextAlign.center,
                style: Theme.of(ctx).textTheme.bodySmall?.copyWith(
                      color: colors.mutedForeground,
                    ),
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: AppSecondaryButton(
                      icon: PhosphorIcons.copy(),
                      label: isAr ? 'نسخ' : 'Copy',
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: url));
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              isAr ? 'تم نسخ الرابط' : 'Link copied',
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: AppPrimaryButton(
                      icon: PhosphorIcons.arrowSquareOut(),
                      label: isAr ? 'فتح' : 'Open',
                      onPressed: () {
                        Navigator.pop(ctx);
                        launchUrl(
                          Uri.parse(url),
                          mode: LaunchMode.externalApplication,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
