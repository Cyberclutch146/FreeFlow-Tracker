import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../core/di/providers.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../widgets/common/glass_panel.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  bool _smsGranted = false;
  String _selectedCurrency = '₹';
  AppThemeMode _selectedTheme = AppThemeMode.dark;
  double _incomeTarget = 50000;

  final List<String> _currencies = ['₹', '\$', '€', '£', '¥'];

  void _nextPage() {
    if (_currentPage < 3) {
      _pageController.animateToPage(
        _currentPage + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _finishOnboarding();
    }
  }

  Future<void> _finishOnboarding() async {
    final repo = ref.read(settingsRepositoryProvider);
    var settings = await repo.get();
    
    settings = settings.copyWith(
      onboardingComplete: true,
      smsPermissionGranted: _smsGranted,
      currencySymbol: _selectedCurrency,
      theme: _selectedTheme,
      monthlyIncomeTarget: _incomeTarget,
    );
    
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
                  _buildWelcomeStep(colors, textStyles),
                  _buildSmsStep(colors, textStyles),
                  _buildThemeAndCurrencyStep(colors, textStyles),
                  _buildIncomeStep(colors, textStyles),
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
                      child: Text(_currentPage == 3 ? 'Get Started' : 'Next', 
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

  Widget _buildWelcomeStep(AppColors colors, AppTextStyles textStyles) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [colors.accentPurple, colors.accentTeal],
            ).createShader(bounds),
            child: const Icon(Icons.auto_awesome, size: 80, color: Colors.white),
          ).animate().scale(duration: 500.ms, curve: Curves.easeOutBack),
          const SizedBox(height: 32),
          Text('Welcome to FreelanceFlow', style: textStyles.headingLarge, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          Text(
            'Your personal financial assistant with zero cloud dependencies. '
            'Everything stays secure on your device.',
            style: textStyles.bodyLarge.copyWith(color: colors.textMuted),
            textAlign: TextAlign.center,
          ),
        ],
      ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1),
    );
  }

  Widget _buildSmsStep(AppColors colors, AppTextStyles textStyles) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.sms_rounded, size: 80, color: colors.accentTeal)
              .animate().scale(duration: 500.ms, curve: Curves.easeOutBack),
          const SizedBox(height: 32),
          Text('Auto-Track Expenses', style: textStyles.headingLarge, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          Text(
            'FreelanceFlow can read bank SMS notifications to automatically track and categorize your spending.',
            style: textStyles.bodyLarge.copyWith(color: colors.textMuted),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          GlassPanel(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.shield_rounded, color: colors.accentTeal),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text('100% Private. Data never leaves your device.', 
                        style: textStyles.bodyMedium),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () async {
                    final status = await Permission.sms.request();
                    setState(() {
                      _smsGranted = status.isGranted;
                    });
                  },
                  icon: Icon(_smsGranted ? Icons.check_circle : Icons.security),
                  label: Text(_smsGranted ? 'Permission Granted' : 'Grant SMS Permission'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _smsGranted ? colors.accentTeal : colors.accentPurple,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(50),
                  ),
                ),
              ],
            ),
          ),
        ],
      ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1),
    );
  }

  Widget _buildThemeAndCurrencyStep(AppColors colors, AppTextStyles textStyles) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.palette_rounded, size: 64, color: colors.accentPurple),
          const SizedBox(height: 24),
          Text('Preferences', style: textStyles.headingLarge),
          const SizedBox(height: 32),
          
          Align(alignment: Alignment.centerLeft, child: Text('Primary Currency', style: textStyles.headingSmall)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            children: _currencies.map((c) => ChoiceChip(
              label: Text(c, style: const TextStyle(fontSize: 18)),
              selected: _selectedCurrency == c,
              onSelected: (val) { if (val) setState(() => _selectedCurrency = c); },
              selectedColor: colors.accentPurple.withValues(alpha: 0.3),
            )).toList(),
          ),
          
          const SizedBox(height: 40),
          
          Align(alignment: Alignment.centerLeft, child: Text('App Theme', style: textStyles.headingSmall)),
          const SizedBox(height: 12),
          Column(
            children: AppThemeMode.values.map((theme) => RadioListTile<AppThemeMode>(
              title: Text(theme.name.toUpperCase()),
              subtitle: theme == AppThemeMode.oled 
                ? Text('True black for battery saving', style: TextStyle(color: colors.accentTeal, fontSize: 12))
                : null,
              value: theme,
              groupValue: _selectedTheme,
              activeColor: colors.accentPurple,
              onChanged: (val) { if (val != null) setState(() => _selectedTheme = val); },
            )).toList(),
          ),
        ],
      ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1),
    );
  }

  Widget _buildIncomeStep(AppColors colors, AppTextStyles textStyles) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.track_changes_rounded, size: 80, color: colors.accentAmber)
              .animate().scale(duration: 500.ms, curve: Curves.easeOutBack),
          const SizedBox(height: 32),
          Text('Set Your Goal', style: textStyles.headingLarge, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          Text(
            'What is your monthly income target as a freelancer?',
            style: textStyles.bodyLarge.copyWith(color: colors.textMuted),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          Text('$_selectedCurrency${_incomeTarget.toInt().toString()}', 
            style: textStyles.headingLarge.copyWith(fontSize: 48, color: colors.accentAmber)),
          Slider(
            value: _incomeTarget,
            min: 5000,
            max: 500000,
            divisions: 495,
            activeColor: colors.accentAmber,
            onChanged: (val) => setState(() => _incomeTarget = val),
          ),
        ],
      ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1),
    );
  }
}
