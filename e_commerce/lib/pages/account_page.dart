import 'package:flutter/material.dart';

/// Neo Brutalism styled fully featured account page.
class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  static const _borderColor = Color(0xFF1A1A2E);
  static const _bgColor = Color(0xFFFFF59D);
  static const _purple = Color(0xFFAB47BC);
  static const _teal = Color(0xFF4ECDC4);
  static const _orange = Color(0xFFFFB74D);
  static const _pink = Color(0xFFFF6B6B);
  static const _green = Color(0xFF4CAF50);
  static const _lavender = Color(0xFFD1C4E9);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Profile 🧑‍🚀', style: TextStyle(fontWeight: FontWeight.w900, color: _borderColor)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(3.5),
          child: Container(color: _borderColor, height: 3.5),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          children: [
            // ── Profile Header Card ────────────────────────────
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _borderColor, width: 3),
                boxShadow: const [BoxShadow(color: _borderColor, offset: Offset(5, 5), blurRadius: 0)],
              ),
              child: Row(
                children: [
                  Container(
                    width: 72, height: 72,
                    decoration: BoxDecoration(
                      color: _lavender, shape: BoxShape.circle,
                      border: Border.all(color: _borderColor, width: 2.5),
                    ),
                    child: const Center(child: Text('😎', style: TextStyle(fontSize: 38))),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Jeki', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: _borderColor)),
                        SizedBox(height: 4),
                        Text('jeki@example.com', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.grey)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _pink, shape: BoxShape.circle,
                      border: Border.all(color: _borderColor, width: 2),
                    ),
                    child: const Icon(Icons.edit_rounded, color: Colors.white, size: 20),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // ── Stats Row ─────────────────────────────────────────
            Row(
              children: [
                Expanded(child: _buildStatCard('Orders', '📦', '12', _teal)),
                const SizedBox(width: 12),
                Expanded(child: _buildStatCard('Coupons', '🎫', '5', _orange)),
                const SizedBox(width: 12),
                Expanded(child: _buildStatCard('Reviews', '⭐', '8', _purple)),
              ],
            ),
            const SizedBox(height: 32),

            // ── Menus ─────────────────────────────────────────────
            _buildMenuTile(Icons.shopping_bag_outlined, 'Riwayat Pesanan', _teal, context, route: '/order-history'),
            _buildMenuTile(Icons.location_on_outlined, 'Alamat Pengiriman', _orange, context, route: '/address'),
            _buildMenuTile(Icons.notifications_none_rounded, 'Notifikasi', _pink, context),
            _buildMenuTile(Icons.payment_rounded, 'Metode Pembayaran', _green, context),
            _buildMenuTile(Icons.help_outline_rounded, 'Pusat Bantuan', _lavender, context, route: '/help-center'),
            const SizedBox(height: 24),

            // ── Logout Button ─────────────────────────────────────
            GestureDetector(
              onTap: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: _pink,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _borderColor, width: 3),
                  boxShadow: const [BoxShadow(color: _borderColor, offset: Offset(4, 4), blurRadius: 0)],
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout_rounded, color: Colors.white, size: 22),
                    SizedBox(width: 8),
                    Text('Logout', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String emoji, String count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderColor, width: 2.5),
        boxShadow: const [BoxShadow(color: _borderColor, offset: Offset(3, 3), blurRadius: 0)],
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 8),
          Text(count, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white)),
          const SizedBox(height: 4),
          Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildMenuTile(IconData icon, String title, Color color, BuildContext context, {String? route}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderColor, width: 2.5),
        boxShadow: const [BoxShadow(color: _borderColor, offset: Offset(3, 3), blurRadius: 0)],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: _borderColor, width: 2),
          ),
          child: Icon(icon, color: _borderColor, size: 22),
        ),
        title: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: _borderColor)),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 18, color: _borderColor),
        onTap: () {
          if (route != null) {
            Navigator.pushNamed(context, route);
          } else {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text('$title belum tersedia')));
          }
        },
      ),
    );
  }
}
