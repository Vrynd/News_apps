import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FontApps {
  // Gunakan hanya satu font: Sora
  static final TextStyle _baseStyle = GoogleFonts.roboto();

  /// displayLarge
  static TextStyle displayLarge = _baseStyle.copyWith(
    fontSize: 57,
    fontWeight: FontWeight.w700,
    height: 1.11,
    letterSpacing: -1.5,
  );

  /// displayMedium
  static TextStyle displayMedium = _baseStyle.copyWith(
    fontSize: 45,
    fontWeight: FontWeight.w600,
    height: 1.17,
    letterSpacing: -0.5,
  );

  /// displaySmall
  static TextStyle displaySmall = _baseStyle.copyWith(
    fontSize: 36,
    fontWeight: FontWeight.w500,
    height: 1.25,
    letterSpacing: -0.25,
  );

  /// headlineLarge
  static TextStyle headlineLarge = _baseStyle.copyWith(
    fontSize: 32,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  /// headlineMedium
  static TextStyle headlineMedium = _baseStyle.copyWith(
    fontSize: 28,
    fontWeight: FontWeight.w500,
    height: 1.25,
  );

  /// headlineSmall
  static TextStyle headlineSmall = _baseStyle.copyWith(
    fontSize: 24,
    fontWeight: FontWeight.w400,
    height: 1.2,
  );

  /// titleLarge
  static TextStyle titleLarge = _baseStyle.copyWith(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    height: 1.25,
  );

  /// titleMedium
  static TextStyle titleMedium = _baseStyle.copyWith(
    fontSize: 19.5,
    fontWeight: FontWeight.w500,
    height: 1.3,
    letterSpacing: 0.15,
  );

  /// titleSmall
  static TextStyle titleSmall = _baseStyle.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.3,
    letterSpacing: 0.1,
  );

  /// bodyLarge
  static TextStyle bodyLarge = _baseStyle.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0.3,
  );

  /// bodyMedium
  static TextStyle bodyMedium = _baseStyle.copyWith(
    fontSize: 15.2,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0.25,
  );

  /// bodySmall
  static TextStyle bodySmall = _baseStyle.copyWith(
    fontSize: 12.5,
    fontWeight: FontWeight.w400,
    height: 1.4,
    letterSpacing: 0.4,
  );

  /// labelLarge
  static TextStyle labelLarge = _baseStyle.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.4,
    letterSpacing: 1.25,
  );

  /// labelMedium
  static TextStyle labelMedium = _baseStyle.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.3,
    letterSpacing: 1.25,
  );

  static TextStyle labelSmall = _baseStyle.copyWith(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    height: 1.2,
    letterSpacing: 1.5,
  );
}
