import 'package:flutter/material.dart';

import '../data/dummy_data.dart';
import '../models/product.dart';
import '../widgets/categories_widget.dart';
import '../widgets/home_app_bar.dart';
import '../widgets/items_widget.dart';
import '../widgets/search_bar_widget.dart';
import 'account_page.dart';
import 'cart_page.dart';

// ══════════════════════════════════════════════════════════════════════
//  NEO BRUTALISM COLORS (shared across home page components)
// ══════════════════════════════════════════════════════════════════════
const _bgColor = Color(0xFFFFF59D);
const _borderColor = Color(0xFF1A1A2E);
const _pink = Color(0xFFFF6B6B);
const _teal = Color(0xFF4ECDC4);
const _orange = Color(0xFFFFB74D);
const _purple = Color(0xFFAB47BC);

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

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..forward();
  }

  @override
  void dispose() {
    _entranceController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _filteredProducts = query.isEmpty
          ? dummyProducts
          : dummyProducts
                .where(
                  (p) => p.name.toLowerCase().contains(query.toLowerCase()),
                )
                .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _bgColor,
      child: ListView(
        children: [
          // ── App bar ────────────────────────────────────────────────
          const HomeAppBar(),

          // ── Main content area ──────────────────────────────────────
          Container(
            padding: const EdgeInsets.only(top: 20),
            decoration: BoxDecoration(
              color: _bgColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(28),
                topRight: Radius.circular(28),
              ),
            ),
            child: Column(
              children: [
                // Search bar
                _slideIn(
                  delay: 0.0,
                  end: 0.4,
                  child: SearchBarWidget(onChanged: _onSearchChanged),
                ),
                const SizedBox(height: 24),

                // Section: Kategori
                _slideIn(
                  delay: 0.1,
                  end: 0.5,
                  child: _buildSectionHeader(
                    'Kategori',
                    Icons.category_rounded,
                    _teal.withValues(alpha: 0.25),
                  ),
                ),
                const SizedBox(height: 12),

                // Categories
                _slideIn(
                  delay: 0.15,
                  end: 0.55,
                  child: const CategoriesWidget(),
                ),
                const SizedBox(height: 24),

                // Section: Populer
                _slideIn(
                  delay: 0.25,
                  end: 0.65,
                  child: _buildSectionHeader(
                    'Populer',
                    Icons.local_fire_department_rounded,
                    _pink.withValues(alpha: 0.2),
                  ),
                ),
                const SizedBox(height: 12),

                // Product grid
                _slideIn(
                  delay: 0.35,
                  end: 0.8,
                  child: ItemsWidget(products: _filteredProducts),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Section header Neo Brutalism banner ────────────────────────────
  Widget _buildSectionHeader(String title, IconData icon, Color bgColor) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderColor, width: 2.5),
        boxShadow: const [
          BoxShadow(
            color: _borderColor,
            offset: Offset(3, 3),
            blurRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, size: 24, color: Colors.white),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: -0.3,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: _borderColor, width: 1.5),
            ),
            child: const Text(
              'Lihat ➜',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: _borderColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Slide-in animation helper ──────────────────────────────────────
  Widget _slideIn({
    required double delay,
    required double end,
    required Widget child,
  }) {
    final curved = CurvedAnimation(
      parent: _entranceController,
      curve: Interval(delay, end, curve: Curves.easeOutBack),
    );
    return AnimatedBuilder(
      animation: curved,
      builder: (_, _) {
        return Opacity(
          opacity: curved.value.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(0, 25 * (1 - curved.value)),
            child: child,
          ),
        );
      },
    );
  }
}

// ══════════════════════════════════════════════════════════════════════
//  HOMEPAGE SHELL (with custom Neo Brutalism bottom nav)
// ══════════════════════════════════════════════════════════════════════

/// CATATAN: nama class "Homepage" (bukan "HomePage") dipertahankan persis
/// sesuai modul asli meski menyalahi konvensi PascalCase Dart standar.
class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> with TickerProviderStateMixin {
  int _currentIndex = 0;
  final PageController _pageController = PageController();
  late final AnimationController _navBounceController;

  @override
  void initState() {
    super.initState();
    _navBounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _navBounceController.dispose();
    super.dispose();
  }

  void _onNavTap(int index) {
    setState(() => _currentIndex = index);
    _pageController.jumpToPage(index);
    _navBounceController.forward(from: 0.0);
  }

  // Nav items data
  static const _navData = [
    _NavItem(Icons.home_rounded, 'Home', _teal),
    _NavItem(Icons.shopping_cart_rounded, 'Cart', _orange),
    _NavItem(Icons.person_rounded, 'Account', _purple),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) => setState(() => _currentIndex = index),
        children: const [HomePageContent(), CartPage(), AccountPage()],
      ),
      bottomNavigationBar: _buildNeoBrutBottomNav(),
    );
  }

  // ── Neo Brutalism Bottom Navigation Bar ────────────────────────────
  Widget _buildNeoBrutBottomNav() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: _borderColor, width: 3.5),
        ),
      ),
      padding: const EdgeInsets.only(top: 8, bottom: 20, left: 16, right: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          for (var i = 0; i < _navData.length; i++)
            _buildNavItem(i, _navData[i]),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, _NavItem data) {
    final isActive = _currentIndex == index;

    return GestureDetector(
      onTap: () => _onNavTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutBack,
        padding: EdgeInsets.symmetric(
          horizontal: isActive ? 16 : 12,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isActive ? data.color : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: isActive
              ? Border.all(color: _borderColor, width: 2.5)
              : Border.all(color: Colors.transparent, width: 2.5),
          boxShadow: isActive
              ? const [
                  BoxShadow(
                    color: _borderColor,
                    offset: Offset(3, 3),
                    blurRadius: 0,
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedScale(
              scale: isActive ? 1.15 : 1.0,
              duration: const Duration(milliseconds: 250),
              child: Icon(
                data.icon,
                size: 26,
                color: isActive ? Colors.white : _borderColor.withValues(alpha: 0.5),
              ),
            ),
            if (isActive) ...[
              const SizedBox(width: 6),
              Text(
                data.label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _NavItem {
  const _NavItem(this.icon, this.label, this.color);
  final IconData icon;
  final String label;
  final Color color;
}
