import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class LiquidBackground extends StatelessWidget {
  final Widget child;

  const LiquidBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    
    return Container(
      color: colors.backgroundPrimary,
      child: SafeArea(child: child),
    );
  }
}
