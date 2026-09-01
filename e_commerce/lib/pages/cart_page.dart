import 'package:flutter/material.dart';
import '../widgets/cart_app_bar.dart';
import '../widgets/cart_bottom_nav_bar.dart';
import '../widgets/cart_item_tile.dart';

import '../providers/cart_provider.dart';

/// Professional Mobile UI styled cart page with better empty state.
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
    if (cartProvider.items.isNotEmpty) {
      // Logic handled in bottom nav bar
    }
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
                              Container(
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: _primary.withValues(alpha: 0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.shopping_bag_outlined, size: 80, color: _primary),
                              ),
                              const SizedBox(height: 24),
                              const Text('Keranjang Belanjamu Kosong', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: _textDark)),
                              const SizedBox(height: 8),
                              const Text('Yuk, temukan barang-barang menarik\ndan tambahkan ke keranjang!', textAlign: TextAlign.center, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: _textLight, height: 1.5)),
                              const SizedBox(height: 32),
                              ElevatedButton(
                                onPressed: () {
                                  // Find the bottom nav in Homepage and jump to page 0
                                  // For now, this requires state lift, so just a dummy action:
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Silakan pilih menu Home di bawah')));
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _primary,
                                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                  elevation: 8,
                                  shadowColor: _primary.withValues(alpha: 0.5),
                                ),
                                child: const Text('Mulai Belanja', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)),
                              )
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
              if (items.isNotEmpty)
                GestureDetector(
                  onTap: () => setState(() => _showCouponInput = !_showCouponInput),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), offset: const Offset(0, 4), blurRadius: 10)],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(color: _primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                          child: Icon(_showCouponInput ? Icons.remove : Icons.add, color: _primary, size: 18),
                        ),
                        const SizedBox(width: 12),
                        const Text('Add Coupon Code', style: TextStyle(color: _textDark, fontWeight: FontWeight.w600, fontSize: 15)),
                        const Spacer(),
                        const Icon(Icons.local_activity_outlined, color: _primary, size: 20),
                      ],
                    ),
                  ),
                ),
              if (_showCouponInput && items.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), offset: const Offset(0, 4), blurRadius: 10)],
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
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(const SnackBar(content: Text('Kupon diterapkan!')));
                            FocusScope.of(context).unfocus();
                          },
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(colors: [Color(0xFF6B73FF), Color(0xFF4C53A5)]),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [BoxShadow(color: _primary.withValues(alpha: 0.3), offset: const Offset(0, 4), blurRadius: 10)],
                            ),
                            child: const Icon(Icons.check, color: Colors.white, size: 20),
                          ),
                        ),
                      ]
                    ],
                  ),
                ),
              const SizedBox(height: 10),
              
              // Only show checkout bar if items exist
              if (items.isNotEmpty)
                CartBottomNavBar(
                  totalPrice: cartProvider.totalPrice,
                  onCheckout: _checkout,
                )
              else
                // Pad bottom for floating nav
                const SizedBox(height: 100),
            ],
          );
        },
      ),
    );
  }
}
