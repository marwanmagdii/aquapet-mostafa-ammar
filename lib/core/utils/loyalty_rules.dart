/// Business rules and constants for loyalty, coupons, and food reminders.
/// Edit these constants to adjust earning rates or thresholds without touching UI.
abstract final class LoyaltyRules {
  /// Base earning: 1 point per 10 EGP spent.
  static const double egpPerPoint = 10.0;

  /// Redemption value: 100 points = 10 EGP discount (0.10 EGP per point).
  static const double egpPer100Points = 10.0;

  /// Lifetime points required to reach each tier.
  static const int silverThreshold = 1000;
  static const int goldThreshold = 3000;

  /// Earning multipliers per tier.
  static const double bronzeMultiplier = 1.0;
  static const double silverMultiplier = 1.25;
  static const double goldMultiplier = 1.5;

  /// One-time & promotional bonus points.
  static const int welcomeBonusPoints = 100;
  static const int birthdayBonusPoints = 150;
  static const int profileCompleteBonusPoints = 50;
  static const int firstTankBonusPoints = 100;
  static const int referralBonusPoints = 150;

  /// Fish food stamp card target.
  static const int stampsForFreeBag = 10;

  /// Delivery fee calculation by Cairo/Giza area (EGP).
  static const Map<String, double> deliveryFeesByArea = {
    'Maadi': 35,
    'Zamalek': 40,
    'Nasr City': 45,
    'New Cairo': 55,
    'Heliopolis': 45,
    'Dokki / Mohandessin': 40,
    '6th of October': 65,
    'Sheikh Zayed': 65,
  };

  /// Calculate points earned for an order subtotal/total in EGP.
  static int calculateEarnedPoints(double amountEgp, double multiplier) {
    if (amountEgp <= 0) return 0;
    return ((amountEgp / egpPerPoint) * multiplier).floor();
  }

  /// Convert points to EGP discount.
  static double pointsToEgp(int points) {
    return (points / 100.0) * egpPer100Points;
  }

  /// Calculate estimated days left for a fish food bag.
  static int calculateDaysLeft({
    required int bagGrams,
    required double dailyGrams,
    required int elapsedDays,
  }) {
    if (dailyGrams <= 0) return 999;
    final totalDays = bagGrams / dailyGrams;
    final remaining = (totalDays - elapsedDays).ceil();
    return remaining < 0 ? 0 : remaining;
  }
}
