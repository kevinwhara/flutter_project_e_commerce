import 'package:flutter/material.dart';

import '../utils/validators.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _confirmFieldKey = GlobalKey<FormFieldState<String>>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  late final AnimationController _bounceController;
  late final AnimationController _staggerController;
  late final AnimationController _buttonController;

  late final Animation<double> _bounceAnim;
  late final Animation<double> _buttonScaleAnim;

  // ── Professional UI constants ────────────────────────────────────────
  static const _bgColor = Color(0xFFF8F9FA);
  static const _cardColor = Colors.white;
  static const _textDark = Color(0xFF2D3142);
  static const _textLight = Color(0xFF9094A6);
  static const _primary = Color(0xFF4C53A5);
  static const _accentPink = Color(0xFFFF6B6B);
  static const _inputBg = Color(0xFFF1F3F5);

  static const LinearGradient _primaryGradient = LinearGradient(
    colors: [Color(0xFF6B73FF), Color(0xFF4C53A5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_revalidateConfirm);
    _confirmController.addListener(_revalidateConfirm);

    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _bounceAnim = CurvedAnimation(
      parent: _bounceController,
      curve: Curves.easeOutBack,
    );

    _staggerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _buttonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
      lowerBound: 0.0,
      upperBound: 1.0,
    );
    _buttonScaleAnim = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.easeInOut),
    );

    _bounceController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _staggerController.forward();
    });
  }

  @override
  void dispose() {
    _passwordController.removeListener(_revalidateConfirm);
    _confirmController.removeListener(_revalidateConfirm);
    _bounceController.dispose();
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
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: ScaleTransition(
            scale: _bounceAnim,
            child: _buildCard(),
          ),
        ),
      ),
    );
  }

  Widget _buildCard() {
    return Container(
      constraints: const BoxConstraints(maxWidth: 420),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            offset: const Offset(0, 10),
            blurRadius: 30,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(32, 40, 32, 32),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.person_add_rounded, size: 48, color: _primary),
              const SizedBox(height: 16),
              const Text('Create Account', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: _textDark, letterSpacing: -0.5)),
              const SizedBox(height: 8),
              const Text('Sign up to get started', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: _textLight)),
              const SizedBox(height: 32),
              _staggeredSlide(delay: 0.0, end: 0.35, child: _buildField(label: 'Name', icon: Icons.person_rounded, controller: _nameController, validator: Validators.name, keyboardType: TextInputType.name, textInputAction: TextInputAction.next)),
              const SizedBox(height: 16),
              _staggeredSlide(delay: 0.1, end: 0.45, child: _buildField(label: 'Email', icon: Icons.email_rounded, controller: _emailController, validator: Validators.email, keyboardType: TextInputType.emailAddress, textInputAction: TextInputAction.next)),
              const SizedBox(height: 16),
              _staggeredSlide(delay: 0.2, end: 0.55, child: _buildField(label: 'Password', icon: Icons.lock_rounded, controller: _passwordController, validator: Validators.password, isPassword: true, obscure: _obscurePassword, onToggle: () => setState(() => _obscurePassword = !_obscurePassword), textInputAction: TextInputAction.next)),
              const SizedBox(height: 16),
              _staggeredSlide(delay: 0.3, end: 0.65, child: _buildField(label: 'Confirm Password', icon: Icons.lock_outline_rounded, controller: _confirmController, fieldKey: _confirmFieldKey, validator: (_) => Validators.confirmPassword(_confirmController.text, _passwordController.text), isPassword: true, obscure: _obscureConfirm, onToggle: () => setState(() => _obscureConfirm = !_obscureConfirm), textInputAction: TextInputAction.done)),
              const SizedBox(height: 32),
              _staggeredSlide(delay: 0.45, end: 0.8, child: _buildButton()),
              const SizedBox(height: 24),
              _staggeredSlide(delay: 0.55, end: 0.9, child: _buildLoginLink()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required String label, required IconData icon,
    required TextEditingController controller, required String? Function(String?) validator,
    bool isPassword = false, bool obscure = false, VoidCallback? onToggle,
    TextInputType? keyboardType, TextInputAction? textInputAction,
    GlobalKey<FormFieldState<String>>? fieldKey,
  }) {
    return TextFormField(
      key: fieldKey,
      controller: controller, validator: validator,
      obscureText: isPassword && obscure,
      keyboardType: keyboardType, textInputAction: textInputAction,
      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: _textDark),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontWeight: FontWeight.w500, color: _textLight, fontSize: 14),
        prefixIcon: Icon(icon, color: _textLight, size: 20),
        suffixIcon: isPassword ? IconButton(
          onPressed: onToggle,
          icon: Icon(obscure ? Icons.visibility_rounded : Icons.visibility_off_rounded, color: _textLight, size: 20),
        ) : null,
        filled: true, fillColor: _inputBg,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _primary, width: 1.5)),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _accentPink, width: 1.5)),
        focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _accentPink, width: 1.5)),
        errorStyle: const TextStyle(fontWeight: FontWeight.w500, color: _accentPink),
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
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            gradient: _primaryGradient,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(color: _primary.withOpacity(0.3), offset: const Offset(0, 4), blurRadius: 12),
            ],
          ),
          child: const Center(
            child: Text('Register', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginLink() {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: RichText(
        text: const TextSpan(
          text: 'Already have an account? ',
          style: TextStyle(color: _textLight, fontWeight: FontWeight.w500, fontSize: 14),
          children: [
            TextSpan(text: 'Login', style: TextStyle(color: _primary, fontWeight: FontWeight.w700)),
          ],
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
          child: Transform.translate(offset: Offset(0, 20 * (1 - curved.value)), child: child),
        );
      },
    );
  }
}
