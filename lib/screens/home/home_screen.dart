import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/di/providers.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/common/glass_panel.dart';
import '../../core/utils/currency_formatter.dart';
import '../../models/transaction.dart';
import '../../core/constants/app_constants.dart';
import '../transactions/add_transaction_sheet.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(recentTransactionsProvider);
    final colors = context.colors;
    final textStyles = context.textStyles;

    return Scaffold(
      backgroundColor: Colors.transparent, // Scaffold background handled by LiquidBackground
      appBar: AppBar(
        title: Text('Dashboard', style: textStyles.headingLarge),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_outlined, color: colors.textPrimary),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: transactionsAsync.when(
        data: (transactions) {
          double income = 0;
          double expense = 0;
          for (var t in transactions) {
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
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 120.0), // Padding for bottom nav
              children: [
                _buildSummaryCard(context, balance, income, expense),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Recent Transactions', style: textStyles.headingSmall),
                    TextButton(
                      onPressed: () {
                        // Navigate to transactions tab
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
                  ...transactions.take(5).map((t) => _buildTransactionTile(context, t)).toList(),
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