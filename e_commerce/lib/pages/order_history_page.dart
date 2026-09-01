import 'package:flutter/material.dart';

import '../models/order.dart';
import '../providers/order_provider.dart';

class OrderHistoryPage extends StatelessWidget {
  const OrderHistoryPage({super.key});

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
        title: const Text('Riwayat Pesanan', style: TextStyle(fontWeight: FontWeight.w800)),
      ),
      body: ListenableBuilder(
        listenable: orderProvider,
        builder: (context, _) {
          final orders = orderProvider.orders;

          if (orders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.receipt_long_rounded, size: 80, color: _textLight.withOpacity(0.3)),
                  const SizedBox(height: 16),
                  const Text(
                    'Belum ada pesanan',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: _textLight),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Pesanan yang sudah kamu checkout\nakan muncul di sini.',
                    style: TextStyle(fontSize: 14, color: _textLight.withOpacity(0.7)),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return _buildOrderCard(context, order);
            },
          );
        },
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context, Order order) {
    final statusColor = _getStatusColor(order.status);
    final itemCount = order.items.fold<int>(0, (s, i) => s + i.quantity);

    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/order-detail', arguments: order.id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.03), offset: const Offset(0, 4), blurRadius: 12),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Order ID + Status Badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(order.id, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: _textDark)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    order.statusLabel,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: statusColor),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Date + Item count
            Row(
              children: [
                Icon(Icons.calendar_today_rounded, size: 14, color: _textLight),
                const SizedBox(width: 6),
                Text(
                  _formatDate(order.orderDate),
                  style: const TextStyle(fontSize: 13, color: _textLight),
                ),
                const SizedBox(width: 16),
                Icon(Icons.shopping_bag_outlined, size: 14, color: _textLight),
                const SizedBox(width: 6),
                Text(
                  '$itemCount barang',
                  style: const TextStyle(fontSize: 13, color: _textLight),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Item previews (show first 2 items)
            ...order.items.take(2).map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      item.imageUrl,
                      width: 40, height: 40,
                      fit: BoxFit.cover,
                      errorBuilder: (c, e, s) => Container(
                        width: 40, height: 40,
                        color: _bgLight,
                        child: const Icon(Icons.image, size: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      item.name,
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _textDark),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    '${item.quantity}x',
                    style: const TextStyle(fontSize: 12, color: _textLight),
                  ),
                ],
              ),
            )),

            if (order.items.length > 2)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  '+${order.items.length - 2} produk lainnya',
                  style: TextStyle(fontSize: 12, color: _primary.withOpacity(0.7), fontWeight: FontWeight.w600),
                ),
              ),

            const Divider(height: 24),

            // Total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total Pembayaran', style: TextStyle(fontSize: 13, color: _textLight)),
                Text(
                  '\$${order.grandTotal.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: _primary),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.diproses:
        return const Color(0xFFFFB74D);
      case OrderStatus.dikirim:
        return const Color(0xFF4ECDC4);
      case OrderStatus.selesai:
        return const Color(0xFF4CAF50);
    }
  }

  String _formatDate(DateTime date) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
    return '${date.day} ${months[date.month - 1]} ${date.year}, ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
