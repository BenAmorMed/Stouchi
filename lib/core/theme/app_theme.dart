import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Colors - Premium Modern Dark Palette
  static const Color backgroundColor = Color(0xFF0F172A); // Slate 900
  static const Color surfaceColor = Color(0xFF1E293B);    // Slate 800
  static const Color primaryColor = Color(0xFF6366F1);    // Indigo 500
  static const Color secondaryColor = Color(0xFF10B981);  // Emerald 500
  static const Color accentColor = Color(0xFF8B5CF6);     // Violet 500
  static const Color textColor = Color(0xFFF8FAFC);       // Slate 50
  static const Color mutedTextColor = Color(0xFF94A3B8);  // Slate 400

  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: primaryColor,
      secondary: secondaryColor,
      surface: surfaceColor,
      error: Color(0xFFEF4444),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: textColor,
    ),
    scaffoldBackgroundColor: backgroundColor,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: GoogleFonts.outfit(
        color: textColor,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: const IconThemeData(color: textColor),
    ),
    textTheme: TextTheme(
      displayLarge: GoogleFonts.outfit(
        color: textColor,
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: GoogleFonts.outfit(
        color: textColor,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      bodyLarge: GoogleFonts.inter(color: textColor, fontSize: 16),
      bodyMedium: GoogleFonts.inter(color: mutedTextColor, fontSize: 14),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surfaceColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      labelStyle: const TextStyle(color: mutedTextColor),
      hintStyle: const TextStyle(color: mutedTextColor),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16),
        elevation: 8,
        shadowColor: primaryColor.withValues(alpha: 0.3),
      ),
    ),
    cardTheme: CardThemeData(
      color: surfaceColor,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      margin: EdgeInsets.zero,
    ),
    dividerTheme: DividerThemeData(
      color: mutedTextColor.withValues(alpha: 0.1),
      thickness: 1,
      space: 1,
    ),
  );

  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      surface: Colors.white,
      error: Color(0xFFEF4444),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Color(0xFF0F172A), // Slate 900
    ),
    scaffoldBackgroundColor: const Color(0xFFF1F5F9), // Slate 100
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: GoogleFonts.outfit(
        color: const Color(0xFF0F172A),
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: const IconThemeData(color: Color(0xFF0F172A)),
    ),
    textTheme: TextTheme(
      displayLarge: GoogleFonts.outfit(
        color: const Color(0xFF0F172A),
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: GoogleFonts.outfit(
        color: const Color(0xFF0F172A),
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      bodyLarge: GoogleFonts.inter(color: const Color(0xFF0F172A), fontSize: 16),
      bodyMedium: GoogleFonts.inter(color: const Color(0xFF64748B), fontSize: 14), // Slate 500
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.1)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      labelStyle: const TextStyle(color: Color(0xFF64748B)),
      hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16),
        elevation: 4,
        shadowColor: primaryColor.withValues(alpha: 0.2),
      ),
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      margin: EdgeInsets.zero,
    ),
    dividerTheme: DividerThemeData(
      color: const Color(0xFF64748B).withValues(alpha: 0.1),
      thickness: 1,
      space: 1,
    ),
  );
}
