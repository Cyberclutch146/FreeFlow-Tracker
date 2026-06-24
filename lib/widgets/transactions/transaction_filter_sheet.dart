import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/transaction.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/extensions.dart';

class TransactionFilterOptions {
  final TransactionDirection? direction;
  final Category? category;
  final PaymentMethod? paymentMethod;
  final DateTime? startDate;
  final DateTime? endDate;

  const TransactionFilterOptions({
    this.direction,
    this.category,
    this.paymentMethod,
    this.startDate,
    this.endDate,
  });

  TransactionFilterOptions copyWith({
    TransactionDirection? direction,
    bool clearDirection = false,
    Category? category,
    bool clearCategory = false,
    PaymentMethod? paymentMethod,
    bool clearPaymentMethod = false,
    DateTime? startDate,
    bool clearStartDate = false,
    DateTime? endDate,
    bool clearEndDate = false,
  }) {
    return TransactionFilterOptions(
      direction: clearDirection ? null : (direction ?? this.direction),
      category: clearCategory ? null : (category ?? this.category),
      paymentMethod: clearPaymentMethod ? null : (paymentMethod ?? this.paymentMethod),
      startDate: clearStartDate ? null : (startDate ?? this.startDate),
      endDate: clearEndDate ? null : (endDate ?? this.endDate),
    );
  }

  bool get isEmpty =>
      direction == null &&
      category == null &&
      paymentMethod == null &&
      startDate == null &&
      endDate == null;
}

class TransactionFilterSheet extends StatefulWidget {
  final TransactionFilterOptions initialFilter;

  const TransactionFilterSheet({
    super.key,
    required this.initialFilter,
  });

  static Future<TransactionFilterOptions?> show(BuildContext context, TransactionFilterOptions initialFilter) {
    return showModalBottomSheet<TransactionFilterOptions>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => TransactionFilterSheet(initialFilter: initialFilter),
    );
  }

  @override
  State<TransactionFilterSheet> createState() => _TransactionFilterSheetState();
}

class _TransactionFilterSheetState extends State<TransactionFilterSheet> {
  late TransactionFilterOptions _filter;

  @override
  void initState() {
    super.initState();
    _filter = widget.initialFilter;
  }

  Future<void> _pickDateRange(AppColors colors) async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      initialDateRange: _filter.startDate != null && _filter.endDate != null
          ? DateTimeRange(start: _filter.startDate!, end: _filter.endDate!)
          : null,
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

    if (picked != null) {
      setState(() {
        _filter = _filter.copyWith(
          startDate: picked.start,
          endDate: picked.end,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textStyles = context.textStyles;

    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: colors.backgroundSurface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        border: Border.all(color: colors.borderSubtle, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 12),
          Center(
            child: Container(
              width: 48,
              height: 4,
              decoration: BoxDecoration(
                color: colors.textMuted.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Filter Transactions', style: textStyles.headingMedium),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _filter = const TransactionFilterOptions();
                    });
                  },
                  child: Text('Reset', style: TextStyle(color: colors.accentRed)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              children: [
                Text('Direction', style: textStyles.headingSmall),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  children: [
                    _buildChip(
                      label: 'All',
                      selected: _filter.direction == null,
                      onSelected: (val) => setState(() => _filter = _filter.copyWith(clearDirection: true)),
                      colors: colors,
                    ),
                    _buildChip(
                      label: 'Expense',
                      selected: _filter.direction == TransactionDirection.debit,
                      onSelected: (val) => setState(() => _filter = _filter.copyWith(direction: TransactionDirection.debit)),
                      colors: colors,
                      activeColor: colors.accentRed,
                    ),
                    _buildChip(
                      label: 'Income',
                      selected: _filter.direction == TransactionDirection.credit,
                      onSelected: (val) => setState(() => _filter = _filter.copyWith(direction: TransactionDirection.credit)),
                      colors: colors,
                      activeColor: colors.accentTeal,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                Text('Date Range', style: textStyles.headingSmall),
                const SizedBox(height: 12),
                InkWell(
                  onTap: () => _pickDateRange(colors),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: colors.borderMid),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _filter.startDate != null && _filter.endDate != null
                              ? '${_filter.startDate!.day}/${_filter.startDate!.month} - ${_filter.endDate!.day}/${_filter.endDate!.month}'
                              : 'Select date range',
                          style: _filter.startDate != null ? textStyles.bodyLarge : textStyles.bodyLarge.copyWith(color: colors.textMuted),
                        ),
                        if (_filter.startDate != null)
                          GestureDetector(
                            onTap: () => setState(() => _filter = _filter.copyWith(clearStartDate: true, clearEndDate: true)),
                            child: Icon(Icons.close, color: colors.textMuted, size: 20),
                          )
                        else
                          Icon(Icons.calendar_month, color: colors.textMuted, size: 20),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                Text('Category', style: textStyles.headingSmall),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: Category.values.map((c) {
                    return _buildChip(
                      label: c.name.capitalize(),
                      selected: _filter.category == c,
                      onSelected: (val) => setState(() => _filter = _filter.copyWith(category: val ? c : null, clearCategory: !val)),
                      colors: colors,
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),

                Text('Payment Method', style: textStyles.headingSmall),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: PaymentMethod.values.map((p) {
                    return _buildChip(
                      label: p.name.capitalize(),
                      selected: _filter.paymentMethod == p,
                      onSelected: (val) => setState(() => _filter = _filter.copyWith(paymentMethod: val ? p : null, clearPaymentMethod: !val)),
                      colors: colors,
                    );
                  }).toList(),
                ),
                const SizedBox(height: 48),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context, _filter),
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.accentPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text('Apply Filters', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChip({
    required String label,
    required bool selected,
    required Function(bool) onSelected,
    required AppColors colors,
    Color? activeColor,
  }) {
    final themeColor = activeColor ?? colors.accentPurple;
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: onSelected,
      selectedColor: themeColor.withValues(alpha: 0.2),
      backgroundColor: colors.backgroundPrimary,
      side: BorderSide(color: selected ? themeColor : colors.borderMid),
      labelStyle: TextStyle(
        color: selected ? themeColor : colors.textMuted,
        fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
      ),
    );
  }
}
