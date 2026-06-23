// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'insight_card.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetInsightCardCollection on Isar {
  IsarCollection<InsightCard> get insightCards => this.collection();
}

const InsightCardSchema = CollectionSchema(
  name: r'InsightCard',
  id: 4171284350503816937,
  properties: {
    r'actionLabel': PropertySchema(
      id: 0,
      name: r'actionLabel',
      type: IsarType.string,
    ),
    r'actionRoute': PropertySchema(
      id: 1,
      name: r'actionRoute',
      type: IsarType.string,
    ),
    r'detail': PropertySchema(
      id: 2,
      name: r'detail',
      type: IsarType.string,
    ),
    r'dismissedUntil': PropertySchema(
      id: 3,
      name: r'dismissedUntil',
      type: IsarType.dateTime,
    ),
    r'generatedAt': PropertySchema(
      id: 4,
      name: r'generatedAt',
      type: IsarType.dateTime,
    ),
    r'hashCode': PropertySchema(
      id: 5,
      name: r'hashCode',
      type: IsarType.long,
    ),
    r'headline': PropertySchema(
      id: 6,
      name: r'headline',
      type: IsarType.string,
    ),
    r'id': PropertySchema(
      id: 7,
      name: r'id',
      type: IsarType.string,
    ),
    r'isDismissed': PropertySchema(
      id: 8,
      name: r'isDismissed',
      type: IsarType.bool,
    ),
    r'ruleId': PropertySchema(
      id: 9,
      name: r'ruleId',
      type: IsarType.string,
    ),
    r'type': PropertySchema(
      id: 10,
      name: r'type',
      type: IsarType.string,
      enumMap: _InsightCardtypeEnumValueMap,
    )
  },
  estimateSize: _insightCardEstimateSize,
  serialize: _insightCardSerialize,
  deserialize: _insightCardDeserialize,
  deserializeProp: _insightCardDeserializeProp,
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
  getId: _insightCardGetId,
  getLinks: _insightCardGetLinks,
  attach: _insightCardAttach,
  version: '3.1.0+1',
);

int _insightCardEstimateSize(
  InsightCard object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.actionLabel;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.actionRoute;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.detail.length * 3;
  bytesCount += 3 + object.headline.length * 3;
  bytesCount += 3 + object.id.length * 3;
  bytesCount += 3 + object.ruleId.length * 3;
  bytesCount += 3 + object.type.name.length * 3;
  return bytesCount;
}

void _insightCardSerialize(
  InsightCard object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.actionLabel);
  writer.writeString(offsets[1], object.actionRoute);
  writer.writeString(offsets[2], object.detail);
  writer.writeDateTime(offsets[3], object.dismissedUntil);
  writer.writeDateTime(offsets[4], object.generatedAt);
  writer.writeLong(offsets[5], object.hashCode);
  writer.writeString(offsets[6], object.headline);
  writer.writeString(offsets[7], object.id);
  writer.writeBool(offsets[8], object.isDismissed);
  writer.writeString(offsets[9], object.ruleId);
  writer.writeString(offsets[10], object.type.name);
}

InsightCard _insightCardDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = InsightCard(
    actionLabel: reader.readStringOrNull(offsets[0]),
    actionRoute: reader.readStringOrNull(offsets[1]),
    detail: reader.readString(offsets[2]),
    dismissedUntil: reader.readDateTimeOrNull(offsets[3]),
    generatedAt: reader.readDateTime(offsets[4]),
    headline: reader.readString(offsets[6]),
    id: reader.readString(offsets[7]),
    isDismissed: reader.readBool(offsets[8]),
    ruleId: reader.readString(offsets[9]),
    type: _InsightCardtypeValueEnumMap[reader.readStringOrNull(offsets[10])] ??
        InsightType.info,
  );
  return object;
}

