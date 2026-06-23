import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';

class MainScaffold extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainScaffold({
    super.key,
    required this.navigationShell,
  });

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: AppColors.borderSubtle, width: 1),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: navigationShell.currentIndex,
          onTap: _onTap,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded, size: 26),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long_rounded, size: 26),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet_rounded, size: 26),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.savings_rounded, size: 26),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart_rounded, size: 26),
              label: '',
            ),
          ],
        ),
      ),
    );
  }
}