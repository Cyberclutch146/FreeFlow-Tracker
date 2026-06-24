import 'package:isar/isar.dart';
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
  
  List<String> receiptImagePaths = [];
  
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
  
  bool isArchived;
  String? splitGroupId;

  Transaction({
    required this.id,
    required this.amount,
    required this.direction,
    required this.category,
    this.note,
    this.receiptImagePaths = const [],
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
    this.isArchived = false,
    this.splitGroupId,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] as String,
      amount: (json['amount'] as num).toDouble(),
      direction: TransactionDirection.values.firstWhere((e) => e.name == json['direction']),
      category: Category.values.firstWhere((e) => e.name == json['category']),
      note: json['note'] as String?,
      receiptImagePaths: (json['receiptImagePaths'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
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
      isArchived: json['isArchived'] as bool? ?? false,
      splitGroupId: json['splitGroupId'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'amount': amount,
    'direction': direction.name,
    'category': category.name,
    'note': note,
    'receiptImagePaths': receiptImagePaths,
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
    'isArchived': isArchived,
    'splitGroupId': splitGroupId,
  };

  Transaction copyWith({
    String? id,
    double? amount,
    TransactionDirection? direction,
    Category? category,
    String? note,
    List<String>? receiptImagePaths,
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
    bool? isArchived,
    String? splitGroupId,
  }) {
    return Transaction(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      direction: direction ?? this.direction,
      category: category ?? this.category,
      note: note ?? this.note,
      receiptImagePaths: receiptImagePaths ?? this.receiptImagePaths,
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
      isArchived: isArchived ?? this.isArchived,
      splitGroupId: splitGroupId ?? this.splitGroupId,
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