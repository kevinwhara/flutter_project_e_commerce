import 'package:flutter/material.dart';
import 'dart:async';

import '../data/dummy_data.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../widgets/categories_widget.dart';
import '../widgets/home_app_bar.dart';
import '../widgets/items_widget.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/promo_banner_widget.dart';
import 'account_page.dart';
import 'cart_page.dart';

// ══════════════════════════════════════════════════════════════════════
//  PROFESSIONAL UI COLORS
// ══════════════════════════════════════════════════════════════════════
const _bgColor = Color(0xFFF8F9FA);
const _primary = Color(0xFF4C53A5);
const _textDark = Color(0xFF2D3142);
const _textLight = Color(0xFF9094A6);
const _accentPink = Color(0xFFFF6B6B);
const _accentTeal = Color(0xFF4ECDC4);

// ══════════════════════════════════════════════════════════════════════
//  HOME PAGE CONTENT (tab 0)
// ══════════════════════════════════════════════════════════════════════

class HomePageContent extends StatefulWidget {
  const HomePageContent({super.key});

  @override
  State<HomePageContent> createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent>
    with SingleTickerProviderStateMixin {
  List<Product> _filteredProducts = dummyProducts;
  late final AnimationController _entranceController;

  // Flash Sale countdown
  late Timer _countdownTimer;
  Duration _remaining = const Duration(hours: 5, minutes: 32, seconds: 17);

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..forward();

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_remaining.inSeconds > 0) {
        setState(() => _remaining -= const Duration(seconds: 1));
      }
    });
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _countdownTimer.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _filteredProducts = query.isEmpty
          ? dummyProducts
          : dummyProducts
                .where((p) => p.name.toLowerCase().contains(query.toLowerCase()))
                .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _bgColor,
      child: ListView(
        children: [
          const HomeAppBar(),
          Container(
            padding: const EdgeInsets.only(top: 20),
            color: _bgColor,
            child: Column(
              children: [
                _slideIn(delay: 0.0, end: 0.4, child: SearchBarWidget(onChanged: _onSearchChanged)),
                const SizedBox(height: 20),

                _slideIn(delay: 0.05, end: 0.45, child: const PromoBannerWidget()),
                const SizedBox(height: 24),

                _slideIn(delay: 0.1, end: 0.5, child: _buildSectionHeader('Kategori', Icons.category_rounded, _accentTeal)),
                const SizedBox(height: 8),
                _slideIn(delay: 0.15, end: 0.55, child: const CategoriesWidget()),
                const SizedBox(height: 24),

                // ── Flash Sale Section ──────────────────────────────
                _slideIn(delay: 0.2, end: 0.6, child: _buildFlashSaleHeader()),
                const SizedBox(height: 12),
                _slideIn(delay: 0.25, end: 0.65, child: _buildFlashSaleList()),
                const SizedBox(height: 24),

                _slideIn(delay: 0.3, end: 0.7, child: _buildSectionHeader('Populer', Icons.local_fire_department_rounded, _accentPink)),
                const SizedBox(height: 12),
                _slideIn(delay: 0.35, end: 0.8, child: ItemsWidget(products: _filteredProducts)),

                // Extra padding for floating nav
                const SizedBox(height: 80),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Flash Sale Header with Countdown ──────────────────────────────
  Widget _buildFlashSaleHeader() {
    final h = _remaining.inHours.toString().padLeft(2, '0');
    final m = (_remaining.inMinutes % 60).toString().padLeft(2, '0');
    final s = (_remaining.inSeconds % 60).toString().padLeft(2, '0');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)]),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.flash_on_rounded, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          const Text('Flash Sale', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: _textDark)),
          const SizedBox(width: 12),
          // Countdown boxes
          _buildTimeBox(h),
          const Text(' : ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: _accentPink)),
          _buildTimeBox(m),
          const Text(' : ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: _accentPink)),
          _buildTimeBox(s),
          const Spacer(),
          Text('Lihat →', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: _primary.withValues(alpha: 0.8))),
        ],
      ),
    );
  }

  Widget _buildTimeBox(String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _accentPink,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Colors.white)),
    );
  }

  // ── Flash Sale horizontal list ────────────────────────────────────
  Widget _buildFlashSaleList() {
    final flashProducts = dummyProducts.where((p) => p.discountPercent > 0).toList();

    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: flashProducts.length,
        itemBuilder: (context, index) {
          final p = flashProducts[index];
          return GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/product-detail', arguments: p),
            child: Container(
              width: 140,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 12, offset: const Offset(0, 4))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                      child: SizedBox(
                        width: double.infinity,
                        child: Image.asset(p.imageUrl, fit: BoxFit.cover,
                          errorBuilder: (c, e, s) => Container(color: const Color(0xFFF1F3F5), child: const Center(child: Icon(Icons.image, color: _textLight))),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(p.name, maxLines: 1, overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: _textDark)),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text('\$${p.price.toStringAsFixed(0)}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: _primary)),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(color: _accentPink.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
                              child: Text('-${p.discountPercent}%', style: const TextStyle(fontSize: 10, color: _accentPink, fontWeight: FontWeight.w700)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, Color accentColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: accentColor, size: 20),
          ),
          const SizedBox(width: 12),
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: _textDark)),
          const Spacer(),
          Text('Lihat semua', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: _primary.withValues(alpha: 0.8))),
          Icon(Icons.chevron_right_rounded, color: _primary.withValues(alpha: 0.8), size: 18),
        ],
      ),
    );
  }

  Widget _slideIn({required double delay, required double end, required Widget child}) {
    final curved = CurvedAnimation(parent: _entranceController, curve: Interval(delay, end, curve: Curves.easeOutBack));
    return AnimatedBuilder(
      animation: curved,
      builder: (_, _) {
        return Opacity(
          opacity: curved.value.clamp(0.0, 1.0),
          child: Transform.translate(offset: Offset(0, 25 * (1 - curved.value)), child: child),
        );
      },
    );
  }
}

