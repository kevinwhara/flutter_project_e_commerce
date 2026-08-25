import 'package:flutter/material.dart';

/// Professional Mobile UI styled search bar.
class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({super.key, required this.onChanged});

  final ValueChanged<String> onChanged;

  static const _primary = Color(0xFF4C53A5);
  static const _textDark = Color(0xFF2D3142);
  static const _textLight = Color(0xFF9094A6);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            offset: const Offset(0, 4),
            blurRadius: 16,
          ),
        ],
      ),
      child: Row(
        children: [
          // ── Search icon ────────────────────────────
          Container(
            margin: const EdgeInsets.only(left: 12),
            padding: const EdgeInsets.all(8),
            child: const Icon(Icons.search_rounded, size: 22, color: _textLight),
          ),
          const SizedBox(width: 4),

          // ── Text field ────────────────────────────────────────────
          Expanded(
            child: TextFormField(
              onChanged: onChanged,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: _textDark,
                fontSize: 15,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Cari produk...',
                hintStyle: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: _textLight,
                  fontSize: 15,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),

          // ── Camera icon ───────────────────────────
          Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F3F5),
              borderRadius: BorderRadius.circular(10),
            ),
            child:
                const Icon(Icons.camera_alt_rounded, size: 20, color: _textDark),
          ),
        ],
      ),
    );
  }
}
