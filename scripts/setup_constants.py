import os

files = {
"lib/core/constants/app_constants.dart": """import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

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
""",

"lib/core/constants/category_keywords.dart": """class CategoryKeywords {
  static const Map<String, List<String>> kCategoryKeywords = {
    'food': ['zomato', 'swiggy', 'mcdonalds', 'kfc', 'dominos', 'eatbox', 'cafe', 'restaurant', 'dhaba', 'canteen', 'food', 'biryani', 'tea', 'coffee'],
    'transport': ['uber', 'ola', 'rapido', 'namma yatri', 'irctc', 'redbus', 'metro', 'petrol', 'fuel', 'hpcl', 'indianoil', 'bpcl', 'auto', 'rickshaw'],
    'academic': ['college', 'university', 'tuition', 'course', 'udemy', 'coursera', 'books', 'stationery', 'library', 'exam', 'fees', 'hostel'],
    'techTools': ['aws', 'digitalocean', 'github', 'domain', 'hosting', 'figma', 'adobe', 'jetbrains', 'chatgpt', 'openai', 'midjourney', 'vercel'],
    'subscriptions': ['netflix', 'amazon prime', 'hotstar', 'spotify', 'youtube premium', 'apple music', 'jio', 'airtel', 'vi', 'recharge', 'broadband', 'wifi'],
    'personal': ['amazon', 'flipkart', 'myntra', 'ajio', 'blinkit', 'zepto', 'instamart', 'pharmacy', 'apollo', 'medical', 'salon', 'haircut', 'gym'],
    'entertainment': ['bookmyshow', 'pvr', 'inox', 'gaming', 'steam', 'playstation', 'xbox', 'pub', 'club', 'event', 'concert'],
    'income': ['salary', 'freelance', 'fiverr', 'upwork', 'client', 'payment received', 'credited', 'tuition fee'],
  };

  static String? matchCategory(String text) {
    final lower = text.toLowerCase();
    for (final entry in kCategoryKeywords.entries) {
      for (final keyword in entry.value) {
        if (lower.contains(keyword)) {
          return entry.key;
        }
      }
    }
    return null;
  }

  static String getConfidence(String text, String category) {
    final lower = text.toLowerCase();
    final keywords = kCategoryKeywords[category] ?? [];
    int matchCount = 0;
    for (final keyword in keywords) {
      if (lower.contains(keyword)) {
        matchCount++;
      }
    }
    if (matchCount >= 2) return 'high';
    if (matchCount == 1) return 'medium';
    return 'low';
  }
}
""",

"lib/core/utils/currency_formatter.dart": """import 'package:intl/intl.dart';

class CurrencyFormatter {
  static final NumberFormat _format = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 0,
  );

  static String format(double amount) {
    return _format.format(amount);
  }
}
""",

"lib/core/utils/date_helpers.dart": """class DateHelpers {
  static DateTime getStartOfMonth(int month, int year) {
    return DateTime(year, month, 1);
  }

  static DateTime getEndOfMonth(int month, int year) {
    return DateTime(year, month + 1, 0, 23, 59, 59, 999);
  }

  static String formatMonthYear(int month, int year) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[month - 1]} $year';
  }
}
""",

"lib/core/utils/extensions.dart": """extension FastHashExtension on String {
  int get fastHash {
    var hash = 0xcbf29ce484222325;
    var i = 0;
    while (i < length) {
      final codeUnit = codeUnitAt(i++);
      hash ^= codeUnit >> 8;
      hash *= 0x100000001b3;
      hash ^= codeUnit & 0xFF;
      hash *= 0x100000001b3;
    }
    return hash;
  }
}
"""
}

for path, content in files.items():
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, "w", encoding="utf-8") as f:
        f.write(content.strip())
