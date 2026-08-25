import 'package:flutter/material.dart';

import '../models/product.dart';

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
            const SizedBox(height: 32),

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
                  color: _primary,
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
}
