import 'package:flutter/material.dart';

import '../providers/order_provider.dart';
import '../providers/review_provider.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  static const _textDark = Color(0xFF2D3142);
  static const _textLight = Color(0xFF9094A6);
  static const _bgLight = Color(0xFFF8F9FA);
  static const _primary = Color(0xFF4C53A5);
  static const _accentPink = Color(0xFFFF6B6B);
  static const _surface = Colors.white;

  // Removed avatar picker dependencies

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgLight,
      appBar: AppBar(
        backgroundColor: _surface,
        elevation: 0,
        title: const Row(
          children: [
            Icon(Icons.person_rounded, color: _textDark),
            SizedBox(width: 8),
            Text('Profile', style: TextStyle(fontWeight: FontWeight.w700, color: _textDark)),
          ],
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
                color: _surface,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.04), offset: const Offset(0, 4), blurRadius: 16),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 72, height: 72,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage('assets/images/pfp.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Jeki', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: _textDark)),
                        SizedBox(height: 4),
                        Text('jeki@example.com', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: _textLight)),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(const SnackBar(content: Text('Fitur ubah foto akan segera hadir!')));
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: _primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.edit_rounded, color: _primary, size: 20),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // ── Stats Row ─────────────────────────────────────────
            ListenableBuilder(
              listenable: orderProvider,
              builder: (context, _) => ListenableBuilder(
                listenable: reviewProvider,
                builder: (context, _) {
                  return Row(
                    children: [
                      Expanded(child: _buildStatCard('Orders', Icons.inventory_2_rounded, '${orderProvider.orders.length}', const LinearGradient(colors: [Color(0xFF4EE3CD), Color(0xFF35A796)], begin: Alignment.topLeft, end: Alignment.bottomRight))),
                      const SizedBox(width: 12),
                      Expanded(child: _buildStatCard('Coupons', Icons.local_offer_rounded, '5', const LinearGradient(colors: [Color(0xFFFFC770), Color(0xFFFF9800)], begin: Alignment.topLeft, end: Alignment.bottomRight))),
                      const SizedBox(width: 12),
                      Expanded(child: _buildStatCard('Reviews', Icons.star_rounded, '${reviewProvider.allReviews.where((r) => r.userName == 'Jeki').length}', const LinearGradient(colors: [Color(0xFFC46FE0), Color(0xFF8E24AA)], begin: Alignment.topLeft, end: Alignment.bottomRight))),
                    ],
                  );
                }
              ),
            ),
            const SizedBox(height: 32),

            // ── Menus ─────────────────────────────────────────────
            _buildMenuTile(Icons.favorite_rounded, 'Favorit Saya', _accentPink, context, route: '/favorite'),
            _buildMenuTile(Icons.shopping_bag_outlined, 'Riwayat Pesanan', const Color(0xFF4ECDC4), context, route: '/order-history'),
            _buildMenuTile(Icons.location_on_outlined, 'Alamat Pengiriman', const Color(0xFFFFB74D), context, route: '/address'),
            _buildMenuTile(Icons.notifications_none_rounded, 'Notifikasi', _accentPink, context, route: '/notification'),
            _buildMenuTile(Icons.payment_rounded, 'Metode Pembayaran', const Color(0xFF4CAF50), context),
            _buildMenuTile(Icons.help_outline_rounded, 'Pusat Bantuan', const Color(0xFFD1C4E9), context, route: '/help-center'),
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
                  color: _surface,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), offset: const Offset(0, 4), blurRadius: 16)],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout_rounded, color: _accentPink, size: 22),
                    const SizedBox(width: 8),
                    Text('Logout', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: _accentPink)),
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

  Widget _buildStatCard(String title, IconData icon, String count, LinearGradient gradient) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: gradient.colors.first.withOpacity(0.3),
            offset: const Offset(0, 4),
            blurRadius: 12,
          )
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 28, color: Colors.white),
          const SizedBox(height: 8),
          Text(count, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white)),
          const SizedBox(height: 4),
          Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildMenuTile(IconData icon, String title, Color color, BuildContext context, {String? route}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), offset: const Offset(0, 4), blurRadius: 12)],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        title: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: _textDark)),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: _textLight),
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
