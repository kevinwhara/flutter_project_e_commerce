import 'package:flutter/material.dart';

/// Neo Brutalism styled account page placeholder.
class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  static const _borderColor = Color(0xFF1A1A2E);
  static const _bgColor = Color(0xFFFFF59D);
  static const _purple = Color(0xFFAB47BC);
  static const _teal = Color(0xFF4ECDC4);
  static const _orange = Color(0xFFFFB74D);
  static const _pink = Color(0xFFFF6B6B);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _borderColor, width: 3.5),
              boxShadow: const [
                BoxShadow(color: _borderColor, offset: Offset(5, 5), blurRadius: 0),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 90, height: 90,
                  decoration: BoxDecoration(
                    color: _purple.withValues(alpha: 0.2), shape: BoxShape.circle,
                    border: Border.all(color: _borderColor, width: 3),
                    boxShadow: [BoxShadow(color: _borderColor.withValues(alpha: 0.8), offset: const Offset(3, 3), blurRadius: 0)],
                  ),
                  child: const Center(child: Text('👤', style: TextStyle(fontSize: 42))),
                ),
                const SizedBox(height: 20),
                const Text('Account', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: _borderColor)),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                    color: _orange.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: _borderColor, width: 2),
                  ),
                  child: const Text('Coming Soon! 🚧', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: _borderColor)),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildMiniTag('Settings ⚙️', _teal),
                    const SizedBox(width: 8),
                    _buildMiniTag('Profile 📋', _pink),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMiniTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _borderColor, width: 1.5),
      ),
      child: Text(text, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: _borderColor)),
    );
  }
}
