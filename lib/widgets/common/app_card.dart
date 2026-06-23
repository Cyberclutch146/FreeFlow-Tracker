import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final Color? glowColor;

  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16.0),
    this.glowColor,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: colors.backgroundSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.borderSubtle, width: 1),
        boxShadow: glowColor != null
            ? [
                BoxShadow(
                  color: glowColor!.withValues(alpha: 0.15),
                  blurRadius: 24,
                  offset: const Offset(0, 4),
                )
              ]
            : null,
      ),
      child: child,
    );
  }
}