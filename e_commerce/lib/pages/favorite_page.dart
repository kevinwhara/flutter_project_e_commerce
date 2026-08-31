import 'package:flutter/material.dart';

import '../providers/favorite_provider.dart';
import '../widgets/product_card.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  static const _textDark = Color(0xFF2D3142);
  static const _bgLight = Color(0xFFF8F9FA);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgLight,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: _textDark,
        elevation: 0,
        title: const Text(
          'Favorit Saya',
          style: TextStyle(fontWeight: FontWeight.w700, color: _textDark),
        ),
      ),
      body: ListenableBuilder(
        listenable: favoriteProvider,
        builder: (context, _) {
          final items = favoriteProvider.items;
          
          if (items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border_rounded, size: 64, color: _textDark.withOpacity(0.2)),
                  const SizedBox(height: 16),
                  const Text('Belum ada produk favorit', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: _textDark)),
                  const SizedBox(height: 8),
                  Text('Yuk cari barang impianmu!', style: TextStyle(fontSize: 14, color: _textDark.withOpacity(0.5))),
                ],
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              return ProductCard(product: items[index]);
            },
          );
        },
      ),
    );
  }
}
