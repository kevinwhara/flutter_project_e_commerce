/// Validator dipakai bersama LoginPage dan RegisterPage supaya aturan email
/// tidak ditulis dua kali dan tidak bisa menyimpang antar halaman.
class Validators {
  const Validators._();

  /// Bukan regex RFC-lengkap (itu overkill), tapi menolak kasus jelas rusak:
  /// tanpa `@`, tanpa domain, tanpa TLD, TLD 1 huruf, dan spasi di dalam email.
  static final RegExp _emailPattern = RegExp(
    r"^[A-Za-z0-9._%+-]+@[A-Za-z0-9-]+(\.[A-Za-z0-9-]+)*\.[A-Za-z]{2,}$",
  );

  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email tidak boleh kosong';
    }
    if (!_emailPattern.hasMatch(value)) {
      return 'Format email tidak valid';
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password tidak boleh kosong';
    }
    if (value.length < 6) {
      return 'Password minimal 6 karakter';
    }
    return null;
  }

  static String? name(String? value) {
    final input = value?.trim() ?? '';
    if (input.isEmpty) {
      return 'Nama tidak boleh kosong';
    }
    if (input.length < 3) {
      return 'Nama minimal 3 karakter';
    }
    return null;
  }

  static String? confirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Konfirmasi password tidak boleh kosong';
    }
    if (value != password) {
      return 'Password tidak sama';
    }
    return null;
  }
}
