import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_text_styles.dart';
import 'core/di/providers.dart';
import 'services/auth_service.dart';

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
                child: Container(
                  color: AppColors.fromConfig(themeConfig).backgroundBase,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.lock_outline, size: 64, color: AppColors.fromConfig(themeConfig).accentPurple),
                        const SizedBox(height: 24),
                        Material(
                          color: Colors.transparent,
                          child: Text(
                            'App Locked',
                            style: AppTextStyles.fromColors(AppColors.fromConfig(themeConfig)).headingLarge,
                          ),
                        ),
                        const SizedBox(height: 32),
                        ElevatedButton.icon(
                          onPressed: _authenticate,
                          icon: const Icon(Icons.fingerprint),
                          label: const Text('Unlock'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.fromConfig(themeConfig).accentPurple,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                        ),
                      ],
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