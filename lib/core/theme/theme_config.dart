import 'package:flutter/material.dart';

class ThemeConfig {
  final String name;
  final Color backgroundBase;
  final Color surfaceColor;
  final Color elevatedSurfaceColor;
  final Color borderSubtle;
  final Color borderMid;
  
  final Color accentPrimary;
  final Color accentSecondary;
  final Color accentAmber;
  final Color accentRed;
  
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color textDisabled;

  const ThemeConfig({
    required this.name,
    required this.backgroundBase,
    required this.surfaceColor,
    required this.elevatedSurfaceColor,
    required this.borderSubtle,
    required this.borderMid,
    required this.accentPrimary,
    required this.accentSecondary,
    required this.accentAmber,
    required this.accentRed,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.textDisabled,
  });

  static const lightMode = ThemeConfig(
    name: 'Light Mode',
    backgroundBase: Color(0xFFF8F9FA),
    surfaceColor: Color(0xFFFFFFFF),
    elevatedSurfaceColor: Color(0xFFF1F3F5),
    borderSubtle: Color(0xFFE9ECEF),
    borderMid: Color(0xFFDEE2E6),
    accentPrimary: Color(0xFF4C6FFF),
    accentSecondary: Color(0xFF20C997),
    accentAmber: Color(0xFFFF9F43),
    accentRed: Color(0xFFFF4D4F),
    textPrimary: Color(0xFF212529),
    textSecondary: Color(0xFF495057),
    textMuted: Color(0xFF868E96),
    textDisabled: Color(0xFFCED4DA),
  );

  static const darkMode = ThemeConfig(
    name: 'Dark Mode',
    backgroundBase: Color(0xFF121212),
    surfaceColor: Color(0xFF1E1E1E),
    elevatedSurfaceColor: Color(0xFF2C2C2C),
    borderSubtle: Color(0xFF333333),
    borderMid: Color(0xFF444444),
    accentPrimary: Color(0xFF6C63FF),
    accentSecondary: Color(0xFF00D4AA),
    accentAmber: Color(0xFFFFB830),
    accentRed: Color(0xFFFF6B6B),
    textPrimary: Color(0xFFF8F9FA),
    textSecondary: Color(0xFFCED4DA),
    textMuted: Color(0xFF868E96),
    textDisabled: Color(0xFF495057),
  );
}
