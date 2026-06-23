// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_settings.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetAppSettingsCollection on Isar {
  IsarCollection<AppSettings> get appSettings => this.collection();
}

const AppSettingsSchema = CollectionSchema(
  name: r'AppSettings',
  id: -5633561779022347008,
  properties: {
    r'budgetResetDay': PropertySchema(
      id: 0,
      name: r'budgetResetDay',
      type: IsarType.long,
    ),
    r'geminiApiKey': PropertySchema(
      id: 1,
      name: r'geminiApiKey',
      type: IsarType.string,
    ),
    r'hashCode': PropertySchema(
      id: 2,
      name: r'hashCode',
      type: IsarType.long,
    ),
    r'id': PropertySchema(
      id: 3,
      name: r'id',
      type: IsarType.string,
    ),
    r'incomeSources': PropertySchema(
      id: 4,
      name: r'incomeSources',
      type: IsarType.stringList,
    ),
    r'lastSmsSync': PropertySchema(
      id: 5,
      name: r'lastSmsSync',
      type: IsarType.dateTime,
    ),
    r'monthlyIncomeTarget': PropertySchema(
      id: 6,
      name: r'monthlyIncomeTarget',
      type: IsarType.double,
    ),
    r'onboardingComplete': PropertySchema(
      id: 7,
      name: r'onboardingComplete',
      type: IsarType.bool,
    ),
    r'smsPermissionGranted': PropertySchema(
      id: 8,
      name: r'smsPermissionGranted',
      type: IsarType.bool,
    ),
    r'theme': PropertySchema(
      id: 9,
      name: r'theme',
      type: IsarType.string,
      enumMap: _AppSettingsthemeEnumValueMap,
    )
  },
  estimateSize: _appSettingsEstimateSize,
  serialize: _appSettingsSerialize,
  deserialize: _appSettingsDeserialize,
  deserializeProp: _appSettingsDeserializeProp,
  idName: r'isarId',
  indexes: {
    r'id': IndexSchema(
      id: -3268401673993471357,
      name: r'id',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'id',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _appSettingsGetId,
  getLinks: _appSettingsGetLinks,
  attach: _appSettingsAttach,
  version: '3.1.0+1',
);

int _appSettingsEstimateSize(
  AppSettings object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.geminiApiKey;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.id.length * 3;
  bytesCount += 3 + object.incomeSources.length * 3;
  {
    for (var i = 0; i < object.incomeSources.length; i++) {
      final value = object.incomeSources[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.theme.name.length * 3;
  return bytesCount;
}

void _appSettingsSerialize(
  AppSettings object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.budgetResetDay);
  writer.writeString(offsets[1], object.geminiApiKey);
  writer.writeLong(offsets[2], object.hashCode);
  writer.writeString(offsets[3], object.id);
  writer.writeStringList(offsets[4], object.incomeSources);
  writer.writeDateTime(offsets[5], object.lastSmsSync);
  writer.writeDouble(offsets[6], object.monthlyIncomeTarget);
  writer.writeBool(offsets[7], object.onboardingComplete);
  writer.writeBool(offsets[8], object.smsPermissionGranted);
  writer.writeString(offsets[9], object.theme.name);
}

AppSettings _appSettingsDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = AppSettings(
    budgetResetDay: reader.readLong(offsets[0]),
    geminiApiKey: reader.readStringOrNull(offsets[1]),
    id: reader.readString(offsets[3]),
    incomeSources: reader.readStringList(offsets[4]) ?? [],
    lastSmsSync: reader.readDateTimeOrNull(offsets[5]),
    monthlyIncomeTarget: reader.readDouble(offsets[6]),
    onboardingComplete: reader.readBool(offsets[7]),
    smsPermissionGranted: reader.readBool(offsets[8]),
    theme: _AppSettingsthemeValueEnumMap[reader.readStringOrNull(offsets[9])] ??
        AppThemeMode.dark,
  );
  return object;
}

P _appSettingsDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readStringList(offset) ?? []) as P;
    case 5:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 6:
      return (reader.readDouble(offset)) as P;
    case 7:
      return (reader.readBool(offset)) as P;
    case 8:
      return (reader.readBool(offset)) as P;
    case 9:
      return (_AppSettingsthemeValueEnumMap[reader.readStringOrNull(offset)] ??
          AppThemeMode.dark) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _AppSettingsthemeEnumValueMap = {
  r'dark': r'dark',
  r'oled': r'oled',
  r'light': r'light',
};
const _AppSettingsthemeValueEnumMap = {
  r'dark': AppThemeMode.dark,
  r'oled': AppThemeMode.oled,
  r'light': AppThemeMode.light,
};

Id _appSettingsGetId(AppSettings object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _appSettingsGetLinks(AppSettings object) {
  return [];
}

void _appSettingsAttach(
    IsarCollection<dynamic> col, Id id, AppSettings object) {}

extension AppSettingsByIndex on IsarCollection<AppSettings> {
  Future<AppSettings?> getById(String id) {
    return getByIndex(r'id', [id]);
  }

  AppSettings? getByIdSync(String id) {
    return getByIndexSync(r'id', [id]);
  }

  Future<bool> deleteById(String id) {
    return deleteByIndex(r'id', [id]);
  }

  bool deleteByIdSync(String id) {
    return deleteByIndexSync(r'id', [id]);
  }

  Future<List<AppSettings?>> getAllById(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return getAllByIndex(r'id', values);
  }

  List<AppSettings?> getAllByIdSync(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'id', values);
  }

  Future<int> deleteAllById(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'id', values);
  }

  int deleteAllByIdSync(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'id', values);
  }

  Future<Id> putById(AppSettings object) {
    return putByIndex(r'id', object);
  }

  Id putByIdSync(AppSettings object, {bool saveLinks = true}) {
    return putByIndexSync(r'id', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllById(List<AppSettings> objects) {
    return putAllByIndex(r'id', objects);
  }

  List<Id> putAllByIdSync(List<AppSettings> objects, {bool saveLinks = true}) {
    return putAllByIndexSync(r'id', objects, saveLinks: saveLinks);
  }
}

extension AppSettingsQueryWhereSort
    on QueryBuilder<AppSettings, AppSettings, QWhere> {
  QueryBuilder<AppSettings, AppSettings, QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension AppSettingsQueryWhere
    on QueryBuilder<AppSettings, AppSettings, QWhereClause> {
  QueryBuilder<AppSettings, AppSettings, QAfterWhereClause> isarIdEqualTo(
      Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterWhereClause> isarIdNotEqualTo(
      Id isarId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterWhereClause> isarIdGreaterThan(
      Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterWhereClause> isarIdLessThan(
      Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterWhereClause> isarIdBetween(
    Id lowerIsarId,
    Id upperIsarId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerIsarId,
        includeLower: includeLower,
        upper: upperIsarId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterWhereClause> idEqualTo(
      String id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'id',
        value: [id],
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterWhereClause> idNotEqualTo(
      String id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'id',
              lower: [],
              upper: [id],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'id',
              lower: [id],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'id',
              lower: [id],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'id',
              lower: [],
              upper: [id],
              includeUpper: false,
            ));
      }
    });
  }
}

extension AppSettingsQueryFilter
    on QueryBuilder<AppSettings, AppSettings, QFilterCondition> {
  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      budgetResetDayEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'budgetResetDay',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      budgetResetDayGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'budgetResetDay',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      budgetResetDayLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'budgetResetDay',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      budgetResetDayBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'budgetResetDay',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      geminiApiKeyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'geminiApiKey',
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      geminiApiKeyIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'geminiApiKey',
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      geminiApiKeyEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'geminiApiKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      geminiApiKeyGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'geminiApiKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      geminiApiKeyLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'geminiApiKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      geminiApiKeyBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'geminiApiKey',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      geminiApiKeyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'geminiApiKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      geminiApiKeyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'geminiApiKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      geminiApiKeyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'geminiApiKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      geminiApiKeyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'geminiApiKey',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      geminiApiKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'geminiApiKey',
        value: '',
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      geminiApiKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'geminiApiKey',
        value: '',
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition> hashCodeEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hashCode',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      hashCodeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'hashCode',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      hashCodeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'hashCode',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition> hashCodeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'hashCode',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition> idEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition> idGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition> idLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition> idBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition> idStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition> idEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition> idContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition> idMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'id',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition> idIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition> idIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      incomeSourcesElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'incomeSources',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      incomeSourcesElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'incomeSources',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      incomeSourcesElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'incomeSources',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      incomeSourcesElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'incomeSources',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      incomeSourcesElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'incomeSources',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      incomeSourcesElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'incomeSources',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      incomeSourcesElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'incomeSources',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      incomeSourcesElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'incomeSources',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      incomeSourcesElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'incomeSources',
        value: '',
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      incomeSourcesElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'incomeSources',
        value: '',
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      incomeSourcesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'incomeSources',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      incomeSourcesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'incomeSources',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      incomeSourcesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'incomeSources',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      incomeSourcesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'incomeSources',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      incomeSourcesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'incomeSources',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      incomeSourcesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'incomeSources',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition> isarIdEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      isarIdGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition> isarIdLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition> isarIdBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'isarId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      lastSmsSyncIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastSmsSync',
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      lastSmsSyncIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastSmsSync',
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      lastSmsSyncEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastSmsSync',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      lastSmsSyncGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastSmsSync',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      lastSmsSyncLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastSmsSync',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      lastSmsSyncBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastSmsSync',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      monthlyIncomeTargetEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'monthlyIncomeTarget',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      monthlyIncomeTargetGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'monthlyIncomeTarget',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      monthlyIncomeTargetLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'monthlyIncomeTarget',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      monthlyIncomeTargetBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'monthlyIncomeTarget',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      onboardingCompleteEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'onboardingComplete',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      smsPermissionGrantedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'smsPermissionGranted',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition> themeEqualTo(
    AppThemeMode value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'theme',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      themeGreaterThan(
    AppThemeMode value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'theme',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition> themeLessThan(
    AppThemeMode value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'theme',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition> themeBetween(
    AppThemeMode lower,
    AppThemeMode upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'theme',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition> themeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'theme',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition> themeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'theme',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition> themeContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'theme',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition> themeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'theme',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition> themeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'theme',
        value: '',
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      themeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'theme',
        value: '',
      ));
    });
  }
}

extension AppSettingsQueryObject
    on QueryBuilder<AppSettings, AppSettings, QFilterCondition> {}

extension AppSettingsQueryLinks
    on QueryBuilder<AppSettings, AppSettings, QFilterCondition> {}

extension AppSettingsQuerySortBy
    on QueryBuilder<AppSettings, AppSettings, QSortBy> {
  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> sortByBudgetResetDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'budgetResetDay', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      sortByBudgetResetDayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'budgetResetDay', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> sortByGeminiApiKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'geminiApiKey', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      sortByGeminiApiKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'geminiApiKey', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> sortByHashCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> sortByHashCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> sortByLastSmsSync() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSmsSync', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> sortByLastSmsSyncDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSmsSync', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      sortByMonthlyIncomeTarget() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthlyIncomeTarget', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      sortByMonthlyIncomeTargetDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthlyIncomeTarget', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      sortByOnboardingComplete() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'onboardingComplete', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      sortByOnboardingCompleteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'onboardingComplete', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      sortBySmsPermissionGranted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'smsPermissionGranted', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      sortBySmsPermissionGrantedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'smsPermissionGranted', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> sortByTheme() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'theme', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> sortByThemeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'theme', Sort.desc);
    });
  }
}

