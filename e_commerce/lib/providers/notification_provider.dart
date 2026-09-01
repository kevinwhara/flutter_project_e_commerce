import 'package:flutter/foundation.dart';
import '../models/notification_item.dart';

/// Global instance for notification state management.
final NotificationProvider notificationProvider = NotificationProvider();

class NotificationProvider extends ChangeNotifier {
  int _nextId = 100;

  final List<NotificationItem> _items = [
    // Pre-populated dummy notifications
    NotificationItem(
      id: 'n1',
      title: 'Selamat Datang! 🎉',
      message: 'Terima kasih telah bergabung di KelontongKu. Nikmati gratis ongkir untuk pesanan pertamamu!',
      type: NotificationType.promo,
      date: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    NotificationItem(
      id: 'n2',
      title: 'Flash Sale Dimulai!',
      message: 'Diskon hingga 50% untuk produk makanan. Berlaku hari ini saja!',
      type: NotificationType.promo,
      date: DateTime.now().subtract(const Duration(hours: 3)),
    ),
    NotificationItem(
      id: 'n3',
      title: 'Tips Belanja Hemat',
      message: 'Kumpulkan poin setiap belanja dan tukar dengan voucher menarik di halaman Kupon.',
      type: NotificationType.info,
      date: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
    ),
  ];

  List<NotificationItem> get items => List.unmodifiable(_items);

  int get unreadCount => _items.where((n) => !n.isRead).length;

  void addNotification({
    required String title,
    required String message,
    required NotificationType type,
  }) {
    _items.insert(0, NotificationItem(
      id: 'n${_nextId++}',
      title: title,
      message: message,
      type: type,
      date: DateTime.now(),
    ));
    notifyListeners();
  }

  void markAsRead(String id) {
    try {
      final item = _items.firstWhere((n) => n.id == id);
      item.isRead = true;
      notifyListeners();
    } catch (_) {}
  }

  void markAllAsRead() {
    for (final item in _items) {
      item.isRead = true;
    }
    notifyListeners();
  }
}
