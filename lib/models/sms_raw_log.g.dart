// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sms_raw_log.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSmsRawLogCollection on Isar {
  IsarCollection<SmsRawLog> get smsRawLogs => this.collection();
}

const SmsRawLogSchema = CollectionSchema(
  name: r'SmsRawLog',
  id: 5679243073795266111,
  properties: {
    r'hashCode': PropertySchema(
      id: 0,
      name: r'hashCode',
      type: IsarType.long,
    ),
    r'id': PropertySchema(
      id: 1,
      name: r'id',
      type: IsarType.string,
    ),
    r'isParsed': PropertySchema(
      id: 2,
      name: r'isParsed',
      type: IsarType.bool,
    ),
    r'linkedTransactionId': PropertySchema(
      id: 3,
      name: r'linkedTransactionId',
      type: IsarType.string,
    ),
    r'rawBody': PropertySchema(
      id: 4,
      name: r'rawBody',
      type: IsarType.string,
    ),
    r'receivedAt': PropertySchema(
      id: 5,
      name: r'receivedAt',
      type: IsarType.dateTime,
    ),
    r'sender': PropertySchema(
      id: 6,
      name: r'sender',
      type: IsarType.string,
    )
  },
  estimateSize: _smsRawLogEstimateSize,
  serialize: _smsRawLogSerialize,
  deserialize: _smsRawLogDeserialize,
  deserializeProp: _smsRawLogDeserializeProp,
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
  getId: _smsRawLogGetId,
  getLinks: _smsRawLogGetLinks,
  attach: _smsRawLogAttach,
  version: '3.1.0+1',
);

int _smsRawLogEstimateSize(
  SmsRawLog object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.id.length * 3;
  {
    final value = object.linkedTransactionId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.rawBody.length * 3;
  bytesCount += 3 + object.sender.length * 3;
  return bytesCount;
}

void _smsRawLogSerialize(
  SmsRawLog object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.hashCode);
  writer.writeString(offsets[1], object.id);
  writer.writeBool(offsets[2], object.isParsed);
  writer.writeString(offsets[3], object.linkedTransactionId);
  writer.writeString(offsets[4], object.rawBody);
  writer.writeDateTime(offsets[5], object.receivedAt);
  writer.writeString(offsets[6], object.sender);
}

SmsRawLog _smsRawLogDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SmsRawLog(
    id: reader.readString(offsets[1]),
    isParsed: reader.readBool(offsets[2]),
    linkedTransactionId: reader.readStringOrNull(offsets[3]),
    rawBody: reader.readString(offsets[4]),
    receivedAt: reader.readDateTime(offsets[5]),
    sender: reader.readString(offsets[6]),
  );
  return object;
}

