// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'advisor_card.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetAdvisorCardCollection on Isar {
  IsarCollection<AdvisorCard> get advisorCards => this.collection();
}

const AdvisorCardSchema = CollectionSchema(
  name: r'AdvisorCard',
  id: 2181036001923463441,
  properties: {
    r'capabilityId': PropertySchema(
      id: 0,
      name: r'capabilityId',
      type: IsarType.string,
    ),
    r'detail': PropertySchema(
      id: 1,
      name: r'detail',
      type: IsarType.string,
    ),
    r'dismissedUntil': PropertySchema(
      id: 2,
      name: r'dismissedUntil',
      type: IsarType.dateTime,
    ),
    r'generatedAt': PropertySchema(
      id: 3,
      name: r'generatedAt',
      type: IsarType.dateTime,
    ),
    r'hashCode': PropertySchema(
      id: 4,
      name: r'hashCode',
      type: IsarType.long,
    ),
    r'headline': PropertySchema(
      id: 5,
      name: r'headline',
      type: IsarType.string,
    ),
    r'id': PropertySchema(
      id: 6,
      name: r'id',
      type: IsarType.string,
    ),
    r'isDismissed': PropertySchema(
      id: 7,
      name: r'isDismissed',
      type: IsarType.bool,
    ),
    r'primaryActionLabel': PropertySchema(
      id: 8,
      name: r'primaryActionLabel',
      type: IsarType.string,
    ),
    r'primaryActionPayload': PropertySchema(
      id: 9,
      name: r'primaryActionPayload',
      type: IsarType.string,
    ),
    r'primaryActionType': PropertySchema(
      id: 10,
      name: r'primaryActionType',
      type: IsarType.string,
      enumMap: _AdvisorCardprimaryActionTypeEnumValueMap,
    ),
    r'secondaryActionLabel': PropertySchema(
      id: 11,
      name: r'secondaryActionLabel',
      type: IsarType.string,
    ),
    r'type': PropertySchema(
      id: 12,
      name: r'type',
      type: IsarType.string,
      enumMap: _AdvisorCardtypeEnumValueMap,
    )
  },
  estimateSize: _advisorCardEstimateSize,
  serialize: _advisorCardSerialize,
  deserialize: _advisorCardDeserialize,
  deserializeProp: _advisorCardDeserializeProp,
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
  getId: _advisorCardGetId,
  getLinks: _advisorCardGetLinks,
  attach: _advisorCardAttach,
  version: '3.1.0+1',
);

int _advisorCardEstimateSize(
  AdvisorCard object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.capabilityId.length * 3;
  bytesCount += 3 + object.detail.length * 3;
  bytesCount += 3 + object.headline.length * 3;
  bytesCount += 3 + object.id.length * 3;
  {
    final value = object.primaryActionLabel;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.primaryActionPayload;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.primaryActionType;
    if (value != null) {
      bytesCount += 3 + value.name.length * 3;
    }
  }
  {
    final value = object.secondaryActionLabel;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.type.name.length * 3;
  return bytesCount;
}

void _advisorCardSerialize(
  AdvisorCard object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.capabilityId);
  writer.writeString(offsets[1], object.detail);
  writer.writeDateTime(offsets[2], object.dismissedUntil);
  writer.writeDateTime(offsets[3], object.generatedAt);
  writer.writeLong(offsets[4], object.hashCode);
  writer.writeString(offsets[5], object.headline);
  writer.writeString(offsets[6], object.id);
  writer.writeBool(offsets[7], object.isDismissed);
  writer.writeString(offsets[8], object.primaryActionLabel);
  writer.writeString(offsets[9], object.primaryActionPayload);
  writer.writeString(offsets[10], object.primaryActionType?.name);
  writer.writeString(offsets[11], object.secondaryActionLabel);
  writer.writeString(offsets[12], object.type.name);
}

AdvisorCard _advisorCardDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = AdvisorCard(
    capabilityId: reader.readString(offsets[0]),
    detail: reader.readString(offsets[1]),
    dismissedUntil: reader.readDateTimeOrNull(offsets[2]),
    generatedAt: reader.readDateTime(offsets[3]),
    headline: reader.readString(offsets[5]),
    id: reader.readString(offsets[6]),
    isDismissed: reader.readBool(offsets[7]),
    primaryActionLabel: reader.readStringOrNull(offsets[8]),
    primaryActionPayload: reader.readStringOrNull(offsets[9]),
    primaryActionType: _AdvisorCardprimaryActionTypeValueEnumMap[
        reader.readStringOrNull(offsets[10])],
    secondaryActionLabel: reader.readStringOrNull(offsets[11]),
    type: _AdvisorCardtypeValueEnumMap[reader.readStringOrNull(offsets[12])] ??
        InsightType.info,
  );
  return object;
}

