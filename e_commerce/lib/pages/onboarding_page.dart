import 'package:flutter/material.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  static const _textDark = Color(0xFF2D3142);
  static const _textLight = Color(0xFF9094A6);
  static const _bgLight = Color(0xFFF8F9FA);
  static const _primary = Color(0xFF4C53A5);
  static const _accentPink = Color(0xFFFF6B6B);
  static const _accentTeal = Color(0xFF4ECDC4);
  static const _accentOrange = Color(0xFFFFB74D);

  late AnimationController _floatController;
  late Animation<double> _floatAnimation;

  final List<Map<String, dynamic>> _pages = [
    {
      'title': 'Jelajahi Ribuan\nProduk Pilihan',
      'desc': 'Temukan berbagai macam produk berkualitas dengan harga terbaik, hanya dalam satu genggaman.',
      'icon': Icons.storefront_rounded,
      'color': _primary,
      'gradient': const [Color(0xFF6B73FF), Color(0xFF4C53A5)],
      'floating_icons': [Icons.fastfood_rounded, Icons.checkroom_rounded, Icons.laptop_chromebook_rounded]
    },
    {
      'title': 'Banyak Promo &\nDiskon Menarik',
      'desc': 'Dapatkan gratis ongkir, cashback, hingga flash sale setiap hari khusus untuk pengguna baru!',
      'icon': Icons.local_offer_rounded,
      'color': _accentPink,
      'gradient': const [Color(0xFFFF8E53), Color(0xFFFF6B6B)],
      'floating_icons': [Icons.percent_rounded, Icons.card_giftcard_rounded, Icons.loyalty_rounded]
    },
    {
      'title': 'Pengiriman Cepat\n& Transaksi Aman',
      'desc': 'Didukung oleh berbagai metode pembayaran dan kurir terpercaya. Belanja jadi lebih tenang.',
      'icon': Icons.verified_user_rounded,
      'color': _accentTeal,
      'gradient': const [Color(0xFF4ECDC4), Color(0xFF20B2AA)],
      'floating_icons': [Icons.local_shipping_rounded, Icons.shield_rounded, Icons.account_balance_wallet_rounded]
    },
  ];

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(begin: -10, end: 10).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentIndex < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutCubic,
      );
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgLight,
      body: Stack(
        children: [
          // Background decorations (subtle circles)
          Positioned(
            top: -100,
            right: -100,
            child: AnimatedBuilder(
              animation: _pageController,
              builder: (context, child) {
                double offset = 0;
                if (_pageController.hasClients) {
                  offset = _pageController.page ?? 0;
                }
                final color = _pages[offset.round()]['color'] as Color;
                return Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color.withOpacity(0.05),
                  ),
                );
              }
            ),
          ),
          
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _currentIndex = index),
            itemCount: _pages.length,
            itemBuilder: (context, index) {
              final page = _pages[index];
              return Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Main Visual Component
                    SizedBox(
                      height: 350,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Central Icon Container
                          AnimatedBuilder(
                            animation: _floatAnimation,
                            builder: (context, child) {
                              return Transform.translate(
                                offset: Offset(0, _floatAnimation.value),
                                child: Container(
                                  width: 200,
                                  height: 200,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      colors: page['gradient'],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: page['color'].withOpacity(0.3),
                                        offset: const Offset(0, 20),
                                        blurRadius: 30,
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    page['icon'],
                                    size: 80,
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            }
                          ),
                          
                          // Orbiting small icons
                          ...List.generate((page['floating_icons'] as List).length, (i) {
                            final icons = page['floating_icons'] as List<IconData>;
                            final angle = (i * (3.14159 * 2 / icons.length));
                            return AnimatedBuilder(
                              animation: _floatController,
                              builder: (context, child) {
                                final radius = 130.0;
                                final yOffset = _floatController.value * 15 * (i % 2 == 0 ? 1 : -1);
                                return Transform.translate(
                                  offset: Offset(
                                    radius * 0.8 * (i == 0 ? 0 : i == 1 ? -1 : 1), 
                                    (radius * 0.8 * (i == 0 ? -1 : 0.5)) + yOffset
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
                                      ],
                                    ),
                                    child: Icon(icons[i], size: 24, color: page['color']),
                                  ),
                                );
                              }
                            );
                          }),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    
                    // Texts
                    Text(
                      page['title'],
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: _textDark,
                        height: 1.3,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      page['desc'],
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: _textDark.withOpacity(0.6),
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            },
          ),
          
          // Bottom Controls
          Positioned(
            bottom: 40,
            left: 32,
            right: 32,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Indicators
                Row(
                  children: List.generate(
                    _pages.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.only(right: 8),
                      height: 8,
                      width: _currentIndex == index ? 24 : 8,
                      decoration: BoxDecoration(
                        color: _currentIndex == index ? _primary : _textLight.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
                
                // Next/Start Button
                GestureDetector(
                  onTap: _nextPage,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: EdgeInsets.symmetric(
                      horizontal: _currentIndex == _pages.length - 1 ? 24 : 20,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: _primary,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: _primary.withOpacity(0.3),
                          offset: const Offset(0, 8),
                          blurRadius: 16,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _currentIndex == _pages.length - 1 ? 'Mulai Sekarang' : 'Lanjut',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                        if (_currentIndex < _pages.length - 1) ...[
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 20),
                        ]
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Skip Button
          Positioned(
            top: 50,
            right: 24,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: _currentIndex == _pages.length - 1 ? 0.0 : 1.0,
              child: TextButton(
                onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                child: const Text(
                  'Lewati',
                  style: TextStyle(
                    color: _textLight,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
