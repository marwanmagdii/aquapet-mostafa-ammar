import 'package:flutter/material.dart';

/// Primitive and semantic design tokens for AquaPet.
/// Derived from design-system/petshop/MASTER.md.
abstract final class AppColors {
  // Primitive / Brand
  static const Color teal600 = Color(0xFF0D9488);
  static const Color teal700 = Color(0xFF0F766E);
  static const Color teal500 = Color(0xFF14B8A6);
  static const Color teal100 = Color(0xFFCCFBF1);
  static const Color teal50 = Color(0xFFF0FDFA);

  static const Color aqua600 = Color(0xFF0891B2);
  static const Color aqua700 = Color(0xFF0E7490);
  static const Color aqua100 = Color(0xFFCFFAFE);

  static const Color coral500 = Color(0xFFF97316);
  static const Color coral600 = Color(0xFFEA580C);
  static const Color coral100 = Color(0xFFFFEDD5);
  static const Color coral50 = Color(0xFFFFF7ED);

  static const Color amber500 = Color(0xFFD97706);
  static const Color amber100 = Color(0xFFFEF3C7);

  static const Color emerald600 = Color(0xFF059669);
  static const Color emerald100 = Color(0xFFD1FAE5);

  static const Color red600 = Color(0xFFDC2626);
  static const Color red100 = Color(0xFFFEE2E2);

  // Light Mode Surfaces & Ink
  static const Color lightBackground = Color(0xFFF4FAFA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightMuted = Color(0xFFE6F2F2);
  static const Color lightBorder = Color(0xFFD5ECEB);
  static const Color lightForeground = Color(0xFF0F2A2E);
  static const Color lightMutedForeground = Color(0xFF476368);

  // Dark Mode Surfaces & Ink
  static const Color darkBackground = Color(0xFF09171A);
  static const Color darkSurface = Color(0xFF102428);
  static const Color darkMuted = Color(0xFF173238);
  static const Color darkBorder = Color(0xFF1F4249);
  static const Color darkForeground = Color(0xFFEAF6F6);
  static const Color darkMutedForeground = Color(0xFF94B4B9);

  // Loyalty Tiers
  static const Color tierBronze = Color(0xFFB45309);
  static const Color tierSilver = Color(0xFF475569);
  static const Color tierGold = Color(0xFFD97706);
}

abstract final class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
  static const double minTouchTarget = 48;
}

abstract final class AppRadii {
  static const double sm = 10;
  static const double md = 14;
  static const double lg = 20;
  static const double xl = 24;
  static const double pill = 999;
}

abstract final class AppDurations {
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 240);
  static const Duration slow = Duration(milliseconds: 380);
}

