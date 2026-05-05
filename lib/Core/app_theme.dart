import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  static const Color _primary = Color(0xFF6C63FF);
  static const Color _primaryDark = Color(0xFF4B44D6);
  static const Color _surface = Color(0xFF1A1A2E);
  static const Color _surfaceVariant = Color(0xFF16213E);
  static const Color _card = Color(0xFF0F3460);
  static const Color _onPrimary = Colors.white;
  static const Color _onSurface = Color(0xFFE0E0E0);
  static const Color _onSurfaceMuted = Color(0xFF9E9E9E);
  static const Color _shimmerBase = Color(0xFF1E2A45);
  static const Color _shimmerHighlight = Color(0xFF2A3A60);

  static Color get shimmerBase => _shimmerBase;
  static Color get shimmerHighlight => _shimmerHighlight;

  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: _primary,
        onPrimary: _onPrimary,
        surface: _surface,
        onSurface: _onSurface,
        surfaceContainerHighest: _surfaceVariant,
        secondary: _card,
      ),
      scaffoldBackgroundColor: _surface,
      cardColor: _card,
      textTheme: GoogleFonts.outfitTextTheme(
        ThemeData.dark().textTheme.copyWith(
              titleLarge: const TextStyle(
                color: _onSurface,
                fontWeight: FontWeight.w700,
                fontSize: 22,
              ),
              titleMedium: const TextStyle(
                color: _onSurface,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
              bodyMedium: const TextStyle(color: _onSurface, fontSize: 14),
              bodySmall: const TextStyle(color: _onSurfaceMuted, fontSize: 12),
            ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: _surfaceVariant,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.outfit(
          color: _onSurface,
          fontSize: 22,
          fontWeight: FontWeight.w700,
        ),
        iconTheme: const IconThemeData(color: _onSurface),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _surfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        hintStyle: const TextStyle(color: _onSurfaceMuted),
      ),
    );
  }
}
