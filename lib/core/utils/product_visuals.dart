import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../data/models/product.dart';

abstract final class ProductVisuals {
  static IconData iconForCategory(ProductCategory category) {
    return switch (category) {
      ProductCategory.fish => PhosphorIcons.fishSimple(PhosphorIconsStyle.duotone),
      ProductCategory.food => PhosphorIcons.bowlFood(PhosphorIconsStyle.duotone),
      ProductCategory.tanks => PhosphorIcons.cubeTransparent(PhosphorIconsStyle.duotone),
      ProductCategory.filters => PhosphorIcons.funnel(PhosphorIconsStyle.duotone),
      ProductCategory.waterCare => PhosphorIcons.drop(PhosphorIconsStyle.duotone),
      ProductCategory.decor => PhosphorIcons.plant(PhosphorIconsStyle.duotone),
    };
  }

  static Color colorForCategory(ProductCategory category) {
    return switch (category) {
      ProductCategory.fish => const Color(0xFF0284C7), // Ocean blue
      ProductCategory.food => const Color(0xFFEA580C), // Warm amber
      ProductCategory.tanks => const Color(0xFF0D9488), // Deep teal
      ProductCategory.filters => const Color(0xFF4F46E5), // Indigo
      ProductCategory.waterCare => const Color(0xFF0891B2), // Cyan
      ProductCategory.decor => const Color(0xFF059669), // Emerald
    };
  }

  static String imageAssetForProduct(Product product) =>
      'assets/images/products/${product.id}.svg';

  static String imageAssetForCategory(ProductCategory category) {
    return switch (category) {
      ProductCategory.fish => 'assets/images/products/cat_fish.jpg',
      ProductCategory.food => 'assets/images/products/cat_food.svg',
      ProductCategory.tanks => 'assets/images/products/cat_tanks.svg',
      ProductCategory.filters => 'assets/images/products/cat_filters.svg',
      ProductCategory.waterCare => 'assets/images/products/cat_watercare.svg',
      ProductCategory.decor => 'assets/images/products/cat_decor.svg',
    };
  }

  static String categoryName(ProductCategory category, bool isArabic) {
    return switch (category) {
      ProductCategory.fish => isArabic ? 'أسماك' : 'Fish',
      ProductCategory.food => isArabic ? 'طعام الأسماك' : 'Fish Food',
      ProductCategory.tanks => isArabic ? 'أحواض' : 'Tanks',
      ProductCategory.filters => isArabic ? 'فلاتر ومضخات' : 'Filters & Pumps',
      ProductCategory.waterCare => isArabic ? 'عناية المياه' : 'Water Care',
      ProductCategory.decor => isArabic ? 'ديكور ونباتات' : 'Decor & Plants',
    };
  }

  static List<Color> colorsForProduct(Product product) =>
      product.gradientHexes.map((hex) => Color(hex)).toList();

  static String formatEgp(double amount, bool isArabic) {
    final rounded = amount == amount.roundToDouble()
        ? amount.toInt().toString()
        : amount.toStringAsFixed(2);
    return isArabic ? '$rounded ج.م' : '$rounded EGP';
  }
}
