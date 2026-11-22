enum ReminderType {
  foodRunOut,
  feedingSchedule,
  waterChange,
  filterMedia,
}

enum FeedingRepeatMode {
  daily,
  everyNDays,
  weekdays, // 1=Mon .. 7=Sun (DateTime.weekday)
}

class ReminderModel {
  const ReminderModel({
    required this.id,
    required this.type,
    required this.titleEn,
    required this.titleAr,
    required this.isEnabled,
    required this.createdAt,
    this.tankId,
    this.productId,
    this.bagGrams,
    this.dailyGrams,
    this.snoozedDays = 0,
    this.intervalDays = 7,
    this.lastCompletedAt,
    this.feedHour = 15,
    this.feedMinute = 0,
    this.repeatMode = FeedingRepeatMode.daily,
    this.weekdays = const [7],
  });

  final String id;
  final ReminderType type;
  final String titleEn;
  final String titleAr;
  final bool isEnabled;
  final DateTime createdAt;
  final String? tankId;
  final String? productId;
  final int? bagGrams;
  final double? dailyGrams;
  final int snoozedDays;
  final int intervalDays;
  final DateTime? lastCompletedAt;

  // Feeding schedule fields
  final int feedHour;
  final int feedMinute;
  final FeedingRepeatMode repeatMode;
  final List<int> weekdays; // DateTime.monday(1)..DateTime.sunday(7)

  String title(bool isArabic) => isArabic ? titleAr : titleEn;

  /// Remaining days for food run-out, or days until next water/filter due.
  int daysLeftAt(DateTime now) {
    if (type == ReminderType.foodRunOut &&
        bagGrams != null &&
        dailyGrams != null &&
        dailyGrams! > 0) {
      final elapsed = now.difference(createdAt).inDays;
      final totalDays = (bagGrams! / dailyGrams!) + snoozedDays;
      final rem = (totalDays - elapsed).ceil();
      return rem < 0 ? 0 : rem;
    }
    if (type == ReminderType.waterChange || type == ReminderType.filterMedia) {
      final anchor = lastCompletedAt ?? createdAt;
      final nextDue = anchor.add(Duration(days: intervalDays + snoozedDays));
      final rem = nextDue.difference(now).inDays;
      return rem < 0 ? 0 : rem;
    }
    return 0;
  }

  /// Fraction remaining (1.0 = full, 0.0 = empty) for food run-out progress bar.
  double remainingRatioAt(DateTime now) {
    if (type != ReminderType.foodRunOut ||
        bagGrams == null ||
        dailyGrams == null ||
        dailyGrams! <= 0) {
      return 1.0;
    }
    final totalDays = (bagGrams! / dailyGrams!) + snoozedDays;
    if (totalDays <= 0) return 0.0;
    return (daysLeftAt(now) / totalDays).clamp(0.0, 1.0);
  }

  ReminderModel copyWith({
    String? titleEn,
    String? titleAr,
    bool? isEnabled,
    DateTime? createdAt,
    String? tankId,
    String? productId,
    int? bagGrams,
    double? dailyGrams,
    int? snoozedDays,
    int? intervalDays,
    DateTime? lastCompletedAt,
    int? feedHour,
    int? feedMinute,
    FeedingRepeatMode? repeatMode,
    List<int>? weekdays,
  }) {
    return ReminderModel(
      id: id,
      type: type,
      titleEn: titleEn ?? this.titleEn,
      titleAr: titleAr ?? this.titleAr,
      isEnabled: isEnabled ?? this.isEnabled,
      createdAt: createdAt ?? this.createdAt,
      tankId: tankId ?? this.tankId,
      productId: productId ?? this.productId,
      bagGrams: bagGrams ?? this.bagGrams,
      dailyGrams: dailyGrams ?? this.dailyGrams,
      snoozedDays: snoozedDays ?? this.snoozedDays,
      intervalDays: intervalDays ?? this.intervalDays,
      lastCompletedAt: lastCompletedAt ?? this.lastCompletedAt,
      feedHour: feedHour ?? this.feedHour,
      feedMinute: feedMinute ?? this.feedMinute,
      repeatMode: repeatMode ?? this.repeatMode,
      weekdays: weekdays ?? this.weekdays,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.name,
        'titleEn': titleEn,
        'titleAr': titleAr,
        'isEnabled': isEnabled,
        'createdAt': createdAt.toIso8601String(),
        'tankId': tankId,
        'productId': productId,
        'bagGrams': bagGrams,
        'dailyGrams': dailyGrams,
        'snoozedDays': snoozedDays,
        'intervalDays': intervalDays,
        'lastCompletedAt': lastCompletedAt?.toIso8601String(),
        'feedHour': feedHour,
        'feedMinute': feedMinute,
        'repeatMode': repeatMode.name,
        'weekdays': weekdays,
      };

  factory ReminderModel.fromJson(Map<String, dynamic> json) => ReminderModel(
        id: json['id'] as String,
        type: ReminderType.values.byName(json['type'] as String),
        titleEn: json['titleEn'] as String,
        titleAr: json['titleAr'] as String,
        isEnabled: json['isEnabled'] as bool? ?? true,
        createdAt: DateTime.parse(json['createdAt'] as String),
        tankId: json['tankId'] as String?,
        productId: json['productId'] as String?,
        bagGrams: json['bagGrams'] as int?,
        dailyGrams: (json['dailyGrams'] as num?)?.toDouble(),
        snoozedDays: json['snoozedDays'] as int? ?? 0,
        intervalDays: json['intervalDays'] as int? ?? 7,
        lastCompletedAt: json['lastCompletedAt'] != null
            ? DateTime.tryParse(json['lastCompletedAt'] as String)
            : null,
        feedHour: json['feedHour'] as int? ?? 15,
        feedMinute: json['feedMinute'] as int? ?? 0,
        repeatMode: json['repeatMode'] != null
            ? FeedingRepeatMode.values.byName(json['repeatMode'] as String)
            : FeedingRepeatMode.daily,
        weekdays: (json['weekdays'] as List<dynamic>? ?? [7])
            .map((e) => e as int)
            .toList(),
      );
}

class TankModel {
  const TankModel({
    required this.id,
    required this.name,
    required this.sizeLiters,
    required this.waterType,
    required this.fishSummary,
    required this.fishCount,
  });

  final String id;
  final String name;
  final int sizeLiters;
  final String waterType; // 'fresh' or 'salt'
  final String fishSummary;
  final int fishCount;

  /// Suggested daily feeding grams based on fish count.
  double get recommendedDailyGrams => (fishCount * 0.35).clamp(1.0, 25.0);

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'sizeLiters': sizeLiters,
        'waterType': waterType,
        'fishSummary': fishSummary,
        'fishCount': fishCount,
      };

  factory TankModel.fromJson(Map<String, dynamic> json) => TankModel(
        id: json['id'] as String,
        name: json['name'] as String,
        sizeLiters: json['sizeLiters'] as int,
        waterType: json['waterType'] as String,
        fishSummary: json['fishSummary'] as String,
        fishCount: json['fishCount'] as int,
      );
}
