import 'package:flutter/material.dart';

/// Professional Mobile UI styled cart bottom bar with total + checkout button.
class CartBottomNavBar extends StatelessWidget {
  const CartBottomNavBar({super.key, required this.totalPrice, required this.onCheckout});

  final double totalPrice;
  final VoidCallback onCheckout;

  static const _textDark = Color(0xFF2D3142);
  static const _primary = Color(0xFF4C53A5);
  static const _bgLight = Color(0xFFF8F9FA);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            offset: const Offset(0, -4),
            blurRadius: 16,
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Total row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: _textDark)),
              Text(
                '\$${totalPrice.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: _primary),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Checkout button
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (ctx) => Dialog(
                  backgroundColor: Colors.transparent,
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.check_circle_rounded, size: 64, color: _primary),
                        const SizedBox(height: 16),
                        const Text(
                          'Pesanan Berhasil!',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: _textDark),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Barangmu sedang diproses dan akan segera dikirim.',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: _textDark.withOpacity(0.7)),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(ctx); // Close dialog
                            Navigator.pushReplacementNamed(context, '/home'); // Go to home
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              color: _primary,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: Text('Kembali Belanja', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16)),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
            child: Container(
              height: 54,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: _primary,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: _primary.withOpacity(0.3),
                    offset: const Offset(0, 4),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Check Out',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.payment_rounded, color: Colors.white, size: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