P _advisorCardDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readBool(offset)) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    case 9:
      return (reader.readStringOrNull(offset)) as P;
    case 10:
      return (_AdvisorCardprimaryActionTypeValueEnumMap[
          reader.readStringOrNull(offset)]) as P;
    case 11:
      return (reader.readStringOrNull(offset)) as P;
    case 12:
      return (_AdvisorCardtypeValueEnumMap[reader.readStringOrNull(offset)] ??
          InsightType.info) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _AdvisorCardprimaryActionTypeEnumValueMap = {
  r'pauseGoal': r'pauseGoal',
  r'setBudget': r'setBudget',
  r'navigate': r'navigate',
};
const _AdvisorCardprimaryActionTypeValueEnumMap = {
  r'pauseGoal': AdvisorActionType.pauseGoal,
  r'setBudget': AdvisorActionType.setBudget,
  r'navigate': AdvisorActionType.navigate,
};
const _AdvisorCardtypeEnumValueMap = {
  r'info': r'info',
  r'warning': r'warning',
  r'success': r'success',
  r'danger': r'danger',
};
const _AdvisorCardtypeValueEnumMap = {
  r'info': InsightType.info,
  r'warning': InsightType.warning,
  r'success': InsightType.success,
  r'danger': InsightType.danger,
};

