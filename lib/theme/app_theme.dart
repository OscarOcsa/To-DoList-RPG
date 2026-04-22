import 'package:flutter/material.dart';

// ─────────────────────────────────────────
//  Tutti i colori dell'app in un unico posto
// ─────────────────────────────────────────
class AppColors {
  // Sfondi
  static const background    = Color(0xFF080812);
  static const surface       = Color(0xFF12122A);
  static const surfaceLight  = Color(0xFF1C1C3A);

  // Brand
  static const primary       = Color(0xFF7C3AED); // viola RPG
  static const primaryGlow   = Color(0xFF9B59B6);

  // Ricompense
  static const gold          = Color(0xFFFFD700);
  static const gem           = Color(0xFF00E5FF);
  static const xpGreen       = Color(0xFF00E676);

  // Testo
  static const textPrimary   = Color(0xFFEEEEFF);
  static const textSecondary = Color(0xFF7878AA);

  // Difficoltà
  static const easy          = Color(0xFF00E676); // verde
  static const normal        = Color(0xFF2979FF); // blu
  static const hard          = Color(0xFFFF9100); // arancione
  static const epic          = Color(0xFFFF1744); // rosso

  // Categorie
  static const catStudy      = Color(0xFF3D5AFE);
  static const catSport      = Color(0xFFFF5252);
  static const catWork       = Color(0xFF7C3AED);
  static const catSocial     = Color(0xFF00BCD4);
  static const catHealth     = Color(0xFF00E676);
}

// ─────────────────────────────────────────
//  Tema globale
// ─────────────────────────────────────────
class AppTheme {
  static ThemeData get dark {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: 'monospace', // stile terminale / retro-RPG

      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.gold,
        surface: AppColors.surface,
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.gold),
        titleTextStyle: TextStyle(
          color: AppColors.gold,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          letterSpacing: 2.5,
          fontFamily: 'monospace',
        ),
      ),

      cardTheme: const CardThemeData(
        color: AppColors.surface,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(14)),
        ),
      ),

      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.background,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        hintStyle: const TextStyle(color: AppColors.textSecondary),
        labelStyle: const TextStyle(color: AppColors.textSecondary),
      ),

      tabBarTheme: const TabBarThemeData(
        indicatorColor: AppColors.primary,
        labelColor: AppColors.gold,
        unselectedLabelColor: AppColors.textSecondary,
        labelStyle: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1),
      ),
    );
  }
}