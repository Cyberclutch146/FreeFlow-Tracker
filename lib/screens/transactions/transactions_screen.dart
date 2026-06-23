import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/di/providers.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/currency_formatter.dart';
import '../../models/transaction.dart';
import '../../core/constants/app_constants.dart';
import '../../widgets/common/empty_state.dart';
import 'add_transaction_sheet.dart';

class TransactionsScreen extends ConsumerWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(recentTransactionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Transactions'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: transactionsAsync.when(
        data: (transactions) {
          if (transactions.isEmpty) {
            return const EmptyState(
              icon: Icons.receipt_long_rounded,
              title: 'No transactions yet.',
              subtitle: 'Import from SMS or add manually.',
            );
          }
          
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final t = transactions[index];
              return _buildTransactionTile(t);
            },
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