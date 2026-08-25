import 'package:flutter/material.dart';

import '../models/product.dart';

/// Neo Brutalism styled product detail page.
class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({super.key});

  static const _borderColor = Color(0xFF1A1A2E);
  static const _bgColor = Color(0xFFFFF59D);
  static const _pink = Color(0xFFFF6B6B);
  static const _teal = Color(0xFF4ECDC4);
  static const _green = Color(0xFF4CAF50);
  static const _orange = Color(0xFFFFB74D);
  static const _lavender = Color(0xFFD1C4E9);

  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context)!.settings.arguments as Product;

    return Scaffold(
      backgroundColor: _bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: _borderColor,
        elevation: 0,
        title: Text(
          product.name,
          style: const TextStyle(fontWeight: FontWeight.w900, color: _borderColor),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(3.5),
          child: Container(color: _borderColor, height: 3.5),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Product image in bordered frame ──────────────────────
            Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _borderColor, width: 3),
                  boxShadow: const [
                    BoxShadow(color: _borderColor, offset: Offset(5, 5), blurRadius: 0),
                  ],
                ),
                child: Image.asset(
                  product.imageUrl,
                  height: 200, width: 200,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 200, width: 200,
                    color: _lavender.withValues(alpha: 0.2),
                    child: const Icon(Icons.image_not_supported_outlined, size: 48, color: _borderColor),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // ── Name ─────────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _borderColor, width: 3),
                boxShadow: const [
                  BoxShadow(color: _borderColor, offset: Offset(3, 3), blurRadius: 0),
                ],
              ),
              child: Text(
                product.name,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: _borderColor),
              ),
            ),
            const SizedBox(height: 16),

            // ── Price + Discount row ─────────────────────────────────
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: _teal.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: _borderColor, width: 2.5),
                    boxShadow: const [
                      BoxShadow(color: _borderColor, offset: Offset(3, 3), blurRadius: 0),
                    ],
                  ),
                  child: Text(
                    '\$${product.price.toStringAsFixed(0)}',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: _borderColor),
                  ),
                ),
                if (product.discountPercent > 0) ...[
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: _pink,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: _borderColor, width: 2.5),
                      boxShadow: const [
                        BoxShadow(color: _borderColor, offset: Offset(2, 2), blurRadius: 0),
                      ],
                    ),
                    child: Text(
                      '-${product.discountPercent}% 🔥',
                      style: const TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w900),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 20),

            // ── Description ──────────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _orange.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _borderColor, width: 2.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Deskripsi 📋', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: _borderColor)),
                  const SizedBox(height: 8),
                  Text(product.description, style: TextStyle(fontSize: 14, color: _borderColor.withValues(alpha: 0.7), fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // ── Add to Cart button ───────────────────────────────────
            GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(const SnackBar(content: Text('Ditambahkan ke keranjang (dummy)')));
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: _green,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _borderColor, width: 3.5),
                  boxShadow: const [
                    BoxShadow(color: _borderColor, offset: Offset(4.5, 4.5), blurRadius: 0),
                  ],
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_shopping_cart_rounded, color: Colors.white, size: 22),
                    SizedBox(width: 10),
                    Text('Add to Cart', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900)),
                    SizedBox(width: 8),
                    Text('🛒', style: TextStyle(fontSize: 18)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
