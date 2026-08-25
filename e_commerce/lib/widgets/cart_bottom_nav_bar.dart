import 'package:flutter/material.dart';

/// Neo Brutalism styled cart bottom bar with total + checkout button.
class CartBottomNavBar extends StatelessWidget {
  const CartBottomNavBar({super.key, required this.totalPrice, required this.onCheckout});

  final double totalPrice;
  final VoidCallback onCheckout;

  static const _borderColor = Color(0xFF1A1A2E);
  static const _green = Color(0xFF4CAF50);
  static const _teal = Color(0xFF4ECDC4);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: _borderColor, width: 3.5)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Total row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: _borderColor)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: _teal.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: _borderColor, width: 2.5),
                ),
                child: Text(
                  '\$${totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: _borderColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Checkout button
          GestureDetector(
            onTap: onCheckout,
            child: Container(
              alignment: Alignment.center,
              height: 52, width: double.infinity,
              decoration: BoxDecoration(
                color: _green,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _borderColor, width: 3.5),
                boxShadow: const [BoxShadow(color: _borderColor, offset: Offset(4, 4), blurRadius: 0)],
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Check Out', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: Colors.white)),
                  SizedBox(width: 8),
                  Text('💳', style: TextStyle(fontSize: 18)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
