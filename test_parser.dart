import 'dart:io';
import 'lib/services/statement_parser.dart';

void main() async {
  final csvContent = '''Date,Description,Amount
2023-10-01,Test Merchant,-50.00
2023-10-02,Salary,1000.00
''';
  final file = File('test_statement.csv');
  await file.writeAsString(csvContent);

  try {
    final parser = StatementParser();
    final txns = await parser.parseCsv('test_statement.csv', 'test-123');
    print('Parsed \${txns.length} transactions:');
    for (var t in txns) {
      print('\${t.date} | \${t.merchantName} | \${t.amount} | \${t.direction}');
    }
  } catch (e, st) {
    print('Exception: \$e');
    print(st);
  }
}
