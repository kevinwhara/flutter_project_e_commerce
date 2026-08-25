import 'package:flutter/material.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  static const _borderColor = Color(0xFF1A1A2E);
  static const _bgColor = Color(0xFFFFF59D);
  static const _purple = Color(0xFFAB47BC);
  static const _teal = Color(0xFF4ECDC4);
  static const _orange = Color(0xFFFFB74D);
  static const _pink = Color(0xFFFF6B6B);
  static const _green = Color(0xFF4CAF50);
  static const _lavender = Color(0xFFD1C4E9);

  // State untuk avatar yang bisa diganti
  IconData _currentAvatar = Icons.face_rounded;
  Color _currentAvatarColor = _lavender;

  // Daftar opsi avatar
  final List<Map<String, dynamic>> _avatarOptions = [
    {'icon': Icons.face_rounded, 'color': Color(0xFFD1C4E9)}, // lavender
    {'icon': Icons.pets_rounded, 'color': Color(0xFFFFB74D)}, // orange
    {'icon': Icons.rocket_launch_rounded, 'color': Color(0xFF4ECDC4)}, // teal
    {'icon': Icons.sports_esports_rounded, 'color': Color(0xFFFF6B6B)}, // pink
    {'icon': Icons.music_note_rounded, 'color': Color(0xFFAB47BC)}, // purple
    {'icon': Icons.camera_alt_rounded, 'color': Color(0xFF4CAF50)}, // green
  ];

  void _showAvatarPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
            border: Border(
              top: BorderSide(color: _borderColor, width: 3.5),
              left: BorderSide(color: _borderColor, width: 3.5),
              right: BorderSide(color: _borderColor, width: 3.5),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Pilih Avatar Baru',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: _borderColor),
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
                        color: option['color'],
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _borderColor,
                          width: isSelected ? 4 : 2,
                        ),
                        boxShadow: isSelected
                            ? const [BoxShadow(color: _borderColor, offset: Offset(4, 4), blurRadius: 0)]
                            : const [BoxShadow(color: _borderColor, offset: Offset(2, 2), blurRadius: 0)],
                      ),
                      child: Icon(option['icon'], size: 32, color: _borderColor),
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
      backgroundColor: _bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Row(
          children: [
            Icon(Icons.person_rounded, color: _borderColor),
            SizedBox(width: 8),
            Text('Profile', style: TextStyle(fontWeight: FontWeight.w900, color: _borderColor)),
          ],
        ),
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
                      color: _currentAvatarColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: _borderColor, width: 2.5),
                    ),
                    child: Center(child: Icon(_currentAvatar, size: 38, color: _borderColor)),
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
                  GestureDetector(
                    onTap: _showAvatarPicker,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _pink, shape: BoxShape.circle,
                        border: Border.all(color: _borderColor, width: 2),
                      ),
                      child: const Icon(Icons.edit_rounded, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // ── Stats Row ─────────────────────────────────────────
            Row(
              children: [
                Expanded(child: _buildStatCard('Orders', Icons.inventory_2_rounded, '12', _teal)),
                const SizedBox(width: 12),
                Expanded(child: _buildStatCard('Coupons', Icons.local_offer_rounded, '5', _orange)),
                const SizedBox(width: 12),
                Expanded(child: _buildStatCard('Reviews', Icons.star_rounded, '8', _purple)),
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

  Widget _buildStatCard(String title, IconData icon, String count, Color color) {
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
          Icon(icon, size: 28, color: _borderColor),
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
