import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/di/providers.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/common/glass_panel.dart';

class TutorialScreen extends ConsumerStatefulWidget {
  const TutorialScreen({super.key});

  @override
  ConsumerState<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends ConsumerState<TutorialScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _nextPage() {
    if (_currentPage < 3) {
      _pageController.animateToPage(
        _currentPage + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _finishTutorial();
    }
  }

  Future<void> _finishTutorial() async {
    final repo = ref.read(settingsRepositoryProvider);
    var settings = await repo.get();
    
    settings = settings.copyWith(tutorialComplete: true);
    await repo.save(settings);
    
    if (mounted) {
      context.go('/home');
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textStyles = context.textStyles;

    return Scaffold(
      backgroundColor: colors.backgroundPrimary,
      body: SafeArea(
        child: Column(
          children: [
            // Progress dots
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (index) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 8,
                    width: _currentPage == index ? 24 : 8,
                    decoration: BoxDecoration(
                      color: _currentPage == index ? colors.accentPurple : colors.borderSubtle,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
            ),

            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (index) => setState(() => _currentPage = index),
                children: [
                  _buildTutorialStep(
                    colors, textStyles,
                    snippet: _buildSnapshotSnippet(colors, textStyles),
                    title: 'Your Financial Snapshot',
                    description: 'The dashboard gives you a real-time overview of your balance, total income, and monthly expenses. Keep an eye here to know exactly where you stand.',
                  ),
                  _buildTutorialStep(
                    colors, textStyles,
                    snippet: _buildAiSnippet(colors, textStyles),
                    title: 'Meet Your AI Assistant',
                    description: 'Tap the glowing AI banner or head to the AI Hub. Your local AI can summarize data, search for specific transactions, and give you personalized tips entirely offline!',
                  ),
                  _buildTutorialStep(
                    colors, textStyles,
                    snippet: _buildUploadSnippet(colors, textStyles),
                    title: 'Upload Bank Statements',
                    description: 'Go to the Transactions tab to import your bank CSV or PDF statements. We automatically process and categorize everything for you.',
                  ),
                  _buildTutorialStep(
                    colors, textStyles,
                    snippet: _buildGoalsSnippet(colors, textStyles),
                    title: 'Set Goals & Budgets',
                    description: 'Plan your future! Use the Goals tab to set up monthly budget limits by category and track your long-term savings goals.',
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_currentPage > 0)
                    TextButton(
                      onPressed: () {
                        _pageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: Text('Back', style: TextStyle(color: colors.textMuted)),
                    )
                  else
                    const SizedBox(width: 64),
                  
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _nextPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.accentPurple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: Text(_currentPage == 3 ? 'Start Exploring' : 'Next', 
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTutorialStep(AppColors colors, AppTextStyles textStyles, {required Widget snippet, required String title, required String description}) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 140,
            alignment: Alignment.center,
            child: snippet.animate().scale(duration: 500.ms, curve: Curves.easeOutBack),
          ),
          const SizedBox(height: 48),
          Text(title, style: textStyles.headingLarge, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          Text(
            description,
            style: textStyles.bodyLarge.copyWith(color: colors.textMuted, height: 1.5),
            textAlign: TextAlign.center,
          ),
        ],
      ).animate().fadeIn(delay: 150.ms).slideY(begin: 0.1),
    );
  }

  Widget _buildSnapshotSnippet(AppColors colors, AppTextStyles textStyles) {
    return GlassPanel(
      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Total Balance', style: textStyles.bodyMedium),
          const SizedBox(height: 8),
          Text('₹42,500', style: textStyles.headingLarge.copyWith(fontSize: 32)),
        ],
      ),
    );
  }

  Widget _buildAiSnippet(AppColors colors, AppTextStyles textStyles) {
    return GlassPanel(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [colors.accentPurple, colors.accentTeal]),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.auto_awesome, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Ask AI Assistant', style: textStyles.headingMedium),
              Text('Get smart insights', style: textStyles.bodyMedium.copyWith(color: colors.textMuted)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildUploadSnippet(AppColors colors, AppTextStyles textStyles) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: colors.accentTeal.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.accentTeal.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.upload_file_rounded, color: colors.accentTeal, size: 28),
          const SizedBox(width: 16),
          Text('Upload Statement', style: textStyles.headingMedium.copyWith(color: colors.accentTeal)),
        ],
      ),
    );
  }

  Widget _buildGoalsSnippet(AppColors colors, AppTextStyles textStyles) {
    return GlassPanel(
      padding: const EdgeInsets.all(24),
      child: SizedBox(
        width: 240,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('New Laptop', style: textStyles.headingMedium),
                Text('60%', style: textStyles.bodyMedium.copyWith(color: colors.accentAmber)),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: 0.6,
              backgroundColor: colors.borderSubtle,
              valueColor: AlwaysStoppedAnimation<Color>(colors.accentAmber),
              borderRadius: BorderRadius.circular(8),
              minHeight: 12,
            ),
          ],
        ),
      ),
    );
  }
}
