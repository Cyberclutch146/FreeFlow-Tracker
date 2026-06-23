import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../core/di/providers.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/common/app_bottom_sheet.dart';
import '../../widgets/common/app_button.dart';
import '../../models/savings_goal.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/extensions.dart';
import 'package:intl/intl.dart';

class AddGoalSheet extends ConsumerStatefulWidget {
  final SavingsGoal? existingGoal;
  const AddGoalSheet({super.key, this.existingGoal});

  static Future<void> show(BuildContext context, {SavingsGoal? existingGoal}) {
    return AppBottomSheet.show(
      context,
      title: existingGoal == null ? 'Add Savings Goal' : 'Edit Goal',
      child: AddGoalSheet(existingGoal: existingGoal),
    );
  }

  @override
  ConsumerState<AddGoalSheet> createState() => _AddGoalSheetState();
}

class _AddGoalSheetState extends ConsumerState<AddGoalSheet> {
  late TextEditingController _nameController;
  late TextEditingController _emojiController;
  late TextEditingController _targetController;
  late TextEditingController _monthlyController;
  
  late Priority _priority;
  DateTime? _deadline;

  @override
  void initState() {
    super.initState();
    final g = widget.existingGoal;
    _nameController = TextEditingController(text: g?.name ?? '');
    _emojiController = TextEditingController(text: g?.emoji ?? '🎯');
    _targetController = TextEditingController(text: g != null ? g.targetAmount.toString() : '');
    _monthlyController = TextEditingController(text: g != null ? g.monthlyAllocation.toString() : '');
    _priority = g?.priority ?? Priority.medium;
    _deadline = g?.deadline;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emojiController.dispose();
    _targetController.dispose();
    _monthlyController.dispose();
    super.dispose();
  }

  void _submit() async {
    final name = _nameController.text.trim();
    final emoji = _emojiController.text.trim();
    final targetText = _targetController.text.trim();
    final monthlyText = _monthlyController.text.trim();
    
    if (name.isEmpty || emoji.isEmpty || targetText.isEmpty) return;
    
    final target = double.tryParse(targetText);
    final monthly = double.tryParse(monthlyText) ?? 0.0;
    if (target == null || target <= 0) return;

    final repo = ref.read(goalRepositoryProvider);
    final goal = SavingsGoal(
      id: widget.existingGoal?.id ?? const Uuid().v4(),
      name: name,
      emoji: emoji,
      targetAmount: target,
      currentAmount: widget.existingGoal?.currentAmount ?? 0.0,
      deadline: _deadline,
      priority: _priority,
      status: widget.existingGoal?.status ?? GoalStatus.active,
      monthlyAllocation: monthly,
      createdAt: widget.existingGoal?.createdAt ?? DateTime.now(),
    );

    await repo.save(goal);
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  Future<void> _pickDeadline() async {
    final colors = context.colors;
    final picked = await showDatePicker(
      context: context,
      initialDate: _deadline ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: colors.accentTeal,
              onPrimary: colors.textPrimary,
              surface: colors.backgroundSurface,
              onSurface: colors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _deadline = picked);
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
          Row(
            children: [
              SizedBox(
                width: 60,
                child: TextField(
                  controller: _emojiController,
                  style: const TextStyle(fontSize: 24),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    labelText: 'Icon',
                    labelStyle: TextStyle(color: colors.textMuted, fontSize: 12),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Goal Name',
                    labelStyle: TextStyle(color: colors.textMuted),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _targetController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: colors.textPrimary),
            decoration: InputDecoration(
              prefixText: '₹ ',
              prefixStyle: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: colors.textMuted),
              hintText: '0',
              border: InputBorder.none,
              labelText: 'Target Amount',
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _monthlyController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: 'Monthly Allocation (Optional)',
                    labelStyle: TextStyle(color: colors.textMuted),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<Priority>(
                  initialValue: _priority,
                  isExpanded: true,
                  dropdownColor: colors.backgroundSurface,
                  decoration: InputDecoration(
                    labelText: 'Priority',
                    labelStyle: TextStyle(color: colors.textMuted),
                  ),
                  items: Priority.values.map((s) {
                    return DropdownMenuItem(
                      value: s,
                      child: Text(
                        s.name.capitalize(),
                        style: textStyles.bodyLarge,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _priority = val);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: _pickDeadline,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                border: Border.all(color: colors.borderMid),
                borderRadius: BorderRadius.circular(12),
                color: colors.backgroundElevated,
              ),
              child: Row(
                children: [
                  Icon(Icons.event_rounded, color: colors.textMuted, size: 20),
                  const SizedBox(width: 12),
                  Text(
                    _deadline != null ? DateFormat('dd MMM yyyy').format(_deadline!) : 'Set Deadline (Optional)',
                    style: textStyles.bodyLarge,
                  ),
                  if (_deadline != null) ...[
                    const Spacer(),
                    GestureDetector(
                      onTap: () => setState(() => _deadline = null),
                      child: Icon(Icons.close_rounded, size: 18, color: colors.textMuted),
                    ),
                  ]
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
          AppButton(
            label: widget.existingGoal == null ? 'Create Goal' : 'Update Goal',
            onPressed: _submit,
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
