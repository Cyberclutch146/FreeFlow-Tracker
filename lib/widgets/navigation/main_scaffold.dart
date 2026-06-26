import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../common/liquid_background.dart';
import '../common/glass_panel.dart';

import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/di/providers.dart';
import '../../core/utils/tutorial_keys.dart';

class MainScaffold extends ConsumerStatefulWidget {
  final StatefulNavigationShell navigationShell;

  const MainScaffold({
    super.key,
    required this.navigationShell,
  });

  @override
  ConsumerState<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends ConsumerState<MainScaffold> {
  TutorialCoachMark? tutorialCoachMark;
  bool _tutorialShown = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndShowTutorial();
    });
  }

  void _checkAndShowTutorial() async {
    final repo = ref.read(settingsRepositoryProvider);
    final settings = await repo.get();
    
    if (!settings.tutorialComplete && !_tutorialShown && mounted) {
      _tutorialShown = true;
      _showTutorial();
      
      // Mark as complete
      await repo.save(settings.copyWith(tutorialComplete: true));
    }
  }

  void _showTutorial() {
    tutorialCoachMark = TutorialCoachMark(
      targets: _createTargets(),
      colorShadow: Colors.black,
      textSkip: "SKIP",
      paddingFocus: 10,
      opacityShadow: 0.9,
      onFinish: () {},
      onClickTarget: (target) {},
      onClickOverlay: (target) {},
      onSkip: () { return true; },
    );
    tutorialCoachMark!.show(context: context);
  }

  List<TargetFocus> _createTargets() {
    final colors = context.colors;
    final textStyles = context.textStyles;

    return [
      TargetFocus(
        identify: "SummaryCard",
        keyTarget: TutorialKeys.summaryCardKey,
        shape: ShapeLightFocus.RRect,
        radius: 24,
        alignSkip: Alignment.topRight,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return _buildTutorialContent(
                title: "Your Financial Snapshot",
                desc: "This card shows your total balance, income, and expenses for the current month. Keep an eye here to know where you stand.",
                colors: colors,
                textStyles: textStyles,
              );
            },
          ),
        ],
      ),
      TargetFocus(
        identify: "AIBanner",
        keyTarget: TutorialKeys.aiBannerKey,
        shape: ShapeLightFocus.RRect,
        radius: 24,
        alignSkip: Alignment.topRight,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return _buildTutorialContent(
                title: "Your AI Assistant",
                desc: "Tap here anytime to chat with the local AI. It can summarize your data, find transactions, and give you smart financial tips!",
                colors: colors,
                textStyles: textStyles,
              );
            },
          ),
        ],
      ),
      TargetFocus(
        identify: "TxnsTab",
        keyTarget: TutorialKeys.txnsTabKey,
        shape: ShapeLightFocus.Circle,
        alignSkip: Alignment.topRight,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return _buildTutorialContent(
                title: "Upload Bank Statements",
                desc: "Head over to the Transactions tab to upload your CSV or PDF bank statements. We'll auto-categorize everything for you!",
                colors: colors,
                textStyles: textStyles,
              );
            },
          ),
        ],
      ),
      TargetFocus(
        identify: "GoalsTab",
        keyTarget: TutorialKeys.goalsTabKey,
        shape: ShapeLightFocus.Circle,
        alignSkip: Alignment.topRight,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return _buildTutorialContent(
                title: "Set Goals & Budgets",
                desc: "Plan for the future by creating Savings Goals and setting Monthly Budgets here.",
                colors: colors,
                textStyles: textStyles,
              );
            },
          ),
        ],
      ),
    ];
  }

  Widget _buildTutorialContent({required String title, required String desc, required dynamic colors, required dynamic textStyles}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: textStyles.headingLarge.copyWith(color: colors.accentPurple)),
        const SizedBox(height: 12),
        Text(desc, style: textStyles.bodyLarge.copyWith(color: Colors.white)),
      ],
    );
  }

  void _onTap(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LiquidBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: widget.navigationShell,
        extendBody: true, // Allow body to scroll behind the floating nav bar
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
          child: GlassPanel(
            baseColor: context.colors.backgroundElevated,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            borderRadius: BorderRadius.circular(32),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildNavItem(context, 0, Icons.home_rounded, 'Home', null),
                _buildNavItem(context, 1, Icons.receipt_long_rounded, 'Txns', TutorialKeys.txnsTabKey),
                _buildNavItem(context, 2, Icons.account_balance_wallet_rounded, 'Income', null),
                _buildNavItem(context, 3, Icons.savings_rounded, 'Goals', TutorialKeys.goalsTabKey),
                _buildNavItem(context, 4, Icons.auto_awesome, 'AI Hub', null),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, int index, IconData icon, String label, GlobalKey? tutorialKey) {
    final isSelected = widget.navigationShell.currentIndex == index;
    final colors = context.colors;
    
    return GestureDetector(
      key: tutorialKey,
      onTap: () => _onTap(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 16.0 : 8.0,
          vertical: 8.0,
        ),
        decoration: BoxDecoration(
          color: isSelected ? colors.accentPurple.withValues(alpha: 0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 24,
              color: isSelected ? colors.accentPurple : colors.textMuted,
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: colors.accentPurple,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}