import 'package:isar/isar.dart';
import '../core/constants/app_constants.dart';
import '../core/utils/extensions.dart';

part 'savings_goal.g.dart';

@collection
class SavingsGoal {
  Id get isarId => id.fastHash;

  @Index(unique: true)
  String id;
  
  String name;
  String emoji;
  double targetAmount;
  double currentAmount;
  DateTime? deadline;
  
  @Enumerated(EnumType.name)
  Priority priority;
  
  @Enumerated(EnumType.name)
  GoalStatus status;
  
  double monthlyAllocation;
  DateTime? predictedCompletionDate;
  DateTime createdAt;
  DateTime? completedAt;

  SavingsGoal({
    required this.id,
    required this.name,
    required this.emoji,
    required this.targetAmount,
    required this.currentAmount,
    this.deadline,
    required this.priority,
    required this.status,
    required this.monthlyAllocation,
    this.predictedCompletionDate,
    required this.createdAt,
    this.completedAt,
  });

  factory SavingsGoal.fromJson(Map<String, dynamic> json) {
    return SavingsGoal(
      id: json['id'] as String,
      name: json['name'] as String,
      emoji: json['emoji'] as String,
      targetAmount: (json['targetAmount'] as num).toDouble(),
      currentAmount: (json['currentAmount'] as num).toDouble(),
      deadline: json['deadline'] != null ? DateTime.parse(json['deadline'] as String) : null,
      priority: Priority.values.firstWhere((e) => e.name == json['priority']),
      status: GoalStatus.values.firstWhere((e) => e.name == json['status']),
      monthlyAllocation: (json['monthlyAllocation'] as num).toDouble(),
      predictedCompletionDate: json['predictedCompletionDate'] != null ? DateTime.parse(json['predictedCompletionDate'] as String) : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      completedAt: json['completedAt'] != null ? DateTime.parse(json['completedAt'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'emoji': emoji,
    'targetAmount': targetAmount,
    'currentAmount': currentAmount,
    'deadline': deadline?.toIso8601String(),
    'priority': priority.name,
    'status': status.name,
    'monthlyAllocation': monthlyAllocation,
    'predictedCompletionDate': predictedCompletionDate?.toIso8601String(),
    'createdAt': createdAt.toIso8601String(),
    'completedAt': completedAt?.toIso8601String(),
  };

  SavingsGoal copyWith({
    String? id,
    String? name,
    String? emoji,
    double? targetAmount,
    double? currentAmount,
    DateTime? deadline,
    Priority? priority,
    GoalStatus? status,
    double? monthlyAllocation,
    DateTime? predictedCompletionDate,
    DateTime? createdAt,
    DateTime? completedAt,
  }) {
    return SavingsGoal(
      id: id ?? this.id,
      name: name ?? this.name,
      emoji: emoji ?? this.emoji,
      targetAmount: targetAmount ?? this.targetAmount,
      currentAmount: currentAmount ?? this.currentAmount,
      deadline: deadline ?? this.deadline,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      monthlyAllocation: monthlyAllocation ?? this.monthlyAllocation,
      predictedCompletionDate: predictedCompletionDate ?? this.predictedCompletionDate,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SavingsGoal && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'SavingsGoal(id: $id, name: $name, target: $targetAmount)';
}