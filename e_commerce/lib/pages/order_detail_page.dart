import 'package:flutter/material.dart';

import '../models/order.dart';
import '../providers/order_provider.dart';
import '../providers/notification_provider.dart';
import '../models/notification_item.dart';

class OrderDetailPage extends StatelessWidget {
  const OrderDetailPage({super.key});

  static const _textDark = Color(0xFF2D3142);
  static const _textLight = Color(0xFF9094A6);
  static const _bgLight = Color(0xFFF8F9FA);
  static const _primary = Color(0xFF4C53A5);

  @override
  Widget build(BuildContext context) {
    final orderId = ModalRoute.of(context)!.settings.arguments as String;

    return ListenableBuilder(
      listenable: orderProvider,
      builder: (context, _) {
        final order = orderProvider.getOrderById(orderId);

        if (order == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Detail Pesanan')),
            body: const Center(child: Text('Pesanan tidak ditemukan')),
          );
        }

        return Scaffold(
          backgroundColor: _bgLight,
          appBar: AppBar(
            backgroundColor: Colors.white,
            foregroundColor: _textDark,
            elevation: 0,
            centerTitle: true,
            title: Text(order.id, style: const TextStyle(fontWeight: FontWeight.w800)),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status Timeline
                _buildStatusTimeline(order),
                const SizedBox(height: 24),

                // Items
                const Text('Daftar Barang', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: _textDark)),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), offset: const Offset(0, 4), blurRadius: 12)],
                  ),
                  child: Column(
                    children: order.items.map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              item.imageUrl,
                              width: 50, height: 50,
                              fit: BoxFit.cover,
                              errorBuilder: (c, e, s) => Container(width: 50, height: 50, color: _bgLight, child: const Icon(Icons.image)),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.name, style: const TextStyle(fontWeight: FontWeight.w600, color: _textDark), maxLines: 1, overflow: TextOverflow.ellipsis),
                                const SizedBox(height: 4),
                                Text('${item.quantity}x  •  \$${item.price.toStringAsFixed(2)}', style: const TextStyle(color: _textLight, fontSize: 12)),
                              ],
                            ),
                          ),
                          Text('\$${(item.price * item.quantity).toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w700, color: _textDark)),
                        ],
                      ),
                    )).toList(),
                  ),
                ),
                const SizedBox(height: 24),

                // Payment Info
                const Text('Detail Pembayaran', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: _textDark)),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), offset: const Offset(0, 4), blurRadius: 12)],
                  ),
                  child: Column(
                    children: [
                      _buildPaymentRow('Metode', order.paymentMethod),
                      const SizedBox(height: 10),
                      _buildPaymentRow('Subtotal', '\$${order.totalPrice.toStringAsFixed(2)}'),
                      const SizedBox(height: 10),
                      _buildPaymentRow('Ongkos Kirim', '\$${order.deliveryFee.toStringAsFixed(2)}'),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Divider(height: 1),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: _textDark)),
                          Text('\$${order.grandTotal.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 20, color: _primary)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Address
                const Text('Alamat Pengiriman', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: _textDark)),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), offset: const Offset(0, 4), blurRadius: 12)],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFB74D).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.location_on_rounded, color: Color(0xFFFFB74D), size: 24),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(order.address, style: TextStyle(color: _textDark.withOpacity(0.7), height: 1.4)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Action Buttons (only for diproses status)
                if (order.status == OrderStatus.diproses)
                  _buildActionButton(
                    context,
                    'Simulasi: Kirim Pesanan',
                    Icons.local_shipping_rounded,
                    const Color(0xFF4ECDC4),
                    () {
                      orderProvider.updateStatus(order.id, OrderStatus.dikirim);
                      notificationProvider.addNotification(
                        title: 'Pesanan Dikirim! 🚚',
                        message: 'Pesanan ${order.id} sedang dalam perjalanan ke alamatmu.',
                        type: NotificationType.order,
                      );
                    },
                  ),

                if (order.status == OrderStatus.dikirim)
                  _buildActionButton(
                    context,
                    'Simulasi: Pesanan Selesai',
                    Icons.check_circle_rounded,
                    const Color(0xFF4CAF50),
                    () {
                      orderProvider.updateStatus(order.id, OrderStatus.selesai);
                      notificationProvider.addNotification(
                        title: 'Pesanan Selesai! ✅',
                        message: 'Pesanan ${order.id} telah sampai. Jangan lupa kasih ulasan ya!',
                        type: NotificationType.order,
                      );
                    },
                  ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusTimeline(Order order) {
    final steps = [
      _TimelineStep('Pesanan Dibuat', Icons.receipt_long_rounded, true),
      _TimelineStep('Diproses', Icons.inventory_2_rounded, order.status.index >= OrderStatus.diproses.index),
      _TimelineStep('Dikirim', Icons.local_shipping_rounded, order.status.index >= OrderStatus.dikirim.index),
      _TimelineStep('Selesai', Icons.check_circle_rounded, order.status == OrderStatus.selesai),
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), offset: const Offset(0, 4), blurRadius: 12)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Status Pesanan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: _textDark)),
          const SizedBox(height: 20),
          ...List.generate(steps.length, (i) {
            final step = steps[i];
            final isLast = i == steps.length - 1;
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Container(
                      width: 36, height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: step.isActive ? _primary : _bgLight,
                      ),
                      child: Icon(step.icon, size: 18, color: step.isActive ? Colors.white : _textLight),
                    ),
                    if (!isLast)
                      Container(
                        width: 2, height: 32,
                        color: step.isActive ? _primary : _bgLight,
                      ),
                  ],
                ),
                const SizedBox(width: 16),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    step.label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: step.isActive ? FontWeight.w700 : FontWeight.w500,
                      color: step.isActive ? _textDark : _textLight,
                    ),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildPaymentRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: _textLight)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600, color: _textDark)),
      ],
    );
  }

  Widget _buildActionButton(BuildContext context, String label, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: color.withOpacity(0.3), offset: const Offset(0, 8), blurRadius: 16)],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15)),
          ],
        ),
      ),
    );
  }
}

class _TimelineStep {
  const _TimelineStep(this.label, this.icon, this.isActive);
  final String label;
  final IconData icon;
  final bool isActive;
}
