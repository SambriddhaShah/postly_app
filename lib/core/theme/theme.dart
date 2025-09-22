// lib/core/theme/theme.dart
import 'package:flutter/material.dart';
import 'custom_colors.dart';
import 'styles.dart';

class AppTheme {
  static final light = ThemeData(
    brightness: Brightness.light,
    primaryColor: CustomColors.primary,
    scaffoldBackgroundColor: CustomColors.background,
    appBarTheme: const AppBarTheme(
      backgroundColor: CustomColors.primary,
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 18),
      iconTheme: IconThemeData(color: Colors.white),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: CustomColors.primary,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide.none,
      ),
      hintStyle: Styles.body.copyWith(color: Colors.grey[500]),
    ),
    textTheme: TextTheme(
      titleLarge: Styles.title,
      bodyMedium: Styles.body,
      titleMedium: Styles.subtitle,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: CustomColors.primary.withOpacity(0.2),
      labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
  );

  static final dark = ThemeData(
    brightness: Brightness.dark,
    primaryColor: CustomColors.primaryDark,
    scaffoldBackgroundColor: Colors.grey[900],
    appBarTheme: const AppBarTheme(
      backgroundColor: CustomColors.primaryDark,
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 18),
      iconTheme: IconThemeData(color: Colors.white),
    ),
  );
}
