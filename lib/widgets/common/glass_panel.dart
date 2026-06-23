import 'dart:ui';
import 'package:flutter/material.dart';

class GlassPanel extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final double blurSigma;
  final double opacity;
  final BorderRadius? borderRadius;
  final Color? baseColor;

  const GlassPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16.0),
    this.blurSigma = 24.0,
    this.opacity = 0.08,
    this.borderRadius,
    this.baseColor,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBorderRadius = borderRadius ?? BorderRadius.circular(16);
    final themeColor = baseColor ?? Theme.of(context).colorScheme.surface;

    return ClipRRect(
      borderRadius: effectiveBorderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: themeColor.withValues(alpha: opacity),
            borderRadius: effectiveBorderRadius,
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
