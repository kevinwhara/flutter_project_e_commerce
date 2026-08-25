import 'package:flutter/material.dart';

import '../utils/validators.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _confirmFieldKey = GlobalKey<FormFieldState<String>>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  late final AnimationController _bounceController;
  late final AnimationController _floatController;
  late final AnimationController _pulseController;
  late final AnimationController _staggerController;
  late final AnimationController _buttonController;

  late final Animation<double> _bounceAnim;
  late final Animation<double> _floatAnim;
  late final Animation<double> _pulseAnim;
  late final Animation<double> _buttonScaleAnim;

  // ── Neo Brutalism constants ────────────────────────────────────────
  static const _kBorder = 3.5;
  static const _kShadow = 4.5;

  static const _bgColor = Color(0xFFB2DFDB); // mint background
  static const _cardColor = Color(0xFFFFFFFF);
  static const _borderColor = Color(0xFF1A1A2E);
  static const _purple = Color(0xFFAB47BC);
  static const _pink = Color(0xFFFF6B6B);
  static const _teal = Color(0xFF4ECDC4);
  static const _orange = Color(0xFFFFB74D);
  static const _lavender = Color(0xFFD1C4E9);
  static const _mintFill = Color(0xFFB2DFDB);
  static const _yellowFill = Color(0xFFFFF59D);
  static const _pinkFill = Color(0xFFFFCDD2);

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_revalidateConfirm);
    _confirmController.addListener(_revalidateConfirm);

    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _bounceAnim = CurvedAnimation(
      parent: _bounceController,
      curve: Curves.elasticOut,
    );

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    _floatAnim = Tween<double>(begin: -12, end: 12).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _staggerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _buttonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
      lowerBound: 0.0,
      upperBound: 1.0,
    );
    _buttonScaleAnim = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.easeInOut),
    );

    _bounceController.forward();
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) _staggerController.forward();
    });
  }

  @override
  void dispose() {
    _passwordController.removeListener(_revalidateConfirm);
    _confirmController.removeListener(_revalidateConfirm);
    _bounceController.dispose();
    _floatController.dispose();
    _pulseController.dispose();
    _staggerController.dispose();
    _buttonController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _revalidateConfirm() {
    if (_confirmController.text.isNotEmpty) {
      _confirmFieldKey.currentState?.validate();
    }
  }

  void _handleRegister() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(content: Text('Registrasi berhasil')));
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: Stack(
        children: [
          ..._buildFloatingShapes(),
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

  List<Widget> _buildFloatingShapes() {
    return [
      _floatingShape(top: -30, right: -20, size: 100, color: _purple.withValues(alpha: 0.6), offset: 1.0),
      _floatingShape(top: 100, left: -30, size: 80, color: _orange.withValues(alpha: 0.6), offset: -0.8),
      _floatingShape(bottom: 150, right: -25, size: 70, color: _pink.withValues(alpha: 0.5), offset: 0.6),
      _floatingShape(bottom: 50, left: 20, size: 55, color: _teal.withValues(alpha: 0.5), offset: -1.2),
    ];
  }

  Widget _floatingShape({
    double? top, double? bottom, double? left, double? right,
    required double size, required Color color, double offset = 1.0,
  }) {
    return AnimatedBuilder(
      animation: _floatAnim,
      builder: (_, _) {
        return Positioned(
          top: top != null ? top + _floatAnim.value * offset : null,
          bottom: bottom != null ? bottom + _floatAnim.value * offset : null,
          left: left, right: right,
          child: Container(
            width: size, height: size,
            decoration: BoxDecoration(
              color: color, shape: BoxShape.circle,
              border: Border.all(color: _borderColor.withValues(alpha: 0.3), width: 2.5),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCard() {
    return Container(
      constraints: const BoxConstraints(maxWidth: 420),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderColor, width: _kBorder),
        boxShadow: [
          BoxShadow(color: _borderColor, offset: const Offset(_kShadow, _kShadow), blurRadius: 0),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          const Positioned(top: -18, right: -14, child: Text('🎉', style: TextStyle(fontSize: 32))),
          const Positioned(top: -14, left: -16, child: Text('✨', style: TextStyle(fontSize: 28))),
          const Positioned(bottom: -16, right: 20, child: Text('🚀', style: TextStyle(fontSize: 26))),
          const Positioned(bottom: -12, left: -10, child: Text('🌈', style: TextStyle(fontSize: 24))),
          Padding(
            padding: const EdgeInsets.fromLTRB(28, 36, 28, 32),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildPulseAvatar(),
                  const SizedBox(height: 16),
                  const Text('Create Account 🎨', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: _borderColor, letterSpacing: -0.5)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: _purple.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: _borderColor, width: 2),
                    ),
                    child: const Text('Sign up to get started ✌️', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _borderColor)),
                  ),
                  const SizedBox(height: 28),
                  _staggeredSlide(delay: 0.0, end: 0.35, child: _buildField(label: 'Nama', icon: Icons.person_rounded, iconColor: _orange, fillColor: _yellowFill, controller: _nameController, validator: Validators.name, keyboardType: TextInputType.name, textInputAction: TextInputAction.next)),
                  const SizedBox(height: 16),
                  _staggeredSlide(delay: 0.1, end: 0.45, child: _buildField(label: 'Email', icon: Icons.email_rounded, iconColor: _teal, fillColor: _mintFill, controller: _emailController, validator: Validators.email, keyboardType: TextInputType.emailAddress, textInputAction: TextInputAction.next)),
                  const SizedBox(height: 16),
                  _staggeredSlide(delay: 0.2, end: 0.55, child: _buildField(label: 'Password', icon: Icons.lock_rounded, iconColor: _purple, fillColor: _lavender, controller: _passwordController, validator: Validators.password, isPassword: true, obscure: _obscurePassword, onToggle: () => setState(() => _obscurePassword = !_obscurePassword), textInputAction: TextInputAction.next)),
                  const SizedBox(height: 16),
                  _staggeredSlide(delay: 0.3, end: 0.65, child: _buildField(label: 'Confirm Password', icon: Icons.lock_outline_rounded, iconColor: _pink, fillColor: _pinkFill, controller: _confirmController, fieldKey: _confirmFieldKey, validator: (_) => Validators.confirmPassword(_confirmController.text, _passwordController.text), isPassword: true, obscure: _obscureConfirm, onToggle: () => setState(() => _obscureConfirm = !_obscureConfirm), textInputAction: TextInputAction.done)),
                  const SizedBox(height: 28),
                  _staggeredSlide(delay: 0.45, end: 0.8, child: _buildButton()),
                  const SizedBox(height: 16),
                  _staggeredSlide(delay: 0.55, end: 0.9, child: _buildLoginLink()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPulseAvatar() {
    return ScaleTransition(
      scale: _pulseAnim,
      child: Container(
        width: 72, height: 72,
        decoration: BoxDecoration(
          color: _purple.withValues(alpha: 0.2), shape: BoxShape.circle,
          border: Border.all(color: _borderColor, width: 3),
          boxShadow: [BoxShadow(color: _borderColor.withValues(alpha: 0.8), offset: const Offset(3, 3), blurRadius: 0)],
        ),
        child: const Center(child: Text('📝', style: TextStyle(fontSize: 34))),
      ),
    );
  }

  Widget _buildField({
    required String label, required IconData icon, required Color iconColor, required Color fillColor,
    required TextEditingController controller, required String? Function(String?) validator,
    bool isPassword = false, bool obscure = false, VoidCallback? onToggle,
    TextInputType? keyboardType, TextInputAction? textInputAction,
    GlobalKey<FormFieldState<String>>? fieldKey,
  }) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [BoxShadow(color: _borderColor.withValues(alpha: 0.85), offset: const Offset(3, 3), blurRadius: 0)],
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextFormField(
        key: fieldKey,
        controller: controller, validator: validator,
        obscureText: isPassword && obscure,
        keyboardType: keyboardType, textInputAction: textInputAction,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _borderColor),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(fontWeight: FontWeight.w700, color: _borderColor.withValues(alpha: 0.7), fontSize: 13),
          prefixIcon: Container(
            margin: const EdgeInsets.all(8), padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(color: iconColor.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(8), border: Border.all(color: _borderColor, width: 1.5)),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          suffixIcon: isPassword ? IconButton(
            onPressed: onToggle,
            icon: Icon(obscure ? Icons.visibility_rounded : Icons.visibility_off_rounded, color: _purple),
          ) : null,
          filled: true, fillColor: fillColor,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: _borderColor, width: _kBorder)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: _borderColor, width: _kBorder)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: iconColor, width: _kBorder)),
          errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: _pink, width: _kBorder)),
          focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: _pink, width: _kBorder)),
          errorStyle: const TextStyle(fontWeight: FontWeight.w700, color: _pink),
        ),
      ),
    );
  }

  Widget _buildButton() {
    return GestureDetector(
      onTapDown: (_) => _buttonController.forward(),
      onTapUp: (_) { _buttonController.reverse(); _handleRegister(); },
      onTapCancel: () => _buttonController.reverse(),
      child: ScaleTransition(
        scale: _buttonScaleAnim,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            color: _purple, borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _borderColor, width: _kBorder),
            boxShadow: [BoxShadow(color: _borderColor, offset: const Offset(_kShadow, _kShadow), blurRadius: 0)],
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Register', style: TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w900, letterSpacing: 1)),
              SizedBox(width: 8),
              Text('🎉', style: TextStyle(fontSize: 19)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginLink() {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: _teal.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: _borderColor, width: 2),
        ),
        child: RichText(
          text: const TextSpan(
            text: 'Already have an account? ',
            style: TextStyle(color: _borderColor, fontWeight: FontWeight.w600, fontSize: 13),
            children: [
              TextSpan(text: 'Login 🔑', style: TextStyle(color: _teal, fontWeight: FontWeight.w900, decoration: TextDecoration.underline, decorationThickness: 2.5, decorationColor: _teal)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _staggeredSlide({required double delay, required double end, required Widget child}) {
    final curved = CurvedAnimation(parent: _staggerController, curve: Interval(delay, end, curve: Curves.easeOutBack));
    return AnimatedBuilder(
      animation: curved,
      builder: (_, _) {
        return Opacity(
          opacity: curved.value.clamp(0.0, 1.0),
          child: Transform.translate(offset: Offset(0, 30 * (1 - curved.value)), child: child),
        );
      },
    );
  }
}
