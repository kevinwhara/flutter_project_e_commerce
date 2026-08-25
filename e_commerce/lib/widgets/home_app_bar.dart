import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';

/// Neo Brutalism styled app bar for the home page.
class HomeAppBar extends StatefulWidget {
  const HomeAppBar({super.key});

  @override
  State<HomeAppBar> createState() => _HomeAppBarState();
}

class _HomeAppBarState extends State<HomeAppBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _wiggleController;
  late final Animation<double> _wiggleAnim;

  // ── Neo Brutalism colors ───────────────────────────────────────────
  static const _borderColor = Color(0xFF1A1A2E);
  static const _pink = Color(0xFFFF6B6B);
  static const _teal = Color(0xFF4ECDC4);
  static const _orange = Color(0xFFFFB74D);

  @override
  void initState() {
    super.initState();
    _wiggleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);
    _wiggleAnim = Tween<double>(begin: -0.05, end: 0.05).animate(
      CurvedAnimation(parent: _wiggleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _wiggleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: _borderColor, width: 3.5),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 50, 20, 16),
      child: Row(
        children: [
          // ── Menu icon in bordered box ──────────────────────────────
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _teal.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: _borderColor, width: 2.5),
              boxShadow: const [
                BoxShadow(
                  color: _borderColor,
                  offset: Offset(3, 3),
                  blurRadius: 0,
                ),
              ],
            ),
            child: const Icon(Icons.menu_rounded, size: 24, color: _borderColor),
          ),
          const SizedBox(width: 14),

          // ── Title ─────────────────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'KelontongKu 🛒',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: _borderColor,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: _orange.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: _borderColor, width: 1.5),
                  ),
                  child: const Text(
                    'belanja seru! ✨',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: _borderColor,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Message badge with wiggle animation ───────────────────
          AnimatedBuilder(
            animation: _wiggleAnim,
            builder: (_, child) {
              return Transform.rotate(
                angle: _wiggleAnim.value,
                child: child,
              );
            },
            child: badges.Badge(
              badgeStyle: badges.BadgeStyle(
                badgeColor: _pink,
                padding: const EdgeInsets.all(6),
                borderSide: const BorderSide(color: _borderColor, width: 2),
              ),
              badgeContent: const Text(
                '9',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 11,
                ),
              ),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _pink.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: _borderColor, width: 2.5),
                  boxShadow: const [
                    BoxShadow(
                      color: _borderColor,
                      offset: Offset(3, 3),
                      blurRadius: 0,
                    ),
                  ],
                ),
                child: InkWell(
                  onTap: () => Navigator.pushNamed(context, '/chat-list'),
                  child:
                      const Icon(Icons.chat_rounded, size: 22, color: _borderColor),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
