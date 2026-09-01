import 'package:flutter/material.dart';

/// Enhanced search bar with filter icon.
class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({super.key, required this.onChanged});

  final ValueChanged<String> onChanged;

  static const _textLight = Color(0xFF9094A6);
  static const _primary = Color(0xFF4C53A5);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          // Search field
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.04), offset: const Offset(0, 4), blurRadius: 16),
                ],
              ),
              child: TextField(
                onChanged: onChanged,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF2D3142)),
                decoration: InputDecoration(
                  hintText: 'Cari produk...',
                  hintStyle: TextStyle(fontWeight: FontWeight.w400, color: _textLight.withValues(alpha: 0.6)),
                  prefixIcon: const Icon(Icons.search_rounded, color: _textLight, size: 22),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Filter button
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF6B73FF), Color(0xFF4C53A5)]),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(color: _primary.withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 4)),
              ],
            ),
            child: const Icon(Icons.tune_rounded, color: Colors.white, size: 22),
          ),
        ],
      ),
    );
  }
}
