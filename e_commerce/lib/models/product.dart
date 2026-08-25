class Product {
  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.discountPercent,
    required this.imageUrl,
    required this.description,
  });

  final String id;
  final String name;
  final double price;
  final int discountPercent;
  final String imageUrl;
  final String description;
}
