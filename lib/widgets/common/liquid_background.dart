import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class LiquidBackground extends StatelessWidget {
  final Widget child;

  const LiquidBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    
    return Scaffold(
      backgroundColor: colors.backgroundPrimary,
      body: Stack(
        children: [
          // Top Left Blob
          Positioned(
            top: -150,
            left: -150,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    colors.gradientBlob1.withValues(alpha: 0.35),
                    colors.gradientBlob1.withValues(alpha: 0.0),
                  ],
                  stops: const [0.1, 1.0],
                ),
              ),
            ),
          ),
          // Bottom Right Blob
          Positioned(
            bottom: -100,
            right: -150,
            child: Container(
              width: 500,
              height: 500,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    colors.gradientBlob2.withValues(alpha: 0.3),
                    colors.gradientBlob2.withValues(alpha: 0.0),
                  ],
                  stops: const [0.1, 1.0],
                ),
              ),
            ),
          ),
          // Middle Accent Blob
          Positioned(
            top: MediaQuery.of(context).size.height * 0.35,
            left: MediaQuery.of(context).size.width * 0.1,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    colors.accentPurple.withValues(alpha: 0.15),
                    colors.accentPurple.withValues(alpha: 0.0),
                  ],
                  stops: const [0.1, 1.0],
                ),
              ),
            ),
          ),
          // Actual Content
          SafeArea(child: child),
        ],
      ),
    );
  }
}
