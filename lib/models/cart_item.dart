import 'product.dart';

class CartItem {
  final Product product;
  final String? selectedColor;
  final String? selectedSize;
  int quantity;

  CartItem({
    required this.product,
    this.selectedColor,
    this.selectedSize,
    this.quantity = 1,
  });

  double get totalPrice => product.price * quantity;

  String get itemKey => '${product.id}_${selectedColor ?? ""}_${selectedSize ?? ""}';
}
