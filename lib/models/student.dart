import 'package:isar/isar.dart';
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