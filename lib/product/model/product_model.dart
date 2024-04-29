

class ProductContent {
  final String id;
  final String thumbnail;
  final Map<String, String> colors;
  final String briefIntroduction;
  final double originalPrice;
  final double discountPrice;

  ProductContent({
    required this.id,
    required this.thumbnail,
    required this.colors,
    required this.briefIntroduction,
    required this.originalPrice,
    required this.discountPrice,
  });

  factory ProductContent.fromMap(Map<String, dynamic> map, String id) {
    return ProductContent(
      id: id,
      thumbnail: map['thumbnail'],
      colors: map['colors'],
      briefIntroduction: map['brief_introduction'],
      originalPrice: double.parse(map['original_price'].toString()),
      discountPrice: double.parse(map['discount_price'].toString()),
    );
  }
}
