import 'package:flutter/material.dart';
import '../widgets/cart_app_bar.dart';
import '../widgets/cart_bottom_nav_bar.dart';
import '../widgets/cart_item_tile.dart';

import '../providers/cart_provider.dart';

/// Professional Mobile UI styled cart page.
class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
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

  void _checkout() {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text('Checkout belum tersedia')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgLight,
      body: ListenableBuilder(
        listenable: cartProvider,
        builder: (context, _) {
          final items = cartProvider.items;
          return Column(
            children: [
              const CartAppBar(),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(top: 8),
                  color: _bgLight,
                  child: items.isEmpty
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
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            final item = items[index];
                            return CartItemTile(
                              item: item,
                              onIncrement: () => cartProvider.incrementQty(item.id),
                              onDecrement: () => cartProvider.decrementQty(item.id),
                              onDelete: () => cartProvider.removeItem(item.id),
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
                            decoration: const InputDecoration(
                              hintText: 'Masukkan kode kupon',
                              hintStyle: TextStyle(fontWeight: FontWeight.w400, color: _textLight),
                              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      if (_couponController.text.isNotEmpty) ...[
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: () {
                            // Dummy apply coupon action
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(const SnackBar(content: Text('Kupon diterapkan!')));
                            FocusScope.of(context).unfocus();
                          },
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: _primary,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [BoxShadow(color: _primary.withOpacity(0.3), offset: const Offset(0, 4), blurRadius: 10)],
                            ),
                            child: const Icon(Icons.check, color: Colors.white, size: 20),
                          ),
                        ),
                      ]
                    ],
                  ),
                ),
              const SizedBox(height: 10),
              CartBottomNavBar(
                totalPrice: cartProvider.totalPrice,
                onCheckout: _checkout,
              ),
            ],
          );
        },
      ),
    );
  }
}
