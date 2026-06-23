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
  
  final Color gradientBlob1;
  final Color gradientBlob2;
  
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
    required this.gradientBlob1,
    required this.gradientBlob2,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.textDisabled,
  });

  static const midnightAmethyst = ThemeConfig(
    name: 'Midnight Amethyst',
    backgroundBase: Color(0xFF08081A),
    surfaceColor: Color(0xFF13131A),
    elevatedSurfaceColor: Color(0xFF1A1A24),
    borderSubtle: Color(0xFF1E1E2E),
    borderMid: Color(0xFF2A2A3A),
    accentPrimary: Color(0xFF6C63FF),
    accentSecondary: Color(0xFF00D4AA),
    accentAmber: Color(0xFFFFB830),
    accentRed: Color(0xFFFF6B6B),
    gradientBlob1: Color(0xFF4A148C),
    gradientBlob2: Color(0xFF004D40),
    textPrimary: Color(0xFFF0F0FF),
    textSecondary: Color(0xFFAAAAAC),
    textMuted: Color(0xFF6B6B8A),
    textDisabled: Color(0xFF3A3A4A),
  );

  static const deepOcean = ThemeConfig(
    name: 'Deep Ocean',
    backgroundBase: Color(0xFF04101A),
    surfaceColor: Color(0xFF0A1824),
    elevatedSurfaceColor: Color(0xFF102030),
    borderSubtle: Color(0xFF162A40),
    borderMid: Color(0xFF203A55),
    accentPrimary: Color(0xFF00B4D8),
    accentSecondary: Color(0xFF90E0EF),
    accentAmber: Color(0xFFFFB830),
    accentRed: Color(0xFFFF6B6B),
    gradientBlob1: Color(0xFF0077B6),
    gradientBlob2: Color(0xFF03045E),
    textPrimary: Color(0xFFF0F8FF),
    textSecondary: Color(0xFFA0B4CC),
    textMuted: Color(0xFF6B8AAB),
    textDisabled: Color(0xFF3A4A5A),
  );

  static const obsidianRose = ThemeConfig(
    name: 'Obsidian Rose',
    backgroundBase: Color(0xFF0F0A0A),
    surfaceColor: Color(0xFF1A1010),
    elevatedSurfaceColor: Color(0xFF241515),
    borderSubtle: Color(0xFF2E1A1A),
    borderMid: Color(0xFF3A2020),
    accentPrimary: Color(0xFFFF6B8A),
    accentSecondary: Color(0xFFFFB830),
    accentAmber: Color(0xFFFF9E00),
    accentRed: Color(0xFFFF4D4D),
    gradientBlob1: Color(0xFF7A1B36),
    gradientBlob2: Color(0xFF663300),
    textPrimary: Color(0xFFFFF0F5),
    textSecondary: Color(0xFFCCA0AA),
    textMuted: Color(0xFF8A6B74),
    textDisabled: Color(0xFF4A3A40),
  );

  static const pureOled = ThemeConfig(
    name: 'Pure OLED',
    backgroundBase: Color(0xFF000000),
    surfaceColor: Color(0xFF000000),
    elevatedSurfaceColor: Color(0xFF111111),
    borderSubtle: Color(0xFF222222),
    borderMid: Color(0xFF333333),
    accentPrimary: Color(0xFFFFFFFF),
    accentSecondary: Color(0xFFAAAAAA),
    accentAmber: Color(0xFFFFB830),
    accentRed: Color(0xFFFF6B6B),
    gradientBlob1: Color(0xFF111111),
    gradientBlob2: Color(0xFF050505),
    textPrimary: Color(0xFFFFFFFF),
    textSecondary: Color(0xFFBBBBBB),
    textMuted: Color(0xFF777777),
    textDisabled: Color(0xFF333333),
  );
}
