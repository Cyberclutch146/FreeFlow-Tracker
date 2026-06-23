import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/di/providers.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/currency_formatter.dart';
import '../../models/transaction.dart';
import '../../core/constants/app_constants.dart';
import '../../widgets/common/empty_state.dart';
import '../../widgets/common/glass_panel.dart';
import 'add_transaction_sheet.dart';

class TransactionsScreen extends ConsumerStatefulWidget {
  const TransactionsScreen({super.key});

  @override
  ConsumerState<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends ConsumerState<TransactionsScreen> {
  TransactionDirection? _filterDirection;

  void _showFilterSheet(BuildContext context, AppColors colors, AppTextStyles textStyles) {
    showModalBottomSheet(
      context: context,
      backgroundColor: colors.backgroundSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Filter Transactions', style: textStyles.headingLarge),
              const SizedBox(height: 16),
              ListTile(
                title: Text('All', style: textStyles.bodyLarge),
                trailing: _filterDirection == null ? Icon(Icons.check, color: colors.accentPurple) : null,
                onTap: () {
                  setState(() => _filterDirection = null);
                  Navigator.pop(ctx);
                },
              ),
              ListTile(
                title: Text('Income Only', style: textStyles.bodyLarge),
                trailing: _filterDirection == TransactionDirection.credit ? Icon(Icons.check, color: colors.accentPurple) : null,
                onTap: () {
                  setState(() => _filterDirection = TransactionDirection.credit);
                  Navigator.pop(ctx);
                },
              ),
              ListTile(
                title: Text('Expenses Only', style: textStyles.bodyLarge),
                trailing: _filterDirection == TransactionDirection.debit ? Icon(Icons.check, color: colors.accentPurple) : null,
                onTap: () {
                  setState(() => _filterDirection = TransactionDirection.debit);
                  Navigator.pop(ctx);
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final transactionsAsync = ref.watch(recentTransactionsProvider);
    final colors = context.colors;
    final textStyles = context.textStyles;

    return Scaffold(
       // Background handled by LiquidBackground
      appBar: AppBar(
        title: Text('All Transactions', style: textStyles.headingLarge),
        
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list_rounded, color: _filterDirection != null ? colors.accentPurple : colors.textPrimary),
            onPressed: () => _showFilterSheet(context, colors, textStyles),
          ),
        ],
      ),
      body: transactionsAsync.when(
        data: (transactions) {
          final filtered = transactions.where((t) {
            if (_filterDirection == null) return true;
            return t.direction == _filterDirection;
          }).toList();

          if (filtered.isEmpty) {
            return const EmptyState(
              icon: Icons.receipt_long_rounded,
              title: 'No transactions yet.',
              subtitle: 'Import from SMS or add manually.',
            );
          }
          
          return ListView.builder(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 120),
            itemCount: filtered.length,
            itemBuilder: (context, index) {
              final t = filtered[index];
              return _buildTransactionTile(context, ref, t);
            },
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

  Widget _buildTransactionTile(BuildContext context, WidgetRef ref, Transaction t) {
    final isIncome = t.direction == TransactionDirection.credit;
    final colors = context.colors;
    final textStyles = context.textStyles;

    return Dismissible(
      key: ValueKey(t.id),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          color: colors.accentRed,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerRight,
        child: const Icon(Icons.delete_outline_rounded, color: Colors.white),
      ),
      onDismissed: (direction) {
        ref.read(transactionRepositoryProvider).delete(t.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Transaction deleted', style: TextStyle(color: colors.textPrimary)),
            backgroundColor: colors.backgroundElevated,
            action: SnackBarAction(
              label: 'Undo',
              textColor: colors.accentPurple,
              onPressed: () {
                ref.read(transactionRepositoryProvider).save(t);
              },
            ),
          ),
        );
      },
      child: GestureDetector(
        onTap: () {
          // Tap to edit
          AddTransactionSheet.show(context, existingTransaction: t);
        },
        child: Padding(
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
        ),
      ),
    );
  }
}
