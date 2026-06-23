import 'package:isar/isar.dart';
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