extension AppSettingsQuerySortThenBy
    on QueryBuilder<AppSettings, AppSettings, QSortThenBy> {
  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> thenByBudgetResetDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'budgetResetDay', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      thenByBudgetResetDayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'budgetResetDay', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> thenByGeminiApiKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'geminiApiKey', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      thenByGeminiApiKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'geminiApiKey', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> thenByHashCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> thenByHashCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> thenByLastSmsSync() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSmsSync', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> thenByLastSmsSyncDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSmsSync', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      thenByMonthlyIncomeTarget() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthlyIncomeTarget', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      thenByMonthlyIncomeTargetDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthlyIncomeTarget', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      thenByOnboardingComplete() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'onboardingComplete', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      thenByOnboardingCompleteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'onboardingComplete', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      thenBySmsPermissionGranted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'smsPermissionGranted', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      thenBySmsPermissionGrantedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'smsPermissionGranted', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> thenByTheme() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'theme', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> thenByThemeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'theme', Sort.desc);
    });
  }
}

extension AppSettingsQueryWhereDistinct
    on QueryBuilder<AppSettings, AppSettings, QDistinct> {
  QueryBuilder<AppSettings, AppSettings, QDistinct> distinctByBudgetResetDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'budgetResetDay');
    });
  }

  QueryBuilder<AppSettings, AppSettings, QDistinct> distinctByGeminiApiKey(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'geminiApiKey', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QDistinct> distinctByHashCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hashCode');
    });
  }

  QueryBuilder<AppSettings, AppSettings, QDistinct> distinctById(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'id', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QDistinct> distinctByIncomeSources() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'incomeSources');
    });
  }

  QueryBuilder<AppSettings, AppSettings, QDistinct> distinctByLastSmsSync() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastSmsSync');
    });
  }

  QueryBuilder<AppSettings, AppSettings, QDistinct>
      distinctByMonthlyIncomeTarget() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'monthlyIncomeTarget');
    });
  }

  QueryBuilder<AppSettings, AppSettings, QDistinct>
      distinctByOnboardingComplete() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'onboardingComplete');
    });
  }

  QueryBuilder<AppSettings, AppSettings, QDistinct>
      distinctBySmsPermissionGranted() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'smsPermissionGranted');
    });
  }

  QueryBuilder<AppSettings, AppSettings, QDistinct> distinctByTheme(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'theme', caseSensitive: caseSensitive);
    });
  }
}

