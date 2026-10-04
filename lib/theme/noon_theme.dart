import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NoonTheme {
  // Noon Signature Branding Colors
  static const Color yellowPrimary = Color(0xFFFFE600); // Official Noon Vibrant Yellow
  static const Color yellowLight = Color(0xFFFFF9C4);
  static const Color noonBlack = Color(0xFF1C1C1E);
  static const Color noonDarkHeader = Color(0xFF242426);
  static const Color noonExpressBadgeBg = Color(0xFFFFE600);
  static const Color noonExpressBadgeText = Color(0xFF1C1C1E);
  
  // Tag & Status Colors
  static const Color saleRed = Color(0xFFE52E2E);
  static const Color successGreen = Color(0xFF008A00);
  static const Color starAmber = Color(0xFFFFB400);
  static const Color dealOrange = Color(0xFFFF5722);
  static const Color tabbyGreen = Color(0xFF2DD4BF);
  static const Color tamaraPink = Color(0xFFFF69B4);

  // Surface Colors
  static const Color lightBackground = Color(0xFFF4F4F7);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0xFFE2E2E8);

  static const Color darkBackground = Color(0xFF121214);
  static const Color darkCard = Color(0xFF1E1E22);
  static const Color darkBorder = Color(0xFF2C2C32);

  static ThemeData lightTheme(String currentLang) {
    TextTheme baseTextTheme = currentLang == 'ar'
        ? GoogleFonts.cairoTextTheme(ThemeData.light().textTheme)
        : GoogleFonts.interTextTheme(ThemeData.light().textTheme);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: yellowPrimary,
      scaffoldBackgroundColor: lightBackground,
      colorScheme: const ColorScheme.light(
        primary: yellowPrimary,
        secondary: noonBlack,
        surface: lightCard,
        error: saleRed,
        onPrimary: noonBlack,
        onSecondary: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: yellowPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: noonBlack),
        titleTextStyle: TextStyle(
          color: noonBlack,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      cardTheme: CardThemeData(
        color: lightCard,
        elevation: 0.5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: lightBorder, width: 0.8),
        ),
      ),
      textTheme: baseTextTheme.copyWith(
        titleLarge: baseTextTheme.titleLarge?.copyWith(
          color: noonBlack,
          fontWeight: FontWeight.bold,
        ),
        bodyMedium: baseTextTheme.bodyMedium?.copyWith(
          color: noonBlack,
        ),
      ),
    );
  }

  static ThemeData darkTheme(String currentLang) {
    TextTheme baseTextTheme = currentLang == 'ar'
        ? GoogleFonts.cairoTextTheme(ThemeData.dark().textTheme)
        : GoogleFonts.interTextTheme(ThemeData.dark().textTheme);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: yellowPrimary,
      scaffoldBackgroundColor: darkBackground,
      colorScheme: const ColorScheme.dark(
        primary: yellowPrimary,
        secondary: Colors.white,
        surface: darkCard,
        error: saleRed,
        onPrimary: noonBlack,
        onSecondary: noonBlack,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: noonDarkHeader,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      cardTheme: CardThemeData(
        color: darkCard,
        elevation: 0.5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: darkBorder, width: 0.8),
        ),
      ),
      textTheme: baseTextTheme.copyWith(
        titleLarge: baseTextTheme.titleLarge?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        bodyMedium: baseTextTheme.bodyMedium?.copyWith(
          color: Colors.white70,
        ),
      ),
    );
  }
}
