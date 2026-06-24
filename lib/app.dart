import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_text_styles.dart';
import 'core/di/providers.dart';
import 'services/auth_service.dart';
import 'models/transaction.dart';
import 'package:home_widget/home_widget.dart';
import 'dart:ui';
import 'package:flutter_animate/flutter_animate.dart';
import 'widgets/common/glass_panel.dart';

final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

class FreelanceFlowApp extends ConsumerStatefulWidget {
  const FreelanceFlowApp({super.key});

  @override
  ConsumerState<FreelanceFlowApp> createState() => _FreelanceFlowAppState();
}

class _FreelanceFlowAppState extends ConsumerState<FreelanceFlowApp> {
  late final AppLifecycleListener _listener;
  bool _isLocked = true; // Lock initially

  @override
  void initState() {
    super.initState();
    _listener = AppLifecycleListener(
      onStateChange: _onStateChanged,
    );
    _authenticate();

    HomeWidget.widgetClicked.listen((Uri? uri) {
      if (uri?.host == 'quick_add') {
        _handleQuickAdd();
      }
    });
    
    HomeWidget.initiallyLaunchedFromHomeWidget().then((Uri? uri) {
      if (uri?.host == 'quick_add') {
        _handleQuickAdd();
      }
    });
  }

  void _handleQuickAdd() {
    // A simple delay to ensure the app and router are fully mounted
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        ref.read(routerProvider).push('/transactions');
      }
    });
  }

  @override
  void dispose() {
    _listener.dispose();
    super.dispose();
  }

  void _onStateChanged(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.hidden) {
      setState(() {
        _isLocked = true;
      });
    } else if (state == AppLifecycleState.resumed && _isLocked) {
      _authenticate();
    }
  }

  Future<void> _authenticate() async {
    final available = await AuthService.isBiometricAvailable();
    if (!available) {
      setState(() => _isLocked = false); // Skip if no biometrics
      return;
    }
    
    final success = await AuthService.authenticate();
    if (success && mounted) {
      setState(() {
        _isLocked = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);
    final themeConfig = ref.watch(themeConfigProvider);
    ref.watch(autoSmsSyncProvider);
    
    ref.listen<AsyncValue<List<Transaction>>>(recentTransactionsProvider, (prev, next) {
      if (next is AsyncData) {
        final txns = next.value ?? [];
        double balance = 0.0;
        for (var t in txns) {
          if (t.direction == TransactionDirection.credit) {
            balance += t.amount;
          } else {
            balance -= t.amount;
          }
        }
        final settings = ref.read(settingsProvider).valueOrNull;
        final formattedBalance = '${settings?.currencySymbol ?? '₹'} ${CurrencyFormatter.format(balance)}';
        
        HomeWidget.saveWidgetData<String>('current_balance', formattedBalance);
        HomeWidget.updateWidget(name: 'HomeScreenWidgetProvider');
      }
    });
    
    return MaterialApp.router(
      scaffoldMessengerKey: scaffoldMessengerKey,
      title: 'FreelanceFlow',
      theme: AppTheme.fromConfig(themeConfig),
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return Stack(
          children: [
            if (child != null) child,
            if (_isLocked)
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                  child: Container(
                    color: AppColors.fromConfig(themeConfig).backgroundPrimary.withValues(alpha: 0.85),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: GlassPanel(
                          padding: const EdgeInsets.all(32),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: AppColors.fromConfig(themeConfig).accentPurple.withValues(alpha: 0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.lock_rounded, 
                                  size: 64, 
                                  color: AppColors.fromConfig(themeConfig).accentPurple,
                                ).animate(onPlay: (controller) => controller.repeat(reverse: true))
                                 .scaleXY(end: 1.1, duration: 2.seconds, curve: Curves.easeInOut),
                              ),
                              const SizedBox(height: 32),
                              Material(
                                color: Colors.transparent,
                                child: Text(
                                  'App Locked',
                                  style: AppTextStyles.fromColors(AppColors.fromConfig(themeConfig)).headingLarge,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Material(
                                color: Colors.transparent,
                                child: Text(
                                  'Authenticate to access your finances',
                                  style: AppTextStyles.fromColors(AppColors.fromConfig(themeConfig)).bodyMedium.copyWith(
                                    color: AppColors.fromConfig(themeConfig).textMuted,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(height: 40),
                              ElevatedButton.icon(
                                onPressed: _authenticate,
                                icon: const Icon(Icons.fingerprint_rounded, size: 28),
                                label: const Text('Unlock', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.fromConfig(themeConfig).accentPurple,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                  elevation: 8,
                                  shadowColor: AppColors.fromConfig(themeConfig).accentPurple.withValues(alpha: 0.5),
                                ),
                              ).animate().shimmer(duration: 2.seconds, delay: 1.seconds),
                            ],
                          ),
                        ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, curve: Curves.easeOutCubic),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}