P _smsRawLogDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readDateTime(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _smsRawLogGetId(SmsRawLog object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _smsRawLogGetLinks(SmsRawLog object) {
  return [];
}

void _smsRawLogAttach(IsarCollection<dynamic> col, Id id, SmsRawLog object) {}

extension SmsRawLogByIndex on IsarCollection<SmsRawLog> {
  Future<SmsRawLog?> getById(String id) {
    return getByIndex(r'id', [id]);
  }

  SmsRawLog? getByIdSync(String id) {
    return getByIndexSync(r'id', [id]);
  }

  Future<bool> deleteById(String id) {
    return deleteByIndex(r'id', [id]);
  }

  bool deleteByIdSync(String id) {
    return deleteByIndexSync(r'id', [id]);
  }

  Future<List<SmsRawLog?>> getAllById(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return getAllByIndex(r'id', values);
  }

  List<SmsRawLog?> getAllByIdSync(List<String> idValues) {
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

  Future<Id> putById(SmsRawLog object) {
    return putByIndex(r'id', object);
  }

  Id putByIdSync(SmsRawLog object, {bool saveLinks = true}) {
    return putByIndexSync(r'id', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllById(List<SmsRawLog> objects) {
    return putAllByIndex(r'id', objects);
  }

  List<Id> putAllByIdSync(List<SmsRawLog> objects, {bool saveLinks = true}) {
    return putAllByIndexSync(r'id', objects, saveLinks: saveLinks);
  }
}

extension SmsRawLogQueryWhereSort
    on QueryBuilder<SmsRawLog, SmsRawLog, QWhere> {
  QueryBuilder<SmsRawLog, SmsRawLog, QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension SmsRawLogQueryWhere
    on QueryBuilder<SmsRawLog, SmsRawLog, QWhereClause> {
  QueryBuilder<SmsRawLog, SmsRawLog, QAfterWhereClause> isarIdEqualTo(
      Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<SmsRawLog, SmsRawLog, QAfterWhereClause> isarIdNotEqualTo(
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

  QueryBuilder<SmsRawLog, SmsRawLog, QAfterWhereClause> isarIdGreaterThan(
      Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<SmsRawLog, SmsRawLog, QAfterWhereClause> isarIdLessThan(
      Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<SmsRawLog, SmsRawLog, QAfterWhereClause> isarIdBetween(
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

  QueryBuilder<SmsRawLog, SmsRawLog, QAfterWhereClause> idEqualTo(String id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'id',
        value: [id],
      ));
    });
  }

  QueryBuilder<SmsRawLog, SmsRawLog, QAfterWhereClause> idNotEqualTo(
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

extension SmsRawLogQueryFilter
    on QueryBuilder<SmsRawLog, SmsRawLog, QFilterCondition> {
  QueryBuilder<SmsRawLog, SmsRawLog, QAfterFilterCondition> hashCodeEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hashCode',
        value: value,
      ));
    });
  }

  QueryBuilder<SmsRawLog, SmsRawLog, QAfterFilterCondition> hashCodeGreaterThan(
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

  QueryBuilder<SmsRawLog, SmsRawLog, QAfterFilterCondition> hashCodeLessThan(
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

  QueryBuilder<SmsRawLog, SmsRawLog, QAfterFilterCondition> hashCodeBetween(
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

  QueryBuilder<SmsRawLog, SmsRawLog, QAfterFilterCondition> idEqualTo(
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

  QueryBuilder<SmsRawLog, SmsRawLog, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<SmsRawLog, SmsRawLog, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<SmsRawLog, SmsRawLog, QAfterFilterCondition> idBetween(
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

  QueryBuilder<SmsRawLog, SmsRawLog, QAfterFilterCondition> idStartsWith(
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

  QueryBuilder<SmsRawLog, SmsRawLog, QAfterFilterCondition> idEndsWith(
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

  QueryBuilder<SmsRawLog, SmsRawLog, QAfterFilterCondition> idContains(
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

  QueryBuilder<SmsRawLog, SmsRawLog, QAfterFilterCondition> idMatches(
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

  QueryBuilder<SmsRawLog, SmsRawLog, QAfterFilterCondition> idIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<SmsRawLog, SmsRawLog, QAfterFilterCondition> idIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<SmsRawLog, SmsRawLog, QAfterFilterCondition> isParsedEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isParsed',
        value: value,
      ));
    });
  }

  QueryBuilder<SmsRawLog, SmsRawLog, QAfterFilterCondition> isarIdEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<SmsRawLog, SmsRawLog, QAfterFilterCondition> isarIdGreaterThan(
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

  QueryBuilder<SmsRawLog, SmsRawLog, QAfterFilterCondition> isarIdLessThan(
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

  QueryBuilder<SmsRawLog, SmsRawLog, QAfterFilterCondition> isarIdBetween(
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

  QueryBuilder<SmsRawLog, SmsRawLog, QAfterFilterCondition>
      linkedTransactionIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'linkedTransactionId',
      ));
    });
  }

  QueryBuilder<SmsRawLog, SmsRawLog, QAfterFilterCondition>
      linkedTransactionIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'linkedTransactionId',
      ));
    });
  }

  QueryBuilder<SmsRawLog, SmsRawLog, QAfterFilterCondition>
      linkedTransactionIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'linkedTransactionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SmsRawLog, SmsRawLog, QAfterFilterCondition>
      linkedTransactionIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'linkedTransactionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SmsRawLog, SmsRawLog, QAfterFilterCondition>
      linkedTransactionIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'linkedTransactionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SmsRawLog, SmsRawLog, QAfterFilterCondition>
      linkedTransactionIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'linkedTransactionId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SmsRawLog, SmsRawLog, QAfterFilterCondition>
      linkedTransactionIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'linkedTransactionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SmsRawLog, SmsRawLog, QAfterFilterCondition>
      linkedTransactionIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'linkedTransactionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SmsRawLog, SmsRawLog, QAfterFilterCondition>
      linkedTransactionIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'linkedTransactionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SmsRawLog, SmsRawLog, QAfterFilterCondition>
      linkedTransactionIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'linkedTransactionId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SmsRawLog, SmsRawLog, QAfterFilterCondition>
      linkedTransactionIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'linkedTransactionId',
        value: '',
      ));
    });
  }

  QueryBuilder<SmsRawLog, SmsRawLog, QAfterFilterCondition>
      linkedTransactionIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'linkedTransactionId',
        value: '',
      ));
    });
  }

  QueryBuilder<SmsRawLog, SmsRawLog, QAfterFilterCondition> rawBodyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rawBody',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SmsRawLog, SmsRawLog, QAfterFilterCondition> rawBodyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'rawBody',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SmsRawLog, SmsRawLog, QAfterFilterCondition> rawBodyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'rawBody',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SmsRawLog, SmsRawLog, QAfterFilterCondition> rawBodyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'rawBody',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SmsRawLog, SmsRawLog, QAfterFilterCondition> rawBodyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'rawBody',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SmsRawLog, SmsRawLog, QAfterFilterCondition> rawBodyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'rawBody',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SmsRawLog, SmsRawLog, QAfterFilterCondition> rawBodyContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'rawBody',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SmsRawLog, SmsRawLog, QAfterFilterCondition> rawBodyMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'rawBody',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SmsRawLog, SmsRawLog, QAfterFilterCondition> rawBodyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rawBody',
        value: '',
      ));
    });
  }

  QueryBuilder<SmsRawLog, SmsRawLog, QAfterFilterCondition>
      rawBodyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'rawBody',
        value: '',
      ));
    });
  }

  QueryBuilder<SmsRawLog, SmsRawLog, QAfterFilterCondition> receivedAtEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'receivedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<SmsRawLog, SmsRawLog, QAfterFilterCondition>
      receivedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'receivedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<SmsRawLog, SmsRawLog, QAfterFilterCondition> receivedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'receivedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<SmsRawLog, SmsRawLog, QAfterFilterCondition> receivedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'receivedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SmsRawLog, SmsRawLog, QAfterFilterCondition> senderEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sender',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SmsRawLog, SmsRawLog, QAfterFilterCondition> senderGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sender',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SmsRawLog, SmsRawLog, QAfterFilterCondition> senderLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sender',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SmsRawLog, SmsRawLog, QAfterFilterCondition> senderBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sender',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SmsRawLog, SmsRawLog, QAfterFilterCondition> senderStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'sender',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SmsRawLog, SmsRawLog, QAfterFilterCondition> senderEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'sender',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SmsRawLog, SmsRawLog, QAfterFilterCondition> senderContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'sender',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SmsRawLog, SmsRawLog, QAfterFilterCondition> senderMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'sender',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SmsRawLog, SmsRawLog, QAfterFilterCondition> senderIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sender',
        value: '',
      ));
    });
  }

  QueryBuilder<SmsRawLog, SmsRawLog, QAfterFilterCondition> senderIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'sender',
        value: '',
      ));
    });
  }
}

