import 'dart:io';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../models/transaction.dart';
import '../../core/constants/app_constants.dart';

class CsvExportService {
  static Future<void> exportTransactions(List<Transaction> transactions) async {
    List<List<dynamic>> rows = [];
    
    // Header
    rows.add([
      "ID",
      "Date",
      "Amount",
      "Direction",
      "Category",
      "Merchant Name",
      "Payment Method",
      "UPI Ref ID",
      "Bank Source",
      "Confirmed",
      "Note"
    ]);

    // Data
    for (var t in transactions) {
      rows.add([
        t.id,
        t.date.toIso8601String(),
        t.amount,
        t.direction.name,
        t.category.name,
        t.merchantName ?? "",
        t.paymentMethod.name,
        t.upiRefId ?? "",
        t.bankSource ?? "",
        t.isConfirmed,
        t.note ?? "",
      ]);
    }

    String csvStr = rows.map((row) => row.map((cell) => '"${cell.toString().replaceAll('"', '""')}"').join(',')).join('\n');

    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/transactions_export.csv');
    await file.writeAsString(csvStr);

    await Share.shareXFiles([XFile(file.path)], text: 'FreelanceFlow Transactions Export');
  }

  static Future<void> exportJson(String jsonStr) async {
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/freelanceflow_backup.json');
    await file.writeAsString(jsonStr);

    await Share.shareXFiles([XFile(file.path)], text: 'FreelanceFlow Backup Data');
  }
}
