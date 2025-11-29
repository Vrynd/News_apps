import 'package:flutter/material.dart';
import 'package:news_app/utils/themes/font_app.dart';

class ThemeApps {
  static TextTheme get _textTheme {
    return TextTheme(
      displayLarge: FontApps.displayLarge,
      displayMedium: FontApps.displayMedium,
      displaySmall: FontApps.displaySmall,
      headlineLarge: FontApps.headlineLarge,
      headlineMedium: FontApps.headlineMedium,
      headlineSmall: FontApps.headlineSmall,
      titleLarge: FontApps.titleLarge,
      titleMedium: FontApps.titleMedium,
      titleSmall: FontApps.titleSmall,
      bodyLarge: FontApps.bodyLarge,
      bodyMedium: FontApps.bodyMedium,
      bodySmall: FontApps.bodySmall,
      labelLarge: FontApps.labelLarge,
      labelMedium: FontApps.labelMedium,
      labelSmall: FontApps.labelSmall,
    );
  }

  static ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF1c6585),
      brightness: Brightness.light,
    ),
    textTheme: _textTheme,
    useMaterial3: true,
  );

  static ThemeData darkTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF1c6585),
      brightness: Brightness.dark,
    ),
    textTheme: _textTheme,
    useMaterial3: true,
  );
}
