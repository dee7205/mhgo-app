// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'survey_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSurveyModelCollection on Isar {
  IsarCollection<SurveyModel> get surveyModels => this.collection();
}

const SurveyModelSchema = CollectionSchema(
  name: r'SurveyModel',
  id: 4129436105623464292,
  properties: {
    r'address': PropertySchema(id: 0, name: r'address', type: IsarType.string),
    r'clientName': PropertySchema(
      id: 1,
      name: r'clientName',
      type: IsarType.string,
    ),
    r'contactNumber': PropertySchema(
      id: 2,
      name: r'contactNumber',
      type: IsarType.string,
    ),
    r'convertedProjectUuid': PropertySchema(
      id: 3,
      name: r'convertedProjectUuid',
      type: IsarType.string,
    ),
    r'coordinates': PropertySchema(
      id: 4,
      name: r'coordinates',
      type: IsarType.string,
    ),
    r'createdAt': PropertySchema(
      id: 5,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'email': PropertySchema(id: 6, name: r'email', type: IsarType.string),
    r'isSynced': PropertySchema(id: 7, name: r'isSynced', type: IsarType.bool),
    r'notes': PropertySchema(id: 8, name: r'notes', type: IsarType.string),
    r'proposedBudget': PropertySchema(
      id: 9,
      name: r'proposedBudget',
      type: IsarType.double,
    ),
    r'proposedCapacityKw': PropertySchema(
      id: 10,
      name: r'proposedCapacityKw',
      type: IsarType.double,
    ),
    r'proposedSystem': PropertySchema(
      id: 11,
      name: r'proposedSystem',
      type: IsarType.string,
    ),
    r'status': PropertySchema(id: 12, name: r'status', type: IsarType.string),
    r'surveyDate': PropertySchema(
      id: 13,
      name: r'surveyDate',
      type: IsarType.dateTime,
    ),
    r'technicalSpecsJson': PropertySchema(
      id: 14,
      name: r'technicalSpecsJson',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 15,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
    r'uuid': PropertySchema(id: 16, name: r'uuid', type: IsarType.string),
  },

  estimateSize: _surveyModelEstimateSize,
  serialize: _surveyModelSerialize,
  deserialize: _surveyModelDeserialize,
  deserializeProp: _surveyModelDeserializeProp,
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
    r'clientName': IndexSchema(
      id: 94440930009573304,
      name: r'clientName',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'clientName',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
    r'address': IndexSchema(
      id: -259407546592846288,
      name: r'address',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'address',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
    r'status': IndexSchema(
      id: -107785170620420283,
      name: r'status',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'status',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _surveyModelGetId,
  getLinks: _surveyModelGetLinks,
  attach: _surveyModelAttach,
  version: '3.3.2',
);

int _surveyModelEstimateSize(
  SurveyModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.address.length * 3;
  bytesCount += 3 + object.clientName.length * 3;
  bytesCount += 3 + object.contactNumber.length * 3;
  {
    final value = object.convertedProjectUuid;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.coordinates;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.email.length * 3;
  {
    final value = object.notes;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.proposedSystem.length * 3;
  bytesCount += 3 + object.status.length * 3;
  bytesCount += 3 + object.technicalSpecsJson.length * 3;
  bytesCount += 3 + object.uuid.length * 3;
  return bytesCount;
}

void _surveyModelSerialize(
  SurveyModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.address);
  writer.writeString(offsets[1], object.clientName);
  writer.writeString(offsets[2], object.contactNumber);
  writer.writeString(offsets[3], object.convertedProjectUuid);
  writer.writeString(offsets[4], object.coordinates);
  writer.writeDateTime(offsets[5], object.createdAt);
  writer.writeString(offsets[6], object.email);
  writer.writeBool(offsets[7], object.isSynced);
  writer.writeString(offsets[8], object.notes);
  writer.writeDouble(offsets[9], object.proposedBudget);
  writer.writeDouble(offsets[10], object.proposedCapacityKw);
  writer.writeString(offsets[11], object.proposedSystem);
  writer.writeString(offsets[12], object.status);
  writer.writeDateTime(offsets[13], object.surveyDate);
  writer.writeString(offsets[14], object.technicalSpecsJson);
  writer.writeDateTime(offsets[15], object.updatedAt);
  writer.writeString(offsets[16], object.uuid);
}

SurveyModel _surveyModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SurveyModel();
  object.address = reader.readString(offsets[0]);
  object.clientName = reader.readString(offsets[1]);
  object.contactNumber = reader.readString(offsets[2]);
  object.convertedProjectUuid = reader.readStringOrNull(offsets[3]);
  object.coordinates = reader.readStringOrNull(offsets[4]);
  object.createdAt = reader.readDateTime(offsets[5]);
  object.email = reader.readString(offsets[6]);
  object.id = id;
  object.isSynced = reader.readBool(offsets[7]);
  object.notes = reader.readStringOrNull(offsets[8]);
  object.proposedBudget = reader.readDouble(offsets[9]);
  object.proposedCapacityKw = reader.readDouble(offsets[10]);
  object.proposedSystem = reader.readString(offsets[11]);
  object.status = reader.readString(offsets[12]);
  object.surveyDate = reader.readDateTime(offsets[13]);
  object.technicalSpecsJson = reader.readString(offsets[14]);
  object.updatedAt = reader.readDateTime(offsets[15]);
  object.uuid = reader.readString(offsets[16]);
  return object;
}

P _surveyModelDeserializeProp<P>(
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
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readDateTime(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readBool(offset)) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    case 9:
      return (reader.readDouble(offset)) as P;
    case 10:
      return (reader.readDouble(offset)) as P;
    case 11:
      return (reader.readString(offset)) as P;
    case 12:
      return (reader.readString(offset)) as P;
    case 13:
      return (reader.readDateTime(offset)) as P;
    case 14:
      return (reader.readString(offset)) as P;
    case 15:
      return (reader.readDateTime(offset)) as P;
    case 16:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _surveyModelGetId(SurveyModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _surveyModelGetLinks(SurveyModel object) {
  return [];
}

void _surveyModelAttach(
  IsarCollection<dynamic> col,
  Id id,
  SurveyModel object,
) {
  object.id = id;
}

extension SurveyModelByIndex on IsarCollection<SurveyModel> {
  Future<SurveyModel?> getByUuid(String uuid) {
    return getByIndex(r'uuid', [uuid]);
  }

  SurveyModel? getByUuidSync(String uuid) {
    return getByIndexSync(r'uuid', [uuid]);
  }

  Future<bool> deleteByUuid(String uuid) {
    return deleteByIndex(r'uuid', [uuid]);
  }

  bool deleteByUuidSync(String uuid) {
    return deleteByIndexSync(r'uuid', [uuid]);
  }

  Future<List<SurveyModel?>> getAllByUuid(List<String> uuidValues) {
    final values = uuidValues.map((e) => [e]).toList();
    return getAllByIndex(r'uuid', values);
  }

  List<SurveyModel?> getAllByUuidSync(List<String> uuidValues) {
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

  Future<Id> putByUuid(SurveyModel object) {
    return putByIndex(r'uuid', object);
  }

  Id putByUuidSync(SurveyModel object, {bool saveLinks = true}) {
    return putByIndexSync(r'uuid', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByUuid(List<SurveyModel> objects) {
    return putAllByIndex(r'uuid', objects);
  }

  List<Id> putAllByUuidSync(
    List<SurveyModel> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(r'uuid', objects, saveLinks: saveLinks);
  }
}

extension SurveyModelQueryWhereSort
    on QueryBuilder<SurveyModel, SurveyModel, QWhere> {
  QueryBuilder<SurveyModel, SurveyModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterWhere> anyClientName() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'clientName'),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterWhere> anyAddress() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'address'),
      );
    });
  }
}

extension SurveyModelQueryWhere
    on QueryBuilder<SurveyModel, SurveyModel, QWhereClause> {
  QueryBuilder<SurveyModel, SurveyModel, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterWhereClause> idNotEqualTo(
    Id id,
  ) {
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

  QueryBuilder<SurveyModel, SurveyModel, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterWhereClause> idBetween(
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

  QueryBuilder<SurveyModel, SurveyModel, QAfterWhereClause> uuidEqualTo(
    String uuid,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'uuid', value: [uuid]),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterWhereClause> uuidNotEqualTo(
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

  QueryBuilder<SurveyModel, SurveyModel, QAfterWhereClause> clientNameEqualTo(
    String clientName,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'clientName', value: [clientName]),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterWhereClause>
  clientNameNotEqualTo(String clientName) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'clientName',
                lower: [],
                upper: [clientName],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'clientName',
                lower: [clientName],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'clientName',
                lower: [clientName],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'clientName',
                lower: [],
                upper: [clientName],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterWhereClause>
  clientNameGreaterThan(String clientName, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'clientName',
          lower: [clientName],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterWhereClause> clientNameLessThan(
    String clientName, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'clientName',
          lower: [],
          upper: [clientName],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterWhereClause> clientNameBetween(
    String lowerClientName,
    String upperClientName, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'clientName',
          lower: [lowerClientName],
          includeLower: includeLower,
          upper: [upperClientName],
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterWhereClause>
  clientNameStartsWith(String ClientNamePrefix) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'clientName',
          lower: [ClientNamePrefix],
          upper: ['$ClientNamePrefix\u{FFFFF}'],
        ),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterWhereClause>
  clientNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'clientName', value: ['']),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterWhereClause>
  clientNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.lessThan(indexName: r'clientName', upper: ['']),
            )
            .addWhereClause(
              IndexWhereClause.greaterThan(
                indexName: r'clientName',
                lower: [''],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.greaterThan(
                indexName: r'clientName',
                lower: [''],
              ),
            )
            .addWhereClause(
              IndexWhereClause.lessThan(indexName: r'clientName', upper: ['']),
            );
      }
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterWhereClause> addressEqualTo(
    String address,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'address', value: [address]),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterWhereClause> addressNotEqualTo(
    String address,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'address',
                lower: [],
                upper: [address],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'address',
                lower: [address],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'address',
                lower: [address],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'address',
                lower: [],
                upper: [address],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterWhereClause> addressGreaterThan(
    String address, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'address',
          lower: [address],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterWhereClause> addressLessThan(
    String address, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'address',
          lower: [],
          upper: [address],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterWhereClause> addressBetween(
    String lowerAddress,
    String upperAddress, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'address',
          lower: [lowerAddress],
          includeLower: includeLower,
          upper: [upperAddress],
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterWhereClause> addressStartsWith(
    String AddressPrefix,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'address',
          lower: [AddressPrefix],
          upper: ['$AddressPrefix\u{FFFFF}'],
        ),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterWhereClause> addressIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'address', value: ['']),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterWhereClause>
  addressIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.lessThan(indexName: r'address', upper: ['']),
            )
            .addWhereClause(
              IndexWhereClause.greaterThan(indexName: r'address', lower: ['']),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.greaterThan(indexName: r'address', lower: ['']),
            )
            .addWhereClause(
              IndexWhereClause.lessThan(indexName: r'address', upper: ['']),
            );
      }
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterWhereClause> statusEqualTo(
    String status,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'status', value: [status]),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterWhereClause> statusNotEqualTo(
    String status,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'status',
                lower: [],
                upper: [status],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'status',
                lower: [status],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'status',
                lower: [status],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'status',
                lower: [],
                upper: [status],
                includeUpper: false,
              ),
            );
      }
    });
  }
}

extension SurveyModelQueryFilter
    on QueryBuilder<SurveyModel, SurveyModel, QFilterCondition> {
  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition> addressEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'address',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition>
  addressGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'address',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition> addressLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'address',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition> addressBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'address',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition>
  addressStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'address',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition> addressEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'address',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition> addressContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'address',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition> addressMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'address',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition>
  addressIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'address', value: ''),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition>
  addressIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'address', value: ''),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition>
  clientNameEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'clientName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition>
  clientNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'clientName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition>
  clientNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'clientName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition>
  clientNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'clientName',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition>
  clientNameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'clientName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition>
  clientNameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'clientName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition>
  clientNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'clientName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition>
  clientNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'clientName',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition>
  clientNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'clientName', value: ''),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition>
  clientNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'clientName', value: ''),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition>
  contactNumberEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'contactNumber',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition>
  contactNumberGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'contactNumber',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition>
  contactNumberLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'contactNumber',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition>
  contactNumberBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'contactNumber',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition>
  contactNumberStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'contactNumber',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition>
  contactNumberEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'contactNumber',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition>
  contactNumberContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'contactNumber',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition>
  contactNumberMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'contactNumber',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition>
  contactNumberIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'contactNumber', value: ''),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition>
  contactNumberIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'contactNumber', value: ''),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition>
  convertedProjectUuidIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'convertedProjectUuid'),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition>
  convertedProjectUuidIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'convertedProjectUuid'),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition>
  convertedProjectUuidEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'convertedProjectUuid',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition>
  convertedProjectUuidGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'convertedProjectUuid',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition>
  convertedProjectUuidLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'convertedProjectUuid',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition>
  convertedProjectUuidBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'convertedProjectUuid',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition>
  convertedProjectUuidStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'convertedProjectUuid',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition>
  convertedProjectUuidEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'convertedProjectUuid',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition>
  convertedProjectUuidContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'convertedProjectUuid',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition>
  convertedProjectUuidMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'convertedProjectUuid',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition>
  convertedProjectUuidIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'convertedProjectUuid', value: ''),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition>
  convertedProjectUuidIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          property: r'convertedProjectUuid',
          value: '',
        ),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition>
  coordinatesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'coordinates'),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition>
  coordinatesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'coordinates'),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition>
  coordinatesEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'coordinates',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition>
  coordinatesGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'coordinates',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition>
  coordinatesLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'coordinates',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition>
  coordinatesBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'coordinates',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition>
  coordinatesStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'coordinates',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition>
  coordinatesEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'coordinates',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition>
  coordinatesContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'coordinates',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition>
  coordinatesMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'coordinates',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition>
  coordinatesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'coordinates', value: ''),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition>
  coordinatesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'coordinates', value: ''),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition>
  createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'createdAt', value: value),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition>
  createdAtGreaterThan(DateTime value, {bool include = false}) {
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

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition>
  createdAtLessThan(DateTime value, {bool include = false}) {
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

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition>
  createdAtBetween(
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

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition> emailEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'email',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition>
  emailGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'email',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition> emailLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'email',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition> emailBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'email',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition> emailStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'email',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition> emailEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'email',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition> emailContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'email',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition> emailMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'email',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition> emailIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'email', value: ''),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition>
  emailIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'email', value: ''),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition> idBetween(
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

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition> isSyncedEqualTo(
    bool value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isSynced', value: value),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition> notesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'notes'),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition>
  notesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'notes'),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition> notesEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'notes',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition>
  notesGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'notes',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition> notesLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'notes',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition> notesBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'notes',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition> notesStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'notes',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition> notesEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'notes',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition> notesContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'notes',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition> notesMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'notes',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition> notesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'notes', value: ''),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition>
  notesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'notes', value: ''),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition>
  proposedBudgetEqualTo(double value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'proposedBudget',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition>
  proposedBudgetGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'proposedBudget',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition>
  proposedBudgetLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'proposedBudget',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition>
  proposedBudgetBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'proposedBudget',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition>
  proposedCapacityKwEqualTo(double value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'proposedCapacityKw',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition>
  proposedCapacityKwGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'proposedCapacityKw',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition>
  proposedCapacityKwLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'proposedCapacityKw',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition>
  proposedCapacityKwBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'proposedCapacityKw',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition>
  proposedSystemEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'proposedSystem',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition>
  proposedSystemGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'proposedSystem',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition>
  proposedSystemLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'proposedSystem',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition>
  proposedSystemBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'proposedSystem',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition>
  proposedSystemStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'proposedSystem',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition>
  proposedSystemEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'proposedSystem',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition>
  proposedSystemContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'proposedSystem',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition>
  proposedSystemMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'proposedSystem',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition>
  proposedSystemIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'proposedSystem', value: ''),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition>
  proposedSystemIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'proposedSystem', value: ''),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition> statusEqualTo(
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

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition>
  statusGreaterThan(
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

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition> statusLessThan(
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

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition> statusBetween(
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

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition>
  statusStartsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition> statusEndsWith(
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

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition> statusContains(
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

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition> statusMatches(
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

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition>
  statusIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'status', value: ''),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition>
  statusIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'status', value: ''),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition>
  surveyDateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'surveyDate', value: value),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition>
  surveyDateGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'surveyDate',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition>
  surveyDateLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'surveyDate',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition>
  surveyDateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'surveyDate',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition>
  technicalSpecsJsonEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'technicalSpecsJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition>
  technicalSpecsJsonGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'technicalSpecsJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition>
  technicalSpecsJsonLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'technicalSpecsJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition>
  technicalSpecsJsonBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'technicalSpecsJson',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition>
  technicalSpecsJsonStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'technicalSpecsJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition>
  technicalSpecsJsonEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'technicalSpecsJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition>
  technicalSpecsJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'technicalSpecsJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition>
  technicalSpecsJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'technicalSpecsJson',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition>
  technicalSpecsJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'technicalSpecsJson', value: ''),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition>
  technicalSpecsJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'technicalSpecsJson', value: ''),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition>
  updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'updatedAt', value: value),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition>
  updatedAtGreaterThan(DateTime value, {bool include = false}) {
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

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition>
  updatedAtLessThan(DateTime value, {bool include = false}) {
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

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition>
  updatedAtBetween(
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

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition> uuidEqualTo(
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

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition> uuidGreaterThan(
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

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition> uuidLessThan(
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

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition> uuidBetween(
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

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition> uuidStartsWith(
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

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition> uuidEndsWith(
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

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition> uuidContains(
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

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition> uuidMatches(
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

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition> uuidIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'uuid', value: ''),
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterFilterCondition>
  uuidIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'uuid', value: ''),
      );
    });
  }
}

extension SurveyModelQueryObject
    on QueryBuilder<SurveyModel, SurveyModel, QFilterCondition> {}

extension SurveyModelQueryLinks
    on QueryBuilder<SurveyModel, SurveyModel, QFilterCondition> {}

extension SurveyModelQuerySortBy
    on QueryBuilder<SurveyModel, SurveyModel, QSortBy> {
  QueryBuilder<SurveyModel, SurveyModel, QAfterSortBy> sortByAddress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'address', Sort.asc);
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterSortBy> sortByAddressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'address', Sort.desc);
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterSortBy> sortByClientName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clientName', Sort.asc);
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterSortBy> sortByClientNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clientName', Sort.desc);
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterSortBy> sortByContactNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contactNumber', Sort.asc);
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterSortBy>
  sortByContactNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contactNumber', Sort.desc);
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterSortBy>
  sortByConvertedProjectUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'convertedProjectUuid', Sort.asc);
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterSortBy>
  sortByConvertedProjectUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'convertedProjectUuid', Sort.desc);
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterSortBy> sortByCoordinates() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coordinates', Sort.asc);
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterSortBy> sortByCoordinatesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coordinates', Sort.desc);
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterSortBy> sortByEmail() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'email', Sort.asc);
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterSortBy> sortByEmailDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'email', Sort.desc);
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterSortBy> sortByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.asc);
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterSortBy> sortByIsSyncedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.desc);
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterSortBy> sortByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterSortBy> sortByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterSortBy> sortByProposedBudget() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'proposedBudget', Sort.asc);
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterSortBy>
  sortByProposedBudgetDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'proposedBudget', Sort.desc);
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterSortBy>
  sortByProposedCapacityKw() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'proposedCapacityKw', Sort.asc);
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterSortBy>
  sortByProposedCapacityKwDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'proposedCapacityKw', Sort.desc);
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterSortBy> sortByProposedSystem() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'proposedSystem', Sort.asc);
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterSortBy>
  sortByProposedSystemDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'proposedSystem', Sort.desc);
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterSortBy> sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterSortBy> sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterSortBy> sortBySurveyDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surveyDate', Sort.asc);
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterSortBy> sortBySurveyDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surveyDate', Sort.desc);
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterSortBy>
  sortByTechnicalSpecsJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'technicalSpecsJson', Sort.asc);
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterSortBy>
  sortByTechnicalSpecsJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'technicalSpecsJson', Sort.desc);
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterSortBy> sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterSortBy> sortByUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.asc);
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterSortBy> sortByUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.desc);
    });
  }
}

