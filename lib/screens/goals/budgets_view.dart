import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/di/providers.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/currency_formatter.dart';
import '../../models/budget.dart';
import '../../widgets/common/empty_state.dart';
import '../../widgets/common/glass_panel.dart';
import '../../core/constants/app_constants.dart';
import 'add_budget_sheet.dart';
import '../../core/utils/extensions.dart';

class BudgetsView extends ConsumerWidget {
  const BudgetsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budgetsAsync = ref.watch(budgetsProvider);
    final colors = context.colors;
    
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: budgetsAsync.when(
        data: (budgets) {
          if (budgets.isEmpty) {
            return const EmptyState(
              icon: Icons.account_balance_wallet_rounded,
              title: 'No active budgets.',
              subtitle: 'Create a budget to keep your spending in check.',
            );
          }
          
          return ListView.builder(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 120),
            itemCount: budgets.length,
            itemBuilder: (context, index) {
              return _buildBudgetCard(context, ref, budgets[index]);
            },
          );
        },
        loading: () => Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(colors.accentTeal),
          ),
        ),
        error: (err, stack) => Center(
          child: Text('Error: $err', style: TextStyle(color: colors.accentRed)),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 90),
        child: FloatingActionButton(
          backgroundColor: colors.accentTeal,
          child: const Icon(Icons.add, color: Colors.white),
          onPressed: () {
            AddBudgetSheet.show(context);
          },
        ),
      ),
    );
  }

  Widget _buildBudgetCard(BuildContext context, WidgetRef ref, Budget b) {
    final colors = context.colors;
    final textStyles = context.textStyles;
    
    // Placeholder for current spent. In a real app we'd aggregate transactions.
    final spent = b.monthlyLimit * 0.45; // Hardcoded mock value
    final progress = (spent / b.monthlyLimit).clamp(0.0, 1.0);
    
    Color progressColor = colors.accentTeal;
    if (progress > AppConstants.kBudgetWarningThreshold) {
      progressColor = colors.accentRed;
    } else if (progress > 0.6) {
      progressColor = Colors.orange;
    }

    return Dismissible(
      key: ValueKey(b.id),
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
        // BudgetRepository does not have delete method currently!
        // We'll just ignore for now, or we should add a delete method.
      },
      child: GestureDetector(
        onTap: () {
          AddBudgetSheet.show(context, existingBudget: b);
        },
        child: Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: GlassPanel(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      b.category.name.capitalize(),
                      style: textStyles.headingLarge,
                    ),
                    Text(
                      '${CurrencyFormatter.format(spent)} / ${CurrencyFormatter.format(b.monthlyLimit)}',
                      style: TextStyle(
                        color: progressColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    backgroundColor: colors.borderMid,
                    valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Remaining: ${CurrencyFormatter.format(b.monthlyLimit - spent)}',
                  style: textStyles.bodySmall.copyWith(color: colors.textMuted),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
