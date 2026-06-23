import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

enum AppButtonVariant { primary, secondary, danger }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final AppButtonVariant variant;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.variant = AppButtonVariant.primary,
  });

  @override
  Widget build(BuildContext context) {
    if (variant == AppButtonVariant.secondary) {
      return OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.accentPurple,
          side: const BorderSide(color: AppColors.accentPurple, width: 1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          minimumSize: const Size.fromHeight(52),
          disabledForegroundColor: AppColors.textDisabled,
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.accentPurple),
                ),
              )
            : Text(label),
      );
    }

    final bgColor = variant == AppButtonVariant.danger ? AppColors.accentRed : AppColors.accentPurple;
    
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        foregroundColor: AppColors.textPrimary,
        disabledBackgroundColor: AppColors.textDisabled.withOpacity(0.3),
        disabledForegroundColor: AppColors.textDisabled,
      ),
      child: isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : Text(label),
    );
  }
}