import 'package:flutter/material.dart';

/// Colorful horizontal-scroll category chips with gradient backgrounds.
class CategoriesWidget extends StatefulWidget {
  const CategoriesWidget({super.key});

  @override
  State<CategoriesWidget> createState() => _CategoriesWidgetState();
}

class _CategoriesWidgetState extends State<CategoriesWidget> {
  int _selectedIndex = 0;

  static const _textDark = Color(0xFF2D3142);

  static const List<_CategoryItem> _categories = [
    _CategoryItem('Semua', Icons.grid_view_rounded, [Color(0xFF6B73FF), Color(0xFF4C53A5)]),
    _CategoryItem('Makanan', Icons.fastfood_rounded, [Color(0xFFFF6B6B), Color(0xFFFF8E53)]),
    _CategoryItem('Minuman', Icons.local_cafe_rounded, [Color(0xFF4ECDC4), Color(0xFF20B2AA)]),
    _CategoryItem('Fashion', Icons.checkroom_rounded, [Color(0xFFC46FE0), Color(0xFF8E24AA)]),
    _CategoryItem('Elektronik', Icons.devices_rounded, [Color(0xFFFFC770), Color(0xFFFF9800)]),
    _CategoryItem('Otomotif', Icons.directions_car_rounded, [Color(0xFF5C6BC0), Color(0xFF3949AB)]),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final cat = _categories[index];
          final isActive = _selectedIndex == index;

          return GestureDetector(
            onTap: () => setState(() => _selectedIndex = index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              width: 80,
              margin: const EdgeInsets.only(right: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon circle
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOutCubic,
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: isActive
                          ? LinearGradient(colors: cat.colors, begin: Alignment.topLeft, end: Alignment.bottomRight)
                          : null,
                      color: isActive ? null : const Color(0xFFF1F3F5),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: isActive
                          ? [BoxShadow(color: cat.colors.first.withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 4))]
                          : [],
                    ),
                    child: Icon(
                      cat.icon,
                      size: 24,
                      color: isActive ? Colors.white : const Color(0xFF9094A6),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Label
                  Text(
                    cat.label,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                      color: isActive ? _textDark : const Color(0xFF9094A6),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _CategoryItem {
  const _CategoryItem(this.label, this.icon, this.colors);
  final String label;
  final IconData icon;
  final List<Color> colors;
}
