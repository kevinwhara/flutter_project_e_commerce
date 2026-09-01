import 'package:flutter/foundation.dart';
import '../models/review.dart';

/// Global instance for review state management.
final ReviewProvider reviewProvider = ReviewProvider();

class ReviewProvider extends ChangeNotifier {
  int _nextId = 100;

  final List<Review> _reviews = [
    // Pre-populated dummy reviews
    Review(
      id: 'r1',
      productId: 'p1',
      userName: 'Budi Santoso',
      rating: 5,
      comment: 'Risol-nya enak banget! Renyah di luar, isi dagingnya berlimpah. Recommended!',
      date: DateTime(2026, 8, 28),
    ),
    Review(
      id: 'r2',
      productId: 'p1',
      userName: 'Siti Aminah',
      rating: 4,
      comment: 'Enak sih, tapi pengirimannya agak lama. Overall puas.',
      date: DateTime(2026, 8, 25),
    ),
    Review(
      id: 'r3',
      productId: 'p2',
      userName: 'Andi Wijaya',
      rating: 5,
      comment: 'Mie ayamnya mantap! Kuahnya gurih, ayamnya banyak. Porsi pas!',
      date: DateTime(2026, 8, 30),
    ),
    Review(
      id: 'r4',
      productId: 'p2',
      userName: 'Rina Puspita',
      rating: 4,
      comment: 'Mie-nya lembut dan bumbu meresap. Pangsit gorengnya crispy.',
      date: DateTime(2026, 8, 27),
    ),
    Review(
      id: 'r5',
      productId: 'p3',
      userName: 'Pak Joko',
      rating: 5,
      comment: 'Gethuknya legit banget, kayak buatan nenek di kampung. Nostalgia!',
      date: DateTime(2026, 8, 29),
    ),
    Review(
      id: 'r6',
      productId: 'p4',
      userName: 'Doni Saputra',
      rating: 4,
      comment: 'Ban-nya kuat dan tahan lama. Sudah pakai 3 bulan masih bagus.',
      date: DateTime(2026, 8, 20),
    ),
    Review(
      id: 'r7',
      productId: 'p5',
      userName: 'Maya Kusuma',
      rating: 3,
      comment: 'Kristalnya bagus tapi ukurannya lebih kecil dari yang diharapkan.',
      date: DateTime(2026, 8, 22),
    ),
  ];

  List<Review> get allReviews => List.unmodifiable(_reviews);

  List<Review> getReviewsForProduct(String productId) {
    return _reviews.where((r) => r.productId == productId).toList();
  }

  double getAverageRating(String productId) {
    final productReviews = getReviewsForProduct(productId);
    if (productReviews.isEmpty) return 0.0;
    final total = productReviews.fold<int>(0, (sum, r) => sum + r.rating);
    return total / productReviews.length;
  }

  void addReview({
    required String productId,
    required String userName,
    required int rating,
    required String comment,
  }) {
    _reviews.insert(0, Review(
      id: 'r${_nextId++}',
      productId: productId,
      userName: userName,
      rating: rating,
      comment: comment,
      date: DateTime.now(),
    ));
    notifyListeners();
  }
}
