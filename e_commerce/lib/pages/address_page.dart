import 'package:flutter/material.dart';

class AddressPage extends StatelessWidget {
  const AddressPage({super.key});

  static const _borderColor = Color(0xFF1A1A2E);
  static const _bgColor = Color(0xFFFFF59D);
  static const _purple = Color(0xFFAB47BC);
  static const _teal = Color(0xFF4ECDC4);

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
        title: const Row(
          children: [
            Icon(Icons.location_on_rounded, color: _borderColor),
            SizedBox(width: 8),
            Text('Alamat Pengiriman', style: TextStyle(fontWeight: FontWeight.w900, color: _borderColor)),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(3.5),
          child: Container(color: _borderColor, height: 3.5),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildAddressCard('Rumah', Icons.home_rounded, 'Jeki Sudirman', 'Jl. Jenderal Sudirman No. 45, Jakarta Pusat, 10220', true, _teal),
          const SizedBox(height: 16),
          _buildAddressCard('Kantor', Icons.business_rounded, 'Jeki Worker', 'Gedung Tech Tower Lt. 12, Sudirman CBD, Jakarta', false, _purple),
          const SizedBox(height: 32),
          GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tambah alamat belum diimplementasi')));
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: _borderColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _borderColor, width: 2),
                boxShadow: const [BoxShadow(color: _borderColor, offset: Offset(4, 4), blurRadius: 0)],
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_rounded, color: Colors.white, size: 24),
                  SizedBox(width: 8),
                  Text('Tambah Alamat Baru', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w900)),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildAddressCard(String label, IconData icon, String name, String fullAddress, bool isMain, Color accentColor) {
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
              Row(
                children: [
                  Icon(icon, color: _borderColor, size: 20),
                  const SizedBox(width: 8),
                  Text(label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: _borderColor)),
                ],
              ),
              if (isMain)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: accentColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: _borderColor, width: 2),
                  ),
                  child: const Text('Utama', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Colors.white)),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: _borderColor)),
          const SizedBox(height: 4),
          Text(fullAddress, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey, height: 1.4)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: _borderColor, width: 2),
                  ),
                  child: const Center(child: Text('Ubah', style: TextStyle(fontWeight: FontWeight.w800, color: _borderColor))),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: _borderColor, width: 2),
                  ),
                  child: const Center(child: Text('Hapus', style: TextStyle(fontWeight: FontWeight.w800, color: _borderColor))),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
