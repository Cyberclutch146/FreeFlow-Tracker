import os

files = {
"lib/screens/home/home_screen.dart": """import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/di/providers.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/common/app_card.dart';
import '../../core/utils/currency_formatter.dart';
import '../../models/transaction.dart';
import '../../core/constants/app_constants.dart';
import '../transactions/add_transaction_sheet.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(recentTransactionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: transactionsAsync.when(
        data: (transactions) {
          double income = 0;
          double expense = 0;
          for (var t in transactions) {
            if (t.direction == TransactionDirection.credit) {
              income += t.amount;
            } else {
              expense += t.amount;
            }
          }
          final balance = income - expense;

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(recentTransactionsProvider);
            },
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                _buildSummaryCard(balance, income, expense),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Recent Transactions', style: AppTextStyles.headingSmall),
                    TextButton(
                      onPressed: () {},
                      child: const Text('See All'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (transactions.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Text('No transactions yet', style: AppTextStyles.bodyMedium),
                    ),
                  )
                else
                  ...transactions.take(5).map((t) => _buildTransactionTile(t)).toList(),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.accentPurple,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          AddTransactionSheet.show(context);
        },
      ),
    );
  }

  Widget _buildSummaryCard(double balance, double income, double expense) {
    return AppCard(
      glowColor: AppColors.accentPurple,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Current Balance', style: AppTextStyles.bodyMedium),
          const SizedBox(height: 8),
          Text(
            CurrencyFormatter.format(balance),
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _buildStat('Income', income, AppColors.accentGreen, Icons.arrow_downward_rounded),
              ),
              Container(width: 1, height: 40, color: AppColors.borderSubtle),
              Expanded(
                child: _buildStat('Expense', expense, AppColors.accentRed, Icons.arrow_upward_rounded),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String label, double amount, Color color, IconData icon) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 4),
            Text(label, style: AppTextStyles.bodySmall),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          CurrencyFormatter.format(amount),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionTile(Transaction t) {
    final isIncome = t.direction == TransactionDirection.credit;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.backgroundSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderSubtle, width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isIncome ? AppColors.accentGreen.withOpacity(0.1) : AppColors.accentRed.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isIncome ? Icons.attach_money_rounded : Icons.shopping_bag_rounded,
              color: isIncome ? AppColors.accentGreen : AppColors.accentRed,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t.note?.isNotEmpty == true ? t.note! : t.category.name.toUpperCase(),
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: AppColors.textPrimary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '\${t.date.day}/\${t.date.month}/\${t.date.year} • \${t.paymentMethod.name.toUpperCase()}',
                  style: AppTextStyles.bodySmall,
                ),
              ],
            ),
          ),
          Text(
            '\${isIncome ? '+' : '-'}${CurrencyFormatter.format(t.amount)}',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: isIncome ? AppColors.accentGreen : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
""",

"lib/core/di/providers.dart": """import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../database/database_service.dart';
import '../../repositories/transaction_repository.dart';
import '../../repositories/project_repository.dart';
import '../../repositories/student_repository.dart';
import '../../repositories/goal_repository.dart';
import '../../repositories/budget_repository.dart';
import '../../repositories/settings_repository.dart';
import '../../services/sms_service.dart';
import '../../services/insights_engine.dart';
import '../../services/savings_advisor.dart';
import '../../widgets/navigation/main_scaffold.dart';
import '../../screens/home/home_screen.dart';
import '../../screens/transactions/transactions_screen.dart';
import '../../screens/income/income_screen.dart';
import '../../screens/goals/goals_screen.dart';
import '../../screens/reports/reports_screen.dart';
import '../../screens/settings/settings_screen.dart';
import '../../models/transaction.dart';

final databaseServiceProvider = Provider((ref) => DatabaseService());

final transactionRepositoryProvider = Provider((ref) =>
  TransactionRepository(ref.read(databaseServiceProvider)));

final goalRepositoryProvider = Provider((ref) =>
  GoalRepository(ref.read(databaseServiceProvider)));

final budgetRepositoryProvider = Provider((ref) =>
  BudgetRepository(ref.read(databaseServiceProvider)));

final settingsRepositoryProvider = Provider((ref) =>
  SettingsRepository(ref.read(databaseServiceProvider)));

final projectRepositoryProvider = Provider((ref) =>
  ProjectRepository(ref.read(databaseServiceProvider)));

final studentRepositoryProvider = Provider((ref) =>
  StudentRepository(ref.read(databaseServiceProvider)));

final smsServiceProvider = Provider((ref) => SmsService());

final insightsEngineProvider = Provider((ref) => InsightsEngine());

final savingsAdvisorProvider = Provider((ref) => SavingsAdvisor());

final settingsProvider = FutureProvider((ref) =>
  ref.read(settingsRepositoryProvider).get());

final recentTransactionsProvider = StreamProvider<List<Transaction>>((ref) {
  return ref.watch(transactionRepositoryProvider).watchAll();
});

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/home',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainScaffold(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(routes: [GoRoute(path: '/home', builder: (context, state) => const HomeScreen())]),
          StatefulShellBranch(routes: [GoRoute(path: '/transactions', builder: (context, state) => const TransactionsScreen())]),
          StatefulShellBranch(routes: [GoRoute(path: '/income', builder: (context, state) => const IncomeScreen())]),
          StatefulShellBranch(routes: [GoRoute(path: '/goals', builder: (context, state) => const GoalsScreen())]),
          StatefulShellBranch(routes: [GoRoute(path: '/reports', builder: (context, state) => const ReportsScreen())]),
        ],
      ),
      GoRoute(path: '/settings', builder: (context, state) => const SettingsScreen()),
    ],
  );
});
""",

"lib/screens/transactions/add_transaction_sheet.dart": """import 'package:flutter/material.dart';
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
                  backgroundColor: AppColors.backgroundBase,
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
                  selectedColor: AppColors.accentGreen.withOpacity(0.2),
                  backgroundColor: AppColors.backgroundBase,
                  labelStyle: TextStyle(
                    color: _direction == TransactionDirection.credit ? AppColors.accentGreen : AppColors.textMuted,
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
""",

"lib/screens/transactions/transactions_screen.dart": """import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/di/providers.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/currency_formatter.dart';
import '../../models/transaction.dart';
import '../../core/constants/app_constants.dart';
import '../../widgets/common/empty_state.dart';
import 'add_transaction_sheet.dart';

class TransactionsScreen extends ConsumerWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(recentTransactionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Transactions'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: transactionsAsync.when(
        data: (transactions) {
          if (transactions.isEmpty) {
            return const EmptyState(
              icon: Icons.receipt_long_rounded,
              title: 'No transactions yet.',
              subtitle: 'Import from SMS or add manually.',
            );
          }
          
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final t = transactions[index];
              return _buildTransactionTile(t);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.accentPurple,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          AddTransactionSheet.show(context);
        },
      ),
    );
  }

  Widget _buildTransactionTile(Transaction t) {
    final isIncome = t.direction == TransactionDirection.credit;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.backgroundSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderSubtle, width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isIncome ? AppColors.accentGreen.withOpacity(0.1) : AppColors.accentRed.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isIncome ? Icons.attach_money_rounded : Icons.shopping_bag_rounded,
              color: isIncome ? AppColors.accentGreen : AppColors.accentRed,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t.note?.isNotEmpty == true ? t.note! : t.category.name.toUpperCase(),
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: AppColors.textPrimary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '\${t.date.day}/\${t.date.month}/\${t.date.year} • \${t.paymentMethod.name.toUpperCase()}',
                  style: AppTextStyles.bodySmall,
                ),
              ],
            ),
          ),
          Text(
            '\${isIncome ? '+' : '-'}${CurrencyFormatter.format(t.amount)}',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: isIncome ? AppColors.accentGreen : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
"""
}

for path, content in files.items():
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, "w", encoding="utf-8") as f:
        f.write(content.strip())
