import 'package:isar/isar.dart';
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