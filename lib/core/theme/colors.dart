import 'package:flutter/material.dart';

/// Application Color Constants
class AppColors {
  AppColors._();

  // Primary Colors (Financial Trust Green)
  static const Color primary = Color(0xFF2E7D32);
  static const Color primaryDark = Color(0xFF1B5E20);
  static const Color primaryLight = Color(0xFF4CAF50);

  // Secondary Colors (Calm Teal)
  static const Color secondary = Color(0xFF00695C);
  static const Color secondaryDark = Color(0xFF004D40);
  static const Color secondaryLight = Color(0xFF26A69A);

  // Accent Colors (Highlight for Actions & Charts)
  static const Color accent = Color(0xFFFFC107);
  static const Color accentDark = Color(0xFFFFA000);
  static const Color accentLight = Color(0xFFFFD54F);

  // Background Colors (Clean Financial UI)
  static const Color background = Color(0xFFF5F7FA);
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1E1E1E);

  // Text Colors (High Readability for Numbers)
  static const Color textPrimary = Color(0xFF263238);
  static const Color textSecondary = Color(0xFF546E7A);
  static const Color textLight = Color(0xFF90A4AE);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Status Colors (Expense Logic)
  static const Color success = Color(0xFF2ECC71); // Income
  static const Color warning = Color(0xFFF39C12); // Budget Limit
  static const Color error = Color(0xFFE74C3C); // Expense / Over Budget
  static const Color info = Color(0xFF3498DB);

  // Border & Divider Colors
  static const Color border = Color(0xFFE0E0E0);
  static const Color divider = Color(0xFFEEEEEE);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, secondary],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accent, accentDark],
  );

  static const LinearGradient darkGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [backgroundDark, surfaceDark],
  );

  static const LinearGradient successGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF11998E), Color(0xFF38EF7D)],
  );
}
