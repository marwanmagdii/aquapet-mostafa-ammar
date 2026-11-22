enum ProductCategory {
  fish,
  food,
  tanks,
  filters,
  waterCare,
  decor,
}

class ProductVariant {
  const ProductVariant({
    required this.id,
    required this.labelEn,
    required this.labelAr,
    required this.priceEgp,
    required this.stock,
    this.grams,
  });

  final String id;
  final String labelEn;
  final String labelAr;
  final double priceEgp;
  final int stock;
  final int? grams;

  String label(bool isArabic) => isArabic ? labelAr : labelEn;
}

class Product {
  const Product({
    required this.id,
    required this.nameEn,
    required this.nameAr,
    required this.descriptionEn,
    required this.descriptionAr,
    required this.careTipsEn,
    required this.careTipsAr,
    required this.category,
    required this.variants,
    required this.gradientHexes,
    required this.iconKey,
    this.imageUrl,
    this.isBestSeller = false,
    this.isNewArrival = false,
    this.isLiveFish = false,
    this.waterType = 'fresh',
  });

  final String id;
  final String nameEn;
  final String nameAr;
  final String descriptionEn;
  final String descriptionAr;
  final String careTipsEn;
  final String careTipsAr;
  final ProductCategory category;
  final List<ProductVariant> variants;
  final List<int> gradientHexes;
  final String iconKey;
  final String? imageUrl;
  final bool isBestSeller;
  final bool isNewArrival;
  final bool isLiveFish;
  final String waterType;

  String name(bool isArabic) => isArabic ? nameAr : nameEn;
  String description(bool isArabic) => isArabic ? descriptionAr : descriptionEn;
  String careTips(bool isArabic) => isArabic ? careTipsAr : careTipsEn;

  double get startingPrice => variants.first.priceEgp;
  bool get hasStock => variants.any((v) => v.stock > 0);
}
