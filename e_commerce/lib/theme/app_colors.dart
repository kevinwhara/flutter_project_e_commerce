import 'package:flutter/material.dart';

/// Professional Mobile UI color palette used throughout the app.
class AppColors {
  const AppColors._();

  static const Color primary = Color(0xFF4C53A5); // Elegant Indigo
  static const Color primaryDark = Color(0xFF383C7E);
  static const Color background = Color(0xFFF8F9FA); // Soft off-white
  static const Color surface = Color(0xFFFFFFFF);
  static const Color fieldFill = Color(0xFFF1F3F5); // Soft gray for fields
  static const Color border = Color(0xFFE8E9F1); // Very light gray
  static const Color textPrimary = Color(0xFF2D3142); // Soft dark gray
  static const Color textSecondary = Color(0xFF9094A6);
  static const Color error = Color(0xFFE53935);
  static const Color onPrimary = Color(0xFFFFFFFF);

  // Gradients for Professional UI
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF6B73FF), Color(0xFF4C53A5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient tealGradient = LinearGradient(
    colors: [Color(0xFF4EE3CD), Color(0xFF35A796)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient orangeGradient = LinearGradient(
    colors: [Color(0xFFFFC770), Color(0xFFFF9800)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient purpleGradient = LinearGradient(
    colors: [Color(0xFFC46FE0), Color(0xFF8E24AA)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
