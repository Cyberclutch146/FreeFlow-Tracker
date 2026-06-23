import 'package:isar/isar.dart';
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