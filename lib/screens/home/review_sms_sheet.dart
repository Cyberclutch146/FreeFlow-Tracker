import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../core/di/providers.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';

class ReviewSmsSheet extends ConsumerWidget {
  const ReviewSmsSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const ReviewSmsSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final textStyles = context.textStyles;
    
    // We use the same unconfirmedTransactionsProvider created earlier
    final unconfirmedAsync = ref.watch(unconfirmedTransactionsProvider);

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: colors.backgroundElevated,
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
                Text('Unconfirmed SMS', style: textStyles.headingMedium),
                IconButton(
                  icon: Icon(Icons.close_rounded, color: colors.textMuted),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: unconfirmedAsync.when(
              data: (txns) {
                if (txns.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle_outline_rounded, color: colors.accentTeal, size: 64)
                            .animate().scale(delay: 200.ms, duration: 400.ms, curve: Curves.easeOutBack),
                        const SizedBox(height: 16),
                        Text("You're all caught up!", style: textStyles.bodyLarge),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 32, left: 24, right: 24),
                  itemCount: txns.length,
                  itemBuilder: (context, index) {
                    final t = txns[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: colors.backgroundPrimary,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: colors.borderSubtle.withValues(alpha: 0.5)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: colors.accentPurple.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.sms_rounded, color: colors.accentPurple),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(t.merchantName ?? t.category.name, style: textStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
                                const SizedBox(height: 4),
                                Text(DateFormat('MMM d, h:mm a').format(t.date), style: textStyles.bodySmall.copyWith(color: colors.textMuted)),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${t.direction == TransactionDirection.credit ? '+' : '-'}₹${t.amount.toStringAsFixed(0)}',
                                style: textStyles.bodyLarge.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: t.direction == TransactionDirection.credit
                                      ? colors.accentTeal
                                      : colors.accentRed,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  InkWell(
                                    onTap: () async {
                                      final repo = ref.read(transactionRepositoryProvider);
                                      await repo.delete(t.id);
                                    },
                                    child: Icon(Icons.delete_outline_rounded, color: colors.accentRed, size: 24),
                                  ),
                                  const SizedBox(width: 16),
                                  InkWell(
                                    onTap: () async {
                                      final repo = ref.read(transactionRepositoryProvider);
                                      t.isConfirmed = true;
                                      await repo.save(t);
                                    },
                                    child: Icon(Icons.check_circle_outline_rounded, color: colors.accentTeal, size: 24),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ).animate().fadeIn(delay: (100 * index).ms).slideX(begin: 0.1);
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