// ══════════════════════════════════════════════════════════════════════
//  HOMEPAGE SHELL (with floating pill bottom nav)
// ══════════════════════════════════════════════════════════════════════

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> with TickerProviderStateMixin {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNavTap(int index) {
    setState(() => _currentIndex = index);
    _pageController.jumpToPage(index);
  }

  static const _navData = [
    _NavItem(Icons.home_rounded, 'Home'),
    _NavItem(Icons.shopping_cart_rounded, 'Cart'),
    _NavItem(Icons.person_rounded, 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: Stack(
        children: [
          // Page content
          PageView(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _currentIndex = index),
            children: const [HomePageContent(), CartPage(), AccountPage()],
          ),

          // Floating pill bottom nav
          Positioned(
            bottom: 24,
            left: 24,
            right: 24,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.08), offset: const Offset(0, 8), blurRadius: 32),
                  BoxShadow(color: _primary.withValues(alpha: 0.05), offset: const Offset(0, 4), blurRadius: 16),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  for (var i = 0; i < _navData.length; i++)
                    _buildNavItem(i, _navData[i]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, _NavItem data) {
    final isActive = _currentIndex == index;

    return GestureDetector(
      onTap: () => _onNavTap(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.symmetric(horizontal: isActive ? 20 : 16, vertical: 10),
        decoration: BoxDecoration(
          gradient: isActive
              ? const LinearGradient(colors: [Color(0xFF6B73FF), Color(0xFF4C53A5)])
              : null,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Cart badge
            if (index == 1)
              ListenableBuilder(
                listenable: cartProvider,
                builder: (context, _) {
                  final count = cartProvider.totalItems;
                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Icon(data.icon, size: 22, color: isActive ? Colors.white : _textLight),
                      if (count > 0)
                        Positioned(
                          right: -8, top: -6,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(color: _accentPink, shape: BoxShape.circle),
                            child: Text('$count', style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w800)),
                          ),
                        ),
                    ],
                  );
                },
              )
            else
              Icon(data.icon, size: 22, color: isActive ? Colors.white : _textLight),

            if (isActive) ...[
              const SizedBox(width: 8),
              Text(data.label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white)),
            ],
          ],
        ),
      ),
    );
  }
}

class _NavItem {
  const _NavItem(this.icon, this.label);
  final IconData icon;
  final String label;
}
