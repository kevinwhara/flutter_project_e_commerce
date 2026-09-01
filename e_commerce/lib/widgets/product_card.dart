import 'package:flutter/material.dart';

import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../providers/favorite_provider.dart';
import '../providers/review_provider.dart';

/// Stunning product card with full-bleed image, rating, and mini add-to-cart.
class ProductCard extends StatefulWidget {
  const ProductCard({super.key, required this.product});

  final Product product;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool _isPressed = false;

  static const _textDark = Color(0xFF2D3142);
  static const _textLight = Color(0xFF9094A6);
  static const _primary = Color(0xFF4C53A5);
  static const _accentPink = Color(0xFFFF6B6B);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        Navigator.pushNamed(context, '/product-detail', arguments: widget.product);
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOutCubic,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: _primary.withValues(alpha: 0.06),
                offset: const Offset(0, 8),
                blurRadius: 24,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Image area with overlays ─────────────────────────
              Expanded(
                flex: 3,
                child: Stack(
                  children: [
                    // Full bleed image
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                      child: SizedBox(
                        width: double.infinity,
                        child: Image.asset(
                          widget.product.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (c, e, s) => Container(
                            color: const Color(0xFFF1F3F5),
                            child: const Center(
                              child: Icon(Icons.image_not_supported_outlined, color: _textLight, size: 32),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Gradient overlay at bottom of image
                    Positioned(
                      bottom: 0, left: 0, right: 0,
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Colors.black.withValues(alpha: 0.15)],
                          ),
                        ),
                      ),
                    ),

                    // Discount badge
                    if (widget.product.discountPercent > 0)
                      Positioned(
                        top: 8, left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)]),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '-${widget.product.discountPercent}%',
                            style: const TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w800),
                          ),
                        ),
                      ),

                    // Favorite icon
                    Positioned(
                      top: 8, right: 8,
                      child: ListenableBuilder(
                        listenable: favoriteProvider,
                        builder: (context, _) {
                          final isFav = favoriteProvider.isFavorite(widget.product.id);
                          return GestureDetector(
                            onTap: () {
                              favoriteProvider.toggleFavorite(widget.product);
                              ScaffoldMessenger.of(context)
                                ..hideCurrentSnackBar()
                                ..showSnackBar(SnackBar(
                                  content: Text(isFav
                                    ? '${widget.product.name} dihapus dari Favorit'
                                    : '${widget.product.name} ditambahkan ke Favorit! ❤️'),
                                ));
                            },
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.9),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 8, offset: const Offset(0, 2)),
                                ],
                              ),
                              child: Icon(
                                isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                                color: isFav ? _accentPink : _textLight,
                                size: 16,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // ── Info area ──────────────────────────────────────────
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name
                      Text(
                        widget.product.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 13, color: _textDark, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 4),

                      // Rating stars
                      ListenableBuilder(
                        listenable: reviewProvider,
                        builder: (context, _) {
                          final avg = reviewProvider.getAverageRating(widget.product.id);
                          final count = reviewProvider.getReviewsForProduct(widget.product.id).length;
                          return Row(
                            children: [
                              ...List.generate(5, (i) => Icon(
                                i < avg.round() ? Icons.star_rounded : Icons.star_border_rounded,
                                color: const Color(0xFFFFB74D),
                                size: 12,
                              )),
                              const SizedBox(width: 4),
                              Text(
                                '($count)',
                                style: TextStyle(fontSize: 10, color: _textLight.withValues(alpha: 0.8), fontWeight: FontWeight.w500),
                              ),
                            ],
                          );
                        },
                      ),
                      const Spacer(),

                      // Price + Add to cart button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '\$${widget.product.price.toStringAsFixed(0)}',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: _primary),
                          ),
                          GestureDetector(
                            onTap: () {
                              cartProvider.addToCart(widget.product);
                              ScaffoldMessenger.of(context)
                                ..hideCurrentSnackBar()
                                ..showSnackBar(SnackBar(content: Text('${widget.product.name} ditambahkan ke keranjang')));
                            },
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(colors: [Color(0xFF6B73FF), Color(0xFF4C53A5)]),
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(color: _primary.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 2)),
                                ],
                              ),
                              child: const Icon(Icons.add_rounded, color: Colors.white, size: 18),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
