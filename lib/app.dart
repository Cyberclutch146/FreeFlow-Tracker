import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/di/providers.dart';

final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

class FreelanceFlowApp extends ConsumerWidget {
  const FreelanceFlowApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeConfig = ref.watch(themeConfigProvider);
    ref.watch(autoSmsSyncProvider);
    
    return MaterialApp.router(
      scaffoldMessengerKey: scaffoldMessengerKey,
      title: 'FreelanceFlow',
      theme: AppTheme.fromConfig(themeConfig),
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}