import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/di/providers.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/currency_formatter.dart';
import '../../widgets/common/glass_panel.dart';

class SubscriptionsScreen extends ConsumerWidget {
  const SubscriptionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(recentTransactionsProvider);
    final colors = context.colors;
    final textStyles = context.textStyles;

    return Scaffold(
      appBar: AppBar(
        title: Text('Subscriptions', style: textStyles.headingLarge),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: colors.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: transactionsAsync.when(
        data: (transactions) {
          // Find subscriptions
          final subTxns = transactions.where((t) => t.category == Category.subscriptions).toList();
          
          // Group by merchant
          final Map<String, double> subs = {};
          for (var t in subTxns) {
            final m = t.merchantName ?? 'Unknown Service';
            if (!subs.containsKey(m)) {
              subs[m] = t.amount;
            }
          }

          if (subs.isEmpty) {
            return Center(
              child: Text(
                'No active subscriptions found.\n(Categorize transactions as Subscriptions)',
                textAlign: TextAlign.center,
                style: textStyles.bodyLarge.copyWith(color: colors.textMuted),
              ),
            );
          }

          final total = subs.values.fold<double>(0, (a, b) => a + b);

          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              GlassPanel(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Text('Total Monthly', style: textStyles.bodyMedium),
                    const SizedBox(height: 8),
                    Text(
                      CurrencyFormatter.format(total),
                      style: textStyles.displayMedium.copyWith(color: colors.accentRed),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Text('Active Services', style: textStyles.headingMedium),
              const SizedBox(height: 16),
              ...subs.entries.map((e) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: GlassPanel(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Row(
                      children: [
                        Icon(Icons.autorenew_rounded, color: colors.accentPurple),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(e.key, style: textStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
                        ),
                        Text(
                          CurrencyFormatter.format(e.value),
                          style: textStyles.bodyLarge.copyWith(color: colors.textPrimary),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          );
        },
        loading: () => Center(child: CircularProgressIndicator(color: colors.accentPurple)),
        error: (e, s) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
