class Review {
  Review({
    required this.id,
    required this.productId,
    required this.userName,
    required this.rating,
    required this.comment,
    required this.date,
  });

  final String id;
  final String productId;
  final String userName;
  final int rating; // 1-5
  final String comment;
  final DateTime date;
}
