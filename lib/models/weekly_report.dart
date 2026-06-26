import 'package:isar/isar.dart';
import '../core/utils/extensions.dart';

part 'weekly_report.g.dart';

@collection
class WeeklyReport {
  Id get isarId => id.fastHash;

  @Index(unique: true)
  String id;

  DateTime startDate;
  DateTime endDate;

  String summaryText;
  double totalSpent;
  double totalIncome;

  WeeklyReport({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.summaryText,
    required this.totalSpent,
    required this.totalIncome,
  });
}
