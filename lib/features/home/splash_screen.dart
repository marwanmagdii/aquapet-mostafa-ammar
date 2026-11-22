import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';

import '../../core/tokens/app_tokens.dart';
import '../../data/repositories/app_providers.dart';
import 'web_splash_video.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key, this.nextRoute});

  final String? nextRoute;

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  VideoPlayerController? _controller;
  Timer? _fallbackTimer;
  bool _navigated = false;
  Widget? _webVideo;

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      _webVideo = buildWebSplashVideo(
        assetPath: 'assets/videos/splash_intro.mp4',
        onEnded: _goNext,
        onError: () {
          _fallbackTimer?.cancel();
          _fallbackTimer = Timer(const Duration(milliseconds: 600), _goNext);
        },
      );
      _fallbackTimer = Timer(const Duration(seconds: 10), _goNext);
    } else {
      _initVideo();
      // Safety fallback in case autoplay or video decoding is blocked.
      _fallbackTimer = Timer(const Duration(seconds: 6), _goNext);
    }
  }

  Future<void> _initVideo() async {
    try {
      final ctrl = VideoPlayerController.asset('assets/videos/splash_intro.mp4');
      _controller = ctrl;
      await ctrl.initialize();
      await ctrl.setVolume(0); // Muted so web autoplay is never blocked.
      ctrl.addListener(_onVideoTick);
      if (mounted) {
        setState(() {});
        await ctrl.play();
      }
    } catch (_) {
      _fallbackTimer?.cancel();
      _fallbackTimer = Timer(const Duration(milliseconds: 600), _goNext);
    }
  }

  void _onVideoTick() {
    final ctrl = _controller;
    if (ctrl == null || !ctrl.value.isInitialized) return;
    if (ctrl.value.position >= ctrl.value.duration &&
        ctrl.value.duration > Duration.zero) {
      _goNext();
    }
  }

  void _goNext() {
    if (_navigated || !mounted) return;
    _navigated = true;
    final user = ref.read(userProvider).valueOrNull;
    final target = widget.nextRoute ??
        (user == null || !user.isOnboarded
            ? '/onboarding'
            : (!user.isLoggedIn ? '/auth' : '/home'));
    context.go(target);
  }

  @override
  void dispose() {
    _fallbackTimer?.cancel();
    _controller?.removeListener(_onVideoTick);
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = _controller;
    final ready = ctrl != null && ctrl.value.isInitialized;
    final isAr = ref.watch(localeProvider).languageCode == 'ar';

    final content = Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (kIsWeb && _webVideo != null)
            Positioned.fill(child: _webVideo!)
          else if (ready)
            FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: ctrl.value.size.width,
                height: ctrl.value.size.height,
                child: VideoPlayer(ctrl),
              ),
            )
          else
            Center(
              child: ClipOval(
                child: Image.asset(
                  'assets/images/app_logo.webp',
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          PositionedDirectional(
            top: AppSpacing.md,
            end: AppSpacing.md,
            child: SafeArea(
              child: FilledButton.tonal(
                onPressed: _goNext,
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.black.withOpacity(0.45),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(48, 38),
                ),
                child: Text(isAr ? 'تخطي' : 'Skip'),
              ),
            ),
          ),
        ],
      ),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth <= 520) return content;
        return Container(
          color: const Color(0xFFE4F1F1),
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Container(
            width: 430,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: Theme.of(context).colorScheme.outline,
                width: 1.5,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x180F2A2E),
                  blurRadius: 32,
                  offset: Offset(0, 14),
                ),
              ],
            ),
            child: content,
          ),
        );
      },
    );
  }
}
