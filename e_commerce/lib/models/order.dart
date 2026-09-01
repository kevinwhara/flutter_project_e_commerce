import 'cart_item.dart';

enum OrderStatus { diproses, dikirim, selesai }

class Order {
  Order({
    required this.id,
    required this.items,
    required this.totalPrice,
    required this.deliveryFee,
    required this.paymentMethod,
    required this.address,
    required this.status,
    required this.orderDate,
  });

  final String id;
  final List<CartItem> items;
  final double totalPrice;
  final double deliveryFee;
  final String paymentMethod;
  final String address;
  OrderStatus status;
  final DateTime orderDate;

  double get grandTotal => totalPrice + deliveryFee;

  String get statusLabel {
    switch (status) {
      case OrderStatus.diproses:
        return 'Diproses';
      case OrderStatus.dikirim:
        return 'Dikirim';
      case OrderStatus.selesai:
        return 'Selesai';
    }
  }
}
