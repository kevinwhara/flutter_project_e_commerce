import 'package:flutter/material.dart';

import '../models/product.dart';
import 'product_card.dart';

/// Grid of product cards — same layout, no extra animations needed since
/// ProductCard already handles its own tap animation.
class ItemsWidget extends StatelessWidget {
  const ItemsWidget({super.key, required this.products});

  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      childAspectRatio: 0.62,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      shrinkWrap: true,
      children: products.map((p) => ProductCard(product: p)).toList(),
    );
  }
}
