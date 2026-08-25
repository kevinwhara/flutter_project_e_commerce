import 'package:flutter/material.dart';

/// Neo Brutalism styled search bar.
class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({super.key, required this.onChanged});

  final ValueChanged<String> onChanged;

  static const _borderColor = Color(0xFF1A1A2E);
  static const _mintFill = Color(0xFFB2DFDB);
  static const _teal = Color(0xFF4ECDC4);
  static const _orange = Color(0xFFFFB74D);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: _mintFill,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _borderColor, width: 3),
        boxShadow: const [
          BoxShadow(
            color: _borderColor,
            offset: Offset(4, 4),
            blurRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          // ── Search icon in bordered box ────────────────────────────
          Container(
            margin: const EdgeInsets.only(left: 10),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _teal.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: _borderColor, width: 2),
            ),
            child: const Icon(Icons.search_rounded, size: 20, color: _borderColor),
          ),
          const SizedBox(width: 10),

          // ── Text field ────────────────────────────────────────────
          Expanded(
            child: TextFormField(
              onChanged: onChanged,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: _borderColor,
                fontSize: 15,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Cari produk... 🔍',
                hintStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF6B7280),
                  fontSize: 15,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),

          // ── Camera icon in bordered box ───────────────────────────
          Container(
            margin: const EdgeInsets.only(right: 10),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _orange.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: _borderColor, width: 2),
            ),
            child:
                const Icon(Icons.camera_alt_rounded, size: 20, color: _borderColor),
          ),
        ],
      ),
    );
  }
}
