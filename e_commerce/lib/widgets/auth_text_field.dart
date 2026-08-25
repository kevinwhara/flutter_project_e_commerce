import 'package:flutter/material.dart';

/// Field reusable untuk semua form auth (Email, Password, Nama, Confirm).
///
/// Catatan penyimpangan dari daftar struktur file: spec menyebut widget ini
/// "StatelessWidget", tapi juga mensyaratkan toggle show/hide "controllable
/// via state internal" — dua hal itu kontradiktif untuk field password.
/// State toggle wajib hidup DI SINI (bukan didorong ke tiap halaman) supaya
/// LoginPage/RegisterPage tidak perlu boilerplate bool _obscureX lagi, jadi
/// class ini StatefulWidget secara internal.
class AuthTextField extends StatefulWidget {
  const AuthTextField({
    super.key,
    this.fieldKey,
    required this.label,
    required this.icon,
    required this.controller,
    required this.validator,
    this.isPassword = false,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
  });

  /// Dipakai kalau halaman perlu memicu validasi field ini sendiri dari luar
  /// (mis. Confirm Password yang di-recheck tiap Password berubah).
  final GlobalKey<FormFieldState<String>>? fieldKey;

  final String label;
  final IconData icon;
  final TextEditingController controller;
  final String? Function(String?) validator;
  final bool isPassword;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: widget.fieldKey,
      controller: widget.controller,
      validator: widget.validator,
      obscureText: widget.isPassword && _obscure,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        labelText: widget.label,
        prefixIcon: Icon(widget.icon, color: const Color(0xFF4C53A5)),
        suffixIcon: widget.isPassword
            ? IconButton(
                onPressed: () => setState(() => _obscure = !_obscure),
                icon: Icon(
                  _obscure ? Icons.visibility : Icons.visibility_off,
                  color: const Color(0xFF4C53A5),
                ),
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
