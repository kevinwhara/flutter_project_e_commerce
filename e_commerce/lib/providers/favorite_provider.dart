import 'package:flutter/foundation.dart';
import '../models/product.dart';

/// Global instance for favorite state management
final FavoriteProvider favoriteProvider = FavoriteProvider();

class FavoriteProvider extends ChangeNotifier {
  final List<Product> _items = [];

  List<Product> get items => List.unmodifiable(_items);

  bool isFavorite(String productId) {
    return _items.any((item) => item.id == productId);
  }

  void toggleFavorite(Product product) {
    if (isFavorite(product.id)) {
      _items.removeWhere((item) => item.id == product.id);
    } else {
      _items.add(product);
    }
    notifyListeners();
  }
}
