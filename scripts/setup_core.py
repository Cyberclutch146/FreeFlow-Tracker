import os

files = {
"lib/main.dart": """import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'database/database_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseService.initialize();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const ProviderScope(child: FreelanceFlowApp()));
}
""",

"lib/app.dart": """import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/di/providers.dart';

class FreelanceFlowApp extends ConsumerWidget {
  const FreelanceFlowApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      title: 'FreelanceFlow',
      theme: AppTheme.darkTheme,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
""",

"lib/core/theme/app_colors.dart": """import 'package:flutter/material.dart';

class AppColors {
  static const Color backgroundPrimary = Color(0xFF0A0A0F);
  static const Color backgroundSurface = Color(0xFF13131A);
  static const Color backgroundElevated = Color(0xFF1A1A24);
  static const Color borderSubtle = Color(0xFF1E1E2E);
  static const Color borderMid = Color(0xFF2A2A3A);
  static const Color accentPurple = Color(0xFF6C63FF);
  static const Color accentTeal = Color(0xFF00D4AA);
  static const Color accentAmber = Color(0xFFFFB830);
  static const Color accentRed = Color(0xFFFF6B6B);
  static const Color textPrimary = Color(0xFFF0F0FF);
  static const Color textSecondary = Color(0xFFAAAAAC);
  static const Color textMuted = Color(0xFF6B6B8A);
  static const Color textDisabled = Color(0xFF3A3A4A);
}
""",

"lib/core/theme/app_text_styles.dart": """import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  static const TextStyle displayLarge = TextStyle(fontSize: 32, fontWeight: FontWeight.w700, color: AppColors.textPrimary);
  static const TextStyle displayMedium = TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.textPrimary);
  static const TextStyle headingLarge = TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.textPrimary);
  static const TextStyle headingMedium = TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: AppColors.textPrimary);
  static const TextStyle headingSmall = TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary);
  static const TextStyle bodyLarge = TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: AppColors.textPrimary);
  static const TextStyle bodyMedium = TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: AppColors.textSecondary);
  static const TextStyle bodySmall = TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.textMuted);
  static const TextStyle labelLarge = TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textMuted);
  static const TextStyle labelSmall = TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: AppColors.textMuted);
  static const TextStyle moneyPositive = TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.accentTeal);
  static const TextStyle moneyNegative = TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.accentRed);
  static const TextStyle moneyNeutral = TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary);
}
""",

"lib/core/theme/app_theme.dart": """import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  static ThemeData get darkTheme {
    final base = ThemeData.dark();
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.backgroundPrimary,
      colorScheme: const ColorScheme.dark(
        surface: AppColors.backgroundSurface,
        primary: AppColors.accentPurple,
        secondary: AppColors.accentTeal,
        error: AppColors.accentRed,
        onSurface: AppColors.textPrimary,
      ),
      textTheme: GoogleFonts.interTextTheme(base.textTheme).copyWith(
        displayLarge: AppTextStyles.displayLarge,
        displayMedium: AppTextStyles.displayMedium,
        headlineLarge: AppTextStyles.headingLarge,
        headlineMedium: AppTextStyles.headingMedium,
        headlineSmall: AppTextStyles.headingSmall,
        bodyLarge: AppTextStyles.bodyLarge,
        bodyMedium: AppTextStyles.bodyMedium,
        bodySmall: AppTextStyles.bodySmall,
        labelLarge: AppTextStyles.labelLarge,
        labelSmall: AppTextStyles.labelSmall,
      ),
      cardTheme: CardTheme(
        color: AppColors.backgroundSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.borderSubtle, width: 1),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.backgroundPrimary,
        elevation: 0,
        titleTextStyle: AppTextStyles.headingLarge,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.backgroundSurface,
        selectedItemColor: AppColors.accentPurple,
        unselectedItemColor: AppColors.textMuted,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.backgroundElevated,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderSubtle),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderSubtle),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.accentPurple),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accentPurple,
          foregroundColor: AppColors.textPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          minimumSize: const Size.fromHeight(52),
          elevation: 0,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.accentPurple,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.borderSubtle,
        thickness: 1,
        space: 1,
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: AppColors.backgroundSurface,
        contentTextStyle: TextStyle(color: AppColors.textPrimary),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
""",

"lib/core/constants/app_constants.dart": """import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AppConstants {
  static const List<String> kCategories = [
    'Food', 'Transport', 'Academic', 'Tech/Tools',
    'Subscriptions', 'Personal', 'Entertainment', 'Income', 'Uncategorized'
  ];

  static const Map<String, IconData> kCategoryIcons = {
    'Food': Icons.restaurant,
    'Transport': Icons.directions_car,
    'Academic': Icons.school,
    'Tech/Tools': Icons.computer,
    'Subscriptions': Icons.subscriptions,
    'Personal': Icons.person,
    'Entertainment': Icons.sports_esports,
    'Income': Icons.account_balance_wallet,
    'Uncategorized': Icons.category,
  };

  static const Map<String, Color> kCategoryColors = {
    'Food': AppColors.accentAmber,
    'Transport': AppColors.accentTeal,
    'Academic': AppColors.accentPurple,
    'Tech/Tools': AppColors.textPrimary,
    'Subscriptions': AppColors.accentRed,
    'Personal': AppColors.textSecondary,
    'Entertainment': AppColors.accentTeal,
    'Income': AppColors.accentTeal,
    'Uncategorized': AppColors.textMuted,
  };

  static const String kDbName = 'freelanceflow';
  static const int kDbVersion = 1;
  static const String kSettingsSingletonId = 'singleton';
  static const List<String> kPaymentMethods = ['UPI', 'Cash', 'Card', 'Unknown'];
  static const List<String> kRecurringFrequencies = ['weekly', 'monthly'];
  static const double kBudgetWarningThreshold = 0.80;
  static const int kPendingIncomeWarningDays = 7;
  static const int kSmsHistoryMonths = 6;
}
""",

"lib/core/constants/category_keywords.dart": """class CategoryKeywords {
  static const Map<String, List<String>> kCategoryKeywords = {
    'Food': ['zomato', 'swiggy', 'mcdonalds', 'kfc', 'dominos', 'eatbox', 'cafe', 'restaurant', 'dhaba', 'canteen', 'food', 'biryani', 'tea', 'coffee'],
    'Transport': ['uber', 'ola', 'rapido', 'namma yatri', 'irctc', 'redbus', 'metro', 'petrol', 'fuel', 'hpcl', 'indianoil', 'bpcl', 'auto', 'rickshaw'],
    'Academic': ['college', 'university', 'tuition', 'course', 'udemy', 'coursera', 'books', 'stationery', 'library', 'exam', 'fees', 'hostel'],
    'Tech/Tools': ['aws', 'digitalocean', 'github', 'domain', 'hosting', 'figma', 'adobe', 'jetbrains', 'chatgpt', 'openai', 'midjourney', 'vercel'],
    'Subscriptions': ['netflix', 'amazon prime', 'hotstar', 'spotify', 'youtube premium', 'apple music', 'jio', 'airtel', 'vi', 'recharge', 'broadband', 'wifi'],
    'Personal': ['amazon', 'flipkart', 'myntra', 'ajio', 'blinkit', 'zepto', 'instamart', 'pharmacy', 'apollo', 'medical', 'salon', 'haircut', 'gym'],
    'Entertainment': ['bookmyshow', 'pvr', 'inox', 'gaming', 'steam', 'playstation', 'xbox', 'pub', 'club', 'event', 'concert'],
    'Income': ['salary', 'freelance', 'fiverr', 'upwork', 'client', 'payment received', 'credited', 'tuition fee'],
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
