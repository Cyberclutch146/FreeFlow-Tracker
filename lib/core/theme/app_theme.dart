import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  static ThemeData get darkTheme {
    final base = ThemeData.dark();
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.backgroundPrimary,
      colorScheme: const ColorScheme.dark(
        surface: AppColors.backgroundSurface,
        primary: AppColors.accentPurple,
        secondary: AppColors.accentTeal,
        error: AppColors.accentRed,
        onSurface: AppColors.textPrimary,
      ),
      textTheme: GoogleFonts.interTextTheme(base.textTheme).copyWith(
        displayLarge: AppTextStyles.displayLarge,
        displayMedium: AppTextStyles.displayMedium,
        headlineLarge: AppTextStyles.headingLarge,
        headlineMedium: AppTextStyles.headingMedium,
        headlineSmall: AppTextStyles.headingSmall,
        bodyLarge: AppTextStyles.bodyLarge,
        bodyMedium: AppTextStyles.bodyMedium,
        bodySmall: AppTextStyles.bodySmall,
        labelLarge: AppTextStyles.labelLarge,
        labelSmall: AppTextStyles.labelSmall,
      ),
      cardTheme: CardTheme(
        color: AppColors.backgroundSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.borderSubtle, width: 1),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.backgroundPrimary,
        elevation: 0,
        titleTextStyle: AppTextStyles.headingLarge,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.backgroundSurface,
        selectedItemColor: AppColors.accentPurple,
        unselectedItemColor: AppColors.textMuted,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.backgroundElevated,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderSubtle),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderSubtle),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.accentPurple),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accentPurple,
          foregroundColor: AppColors.textPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          minimumSize: const Size.fromHeight(52),
          elevation: 0,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.accentPurple,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.borderSubtle,
        thickness: 1,
        space: 1,
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: AppColors.backgroundSurface,
        contentTextStyle: TextStyle(color: AppColors.textPrimary),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}