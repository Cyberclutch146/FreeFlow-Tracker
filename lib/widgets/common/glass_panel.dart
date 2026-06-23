import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class GlassPanel extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final BorderRadius? borderRadius;
  final Color? baseColor;

  const GlassPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16.0),
    this.borderRadius,
    this.baseColor,
    // Kept for backwards compatibility but unused
    double blurSigma = 24.0,
    double opacity = 0.08,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final effectiveBorderRadius = borderRadius ?? BorderRadius.circular(16);
    final themeColor = baseColor ?? colors.backgroundSurface;

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: themeColor,
        borderRadius: effectiveBorderRadius,
        // No border for the flat/clean look
      ),
      child: child,
    );
  }
}
