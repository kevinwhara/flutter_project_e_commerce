import 'package:flutter/material.dart';

/// Neo Brutalism styled cart app bar.
class CartAppBar extends StatelessWidget {
  const CartAppBar({super.key});

  static const _borderColor = Color(0xFF1A1A2E);
  static const _teal = Color(0xFF4ECDC4);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: _borderColor, width: 3.5)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 50, 20, 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _teal.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: _borderColor, width: 2.5),
                boxShadow: const [BoxShadow(color: _borderColor, offset: Offset(3, 3), blurRadius: 0)],
              ),
              child: const Icon(Icons.arrow_back_rounded, size: 22, color: _borderColor),
            ),
          ),
          const SizedBox(width: 14),
          const Text('Cart 🛒', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: _borderColor)),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: _borderColor, width: 2.5),
            ),
            child: const Icon(Icons.more_vert_rounded, size: 22, color: _borderColor),
          ),
        ],
      ),
    );
  }
}
