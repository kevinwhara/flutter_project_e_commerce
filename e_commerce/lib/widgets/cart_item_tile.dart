import 'package:flutter/material.dart';

import '../models/cart_item.dart';

/// Neo Brutalism styled cart item tile.
class CartItemTile extends StatelessWidget {
  const CartItemTile({super.key, required this.item, required this.onIncrement, required this.onDecrement, required this.onDelete});

  final CartItem item;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onDelete;

  static const _borderColor = Color(0xFF1A1A2E);
  static const _pink = Color(0xFFFF6B6B);
  static const _teal = Color(0xFF4ECDC4);
  static const _orange = Color(0xFFFFB74D);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _borderColor, width: 3),
        boxShadow: [BoxShadow(color: _borderColor.withValues(alpha: 0.9), offset: const Offset(4, 4), blurRadius: 0)],
      ),
      child: Row(
        children: [
          // Product image in bordered frame
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: _orange.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: _borderColor, width: 2),
            ),
            child: Image.asset(
              item.imageUrl, width: 60, height: 60, fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 60, height: 60,
                color: _orange.withValues(alpha: 0.1),
                child: const Icon(Icons.image_not_supported_outlined, color: _borderColor),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Name + price
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: _borderColor)),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: _teal.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: _borderColor, width: 1.5),
                  ),
                  child: Text('\$${item.price}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: _borderColor)),
                ),
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
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: _pink.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: _borderColor, width: 1.5),
                  ),
                  child: const Icon(Icons.delete_rounded, color: _pink, size: 20),
                ),
              ),
              const SizedBox(height: 10),
              // Quantity controls
              Row(
                children: [
                  _qtyButton(Icons.remove, onDecrement),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _orange.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: _borderColor, width: 1.5),
                    ),
                    child: Text('${item.quantity}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: _borderColor)),
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
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: _borderColor, width: 2),
          boxShadow: const [BoxShadow(color: _borderColor, offset: Offset(2, 2), blurRadius: 0)],
        ),
        child: Icon(icon, size: 16, color: _borderColor),
      ),
    );
  }
}
