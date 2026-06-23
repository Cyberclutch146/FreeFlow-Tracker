import 'package:isar/isar.dart';
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