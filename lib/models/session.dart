import 'package:isar/isar.dart';
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