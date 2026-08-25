import 'package:flutter/material.dart';

/// Professional Mobile UI styled category chips.
class CategoriesWidget extends StatefulWidget {
  const CategoriesWidget({super.key});

  @override
  State<CategoriesWidget> createState() => _CategoriesWidgetState();
}

class _CategoriesWidgetState extends State<CategoriesWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _staggerController;

  // Each category gets its own color + icon
  static const List<_CategoryData> _categories = [
    _CategoryData('Outfit', Icons.checkroom_rounded, Color(0xFFFF6B6B), Color(0xFFFFCDD2)),
    _CategoryData('Makanan', Icons.restaurant_rounded, Color(0xFF4ECDC4), Color(0xFFB2DFDB)),
    _CategoryData('Skincare', Icons.face_retouching_natural_rounded, Color(0xFFAB47BC), Color(0xFFD1C4E9)),
    _CategoryData('Elektronic', Icons.bolt_rounded, Color(0xFFFFB74D), Color(0xFFFFE0B2)),
  ];

  @override
  void initState() {
    super.initState();
    _staggerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();
  }

  @override
  void dispose() {
    _staggerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          for (var i = 0; i < _categories.length; i++)
            _buildCategoryChip(i, _categories[i]),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(int index, _CategoryData data) {
    final interval = Interval(
      index * 0.2,
      0.5 + index * 0.15,
      curve: Curves.elasticOut,
    );
    final anim = CurvedAnimation(parent: _staggerController, curve: interval);

    return AnimatedBuilder(
      animation: anim,
      builder: (_, child) {
        return Transform.scale(
          scale: anim.value.clamp(0.0, 1.0),
          child: Opacity(
            opacity: anim.value.clamp(0.0, 1.0),
            child: child,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              offset: const Offset(0, 4),
              blurRadius: 10,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon in a small circle
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: data.fillColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(data.icon, size: 20, color: data.accentColor),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              data.label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Color(0xFF2D3142),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryData {
  const _CategoryData(this.label, this.icon, this.accentColor, this.fillColor);
  final String label;
  final IconData icon;
  final Color accentColor;
  final Color fillColor;
}
