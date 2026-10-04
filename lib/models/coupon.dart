class Coupon {
  final String code;
  final double discountPercentage;
  final double maxDiscount;
  final double minSpend;
  final String description;
  final String validUntil;

  Coupon({
    required this.code,
    required this.discountPercentage,
    required this.maxDiscount,
    required this.minSpend,
    required this.description,
    required this.validUntil,
  });

  double calculateDiscount(double subtotal) {
    if (subtotal < minSpend) return 0.0;
    double discount = subtotal * (discountPercentage / 100);
    return discount > maxDiscount ? maxDiscount : discount;
  }
}
