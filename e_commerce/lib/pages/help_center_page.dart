import 'package:flutter/material.dart';

class HelpCenterPage extends StatelessWidget {
  const HelpCenterPage({super.key});

  static const _borderColor = Color(0xFF1A1A2E);
  static const _bgColor = Color(0xFFFFF59D);
  static const _pink = Color(0xFFFF6B6B);

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
        title: const Text('Pusat Bantuan 🆘', style: TextStyle(fontWeight: FontWeight.w900, color: _borderColor)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(3.5),
          child: Container(color: _borderColor, height: 3.5),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: _pink,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _borderColor, width: 3),
              boxShadow: const [BoxShadow(color: _borderColor, offset: Offset(5, 5), blurRadius: 0)],
            ),
            child: const Column(
              children: [
                Text('💬', style: TextStyle(fontSize: 48)),
                SizedBox(height: 12),
                Text('Ada yang bisa kami bantu?', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white)),
                SizedBox(height: 8),
                Text('Tim support kami siap membantu Anda 24/7.', textAlign: TextAlign.center, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white)),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _buildFaqItem('Bagaimana cara meretur barang?'),
          _buildFaqItem('Berapa lama proses pengiriman?'),
          _buildFaqItem('Apakah ada garansi untuk produk elektronik?'),
          _buildFaqItem('Bagaimana cara menukar kode promo?'),
        ],
      ),
    );
  }

  Widget _buildFaqItem(String question) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderColor, width: 2.5),
        boxShadow: const [BoxShadow(color: _borderColor, offset: Offset(3, 3), blurRadius: 0)],
      ),
      child: ExpansionTile(
        title: Text(question, style: const TextStyle(fontWeight: FontWeight.w800, color: _borderColor, fontSize: 14)),
        iconColor: _borderColor,
        collapsedIconColor: _borderColor,
        shape: const RoundedRectangleBorder(side: BorderSide.none), // Remove borders on expand
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: _borderColor, width: 2)),
            ),
            child: const Text(
              'Ini adalah jawaban contoh untuk pertanyaan di atas. Anda bisa mengedit bagian ini nanti.',
              style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey, height: 1.5),
            ),
          )
        ],
      ),
    );
  }
}
