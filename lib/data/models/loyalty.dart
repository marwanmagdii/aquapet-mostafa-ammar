import '../../core/utils/loyalty_rules.dart';

enum LoyaltyTier {
  bronze,
  silver,
  gold;

  double get multiplier => switch (this) {
        LoyaltyTier.bronze => LoyaltyRules.bronzeMultiplier,
        LoyaltyTier.silver => LoyaltyRules.silverMultiplier,
        LoyaltyTier.gold => LoyaltyRules.goldMultiplier,
      };

  static LoyaltyTier fromLifetimePoints(int lifetimePoints) {
    if (lifetimePoints >= LoyaltyRules.goldThreshold) return LoyaltyTier.gold;
    if (lifetimePoints >= LoyaltyRules.silverThreshold) {
      return LoyaltyTier.silver;
    }
    return LoyaltyTier.bronze;
  }
}

class PointsTransaction {
  const PointsTransaction({
    required this.id,
    required this.titleEn,
    required this.titleAr,
    required this.points,
    required this.createdAt,
  });

  final String id;
  final String titleEn;
  final String titleAr;
  final int points; // positive = earned, negative = spent
  final DateTime createdAt;

  String title(bool isArabic) => isArabic ? titleAr : titleEn;

  Map<String, dynamic> toJson() => {
        'id': id,
        'titleEn': titleEn,
        'titleAr': titleAr,
        'points': points,
        'createdAt': createdAt.toIso8601String(),
      };

  factory PointsTransaction.fromJson(Map<String, dynamic> json) =>
      PointsTransaction(
        id: json['id'] as String,
        titleEn: json['titleEn'] as String,
        titleAr: json['titleAr'] as String,
        points: json['points'] as int,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}

class RewardItem {
  const RewardItem({
    required this.id,
    required this.titleEn,
    required this.titleAr,
    required this.subtitleEn,
    required this.subtitleAr,
    required this.pointsCost,
    required this.discountEgp,
    required this.isFreeItem,
    required this.imageAsset,
    this.imageUrl,
    this.couponCodePrefix = 'RWD',
  });

  final String id;
  final String titleEn;
  final String titleAr;
  final String subtitleEn;
  final String subtitleAr;
  final int pointsCost;
  final double discountEgp;
  final bool isFreeItem;
  final String imageAsset;
  final String? imageUrl;
  final String couponCodePrefix;

  String title(bool isArabic) => isArabic ? titleAr : titleEn;
  String subtitle(bool isArabic) => isArabic ? subtitleAr : subtitleEn;
}

class LoyaltyState {
  const LoyaltyState({
    required this.balancePoints,
    required this.lifetimePoints,
    required this.transactions,
  });

  final int balancePoints;
  final int lifetimePoints;
  final List<PointsTransaction> transactions;

  LoyaltyTier get tier => LoyaltyTier.fromLifetimePoints(lifetimePoints);

  int? get nextTierThreshold => switch (tier) {
        LoyaltyTier.bronze => LoyaltyRules.silverThreshold,
        LoyaltyTier.silver => LoyaltyRules.goldThreshold,
        LoyaltyTier.gold => null,
      };

  double get progressToNextTier {
    if (tier == LoyaltyTier.gold) return 1.0;
    final start =
        tier == LoyaltyTier.bronze ? 0 : LoyaltyRules.silverThreshold;
    final end = nextTierThreshold!;
    return ((lifetimePoints - start) / (end - start)).clamp(0.0, 1.0);
  }

  LoyaltyState copyWith({
    int? balancePoints,
    int? lifetimePoints,
    List<PointsTransaction>? transactions,
  }) =>
      LoyaltyState(
        balancePoints: balancePoints ?? this.balancePoints,
        lifetimePoints: lifetimePoints ?? this.lifetimePoints,
        transactions: transactions ?? this.transactions,
      );

  Map<String, dynamic> toJson() => {
        'balancePoints': balancePoints,
        'lifetimePoints': lifetimePoints,
        'transactions': transactions.map((e) => e.toJson()).toList(),
      };

  factory LoyaltyState.fromJson(Map<String, dynamic> json) => LoyaltyState(
        balancePoints: json['balancePoints'] as int,
        lifetimePoints: json['lifetimePoints'] as int,
        transactions: (json['transactions'] as List<dynamic>)
            .map((e) => PointsTransaction.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}