extension SurveyModelQuerySortThenBy
    on QueryBuilder<SurveyModel, SurveyModel, QSortThenBy> {
  QueryBuilder<SurveyModel, SurveyModel, QAfterSortBy> thenByAddress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'address', Sort.asc);
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterSortBy> thenByAddressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'address', Sort.desc);
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterSortBy> thenByClientName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clientName', Sort.asc);
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterSortBy> thenByClientNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clientName', Sort.desc);
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterSortBy> thenByContactNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contactNumber', Sort.asc);
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterSortBy>
  thenByContactNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contactNumber', Sort.desc);
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterSortBy>
  thenByConvertedProjectUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'convertedProjectUuid', Sort.asc);
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterSortBy>
  thenByConvertedProjectUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'convertedProjectUuid', Sort.desc);
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterSortBy> thenByCoordinates() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coordinates', Sort.asc);
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterSortBy> thenByCoordinatesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coordinates', Sort.desc);
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterSortBy> thenByEmail() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'email', Sort.asc);
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterSortBy> thenByEmailDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'email', Sort.desc);
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterSortBy> thenByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.asc);
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterSortBy> thenByIsSyncedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.desc);
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterSortBy> thenByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterSortBy> thenByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterSortBy> thenByProposedBudget() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'proposedBudget', Sort.asc);
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterSortBy>
  thenByProposedBudgetDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'proposedBudget', Sort.desc);
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterSortBy>
  thenByProposedCapacityKw() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'proposedCapacityKw', Sort.asc);
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterSortBy>
  thenByProposedCapacityKwDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'proposedCapacityKw', Sort.desc);
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterSortBy> thenByProposedSystem() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'proposedSystem', Sort.asc);
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterSortBy>
  thenByProposedSystemDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'proposedSystem', Sort.desc);
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterSortBy> thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterSortBy> thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterSortBy> thenBySurveyDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surveyDate', Sort.asc);
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterSortBy> thenBySurveyDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surveyDate', Sort.desc);
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterSortBy>
  thenByTechnicalSpecsJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'technicalSpecsJson', Sort.asc);
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterSortBy>
  thenByTechnicalSpecsJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'technicalSpecsJson', Sort.desc);
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterSortBy> thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterSortBy> thenByUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.asc);
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QAfterSortBy> thenByUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.desc);
    });
  }
}

