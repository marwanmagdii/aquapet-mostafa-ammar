class VetModel {
  const VetModel({
    required this.id,
    required this.nameEn,
    required this.nameAr,
    required this.clinicEn,
    required this.clinicAr,
    required this.specialtyEn,
    required this.specialtyAr,
    required this.areaEn,
    required this.areaAr,
    required this.imageAsset,
    required this.bioEn,
    required this.bioAr,
    this.phone,
    this.whatsapp,
    this.socialLinks = const {},
    this.mapUrl,
  });

  final String id;
  final String nameEn;
  final String nameAr;
  final String clinicEn;
  final String clinicAr;
  final String specialtyEn;
  final String specialtyAr;
  final String areaEn;
  final String areaAr;
  final String imageAsset;
  final String bioEn;
  final String bioAr;
  final String? phone;
  final String? whatsapp;
  final Map<String, String> socialLinks;
  final String? mapUrl;

  String name(bool isArabic) => isArabic ? nameAr : nameEn;
  String clinic(bool isArabic) => isArabic ? clinicAr : clinicEn;
  String specialty(bool isArabic) => isArabic ? specialtyAr : specialtyEn;
  String area(bool isArabic) => isArabic ? areaAr : areaEn;
  String bio(bool isArabic) => isArabic ? bioAr : bioEn;
}
