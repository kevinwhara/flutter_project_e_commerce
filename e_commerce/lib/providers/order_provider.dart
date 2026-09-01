import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';
import '../models/order.dart';

/// Global instance for order state management.
final OrderProvider orderProvider = OrderProvider();

class OrderProvider extends ChangeNotifier {
  final List<Order> _orders = [];
  int _nextId = 1;

  List<Order> get orders => List.unmodifiable(_orders);

  Order? getOrderById(String id) {
    try {
      return _orders.firstWhere((o) => o.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Creates a new order from the current cart items.
  Order addOrder({
    required List<CartItem> items,
    required double totalPrice,
    required double deliveryFee,
    required String paymentMethod,
    required String address,
  }) {
    final order = Order(
      id: 'ORD-${_nextId.toString().padLeft(4, '0')}',
      items: items.map((e) => CartItem(
        id: e.id,
        name: e.name,
        price: e.price,
        imageUrl: e.imageUrl,
        quantity: e.quantity,
      )).toList(),
      totalPrice: totalPrice,
      deliveryFee: deliveryFee,
      paymentMethod: paymentMethod,
      address: address,
      status: OrderStatus.diproses,
      orderDate: DateTime.now(),
    );
    _nextId++;
    _orders.insert(0, order); // newest first
    notifyListeners();
    return order;
  }

  void updateStatus(String orderId, OrderStatus newStatus) {
    final order = getOrderById(orderId);
    if (order != null) {
      order.status = newStatus;
      notifyListeners();
    }
  }
}
