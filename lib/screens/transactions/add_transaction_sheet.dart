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
import '../../core/utils/extensions.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'split_transaction_sheet.dart';

class AddTransactionSheet extends ConsumerStatefulWidget {
  final Transaction? existingTransaction;
  const AddTransactionSheet({super.key, this.existingTransaction});

  static Future<void> show(BuildContext context, {Transaction? existingTransaction}) {
    return AppBottomSheet.show(
      context,
      title: existingTransaction == null ? 'Add Transaction' : 'Edit Transaction',
      child: AddTransactionSheet(existingTransaction: existingTransaction),
    );
  }

  @override
  ConsumerState<AddTransactionSheet> createState() => _AddTransactionSheetState();
}

class _AddTransactionSheetState extends ConsumerState<AddTransactionSheet> {
  late TextEditingController _amountController;
  late TextEditingController _noteController;
  
  late TransactionDirection _direction;
  late Category _category;
  late PaymentMethod _paymentMethod;
  late DateTime _date;
  List<String> _receiptImagePaths = [];

  @override
  void initState() {
    super.initState();
    final t = widget.existingTransaction;
    _amountController = TextEditingController(text: t != null ? t.amount.toString() : '');
    _noteController = TextEditingController(text: t?.note ?? '');
    _direction = t?.direction ?? TransactionDirection.debit;
    _category = t?.category ?? Category.food;
    _paymentMethod = t?.paymentMethod ?? PaymentMethod.upi;
    _date = t?.date ?? DateTime.now();
    _receiptImagePaths = List.from(t?.receiptImagePaths ?? []);
  }

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
      id: widget.existingTransaction?.id ?? const Uuid().v4(),
      amount: amount,
      direction: _direction,
      category: _category,
      note: _noteController.text.trim(),
      date: _date,
      paymentMethod: _paymentMethod,
      isRecurring: widget.existingTransaction?.isRecurring ?? false,
      confidence: widget.existingTransaction?.confidence ?? Confidence.high,
      isConfirmed: true,
      receiptImagePaths: _receiptImagePaths,
    );

    await repo.save(transaction);
    HapticFeedback.mediumImpact();
    
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  Future<void> _pickDate() async {
    final colors = context.colors;
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: colors.accentPurple,
              onPrimary: colors.textPrimary,
              surface: colors.backgroundSurface,
              onSurface: colors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _date) {
      setState(() => _date = picked);
    }
  }

  Future<void> _pickReceipt() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    
    if (pickedFile != null) {
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = '${const Uuid().v4()}${path.extension(pickedFile.path)}';
      final savedImage = await File(pickedFile.path).copy('${appDir.path}/$fileName');
      
      setState(() {
        _receiptImagePaths.add(savedImage.path);
      });
    }
  }

  void _removeReceipt(int index) {
    setState(() {
      _receiptImagePaths.removeAt(index);
    });
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
              Expanded(
                child: ChoiceChip(
                  label: const Text('Expense'),
                  selected: _direction == TransactionDirection.debit,
                  onSelected: (val) => setState(() => _direction = TransactionDirection.debit),
                  selectedColor: colors.accentRed.withValues(alpha: 0.2),
                  backgroundColor: colors.backgroundPrimary,
                  side: BorderSide(color: _direction == TransactionDirection.debit ? colors.accentRed : colors.borderMid),
                  labelStyle: TextStyle(
                    color: _direction == TransactionDirection.debit ? colors.accentRed : colors.textMuted,
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
                  selectedColor: colors.accentTeal.withValues(alpha: 0.2),
                  backgroundColor: colors.backgroundPrimary,
                  side: BorderSide(color: _direction == TransactionDirection.credit ? colors.accentTeal : colors.borderMid),
                  labelStyle: TextStyle(
                    color: _direction == TransactionDirection.credit ? colors.accentTeal : colors.textMuted,
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
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: colors.textPrimary),
            decoration: InputDecoration(
              prefixText: '₹ ',
              prefixStyle: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: colors.textMuted),
              hintText: '0',
              border: InputBorder.none,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<Category>(
                  initialValue: _category,
                  isExpanded: true,
                  dropdownColor: colors.backgroundSurface,
                  decoration: InputDecoration(
                    labelText: 'Category',
                    labelStyle: TextStyle(color: colors.textMuted),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: colors.borderMid),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: colors.accentPurple),
                    ),
                  ),
                  items: Category.values.map((c) {
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
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<PaymentMethod>(
                  initialValue: _paymentMethod,
                  isExpanded: true,
                  dropdownColor: colors.backgroundSurface,
                  decoration: InputDecoration(
                    labelText: 'Method',
                    labelStyle: TextStyle(color: colors.textMuted),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: colors.borderMid),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: colors.accentPurple),
                    ),
                  ),
                  items: PaymentMethod.values.map((p) {
                    return DropdownMenuItem(
                      value: p,
                      child: Text(
                        p.name.capitalize(),
                        style: textStyles.bodyLarge,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _paymentMethod = val);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: _pickDate,
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
                  Icon(Icons.calendar_month_rounded, color: colors.textMuted, size: 20),
                  const SizedBox(width: 12),
                  Text(
                    DateFormat('dd MMM yyyy').format(_date),
                    style: textStyles.bodyLarge,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _noteController,
            decoration: InputDecoration(
              labelText: 'Note (Optional)',
              labelStyle: TextStyle(color: colors.textMuted),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: colors.borderMid),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: colors.accentPurple),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text('Receipts', style: TextStyle(color: colors.textMuted, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _receiptImagePaths.length + 1,
              itemBuilder: (context, index) {
                if (index == _receiptImagePaths.length) {
                  return GestureDetector(
                    onTap: _pickReceipt,
                    child: Container(
                      width: 80,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: colors.backgroundElevated,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: colors.borderMid, style: BorderStyle.solid),
                      ),
                      child: Icon(Icons.add_a_photo, color: colors.textMuted),
                    ),
                  );
                }
                
                final imgPath = _receiptImagePaths[index];
                return Container(
                  width: 80,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: FileImage(File(imgPath)),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: () => _removeReceipt(index),
                      child: Container(
                        margin: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close, size: 16, color: Colors.white),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          AppButton(
            label: widget.existingTransaction == null ? 'Save Transaction' : 'Update Transaction',
            onPressed: _submit,
          ),
          if (widget.existingTransaction != null) ...[
            const SizedBox(height: 16),
            Center(
              child: TextButton.icon(
                onPressed: () {
                  SplitTransactionSheet.show(context, parentTransaction: widget.existingTransaction!);
                },
                icon: Icon(Icons.call_split_rounded, color: colors.accentAmber),
                label: Text('Split this transaction', style: TextStyle(color: colors.accentAmber, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}