extension SurveyModelQueryWhereDistinct
    on QueryBuilder<SurveyModel, SurveyModel, QDistinct> {
  QueryBuilder<SurveyModel, SurveyModel, QDistinct> distinctByAddress({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'address', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QDistinct> distinctByClientName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'clientName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QDistinct> distinctByContactNumber({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'contactNumber',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QDistinct>
  distinctByConvertedProjectUuid({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'convertedProjectUuid',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QDistinct> distinctByCoordinates({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'coordinates', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QDistinct> distinctByEmail({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'email', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QDistinct> distinctByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isSynced');
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QDistinct> distinctByNotes({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'notes', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QDistinct> distinctByProposedBudget() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'proposedBudget');
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QDistinct>
  distinctByProposedCapacityKw() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'proposedCapacityKw');
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QDistinct> distinctByProposedSystem({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'proposedSystem',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QDistinct> distinctByStatus({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QDistinct> distinctBySurveyDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'surveyDate');
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QDistinct>
  distinctByTechnicalSpecsJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'technicalSpecsJson',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QDistinct> distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }

  QueryBuilder<SurveyModel, SurveyModel, QDistinct> distinctByUuid({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'uuid', caseSensitive: caseSensitive);
    });
  }
}

extension SurveyModelQueryProperty
    on QueryBuilder<SurveyModel, SurveyModel, QQueryProperty> {
  QueryBuilder<SurveyModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<SurveyModel, String, QQueryOperations> addressProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'address');
    });
  }

  QueryBuilder<SurveyModel, String, QQueryOperations> clientNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'clientName');
    });
  }

  QueryBuilder<SurveyModel, String, QQueryOperations> contactNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'contactNumber');
    });
  }

  QueryBuilder<SurveyModel, String?, QQueryOperations>
  convertedProjectUuidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'convertedProjectUuid');
    });
  }

  QueryBuilder<SurveyModel, String?, QQueryOperations> coordinatesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'coordinates');
    });
  }

  QueryBuilder<SurveyModel, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<SurveyModel, String, QQueryOperations> emailProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'email');
    });
  }

  QueryBuilder<SurveyModel, bool, QQueryOperations> isSyncedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isSynced');
    });
  }

  QueryBuilder<SurveyModel, String?, QQueryOperations> notesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'notes');
    });
  }

  QueryBuilder<SurveyModel, double, QQueryOperations> proposedBudgetProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'proposedBudget');
    });
  }

  QueryBuilder<SurveyModel, double, QQueryOperations>
  proposedCapacityKwProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'proposedCapacityKw');
    });
  }

  QueryBuilder<SurveyModel, String, QQueryOperations> proposedSystemProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'proposedSystem');
    });
  }

  QueryBuilder<SurveyModel, String, QQueryOperations> statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }

  QueryBuilder<SurveyModel, DateTime, QQueryOperations> surveyDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'surveyDate');
    });
  }

  QueryBuilder<SurveyModel, String, QQueryOperations>
  technicalSpecsJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'technicalSpecsJson');
    });
  }

  QueryBuilder<SurveyModel, DateTime, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }

  QueryBuilder<SurveyModel, String, QQueryOperations> uuidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'uuid');
    });
  }
}
