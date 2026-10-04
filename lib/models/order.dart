import 'cart_item.dart';
import 'user_address.dart';

enum OrderStatus { placed, packed, shipped, outForDelivery, delivered }

class OrderModel {
  final String orderId;
  final DateTime orderDate;
  final List<CartItem> items;
  final double subtotal;
  final double discount;
  final double shippingFee;
  final double totalAmount;
  final OrderStatus status;
  final UserAddress deliveryAddress;
  final String paymentMethod;
  final String estimatedDelivery;

  OrderModel({
    required this.orderId,
    required this.orderDate,
    required this.items,
    required this.subtotal,
    required this.discount,
    required this.shippingFee,
    required this.totalAmount,
    required this.status,
    required this.deliveryAddress,
    required this.paymentMethod,
    required this.estimatedDelivery,
  });

  String get statusText {
    switch (status) {
      case OrderStatus.placed:
        return 'Order Placed';
      case OrderStatus.packed:
        return 'Packed & Ready';
      case OrderStatus.shipped:
        return 'In Transit';
      case OrderStatus.outForDelivery:
        return 'Out for Delivery';
      case OrderStatus.delivered:
        return 'Delivered';
    }
  }

  int get currentStep {
    switch (status) {
      case OrderStatus.placed:
        return 0;
      case OrderStatus.packed:
        return 1;
      case OrderStatus.shipped:
        return 2;
      case OrderStatus.outForDelivery:
        return 3;
      case OrderStatus.delivered:
        return 4;
    }
  }
}
