import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
import '../../database/database_service.dart';
import '../../models/app_settings.dart';

import '../../core/constants/app_constants.dart';

class CurrencyFormatter {
  static String format(double amount) {
    String symbol = '₹';
    try {
      final isar = Isar.getInstance(AppConstants.kDbName);
      final settings = isar?.appSettings.where().findFirstSync();
      if (settings != null) {
        symbol = settings.currencySymbol;
      }
    } catch (e) {
      // Fallback if db not initialized
    }
    
    final fmt = NumberFormat.currency(
      locale: 'en_IN',
      symbol: symbol,
      decimalDigits: 0,
    );
    return fmt.format(amount);
  }
}