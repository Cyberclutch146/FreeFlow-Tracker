import 'dart:io';
import 'package:csv/csv.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import '../models/transaction.dart';
import '../core/constants/app_constants.dart';
import 'ai/category_classifier.dart';

class StatementParser {
  final _uuid = const Uuid();

  Future<List<Transaction>> parseCsv(String filePath, String statementId) async {
    final file = File(filePath);
    String input;
    try {
      input = await file.readAsString();
    } catch (_) {
      // Fallback to latin1 for legacy bank exports
      input = await file.readAsString(encoding: latin1);
    }
    
    // Some CSVs use \n instead of \r\n, replacing it ensures compatibility if the parser is strict
    input = input.replaceAll('\r\n', '\n');
    final customCsv = Csv(lineDelimiter: '\n');
    final fields = customCsv.decode(input);

    final transactions = <Transaction>[];
    if (fields.isEmpty) return transactions;

    int dateIndex = -1, descIndex = -1, debitIndex = -1, creditIndex = -1, amountIndex = -1, typeIndex = -1;
    int startIndex = 0;
    List<String> detectedHeader = [];

    // Scan the first 30 rows to find the header
    for (int i = 0; i < fields.length && i < 30; i++) {
      final row = fields[i].map((e) => e.toString().toLowerCase().trim()).toList();
      if (row.any((e) => e.contains('date'))) {
        detectedHeader = row;
        for (int j = 0; j < row.length; j++) {
          final col = row[j];
          if (col.contains('date')) dateIndex = j;
          if (col.contains('desc') || col.contains('narration') || col.contains('particulars') || col.contains('details')) descIndex = j;
          if (col.contains('debit') || col.contains('withdrawal') || col.contains('paid out') || col.contains('money out') || col.contains('dr amount') || col == 'dr' || col == 'dr.') debitIndex = j;
          if (col.contains('credit') || col.contains('deposit') || col.contains('paid in') || col.contains('money in') || col.contains('cr amount') || col == 'cr' || col == 'cr.') creditIndex = j;
          if (col.contains('amount') && !col.contains('dr amount') && !col.contains('cr amount')) amountIndex = j;
          if (col == 'type' || col == 'dr/cr' || col == 'cr/dr' || col == 'txn type' || col == 'transaction type') typeIndex = j;
        }
        startIndex = i + 1; // Data starts after header
        break;
      }
    }

    print('--- CSV PARSER DEBUG ---');
    print('Detected Header: $detectedHeader');
    print('Indices -> Date: $dateIndex, Desc: $descIndex, Amount: $amountIndex, Debit: $debitIndex, Credit: $creditIndex, Type: $typeIndex');


    // If we couldn't find a header, just assume standard format and start at 0
    if (dateIndex == -1) {
      dateIndex = 0; descIndex = 1; amountIndex = 2; startIndex = 0;
    }

    final maxRequiredIndex = [dateIndex, descIndex, amountIndex, debitIndex, creditIndex].reduce((a, b) => a > b ? a : b);

    for (int i = startIndex; i < fields.length; i++) {
      final row = fields[i];
      // Need enough columns to cover our required fields (maxRequiredIndex could be -1 if missing)
      if (row.length <= (dateIndex > descIndex ? dateIndex : descIndex)) continue;

      final dateStr = row[dateIndex].toString().trim();
      final desc = row[descIndex].toString().trim();
      if (dateStr.isEmpty) continue;

      double parsedAmount = 0.0;

      // Check explicit debit/credit columns first
      if (debitIndex != -1 && row.length > debitIndex) {
        final dStr = row[debitIndex].toString().replaceAll(RegExp(r'[^0-9.-]'), '');
        final d = double.tryParse(dStr) ?? 0.0;
        if (d > 0) parsedAmount = -d;
      }
      if (parsedAmount == 0 && creditIndex != -1 && row.length > creditIndex) {
        final cStr = row[creditIndex].toString().replaceAll(RegExp(r'[^0-9.-]'), '');
        final c = double.tryParse(cStr) ?? 0.0;
        if (c > 0) parsedAmount = c;
      }
      
      // Fallback to single amount column
      if (parsedAmount == 0 && amountIndex != -1 && row.length > amountIndex) {
        final aStr = row[amountIndex].toString().replaceAll(RegExp(r'[^0-9.-]'), '');
        parsedAmount = double.tryParse(aStr) ?? 0.0;
      }

      if (parsedAmount == 0) continue;

      // Adjust based on Type column if it exists
      if (typeIndex != -1 && row.length > typeIndex) {
        final tStr = row[typeIndex].toString().toLowerCase();
        if (tStr.contains('dr') || tStr.contains('debit')) {
          parsedAmount = -parsedAmount.abs();
        } else if (tStr.contains('cr') || tStr.contains('credit')) {
          parsedAmount = parsedAmount.abs();
        }
      }

      // Hack for Credit Card statements: if amount column is specifically called "debit" 
      // but numbers are positive, we handled it via debitIndex above!
      // But if there's no way to tell, we default to standard bank direction.
      
      final direction = parsedAmount < 0 ? TransactionDirection.debit : TransactionDirection.credit;
      final absAmount = parsedAmount.abs();

      DateTime date = DateTime.now();
      try {
        // Simple fallback parser for DD/MM/YYYY or YYYY-MM-DD
        final parts = dateStr.split(RegExp(r'[-/]'));
        if (parts.length == 3) {
           if (parts[0].length == 4) {
             date = DateTime.parse(dateStr.replaceAll('/', '-'));
           } else if (parts[2].length == 4) {
             date = DateTime(int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));
           } else {
             date = DateTime.parse(dateStr);
           }
        } else {
           date = DateTime.parse(dateStr);
        }
      } catch (_) {}

      // Categorize locally
      final catMap = CategoryClassifier.batchClassifyNamed([desc]);
      Category category = Category.uncategorized;
      try {
        final catStr = catMap[desc];
        if (catStr != null) {
          category = Category.values.firstWhere((e) => e.name == catStr);
        }
      } catch (_) {}

      transactions.add(Transaction(
        id: _uuid.v4(),
        amount: absAmount,
        direction: direction,
        category: category,
        date: date,
        paymentMethod: PaymentMethod.unknown,
        isRecurring: false,
        confidence: Confidence.high,
        isConfirmed: true,
        merchantName: desc.length > 20 ? desc.substring(0, 20) : desc,
        statementId: statementId,
      ));
    }
    return transactions;
  }

  Future<List<Transaction>> parsePdfLocal(String path, String statementId) async {
    final bytes = await File(path).readAsBytes();
    final document = PdfDocument(inputBytes: bytes);
    final text = PdfTextExtractor(document).extractText();
    document.dispose();

    final lines = text.split('\n');
    final transactions = <Transaction>[];

    // Regex to match the PNB PDF format (and similar formats):
    // "26/06/2026 53.0 DR 600.36 UPI/DR/..."
    // Matches: Date (dd/mm/yyyy), Amount (float), Type (DR|CR), Balance (float), Remarks (string)
    // Sometimes there might be an Instrument ID column between Date and Amount.
    // We'll use a flexible regex that allows optional tokens.
    final pnbRegex = RegExp(r'^(\d{2}[-/]\d{2}[-/]\d{4})\s+(?:[\w-]+\s+)?([\d.,]+)\s+(DR|CR)\s+([\d.,]+)\s+(.+)$', caseSensitive: false);

    for (final line in lines) {
      final match = pnbRegex.firstMatch(line.trim());
      if (match != null) {
        final dateStr = match.group(1)!;
        final amountStr = match.group(2)!.replaceAll(',', '');
        final typeStr = match.group(3)!.toUpperCase();
        final remarks = match.group(5)!;

        final amount = double.tryParse(amountStr) ?? 0.0;
        if (amount == 0) continue;

        final direction = typeStr == 'DR' || typeStr == 'DEBIT' ? TransactionDirection.debit : TransactionDirection.credit;

        DateTime date = DateTime.now();
        try {
          final parts = dateStr.split(RegExp(r'[-/]'));
          if (parts[2].length == 4) {
            date = DateTime(int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));
          } else {
             date = DateTime.parse(dateStr);
          }
        } catch (_) {}

        // Categorize locally
        final catMap = CategoryClassifier.batchClassifyNamed([remarks]);
        Category category = Category.uncategorized;
        try {
          final catStr = catMap[remarks];
          if (catStr != null) {
            category = Category.values.firstWhere((e) => e.name == catStr);
          }
        } catch (_) {}

        transactions.add(Transaction(
          id: _uuid.v4(),
          amount: amount,
          direction: direction,
          category: category,
          date: date,
          paymentMethod: PaymentMethod.unknown,
          isRecurring: false,
          confidence: Confidence.high,
          isConfirmed: true,
          merchantName: remarks.length > 20 ? remarks.substring(0, 20) : remarks,
          statementId: statementId,
        ));
      }
    }

    return transactions;
  }

  Future<List<Transaction>> parsePdfCloud(String filePath, String statementId, String apiKey) async {
    final file = File(filePath);
    final bytes = await file.readAsBytes();
    
    final document = PdfDocument(inputBytes: bytes);
    final textExtractor = PdfTextExtractor(document);
    String pdfText = '';
    for (int i = 0; i < document.pages.count; i++) {
      pdfText += textExtractor.extractText(startPageIndex: i, endPageIndex: i) + '\n';
    }
    document.dispose();

    if (pdfText.length > 50000) {
      pdfText = pdfText.substring(0, 50000); // safety truncation
    }

    final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);
    
    final prompt = '''
You are a financial data parser. Extract the transactions from this bank statement text.
Format the output EXACTLY as a JSON array of objects. 
Each object must have:
"date": "YYYY-MM-DD"
"description": "merchant name or narration"
"amount": absolute value as float
"direction": "expense" or "income"
"category": assign one of: food, transport, academic, techTools, subscriptions, personal, entertainment, income, uncategorized.

Bank Statement Text:
\$pdfText

Return ONLY the JSON array. Do not include markdown formatting or comments.
''';

    final response = await model.generateContent([Content.text(prompt)]);
    final jsonStr = response.text?.replaceAll('```json', '').replaceAll('```', '').trim() ?? '[]';
    
    final List<dynamic> jsonList = jsonDecode(jsonStr);
    final transactions = <Transaction>[];

    for (var item in jsonList) {
      final amount = double.tryParse(item['amount'].toString()) ?? 0.0;
      if (amount == 0) continue;
      
      final directionStr = item['direction'].toString().toLowerCase();
      final direction = directionStr == 'income' ? TransactionDirection.credit : TransactionDirection.debit;
      
      Category category = Category.uncategorized;
      try {
        category = Category.values.firstWhere((e) => e.name == item['category'].toString());
      } catch (_) {}

      DateTime date = DateTime.now();
      try {
        date = DateTime.parse(item['date'].toString());
      } catch (_) {}

      transactions.add(Transaction(
        id: _uuid.v4(),
        amount: amount,
        direction: direction,
        category: category,
        date: date,
        paymentMethod: PaymentMethod.unknown,
        isRecurring: false,
        confidence: Confidence.high,
        isConfirmed: true,
        merchantName: item['description'].toString(),
        statementId: statementId,
      ));
    }
    return transactions;
  }
}
