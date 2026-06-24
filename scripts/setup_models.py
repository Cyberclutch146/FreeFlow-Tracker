import os

models = {
"lib/models/transaction.dart": """import 'package:isar/isar.dart';
import '../core/constants/app_constants.dart';
import '../core/utils/extensions.dart';

part 'transaction.g.dart';

@collection
class Transaction {
  Id get isarId => id.fastHash;

  @Index(unique: true)
  String id;
  
  double amount;
  
  @Enumerated(EnumType.name)
  TransactionDirection direction;
  
  @Enumerated(EnumType.name)
  Category category;
  
  String? note;
  
  @Index()
  DateTime date;
  
  @Enumerated(EnumType.name)
  PaymentMethod paymentMethod;
  
  String? projectId;
  String? studentId;
  bool isRecurring;
  
  @Enumerated(EnumType.name)
  RecurringFrequency? recurringFrequency;
  
  String? smsRawLogId;
  
  @Enumerated(EnumType.name)
  Confidence confidence;
  
  bool isConfirmed;
  String? merchantName;
  String? upiRefId;
  String? bankSource;

  Transaction({
    required this.id,
    required this.amount,
    required this.direction,
    required this.category,
    this.note,
    required this.date,
    required this.paymentMethod,
    this.projectId,
    this.studentId,
    required this.isRecurring,
    this.recurringFrequency,
    this.smsRawLogId,
    required this.confidence,
    required this.isConfirmed,
    this.merchantName,
    this.upiRefId,
    this.bankSource,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] as String,
      amount: (json['amount'] as num).toDouble(),
      direction: TransactionDirection.values.firstWhere((e) => e.name == json['direction']),
      category: Category.values.firstWhere((e) => e.name == json['category']),
      note: json['note'] as String?,
      date: DateTime.parse(json['date'] as String),
      paymentMethod: PaymentMethod.values.firstWhere((e) => e.name == json['paymentMethod']),
      projectId: json['projectId'] as String?,
      studentId: json['studentId'] as String?,
      isRecurring: json['isRecurring'] as bool,
      recurringFrequency: json['recurringFrequency'] != null 
          ? RecurringFrequency.values.firstWhere((e) => e.name == json['recurringFrequency']) 
          : null,
      smsRawLogId: json['smsRawLogId'] as String?,
      confidence: Confidence.values.firstWhere((e) => e.name == json['confidence']),
      isConfirmed: json['isConfirmed'] as bool,
      merchantName: json['merchantName'] as String?,
      upiRefId: json['upiRefId'] as String?,
      bankSource: json['bankSource'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'amount': amount,
    'direction': direction.name,
    'category': category.name,
    'note': note,
    'date': date.toIso8601String(),
    'paymentMethod': paymentMethod.name,
    'projectId': projectId,
    'studentId': studentId,
    'isRecurring': isRecurring,
    'recurringFrequency': recurringFrequency?.name,
    'smsRawLogId': smsRawLogId,
    'confidence': confidence.name,
    'isConfirmed': isConfirmed,
    'merchantName': merchantName,
    'upiRefId': upiRefId,
    'bankSource': bankSource,
  };

  Transaction copyWith({
    String? id,
    double? amount,
    TransactionDirection? direction,
    Category? category,
    String? note,
    DateTime? date,
    PaymentMethod? paymentMethod,
    String? projectId,
    String? studentId,
    bool? isRecurring,
    RecurringFrequency? recurringFrequency,
    String? smsRawLogId,
    Confidence? confidence,
    bool? isConfirmed,
    String? merchantName,
    String? upiRefId,
    String? bankSource,
  }) {
    return Transaction(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      direction: direction ?? this.direction,
      category: category ?? this.category,
      note: note ?? this.note,
      date: date ?? this.date,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      projectId: projectId ?? this.projectId,
      studentId: studentId ?? this.studentId,
      isRecurring: isRecurring ?? this.isRecurring,
      recurringFrequency: recurringFrequency ?? this.recurringFrequency,
      smsRawLogId: smsRawLogId ?? this.smsRawLogId,
      confidence: confidence ?? this.confidence,
      isConfirmed: isConfirmed ?? this.isConfirmed,
      merchantName: merchantName ?? this.merchantName,
      upiRefId: upiRefId ?? this.upiRefId,
      bankSource: bankSource ?? this.bankSource,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Transaction && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Transaction(id: $id, amount: $amount, category: $category)';
}
""",

"lib/models/sms_raw_log.dart": """import 'package:isar/isar.dart';
import '../core/utils/extensions.dart';

part 'sms_raw_log.g.dart';

@collection
class SmsRawLog {
  Id get isarId => id.fastHash;

  @Index(unique: true)
  String id;
  
  String rawBody;
  String sender;
  DateTime receivedAt;
  bool isParsed;
  String? linkedTransactionId;

  SmsRawLog({
    required this.id,
    required this.rawBody,
    required this.sender,
    required this.receivedAt,
    required this.isParsed,
    this.linkedTransactionId,
  });

  factory SmsRawLog.fromJson(Map<String, dynamic> json) {
    return SmsRawLog(
      id: json['id'] as String,
      rawBody: json['rawBody'] as String,
      sender: json['sender'] as String,
      receivedAt: DateTime.parse(json['receivedAt'] as String),
      isParsed: json['isParsed'] as bool,
      linkedTransactionId: json['linkedTransactionId'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'rawBody': rawBody,
    'sender': sender,
    'receivedAt': receivedAt.toIso8601String(),
    'isParsed': isParsed,
    'linkedTransactionId': linkedTransactionId,
  };

  SmsRawLog copyWith({
    String? id,
    String? rawBody,
    String? sender,
    DateTime? receivedAt,
    bool? isParsed,
    String? linkedTransactionId,
  }) {
    return SmsRawLog(
      id: id ?? this.id,
      rawBody: rawBody ?? this.rawBody,
      sender: sender ?? this.sender,
      receivedAt: receivedAt ?? this.receivedAt,
      isParsed: isParsed ?? this.isParsed,
      linkedTransactionId: linkedTransactionId ?? this.linkedTransactionId,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SmsRawLog && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'SmsRawLog(id: $id, sender: $sender)';
}
""",

"lib/models/project.dart": """import 'package:isar/isar.dart';
import '../core/constants/app_constants.dart';
import '../core/utils/extensions.dart';

part 'project.g.dart';

@collection
class Project {
  Id get isarId => id.fastHash;

  @Index(unique: true)
  String id;
  
  String name;
  String clientName;
  double totalValue;
  DateTime? deadline;
  
  @Enumerated(EnumType.name)
  ProjectStatus status;
  
  DateTime createdAt;
  String? notes;

  Project({
    required this.id,
    required this.name,
    required this.clientName,
    required this.totalValue,
    this.deadline,
    required this.status,
    required this.createdAt,
    this.notes,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'] as String,
      name: json['name'] as String,
      clientName: json['clientName'] as String,
      totalValue: (json['totalValue'] as num).toDouble(),
      deadline: json['deadline'] != null ? DateTime.parse(json['deadline'] as String) : null,
      status: ProjectStatus.values.firstWhere((e) => e.name == json['status']),
      createdAt: DateTime.parse(json['createdAt'] as String),
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'clientName': clientName,
    'totalValue': totalValue,
    'deadline': deadline?.toIso8601String(),
    'status': status.name,
    'createdAt': createdAt.toIso8601String(),
    'notes': notes,
  };

  Project copyWith({
    String? id,
    String? name,
    String? clientName,
    double? totalValue,
    DateTime? deadline,
    ProjectStatus? status,
    DateTime? createdAt,
    String? notes,
  }) {
    return Project(
      id: id ?? this.id,
      name: name ?? this.name,
      clientName: clientName ?? this.clientName,
      totalValue: totalValue ?? this.totalValue,
      deadline: deadline ?? this.deadline,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      notes: notes ?? this.notes,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Project && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Project(id: $id, name: $name, status: $status)';
}
""",

"lib/models/student.dart": """import 'package:isar/isar.dart';
import '../core/utils/extensions.dart';

part 'student.g.dart';

@collection
class Student {
  Id get isarId => id.fastHash;

  @Index(unique: true)
  String id;
  
  String name;
  String subject;
  double feePerSession;
  String? schedule;
  bool isActive;
  DateTime createdAt;

  Student({
    required this.id,
    required this.name,
    required this.subject,
    required this.feePerSession,
    this.schedule,
    required this.isActive,
    required this.createdAt,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'] as String,
      name: json['name'] as String,
      subject: json['subject'] as String,
      feePerSession: (json['feePerSession'] as num).toDouble(),
      schedule: json['schedule'] as String?,
      isActive: json['isActive'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'subject': subject,
    'feePerSession': feePerSession,
    'schedule': schedule,
    'isActive': isActive,
    'createdAt': createdAt.toIso8601String(),
  };

  Student copyWith({
    String? id,
    String? name,
    String? subject,
    double? feePerSession,
    String? schedule,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return Student(
      id: id ?? this.id,
      name: name ?? this.name,
      subject: subject ?? this.subject,
      feePerSession: feePerSession ?? this.feePerSession,
      schedule: schedule ?? this.schedule,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Student && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Student(id: $id, name: $name, subject: $subject)';
}
""",

"lib/models/session.dart": """import 'package:isar/isar.dart';
import '../core/utils/extensions.dart';

part 'session.g.dart';

@collection
class Session {
  Id get isarId => id.fastHash;

  @Index(unique: true)
  String id;
  
  String studentId;
  DateTime date;
  bool isPaid;
  String? notes;

  Session({
    required this.id,
    required this.studentId,
    required this.date,
    required this.isPaid,
    this.notes,
  });

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      id: json['id'] as String,
      studentId: json['studentId'] as String,
      date: DateTime.parse(json['date'] as String),
      isPaid: json['isPaid'] as bool,
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'studentId': studentId,
    'date': date.toIso8601String(),
    'isPaid': isPaid,
    'notes': notes,
  };

  Session copyWith({
    String? id,
    String? studentId,
    DateTime? date,
    bool? isPaid,
    String? notes,
  }) {
    return Session(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      date: date ?? this.date,
      isPaid: isPaid ?? this.isPaid,
      notes: notes ?? this.notes,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Session && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Session(id: $id, studentId: $studentId)';
}
""",

"lib/models/savings_goal.dart": """import 'package:isar/isar.dart';
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
""",

"lib/models/goal_contribution.dart": """import 'package:isar/isar.dart';
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
""",

"lib/models/budget.dart": """import 'package:isar/isar.dart';
import '../core/constants/app_constants.dart';
import '../core/utils/extensions.dart';

part 'budget.g.dart';

@collection
class Budget {
  Id get isarId => id.fastHash;

  @Index(unique: true)
  String id;
  
  @Enumerated(EnumType.name)
  Category category;
  
  double monthlyLimit;
  int month;
  int year;

  Budget({
    required this.id,
    required this.category,
    required this.monthlyLimit,
    required this.month,
    required this.year,
  });

  factory Budget.fromJson(Map<String, dynamic> json) {
    return Budget(
      id: json['id'] as String,
      category: Category.values.firstWhere((e) => e.name == json['category']),
      monthlyLimit: (json['monthlyLimit'] as num).toDouble(),
      month: json['month'] as int,
      year: json['year'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'category': category.name,
    'monthlyLimit': monthlyLimit,
    'month': month,
    'year': year,
  };

  Budget copyWith({
    String? id,
    Category? category,
    double? monthlyLimit,
    int? month,
    int? year,
  }) {
    return Budget(
      id: id ?? this.id,
      category: category ?? this.category,
      monthlyLimit: monthlyLimit ?? this.monthlyLimit,
      month: month ?? this.month,
      year: year ?? this.year,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Budget && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Budget(id: $id, category: $category, limit: $monthlyLimit)';
}
""",

"lib/models/insight_card.dart": """import 'package:isar/isar.dart';
import '../core/constants/app_constants.dart';
import '../core/utils/extensions.dart';

part 'insight_card.g.dart';

@collection
class InsightCard {
  Id get isarId => id.fastHash;

  @Index(unique: true)
  String id;
  
  String ruleId;
  
  @Enumerated(EnumType.name)
  InsightType type;
  
  String headline;
  String detail;
  String? actionLabel;
  String? actionRoute;
  DateTime generatedAt;
  bool isDismissed;
  DateTime? dismissedUntil;

  InsightCard({
    required this.id,
    required this.ruleId,
    required this.type,
    required this.headline,
    required this.detail,
    this.actionLabel,
    this.actionRoute,
    required this.generatedAt,
    required this.isDismissed,
    this.dismissedUntil,
  });

  factory InsightCard.fromJson(Map<String, dynamic> json) {
    return InsightCard(
      id: json['id'] as String,
      ruleId: json['ruleId'] as String,
      type: InsightType.values.firstWhere((e) => e.name == json['type']),
      headline: json['headline'] as String,
      detail: json['detail'] as String,
      actionLabel: json['actionLabel'] as String?,
      actionRoute: json['actionRoute'] as String?,
      generatedAt: DateTime.parse(json['generatedAt'] as String),
      isDismissed: json['isDismissed'] as bool,
      dismissedUntil: json['dismissedUntil'] != null ? DateTime.parse(json['dismissedUntil'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'ruleId': ruleId,
    'type': type.name,
    'headline': headline,
    'detail': detail,
    'actionLabel': actionLabel,
    'actionRoute': actionRoute,
    'generatedAt': generatedAt.toIso8601String(),
    'isDismissed': isDismissed,
    'dismissedUntil': dismissedUntil?.toIso8601String(),
  };

  InsightCard copyWith({
    String? id,
    String? ruleId,
    InsightType? type,
    String? headline,
    String? detail,
    String? actionLabel,
    String? actionRoute,
    DateTime? generatedAt,
    bool? isDismissed,
    DateTime? dismissedUntil,
  }) {
    return InsightCard(
      id: id ?? this.id,
      ruleId: ruleId ?? this.ruleId,
      type: type ?? this.type,
      headline: headline ?? this.headline,
      detail: detail ?? this.detail,
      actionLabel: actionLabel ?? this.actionLabel,
      actionRoute: actionRoute ?? this.actionRoute,
      generatedAt: generatedAt ?? this.generatedAt,
      isDismissed: isDismissed ?? this.isDismissed,
      dismissedUntil: dismissedUntil ?? this.dismissedUntil,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InsightCard && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'InsightCard(id: $id, headline: $headline)';
}
""",

"lib/models/advisor_card.dart": """import 'package:isar/isar.dart';
import '../core/constants/app_constants.dart';
import '../core/utils/extensions.dart';

part 'advisor_card.g.dart';

@collection
class AdvisorCard {
  Id get isarId => id.fastHash;

  @Index(unique: true)
  String id;
  
  String capabilityId;
  
  @Enumerated(EnumType.name)
  InsightType type;
  
  String headline;
  String detail;
  String? primaryActionLabel;
  
  @Enumerated(EnumType.name)
  AdvisorActionType? primaryActionType;
  
  String? primaryActionPayload;
  String? secondaryActionLabel;
  DateTime generatedAt;
  bool isDismissed;
  DateTime? dismissedUntil;

  AdvisorCard({
    required this.id,
    required this.capabilityId,
    required this.type,
    required this.headline,
    required this.detail,
    this.primaryActionLabel,
    this.primaryActionType,
    this.primaryActionPayload,
    this.secondaryActionLabel,
    required this.generatedAt,
    required this.isDismissed,
    this.dismissedUntil,
  });

  factory AdvisorCard.fromJson(Map<String, dynamic> json) {
    return AdvisorCard(
      id: json['id'] as String,
      capabilityId: json['capabilityId'] as String,
      type: InsightType.values.firstWhere((e) => e.name == json['type']),
      headline: json['headline'] as String,
      detail: json['detail'] as String,
      primaryActionLabel: json['primaryActionLabel'] as String?,
      primaryActionType: json['primaryActionType'] != null 
          ? AdvisorActionType.values.firstWhere((e) => e.name == json['primaryActionType']) 
          : null,
      primaryActionPayload: json['primaryActionPayload'] as String?,
      secondaryActionLabel: json['secondaryActionLabel'] as String?,
      generatedAt: DateTime.parse(json['generatedAt'] as String),
      isDismissed: json['isDismissed'] as bool,
      dismissedUntil: json['dismissedUntil'] != null ? DateTime.parse(json['dismissedUntil'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'capabilityId': capabilityId,
    'type': type.name,
    'headline': headline,
    'detail': detail,
    'primaryActionLabel': primaryActionLabel,
    'primaryActionType': primaryActionType?.name,
    'primaryActionPayload': primaryActionPayload,
    'secondaryActionLabel': secondaryActionLabel,
    'generatedAt': generatedAt.toIso8601String(),
    'isDismissed': isDismissed,
    'dismissedUntil': dismissedUntil?.toIso8601String(),
  };

  AdvisorCard copyWith({
    String? id,
    String? capabilityId,
    InsightType? type,
    String? headline,
    String? detail,
    String? primaryActionLabel,
    AdvisorActionType? primaryActionType,
    String? primaryActionPayload,
    String? secondaryActionLabel,
    DateTime? generatedAt,
    bool? isDismissed,
    DateTime? dismissedUntil,
  }) {
    return AdvisorCard(
      id: id ?? this.id,
      capabilityId: capabilityId ?? this.capabilityId,
      type: type ?? this.type,
      headline: headline ?? this.headline,
      detail: detail ?? this.detail,
      primaryActionLabel: primaryActionLabel ?? this.primaryActionLabel,
      primaryActionType: primaryActionType ?? this.primaryActionType,
      primaryActionPayload: primaryActionPayload ?? this.primaryActionPayload,
      secondaryActionLabel: secondaryActionLabel ?? this.secondaryActionLabel,
      generatedAt: generatedAt ?? this.generatedAt,
      isDismissed: isDismissed ?? this.isDismissed,
      dismissedUntil: dismissedUntil ?? this.dismissedUntil,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AdvisorCard && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'AdvisorCard(id: $id, headline: $headline)';
}
""",

"lib/models/app_settings.dart": """import 'package:isar/isar.dart';
import '../core/constants/app_constants.dart';
import '../core/utils/extensions.dart';

part 'app_settings.g.dart';

@collection
class AppSettings {
  Id get isarId => id.fastHash;

  @Index(unique: true)
  String id;
  
  double monthlyIncomeTarget;
  int budgetResetDay;
  
  @Enumerated(EnumType.name)
  AppThemeMode theme;
  
  bool smsPermissionGranted;
  bool onboardingComplete;
  List<String> incomeSources;
  DateTime? lastSmsSync;

  AppSettings({
    required this.id,
    required this.monthlyIncomeTarget,
    required this.budgetResetDay,
    required this.theme,
    required this.smsPermissionGranted,
    required this.onboardingComplete,
    required this.incomeSources,
    this.lastSmsSync,
  });

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      id: json['id'] as String,
      monthlyIncomeTarget: (json['monthlyIncomeTarget'] as num).toDouble(),
      budgetResetDay: json['budgetResetDay'] as int,
      theme: AppThemeMode.values.firstWhere((e) => e.name == json['theme']),
      smsPermissionGranted: json['smsPermissionGranted'] as bool,
      onboardingComplete: json['onboardingComplete'] as bool,
      incomeSources: List<String>.from(json['incomeSources']),
      lastSmsSync: json['lastSmsSync'] != null ? DateTime.parse(json['lastSmsSync'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'monthlyIncomeTarget': monthlyIncomeTarget,
    'budgetResetDay': budgetResetDay,
    'theme': theme.name,
    'smsPermissionGranted': smsPermissionGranted,
    'onboardingComplete': onboardingComplete,
    'incomeSources': incomeSources,
    'lastSmsSync': lastSmsSync?.toIso8601String(),
  };

  AppSettings copyWith({
    String? id,
    double? monthlyIncomeTarget,
    int? budgetResetDay,
    AppThemeMode? theme,
    bool? smsPermissionGranted,
    bool? onboardingComplete,
    List<String>? incomeSources,
    DateTime? lastSmsSync,
  }) {
    return AppSettings(
      id: id ?? this.id,
      monthlyIncomeTarget: monthlyIncomeTarget ?? this.monthlyIncomeTarget,
      budgetResetDay: budgetResetDay ?? this.budgetResetDay,
      theme: theme ?? this.theme,
      smsPermissionGranted: smsPermissionGranted ?? this.smsPermissionGranted,
      onboardingComplete: onboardingComplete ?? this.onboardingComplete,
      incomeSources: incomeSources ?? this.incomeSources,
      lastSmsSync: lastSmsSync ?? this.lastSmsSync,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppSettings && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'AppSettings(id: $id, theme: $theme)';
}
"""
}

for path, content in models.items():
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, "w", encoding="utf-8") as f:
        f.write(content.strip())
