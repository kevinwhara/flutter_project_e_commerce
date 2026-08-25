import 'package:flutter/material.dart';

class OrderHistoryPage extends StatelessWidget {
  const OrderHistoryPage({super.key});

  static const _borderColor = Color(0xFF1A1A2E);
  static const _bgColor = Color(0xFFFFF59D);
  static const _green = Color(0xFF4CAF50);
  static const _teal = Color(0xFF4ECDC4);
  static const _pink = Color(0xFFFF6B6B);
  static const _orange = Color(0xFFFFB74D);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: _borderColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Riwayat Pesanan', style: TextStyle(fontWeight: FontWeight.w900, color: _borderColor)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(3.5),
          child: Container(color: _borderColor, height: 3.5),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildOrderCard(
            id: 'ORD-29931',
            date: '12 Agustus 2026',
            status: 'Dikirim',
            statusColor: _green,
            icon: Icons.local_shipping_rounded,
            total: '\$148.50',
            itemCount: 3,
          ),
          const SizedBox(height: 16),
          _buildOrderCard(
            id: 'ORD-29910',
            date: '5 Agustus 2026',
            status: 'Selesai',
            statusColor: _teal,
            icon: Icons.check_circle_rounded,
            total: '\$24.00',
            itemCount: 1,
          ),
          const SizedBox(height: 16),
          _buildOrderCard(
            id: 'ORD-29850',
            date: '20 Juli 2026',
            status: 'Dibatalkan',
            statusColor: _pink,
            icon: Icons.cancel_rounded,
            total: '\$12.99',
            itemCount: 2,
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard({
    required String id,
    required String date,
    required String status,
    required Color statusColor,
    required IconData icon,
    required String total,
    required int itemCount,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _borderColor, width: 3),
        boxShadow: const [BoxShadow(color: _borderColor, offset: Offset(5, 5), blurRadius: 0)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(id, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: _borderColor)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: _borderColor, width: 2),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, size: 14, color: _borderColor),
                    const SizedBox(width: 4),
                    Text(status, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: _borderColor)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(date, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey)),
          const Divider(color: _borderColor, thickness: 2, height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('$itemCount Barang', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: _borderColor)),
              Text(total, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: _borderColor)),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: _orange,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: _borderColor, width: 2.5),
              boxShadow: const [BoxShadow(color: _borderColor, offset: Offset(3, 3), blurRadius: 0)],
            ),
            child: const Center(
              child: Text('Lacak Pesanan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 14)),
            ),
          )
        ],
      ),
    );
  }
}
