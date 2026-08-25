import 'package:flutter/material.dart';

/// Neo Brutalism styled category chips with colorful fills and emojis.
class CategoriesWidget extends StatefulWidget {
  const CategoriesWidget({super.key});

  @override
  State<CategoriesWidget> createState() => _CategoriesWidgetState();
}

class _CategoriesWidgetState extends State<CategoriesWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _staggerController;

  static const _borderColor = Color(0xFF1A1A2E);

  // Each category gets its own color + emoji
  static const List<_CategoryData> _categories = [
    _CategoryData('Outfit', '👗', Color(0xFFFF6B6B), Color(0xFFFFCDD2)),
    _CategoryData('Makanan', '🍜', Color(0xFF4ECDC4), Color(0xFFB2DFDB)),
    _CategoryData('Skincare', '✨', Color(0xFFAB47BC), Color(0xFFD1C4E9)),
    _CategoryData('Elektronic', '⚡', Color(0xFFFFB74D), Color(0xFFFFE0B2)),
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
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        decoration: BoxDecoration(
          color: data.fillColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _borderColor, width: 2.5),
          boxShadow: const [
            BoxShadow(
              color: _borderColor,
              offset: Offset(3, 3),
              blurRadius: 0,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Emoji in a small bordered circle
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: data.accentColor.withValues(alpha: 0.3),
                shape: BoxShape.circle,
                border: Border.all(color: _borderColor, width: 2),
              ),
              child: Center(
                child: Text(data.emoji, style: const TextStyle(fontSize: 18)),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              data.label,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 15,
                color: _borderColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryData {
  const _CategoryData(this.label, this.emoji, this.accentColor, this.fillColor);
  final String label;
  final String emoji;
  final Color accentColor;
  final Color fillColor;
}
