import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/di/providers.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/common/app_card.dart';
import '../../core/utils/currency_formatter.dart';
import '../../models/transaction.dart';
import '../../core/constants/app_constants.dart';
import '../transactions/add_transaction_sheet.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(recentTransactionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
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
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                _buildSummaryCard(balance, income, expense),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Recent Transactions', style: AppTextStyles.headingSmall),
                    TextButton(
                      onPressed: () {},
                      child: const Text('See All'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (transactions.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Text('No transactions yet', style: AppTextStyles.bodyMedium),
                    ),
                  )
                else
                  ...transactions.take(5).map((t) => _buildTransactionTile(t)).toList(),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.accentPurple,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          AddTransactionSheet.show(context);
        },
      ),
    );
  }

  Widget _buildSummaryCard(double balance, double income, double expense) {
    return AppCard(
      glowColor: AppColors.accentPurple,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Current Balance', style: AppTextStyles.bodyMedium),
          const SizedBox(height: 8),
          Text(
            CurrencyFormatter.format(balance),
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _buildStat('Income', income, AppColors.accentTeal, Icons.arrow_downward_rounded),
              ),
              Container(width: 1, height: 40, color: AppColors.borderSubtle),
              Expanded(
                child: _buildStat('Expense', expense, AppColors.accentRed, Icons.arrow_upward_rounded),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String label, double amount, Color color, IconData icon) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 4),
            Text(label, style: AppTextStyles.bodySmall),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          CurrencyFormatter.format(amount),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionTile(Transaction t) {
    final isIncome = t.direction == TransactionDirection.credit;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.backgroundSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderSubtle, width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isIncome ? AppColors.accentTeal.withOpacity(0.1) : AppColors.accentRed.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isIncome ? Icons.attach_money_rounded : Icons.shopping_bag_rounded,
              color: isIncome ? AppColors.accentTeal : AppColors.accentRed,
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
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: AppColors.textPrimary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '\${t.date.day}/\${t.date.month}/\${t.date.year} • \${t.paymentMethod.name.toUpperCase()}',
                  style: AppTextStyles.bodySmall,
                ),
              ],
            ),
          ),
          Text(
            isIncome ? "+${CurrencyFormatter.format(t.amount)}" : "-${CurrencyFormatter.format(t.amount)}",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: isIncome ? AppColors.accentTeal : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}