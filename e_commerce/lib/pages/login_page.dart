import 'package:flutter/material.dart';

import '../utils/validators.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  // ── Animation controllers ──────────────────────────────────────────
  late final AnimationController _bounceController;
  late final AnimationController _floatController;
  late final AnimationController _pulseController;
  late final AnimationController _staggerController;
  late final AnimationController _buttonController;

  // ── Animations ─────────────────────────────────────────────────────
  late final Animation<double> _bounceAnim;
  late final Animation<double> _floatAnim;
  late final Animation<double> _pulseAnim;
  late final Animation<double> _buttonScaleAnim;

  @override
  void initState() {
    super.initState();

    // Card bounce-in from bottom
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _bounceAnim = CurvedAnimation(
      parent: _bounceController,
      curve: Curves.elasticOut,
    );

    // Floating shapes infinite loop
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    _floatAnim = Tween<double>(begin: -12, end: 12).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    // Pulse avatar infinite loop
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Staggered entrance for form fields
    _staggerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );

    // Button press scale
    _buttonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
      lowerBound: 0.0,
      upperBound: 1.0,
    );
    _buttonScaleAnim = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.easeInOut),
    );

    // Kick off entrance animations
    _bounceController.forward();
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) _staggerController.forward();
    });
  }

  @override
  void dispose() {
    _bounceController.dispose();
    _floatController.dispose();
    _pulseController.dispose();
    _staggerController.dispose();
    _buttonController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  // ── Neo-Brutalism constants ────────────────────────────────────────
  static const _kBorder = 3.5;
  static const _kShadow = 4.5;
  static const _kRadius = 12.0;

  static const _bgColor = Color(0xFFFFF59D); // bright yellow
  static const _cardColor = Color(0xFFFFFFFF);
  static const _borderColor = Color(0xFF1A1A2E);
  static const _greenBtn = Color(0xFF4CAF50);
  static const _mintFill = Color(0xFFB2DFDB);
  static const _lavenderFill = Color(0xFFD1C4E9);
  static const _pink = Color(0xFFFF6B6B);
  static const _teal = Color(0xFF4ECDC4);
  static const _orange = Color(0xFFFFB74D);
  static const _purple = Color(0xFFAB47BC);
  static const _blue = Color(0xFF42A5F5);

  // ══════════════════════════════════════════════════════════════════
  //  BUILD
  // ══════════════════════════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: Stack(
        children: [
          // ── Floating background shapes ─────────────────────────────
          ..._buildFloatingShapes(),

          // ── Main content ───────────────────────────────────────────
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: ScaleTransition(
                scale: _bounceAnim,
                child: _buildCard(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Floating shapes ────────────────────────────────────────────────
  List<Widget> _buildFloatingShapes() {
    return [
      // Big circle top-left
      _floatingShape(
        top: -30,
        left: -30,
        size: 120,
        color: _pink.withValues(alpha: 0.7),
        shape: BoxShape.circle,
        offset: 1.0,
      ),
      // Small square top-right
      _floatingShape(
        top: 60,
        right: -20,
        size: 80,
        color: _teal.withValues(alpha: 0.7),
        shape: BoxShape.rectangle,
        borderRadius: 14,
        offset: -0.8,
      ),
      // Medium circle center-right
      _floatingShape(
        top: 300,
        right: -40,
        size: 100,
        color: _orange.withValues(alpha: 0.6),
        shape: BoxShape.circle,
        offset: 0.6,
      ),
      // Small circle bottom-left
      _floatingShape(
        bottom: 120,
        left: -25,
        size: 70,
        color: _purple.withValues(alpha: 0.6),
        shape: BoxShape.circle,
        offset: -1.2,
      ),
      // Tiny square bottom-right
      _floatingShape(
        bottom: 40,
        right: 30,
        size: 55,
        color: _blue.withValues(alpha: 0.55),
        shape: BoxShape.rectangle,
        borderRadius: 10,
        offset: 1.4,
        rotation: 0.6,
      ),
      // Extra small circle mid-left
      _floatingShape(
        top: 180,
        left: 15,
        size: 45,
        color: _greenBtn.withValues(alpha: 0.5),
        shape: BoxShape.circle,
        offset: -0.9,
      ),
    ];
  }

  Widget _floatingShape({
    double? top,
    double? bottom,
    double? left,
    double? right,
    required double size,
    required Color color,
    required BoxShape shape,
    double borderRadius = 0,
    double offset = 1.0,
    double rotation = 0,
  }) {
    return AnimatedBuilder(
      animation: _floatAnim,
      builder: (_, _) {
        return Positioned(
          top: top != null ? top + _floatAnim.value * offset : null,
          bottom: bottom != null ? bottom + _floatAnim.value * offset : null,
          left: left,
          right: right,
          child: Transform.rotate(
            angle: rotation + _floatAnim.value * 0.02,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: color,
                shape: shape,
                borderRadius: shape == BoxShape.rectangle
                    ? BorderRadius.circular(borderRadius)
                    : null,
                border: Border.all(
                  color: _borderColor.withValues(alpha: 0.3),
                  width: 2.5,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ── Main card ──────────────────────────────────────────────────────
  Widget _buildCard() {
    return Container(
      constraints: const BoxConstraints(maxWidth: 420),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(_kRadius),
        border: Border.all(color: _borderColor, width: _kBorder),
        boxShadow: [
          BoxShadow(
            color: _borderColor,
            offset: const Offset(_kShadow, _kShadow),
            blurRadius: 0,
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // ── Sticker decorations ────────────────────────────────────
          const Positioned(
            top: -18,
            right: -14,
            child: Text('⚡', style: TextStyle(fontSize: 32)),
          ),
          const Positioned(
            top: -14,
            left: -16,
            child: Text('🌟', style: TextStyle(fontSize: 28)),
          ),
          const Positioned(
            bottom: -16,
            right: 20,
            child: Text('💫', style: TextStyle(fontSize: 26)),
          ),
          const Positioned(
            bottom: -12,
            left: -10,
            child: Text('🎪', style: TextStyle(fontSize: 24)),
          ),

          // ── Card content ───────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(28, 36, 28, 32),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Avatar emoji pulse
                  _buildPulseAvatar(),
                  const SizedBox(height: 16),

                  // Title
                  _buildTitle(),
                  const SizedBox(height: 8),

                  // Subtitle
                  _buildSubtitle(),
                  const SizedBox(height: 32),

                  // Email field (staggered)
                  _staggeredSlide(
                    delay: 0.0,
                    end: 0.5,
                    child: _buildNeoBrutField(
                      label: 'Email',
                      icon: Icons.email_rounded,
                      iconColor: _teal,
                      fillColor: _mintFill,
                      controller: _emailController,
                      validator: Validators.email,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Password field (staggered)
                  _staggeredSlide(
                    delay: 0.2,
                    end: 0.7,
                    child: _buildNeoBrutField(
                      label: 'Password',
                      icon: Icons.lock_rounded,
                      iconColor: _purple,
                      fillColor: _lavenderFill,
                      controller: _passwordController,
                      validator: Validators.password,
                      isPassword: true,
                      textInputAction: TextInputAction.done,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Login button (staggered)
                  _staggeredSlide(
                    delay: 0.4,
                    end: 0.9,
                    child: _buildNeoBrutButton(),
                  ),
                  const SizedBox(height: 20),

                  // Sign up link (staggered)
                  _staggeredSlide(
                    delay: 0.55,
                    end: 1.0,
                    child: _buildSignUpLink(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Pulse avatar ───────────────────────────────────────────────────
  Widget _buildPulseAvatar() {
    return ScaleTransition(
      scale: _pulseAnim,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: _orange.withValues(alpha: 0.25),
          shape: BoxShape.circle,
          border: Border.all(color: _borderColor, width: 3),
          boxShadow: [
            BoxShadow(
              color: _borderColor.withValues(alpha: 0.8),
              offset: const Offset(3, 3),
              blurRadius: 0,
            ),
          ],
        ),
        child: const Center(
          child: Icon(Icons.shopping_cart_rounded, size: 36, color: _borderColor),
        ),
      ),
    );
  }

  // ── Title & Subtitle ──────────────────────────────────────────────
  Widget _buildTitle() {
    return const Text(
      'Welcome Back! 👋',
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w900,
        color: _borderColor,
        letterSpacing: -0.5,
      ),
    );
  }

  Widget _buildSubtitle() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: _teal.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _borderColor, width: 2),
      ),
      child: const Text(
        'Login to continue shopping ✨',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: _borderColor,
        ),
      ),
    );
  }

  // ── Neo-Brutalism Text Field ───────────────────────────────────────
  Widget _buildNeoBrutField({
    required String label,
    required IconData icon,
    required Color iconColor,
    required Color fillColor,
    required TextEditingController controller,
    required String? Function(String?) validator,
    bool isPassword = false,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
  }) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: _borderColor.withValues(alpha: 0.85),
            offset: const Offset(3, 3),
            blurRadius: 0,
          ),
        ],
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextFormField(
        controller: controller,
        validator: validator,
        obscureText: isPassword && _obscurePassword,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: _borderColor,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            fontWeight: FontWeight.w700,
            color: _borderColor.withValues(alpha: 0.7),
            fontSize: 14,
          ),
          prefixIcon: Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: _borderColor, width: 1.5),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          suffixIcon: isPassword
              ? IconButton(
                  onPressed: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_rounded
                        : Icons.visibility_off_rounded,
                    color: _purple,
                  ),
                )
              : null,
          filled: true,
          fillColor: fillColor,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: _borderColor, width: _kBorder),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: _borderColor, width: _kBorder),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: iconColor, width: _kBorder),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: _pink, width: _kBorder),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: _pink, width: _kBorder),
          ),
          errorStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            color: _pink,
          ),
        ),
      ),
    );
  }

  // ── Neo-Brutalism Button ───────────────────────────────────────────
  Widget _buildNeoBrutButton() {
    return GestureDetector(
      onTapDown: (_) => _buttonController.forward(),
      onTapUp: (_) {
        _buttonController.reverse();
        _handleLogin();
      },
      onTapCancel: () => _buttonController.reverse(),
      child: ScaleTransition(
        scale: _buttonScaleAnim,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: _greenBtn,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _borderColor, width: _kBorder),
            boxShadow: [
              BoxShadow(
                color: _borderColor,
                offset: const Offset(_kShadow, _kShadow),
                blurRadius: 0,
              ),
            ],
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Login',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                ),
              ),
              SizedBox(width: 8),
              Text('🚀', style: TextStyle(fontSize: 20)),
            ],
          ),
        ),
      ),
    );
  }

  // ── Sign-up link ───────────────────────────────────────────────────
  Widget _buildSignUpLink() {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/register'),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: _pink.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: _borderColor, width: 2),
        ),
        child: RichText(
          text: const TextSpan(
            text: "Don't have an account? ",
            style: TextStyle(
              color: _borderColor,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
            children: [
              TextSpan(
                text: 'Sign Up 🎉',
                style: TextStyle(
                  color: _purple,
                  fontWeight: FontWeight.w900,
                  decoration: TextDecoration.underline,
                  decorationThickness: 2.5,
                  decorationColor: _purple,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Staggered slide helper ─────────────────────────────────────────
  Widget _staggeredSlide({
    required double delay,
    required double end,
    required Widget child,
  }) {
    final curved = CurvedAnimation(
      parent: _staggerController,
      curve: Interval(delay, end, curve: Curves.easeOutBack),
    );
    return AnimatedBuilder(
      animation: curved,
      builder: (_, _) {
        return Opacity(
          opacity: curved.value.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(0, 30 * (1 - curved.value)),
            child: child,
          ),
        );
      },
    );
  }
}
