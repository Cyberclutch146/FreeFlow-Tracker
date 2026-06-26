import 'package:isar/isar.dart';
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
  String? geminiApiKey;
  String currencySymbol;
  bool pushNotificationsEnabled;
  bool tutorialComplete;

  AppSettings({
    required this.id,
    required this.monthlyIncomeTarget,
    required this.budgetResetDay,
    required this.theme,
    required this.smsPermissionGranted,
    required this.onboardingComplete,
    required this.incomeSources,
    this.lastSmsSync,
    this.geminiApiKey,
    this.currencySymbol = '₹',
    this.pushNotificationsEnabled = false,
    this.tutorialComplete = false,
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
      geminiApiKey: json['geminiApiKey'] as String?,
      currencySymbol: json['currencySymbol'] as String? ?? '₹',
      pushNotificationsEnabled: json['pushNotificationsEnabled'] as bool? ?? false,
      tutorialComplete: json['tutorialComplete'] as bool? ?? false,
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
    'geminiApiKey': geminiApiKey,
    'currencySymbol': currencySymbol,
    'pushNotificationsEnabled': pushNotificationsEnabled,
    'tutorialComplete': tutorialComplete,
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
    String? geminiApiKey,
    String? currencySymbol,
    bool? pushNotificationsEnabled,
    bool? tutorialComplete,
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
      geminiApiKey: geminiApiKey ?? this.geminiApiKey,
      currencySymbol: currencySymbol ?? this.currencySymbol,
      pushNotificationsEnabled: pushNotificationsEnabled ?? this.pushNotificationsEnabled,
      tutorialComplete: tutorialComplete ?? this.tutorialComplete,
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