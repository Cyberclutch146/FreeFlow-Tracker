import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/services.dart';
import '../../core/di/providers.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/common/app_bottom_sheet.dart';
import '../../widgets/common/app_button.dart';
import '../../models/transaction.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/extensions.dart';
import '../../core/utils/currency_formatter.dart';

class SplitTransactionSheet extends ConsumerStatefulWidget {
  final Transaction parentTransaction;
  const SplitTransactionSheet({super.key, required this.parentTransaction});

  static Future<void> show(BuildContext context, {required Transaction parentTransaction}) {
    return AppBottomSheet.show(
      context,
      title: 'Split Transaction',
      child: SplitTransactionSheet(parentTransaction: parentTransaction),
    );
  }

  @override
  ConsumerState<SplitTransactionSheet> createState() => _SplitTransactionSheetState();
}

class _SplitTransactionSheetState extends ConsumerState<SplitTransactionSheet> {
  late TextEditingController _part1AmountController;
  late Category _part1Category;
  late TextEditingController _part1NoteController;

  late Category _part2Category;
  late TextEditingController _part2NoteController;

  late double _totalAmount;

  @override
  void initState() {
    super.initState();
    _totalAmount = widget.parentTransaction.amount;
    
    // Default split: 50/50
    final half = _totalAmount / 2;
    _part1AmountController = TextEditingController(text: half.toStringAsFixed(2));
    
    _part1Category = widget.parentTransaction.category;
    _part1NoteController = TextEditingController(text: '${widget.parentTransaction.note ?? widget.parentTransaction.category.name} (Part 1)');
    
    _part2Category = Category.uncategorized;
    _part2NoteController = TextEditingController(text: '${widget.parentTransaction.note ?? widget.parentTransaction.category.name} (Part 2)');

    _part1AmountController.addListener(_onAmountChanged);
  }

  void _onAmountChanged() {
    setState(() {}); // Rebuild to update part 2 amount
  }

  @override
  void dispose() {
    _part1AmountController.removeListener(_onAmountChanged);
    _part1AmountController.dispose();
    _part1NoteController.dispose();
    _part2NoteController.dispose();
    super.dispose();
  }

  double get _part1Amount => double.tryParse(_part1AmountController.text) ?? 0;
  double get _part2Amount => (_totalAmount - _part1Amount).clamp(0, _totalAmount);

  void _submit() async {
    if (_part1Amount <= 0 || _part1Amount >= _totalAmount) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid split amount')),
      );
      return;
    }

    final repo = ref.read(transactionRepositoryProvider);
    final splitGroupId = const Uuid().v4();

    final part1 = widget.parentTransaction.copyWith(
      id: const Uuid().v4(),
      amount: _part1Amount,
      category: _part1Category,
      note: _part1NoteController.text.trim(),
      splitGroupId: splitGroupId,
    );

    final part2 = widget.parentTransaction.copyWith(
      id: const Uuid().v4(),
      amount: _part2Amount,
      category: _part2Category,
      note: _part2NoteController.text.trim(),
      splitGroupId: splitGroupId,
    );

    await repo.splitTransaction(widget.parentTransaction.id, [part1, part2]);
    HapticFeedback.mediumImpact();
    
    if (mounted) {
      // Pop the split sheet
      Navigator.of(context).pop();
      // Pop the add/edit sheet underneath it
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textStyles = context.textStyles;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colors.backgroundElevated,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colors.borderMid),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total Amount', style: textStyles.bodyLarge),
                Text(CurrencyFormatter.format(_totalAmount), style: textStyles.headingMedium),
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          // Part 1
          Text('Part 1', style: textStyles.headingSmall.copyWith(color: colors.accentPurple)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextField(
                  controller: _part1AmountController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: colors.textPrimary),
                  decoration: InputDecoration(
                    prefixText: '₹ ',
                    prefixStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: colors.textMuted),
                    labelText: 'Amount',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 3,
                child: DropdownButtonFormField<Category>(
                  value: _part1Category,
                  isExpanded: true,
                  dropdownColor: colors.backgroundSurface,
                  decoration: InputDecoration(labelText: 'Category', labelStyle: TextStyle(color: colors.textMuted)),
                  items: Category.values.map((c) => DropdownMenuItem(value: c, child: Text(c.name.capitalize()))).toList(),
                  onChanged: (val) => setState(() => _part1Category = val!),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _part1NoteController,
            decoration: InputDecoration(labelText: 'Note', labelStyle: TextStyle(color: colors.textMuted)),
          ),
          const SizedBox(height: 32),

          // Part 2
          Text('Part 2 (Auto-calculated)', style: textStyles.headingSmall.copyWith(color: colors.accentTeal)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(border: Border(bottom: BorderSide(color: colors.borderMid))),
                  child: Text(
                    '₹ ${CurrencyFormatter.format(_part2Amount)}',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: colors.textMuted),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 3,
                child: DropdownButtonFormField<Category>(
                  value: _part2Category,
                  isExpanded: true,
                  dropdownColor: colors.backgroundSurface,
                  decoration: InputDecoration(labelText: 'Category', labelStyle: TextStyle(color: colors.textMuted)),
                  items: Category.values.map((c) => DropdownMenuItem(value: c, child: Text(c.name.capitalize()))).toList(),
                  onChanged: (val) => setState(() => _part2Category = val!),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _part2NoteController,
            decoration: InputDecoration(labelText: 'Note', labelStyle: TextStyle(color: colors.textMuted)),
          ),
          
          const SizedBox(height: 40),
          AppButton(
            label: 'Confirm Split',
            onPressed: _part1Amount > 0 && _part1Amount < _totalAmount ? _submit : null,
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
