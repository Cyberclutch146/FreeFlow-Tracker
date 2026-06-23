import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_constants.dart';

class BudgetProgressBar extends StatelessWidget {
  final double progress;
  final Color progressColor;
  final double height;

  const BudgetProgressBar({
    super.key,
    required this.progress,
    required this.progressColor,
    this.height = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: colors.backgroundPrimary,
        borderRadius: BorderRadius.circular(height / 2),
      ),
      alignment: Alignment.centerLeft,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOutCubic,
            width: constraints.maxWidth * progress,
            height: height,
            decoration: BoxDecoration(
              color: progressColor,
              borderRadius: BorderRadius.circular(height / 2),
              boxShadow: [
                BoxShadow(
                  color: progressColor.withValues(alpha: 0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
