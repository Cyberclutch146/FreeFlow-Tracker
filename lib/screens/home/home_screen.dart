import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/di/providers.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/common/glass_panel.dart';
import '../../core/utils/currency_formatter.dart';
import '../../models/transaction.dart';
import '../../core/constants/app_constants.dart';
import '../transactions/add_transaction_sheet.dart';
import 'review_sms_sheet.dart';
import 'package:flutter_animate/flutter_animate.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _showAllTime = false;

  @override
  Widget build(BuildContext context) {
    final transactionsAsync = ref.watch(recentTransactionsProvider);
    final unconfirmedAsync = ref.watch(unconfirmedTransactionsProvider);
    final insightsAsync = ref.watch(insightsProvider);
    final colors = context.colors;
    final textStyles = context.textStyles;
    final now = DateTime.now();

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text('Dashboard', style: textStyles.headingLarge),
        actions: [
          IconButton(
            icon: ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [colors.accentPurple, colors.accentTeal],
              ).createShader(bounds),
              child: const Icon(Icons.auto_awesome, color: Colors.white, size: 22),
            ),
            tooltip: 'AI Assistant',
            onPressed: () => GoRouter.of(context).push('/ai-chat'),
          ),

          IconButton(
            icon: Icon(Icons.settings_outlined, color: colors.textPrimary),
            onPressed: () => GoRouter.of(context).push('/settings'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: transactionsAsync.when(
        data: (transactions) {
          // Filter to current month for dashboard view
          final displayTxns = _showAllTime
              ? transactions
              : transactions
                  .where((t) =>
                      t.date.year == now.year && t.date.month == now.month)
                  .toList();

          double income = 0;
          double expense = 0;
          for (var t in displayTxns) {
            if (t.direction == TransactionDirection.credit) {
              income += t.amount;
            } else {
              expense += t.amount;
            }
          }
          final balance = income - expense;

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(recentTransactionsProvider);
            },
            color: colors.accentPurple,
            child: ListView(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 120.0),
              children: [
                // Month/All-time toggle
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ChoiceChip(
                      label: const Text('This Month'),
                      selected: !_showAllTime,
                      onSelected: (_) => setState(() => _showAllTime = false),
                      selectedColor: colors.accentPurple.withValues(alpha: 0.2),
                      labelStyle: TextStyle(
                        color: !_showAllTime ? colors.accentPurple : colors.textMuted,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    ChoiceChip(
                      label: const Text('All Time'),
                      selected: _showAllTime,
                      onSelected: (_) => setState(() => _showAllTime = true),
                      selectedColor: colors.accentTeal.withValues(alpha: 0.2),
                      labelStyle: TextStyle(
                        color: _showAllTime ? colors.accentTeal : colors.textMuted,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildSummaryCard(context, balance, income, expense),
                const SizedBox(height: 32),
                
                // Unconfirmed Transactions Banner
                unconfirmedAsync.when(
                  data: (unconfirmed) {
                    if (unconfirmed.isEmpty) return const SizedBox.shrink();
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 24.0),
                      child: GlassPanel(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: colors.accentRed.withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.warning_amber_rounded, color: colors.accentRed, size: 20),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('${unconfirmed.length} Unconfirmed SMS', style: textStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
                                  Text('Tap to review new transactions', style: textStyles.bodySmall.copyWith(color: colors.textMuted)),
                                ],
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                ReviewSmsSheet.show(context);
                              },
                              child: Text('Review', style: TextStyle(color: colors.accentTeal, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ).animate().fadeIn().slideX(begin: -0.2),
                    );
                  },
                  loading: () => const SizedBox.shrink(),
                  error: (_, _) => const SizedBox.shrink(),
                ),

                // Insights Row
                insightsAsync.when(
                  data: (insights) {
                    if (insights.isEmpty) return const SizedBox.shrink();
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Smart Insights', style: textStyles.headingSmall),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 140,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: insights.length,
                            separatorBuilder: (context, index) => const SizedBox(width: 12),
                            itemBuilder: (context, index) {
                              final card = insights[index];
                              Color cardColor;
                              IconData iconData;
                              switch (card.type) {
                                case InsightType.info:
                                  cardColor = colors.accentTeal;
                                  iconData = Icons.lightbulb_outline;
                                  break;
                                case InsightType.success:
                                  cardColor = Colors.greenAccent;
                                  iconData = Icons.check_circle_outline;
                                  break;
                                case InsightType.warning:
                                  cardColor = Colors.orangeAccent;
                                  iconData = Icons.warning_amber_rounded;
                                  break;
                                case InsightType.danger:
                                  cardColor = colors.accentRed;
                                  iconData = Icons.error_outline;
                                  break;
                              }

                              return SizedBox(
                                width: 280,
                                child: GlassPanel(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(iconData, color: cardColor, size: 20),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(card.headline, style: textStyles.bodyLarge.copyWith(color: cardColor, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Expanded(
                                        child: Text(card.detail, style: textStyles.bodyMedium.copyWith(color: colors.textPrimary), maxLines: 3, overflow: TextOverflow.ellipsis),
                                      ),
                                    ],
                                  ),
                                ).animate().fadeIn(delay: (200 + index * 100).ms).slideX(begin: 0.2),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 32),
                      ],
                    );
                  },
                  loading: () => const SizedBox.shrink(),
                  error: (_, _) => const SizedBox.shrink(),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Recent Transactions', style: textStyles.headingSmall),
                    TextButton(
                      onPressed: () {
                        // Navigate to the Transactions tab (index 1 in the shell)
                        GoRouter.of(context).go('/transactions');
                      },
                      child: Text('See All', style: TextStyle(color: colors.accentPurple)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (transactions.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Text('No transactions yet', style: textStyles.bodyMedium),
                    ),
                  )
                else
                  ...transactions.take(5).toList().asMap().entries.map((entry) {
                    int idx = entry.key;
                    var t = entry.value;
                    return _buildTransactionTile(context, t)
                        .animate()
                        .fadeIn(delay: (300 + idx * 100).ms)
                        .slideY(begin: 0.2);
                  }),
              ],
            ),
          );
        },
        loading: () => Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(colors.accentPurple),
          ),
        ),
        error: (err, stack) => Center(
          child: Text('Error: $err', style: TextStyle(color: colors.accentRed)),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 90),
        child: FloatingActionButton(
          backgroundColor: colors.accentPurple,
          child: const Icon(Icons.add, color: Colors.white),
          onPressed: () {
            AddTransactionSheet.show(context);
          },
        ),
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context, double balance, double income, double expense) {
    final colors = context.colors;
    final textStyles = context.textStyles;

    return GlassPanel(
      padding: const EdgeInsets.all(24),
      blurSigma: 32,
      opacity: 0.15,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Total Balance', style: textStyles.bodyMedium),
          const SizedBox(height: 8),
          Text(
            CurrencyFormatter.format(balance),
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w800,
              color: colors.textPrimary,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: _buildStat(context, 'Income', income, colors.accentTeal, Icons.arrow_downward_rounded),
              ),
              Container(width: 1, height: 40, color: colors.borderSubtle),
              Expanded(
                child: _buildStat(context, 'Expense', expense, colors.accentRed, Icons.arrow_upward_rounded),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStat(BuildContext context, String label, double amount, Color color, IconData icon) {
    final textStyles = context.textStyles;
    
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 4),
            Text(label, style: textStyles.bodySmall),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          CurrencyFormatter.format(amount),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionTile(BuildContext context, Transaction t) {
    final isIncome = t.direction == TransactionDirection.credit;
    final colors = context.colors;
    final textStyles = context.textStyles;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassPanel(
        padding: const EdgeInsets.all(16),
        opacity: 0.08,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isIncome ? colors.accentTeal.withValues(alpha: 0.15) : colors.accentRed.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isIncome ? Icons.attach_money_rounded : Icons.shopping_bag_rounded,
                color: isIncome ? colors.accentTeal : colors.accentRed,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    t.note?.isNotEmpty == true ? t.note! : t.category.name.toUpperCase(),
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: colors.textPrimary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${t.date.day}/${t.date.month}/${t.date.year} • ${t.paymentMethod.name.toUpperCase()}',
                    style: textStyles.bodySmall,
                  ),
                ],
              ),
            ),
            Text(
              isIncome ? "+${CurrencyFormatter.format(t.amount)}" : "-${CurrencyFormatter.format(t.amount)}",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: isIncome ? colors.accentTeal : colors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}