P _insightCardDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 4:
      return (reader.readDateTime(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readBool(offset)) as P;
    case 9:
      return (reader.readString(offset)) as P;
    case 10:
      return (_InsightCardtypeValueEnumMap[reader.readStringOrNull(offset)] ??
          InsightType.info) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _InsightCardtypeEnumValueMap = {
  r'info': r'info',
  r'warning': r'warning',
  r'success': r'success',
  r'danger': r'danger',
};
const _InsightCardtypeValueEnumMap = {
  r'info': InsightType.info,
  r'warning': InsightType.warning,
  r'success': InsightType.success,
  r'danger': InsightType.danger,
};

Id _insightCardGetId(InsightCard object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _insightCardGetLinks(InsightCard object) {
  return [];
}

void _insightCardAttach(
    IsarCollection<dynamic> col, Id id, InsightCard object) {}

extension InsightCardByIndex on IsarCollection<InsightCard> {
  Future<InsightCard?> getById(String id) {
    return getByIndex(r'id', [id]);
  }

  InsightCard? getByIdSync(String id) {
    return getByIndexSync(r'id', [id]);
  }

  Future<bool> deleteById(String id) {
    return deleteByIndex(r'id', [id]);
  }

  bool deleteByIdSync(String id) {
    return deleteByIndexSync(r'id', [id]);
  }

  Future<List<InsightCard?>> getAllById(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return getAllByIndex(r'id', values);
  }

  List<InsightCard?> getAllByIdSync(List<String> idValues) {
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

  Future<Id> putById(InsightCard object) {
    return putByIndex(r'id', object);
  }

  Id putByIdSync(InsightCard object, {bool saveLinks = true}) {
    return putByIndexSync(r'id', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllById(List<InsightCard> objects) {
    return putAllByIndex(r'id', objects);
  }

  List<Id> putAllByIdSync(List<InsightCard> objects, {bool saveLinks = true}) {
    return putAllByIndexSync(r'id', objects, saveLinks: saveLinks);
  }
}

extension InsightCardQueryWhereSort
    on QueryBuilder<InsightCard, InsightCard, QWhere> {
  QueryBuilder<InsightCard, InsightCard, QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension InsightCardQueryWhere
    on QueryBuilder<InsightCard, InsightCard, QWhereClause> {
  QueryBuilder<InsightCard, InsightCard, QAfterWhereClause> isarIdEqualTo(
      Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterWhereClause> isarIdNotEqualTo(
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

  QueryBuilder<InsightCard, InsightCard, QAfterWhereClause> isarIdGreaterThan(
      Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterWhereClause> isarIdLessThan(
      Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterWhereClause> isarIdBetween(
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

  QueryBuilder<InsightCard, InsightCard, QAfterWhereClause> idEqualTo(
      String id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'id',
        value: [id],
      ));
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterWhereClause> idNotEqualTo(
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

extension InsightCardQueryFilter
    on QueryBuilder<InsightCard, InsightCard, QFilterCondition> {
  QueryBuilder<InsightCard, InsightCard, QAfterFilterCondition>
      actionLabelIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'actionLabel',
      ));
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterFilterCondition>
      actionLabelIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'actionLabel',
      ));
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterFilterCondition>
      actionLabelEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'actionLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterFilterCondition>
      actionLabelGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'actionLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterFilterCondition>
      actionLabelLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'actionLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterFilterCondition>
      actionLabelBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'actionLabel',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterFilterCondition>
      actionLabelStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'actionLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterFilterCondition>
      actionLabelEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'actionLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterFilterCondition>
      actionLabelContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'actionLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterFilterCondition>
      actionLabelMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'actionLabel',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterFilterCondition>
      actionLabelIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'actionLabel',
        value: '',
      ));
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterFilterCondition>
      actionLabelIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'actionLabel',
        value: '',
      ));
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterFilterCondition>
      actionRouteIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'actionRoute',
      ));
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterFilterCondition>
      actionRouteIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'actionRoute',
      ));
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterFilterCondition>
      actionRouteEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'actionRoute',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterFilterCondition>
      actionRouteGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'actionRoute',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterFilterCondition>
      actionRouteLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'actionRoute',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterFilterCondition>
      actionRouteBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'actionRoute',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterFilterCondition>
      actionRouteStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'actionRoute',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterFilterCondition>
      actionRouteEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'actionRoute',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterFilterCondition>
      actionRouteContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'actionRoute',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterFilterCondition>
      actionRouteMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'actionRoute',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterFilterCondition>
      actionRouteIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'actionRoute',
        value: '',
      ));
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterFilterCondition>
      actionRouteIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'actionRoute',
        value: '',
      ));
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterFilterCondition> detailEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'detail',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterFilterCondition>
      detailGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'detail',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterFilterCondition> detailLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'detail',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterFilterCondition> detailBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'detail',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterFilterCondition>
      detailStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'detail',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterFilterCondition> detailEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'detail',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterFilterCondition> detailContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'detail',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterFilterCondition> detailMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'detail',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterFilterCondition>
      detailIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'detail',
        value: '',
      ));
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterFilterCondition>
      detailIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'detail',
        value: '',
      ));
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterFilterCondition>
      dismissedUntilIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'dismissedUntil',
      ));
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterFilterCondition>
      dismissedUntilIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'dismissedUntil',
      ));
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterFilterCondition>
      dismissedUntilEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dismissedUntil',
        value: value,
      ));
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterFilterCondition>
      dismissedUntilGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dismissedUntil',
        value: value,
      ));
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterFilterCondition>
      dismissedUntilLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dismissedUntil',
        value: value,
      ));
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterFilterCondition>
      dismissedUntilBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dismissedUntil',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterFilterCondition>
      generatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'generatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterFilterCondition>
      generatedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'generatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterFilterCondition>
      generatedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'generatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterFilterCondition>
      generatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'generatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterFilterCondition> hashCodeEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hashCode',
        value: value,
      ));
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterFilterCondition>
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

  QueryBuilder<InsightCard, InsightCard, QAfterFilterCondition>
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

  QueryBuilder<InsightCard, InsightCard, QAfterFilterCondition> hashCodeBetween(
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

  QueryBuilder<InsightCard, InsightCard, QAfterFilterCondition> headlineEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'headline',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterFilterCondition>
      headlineGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'headline',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterFilterCondition>
      headlineLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'headline',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterFilterCondition> headlineBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'headline',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterFilterCondition>
      headlineStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'headline',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterFilterCondition>
      headlineEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'headline',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterFilterCondition>
      headlineContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'headline',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterFilterCondition> headlineMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'headline',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterFilterCondition>
      headlineIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'headline',
        value: '',
      ));
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterFilterCondition>
      headlineIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'headline',
        value: '',
      ));
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterFilterCondition> idEqualTo(
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

  QueryBuilder<InsightCard, InsightCard, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<InsightCard, InsightCard, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<InsightCard, InsightCard, QAfterFilterCondition> idBetween(
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

  QueryBuilder<InsightCard, InsightCard, QAfterFilterCondition> idStartsWith(
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

  QueryBuilder<InsightCard, InsightCard, QAfterFilterCondition> idEndsWith(
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

  QueryBuilder<InsightCard, InsightCard, QAfterFilterCondition> idContains(
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

  QueryBuilder<InsightCard, InsightCard, QAfterFilterCondition> idMatches(
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

  QueryBuilder<InsightCard, InsightCard, QAfterFilterCondition> idIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterFilterCondition> idIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterFilterCondition>
      isDismissedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isDismissed',
        value: value,
      ));
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterFilterCondition> isarIdEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterFilterCondition>
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

  QueryBuilder<InsightCard, InsightCard, QAfterFilterCondition> isarIdLessThan(
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

  QueryBuilder<InsightCard, InsightCard, QAfterFilterCondition> isarIdBetween(
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

  QueryBuilder<InsightCard, InsightCard, QAfterFilterCondition> ruleIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ruleId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterFilterCondition>
      ruleIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'ruleId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterFilterCondition> ruleIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'ruleId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterFilterCondition> ruleIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'ruleId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterFilterCondition>
      ruleIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'ruleId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterFilterCondition> ruleIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'ruleId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterFilterCondition> ruleIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'ruleId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterFilterCondition> ruleIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'ruleId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterFilterCondition>
      ruleIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ruleId',
        value: '',
      ));
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterFilterCondition>
      ruleIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'ruleId',
        value: '',
      ));
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterFilterCondition> typeEqualTo(
    InsightType value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterFilterCondition> typeGreaterThan(
    InsightType value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterFilterCondition> typeLessThan(
    InsightType value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterFilterCondition> typeBetween(
    InsightType lower,
    InsightType upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'type',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterFilterCondition> typeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterFilterCondition> typeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterFilterCondition> typeContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterFilterCondition> typeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'type',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterFilterCondition> typeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: '',
      ));
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterFilterCondition>
      typeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'type',
        value: '',
      ));
    });
  }
}

