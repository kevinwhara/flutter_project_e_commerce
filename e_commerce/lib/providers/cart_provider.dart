import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

/// A global instance of CartProvider for simple state management without the `provider` package.
final CartProvider cartProvider = CartProvider();

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  double get totalPrice {
    return _items.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
  }

  int get totalItems {
    return _items.fold(0, (sum, item) => sum + item.quantity);
  }

  void addToCart(Product product) {
    // Check if item already in cart
    final index = _items.indexWhere((item) => item.id == product.id);
    
    if (index >= 0) {
      _items[index].quantity += 1;
    } else {
      _items.add(
        CartItem(
          id: product.id,
          name: product.name,
          price: product.price,
          imageUrl: product.imageUrl,
          quantity: 1,
        ),
      );
    }
    notifyListeners();
  }

  void incrementQty(String id) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index >= 0) {
      _items[index].quantity += 1;
      notifyListeners();
    }
  }

  void decrementQty(String id) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index >= 0) {
      if (_items[index].quantity > 1) {
        _items[index].quantity -= 1;
      } else {
        // Remove item if quantity becomes 0
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  void removeItem(String id) {
    _items.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
