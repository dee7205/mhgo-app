// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dar_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetDarModelCollection on Isar {
  IsarCollection<DarModel> get darModels => this.collection();
}

const DarModelSchema = CollectionSchema(
  name: r'DarModel',
  id: 1409137744658820164,
  properties: {
    r'accomplishmentsJson': PropertySchema(
      id: 0,
      name: r'accomplishmentsJson',
      type: IsarType.string,
    ),
    r'createdAt': PropertySchema(
      id: 1,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'darNumber': PropertySchema(
      id: 2,
      name: r'darNumber',
      type: IsarType.string,
    ),
    r'delaysJson': PropertySchema(
      id: 3,
      name: r'delaysJson',
      type: IsarType.string,
    ),
    r'equipmentJson': PropertySchema(
      id: 4,
      name: r'equipmentJson',
      type: IsarType.string,
    ),
    r'isSynced': PropertySchema(id: 5, name: r'isSynced', type: IsarType.bool),
    r'manpowerJson': PropertySchema(
      id: 6,
      name: r'manpowerJson',
      type: IsarType.string,
    ),
    r'materialsJson': PropertySchema(
      id: 7,
      name: r'materialsJson',
      type: IsarType.string,
    ),
    r'photosJson': PropertySchema(
      id: 8,
      name: r'photosJson',
      type: IsarType.string,
    ),
    r'preparedBy': PropertySchema(
      id: 9,
      name: r'preparedBy',
      type: IsarType.string,
    ),
    r'projectName': PropertySchema(
      id: 10,
      name: r'projectName',
      type: IsarType.string,
    ),
    r'projectUuid': PropertySchema(
      id: 11,
      name: r'projectUuid',
      type: IsarType.string,
    ),
    r'reportDate': PropertySchema(
      id: 12,
      name: r'reportDate',
      type: IsarType.dateTime,
    ),
    r'reportingPeriod': PropertySchema(
      id: 13,
      name: r'reportingPeriod',
      type: IsarType.string,
    ),
    r'signedApproved': PropertySchema(
      id: 14,
      name: r'signedApproved',
      type: IsarType.string,
    ),
    r'signedChecked': PropertySchema(
      id: 15,
      name: r'signedChecked',
      type: IsarType.string,
    ),
    r'signedPrepared': PropertySchema(
      id: 16,
      name: r'signedPrepared',
      type: IsarType.string,
    ),
    r'siteCondition': PropertySchema(
      id: 17,
      name: r'siteCondition',
      type: IsarType.string,
    ),
    r'status': PropertySchema(id: 18, name: r'status', type: IsarType.string),
    r'temperature': PropertySchema(
      id: 19,
      name: r'temperature',
      type: IsarType.double,
    ),
    r'updatedAt': PropertySchema(
      id: 20,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
    r'uuid': PropertySchema(id: 21, name: r'uuid', type: IsarType.string),
    r'weather': PropertySchema(id: 22, name: r'weather', type: IsarType.string),
    r'windCondition': PropertySchema(
      id: 23,
      name: r'windCondition',
      type: IsarType.string,
    ),
  },

  estimateSize: _darModelEstimateSize,
  serialize: _darModelSerialize,
  deserialize: _darModelDeserialize,
  deserializeProp: _darModelDeserializeProp,
  idName: r'id',
  indexes: {
    r'uuid': IndexSchema(
      id: 2134397340427724972,
      name: r'uuid',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'uuid',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
    r'projectUuid': IndexSchema(
      id: 1800627547519742770,
      name: r'projectUuid',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'projectUuid',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _darModelGetId,
  getLinks: _darModelGetLinks,
  attach: _darModelAttach,
  version: '3.3.2',
);

int _darModelEstimateSize(
  DarModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.accomplishmentsJson.length * 3;
  bytesCount += 3 + object.darNumber.length * 3;
  bytesCount += 3 + object.delaysJson.length * 3;
  bytesCount += 3 + object.equipmentJson.length * 3;
  bytesCount += 3 + object.manpowerJson.length * 3;
  bytesCount += 3 + object.materialsJson.length * 3;
  bytesCount += 3 + object.photosJson.length * 3;
  bytesCount += 3 + object.preparedBy.length * 3;
  bytesCount += 3 + object.projectName.length * 3;
  bytesCount += 3 + object.projectUuid.length * 3;
  bytesCount += 3 + object.reportingPeriod.length * 3;
  {
    final value = object.signedApproved;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.signedChecked;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.signedPrepared;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.siteCondition.length * 3;
  bytesCount += 3 + object.status.length * 3;
  bytesCount += 3 + object.uuid.length * 3;
  bytesCount += 3 + object.weather.length * 3;
  bytesCount += 3 + object.windCondition.length * 3;
  return bytesCount;
}

void _darModelSerialize(
  DarModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.accomplishmentsJson);
  writer.writeDateTime(offsets[1], object.createdAt);
  writer.writeString(offsets[2], object.darNumber);
  writer.writeString(offsets[3], object.delaysJson);
  writer.writeString(offsets[4], object.equipmentJson);
  writer.writeBool(offsets[5], object.isSynced);
  writer.writeString(offsets[6], object.manpowerJson);
  writer.writeString(offsets[7], object.materialsJson);
  writer.writeString(offsets[8], object.photosJson);
  writer.writeString(offsets[9], object.preparedBy);
  writer.writeString(offsets[10], object.projectName);
  writer.writeString(offsets[11], object.projectUuid);
  writer.writeDateTime(offsets[12], object.reportDate);
  writer.writeString(offsets[13], object.reportingPeriod);
  writer.writeString(offsets[14], object.signedApproved);
  writer.writeString(offsets[15], object.signedChecked);
  writer.writeString(offsets[16], object.signedPrepared);
  writer.writeString(offsets[17], object.siteCondition);
  writer.writeString(offsets[18], object.status);
  writer.writeDouble(offsets[19], object.temperature);
  writer.writeDateTime(offsets[20], object.updatedAt);
  writer.writeString(offsets[21], object.uuid);
  writer.writeString(offsets[22], object.weather);
  writer.writeString(offsets[23], object.windCondition);
}

DarModel _darModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DarModel();
  object.accomplishmentsJson = reader.readString(offsets[0]);
  object.createdAt = reader.readDateTime(offsets[1]);
  object.darNumber = reader.readString(offsets[2]);
  object.delaysJson = reader.readString(offsets[3]);
  object.equipmentJson = reader.readString(offsets[4]);
  object.id = id;
  object.isSynced = reader.readBool(offsets[5]);
  object.manpowerJson = reader.readString(offsets[6]);
  object.materialsJson = reader.readString(offsets[7]);
  object.photosJson = reader.readString(offsets[8]);
  object.preparedBy = reader.readString(offsets[9]);
  object.projectName = reader.readString(offsets[10]);
  object.projectUuid = reader.readString(offsets[11]);
  object.reportDate = reader.readDateTime(offsets[12]);
  object.reportingPeriod = reader.readString(offsets[13]);
  object.signedApproved = reader.readStringOrNull(offsets[14]);
  object.signedChecked = reader.readStringOrNull(offsets[15]);
  object.signedPrepared = reader.readStringOrNull(offsets[16]);
  object.siteCondition = reader.readString(offsets[17]);
  object.status = reader.readString(offsets[18]);
  object.temperature = reader.readDouble(offsets[19]);
  object.updatedAt = reader.readDateTime(offsets[20]);
  object.uuid = reader.readString(offsets[21]);
  object.weather = reader.readString(offsets[22]);
  object.windCondition = reader.readString(offsets[23]);
  return object;
}

P _darModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readBool(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readString(offset)) as P;
    case 10:
      return (reader.readString(offset)) as P;
    case 11:
      return (reader.readString(offset)) as P;
    case 12:
      return (reader.readDateTime(offset)) as P;
    case 13:
      return (reader.readString(offset)) as P;
    case 14:
      return (reader.readStringOrNull(offset)) as P;
    case 15:
      return (reader.readStringOrNull(offset)) as P;
    case 16:
      return (reader.readStringOrNull(offset)) as P;
    case 17:
      return (reader.readString(offset)) as P;
    case 18:
      return (reader.readString(offset)) as P;
    case 19:
      return (reader.readDouble(offset)) as P;
    case 20:
      return (reader.readDateTime(offset)) as P;
    case 21:
      return (reader.readString(offset)) as P;
    case 22:
      return (reader.readString(offset)) as P;
    case 23:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _darModelGetId(DarModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _darModelGetLinks(DarModel object) {
  return [];
}

void _darModelAttach(IsarCollection<dynamic> col, Id id, DarModel object) {
  object.id = id;
}

extension DarModelByIndex on IsarCollection<DarModel> {
  Future<DarModel?> getByUuid(String uuid) {
    return getByIndex(r'uuid', [uuid]);
  }

  DarModel? getByUuidSync(String uuid) {
    return getByIndexSync(r'uuid', [uuid]);
  }

  Future<bool> deleteByUuid(String uuid) {
    return deleteByIndex(r'uuid', [uuid]);
  }

  bool deleteByUuidSync(String uuid) {
    return deleteByIndexSync(r'uuid', [uuid]);
  }

  Future<List<DarModel?>> getAllByUuid(List<String> uuidValues) {
    final values = uuidValues.map((e) => [e]).toList();
    return getAllByIndex(r'uuid', values);
  }

  List<DarModel?> getAllByUuidSync(List<String> uuidValues) {
    final values = uuidValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'uuid', values);
  }

  Future<int> deleteAllByUuid(List<String> uuidValues) {
    final values = uuidValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'uuid', values);
  }

  int deleteAllByUuidSync(List<String> uuidValues) {
    final values = uuidValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'uuid', values);
  }

  Future<Id> putByUuid(DarModel object) {
    return putByIndex(r'uuid', object);
  }

  Id putByUuidSync(DarModel object, {bool saveLinks = true}) {
    return putByIndexSync(r'uuid', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByUuid(List<DarModel> objects) {
    return putAllByIndex(r'uuid', objects);
  }

  List<Id> putAllByUuidSync(List<DarModel> objects, {bool saveLinks = true}) {
    return putAllByIndexSync(r'uuid', objects, saveLinks: saveLinks);
  }
}

extension DarModelQueryWhereSort on QueryBuilder<DarModel, DarModel, QWhere> {
  QueryBuilder<DarModel, DarModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension DarModelQueryWhere on QueryBuilder<DarModel, DarModel, QWhereClause> {
  QueryBuilder<DarModel, DarModel, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(
          lower: lowerId,
          includeLower: includeLower,
          upper: upperId,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterWhereClause> uuidEqualTo(String uuid) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'uuid', value: [uuid]),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterWhereClause> uuidNotEqualTo(
    String uuid,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'uuid',
                lower: [],
                upper: [uuid],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'uuid',
                lower: [uuid],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'uuid',
                lower: [uuid],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'uuid',
                lower: [],
                upper: [uuid],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterWhereClause> projectUuidEqualTo(
    String projectUuid,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(
          indexName: r'projectUuid',
          value: [projectUuid],
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterWhereClause> projectUuidNotEqualTo(
    String projectUuid,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'projectUuid',
                lower: [],
                upper: [projectUuid],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'projectUuid',
                lower: [projectUuid],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'projectUuid',
                lower: [projectUuid],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'projectUuid',
                lower: [],
                upper: [projectUuid],
                includeUpper: false,
              ),
            );
      }
    });
  }
}

extension DarModelQueryFilter
    on QueryBuilder<DarModel, DarModel, QFilterCondition> {
  QueryBuilder<DarModel, DarModel, QAfterFilterCondition>
  accomplishmentsJsonEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'accomplishmentsJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition>
  accomplishmentsJsonGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'accomplishmentsJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition>
  accomplishmentsJsonLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'accomplishmentsJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition>
  accomplishmentsJsonBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'accomplishmentsJson',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition>
  accomplishmentsJsonStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'accomplishmentsJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition>
  accomplishmentsJsonEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'accomplishmentsJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition>
  accomplishmentsJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'accomplishmentsJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition>
  accomplishmentsJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'accomplishmentsJson',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition>
  accomplishmentsJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'accomplishmentsJson', value: ''),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition>
  accomplishmentsJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          property: r'accomplishmentsJson',
          value: '',
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> createdAtEqualTo(
    DateTime value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'createdAt', value: value),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'createdAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'createdAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'createdAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> darNumberEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'darNumber',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> darNumberGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'darNumber',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> darNumberLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'darNumber',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> darNumberBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'darNumber',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> darNumberStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'darNumber',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> darNumberEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'darNumber',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> darNumberContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'darNumber',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> darNumberMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'darNumber',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> darNumberIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'darNumber', value: ''),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition>
  darNumberIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'darNumber', value: ''),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> delaysJsonEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'delaysJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> delaysJsonGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'delaysJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> delaysJsonLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'delaysJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> delaysJsonBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'delaysJson',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> delaysJsonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'delaysJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> delaysJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'delaysJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> delaysJsonContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'delaysJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> delaysJsonMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'delaysJson',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> delaysJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'delaysJson', value: ''),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition>
  delaysJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'delaysJson', value: ''),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> equipmentJsonEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'equipmentJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition>
  equipmentJsonGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'equipmentJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> equipmentJsonLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'equipmentJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> equipmentJsonBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'equipmentJson',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition>
  equipmentJsonStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'equipmentJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> equipmentJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'equipmentJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> equipmentJsonContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'equipmentJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> equipmentJsonMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'equipmentJson',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition>
  equipmentJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'equipmentJson', value: ''),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition>
  equipmentJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'equipmentJson', value: ''),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'id',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> isSyncedEqualTo(
    bool value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isSynced', value: value),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> manpowerJsonEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'manpowerJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition>
  manpowerJsonGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'manpowerJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> manpowerJsonLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'manpowerJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> manpowerJsonBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'manpowerJson',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition>
  manpowerJsonStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'manpowerJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> manpowerJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'manpowerJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> manpowerJsonContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'manpowerJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> manpowerJsonMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'manpowerJson',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition>
  manpowerJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'manpowerJson', value: ''),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition>
  manpowerJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'manpowerJson', value: ''),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> materialsJsonEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'materialsJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition>
  materialsJsonGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'materialsJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> materialsJsonLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'materialsJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> materialsJsonBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'materialsJson',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition>
  materialsJsonStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'materialsJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> materialsJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'materialsJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> materialsJsonContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'materialsJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> materialsJsonMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'materialsJson',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition>
  materialsJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'materialsJson', value: ''),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition>
  materialsJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'materialsJson', value: ''),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> photosJsonEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'photosJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> photosJsonGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'photosJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> photosJsonLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'photosJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> photosJsonBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'photosJson',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> photosJsonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'photosJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> photosJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'photosJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> photosJsonContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'photosJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> photosJsonMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'photosJson',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> photosJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'photosJson', value: ''),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition>
  photosJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'photosJson', value: ''),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> preparedByEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'preparedBy',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> preparedByGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'preparedBy',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> preparedByLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'preparedBy',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> preparedByBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'preparedBy',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> preparedByStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'preparedBy',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> preparedByEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'preparedBy',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> preparedByContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'preparedBy',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> preparedByMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'preparedBy',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> preparedByIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'preparedBy', value: ''),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition>
  preparedByIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'preparedBy', value: ''),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> projectNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'projectName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition>
  projectNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'projectName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> projectNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'projectName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> projectNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'projectName',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> projectNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'projectName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> projectNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'projectName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> projectNameContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'projectName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> projectNameMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'projectName',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> projectNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'projectName', value: ''),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition>
  projectNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'projectName', value: ''),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> projectUuidEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'projectUuid',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition>
  projectUuidGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'projectUuid',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> projectUuidLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'projectUuid',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> projectUuidBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'projectUuid',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> projectUuidStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'projectUuid',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> projectUuidEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'projectUuid',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> projectUuidContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'projectUuid',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> projectUuidMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'projectUuid',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> projectUuidIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'projectUuid', value: ''),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition>
  projectUuidIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'projectUuid', value: ''),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> reportDateEqualTo(
    DateTime value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'reportDate', value: value),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> reportDateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'reportDate',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> reportDateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'reportDate',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> reportDateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'reportDate',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition>
  reportingPeriodEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'reportingPeriod',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition>
  reportingPeriodGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'reportingPeriod',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition>
  reportingPeriodLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'reportingPeriod',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition>
  reportingPeriodBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'reportingPeriod',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition>
  reportingPeriodStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'reportingPeriod',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition>
  reportingPeriodEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'reportingPeriod',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition>
  reportingPeriodContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'reportingPeriod',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition>
  reportingPeriodMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'reportingPeriod',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition>
  reportingPeriodIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'reportingPeriod', value: ''),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition>
  reportingPeriodIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'reportingPeriod', value: ''),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition>
  signedApprovedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'signedApproved'),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition>
  signedApprovedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'signedApproved'),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> signedApprovedEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'signedApproved',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition>
  signedApprovedGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'signedApproved',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition>
  signedApprovedLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'signedApproved',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> signedApprovedBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'signedApproved',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition>
  signedApprovedStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'signedApproved',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition>
  signedApprovedEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'signedApproved',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition>
  signedApprovedContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'signedApproved',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> signedApprovedMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'signedApproved',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition>
  signedApprovedIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'signedApproved', value: ''),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition>
  signedApprovedIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'signedApproved', value: ''),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition>
  signedCheckedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'signedChecked'),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition>
  signedCheckedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'signedChecked'),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> signedCheckedEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'signedChecked',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition>
  signedCheckedGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'signedChecked',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> signedCheckedLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'signedChecked',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> signedCheckedBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'signedChecked',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition>
  signedCheckedStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'signedChecked',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> signedCheckedEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'signedChecked',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> signedCheckedContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'signedChecked',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> signedCheckedMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'signedChecked',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition>
  signedCheckedIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'signedChecked', value: ''),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition>
  signedCheckedIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'signedChecked', value: ''),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition>
  signedPreparedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'signedPrepared'),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition>
  signedPreparedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'signedPrepared'),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> signedPreparedEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'signedPrepared',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition>
  signedPreparedGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'signedPrepared',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition>
  signedPreparedLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'signedPrepared',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> signedPreparedBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'signedPrepared',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition>
  signedPreparedStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'signedPrepared',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition>
  signedPreparedEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'signedPrepared',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition>
  signedPreparedContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'signedPrepared',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> signedPreparedMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'signedPrepared',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition>
  signedPreparedIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'signedPrepared', value: ''),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition>
  signedPreparedIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'signedPrepared', value: ''),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> siteConditionEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'siteCondition',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition>
  siteConditionGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'siteCondition',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> siteConditionLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'siteCondition',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> siteConditionBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'siteCondition',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition>
  siteConditionStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'siteCondition',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> siteConditionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'siteCondition',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> siteConditionContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'siteCondition',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> siteConditionMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'siteCondition',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition>
  siteConditionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'siteCondition', value: ''),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition>
  siteConditionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'siteCondition', value: ''),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> statusEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'status',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> statusGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'status',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> statusLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'status',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> statusBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'status',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> statusStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'status',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> statusEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'status',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> statusContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'status',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> statusMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'status',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> statusIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'status', value: ''),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> statusIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'status', value: ''),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> temperatureEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'temperature',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition>
  temperatureGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'temperature',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> temperatureLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'temperature',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> temperatureBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'temperature',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> updatedAtEqualTo(
    DateTime value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'updatedAt', value: value),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> updatedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'updatedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> updatedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'updatedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> updatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'updatedAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> uuidEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'uuid',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> uuidGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'uuid',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> uuidLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'uuid',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> uuidBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'uuid',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> uuidStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'uuid',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> uuidEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'uuid',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> uuidContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'uuid',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> uuidMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'uuid',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> uuidIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'uuid', value: ''),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> uuidIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'uuid', value: ''),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> weatherEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'weather',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> weatherGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'weather',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> weatherLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'weather',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> weatherBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'weather',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> weatherStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'weather',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> weatherEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'weather',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> weatherContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'weather',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> weatherMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'weather',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> weatherIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'weather', value: ''),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> weatherIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'weather', value: ''),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> windConditionEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'windCondition',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition>
  windConditionGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'windCondition',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> windConditionLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'windCondition',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> windConditionBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'windCondition',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition>
  windConditionStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'windCondition',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> windConditionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'windCondition',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> windConditionContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'windCondition',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition> windConditionMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'windCondition',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition>
  windConditionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'windCondition', value: ''),
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterFilterCondition>
  windConditionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'windCondition', value: ''),
      );
    });
  }
}