extension InsightCardQueryObject
    on QueryBuilder<InsightCard, InsightCard, QFilterCondition> {}

extension InsightCardQueryLinks
    on QueryBuilder<InsightCard, InsightCard, QFilterCondition> {}

extension InsightCardQuerySortBy
    on QueryBuilder<InsightCard, InsightCard, QSortBy> {
  QueryBuilder<InsightCard, InsightCard, QAfterSortBy> sortByActionLabel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actionLabel', Sort.asc);
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterSortBy> sortByActionLabelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actionLabel', Sort.desc);
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterSortBy> sortByActionRoute() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actionRoute', Sort.asc);
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterSortBy> sortByActionRouteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actionRoute', Sort.desc);
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterSortBy> sortByDetail() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'detail', Sort.asc);
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterSortBy> sortByDetailDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'detail', Sort.desc);
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterSortBy> sortByDismissedUntil() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dismissedUntil', Sort.asc);
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterSortBy>
      sortByDismissedUntilDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dismissedUntil', Sort.desc);
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterSortBy> sortByGeneratedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'generatedAt', Sort.asc);
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterSortBy> sortByGeneratedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'generatedAt', Sort.desc);
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterSortBy> sortByHashCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.asc);
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterSortBy> sortByHashCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.desc);
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterSortBy> sortByHeadline() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'headline', Sort.asc);
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterSortBy> sortByHeadlineDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'headline', Sort.desc);
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterSortBy> sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterSortBy> sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterSortBy> sortByIsDismissed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDismissed', Sort.asc);
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterSortBy> sortByIsDismissedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDismissed', Sort.desc);
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterSortBy> sortByRuleId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ruleId', Sort.asc);
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterSortBy> sortByRuleIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ruleId', Sort.desc);
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterSortBy> sortByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterSortBy> sortByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension InsightCardQuerySortThenBy
    on QueryBuilder<InsightCard, InsightCard, QSortThenBy> {
  QueryBuilder<InsightCard, InsightCard, QAfterSortBy> thenByActionLabel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actionLabel', Sort.asc);
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterSortBy> thenByActionLabelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actionLabel', Sort.desc);
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterSortBy> thenByActionRoute() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actionRoute', Sort.asc);
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterSortBy> thenByActionRouteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actionRoute', Sort.desc);
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterSortBy> thenByDetail() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'detail', Sort.asc);
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterSortBy> thenByDetailDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'detail', Sort.desc);
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterSortBy> thenByDismissedUntil() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dismissedUntil', Sort.asc);
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterSortBy>
      thenByDismissedUntilDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dismissedUntil', Sort.desc);
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterSortBy> thenByGeneratedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'generatedAt', Sort.asc);
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterSortBy> thenByGeneratedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'generatedAt', Sort.desc);
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterSortBy> thenByHashCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.asc);
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterSortBy> thenByHashCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.desc);
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterSortBy> thenByHeadline() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'headline', Sort.asc);
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterSortBy> thenByHeadlineDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'headline', Sort.desc);
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterSortBy> thenByIsDismissed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDismissed', Sort.asc);
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterSortBy> thenByIsDismissedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDismissed', Sort.desc);
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterSortBy> thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterSortBy> thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterSortBy> thenByRuleId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ruleId', Sort.asc);
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterSortBy> thenByRuleIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ruleId', Sort.desc);
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterSortBy> thenByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<InsightCard, InsightCard, QAfterSortBy> thenByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension InsightCardQueryWhereDistinct
    on QueryBuilder<InsightCard, InsightCard, QDistinct> {
  QueryBuilder<InsightCard, InsightCard, QDistinct> distinctByActionLabel(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'actionLabel', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<InsightCard, InsightCard, QDistinct> distinctByActionRoute(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'actionRoute', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<InsightCard, InsightCard, QDistinct> distinctByDetail(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'detail', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<InsightCard, InsightCard, QDistinct> distinctByDismissedUntil() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dismissedUntil');
    });
  }

  QueryBuilder<InsightCard, InsightCard, QDistinct> distinctByGeneratedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'generatedAt');
    });
  }

  QueryBuilder<InsightCard, InsightCard, QDistinct> distinctByHashCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hashCode');
    });
  }

  QueryBuilder<InsightCard, InsightCard, QDistinct> distinctByHeadline(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'headline', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<InsightCard, InsightCard, QDistinct> distinctById(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'id', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<InsightCard, InsightCard, QDistinct> distinctByIsDismissed() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isDismissed');
    });
  }

  QueryBuilder<InsightCard, InsightCard, QDistinct> distinctByRuleId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ruleId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<InsightCard, InsightCard, QDistinct> distinctByType(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'type', caseSensitive: caseSensitive);
    });
  }
}

