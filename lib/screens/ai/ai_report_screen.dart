import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/di/providers.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/common/glass_panel.dart';

class AiReportScreen extends ConsumerStatefulWidget {
  const AiReportScreen({super.key});

  @override
  ConsumerState<AiReportScreen> createState() => _AiReportScreenState();
}

class _AiReportScreenState extends ConsumerState<AiReportScreen> {
  String? _report;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _generateReport();
  }

  Future<void> _generateReport() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final gemini = ref.read(geminiServiceProvider);
      if (!gemini.isConfigured) {
        setState(() {
          _error = 'Please add your Gemini API key in Settings first.';
          _isLoading = false;
        });
        return;
      }

      final txns = await ref.read(transactionRepositoryProvider).getAll();
      final goals = await ref.read(goalRepositoryProvider).getAll();
      final budgets = await ref.read(budgetRepositoryProvider).getAll();
      final settings = await ref.read(settingsRepositoryProvider).get();

      final now = DateTime.now();
      final currentMonth = txns.where((t) => t.date.year == now.year && t.date.month == now.month).toList();
      final lastMonth = txns.where((t) {
        var prevMonth = now.month - 1 == 0 ? 12 : now.month - 1;
        var prevYear = now.month - 1 == 0 ? now.year - 1 : now.year;
        return t.date.year == prevYear && t.date.month == prevMonth;
      }).toList();

      final report = await gemini.generateMonthlyReport(
        currentMonthTxns: currentMonth,
        lastMonthTxns: lastMonth,
        goals: goals,
        budgets: budgets,
        settings: settings,
      );

      setState(() {
        _report = report;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to generate report: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textStyles = context.textStyles;

    return Scaffold(
      
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [colors.accentTeal, Colors.greenAccent]),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.summarize_rounded, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 12),
            Text('AI Report', style: textStyles.headingLarge),
          ],
        ),
        
        actions: [
          IconButton(
            icon: Icon(Icons.refresh_rounded, color: colors.textMuted),
            tooltip: 'Regenerate',
            onPressed: _generateReport,
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [colors.accentPurple.withValues(alpha: 0.3), colors.accentTeal.withValues(alpha: 0.3)]),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.auto_awesome, color: colors.accentPurple, size: 32),
                  ).animate(onPlay: (c) => c.repeat(reverse: true)).scaleXY(end: 1.2, duration: 800.ms),
                  const SizedBox(height: 24),
                  Text('Analyzing your finances...', style: textStyles.bodyLarge),
                  const SizedBox(height: 8),
                  Text('Gemini is reviewing your data', style: textStyles.bodySmall.copyWith(color: colors.textMuted)),
                ],
              ),
            )
          : _error != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.error_outline, color: colors.accentRed, size: 48),
                        const SizedBox(height: 16),
                        Text(_error!, style: textStyles.bodyMedium.copyWith(color: colors.accentRed), textAlign: TextAlign.center),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: _generateReport,
                          style: ElevatedButton.styleFrom(backgroundColor: colors.accentPurple),
                          child: const Text('Try Again', style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: GlassPanel(
                    padding: const EdgeInsets.all(20),
                    child: SelectableText(
                      _report ?? 'No report generated yet.',
                      style: textStyles.bodyMedium.copyWith(
                        height: 1.7,
                        color: colors.textPrimary,
                      ),
                    ),
                  ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.1),
                ),
    );
  }
}
