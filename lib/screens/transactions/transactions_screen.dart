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
import '../../widgets/transactions/transaction_filter_sheet.dart';

class TransactionsScreen extends ConsumerStatefulWidget {
  const TransactionsScreen({super.key});

  @override
  ConsumerState<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends ConsumerState<TransactionsScreen> {
  TransactionFilterOptions _filterOptions = const TransactionFilterOptions();
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showFilterSheet(BuildContext context, AppColors colors, AppTextStyles textStyles) async {
    final result = await TransactionFilterSheet.show(context, _filterOptions);
    if (result != null) {
      setState(() {
        _filterOptions = result;
      });
    }
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
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search merchant or note...',
                hintStyle: TextStyle(color: colors.textMuted),
                prefixIcon: Icon(Icons.search, color: colors.textMuted),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear, color: colors.textMuted),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                filled: true,
                fillColor: colors.backgroundElevated,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              onChanged: (val) {
                setState(() {
                  _searchQuery = val.toLowerCase();
                });
              },
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list_rounded, color: !_filterOptions.isEmpty ? colors.accentPurple : colors.textPrimary),
            onPressed: () => _showFilterSheet(context, colors, textStyles),
          ),
        ],
      ),
      body: transactionsAsync.when(
        data: (transactions) {
          final filtered = transactions.where((t) {
            if (_filterOptions.direction != null && t.direction != _filterOptions.direction) return false;
            if (_filterOptions.category != null && t.category != _filterOptions.category) return false;
            if (_filterOptions.paymentMethod != null && t.paymentMethod != _filterOptions.paymentMethod) return false;
            if (_filterOptions.startDate != null && t.date.isBefore(_filterOptions.startDate!)) return false;
            // Add 1 day to end date to include the whole day
            if (_filterOptions.endDate != null && t.date.isAfter(_filterOptions.endDate!.add(const Duration(days: 1)))) return false;
            
            if (_searchQuery.isNotEmpty) {
              final merchant = t.merchantName?.toLowerCase() ?? '';
              final note = t.note?.toLowerCase() ?? '';
              final categoryName = t.category.name.toLowerCase();
              if (!merchant.contains(_searchQuery) && !note.contains(_searchQuery) && !categoryName.contains(_searchQuery)) {
                return false;
              }
            }
            return true;
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
