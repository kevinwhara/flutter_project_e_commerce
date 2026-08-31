import 'package:flutter/material.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  static const _borderColor = Color(0xFF1A1A2E);
  static const _yellow = Color(0xFFFFF59D);
  static const _pink = Color(0xFFFF6B6B);
  static const _teal = Color(0xFF4ECDC4);
  static const _orange = Color(0xFFFFB74D);

  final List<Map<String, dynamic>> _pages = [
    {
      'color': _yellow,
      'icon': Icons.shopping_bag_outlined,
      'iconBg': _pink,
      'title': 'Belanja Gaya\nNeo Brutalism!',
      'desc': 'Temukan pengalaman belanja unik dengan desain yang anti-mainstream dan berani tampil beda.',
    },
    {
      'color': _pink,
      'icon': Icons.local_fire_department_rounded,
      'iconBg': _orange,
      'title': 'Diskon Gede\nTiap Hari 🔥',
      'desc': 'Dapatkan promo eksklusif dan voucher belanja tanpa henti. Jangan sampai ketinggalan!',
    },
    {
      'color': _teal,
      'icon': Icons.rocket_launch_rounded,
      'iconBg': _yellow,
      'title': 'Siap Mulai\nPetualangan?',
      'desc': 'Daftar sekarang dan nikmati gratis ongkir untuk pembelian pertamamu.',
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentIndex < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _currentIndex = index),
            itemCount: _pages.length,
            itemBuilder: (context, index) {
              final page = _pages[index];
              return Container(
                color: page['color'],
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Floating Icon Shape
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: page['iconBg'],
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: _borderColor, width: 4),
                        boxShadow: const [
                          BoxShadow(color: _borderColor, offset: Offset(8, 8), blurRadius: 0),
                        ],
                      ),
                      child: Icon(page['icon'], size: 64, color: _borderColor),
                    ),
                    const SizedBox(height: 48),
                    // Title
                    Text(
                      page['title'],
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w900,
                        color: _borderColor,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Description
                    Text(
                      page['desc'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: _borderColor,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          
          // Navigation Row
          Positioned(
            bottom: 40,
            left: 24,
            right: 24,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Indicators
                Row(
                  children: List.generate(_pages.length, (index) {
                    final isSelected = _currentIndex == index;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.only(right: 8),
                      height: 12,
                      width: isSelected ? 32 : 12,
                      decoration: BoxDecoration(
                        color: isSelected ? _borderColor : Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: _borderColor, width: 2),
                      ),
                    );
                  }),
                ),
                
                // Next Button
                GestureDetector(
                  onTap: _nextPage,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _borderColor, width: 3),
                      boxShadow: const [
                        BoxShadow(color: _borderColor, offset: Offset(4, 4), blurRadius: 0),
                      ],
                    ),
                    child: Row(
                      children: [
                        Text(
                          _currentIndex == _pages.length - 1 ? 'Mulai' : 'Lanjut',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: _borderColor,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward_rounded, color: _borderColor),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
