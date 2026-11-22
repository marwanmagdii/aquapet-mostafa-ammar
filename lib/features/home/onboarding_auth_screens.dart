import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../core/tokens/app_tokens.dart';
import '../../data/repositories/app_providers.dart';
import '../../shared/widgets/shared_widgets.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _controller = PageController();
  int _page = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isAr = ref.watch(localeProvider).languageCode == 'ar';
    final colors = context.appColors;

    final slides = [
      (
        icon: PhosphorIcons.fishSimple(),
        title: isAr ? 'عالم أسماك متكامل' : 'Healthy Fish & Supplies',
        body: isAr
            ? 'أسماك زينة، طعام متوازن، أحواض وفلاتر مختارة بعناية وتوصيل آمن لباب بيتك.'
            : 'Curated freshwater & marine fish, balanced food, and quiet filtration delivered with care.',
        gradient: [colors.primary, colors.secondary],
      ),
      (
        icon: PhosphorIcons.bellRinging(),
        title: isAr ? 'تذكيرات ذكية للطعام والحوض' : 'Smart Food & Tank Reminders',
        body: isAr
            ? 'نحسب لك متى ينفد طعام الأسماك ونذكرك بمواعيد الإطعام وتغيير المياه تلقائياً.'
            : 'We estimate when your fish food runs out and remind you of feeding times and water changes.',
        gradient: [colors.secondary, AppColors.teal700],
      ),
      (
        icon: PhosphorIcons.crownSimple(),
        title: isAr ? 'نقاط ومكافآت مع كل طلب' : 'Loyalty Card & Rewards',
        body: isAr
            ? 'احصل على ١٠٠ نقطة ترحيب فورية، واجمع نقاطاً وخصومات مع كل عملية شراء.'
            : 'Get 100 welcome points on sign-up, unlock Silver & Gold multipliers, and collect food stamps.',
        gradient: [colors.accent, colors.primary],
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => ref.read(localeProvider.notifier).toggle(),
                    child: Text(isAr ? 'English' : 'العربية'),
                  ),
                  TextButton(
                    onPressed: () async {
                      await ref.read(userProvider.notifier).completeOnboarding();
                      if (context.mounted) context.go('/auth');
                    },
                    child: Text(isAr ? 'تخطي' : 'Skip'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: slides.length,
                onPageChanged: (index) => setState(() => _page = index),
                itemBuilder: (context, index) {
                  final slide = slides[index];
                  return Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (index == 0)
                          ClipOval(
                            child: Image.asset(
                              'assets/images/app_logo.webp',
                              width: 190,
                              height: 190,
                              fit: BoxFit.cover,
                            ),
                          )
                        else
                          Container(
                            width: 190,
                            height: 190,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(36),
                              gradient: LinearGradient(
                                begin: AlignmentDirectional.topStart,
                                end: AlignmentDirectional.bottomEnd,
                                colors: slide.gradient,
                              ),
                            ),
                            child: Icon(
                              slide.icon,
                              size: 84,
                              color: Colors.white,
                            ),
                          ),
                        const SizedBox(height: AppSpacing.xl),
                        Text(
                          slide.title,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          slide.body,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: colors.mutedForeground,
                                height: 1.5,
                              ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      slides.length,
                      (i) => AnimatedContainer(
                        duration: AppDurations.normal,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _page == i ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _page == i ? colors.primary : colors.border,
                          borderRadius: BorderRadius.circular(AppRadii.pill),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  AppPrimaryButton(
                    label: _page == slides.length - 1
                        ? (isAr ? 'ابدأ الآن' : 'Get Started')
                        : (isAr ? 'التالي' : 'Next'),
                    onPressed: () async {
                      if (_page < slides.length - 1) {
                        _controller.nextPage(
                          duration: AppDurations.normal,
                          curve: Curves.easeOutCubic,
                        );
                      } else {
                        await ref
                            .read(userProvider.notifier)
                            .completeOnboarding();
                        if (context.mounted) context.go('/auth');
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _nameCtrl = TextEditingController(text: 'Omar');
  final _phoneCtrl = TextEditingController(text: '+201012345678');
  final _otpCtrl = TextEditingController();
  bool _otpStep = false;
  bool _submitting = false;
  String? _error;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _otpCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isAr = ref.watch(localeProvider).languageCode == 'ar';
    final colors = context.appColors;

    return Scaffold(
      appBar: AppBar(
        title: Text(isAr ? 'تسجيل الدخول' : 'Sign In'),
        actions: [
          TextButton(
            onPressed: () => ref.read(localeProvider.notifier).toggle(),
            child: Text(isAr ? 'English' : 'العربية'),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppCard(
                backgroundColor: colors.primary.withOpacity(0.08),
                borderColor: colors.primary.withOpacity(0.25),
                child: Row(
                  children: [
                    Icon(PhosphorIcons.gift(), color: colors.accent, size: 28),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Text(
                        isAr
                            ? 'احصل على ١٠٠ نقطة ترحيب مجانية عند تسجيل دخولك الأول!'
                            : 'Get 100 welcome points immediately on your first sign-in.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              if (!_otpStep) ...[
                Text(
                  isAr ? 'أهلاً بك في أكوا بت' : 'Welcome to AquaPet',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  isAr
                      ? 'أدخل اسمك ورقم هاتفك للمتابعة'
                      : 'Enter your name and phone number to continue',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colors.mutedForeground,
                      ),
                ),
                const SizedBox(height: AppSpacing.lg),
                AppTextField(
                  controller: _nameCtrl,
                  label: isAr ? 'الاسم' : 'Full Name',
                  prefixIcon: PhosphorIcons.user(),
                ),
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  controller: _phoneCtrl,
                  label: isAr ? 'رقم الهاتف' : 'Phone Number',
                  hint: '+2010XXXXXXXX',
                  keyboardType: TextInputType.phone,
                  prefixIcon: PhosphorIcons.phone(),
                ),
              ] else ...[
                Text(
                  isAr ? 'تأكيد رمز التحقق' : 'Verify OTP Code',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  isAr
                      ? 'أدخل أي ٤ أرقام لتأكيد رقم ${_phoneCtrl.text} (وضع تجريبي)'
                      : 'Enter any 4 digits to verify ${_phoneCtrl.text} (demo mode)',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colors.mutedForeground,
                      ),
                ),
                const SizedBox(height: AppSpacing.lg),
                AppTextField(
                  controller: _otpCtrl,
                  label: isAr ? 'رمز التحقق (٤ أرقام)' : '4-Digit OTP',
                  hint: '1234',
                  keyboardType: TextInputType.number,
                  prefixIcon: PhosphorIcons.lockKey(),
                ),
              ],
              if (_error != null) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(
                  _error!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colors.danger,
                      ),
                ),
              ],
              const SizedBox(height: AppSpacing.xl),
              AppPrimaryButton(
                isLoading: _submitting,
                label: _otpStep
                    ? (isAr ? 'تأكيد ودخول' : 'Verify & Continue')
                    : (isAr ? 'إرسال رمز التحقق' : 'Send OTP'),
                onPressed: () async {
                  setState(() => _error = null);
                  if (!_otpStep) {
                    if (_phoneCtrl.text.trim().length < 6) {
                      setState(() {
                        _error = isAr
                            ? 'يرجى إدخال رقم هاتف صحيح'
                            : 'Please enter a valid phone number';
                      });
                      return;
                    }
                    setState(() => _otpStep = true);
                    return;
                  }

                  if (_otpCtrl.text.trim().length != 4) {
                    setState(() {
                      _error = isAr
                          ? 'يرجى إدخال ٤ أرقام'
                          : 'Please enter any 4 digits';
                    });
                    return;
                  }

                  setState(() => _submitting = true);
                  await ref.read(userProvider.notifier).loginWithPhone(
                        phone: _phoneCtrl.text.trim(),
                        name: _nameCtrl.text.trim(),
                      );
                  if (mounted) {
                    setState(() => _submitting = false);
                    this.context.go('/home');
                  }
                },
              ),
              if (_otpStep) ...[
                const SizedBox(height: AppSpacing.sm),
                Center(
                  child: TextButton(
                    onPressed: () => setState(() => _otpStep = false),
                    child: Text(isAr ? 'تعديل رقم الهاتف' : 'Edit phone number'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