Id _advisorCardGetId(AdvisorCard object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _advisorCardGetLinks(AdvisorCard object) {
  return [];
}

void _advisorCardAttach(
    IsarCollection<dynamic> col, Id id, AdvisorCard object) {}

extension AdvisorCardByIndex on IsarCollection<AdvisorCard> {
  Future<AdvisorCard?> getById(String id) {
    return getByIndex(r'id', [id]);
  }

  AdvisorCard? getByIdSync(String id) {
    return getByIndexSync(r'id', [id]);
  }

  Future<bool> deleteById(String id) {
    return deleteByIndex(r'id', [id]);
  }

  bool deleteByIdSync(String id) {
    return deleteByIndexSync(r'id', [id]);
  }

  Future<List<AdvisorCard?>> getAllById(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return getAllByIndex(r'id', values);
  }

  List<AdvisorCard?> getAllByIdSync(List<String> idValues) {
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

  Future<Id> putById(AdvisorCard object) {
    return putByIndex(r'id', object);
  }

  Id putByIdSync(AdvisorCard object, {bool saveLinks = true}) {
    return putByIndexSync(r'id', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllById(List<AdvisorCard> objects) {
    return putAllByIndex(r'id', objects);
  }

  List<Id> putAllByIdSync(List<AdvisorCard> objects, {bool saveLinks = true}) {
    return putAllByIndexSync(r'id', objects, saveLinks: saveLinks);
  }
}

extension AdvisorCardQueryWhereSort
    on QueryBuilder<AdvisorCard, AdvisorCard, QWhere> {
  QueryBuilder<AdvisorCard, AdvisorCard, QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension AdvisorCardQueryWhere
    on QueryBuilder<AdvisorCard, AdvisorCard, QWhereClause> {
  QueryBuilder<AdvisorCard, AdvisorCard, QAfterWhereClause> isarIdEqualTo(
      Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterWhereClause> isarIdNotEqualTo(
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

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterWhereClause> isarIdGreaterThan(
      Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterWhereClause> isarIdLessThan(
      Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterWhereClause> isarIdBetween(
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

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterWhereClause> idEqualTo(
      String id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'id',
        value: [id],
      ));
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterWhereClause> idNotEqualTo(
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

extension AdvisorCardQueryFilter
    on QueryBuilder<AdvisorCard, AdvisorCard, QFilterCondition> {
  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition>
      capabilityIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'capabilityId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition>
      capabilityIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'capabilityId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition>
      capabilityIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'capabilityId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition>
      capabilityIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'capabilityId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition>
      capabilityIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'capabilityId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition>
      capabilityIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'capabilityId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition>
      capabilityIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'capabilityId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition>
      capabilityIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'capabilityId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition>
      capabilityIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'capabilityId',
        value: '',
      ));
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition>
      capabilityIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'capabilityId',
        value: '',
      ));
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition> detailEqualTo(
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

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition>
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

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition> detailLessThan(
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

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition> detailBetween(
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

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition>
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

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition> detailEndsWith(
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

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition> detailContains(
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

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition> detailMatches(
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

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition>
      detailIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'detail',
        value: '',
      ));
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition>
      detailIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'detail',
        value: '',
      ));
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition>
      dismissedUntilIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'dismissedUntil',
      ));
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition>
      dismissedUntilIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'dismissedUntil',
      ));
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition>
      dismissedUntilEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dismissedUntil',
        value: value,
      ));
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition>
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

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition>
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

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition>
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

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition>
      generatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'generatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition>
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

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition>
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

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition>
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

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition> hashCodeEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hashCode',
        value: value,
      ));
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition>
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

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition>
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

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition> hashCodeBetween(
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

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition> headlineEqualTo(
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

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition>
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

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition>
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

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition> headlineBetween(
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

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition>
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

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition>
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

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition>
      headlineContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'headline',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition> headlineMatches(
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

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition>
      headlineIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'headline',
        value: '',
      ));
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition>
      headlineIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'headline',
        value: '',
      ));
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition> idEqualTo(
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

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition> idBetween(
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

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition> idStartsWith(
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

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition> idEndsWith(
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

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition> idContains(
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

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition> idMatches(
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

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition> idIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition> idIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition>
      isDismissedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isDismissed',
        value: value,
      ));
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition> isarIdEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition>
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

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition> isarIdLessThan(
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

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition> isarIdBetween(
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

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition>
      primaryActionLabelIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'primaryActionLabel',
      ));
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition>
      primaryActionLabelIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'primaryActionLabel',
      ));
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition>
      primaryActionLabelEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'primaryActionLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition>
      primaryActionLabelGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'primaryActionLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition>
      primaryActionLabelLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'primaryActionLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition>
      primaryActionLabelBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'primaryActionLabel',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition>
      primaryActionLabelStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'primaryActionLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition>
      primaryActionLabelEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'primaryActionLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition>
      primaryActionLabelContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'primaryActionLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition>
      primaryActionLabelMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'primaryActionLabel',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition>
      primaryActionLabelIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'primaryActionLabel',
        value: '',
      ));
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition>
      primaryActionLabelIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'primaryActionLabel',
        value: '',
      ));
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition>
      primaryActionPayloadIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'primaryActionPayload',
      ));
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition>
      primaryActionPayloadIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'primaryActionPayload',
      ));
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition>
      primaryActionPayloadEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'primaryActionPayload',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition>
      primaryActionPayloadGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'primaryActionPayload',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition>
      primaryActionPayloadLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'primaryActionPayload',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition>
      primaryActionPayloadBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'primaryActionPayload',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition>
      primaryActionPayloadStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'primaryActionPayload',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition>
      primaryActionPayloadEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'primaryActionPayload',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition>
      primaryActionPayloadContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'primaryActionPayload',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition>
      primaryActionPayloadMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'primaryActionPayload',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition>
      primaryActionPayloadIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'primaryActionPayload',
        value: '',
      ));
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition>
      primaryActionPayloadIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'primaryActionPayload',
        value: '',
      ));
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition>
      primaryActionTypeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'primaryActionType',
      ));
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition>
      primaryActionTypeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'primaryActionType',
      ));
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition>
      primaryActionTypeEqualTo(
    AdvisorActionType? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'primaryActionType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition>
      primaryActionTypeGreaterThan(
    AdvisorActionType? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'primaryActionType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition>
      primaryActionTypeLessThan(
    AdvisorActionType? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'primaryActionType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition>
      primaryActionTypeBetween(
    AdvisorActionType? lower,
    AdvisorActionType? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'primaryActionType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition>
      primaryActionTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'primaryActionType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition>
      primaryActionTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'primaryActionType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition>
      primaryActionTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'primaryActionType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition>
      primaryActionTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'primaryActionType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition>
      primaryActionTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'primaryActionType',
        value: '',
      ));
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition>
      primaryActionTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'primaryActionType',
        value: '',
      ));
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition>
      secondaryActionLabelIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'secondaryActionLabel',
      ));
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition>
      secondaryActionLabelIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'secondaryActionLabel',
      ));
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition>
      secondaryActionLabelEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'secondaryActionLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition>
      secondaryActionLabelGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'secondaryActionLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition>
      secondaryActionLabelLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'secondaryActionLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition>
      secondaryActionLabelBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'secondaryActionLabel',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition>
      secondaryActionLabelStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'secondaryActionLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition>
      secondaryActionLabelEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'secondaryActionLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition>
      secondaryActionLabelContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'secondaryActionLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition>
      secondaryActionLabelMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'secondaryActionLabel',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition>
      secondaryActionLabelIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'secondaryActionLabel',
        value: '',
      ));
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition>
      secondaryActionLabelIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'secondaryActionLabel',
        value: '',
      ));
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition> typeEqualTo(
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

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition> typeGreaterThan(
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

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition> typeLessThan(
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

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition> typeBetween(
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

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition> typeStartsWith(
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

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition> typeEndsWith(
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

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition> typeContains(
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

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition> typeMatches(
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

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition> typeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: '',
      ));
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterFilterCondition>
      typeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'type',
        value: '',
      ));
    });
  }
}

