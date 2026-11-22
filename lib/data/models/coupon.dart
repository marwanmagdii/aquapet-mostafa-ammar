enum CouponType { percent, fixed, freeItem }

enum CouponStatus { available, used, expired }

class CouponModel {
  const CouponModel({
    required this.id,
    required this.code,
    required this.titleEn,
    required this.titleAr,
    required this.conditionEn,
    required this.conditionAr,
    required this.type,
    required this.value,
    required this.minOrderEgp,
    required this.expiresAt,
    required this.status,
  });

  final String id;
  final String code;
  final String titleEn;
  final String titleAr;
  final String conditionEn;
  final String conditionAr;
  final CouponType type;
  final double value;
  final double minOrderEgp;
  final DateTime expiresAt;
  final CouponStatus status;

  String title(bool isArabic) => isArabic ? titleAr : titleEn;
  String condition(bool isArabic) => isArabic ? conditionAr : conditionEn;

  double computeDiscount(double subtotal) {
    if (status != CouponStatus.available || subtotal < minOrderEgp) return 0;
    return switch (type) {
      CouponType.percent => (subtotal * (value / 100.0)).clamp(0, subtotal),
      CouponType.fixed => value.clamp(0, subtotal),
      CouponType.freeItem => value.clamp(0, subtotal),
    };
  }

  CouponModel copyWith({CouponStatus? status}) => CouponModel(
        id: id,
        code: code,
        titleEn: titleEn,
        titleAr: titleAr,
        conditionEn: conditionEn,
        conditionAr: conditionAr,
        type: type,
        value: value,
        minOrderEgp: minOrderEgp,
        expiresAt: expiresAt,
        status: status ?? this.status,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'code': code,
        'titleEn': titleEn,
        'titleAr': titleAr,
        'conditionEn': conditionEn,
        'conditionAr': conditionAr,
        'type': type.name,
        'value': value,
        'minOrderEgp': minOrderEgp,
        'expiresAt': expiresAt.toIso8601String(),
        'status': status.name,
      };

  factory CouponModel.fromJson(Map<String, dynamic> json) => CouponModel(
        id: json['id'] as String,
        code: json['code'] as String,
        titleEn: json['titleEn'] as String,
        titleAr: json['titleAr'] as String,
        conditionEn: json['conditionEn'] as String,
        conditionAr: json['conditionAr'] as String,
        type: CouponType.values.byName(json['type'] as String),
        value: (json['value'] as num).toDouble(),
        minOrderEgp: (json['minOrderEgp'] as num).toDouble(),
        expiresAt: DateTime.parse(json['expiresAt'] as String),
        status: CouponStatus.values.byName(json['status'] as String),
      );
}
