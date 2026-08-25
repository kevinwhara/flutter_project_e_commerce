import 'package:flutter/material.dart';

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

  // State untuk avatar yang bisa diganti
  IconData _currentAvatar = Icons.face_rounded;
  Color _currentAvatarColor = const Color(0xFFD1C4E9); // lavender

  // Daftar opsi avatar
  final List<Map<String, dynamic>> _avatarOptions = [
    {'icon': Icons.face_rounded, 'color': const Color(0xFFD1C4E9)}, // lavender
    {'icon': Icons.pets_rounded, 'color': const Color(0xFFFFB74D)}, // orange
    {'icon': Icons.rocket_launch_rounded, 'color': const Color(0xFF4ECDC4)}, // teal
    {'icon': Icons.sports_esports_rounded, 'color': const Color(0xFFFF6B6B)}, // pink
    {'icon': Icons.music_note_rounded, 'color': const Color(0xFFAB47BC)}, // purple
    {'icon': Icons.camera_alt_rounded, 'color': const Color(0xFF4CAF50)}, // green
  ];

  void _showAvatarPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: _surface,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Pilih Avatar Baru',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: _textDark),
              ),
              const SizedBox(height: 24),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                alignment: WrapAlignment.center,
                children: _avatarOptions.map((option) {
                  final isSelected = _currentAvatar == option['icon'];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _currentAvatar = option['icon'];
                        _currentAvatarColor = option['color'];
                      });
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(const SnackBar(content: Text('Foto profil berhasil diubah!')));
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: option['color'].withOpacity(0.2),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected ? _primary : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Icon(option['icon'], size: 32, color: option['color']),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

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
                    decoration: BoxDecoration(
                      color: _currentAvatarColor.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Center(child: Icon(_currentAvatar, size: 38, color: _currentAvatarColor)),
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
                    onTap: _showAvatarPicker,
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
            Row(
              children: [
                Expanded(child: _buildStatCard('Orders', Icons.inventory_2_rounded, '12', const Color(0xFF4ECDC4))),
                const SizedBox(width: 12),
                Expanded(child: _buildStatCard('Coupons', Icons.local_offer_rounded, '5', const Color(0xFFFFB74D))),
                const SizedBox(width: 12),
                Expanded(child: _buildStatCard('Reviews', Icons.star_rounded, '8', const Color(0xFFAB47BC))),
              ],
            ),
            const SizedBox(height: 32),

            // ── Menus ─────────────────────────────────────────────
            _buildMenuTile(Icons.shopping_bag_outlined, 'Riwayat Pesanan', const Color(0xFF4ECDC4), context, route: '/order-history'),
            _buildMenuTile(Icons.location_on_outlined, 'Alamat Pengiriman', const Color(0xFFFFB74D), context, route: '/address'),
            _buildMenuTile(Icons.notifications_none_rounded, 'Notifikasi', _accentPink, context),
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

  Widget _buildStatCard(String title, IconData icon, String count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), offset: const Offset(0, 4), blurRadius: 12)],
      ),
      child: Column(
        children: [
          Icon(icon, size: 28, color: color),
          const SizedBox(height: 8),
          Text(count, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: _textDark)),
          const SizedBox(height: 4),
          Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: _textLight)),
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
