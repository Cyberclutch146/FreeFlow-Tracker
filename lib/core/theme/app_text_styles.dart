import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  static const TextStyle displayLarge = TextStyle(fontSize: 32, fontWeight: FontWeight.w700, color: AppColors.textPrimary);
  static const TextStyle displayMedium = TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.textPrimary);
  static const TextStyle headingLarge = TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.textPrimary);
  static const TextStyle headingMedium = TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: AppColors.textPrimary);
  static const TextStyle headingSmall = TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary);
  static const TextStyle bodyLarge = TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: AppColors.textPrimary);
  static const TextStyle bodyMedium = TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: AppColors.textSecondary);
  static const TextStyle bodySmall = TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.textMuted);
  static const TextStyle labelLarge = TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textMuted);
  static const TextStyle labelSmall = TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: AppColors.textMuted);
  static const TextStyle moneyPositive = TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.accentTeal);
  static const TextStyle moneyNegative = TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.accentRed);
  static const TextStyle moneyNeutral = TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary);
}