import 'package:flutter/material.dart';

import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../providers/favorite_provider.dart';
import '../providers/review_provider.dart';

/// Professional Mobile UI styled product detail page.
class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({super.key});

  static const _textDark = Color(0xFF2D3142);
  static const _textLight = Color(0xFF9094A6);
  static const _bgLight = Color(0xFFF8F9FA);
  static const _primary = Color(0xFF4C53A5);
  static const _accentPink = Color(0xFFFF6B6B);
  static const _surface = Colors.white;

  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context)!.settings.arguments as Product;

    return Scaffold(
      backgroundColor: _bgLight,
      appBar: AppBar(
        backgroundColor: _surface,
        foregroundColor: _textDark,
        elevation: 0,
        title: Text(
          product.name,
          style: const TextStyle(fontWeight: FontWeight.w700, color: _textDark),
        ),
        actions: [
          ListenableBuilder(
            listenable: favoriteProvider,
            builder: (context, _) {
              final isFav = favoriteProvider.isFavorite(product.id);
              return IconButton(
                onPressed: () {
                  favoriteProvider.toggleFavorite(product);
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(
                        content: Text(
                          isFav
                            ? '${product.name} dihapus dari Favorit'
                            : '${product.name} ditambahkan ke Favorit! ❤️'
                        ),
                      ),
                    );
                },
                icon: Icon(
                  isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                  color: isFav ? _accentPink : _textDark,
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Product image ──────────────────────
            Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _surface,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.04), offset: const Offset(0, 8), blurRadius: 24),
                  ],
                ),
                child: Image.asset(
                  product.imageUrl,
                  height: 200, width: 200,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 200, width: 200,
                    color: _bgLight,
                    child: const Icon(Icons.image_not_supported_outlined, size: 48, color: _textLight),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // ── Name ─────────────────────────────────────────────────
            Text(
              product.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: _textDark),
            ),
            const SizedBox(height: 16),

            // ── Price + Discount row ─────────────────────────────────
            Row(
              children: [
                Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: _primary),
                ),
                if (product.discountPercent > 0) ...[
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: _accentPink.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '-${product.discountPercent}%',
                      style: const TextStyle(fontSize: 14, color: _accentPink, fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 24),

            // ── Description ──────────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: _surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.02), offset: const Offset(0, 4), blurRadius: 12),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.description_outlined, size: 20, color: _primary),
                      SizedBox(width: 8),
                      Text('Deskripsi', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: _textDark)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(product.description, style: const TextStyle(fontSize: 14, color: _textLight, height: 1.5)),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ── Reviews Section ──────────────────────────────────────
            ListenableBuilder(
              listenable: reviewProvider,
              builder: (context, _) {
                final reviews = reviewProvider.getReviewsForProduct(product.id);
                final avgRating = reviewProvider.getAverageRating(product.id);
                
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Ulasan Pembeli', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: _textDark)),
                        if (reviews.isNotEmpty)
                          Row(
                            children: [
                              const Icon(Icons.star_rounded, color: Color(0xFFFFB74D), size: 18),
                              const SizedBox(width: 4),
                              Text('${avgRating.toStringAsFixed(1)} (${reviews.length})', style: const TextStyle(fontWeight: FontWeight.w700, color: _textDark)),
                            ],
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (reviews.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Text('Belum ada ulasan.', style: TextStyle(color: _textLight.withOpacity(0.8))),
                        ),
                      )
                    else
                      ...reviews.take(3).map((review) => Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: _surface,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), offset: const Offset(0, 4), blurRadius: 12)],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(review.userName, style: const TextStyle(fontWeight: FontWeight.w600, color: _textDark)),
                                Row(
                                  children: List.generate(5, (index) => Icon(
                                    index < review.rating ? Icons.star_rounded : Icons.star_border_rounded,
                                    color: const Color(0xFFFFB74D),
                                    size: 14,
                                  )),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(review.comment, style: const TextStyle(fontSize: 13, color: _textLight, height: 1.4)),
                          ],
                        ),
                      )),
                    
                    const SizedBox(height: 12),
                    Center(
                      child: TextButton.icon(
                        onPressed: () => _showAddReviewSheet(context, product.id),
                        icon: const Icon(Icons.edit_rounded, size: 18),
                        label: const Text('Tulis Ulasan', style: TextStyle(fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ],
                );
              }
            ),
            const SizedBox(height: 32),

            // ── Add to Cart button ───────────────────────────────────
            GestureDetector(
              onTap: () {
                cartProvider.addToCart(product);
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(SnackBar(content: Text('${product.name} ditambahkan ke keranjang')));
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFF6B73FF), Color(0xFF4C53A5)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: _primary.withOpacity(0.3), offset: const Offset(0, 4), blurRadius: 16),
                  ],
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_shopping_cart_rounded, color: Colors.white, size: 22),
                    SizedBox(width: 10),
                    Text('Add to Cart', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showAddReviewSheet(BuildContext context, String productId) {
    int rating = 5;
    final controller = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Tulis Ulasan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: _textDark)),
                const SizedBox(height: 24),
                
                const Text('Rating', style: TextStyle(fontWeight: FontWeight.w600, color: _textDark)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) => GestureDetector(
                    onTap: () => setState(() => rating = index + 1),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Icon(
                        index < rating ? Icons.star_rounded : Icons.star_border_rounded,
                        color: const Color(0xFFFFB74D),
                        size: 32,
                      ),
                    ),
                  )),
                ),
                const SizedBox(height: 24),
                
                const Text('Komentar', style: TextStyle(fontWeight: FontWeight.w600, color: _textDark)),
                const SizedBox(height: 8),
                TextField(
                  controller: controller,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Tulis pendapatmu tentang produk ini...',
                    hintStyle: const TextStyle(color: _textLight),
                    filled: true,
                    fillColor: _bgLight,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 24),
                
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      if (controller.text.trim().isEmpty) return;
                      reviewProvider.addReview(
                        productId: productId,
                        userName: 'Jeki', // Hardcoded for demo
                        rating: rating,
                        comment: controller.text.trim(),
                      );
                      Navigator.pop(ctx);
                    },
                    child: const Text('Kirim Ulasan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

