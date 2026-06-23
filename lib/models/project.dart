import 'package:isar/isar.dart';
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