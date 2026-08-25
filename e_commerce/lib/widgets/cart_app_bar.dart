import 'package:flutter/material.dart';

/// Professional Mobile UI styled cart app bar.
class CartAppBar extends StatelessWidget {
  const CartAppBar({super.key});

  static const _textDark = Color(0xFF2D3142);
  static const _primary = Color(0xFF4C53A5);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            offset: const Offset(0, 4),
            blurRadius: 12,
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(20, 50, 20, 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F3F5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.arrow_back_rounded, size: 22, color: _textDark),
            ),
          ),
          const SizedBox(width: 16),
          const Text('Cart', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: _textDark)),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.more_vert_rounded, size: 22, color: _textDark),
          ),
        ],
      ),
    );
  }
}
