import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/di/providers.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/extensions.dart';
import '../../models/budget.dart';
import '../../models/transaction.dart';
import '../../widgets/common/glass_panel.dart';
import 'package:intl/intl.dart';
import '../../widgets/budgets/budget_progress_bar.dart';
import '../../core/constants/app_constants.dart';

class BudgetHistorySheet extends ConsumerWidget {
  final Budget budget;

  const BudgetHistorySheet({super.key, required this.budget});

  static Future<void> show(BuildContext context, Budget budget) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => BudgetHistorySheet(budget: budget),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(recentTransactionsProvider);
    final colors = context.colors;
    final textStyles = context.textStyles;

    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: colors.backgroundSurface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        border: Border.all(color: colors.borderSubtle, width: 1),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 48,
            height: 4,
            decoration: BoxDecoration(
              color: colors.textMuted.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${budget.category.name.capitalize()} History', style: textStyles.headingMedium),
                IconButton(
                  icon: Icon(Icons.close_rounded, color: colors.textMuted),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: transactionsAsync.when(
              data: (transactions) {
                // Get past 3 months
                final now = DateTime.now();
                final List<Map<String, dynamic>> history = [];

                for (int i = 0; i < 3; i++) {
                  final month = DateTime(now.year, now.month - i, 1);
                  final spent = transactions
                      .where((t) =>
                          t.category == budget.category &&
                          t.direction == TransactionDirection.debit &&
                          t.date.year == month.year &&
                          t.date.month == month.month)
                      .fold<double>(0, (sum, t) => sum + t.amount);

                  history.add({
                    'date': month,
                    'spent': spent,
                  });
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(24),
                  itemCount: history.length,
                  itemBuilder: (context, index) {
                    final data = history[index];
                    final date = data['date'] as DateTime;
                    final spent = data['spent'] as double;
                    
                    final progress = (spent / budget.monthlyLimit).clamp(0.0, 1.0);
                    Color progressColor = colors.accentTeal;
                    if (progress > AppConstants.kBudgetWarningThreshold) {
                      progressColor = colors.accentRed;
                    } else if (progress > 0.6) {
                      progressColor = Colors.orange;
                    }

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: GlassPanel(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  DateFormat('MMMM yyyy').format(date),
                                  style: textStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '${CurrencyFormatter.format(spent)} / ${CurrencyFormatter.format(budget.monthlyLimit)}',
                                  style: TextStyle(
                                    color: progressColor,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            BudgetProgressBar(
                              progress: progress,
                              progressColor: progressColor,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => Center(child: CircularProgressIndicator(color: colors.accentPurple)),
              error: (err, stack) => Center(child: Text('Error: $err', style: TextStyle(color: colors.accentRed))),
            ),
          ),
        ],
      ),
    );
  }
}
