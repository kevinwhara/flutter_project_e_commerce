import 'package:flutter/material.dart';

/// Judul + subjudul halaman auth. Angka (fontSize 32/18, SizedBox 10)
/// sama persis spesifikasi modul — jangan diubah.
class AuthHeader extends StatelessWidget {
  const AuthHeader({
    super.key,
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      // min: header ini dipasang di dalam Column yang dibungkus
      // SingleChildScrollView (tinggi unbounded) — tanpa min, Column akan
      // coba mengambil tinggi tak terhingga dan crash saat layout.
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Color(0xFF4C53A5),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 18,
            color: Color(0xFF4C53A5),
          ),
        ),
      ],
    );
  }
}