extension InsightCardQueryProperty
    on QueryBuilder<InsightCard, InsightCard, QQueryProperty> {
  QueryBuilder<InsightCard, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<InsightCard, String?, QQueryOperations> actionLabelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'actionLabel');
    });
  }

  QueryBuilder<InsightCard, String?, QQueryOperations> actionRouteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'actionRoute');
    });
  }

  QueryBuilder<InsightCard, String, QQueryOperations> detailProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'detail');
    });
  }

  QueryBuilder<InsightCard, DateTime?, QQueryOperations>
      dismissedUntilProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dismissedUntil');
    });
  }

  QueryBuilder<InsightCard, DateTime, QQueryOperations> generatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'generatedAt');
    });
  }

  QueryBuilder<InsightCard, int, QQueryOperations> hashCodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hashCode');
    });
  }

  QueryBuilder<InsightCard, String, QQueryOperations> headlineProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'headline');
    });
  }

  QueryBuilder<InsightCard, String, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<InsightCard, bool, QQueryOperations> isDismissedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isDismissed');
    });
  }

  QueryBuilder<InsightCard, String, QQueryOperations> ruleIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ruleId');
    });
  }

  QueryBuilder<InsightCard, InsightType, QQueryOperations> typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'type');
    });
  }
}
