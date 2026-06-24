import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../core/di/providers.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/common/app_bottom_sheet.dart';
import '../../widgets/common/app_button.dart';
import '../../models/budget.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/extensions.dart';

class AddBudgetSheet extends ConsumerStatefulWidget {
  final Budget? existingBudget;
  const AddBudgetSheet({super.key, this.existingBudget});

  static Future<void> show(BuildContext context, {Budget? existingBudget}) {
    return AppBottomSheet.show(
      context,
      title: existingBudget == null ? 'Set Budget' : 'Edit Budget',
      child: AddBudgetSheet(existingBudget: existingBudget),
    );
  }

  @override
  ConsumerState<AddBudgetSheet> createState() => _AddBudgetSheetState();
}

class _AddBudgetSheetState extends ConsumerState<AddBudgetSheet> {
  late TextEditingController _limitController;
  late Category _category;

  @override
  void initState() {
    super.initState();
    final b = widget.existingBudget;
    _limitController = TextEditingController(text: b != null ? b.monthlyLimit.toString() : '');
    _category = b?.category ?? Category.food;
  }

  @override
  void dispose() {
    _limitController.dispose();
    super.dispose();
  }

  void _submit() async {
    final limitText = _limitController.text.trim();
    
    if (limitText.isEmpty) return;
    
    final limit = double.tryParse(limitText);
    if (limit == null || limit <= 0) return;

    final repo = ref.read(budgetRepositoryProvider);
    final now = DateTime.now();
    final budget = Budget(
      id: widget.existingBudget?.id ?? const Uuid().v4(),
      category: _category,
      monthlyLimit: limit,
      month: widget.existingBudget?.month ?? now.month,
      year: widget.existingBudget?.year ?? now.year,
    );

    await repo.save(budget);
    if (mounted) {
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
          DropdownButtonFormField<Category>(
            initialValue: _category,
            isExpanded: true,
            dropdownColor: colors.backgroundSurface,
            decoration: InputDecoration(
              labelText: 'Category',
              labelStyle: TextStyle(color: colors.textMuted),
            ),
            items: Category.values.where((c) => c != Category.income).map((c) {
              return DropdownMenuItem(
                value: c,
                child: Text(
                  c.name.capitalize(),
                  style: textStyles.bodyLarge,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
            onChanged: (val) {
              if (val != null) setState(() => _category = val);
            },
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _limitController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: colors.textPrimary),
            decoration: InputDecoration(
              prefixText: '₹ ',
              prefixStyle: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: colors.textMuted),
              hintText: '0',
              border: InputBorder.none,
              labelText: 'Monthly Limit',
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
          ),
          const SizedBox(height: 32),
          AppButton(
            label: widget.existingBudget == null ? 'Set Budget' : 'Update Budget',
            onPressed: _submit,
            backgroundColor: colors.accentTeal,
            textColor: Colors.white,
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
