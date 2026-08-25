import 'package:flutter/material.dart';

import '../data/dummy_data.dart';
import '../models/cart_item.dart';
import '../widgets/cart_app_bar.dart';
import '../widgets/cart_bottom_nav_bar.dart';
import '../widgets/cart_item_tile.dart';

/// Neo Brutalism styled cart page.
class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final List<CartItem> _items = dummyCartItems.map((item) => item.copyWith()).toList();
  bool _showCouponInput = false;
  final _couponController = TextEditingController();

  static const _borderColor = Color(0xFF1A1A2E);
  static const _bgColor = Color(0xFFFFF59D);
  static const _teal = Color(0xFF4ECDC4);
  static const _purple = Color(0xFFAB47BC);

  @override
  void initState() {
    super.initState();
    _couponController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  void _incrementQty(String id) {
    setState(() { _items.firstWhere((item) => item.id == id).quantity++; });
  }

  void _decrementQty(String id) {
    setState(() {
      final item = _items.firstWhere((item) => item.id == id);
      if (item.quantity > 1) item.quantity--;
    });
  }

  void _removeItem(String id) {
    setState(() { _items.removeWhere((item) => item.id == id); });
  }

  double get _totalPrice => _items.fold(0.0, (sum, item) => sum + item.price * item.quantity);

  void _checkout() {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text('Checkout belum tersedia')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: Column(
        children: [
          const CartAppBar(),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(top: 16),
              color: _bgColor,
              child: ListView.builder(
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  final item = _items[index];
                  return CartItemTile(
                    item: item,
                    onIncrement: () => _incrementQty(item.id),
                    onDecrement: () => _decrementQty(item.id),
                    onDelete: () => _removeItem(item.id),
                  );
                },
              ),
            ),
          ),
          // Coupon section
          GestureDetector(
            onTap: () => setState(() => _showCouponInput = !_showCouponInput),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _borderColor, width: 2.5),
                boxShadow: const [BoxShadow(color: _borderColor, offset: Offset(3, 3), blurRadius: 0)],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: _purple,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: _borderColor, width: 2),
                    ),
                    child: const Icon(Icons.add, color: Colors.white, size: 18),
                  ),
                  const SizedBox(width: 10),
                  const Text('Add Coupon Code 🎫', style: TextStyle(color: _borderColor, fontWeight: FontWeight.w800, fontSize: 15)),
                ],
              ),
            ),
          ),
          if (_showCouponInput)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [BoxShadow(color: _borderColor.withValues(alpha: 0.85), offset: const Offset(3, 3), blurRadius: 0)],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        controller: _couponController,
                        style: const TextStyle(fontWeight: FontWeight.w600, color: _borderColor),
                        decoration: InputDecoration(
                          hintText: 'Masukkan kode kupon',
                          hintStyle: TextStyle(fontWeight: FontWeight.w600, color: _borderColor.withValues(alpha: 0.4)),
                          filled: true, fillColor: _teal.withValues(alpha: 0.15),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: _borderColor, width: 3)),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: _borderColor, width: 3)),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: _teal, width: 3)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: _couponController.text.isEmpty ? null : () {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Kupon ${_couponController.text} diterapkan')));
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: _couponController.text.isEmpty ? Colors.grey : _purple,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: _borderColor, width: 3),
                        boxShadow: const [BoxShadow(color: _borderColor, offset: Offset(3, 3), blurRadius: 0)],
                      ),
                      child: const Text('Apply', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 8),
        ],
      ),
      bottomNavigationBar: CartBottomNavBar(totalPrice: _totalPrice, onCheckout: _checkout),
    );
  }
}