extension AdvisorCardQueryObject
    on QueryBuilder<AdvisorCard, AdvisorCard, QFilterCondition> {}

extension AdvisorCardQueryLinks
    on QueryBuilder<AdvisorCard, AdvisorCard, QFilterCondition> {}

extension AdvisorCardQuerySortBy
    on QueryBuilder<AdvisorCard, AdvisorCard, QSortBy> {
  QueryBuilder<AdvisorCard, AdvisorCard, QAfterSortBy> sortByCapabilityId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'capabilityId', Sort.asc);
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterSortBy>
      sortByCapabilityIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'capabilityId', Sort.desc);
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterSortBy> sortByDetail() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'detail', Sort.asc);
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterSortBy> sortByDetailDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'detail', Sort.desc);
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterSortBy> sortByDismissedUntil() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dismissedUntil', Sort.asc);
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterSortBy>
      sortByDismissedUntilDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dismissedUntil', Sort.desc);
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterSortBy> sortByGeneratedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'generatedAt', Sort.asc);
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterSortBy> sortByGeneratedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'generatedAt', Sort.desc);
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterSortBy> sortByHashCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.asc);
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterSortBy> sortByHashCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.desc);
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterSortBy> sortByHeadline() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'headline', Sort.asc);
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterSortBy> sortByHeadlineDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'headline', Sort.desc);
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterSortBy> sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterSortBy> sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterSortBy> sortByIsDismissed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDismissed', Sort.asc);
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterSortBy> sortByIsDismissedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDismissed', Sort.desc);
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterSortBy>
      sortByPrimaryActionLabel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'primaryActionLabel', Sort.asc);
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterSortBy>
      sortByPrimaryActionLabelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'primaryActionLabel', Sort.desc);
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterSortBy>
      sortByPrimaryActionPayload() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'primaryActionPayload', Sort.asc);
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterSortBy>
      sortByPrimaryActionPayloadDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'primaryActionPayload', Sort.desc);
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterSortBy>
      sortByPrimaryActionType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'primaryActionType', Sort.asc);
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterSortBy>
      sortByPrimaryActionTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'primaryActionType', Sort.desc);
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterSortBy>
      sortBySecondaryActionLabel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'secondaryActionLabel', Sort.asc);
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterSortBy>
      sortBySecondaryActionLabelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'secondaryActionLabel', Sort.desc);
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterSortBy> sortByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterSortBy> sortByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension AdvisorCardQuerySortThenBy
    on QueryBuilder<AdvisorCard, AdvisorCard, QSortThenBy> {
  QueryBuilder<AdvisorCard, AdvisorCard, QAfterSortBy> thenByCapabilityId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'capabilityId', Sort.asc);
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterSortBy>
      thenByCapabilityIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'capabilityId', Sort.desc);
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterSortBy> thenByDetail() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'detail', Sort.asc);
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterSortBy> thenByDetailDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'detail', Sort.desc);
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterSortBy> thenByDismissedUntil() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dismissedUntil', Sort.asc);
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterSortBy>
      thenByDismissedUntilDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dismissedUntil', Sort.desc);
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterSortBy> thenByGeneratedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'generatedAt', Sort.asc);
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterSortBy> thenByGeneratedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'generatedAt', Sort.desc);
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterSortBy> thenByHashCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.asc);
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterSortBy> thenByHashCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.desc);
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterSortBy> thenByHeadline() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'headline', Sort.asc);
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterSortBy> thenByHeadlineDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'headline', Sort.desc);
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterSortBy> thenByIsDismissed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDismissed', Sort.asc);
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterSortBy> thenByIsDismissedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDismissed', Sort.desc);
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterSortBy> thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterSortBy> thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterSortBy>
      thenByPrimaryActionLabel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'primaryActionLabel', Sort.asc);
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterSortBy>
      thenByPrimaryActionLabelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'primaryActionLabel', Sort.desc);
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterSortBy>
      thenByPrimaryActionPayload() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'primaryActionPayload', Sort.asc);
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterSortBy>
      thenByPrimaryActionPayloadDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'primaryActionPayload', Sort.desc);
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterSortBy>
      thenByPrimaryActionType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'primaryActionType', Sort.asc);
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterSortBy>
      thenByPrimaryActionTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'primaryActionType', Sort.desc);
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterSortBy>
      thenBySecondaryActionLabel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'secondaryActionLabel', Sort.asc);
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterSortBy>
      thenBySecondaryActionLabelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'secondaryActionLabel', Sort.desc);
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterSortBy> thenByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QAfterSortBy> thenByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension AdvisorCardQueryWhereDistinct
    on QueryBuilder<AdvisorCard, AdvisorCard, QDistinct> {
  QueryBuilder<AdvisorCard, AdvisorCard, QDistinct> distinctByCapabilityId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'capabilityId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QDistinct> distinctByDetail(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'detail', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QDistinct> distinctByDismissedUntil() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dismissedUntil');
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QDistinct> distinctByGeneratedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'generatedAt');
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QDistinct> distinctByHashCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hashCode');
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QDistinct> distinctByHeadline(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'headline', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QDistinct> distinctById(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'id', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QDistinct> distinctByIsDismissed() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isDismissed');
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QDistinct>
      distinctByPrimaryActionLabel({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'primaryActionLabel',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QDistinct>
      distinctByPrimaryActionPayload({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'primaryActionPayload',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QDistinct> distinctByPrimaryActionType(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'primaryActionType',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QDistinct>
      distinctBySecondaryActionLabel({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'secondaryActionLabel',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AdvisorCard, AdvisorCard, QDistinct> distinctByType(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'type', caseSensitive: caseSensitive);
    });
  }
}

extension AdvisorCardQueryProperty
    on QueryBuilder<AdvisorCard, AdvisorCard, QQueryProperty> {
  QueryBuilder<AdvisorCard, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<AdvisorCard, String, QQueryOperations> capabilityIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'capabilityId');
    });
  }

  QueryBuilder<AdvisorCard, String, QQueryOperations> detailProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'detail');
    });
  }

  QueryBuilder<AdvisorCard, DateTime?, QQueryOperations>
      dismissedUntilProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dismissedUntil');
    });
  }

  QueryBuilder<AdvisorCard, DateTime, QQueryOperations> generatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'generatedAt');
    });
  }

  QueryBuilder<AdvisorCard, int, QQueryOperations> hashCodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hashCode');
    });
  }

  QueryBuilder<AdvisorCard, String, QQueryOperations> headlineProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'headline');
    });
  }

  QueryBuilder<AdvisorCard, String, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<AdvisorCard, bool, QQueryOperations> isDismissedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isDismissed');
    });
  }

  QueryBuilder<AdvisorCard, String?, QQueryOperations>
      primaryActionLabelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'primaryActionLabel');
    });
  }

  QueryBuilder<AdvisorCard, String?, QQueryOperations>
      primaryActionPayloadProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'primaryActionPayload');
    });
  }

  QueryBuilder<AdvisorCard, AdvisorActionType?, QQueryOperations>
      primaryActionTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'primaryActionType');
    });
  }

  QueryBuilder<AdvisorCard, String?, QQueryOperations>
      secondaryActionLabelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'secondaryActionLabel');
    });
  }

  QueryBuilder<AdvisorCard, InsightType, QQueryOperations> typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'type');
    });
  }
}