/// Custom ThemeExtension exposing semantic aquatic tokens via `Theme.of(context)`.
@immutable
class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  const AppColorsExtension({
    required this.background,
    required this.surface,
    required this.muted,
    required this.border,
    required this.foreground,
    required this.mutedForeground,
    required this.primary,
    required this.onPrimary,
    required this.secondary,
    required this.accent,
    required this.onAccent,
    required this.success,
    required this.successSurface,
    required this.warning,
    required this.warningSurface,
    required this.danger,
    required this.dangerSurface,
    required this.loyaltyGradientStart,
    required this.loyaltyGradientEnd,
  });

  final Color background;
  final Color surface;
  final Color muted;
  final Color border;
  final Color foreground;
  final Color mutedForeground;
  final Color primary;
  final Color onPrimary;
  final Color secondary;
  final Color accent;
  final Color onAccent;
  final Color success;
  final Color successSurface;
  final Color warning;
  final Color warningSurface;
  final Color danger;
  final Color dangerSurface;
  final Color loyaltyGradientStart;
  final Color loyaltyGradientEnd;

  static const AppColorsExtension light = AppColorsExtension(
    background: AppColors.lightBackground,
    surface: AppColors.lightSurface,
    muted: AppColors.lightMuted,
    border: AppColors.lightBorder,
    foreground: AppColors.lightForeground,
    mutedForeground: AppColors.lightMutedForeground,
    primary: AppColors.teal600,
    onPrimary: Colors.white,
    secondary: AppColors.aqua600,
    accent: AppColors.coral600,
    onAccent: Colors.white,
    success: AppColors.emerald600,
    successSurface: AppColors.emerald100,
    warning: AppColors.amber500,
    warningSurface: AppColors.amber100,
    danger: AppColors.red600,
    dangerSurface: AppColors.red100,
    loyaltyGradientStart: Color(0xFF0F766E),
    loyaltyGradientEnd: Color(0xFF0891B2),
  );

  static const AppColorsExtension dark = AppColorsExtension(
    background: AppColors.darkBackground,
    surface: AppColors.darkSurface,
    muted: AppColors.darkMuted,
    border: AppColors.darkBorder,
    foreground: AppColors.darkForeground,
    mutedForeground: AppColors.darkMutedForeground,
    primary: AppColors.teal500,
    onPrimary: Color(0xFF042F2E),
    secondary: Color(0xFF22D3EE),
    accent: AppColors.coral500,
    onAccent: Color(0xFF1F0E03),
    success: Color(0xFF34D399),
    successSurface: Color(0xFF064E3B),
    warning: Color(0xFFFBBF24),
    warningSurface: Color(0xFF451A03),
    danger: Color(0xFFF87171),
    dangerSurface: Color(0xFF450A0A),
    loyaltyGradientStart: Color(0xFF115E59),
    loyaltyGradientEnd: Color(0xFF0E7490),
  );

  @override
  AppColorsExtension copyWith({
    Color? background,
    Color? surface,
    Color? muted,
    Color? border,
    Color? foreground,
    Color? mutedForeground,
    Color? primary,
    Color? onPrimary,
    Color? secondary,
    Color? accent,
    Color? onAccent,
    Color? success,
    Color? successSurface,
    Color? warning,
    Color? warningSurface,
    Color? danger,
    Color? dangerSurface,
    Color? loyaltyGradientStart,
    Color? loyaltyGradientEnd,
  }) {
    return AppColorsExtension(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      muted: muted ?? this.muted,
      border: border ?? this.border,
      foreground: foreground ?? this.foreground,
      mutedForeground: mutedForeground ?? this.mutedForeground,
      primary: primary ?? this.primary,
      onPrimary: onPrimary ?? this.onPrimary,
      secondary: secondary ?? this.secondary,
      accent: accent ?? this.accent,
      onAccent: onAccent ?? this.onAccent,
      success: success ?? this.success,
      successSurface: successSurface ?? this.successSurface,
      warning: warning ?? this.warning,
      warningSurface: warningSurface ?? this.warningSurface,
      danger: danger ?? this.danger,
      dangerSurface: dangerSurface ?? this.dangerSurface,
      loyaltyGradientStart: loyaltyGradientStart ?? this.loyaltyGradientStart,
      loyaltyGradientEnd: loyaltyGradientEnd ?? this.loyaltyGradientEnd,
    );
  }

  @override
  AppColorsExtension lerp(covariant AppColorsExtension? other, double t) {
    if (other is! AppColorsExtension) return this;
    return AppColorsExtension(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      muted: Color.lerp(muted, other.muted, t)!,
      border: Color.lerp(border, other.border, t)!,
      foreground: Color.lerp(foreground, other.foreground, t)!,
      mutedForeground: Color.lerp(mutedForeground, other.mutedForeground, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      onAccent: Color.lerp(onAccent, other.onAccent, t)!,
      success: Color.lerp(success, other.success, t)!,
      successSurface: Color.lerp(successSurface, other.successSurface, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      warningSurface: Color.lerp(warningSurface, other.warningSurface, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      dangerSurface: Color.lerp(dangerSurface, other.dangerSurface, t)!,
      loyaltyGradientStart:
          Color.lerp(loyaltyGradientStart, other.loyaltyGradientStart, t)!,
      loyaltyGradientEnd:
          Color.lerp(loyaltyGradientEnd, other.loyaltyGradientEnd, t)!,
    );
  }
}

extension AppThemeContextX on BuildContext {
  AppColorsExtension get appColors =>
      Theme.of(this).extension<AppColorsExtension>() ??
      AppColorsExtension.light;
}
