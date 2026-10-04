class Product {
  final String id;
  final String title;
  final String brand;
  final String description;
  final double price;
  final double? originalPrice;
  final double rating;
  final int reviewCount;
  final List<String> images;
  final String category;
  final bool isExpress;
  final int? discountPercent;
  final List<String> colors;
  final List<String> sizes;
  final Map<String, String> specs;
  final String seller;
  final int deliveryDays;
  final bool isBestSeller;
  final bool isTrending;
  final int stock;

  Product({
    required this.id,
    required this.title,
    required this.brand,
    required this.description,
    required this.price,
    this.originalPrice,
    required this.rating,
    required this.reviewCount,
    required this.images,
    required this.category,
    this.isExpress = true,
    this.discountPercent,
    this.colors = const [],
    this.sizes = const [],
    required this.specs,
    this.seller = 'noon Express',
    this.deliveryDays = 1,
    this.isBestSeller = false,
    this.isTrending = false,
    this.stock = 50,
  });

  double get effectiveDiscount {
    if (discountPercent != null) return discountPercent!.toDouble();
    if (originalPrice != null && originalPrice! > price) {
      return (((originalPrice! - price) / originalPrice!) * 100).roundToDouble();
    }
    return 0;
  }
}
