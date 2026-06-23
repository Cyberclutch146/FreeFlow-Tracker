import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';
import 'theme_config.dart';

class AppTheme {
  static ThemeData fromConfig(ThemeConfig config) {
    final isLight = config.name == 'Light Mode';
    final base = isLight ? ThemeData.light() : ThemeData.dark();
    final appColors = AppColors.fromConfig(config);
    final appTextStyles = AppTextStyles.fromColors(appColors);

    return ThemeData(
      useMaterial3: true,
      brightness: isLight ? Brightness.light : Brightness.dark,
      scaffoldBackgroundColor: Colors.transparent, // LiquidBackground will handle this
      colorScheme: (isLight ? const ColorScheme.light() : const ColorScheme.dark()).copyWith(
        surface: appColors.backgroundSurface,
        primary: appColors.accentPurple,
        secondary: appColors.accentTeal,
        error: appColors.accentRed,
        onSurface: appColors.textPrimary,
      ),
      extensions: [
        appColors,
        appTextStyles,
      ],
      textTheme: GoogleFonts.interTextTheme(base.textTheme).copyWith(
        displayLarge: appTextStyles.displayLarge,
        displayMedium: appTextStyles.displayMedium,
        headlineLarge: appTextStyles.headingLarge,
        headlineMedium: appTextStyles.headingMedium,
        headlineSmall: appTextStyles.headingSmall,
        bodyLarge: appTextStyles.bodyLarge,
        bodyMedium: appTextStyles.bodyMedium,
        bodySmall: appTextStyles.bodySmall,
        labelLarge: appTextStyles.labelLarge,
        labelSmall: appTextStyles.labelSmall,
      ),
      cardTheme: CardThemeData(
        color: appColors.backgroundSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: appColors.borderSubtle, width: 1),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: appColors.backgroundPrimary,
        scrolledUnderElevation: 0,
        elevation: 0,
        titleTextStyle: appTextStyles.headingLarge,
        iconTheme: IconThemeData(color: appColors.textPrimary),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: appColors.backgroundSurface,
        selectedItemColor: appColors.accentPurple,
        unselectedItemColor: appColors.textMuted,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: appColors.backgroundElevated,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: appColors.borderSubtle),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: appColors.borderSubtle),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: appColors.accentPurple),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: appColors.accentPurple,
          foregroundColor: appColors.textPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          minimumSize: const Size.fromHeight(52),
          elevation: 0,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: appColors.accentPurple,
        ),
      ),
      dividerTheme: DividerThemeData(
        color: appColors.borderSubtle,
        thickness: 1,
        space: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: appColors.backgroundSurface,
        contentTextStyle: TextStyle(color: appColors.textPrimary),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}