extension DarModelQueryObject
    on QueryBuilder<DarModel, DarModel, QFilterCondition> {}

extension DarModelQueryLinks
    on QueryBuilder<DarModel, DarModel, QFilterCondition> {}

extension DarModelQuerySortBy on QueryBuilder<DarModel, DarModel, QSortBy> {
  QueryBuilder<DarModel, DarModel, QAfterSortBy> sortByAccomplishmentsJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accomplishmentsJson', Sort.asc);
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterSortBy>
  sortByAccomplishmentsJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accomplishmentsJson', Sort.desc);
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterSortBy> sortByDarNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'darNumber', Sort.asc);
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterSortBy> sortByDarNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'darNumber', Sort.desc);
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterSortBy> sortByDelaysJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'delaysJson', Sort.asc);
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterSortBy> sortByDelaysJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'delaysJson', Sort.desc);
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterSortBy> sortByEquipmentJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'equipmentJson', Sort.asc);
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterSortBy> sortByEquipmentJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'equipmentJson', Sort.desc);
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterSortBy> sortByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.asc);
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterSortBy> sortByIsSyncedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.desc);
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterSortBy> sortByManpowerJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'manpowerJson', Sort.asc);
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterSortBy> sortByManpowerJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'manpowerJson', Sort.desc);
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterSortBy> sortByMaterialsJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'materialsJson', Sort.asc);
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterSortBy> sortByMaterialsJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'materialsJson', Sort.desc);
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterSortBy> sortByPhotosJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'photosJson', Sort.asc);
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterSortBy> sortByPhotosJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'photosJson', Sort.desc);
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterSortBy> sortByPreparedBy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'preparedBy', Sort.asc);
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterSortBy> sortByPreparedByDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'preparedBy', Sort.desc);
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterSortBy> sortByProjectName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'projectName', Sort.asc);
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterSortBy> sortByProjectNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'projectName', Sort.desc);
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterSortBy> sortByProjectUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'projectUuid', Sort.asc);
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterSortBy> sortByProjectUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'projectUuid', Sort.desc);
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterSortBy> sortByReportDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reportDate', Sort.asc);
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterSortBy> sortByReportDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reportDate', Sort.desc);
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterSortBy> sortByReportingPeriod() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reportingPeriod', Sort.asc);
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterSortBy> sortByReportingPeriodDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reportingPeriod', Sort.desc);
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterSortBy> sortBySignedApproved() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'signedApproved', Sort.asc);
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterSortBy> sortBySignedApprovedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'signedApproved', Sort.desc);
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterSortBy> sortBySignedChecked() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'signedChecked', Sort.asc);
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterSortBy> sortBySignedCheckedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'signedChecked', Sort.desc);
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterSortBy> sortBySignedPrepared() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'signedPrepared', Sort.asc);
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterSortBy> sortBySignedPreparedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'signedPrepared', Sort.desc);
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterSortBy> sortBySiteCondition() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'siteCondition', Sort.asc);
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterSortBy> sortBySiteConditionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'siteCondition', Sort.desc);
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterSortBy> sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterSortBy> sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterSortBy> sortByTemperature() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'temperature', Sort.asc);
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterSortBy> sortByTemperatureDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'temperature', Sort.desc);
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterSortBy> sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterSortBy> sortByUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.asc);
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterSortBy> sortByUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.desc);
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterSortBy> sortByWeather() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weather', Sort.asc);
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterSortBy> sortByWeatherDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weather', Sort.desc);
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterSortBy> sortByWindCondition() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'windCondition', Sort.asc);
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterSortBy> sortByWindConditionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'windCondition', Sort.desc);
    });
  }
}