extension AppSettingsQueryProperty
    on QueryBuilder<AppSettings, AppSettings, QQueryProperty> {
  QueryBuilder<AppSettings, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<AppSettings, int, QQueryOperations> budgetResetDayProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'budgetResetDay');
    });
  }

  QueryBuilder<AppSettings, String?, QQueryOperations> geminiApiKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'geminiApiKey');
    });
  }

  QueryBuilder<AppSettings, int, QQueryOperations> hashCodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hashCode');
    });
  }

  QueryBuilder<AppSettings, String, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<AppSettings, List<String>, QQueryOperations>
      incomeSourcesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'incomeSources');
    });
  }

  QueryBuilder<AppSettings, DateTime?, QQueryOperations> lastSmsSyncProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastSmsSync');
    });
  }

  QueryBuilder<AppSettings, double, QQueryOperations>
      monthlyIncomeTargetProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'monthlyIncomeTarget');
    });
  }

  QueryBuilder<AppSettings, bool, QQueryOperations>
      onboardingCompleteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'onboardingComplete');
    });
  }

  QueryBuilder<AppSettings, bool, QQueryOperations>
      smsPermissionGrantedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'smsPermissionGranted');
    });
  }

  QueryBuilder<AppSettings, AppThemeMode, QQueryOperations> themeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'theme');
    });
  }
}
