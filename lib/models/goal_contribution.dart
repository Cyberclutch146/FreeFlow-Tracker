import 'package:isar/isar.dart';
import '../core/utils/extensions.dart';

part 'goal_contribution.g.dart';

@collection
class GoalContribution {
  Id get isarId => id.fastHash;

  @Index(unique: true)
  String id;
  
  String goalId;
  double amount;
  DateTime date;
  String? note;

  GoalContribution({
    required this.id,
    required this.goalId,
    required this.amount,
    required this.date,
    this.note,
  });

  factory GoalContribution.fromJson(Map<String, dynamic> json) {
    return GoalContribution(
      id: json['id'] as String,
      goalId: json['goalId'] as String,
      amount: (json['amount'] as num).toDouble(),
      date: DateTime.parse(json['date'] as String),
      note: json['note'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'goalId': goalId,
    'amount': amount,
    'date': date.toIso8601String(),
    'note': note,
  };

  GoalContribution copyWith({
    String? id,
    String? goalId,
    double? amount,
    DateTime? date,
    String? note,
  }) {
    return GoalContribution(
      id: id ?? this.id,
      goalId: goalId ?? this.goalId,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      note: note ?? this.note,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GoalContribution && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'GoalContribution(id: $id, amount: $amount)';
}