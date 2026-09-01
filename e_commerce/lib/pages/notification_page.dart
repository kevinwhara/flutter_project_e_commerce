import 'package:flutter/material.dart';

import '../models/notification_item.dart';
import '../providers/notification_provider.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  static const _textDark = Color(0xFF2D3142);
  static const _textLight = Color(0xFF9094A6);
  static const _bgLight = Color(0xFFF8F9FA);
  static const _primary = Color(0xFF4C53A5);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgLight,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: _textDark,
        elevation: 0,
        centerTitle: true,
        title: const Text('Notifikasi', style: TextStyle(fontWeight: FontWeight.w800)),
        actions: [
          ListenableBuilder(
            listenable: notificationProvider,
            builder: (context, _) {
              if (notificationProvider.unreadCount == 0) return const SizedBox.shrink();
              return TextButton(
                onPressed: () => notificationProvider.markAllAsRead(),
                child: const Text('Baca Semua', style: TextStyle(fontWeight: FontWeight.w700, color: _primary, fontSize: 13)),
              );
            },
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: notificationProvider,
        builder: (context, _) {
          final items = notificationProvider.items;

          if (items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_none_rounded, size: 80, color: _textLight.withOpacity(0.3)),
                  const SizedBox(height: 16),
                  const Text(
                    'Belum ada notifikasi',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: _textLight),
                  ),
                ],
              ),
            );
          }

          // Group: Today & Earlier
          final now = DateTime.now();
          final today = <NotificationItem>[];
          final earlier = <NotificationItem>[];

          for (final item in items) {
            if (item.date.year == now.year && item.date.month == now.month && item.date.day == now.day) {
              today.add(item);
            } else {
              earlier.add(item);
            }
          }

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              if (today.isNotEmpty) ...[
                _buildSectionLabel('Hari Ini'),
                const SizedBox(height: 12),
                ...today.map((item) => _buildNotificationCard(item)),
                const SizedBox(height: 20),
              ],
              if (earlier.isNotEmpty) ...[
                _buildSectionLabel('Sebelumnya'),
                const SizedBox(height: 12),
                ...earlier.map((item) => _buildNotificationCard(item)),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: _textLight),
    );
  }

  Widget _buildNotificationCard(NotificationItem item) {
    final iconData = _getIcon(item.type);
    final iconColor = _getColor(item.type);

    return GestureDetector(
      onTap: () {
        if (!item.isRead) {
          notificationProvider.markAsRead(item.id);
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: item.isRead ? Colors.white : _primary.withOpacity(0.04),
          borderRadius: BorderRadius.circular(16),
          border: item.isRead ? null : Border.all(color: _primary.withOpacity(0.1), width: 1),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.02), offset: const Offset(0, 4), blurRadius: 12),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(iconData, color: iconColor, size: 22),
            ),
            const SizedBox(width: 14),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          item.title,
                          style: TextStyle(
                            fontWeight: item.isRead ? FontWeight.w600 : FontWeight.w800,
                            fontSize: 14,
                            color: _textDark,
                          ),
                        ),
                      ),
                      if (!item.isRead)
                        Container(
                          width: 8, height: 8,
                          decoration: const BoxDecoration(shape: BoxShape.circle, color: _primary),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.message,
                    style: TextStyle(fontSize: 13, color: _textDark.withOpacity(0.6), height: 1.4),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _formatTime(item.date),
                    style: const TextStyle(fontSize: 11, color: _textLight),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIcon(NotificationType type) {
    switch (type) {
      case NotificationType.order:
        return Icons.local_shipping_rounded;
      case NotificationType.promo:
        return Icons.local_offer_rounded;
      case NotificationType.info:
        return Icons.info_outline_rounded;
    }
  }

  Color _getColor(NotificationType type) {
    switch (type) {
      case NotificationType.order:
        return const Color(0xFF4ECDC4);
      case NotificationType.promo:
        return const Color(0xFFFF6B6B);
      case NotificationType.info:
        return _primary;
    }
  }

  String _formatTime(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 60) return '${diff.inMinutes} menit lalu';
    if (diff.inHours < 24) return '${diff.inHours} jam lalu';
    if (diff.inDays < 7) return '${diff.inDays} hari lalu';

    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}
