import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';

/// Professional Mobile UI styled app bar for the home page.
class HomeAppBar extends StatefulWidget {
  const HomeAppBar({super.key});

  @override
  State<HomeAppBar> createState() => _HomeAppBarState();
}

class _HomeAppBarState extends State<HomeAppBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _wiggleController;
  late final Animation<double> _wiggleAnim;

  // ── Professional UI colors ───────────────────────────────────────────
  static const _primary = Color(0xFF4C53A5);
  static const _textDark = Color(0xFF2D3142);
  static const _accentOrange = Color(0xFFFFB74D);
  static const _accentPink = Color(0xFFFF6B6B);

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
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            offset: const Offset(0, 4),
            blurRadius: 12,
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(20, 50, 20, 16),
      child: Row(
        children: [
          // ── Menu icon in smooth rounded box ──────────────────────────────
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F3F5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.menu_rounded, size: 24, color: _textDark),
          ),
          const SizedBox(width: 14),

          // ── Title ─────────────────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'KelontongKu',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: _textDark,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: _accentOrange.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'belanja seru! ✨',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: _accentOrange,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Favorite Icon ───────────────────────────────────────────
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/favorite'),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _accentPink.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.favorite_border_rounded, size: 22, color: _accentPink),
            ),
          ),
          const SizedBox(width: 12),

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
              badgeStyle: const badges.BadgeStyle(
                badgeColor: _accentPink,
                padding: EdgeInsets.all(6),
                elevation: 0,
              ),
              badgeContent: const Text(
                '9',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 11,
                ),
              ),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InkWell(
                  onTap: () => Navigator.pushNamed(context, '/chat-list'),
                  child: const Icon(Icons.chat_bubble_outline_rounded, size: 22, color: _primary),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
