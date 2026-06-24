import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/di/providers.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/common/app_bottom_sheet.dart';
import '../../widgets/common/app_button.dart';
import '../../models/savings_goal.dart';
import '../../core/utils/extensions.dart';

class AddContributionSheet extends ConsumerStatefulWidget {
  final SavingsGoal goal;
  const AddContributionSheet({super.key, required this.goal});

  static Future<void> show(BuildContext context, {required SavingsGoal goal}) {
    return AppBottomSheet.show(
      context,
      title: 'Add Funds to ${goal.name}',
      child: AddContributionSheet(goal: goal),
    );
  }

  @override
  ConsumerState<AddContributionSheet> createState() => _AddContributionSheetState();
}

class _AddContributionSheetState extends ConsumerState<AddContributionSheet> {
  late TextEditingController _amountController;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _saveContribution() {
    final amountText = _amountController.text.trim();
    if (amountText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter an amount')),
      );
      return;
    }

    final amount = double.tryParse(amountText);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount')),
      );
      return;
    }

    // Add contribution to current amount
    final updatedGoal = widget.goal.copyWith(
      currentAmount: widget.goal.currentAmount + amount,
    );

    // Save back to DB
    ref.read(goalRepositoryProvider).save(updatedGoal);

    // Close the sheet
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textStyles = context.textStyles;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'How much did you save towards this goal?',
              style: textStyles.bodyMedium.copyWith(color: colors.textMuted),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
              style: textStyles.bodyLarge,
              decoration: InputDecoration(
                labelText: 'Amount (₹)',
                labelStyle: TextStyle(color: colors.textMuted),
                prefixText: '₹ ',
                prefixStyle: textStyles.bodyLarge,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: colors.borderSubtle),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: colors.accentTeal, width: 2),
                ),
                filled: true,
                fillColor: colors.backgroundElevated,
              ),
            ),
            const SizedBox(height: 32),
            AppButton(
              label: 'Add Funds',
              onPressed: _saveContribution,
              backgroundColor: colors.accentTeal,
              textColor: Colors.white,
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
          ],
        ),
      ),
    );
  }
}
