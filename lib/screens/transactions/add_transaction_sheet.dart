import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../core/di/providers.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/common/app_bottom_sheet.dart';
import '../../widgets/common/app_button.dart';
import '../../models/transaction.dart';
import '../../core/constants/app_constants.dart';

class AddTransactionSheet extends ConsumerStatefulWidget {
  const AddTransactionSheet({super.key});

  static Future<void> show(BuildContext context) {
    return AppBottomSheet.show(
      context,
      title: 'Add Transaction',
      child: const AddTransactionSheet(),
    );
  }

  @override
  ConsumerState<AddTransactionSheet> createState() => _AddTransactionSheetState();
}

class _AddTransactionSheetState extends ConsumerState<AddTransactionSheet> {
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  
  TransactionDirection _direction = TransactionDirection.debit;
  Category _category = Category.food;
  PaymentMethod _paymentMethod = PaymentMethod.upi;
  DateTime _date = DateTime.now();

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _submit() async {
    final amountText = _amountController.text.trim();
    if (amountText.isEmpty) return;
    
    final amount = double.tryParse(amountText);
    if (amount == null || amount <= 0) return;

    final repo = ref.read(transactionRepositoryProvider);
    final transaction = Transaction(
      id: const Uuid().v4(),
      amount: amount,
      direction: _direction,
      category: _category,
      note: _noteController.text.trim(),
      date: _date,
      paymentMethod: _paymentMethod,
      isRecurring: false,
      confidence: Confidence.high,
      isConfirmed: true,
    );

    await repo.save(transaction);
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: ChoiceChip(
                  label: const Text('Expense'),
                  selected: _direction == TransactionDirection.debit,
                  onSelected: (val) => setState(() => _direction = TransactionDirection.debit),
                  selectedColor: AppColors.accentRed.withOpacity(0.2),
                  backgroundColor: AppColors.backgroundPrimary,
                  labelStyle: TextStyle(
                    color: _direction == TransactionDirection.debit ? AppColors.accentRed : AppColors.textMuted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ChoiceChip(
                  label: const Text('Income'),
                  selected: _direction == TransactionDirection.credit,
                  onSelected: (val) => setState(() => _direction = TransactionDirection.credit),
                  selectedColor: AppColors.accentTeal.withOpacity(0.2),
                  backgroundColor: AppColors.backgroundPrimary,
                  labelStyle: TextStyle(
                    color: _direction == TransactionDirection.credit ? AppColors.accentTeal : AppColors.textMuted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            decoration: const InputDecoration(
              prefixText: '₹ ',
              prefixStyle: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.textMuted),
              hintText: '0',
              border: InputBorder.none,
            ),
          ),
          const SizedBox(height: 24),
          DropdownButtonFormField<Category>(
            value: _category,
            dropdownColor: AppColors.backgroundSurface,
            decoration: InputDecoration(
              labelText: 'Category',
              labelStyle: const TextStyle(color: AppColors.textMuted),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.borderMid),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.accentPurple),
              ),
            ),
            items: Category.values.map((c) {
              return DropdownMenuItem(
                value: c,
                child: Text(c.name.toUpperCase()),
              );
            }).toList(),
            onChanged: (val) {
              if (val != null) setState(() => _category = val);
            },
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _noteController,
            decoration: InputDecoration(
              labelText: 'Note (Optional)',
              labelStyle: const TextStyle(color: AppColors.textMuted),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.borderMid),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.accentPurple),
              ),
            ),
          ),
          const SizedBox(height: 32),
          AppButton(
            label: 'Save Transaction',
            onPressed: _submit,
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}