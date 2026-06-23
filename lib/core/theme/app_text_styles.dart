import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles extends ThemeExtension<AppTextStyles> {
  final TextStyle displayLarge;
  final TextStyle displayMedium;
  final TextStyle headingLarge;
  final TextStyle headingMedium;
  final TextStyle headingSmall;
  final TextStyle bodyLarge;
  final TextStyle bodyMedium;
  final TextStyle bodySmall;
  final TextStyle labelLarge;
  final TextStyle labelSmall;
  final TextStyle moneyPositive;
  final TextStyle moneyNegative;
  final TextStyle moneyNeutral;

  const AppTextStyles({
    required this.displayLarge,
    required this.displayMedium,
    required this.headingLarge,
    required this.headingMedium,
    required this.headingSmall,
    required this.bodyLarge,
    required this.bodyMedium,
    required this.bodySmall,
    required this.labelLarge,
    required this.labelSmall,
    required this.moneyPositive,
    required this.moneyNegative,
    required this.moneyNeutral,
  });

  factory AppTextStyles.fromColors(AppColors colors) {
    return AppTextStyles(
      displayLarge: GoogleFonts.outfit(fontSize: 32, fontWeight: FontWeight.w700, color: colors.textPrimary),
      displayMedium: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.w700, color: colors.textPrimary),
      headingLarge: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.w600, color: colors.textPrimary),
      headingMedium: GoogleFonts.outfit(fontSize: 17, fontWeight: FontWeight.w600, color: colors.textPrimary),
      headingSmall: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.w600, color: colors.textPrimary),
      bodyLarge: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.w400, color: colors.textPrimary),
      bodyMedium: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.w400, color: colors.textSecondary),
      bodySmall: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.w400, color: colors.textMuted),
      labelLarge: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.w600, color: colors.textMuted),
      labelSmall: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.w500, color: colors.textMuted),
      moneyPositive: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w700, color: colors.accentTeal),
      moneyNegative: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w700, color: colors.accentRed),
      moneyNeutral: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w700, color: colors.textPrimary),
    );
  }

  @override
  ThemeExtension<AppTextStyles> copyWith() {
    return this; // TextStyles usually update whole via fromColors
  }

  @override
  ThemeExtension<AppTextStyles> lerp(ThemeExtension<AppTextStyles>? other, double t) {
    if (other is! AppTextStyles) return this;
    return AppTextStyles(
      displayLarge: TextStyle.lerp(displayLarge, other.displayLarge, t)!,
      displayMedium: TextStyle.lerp(displayMedium, other.displayMedium, t)!,
      headingLarge: TextStyle.lerp(headingLarge, other.headingLarge, t)!,
      headingMedium: TextStyle.lerp(headingMedium, other.headingMedium, t)!,
      headingSmall: TextStyle.lerp(headingSmall, other.headingSmall, t)!,
      bodyLarge: TextStyle.lerp(bodyLarge, other.bodyLarge, t)!,
      bodyMedium: TextStyle.lerp(bodyMedium, other.bodyMedium, t)!,
      bodySmall: TextStyle.lerp(bodySmall, other.bodySmall, t)!,
      labelLarge: TextStyle.lerp(labelLarge, other.labelLarge, t)!,
      labelSmall: TextStyle.lerp(labelSmall, other.labelSmall, t)!,
      moneyPositive: TextStyle.lerp(moneyPositive, other.moneyPositive, t)!,
      moneyNegative: TextStyle.lerp(moneyNegative, other.moneyNegative, t)!,
      moneyNeutral: TextStyle.lerp(moneyNeutral, other.moneyNeutral, t)!,
    );
  }
}

extension AppTextStylesExtension on BuildContext {
  AppTextStyles get textStyles => Theme.of(this).extension<AppTextStyles>()!;
}