extension DarModelQuerySortThenBy
    on QueryBuilder<DarModel, DarModel, QSortThenBy> {
  QueryBuilder<DarModel, DarModel, QAfterSortBy> thenByAccomplishmentsJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accomplishmentsJson', Sort.asc);
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterSortBy>
  thenByAccomplishmentsJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accomplishmentsJson', Sort.desc);
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterSortBy> thenByDarNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'darNumber', Sort.asc);
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterSortBy> thenByDarNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'darNumber', Sort.desc);
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterSortBy> thenByDelaysJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'delaysJson', Sort.asc);
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterSortBy> thenByDelaysJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'delaysJson', Sort.desc);
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterSortBy> thenByEquipmentJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'equipmentJson', Sort.asc);
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterSortBy> thenByEquipmentJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'equipmentJson', Sort.desc);
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterSortBy> thenByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.asc);
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterSortBy> thenByIsSyncedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.desc);
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterSortBy> thenByManpowerJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'manpowerJson', Sort.asc);
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterSortBy> thenByManpowerJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'manpowerJson', Sort.desc);
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterSortBy> thenByMaterialsJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'materialsJson', Sort.asc);
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterSortBy> thenByMaterialsJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'materialsJson', Sort.desc);
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterSortBy> thenByPhotosJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'photosJson', Sort.asc);
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterSortBy> thenByPhotosJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'photosJson', Sort.desc);
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterSortBy> thenByPreparedBy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'preparedBy', Sort.asc);
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterSortBy> thenByPreparedByDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'preparedBy', Sort.desc);
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterSortBy> thenByProjectName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'projectName', Sort.asc);
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterSortBy> thenByProjectNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'projectName', Sort.desc);
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterSortBy> thenByProjectUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'projectUuid', Sort.asc);
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterSortBy> thenByProjectUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'projectUuid', Sort.desc);
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterSortBy> thenByReportDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reportDate', Sort.asc);
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterSortBy> thenByReportDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reportDate', Sort.desc);
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterSortBy> thenByReportingPeriod() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reportingPeriod', Sort.asc);
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterSortBy> thenByReportingPeriodDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reportingPeriod', Sort.desc);
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterSortBy> thenBySignedApproved() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'signedApproved', Sort.asc);
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterSortBy> thenBySignedApprovedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'signedApproved', Sort.desc);
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterSortBy> thenBySignedChecked() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'signedChecked', Sort.asc);
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterSortBy> thenBySignedCheckedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'signedChecked', Sort.desc);
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterSortBy> thenBySignedPrepared() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'signedPrepared', Sort.asc);
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterSortBy> thenBySignedPreparedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'signedPrepared', Sort.desc);
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterSortBy> thenBySiteCondition() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'siteCondition', Sort.asc);
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterSortBy> thenBySiteConditionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'siteCondition', Sort.desc);
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterSortBy> thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterSortBy> thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterSortBy> thenByTemperature() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'temperature', Sort.asc);
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterSortBy> thenByTemperatureDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'temperature', Sort.desc);
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterSortBy> thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterSortBy> thenByUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.asc);
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterSortBy> thenByUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.desc);
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterSortBy> thenByWeather() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weather', Sort.asc);
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterSortBy> thenByWeatherDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weather', Sort.desc);
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterSortBy> thenByWindCondition() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'windCondition', Sort.asc);
    });
  }

  QueryBuilder<DarModel, DarModel, QAfterSortBy> thenByWindConditionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'windCondition', Sort.desc);
    });
  }
}