extension SmsRawLogQueryObject
    on QueryBuilder<SmsRawLog, SmsRawLog, QFilterCondition> {}

extension SmsRawLogQueryLinks
    on QueryBuilder<SmsRawLog, SmsRawLog, QFilterCondition> {}

extension SmsRawLogQuerySortBy on QueryBuilder<SmsRawLog, SmsRawLog, QSortBy> {
  QueryBuilder<SmsRawLog, SmsRawLog, QAfterSortBy> sortByHashCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.asc);
    });
  }

  QueryBuilder<SmsRawLog, SmsRawLog, QAfterSortBy> sortByHashCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.desc);
    });
  }

  QueryBuilder<SmsRawLog, SmsRawLog, QAfterSortBy> sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<SmsRawLog, SmsRawLog, QAfterSortBy> sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<SmsRawLog, SmsRawLog, QAfterSortBy> sortByIsParsed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isParsed', Sort.asc);
    });
  }

  QueryBuilder<SmsRawLog, SmsRawLog, QAfterSortBy> sortByIsParsedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isParsed', Sort.desc);
    });
  }

  QueryBuilder<SmsRawLog, SmsRawLog, QAfterSortBy> sortByLinkedTransactionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'linkedTransactionId', Sort.asc);
    });
  }

  QueryBuilder<SmsRawLog, SmsRawLog, QAfterSortBy>
      sortByLinkedTransactionIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'linkedTransactionId', Sort.desc);
    });
  }

  QueryBuilder<SmsRawLog, SmsRawLog, QAfterSortBy> sortByRawBody() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rawBody', Sort.asc);
    });
  }

  QueryBuilder<SmsRawLog, SmsRawLog, QAfterSortBy> sortByRawBodyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rawBody', Sort.desc);
    });
  }

  QueryBuilder<SmsRawLog, SmsRawLog, QAfterSortBy> sortByReceivedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receivedAt', Sort.asc);
    });
  }

  QueryBuilder<SmsRawLog, SmsRawLog, QAfterSortBy> sortByReceivedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receivedAt', Sort.desc);
    });
  }

  QueryBuilder<SmsRawLog, SmsRawLog, QAfterSortBy> sortBySender() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sender', Sort.asc);
    });
  }

  QueryBuilder<SmsRawLog, SmsRawLog, QAfterSortBy> sortBySenderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sender', Sort.desc);
    });
  }
}

