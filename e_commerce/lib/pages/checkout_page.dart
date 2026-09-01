import 'package:flutter/material.dart';

import '../models/notification_item.dart';
import '../providers/cart_provider.dart';
import '../providers/notification_provider.dart';
import '../providers/order_provider.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  static const _textDark = Color(0xFF2D3142);
  static const _textLight = Color(0xFF9094A6);
  static const _bgLight = Color(0xFFF8F9FA);
  static const _primary = Color(0xFF4C53A5);
  static const _accentPink = Color(0xFFFF6B6B);
  static const _accentOrange = Color(0xFFFFB74D);

  String _selectedPayment = 'GoPay';
  bool _isProcessing = false;

  void _processPayment() {
    setState(() => _isProcessing = true);
    
    // Simulate network delay
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      
      final subtotal = cartProvider.totalPrice;
      final deliveryFee = subtotal > 0 ? 15.0 : 0.0;
      
      // Save Order
      final order = orderProvider.addOrder(
        items: cartProvider.items,
        totalPrice: subtotal,
        deliveryFee: deliveryFee,
        paymentMethod: _selectedPayment,
        address: 'Jl. Mawar Indah No. 123, Komplek Asri, Jakarta Selatan 12345',
      );

      // Add Notification
      notificationProvider.addNotification(
        title: 'Pesanan Berhasil! 🎉',
        message: 'Pesanan ${order.id} berhasil dibuat dan sedang diproses.',
        type: NotificationType.order,
      );

      // Clear cart
      cartProvider.clearCart();
      
      // Show success dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle_rounded, size: 72, color: _primary),
                const SizedBox(height: 20),
                const Text(
                  'Pembayaran Berhasil!',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: _textDark),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'Pesanan Anda sedang disiapkan dan akan segera dikirim ke alamat tujuan.',
                  style: TextStyle(fontSize: 14, height: 1.5, color: _textDark.withOpacity(0.7)),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(ctx); // close dialog
                    Navigator.pushNamedAndRemoveUntil(context, '/home', (r) => false);
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: _primary,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(color: _primary.withOpacity(0.3), offset: const Offset(0, 8), blurRadius: 16),
                      ],
                    ),
                    child: const Center(
                      child: Text('Kembali ke Beranda', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }

  void _showPaymentSelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Pilih Metode Pembayaran', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: _textDark)),
            const SizedBox(height: 16),
            _buildPaymentOption('GoPay', Icons.account_balance_wallet_rounded, Colors.blue),
            _buildPaymentOption('OVO', Icons.account_balance_wallet_rounded, Colors.purple),
            _buildPaymentOption('Transfer Bank', Icons.account_balance_rounded, Colors.orange),
            _buildPaymentOption('Cash on Delivery', Icons.local_shipping_rounded, Colors.green),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOption(String name, IconData icon, Color color) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: color),
      title: Text(name, style: const TextStyle(fontWeight: FontWeight.w600, color: _textDark)),
      trailing: _selectedPayment == name ? const Icon(Icons.check_circle_rounded, color: _primary) : null,
      onTap: () {
        setState(() => _selectedPayment = name);
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = cartProvider.items;
    final subtotal = cartProvider.totalPrice;
    final deliveryFee = subtotal > 0 ? 15.0 : 0.0;
    final total = subtotal + deliveryFee;

    return Scaffold(
      backgroundColor: _bgLight,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: _textDark,
        elevation: 0,
        centerTitle: true,
        title: const Text('Checkout', style: TextStyle(fontWeight: FontWeight.w800)),
      ),
      body: items.isEmpty
          ? Center(
              child: Text(
                'Keranjang kosong',
                style: TextStyle(color: _textDark.withOpacity(0.5)),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Alamat Pengiriman
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: _accentOrange.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.location_on_rounded, color: _accentOrange, size: 24),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Rumah - Jeki', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: _textDark)),
                              const SizedBox(height: 4),
                              Text('Jl. Mawar Indah No. 123, Komplek Asri, Jakarta Selatan 12345', style: TextStyle(color: _textDark.withOpacity(0.6), height: 1.4)),
                            ],
                          ),
                        ),
                        const Icon(Icons.edit_rounded, color: _primary, size: 20),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Ringkasan Pesanan
                  const Text('Ringkasan Pesanan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: _textDark)),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), offset: const Offset(0, 4), blurRadius: 12)],
                    ),
                    child: Column(
                      children: items.map((item) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  item.imageUrl,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                  errorBuilder: (c,e,s) => Container(width: 50, height: 50, color: _bgLight, child: const Icon(Icons.image)),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item.name, style: const TextStyle(fontWeight: FontWeight.w600, color: _textDark), maxLines: 1, overflow: TextOverflow.ellipsis),
                                    const SizedBox(height: 4),
                                    Text('${item.quantity}x', style: const TextStyle(color: _textLight, fontSize: 12)),
                                  ],
                                ),
                              ),
                              Text('\$${(item.price * item.quantity).toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w700, color: _textDark)),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Metode Pembayaran
                  const Text('Metode Pembayaran', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: _textDark)),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: _showPaymentSelector,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), offset: const Offset(0, 4), blurRadius: 12)],
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.account_balance_wallet_rounded, color: _primary),
                          const SizedBox(width: 16),
                          Text(_selectedPayment, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: _textDark)),
                          const Spacer(),
                          const Icon(Icons.keyboard_arrow_down_rounded, color: _textLight),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Detail Pembayaran
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), offset: const Offset(0, 4), blurRadius: 12)],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Subtotal', style: TextStyle(color: _textLight)),
                            Text('\$${subtotal.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w600, color: _textDark)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Ongkos Kirim', style: TextStyle(color: _textLight)),
                            Text('\$${deliveryFee.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w600, color: _textDark)),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Divider(height: 1, color: _bgLight),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Total Pembayaran', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: _textDark)),
                            Text('\$${total.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 20, color: _primary)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
      bottomNavigationBar: items.isEmpty ? null : SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), offset: const Offset(0, -4), blurRadius: 16)],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: _isProcessing ? null : _processPayment,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: _isProcessing ? _textLight : _primary,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: _isProcessing ? [] : [
                      BoxShadow(color: _primary.withOpacity(0.3), offset: const Offset(0, 8), blurRadius: 16),
                    ],
                  ),
                  child: Center(
                    child: _isProcessing
                        ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                        : const Text('Bayar Sekarang', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
