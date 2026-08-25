import 'package:flutter/material.dart';

import '../models/cart_item.dart';

/// Professional Mobile UI styled cart item tile.
class CartItemTile extends StatelessWidget {
  const CartItemTile({super.key, required this.item, required this.onIncrement, required this.onDecrement, required this.onDelete});

  final CartItem item;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onDelete;

  static const _textDark = Color(0xFF2D3142);
  static const _textLight = Color(0xFF9094A6);
  static const _primary = Color(0xFF4C53A5);
  static const _accentPink = Color(0xFFFF6B6B);
  static const _bgLight = Color(0xFFF8F9FA);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), offset: const Offset(0, 4), blurRadius: 12)],
      ),
      child: Row(
        children: [
          // Product image
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: _bgLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Image.asset(
              item.imageUrl, width: 60, height: 60, fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 60, height: 60,
                color: _bgLight,
                child: const Icon(Icons.image_not_supported_outlined, color: _textLight),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Name + price
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: _textDark)),
                const SizedBox(height: 8),
                Text('\$${item.price.toStringAsFixed(2)}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: _primary)),
              ],
            ),
          ),
          // Controls column
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Delete button
              GestureDetector(
                onTap: onDelete,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: _accentPink.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.delete_outline_rounded, color: _accentPink, size: 20),
                ),
              ),
              const SizedBox(height: 12),
              // Quantity controls
              Row(
                children: [
                  _qtyButton(Icons.remove, onDecrement),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text('${item.quantity}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: _textDark)),
                  ),
                  _qtyButton(Icons.add, onIncrement),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _qtyButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: _bgLight,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 16, color: _textDark),
      ),
    );
  }
}
