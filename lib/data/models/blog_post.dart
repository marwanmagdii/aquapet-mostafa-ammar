class BlogPost {
  const BlogPost({
    required this.id,
    required this.titleEn,
    required this.titleAr,
    required this.summaryEn,
    required this.summaryAr,
    required this.bodyEn,
    required this.bodyAr,
    required this.categoryEn,
    required this.categoryAr,
    required this.readMinutes,
    required this.publishedAt,
    required this.imageUrl,
    required this.authorName,
    this.relatedProductIds = const [],
  });

  final String id;
  final String titleEn;
  final String titleAr;
  final String summaryEn;
  final String summaryAr;
  final String bodyEn;
  final String bodyAr;
  final String categoryEn;
  final String categoryAr;
  final int readMinutes;
  final DateTime publishedAt;
  final String imageUrl;
  final String authorName;
  final List<String> relatedProductIds;

  String title(bool isArabic) => isArabic ? titleAr : titleEn;
  String summary(bool isArabic) => isArabic ? summaryAr : summaryEn;
  String body(bool isArabic) => isArabic ? bodyAr : bodyEn;
  String category(bool isArabic) => isArabic ? categoryAr : categoryEn;
}
