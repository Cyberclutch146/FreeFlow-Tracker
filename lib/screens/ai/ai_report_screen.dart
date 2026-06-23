import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:intl/intl.dart';
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
  DateTime? _generatedAt;

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
      final ai = ref.read(geminiServiceProvider);
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

      final report = await ai.generateMonthlyReport(
        currentMonthTxns: currentMonth,
        lastMonthTxns: lastMonth,
        goals: goals,
        budgets: budgets,
        settings: settings,
      );

      setState(() {
        _report = report;
        _generatedAt = DateTime.now();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to generate report: $e';
        _isLoading = false;
      });
    }
  }

  void _copyReport() {
    if (_report == null) return;
    Clipboard.setData(ClipboardData(text: _report!));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Report copied to clipboard!'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textStyles = context.textStyles;

    return Scaffold(
      backgroundColor: colors.backgroundPrimary,
      appBar: AppBar(
        backgroundColor: colors.backgroundPrimary,
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [colors.accentTeal, const Color(0xFF00E676)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: colors.accentTeal.withValues(alpha: 0.4), blurRadius: 8, spreadRadius: 1)],
              ),
              child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('AI Report', style: textStyles.headingMedium),
                if (_generatedAt != null)
                  Text(
                    'Generated ${DateFormat('hh:mm a').format(_generatedAt!)}',
                    style: textStyles.bodySmall.copyWith(color: colors.textMuted, fontSize: 10),
                  ),
              ],
            ),
          ],
        ),
        actions: [
          if (_report != null)
            IconButton(
              icon: Icon(Icons.copy_rounded, color: colors.textMuted, size: 20),
              tooltip: 'Copy report',
              onPressed: _copyReport,
            ),
          IconButton(
            icon: Icon(Icons.refresh_rounded, color: colors.textMuted),
            tooltip: 'Regenerate',
            onPressed: _isLoading ? null : _generateReport,
          ),
        ],
      ),
      body: _isLoading
          ? _buildLoadingState(colors, textStyles)
          : _error != null
              ? _buildErrorState(colors, textStyles)
              : _buildReportContent(colors, textStyles),
    );
  }

  Widget _buildLoadingState(AppColors colors, AppTextStyles textStyles) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [colors.accentPurple.withValues(alpha: 0.2), colors.accentTeal.withValues(alpha: 0.2)],
              ),
              shape: BoxShape.circle,
              border: Border.all(color: colors.accentPurple.withValues(alpha: 0.3), width: 2),
            ),
            child: Icon(Icons.auto_awesome_rounded, color: colors.accentPurple, size: 36),
          ).animate(onPlay: (c) => c.repeat(reverse: true)).scaleXY(end: 1.1, duration: 900.ms).then().shimmer(color: colors.accentTeal.withValues(alpha: 0.3)),
          const SizedBox(height: 28),
          Text('Crunching your numbers...', style: textStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.lock_rounded, size: 13, color: colors.accentTeal),
              const SizedBox(width: 4),
              Text('100% offline — data never leaves your device', style: textStyles.bodySmall.copyWith(color: colors.textMuted)),
            ],
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: 200,
            child: LinearProgressIndicator(
              backgroundColor: colors.borderSubtle,
              valueColor: AlwaysStoppedAnimation<Color>(colors.accentPurple),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(AppColors colors, AppTextStyles textStyles) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colors.accentRed.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.error_outline_rounded, color: colors.accentRed, size: 40),
            ),
            const SizedBox(height: 16),
            Text('Something went wrong', style: textStyles.headingMedium),
            const SizedBox(height: 8),
            Text(_error!, style: textStyles.bodySmall.copyWith(color: colors.textMuted), textAlign: TextAlign.center),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _generateReport,
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.accentPurple,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.refresh_rounded, color: Colors.white, size: 18),
              label: const Text('Try Again', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportContent(AppColors colors, AppTextStyles textStyles) {
    if (_report == null) return const SizedBox.shrink();

    return Column(
      children: [
        // Offline badge
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [colors.accentTeal.withValues(alpha: 0.08), colors.accentPurple.withValues(alpha: 0.05)],
            ),
            border: Border(bottom: BorderSide(color: colors.borderSubtle)),
          ),
          child: Row(
            children: [
              Icon(Icons.shield_rounded, size: 14, color: colors.accentTeal),
              const SizedBox(width: 6),
              Text(
                'Generated offline • All data stays on your device',
                style: textStyles.bodySmall.copyWith(color: colors.accentTeal, fontSize: 11),
              ),
              const Spacer(),
              Icon(Icons.lock_rounded, size: 12, color: colors.accentTeal),
            ],
          ),
        ),

        // Markdown report body
        Expanded(
          child: Markdown(
            data: _report!,
            selectable: true,
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
            styleSheet: _buildMarkdownStyleSheet(colors, textStyles),
            onTapLink: (text, href, title) {},
          ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.05),
        ),
      ],
    );
  }

  MarkdownStyleSheet _buildMarkdownStyleSheet(AppColors colors, AppTextStyles textStyles) {
    return MarkdownStyleSheet(
      // Headings
      h1: textStyles.headingLarge.copyWith(
        color: colors.textPrimary,
        fontSize: 22,
        fontWeight: FontWeight.w800,
        height: 1.3,
      ),
      h2: textStyles.headingMedium.copyWith(
        color: colors.accentPurple,
        fontSize: 15,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.3,
      ),
      h3: textStyles.bodyLarge.copyWith(
        color: colors.textSecondary,
        fontWeight: FontWeight.w600,
        fontSize: 13,
      ),
      // Body text
      p: textStyles.bodyMedium.copyWith(
        color: colors.textPrimary,
        height: 1.7,
        fontSize: 14,
      ),
      // Bold
      strong: textStyles.bodyMedium.copyWith(
        color: colors.textPrimary,
        fontWeight: FontWeight.w700,
        fontSize: 14,
      ),
      // Code / monospace
      code: textStyles.bodySmall.copyWith(
        color: colors.accentTeal,
        backgroundColor: colors.accentTeal.withValues(alpha: 0.1),
        fontFamily: 'monospace',
        fontSize: 13,
      ),
      codeblockDecoration: BoxDecoration(
        color: colors.backgroundElevated,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colors.borderSubtle),
      ),
      // Blockquotes
      blockquote: textStyles.bodyMedium.copyWith(
        color: colors.textSecondary,
        fontStyle: FontStyle.italic,
        fontSize: 13,
      ),
      blockquoteDecoration: BoxDecoration(
        color: colors.accentAmber.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(4),
        border: Border(left: BorderSide(color: colors.accentAmber, width: 3)),
      ),
      // Tables
      tableHead: textStyles.bodySmall.copyWith(
        color: colors.textMuted,
        fontWeight: FontWeight.w700,
        fontSize: 11,
        letterSpacing: 0.5,
      ),
      tableBody: textStyles.bodyMedium.copyWith(
        color: colors.textPrimary,
        fontSize: 13,
      ),
      tableHeadAlign: TextAlign.left,
      tableBorder: TableBorder.all(color: colors.borderSubtle, width: 0.5),
      tableColumnWidth: const FlexColumnWidth(),
      tableCellsPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      // List bullets
      listBullet: textStyles.bodyMedium.copyWith(color: colors.accentPurple, fontSize: 14),
      // Horizontal rule
      horizontalRuleDecoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: colors.borderSubtle, width: 1)),
      ),
      // Spacing
      h1Padding: const EdgeInsets.only(bottom: 4, top: 8),
      h2Padding: const EdgeInsets.only(top: 20, bottom: 8),
      h3Padding: const EdgeInsets.only(top: 12, bottom: 4),
      pPadding: const EdgeInsets.only(bottom: 4),
      blockquotePadding: const EdgeInsets.all(12),
    );
  }
}
