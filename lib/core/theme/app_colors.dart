import 'package:flutter/material.dart';
import 'theme_config.dart';

class AppColors extends ThemeExtension<AppColors> {
  final Color backgroundPrimary;
  final Color backgroundSurface;
  final Color backgroundElevated;
  final Color borderSubtle;
  final Color borderMid;
  
  final Color accentPurple;
  final Color accentTeal;
  final Color accentAmber;
  final Color accentRed;
  
  final Color gradientBlob1;
  final Color gradientBlob2;
  
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color textDisabled;

  const AppColors({
    required this.backgroundPrimary,
    required this.backgroundSurface,
    required this.backgroundElevated,
    required this.borderSubtle,
    required this.borderMid,
    required this.accentPurple,
    required this.accentTeal,
    required this.accentAmber,
    required this.accentRed,
    required this.gradientBlob1,
    required this.gradientBlob2,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.textDisabled,
  });

  factory AppColors.fromConfig(ThemeConfig config) {
    return AppColors(
      backgroundPrimary: config.backgroundBase,
      backgroundSurface: config.surfaceColor,
      backgroundElevated: config.elevatedSurfaceColor,
      borderSubtle: config.borderSubtle,
      borderMid: config.borderMid,
      accentPurple: config.accentPrimary,
      accentTeal: config.accentSecondary,
      accentAmber: config.accentAmber,
      accentRed: config.accentRed,
      gradientBlob1: config.gradientBlob1,
      gradientBlob2: config.gradientBlob2,
      textPrimary: config.textPrimary,
      textSecondary: config.textSecondary,
      textMuted: config.textMuted,
      textDisabled: config.textDisabled,
    );
  }

  @override
  ThemeExtension<AppColors> copyWith({
    Color? backgroundPrimary,
    Color? backgroundSurface,
    Color? backgroundElevated,
    Color? borderSubtle,
    Color? borderMid,
    Color? accentPurple,
    Color? accentTeal,
    Color? accentAmber,
    Color? accentRed,
    Color? gradientBlob1,
    Color? gradientBlob2,
    Color? textPrimary,
    Color? textSecondary,
    Color? textMuted,
    Color? textDisabled,
  }) {
    return AppColors(
      backgroundPrimary: backgroundPrimary ?? this.backgroundPrimary,
      backgroundSurface: backgroundSurface ?? this.backgroundSurface,
      backgroundElevated: backgroundElevated ?? this.backgroundElevated,
      borderSubtle: borderSubtle ?? this.borderSubtle,
      borderMid: borderMid ?? this.borderMid,
      accentPurple: accentPurple ?? this.accentPurple,
      accentTeal: accentTeal ?? this.accentTeal,
      accentAmber: accentAmber ?? this.accentAmber,
      accentRed: accentRed ?? this.accentRed,
      gradientBlob1: gradientBlob1 ?? this.gradientBlob1,
      gradientBlob2: gradientBlob2 ?? this.gradientBlob2,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textMuted: textMuted ?? this.textMuted,
      textDisabled: textDisabled ?? this.textDisabled,
    );
  }

  @override
  ThemeExtension<AppColors> lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      backgroundPrimary: Color.lerp(backgroundPrimary, other.backgroundPrimary, t)!,
      backgroundSurface: Color.lerp(backgroundSurface, other.backgroundSurface, t)!,
      backgroundElevated: Color.lerp(backgroundElevated, other.backgroundElevated, t)!,
      borderSubtle: Color.lerp(borderSubtle, other.borderSubtle, t)!,
      borderMid: Color.lerp(borderMid, other.borderMid, t)!,
      accentPurple: Color.lerp(accentPurple, other.accentPurple, t)!,
      accentTeal: Color.lerp(accentTeal, other.accentTeal, t)!,
      accentAmber: Color.lerp(accentAmber, other.accentAmber, t)!,
      accentRed: Color.lerp(accentRed, other.accentRed, t)!,
      gradientBlob1: Color.lerp(gradientBlob1, other.gradientBlob1, t)!,
      gradientBlob2: Color.lerp(gradientBlob2, other.gradientBlob2, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      textDisabled: Color.lerp(textDisabled, other.textDisabled, t)!,
    );
  }
}

extension AppColorsExtension on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>()!;
}