import 'package:flutter/material.dart';

import '../data/dummy_data.dart';
import '../models/cart_item.dart';
import '../widgets/cart_app_bar.dart';
import '../widgets/cart_bottom_nav_bar.dart';
import '../widgets/cart_item_tile.dart';

/// Professional Mobile UI styled cart page.
class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final List<CartItem> _items = dummyCartItems.map((item) => item.copyWith()).toList();
  bool _showCouponInput = false;
  final _couponController = TextEditingController();

  static const _textDark = Color(0xFF2D3142);
  static const _textLight = Color(0xFF9094A6);
  static const _bgLight = Color(0xFFF8F9FA);
  static const _primary = Color(0xFF4C53A5);

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
      backgroundColor: _bgLight,
      body: Column(
        children: [
          const CartAppBar(),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(top: 8),
              color: _bgLight,
              child: _items.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.shopping_cart_outlined, size: 64, color: _textLight),
                          const SizedBox(height: 16),
                          const Text('Keranjangmu Kosong!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: _textDark)),
                          const SizedBox(height: 8),
                          const Text('Yuk mulai belanja sekarang', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: _textLight)),
                        ],
                      ),
                    )
                  : ListView.builder(
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), offset: const Offset(0, 4), blurRadius: 10)],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: _primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.add, color: _primary, size: 18),
                  ),
                  const SizedBox(width: 12),
                  const Text('Add Coupon Code', style: TextStyle(color: _textDark, fontWeight: FontWeight.w600, fontSize: 15)),
                  const Spacer(),
                  const Icon(Icons.local_activity_outlined, color: _primary, size: 20),
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
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), offset: const Offset(0, 4), blurRadius: 10)],
                      ),
                      child: TextField(
                        controller: _couponController,
                        style: const TextStyle(fontWeight: FontWeight.w500, color: _textDark),
                        decoration: InputDecoration(
                          hintText: 'Masukkan kode kupon',
                          hintStyle: const TextStyle(fontWeight: FontWeight.w400, color: _textLight),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: _couponController.text.isEmpty ? null : () {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Kupon ${_couponController.text} diterapkan')));
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      decoration: BoxDecoration(
                        color: _couponController.text.isEmpty ? _textLight : _primary,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          if (_couponController.text.isNotEmpty)
                            BoxShadow(color: _primary.withOpacity(0.3), offset: const Offset(0, 4), blurRadius: 10)
                        ],
                      ),
                      child: const Text('Apply', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 16),
        ],
      ),
      bottomNavigationBar: CartBottomNavBar(totalPrice: _totalPrice, onCheckout: _checkout),
    );
  }
}