extension DarModelQueryWhereDistinct
    on QueryBuilder<DarModel, DarModel, QDistinct> {
  QueryBuilder<DarModel, DarModel, QDistinct> distinctByAccomplishmentsJson({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'accomplishmentsJson',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<DarModel, DarModel, QDistinct> distinctByDarNumber({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'darNumber', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DarModel, DarModel, QDistinct> distinctByDelaysJson({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'delaysJson', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DarModel, DarModel, QDistinct> distinctByEquipmentJson({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'equipmentJson',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QDistinct> distinctByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isSynced');
    });
  }

  QueryBuilder<DarModel, DarModel, QDistinct> distinctByManpowerJson({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'manpowerJson', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DarModel, DarModel, QDistinct> distinctByMaterialsJson({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'materialsJson',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QDistinct> distinctByPhotosJson({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'photosJson', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DarModel, DarModel, QDistinct> distinctByPreparedBy({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'preparedBy', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DarModel, DarModel, QDistinct> distinctByProjectName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'projectName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DarModel, DarModel, QDistinct> distinctByProjectUuid({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'projectUuid', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DarModel, DarModel, QDistinct> distinctByReportDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'reportDate');
    });
  }

  QueryBuilder<DarModel, DarModel, QDistinct> distinctByReportingPeriod({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'reportingPeriod',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QDistinct> distinctBySignedApproved({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'signedApproved',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QDistinct> distinctBySignedChecked({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'signedChecked',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QDistinct> distinctBySignedPrepared({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'signedPrepared',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QDistinct> distinctBySiteCondition({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'siteCondition',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<DarModel, DarModel, QDistinct> distinctByStatus({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DarModel, DarModel, QDistinct> distinctByTemperature() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'temperature');
    });
  }

  QueryBuilder<DarModel, DarModel, QDistinct> distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }

  QueryBuilder<DarModel, DarModel, QDistinct> distinctByUuid({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'uuid', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DarModel, DarModel, QDistinct> distinctByWeather({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'weather', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DarModel, DarModel, QDistinct> distinctByWindCondition({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'windCondition',
        caseSensitive: caseSensitive,
      );
    });
  }
}

extension DarModelQueryProperty
    on QueryBuilder<DarModel, DarModel, QQueryProperty> {
  QueryBuilder<DarModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<DarModel, String, QQueryOperations>
  accomplishmentsJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'accomplishmentsJson');
    });
  }

  QueryBuilder<DarModel, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<DarModel, String, QQueryOperations> darNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'darNumber');
    });
  }

  QueryBuilder<DarModel, String, QQueryOperations> delaysJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'delaysJson');
    });
  }

  QueryBuilder<DarModel, String, QQueryOperations> equipmentJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'equipmentJson');
    });
  }

  QueryBuilder<DarModel, bool, QQueryOperations> isSyncedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isSynced');
    });
  }

  QueryBuilder<DarModel, String, QQueryOperations> manpowerJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'manpowerJson');
    });
  }

  QueryBuilder<DarModel, String, QQueryOperations> materialsJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'materialsJson');
    });
  }

  QueryBuilder<DarModel, String, QQueryOperations> photosJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'photosJson');
    });
  }

  QueryBuilder<DarModel, String, QQueryOperations> preparedByProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'preparedBy');
    });
  }

  QueryBuilder<DarModel, String, QQueryOperations> projectNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'projectName');
    });
  }

  QueryBuilder<DarModel, String, QQueryOperations> projectUuidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'projectUuid');
    });
  }

  QueryBuilder<DarModel, DateTime, QQueryOperations> reportDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'reportDate');
    });
  }

  QueryBuilder<DarModel, String, QQueryOperations> reportingPeriodProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'reportingPeriod');
    });
  }

  QueryBuilder<DarModel, String?, QQueryOperations> signedApprovedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'signedApproved');
    });
  }

  QueryBuilder<DarModel, String?, QQueryOperations> signedCheckedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'signedChecked');
    });
  }

  QueryBuilder<DarModel, String?, QQueryOperations> signedPreparedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'signedPrepared');
    });
  }

  QueryBuilder<DarModel, String, QQueryOperations> siteConditionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'siteCondition');
    });
  }

  QueryBuilder<DarModel, String, QQueryOperations> statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }

  QueryBuilder<DarModel, double, QQueryOperations> temperatureProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'temperature');
    });
  }

  QueryBuilder<DarModel, DateTime, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }

  QueryBuilder<DarModel, String, QQueryOperations> uuidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'uuid');
    });
  }

  QueryBuilder<DarModel, String, QQueryOperations> weatherProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'weather');
    });
  }

  QueryBuilder<DarModel, String, QQueryOperations> windConditionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'windCondition');
    });
  }
}
