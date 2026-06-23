
enum TransactionDirection { debit, credit }
enum Category { food, transport, academic, techTools, subscriptions, personal, entertainment, income, uncategorized }
enum PaymentMethod { upi, cash, card, unknown }
enum RecurringFrequency { weekly, monthly }
enum Confidence { high, medium, low }
enum ProjectStatus { ongoing, completed, unpaid }
enum Priority { high, medium, low }
enum GoalStatus { active, paused, completed }
enum InsightType { info, warning, success, danger }
enum AppThemeMode { dark, oled, light }
enum IncomeSource { freelancing, tuitions }
enum AdvisorActionType { pauseGoal, setBudget, navigate }

class AppConstants {
  static const List<String> kCategories = [
    'food', 'transport', 'academic', 'techTools',
    'subscriptions', 'personal', 'entertainment', 'income', 'uncategorized'
  ];

  static const String kDbName = 'freelanceflow';
  static const int kDbVersion = 1;
  static const String kSettingsSingletonId = 'singleton';
  static const List<String> kPaymentMethods = ['upi', 'cash', 'card', 'unknown'];
  static const List<String> kRecurringFrequencies = ['weekly', 'monthly'];
  static const double kBudgetWarningThreshold = 0.80;
  static const int kPendingIncomeWarningDays = 7;
  static const int kSmsHistoryMonths = 6;
}