extension SmsRawLogQuerySortThenBy
    on QueryBuilder<SmsRawLog, SmsRawLog, QSortThenBy> {
  QueryBuilder<SmsRawLog, SmsRawLog, QAfterSortBy> thenByHashCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.asc);
    });
  }

  QueryBuilder<SmsRawLog, SmsRawLog, QAfterSortBy> thenByHashCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.desc);
    });
  }

  QueryBuilder<SmsRawLog, SmsRawLog, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<SmsRawLog, SmsRawLog, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<SmsRawLog, SmsRawLog, QAfterSortBy> thenByIsParsed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isParsed', Sort.asc);
    });
  }

  QueryBuilder<SmsRawLog, SmsRawLog, QAfterSortBy> thenByIsParsedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isParsed', Sort.desc);
    });
  }

  QueryBuilder<SmsRawLog, SmsRawLog, QAfterSortBy> thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<SmsRawLog, SmsRawLog, QAfterSortBy> thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<SmsRawLog, SmsRawLog, QAfterSortBy> thenByLinkedTransactionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'linkedTransactionId', Sort.asc);
    });
  }

  QueryBuilder<SmsRawLog, SmsRawLog, QAfterSortBy>
      thenByLinkedTransactionIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'linkedTransactionId', Sort.desc);
    });
  }

  QueryBuilder<SmsRawLog, SmsRawLog, QAfterSortBy> thenByRawBody() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rawBody', Sort.asc);
    });
  }

  QueryBuilder<SmsRawLog, SmsRawLog, QAfterSortBy> thenByRawBodyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rawBody', Sort.desc);
    });
  }

  QueryBuilder<SmsRawLog, SmsRawLog, QAfterSortBy> thenByReceivedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receivedAt', Sort.asc);
    });
  }

  QueryBuilder<SmsRawLog, SmsRawLog, QAfterSortBy> thenByReceivedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receivedAt', Sort.desc);
    });
  }

  QueryBuilder<SmsRawLog, SmsRawLog, QAfterSortBy> thenBySender() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sender', Sort.asc);
    });
  }

  QueryBuilder<SmsRawLog, SmsRawLog, QAfterSortBy> thenBySenderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sender', Sort.desc);
    });
  }
}

extension SmsRawLogQueryWhereDistinct
    on QueryBuilder<SmsRawLog, SmsRawLog, QDistinct> {
  QueryBuilder<SmsRawLog, SmsRawLog, QDistinct> distinctByHashCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hashCode');
    });
  }

  QueryBuilder<SmsRawLog, SmsRawLog, QDistinct> distinctById(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'id', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SmsRawLog, SmsRawLog, QDistinct> distinctByIsParsed() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isParsed');
    });
  }

  QueryBuilder<SmsRawLog, SmsRawLog, QDistinct> distinctByLinkedTransactionId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'linkedTransactionId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SmsRawLog, SmsRawLog, QDistinct> distinctByRawBody(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'rawBody', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SmsRawLog, SmsRawLog, QDistinct> distinctByReceivedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'receivedAt');
    });
  }

  QueryBuilder<SmsRawLog, SmsRawLog, QDistinct> distinctBySender(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sender', caseSensitive: caseSensitive);
    });
  }
}

extension SmsRawLogQueryProperty
    on QueryBuilder<SmsRawLog, SmsRawLog, QQueryProperty> {
  QueryBuilder<SmsRawLog, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<SmsRawLog, int, QQueryOperations> hashCodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hashCode');
    });
  }

  QueryBuilder<SmsRawLog, String, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<SmsRawLog, bool, QQueryOperations> isParsedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isParsed');
    });
  }

  QueryBuilder<SmsRawLog, String?, QQueryOperations>
      linkedTransactionIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'linkedTransactionId');
    });
  }

  QueryBuilder<SmsRawLog, String, QQueryOperations> rawBodyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'rawBody');
    });
  }

  QueryBuilder<SmsRawLog, DateTime, QQueryOperations> receivedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'receivedAt');
    });
  }

  QueryBuilder<SmsRawLog, String, QQueryOperations> senderProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sender');
    });
  }
}
