// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetProjectModelCollection on Isar {
  IsarCollection<ProjectModel> get projectModels => this.collection();
}

const ProjectModelSchema = CollectionSchema(
  name: r'ProjectModel',
  id: 1822059982794199752,
  properties: {
    r'bomSpecsJson': PropertySchema(
      id: 0,
      name: r'bomSpecsJson',
      type: IsarType.string,
    ),
    r'capacityMw': PropertySchema(
      id: 1,
      name: r'capacityMw',
      type: IsarType.double,
    ),
    r'capacityUnit': PropertySchema(
      id: 2,
      name: r'capacityUnit',
      type: IsarType.string,
    ),
    r'client': PropertySchema(id: 3, name: r'client', type: IsarType.string),
    r'createdAt': PropertySchema(
      id: 4,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'description': PropertySchema(
      id: 5,
      name: r'description',
      type: IsarType.string,
    ),
    r'endDate': PropertySchema(
      id: 6,
      name: r'endDate',
      type: IsarType.dateTime,
    ),
    r'isSynced': PropertySchema(id: 7, name: r'isSynced', type: IsarType.bool),
    r'location': PropertySchema(
      id: 8,
      name: r'location',
      type: IsarType.string,
    ),
    r'name': PropertySchema(id: 9, name: r'name', type: IsarType.string),
    r'progress': PropertySchema(
      id: 10,
      name: r'progress',
      type: IsarType.double,
    ),
    r'stage': PropertySchema(id: 11, name: r'stage', type: IsarType.string),
    r'startDate': PropertySchema(
      id: 12,
      name: r'startDate',
      type: IsarType.dateTime,
    ),
    r'status': PropertySchema(id: 13, name: r'status', type: IsarType.string),
    r'supervisor': PropertySchema(
      id: 14,
      name: r'supervisor',
      type: IsarType.string,
    ),
    r'systemType': PropertySchema(
      id: 15,
      name: r'systemType',
      type: IsarType.string,
    ),
    r'teamMembersJson': PropertySchema(
      id: 16,
      name: r'teamMembersJson',
      type: IsarType.string,
    ),
    r'totalCost': PropertySchema(
      id: 17,
      name: r'totalCost',
      type: IsarType.double,
    ),
    r'type': PropertySchema(id: 18, name: r'type', type: IsarType.string),
    r'updatedAt': PropertySchema(
      id: 19,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
    r'uuid': PropertySchema(id: 20, name: r'uuid', type: IsarType.string),
  },

  estimateSize: _projectModelEstimateSize,
  serialize: _projectModelSerialize,
  deserialize: _projectModelDeserialize,
  deserializeProp: _projectModelDeserializeProp,
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
  },
  links: {},
  embeddedSchemas: {},

  getId: _projectModelGetId,
  getLinks: _projectModelGetLinks,
  attach: _projectModelAttach,
  version: '3.3.2',
);

int _projectModelEstimateSize(
  ProjectModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.bomSpecsJson;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.capacityUnit;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.client;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.description;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.location.length * 3;
  bytesCount += 3 + object.name.length * 3;
  {
    final value = object.stage;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.status.length * 3;
  {
    final value = object.supervisor;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.systemType;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.teamMembersJson;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.type.length * 3;
  bytesCount += 3 + object.uuid.length * 3;
  return bytesCount;
}

void _projectModelSerialize(
  ProjectModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.bomSpecsJson);
  writer.writeDouble(offsets[1], object.capacity);
  writer.writeString(offsets[2], object.capacityUnit);
  writer.writeString(offsets[3], object.client);
  writer.writeDateTime(offsets[4], object.createdAt);
  writer.writeString(offsets[5], object.description);
  writer.writeDateTime(offsets[6], object.endDate);
  writer.writeBool(offsets[7], object.isSynced);
  writer.writeString(offsets[8], object.location);
  writer.writeString(offsets[9], object.name);
  writer.writeDouble(offsets[10], object.progress);
  writer.writeString(offsets[11], object.stage);
  writer.writeDateTime(offsets[12], object.startDate);
  writer.writeString(offsets[13], object.status);
  writer.writeString(offsets[14], object.supervisor);
  writer.writeString(offsets[15], object.systemType);
  writer.writeString(offsets[16], object.teamMembersJson);
  writer.writeDouble(offsets[17], object.totalCost);
  writer.writeString(offsets[18], object.type);
  writer.writeDateTime(offsets[19], object.updatedAt);
  writer.writeString(offsets[20], object.uuid);
}

ProjectModel _projectModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ProjectModel();
  object.bomSpecsJson = reader.readStringOrNull(offsets[0]);
  object.capacity = reader.readDouble(offsets[1]);
  object.capacityUnit = reader.readStringOrNull(offsets[2]);
  object.client = reader.readStringOrNull(offsets[3]);
  object.createdAt = reader.readDateTime(offsets[4]);
  object.description = reader.readStringOrNull(offsets[5]);
  object.endDate = reader.readDateTime(offsets[6]);
  object.id = id;
  object.isSynced = reader.readBool(offsets[7]);
  object.location = reader.readString(offsets[8]);
  object.name = reader.readString(offsets[9]);
  object.progress = reader.readDouble(offsets[10]);
  object.stage = reader.readStringOrNull(offsets[11]);
  object.startDate = reader.readDateTime(offsets[12]);
  object.status = reader.readString(offsets[13]);
  object.supervisor = reader.readStringOrNull(offsets[14]);
  object.systemType = reader.readStringOrNull(offsets[15]);
  object.teamMembersJson = reader.readStringOrNull(offsets[16]);
  object.totalCost = reader.readDouble(offsets[17]);
  object.type = reader.readString(offsets[18]);
  object.updatedAt = reader.readDateTime(offsets[19]);
  object.uuid = reader.readString(offsets[20]);
  return object;
}

P _projectModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readDateTime(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readDateTime(offset)) as P;
    case 7:
      return (reader.readBool(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readString(offset)) as P;
    case 10:
      return (reader.readDouble(offset)) as P;
    case 11:
      return (reader.readStringOrNull(offset)) as P;
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
      return (reader.readDouble(offset)) as P;
    case 18:
      return (reader.readString(offset)) as P;
    case 19:
      return (reader.readDateTime(offset)) as P;
    case 20:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _projectModelGetId(ProjectModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _projectModelGetLinks(ProjectModel object) {
  return [];
}

void _projectModelAttach(
  IsarCollection<dynamic> col,
  Id id,
  ProjectModel object,
) {
  object.id = id;
}

extension ProjectModelByIndex on IsarCollection<ProjectModel> {
  Future<ProjectModel?> getByUuid(String uuid) {
    return getByIndex(r'uuid', [uuid]);
  }

  ProjectModel? getByUuidSync(String uuid) {
    return getByIndexSync(r'uuid', [uuid]);
  }

  Future<bool> deleteByUuid(String uuid) {
    return deleteByIndex(r'uuid', [uuid]);
  }

  bool deleteByUuidSync(String uuid) {
    return deleteByIndexSync(r'uuid', [uuid]);
  }

  Future<List<ProjectModel?>> getAllByUuid(List<String> uuidValues) {
    final values = uuidValues.map((e) => [e]).toList();
    return getAllByIndex(r'uuid', values);
  }

  List<ProjectModel?> getAllByUuidSync(List<String> uuidValues) {
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

  Future<Id> putByUuid(ProjectModel object) {
    return putByIndex(r'uuid', object);
  }

  Id putByUuidSync(ProjectModel object, {bool saveLinks = true}) {
    return putByIndexSync(r'uuid', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByUuid(List<ProjectModel> objects) {
    return putAllByIndex(r'uuid', objects);
  }

  List<Id> putAllByUuidSync(
    List<ProjectModel> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(r'uuid', objects, saveLinks: saveLinks);
  }
}

extension ProjectModelQueryWhereSort
    on QueryBuilder<ProjectModel, ProjectModel, QWhere> {
  QueryBuilder<ProjectModel, ProjectModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ProjectModelQueryWhere
    on QueryBuilder<ProjectModel, ProjectModel, QWhereClause> {
  QueryBuilder<ProjectModel, ProjectModel, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<ProjectModel, ProjectModel, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterWhereClause> idBetween(
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

  QueryBuilder<ProjectModel, ProjectModel, QAfterWhereClause> uuidEqualTo(
    String uuid,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'uuid', value: [uuid]),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterWhereClause> uuidNotEqualTo(
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
}

extension ProjectModelQueryFilter
    on QueryBuilder<ProjectModel, ProjectModel, QFilterCondition> {
  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  bomSpecsJsonIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'bomSpecsJson'),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  bomSpecsJsonIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'bomSpecsJson'),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  bomSpecsJsonEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'bomSpecsJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  bomSpecsJsonGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'bomSpecsJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  bomSpecsJsonLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'bomSpecsJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  bomSpecsJsonBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'bomSpecsJson',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  bomSpecsJsonStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'bomSpecsJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  bomSpecsJsonEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'bomSpecsJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  bomSpecsJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'bomSpecsJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  bomSpecsJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'bomSpecsJson',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  bomSpecsJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'bomSpecsJson', value: ''),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  bomSpecsJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'bomSpecsJson', value: ''),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  capacityEqualTo(double value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'capacityMw',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  capacityGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'capacityMw',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  capacityLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'capacityMw',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  capacityBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'capacityMw',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  capacityUnitIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'capacityUnit'),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  capacityUnitIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'capacityUnit'),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  capacityUnitEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'capacityUnit',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  capacityUnitGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'capacityUnit',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  capacityUnitLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'capacityUnit',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  capacityUnitBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'capacityUnit',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  capacityUnitStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'capacityUnit',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  capacityUnitEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'capacityUnit',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  capacityUnitContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'capacityUnit',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  capacityUnitMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'capacityUnit',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  capacityUnitIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'capacityUnit', value: ''),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  capacityUnitIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'capacityUnit', value: ''),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  clientIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'client'),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  clientIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'client'),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition> clientEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'client',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  clientGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'client',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  clientLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'client',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition> clientBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'client',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  clientStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'client',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  clientEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'client',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  clientContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'client',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition> clientMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'client',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  clientIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'client', value: ''),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  clientIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'client', value: ''),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'createdAt', value: value),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
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

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
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

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
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

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  descriptionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'description'),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  descriptionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'description'),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  descriptionEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'description',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  descriptionGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'description',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  descriptionLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'description',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  descriptionBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'description',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  descriptionStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'description',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  descriptionEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'description',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  descriptionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'description',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  descriptionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'description',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  descriptionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'description', value: ''),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  descriptionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'description', value: ''),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  endDateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'endDate', value: value),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  endDateGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'endDate',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  endDateLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'endDate',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  endDateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'endDate',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition> idBetween(
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

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  isSyncedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isSynced', value: value),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  locationEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'location',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  locationGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'location',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  locationLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'location',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  locationBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'location',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  locationStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'location',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  locationEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'location',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  locationContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'location',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  locationMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'location',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  locationIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'location', value: ''),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  locationIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'location', value: ''),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition> nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition> nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'name',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  nameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition> nameContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition> nameMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'name',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'name', value: ''),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'name', value: ''),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  progressEqualTo(double value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'progress',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  progressGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'progress',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  progressLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'progress',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  progressBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'progress',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  stageIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'stage'),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  stageIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'stage'),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition> stageEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'stage',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  stageGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'stage',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition> stageLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'stage',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition> stageBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'stage',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  stageStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'stage',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition> stageEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'stage',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition> stageContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'stage',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition> stageMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'stage',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  stageIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'stage', value: ''),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  stageIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'stage', value: ''),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  startDateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'startDate', value: value),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  startDateGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'startDate',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  startDateLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'startDate',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  startDateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'startDate',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition> statusEqualTo(
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

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
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

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  statusLessThan(
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

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition> statusBetween(
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

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
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

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  statusEndsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  statusContains(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition> statusMatches(
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

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  statusIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'status', value: ''),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  statusIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'status', value: ''),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  supervisorIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'supervisor'),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  supervisorIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'supervisor'),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  supervisorEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'supervisor',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  supervisorGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'supervisor',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  supervisorLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'supervisor',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  supervisorBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'supervisor',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  supervisorStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'supervisor',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  supervisorEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'supervisor',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  supervisorContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'supervisor',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  supervisorMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'supervisor',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  supervisorIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'supervisor', value: ''),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  supervisorIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'supervisor', value: ''),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  systemTypeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'systemType'),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  systemTypeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'systemType'),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  systemTypeEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'systemType',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  systemTypeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'systemType',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  systemTypeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'systemType',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  systemTypeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'systemType',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  systemTypeStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'systemType',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  systemTypeEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'systemType',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  systemTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'systemType',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  systemTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'systemType',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  systemTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'systemType', value: ''),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  systemTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'systemType', value: ''),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  teamMembersJsonIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'teamMembersJson'),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  teamMembersJsonIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'teamMembersJson'),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  teamMembersJsonEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'teamMembersJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  teamMembersJsonGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'teamMembersJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  teamMembersJsonLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'teamMembersJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  teamMembersJsonBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'teamMembersJson',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  teamMembersJsonStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'teamMembersJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  teamMembersJsonEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'teamMembersJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  teamMembersJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'teamMembersJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  teamMembersJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'teamMembersJson',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  teamMembersJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'teamMembersJson', value: ''),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  teamMembersJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'teamMembersJson', value: ''),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  totalCostEqualTo(double value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'totalCost',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  totalCostGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'totalCost',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  totalCostLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'totalCost',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  totalCostBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'totalCost',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition> typeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'type',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  typeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'type',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition> typeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'type',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition> typeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'type',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  typeStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'type',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition> typeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'type',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition> typeContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'type',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition> typeMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'type',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  typeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'type', value: ''),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  typeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'type', value: ''),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'updatedAt', value: value),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
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

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
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

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
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

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition> uuidEqualTo(
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

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  uuidGreaterThan(
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

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition> uuidLessThan(
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

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition> uuidBetween(
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

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  uuidStartsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition> uuidEndsWith(
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

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition> uuidContains(
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

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition> uuidMatches(
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

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  uuidIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'uuid', value: ''),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
  uuidIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'uuid', value: ''),
      );
    });
  }
}

extension ProjectModelQueryObject
    on QueryBuilder<ProjectModel, ProjectModel, QFilterCondition> {}

extension ProjectModelQueryLinks
    on QueryBuilder<ProjectModel, ProjectModel, QFilterCondition> {}

extension ProjectModelQuerySortBy
    on QueryBuilder<ProjectModel, ProjectModel, QSortBy> {
  QueryBuilder<ProjectModel, ProjectModel, QAfterSortBy> sortByBomSpecsJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bomSpecsJson', Sort.asc);
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterSortBy>
  sortByBomSpecsJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bomSpecsJson', Sort.desc);
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterSortBy> sortByCapacity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'capacityMw', Sort.asc);
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterSortBy> sortByCapacityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'capacityMw', Sort.desc);
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterSortBy> sortByCapacityUnit() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'capacityUnit', Sort.asc);
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterSortBy>
  sortByCapacityUnitDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'capacityUnit', Sort.desc);
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterSortBy> sortByClient() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'client', Sort.asc);
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterSortBy> sortByClientDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'client', Sort.desc);
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterSortBy> sortByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterSortBy>
  sortByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterSortBy> sortByEndDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endDate', Sort.asc);
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterSortBy> sortByEndDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endDate', Sort.desc);
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterSortBy> sortByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.asc);
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterSortBy> sortByIsSyncedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.desc);
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterSortBy> sortByLocation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'location', Sort.asc);
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterSortBy> sortByLocationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'location', Sort.desc);
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterSortBy> sortByProgress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'progress', Sort.asc);
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterSortBy> sortByProgressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'progress', Sort.desc);
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterSortBy> sortByStage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stage', Sort.asc);
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterSortBy> sortByStageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stage', Sort.desc);
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterSortBy> sortByStartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startDate', Sort.asc);
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterSortBy> sortByStartDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startDate', Sort.desc);
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterSortBy> sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterSortBy> sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterSortBy> sortBySupervisor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'supervisor', Sort.asc);
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterSortBy>
  sortBySupervisorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'supervisor', Sort.desc);
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterSortBy> sortBySystemType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'systemType', Sort.asc);
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterSortBy>
  sortBySystemTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'systemType', Sort.desc);
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterSortBy>
  sortByTeamMembersJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'teamMembersJson', Sort.asc);
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterSortBy>
  sortByTeamMembersJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'teamMembersJson', Sort.desc);
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterSortBy> sortByTotalCost() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalCost', Sort.asc);
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterSortBy> sortByTotalCostDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalCost', Sort.desc);
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterSortBy> sortByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterSortBy> sortByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterSortBy> sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterSortBy> sortByUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.asc);
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterSortBy> sortByUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.desc);
    });
  }
}

extension ProjectModelQuerySortThenBy
    on QueryBuilder<ProjectModel, ProjectModel, QSortThenBy> {
  QueryBuilder<ProjectModel, ProjectModel, QAfterSortBy> thenByBomSpecsJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bomSpecsJson', Sort.asc);
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterSortBy>
  thenByBomSpecsJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bomSpecsJson', Sort.desc);
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterSortBy> thenByCapacity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'capacityMw', Sort.asc);
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterSortBy> thenByCapacityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'capacityMw', Sort.desc);
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterSortBy> thenByCapacityUnit() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'capacityUnit', Sort.asc);
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterSortBy>
  thenByCapacityUnitDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'capacityUnit', Sort.desc);
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterSortBy> thenByClient() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'client', Sort.asc);
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterSortBy> thenByClientDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'client', Sort.desc);
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterSortBy> thenByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterSortBy>
  thenByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterSortBy> thenByEndDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endDate', Sort.asc);
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterSortBy> thenByEndDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endDate', Sort.desc);
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterSortBy> thenByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.asc);
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterSortBy> thenByIsSyncedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.desc);
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterSortBy> thenByLocation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'location', Sort.asc);
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterSortBy> thenByLocationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'location', Sort.desc);
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterSortBy> thenByProgress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'progress', Sort.asc);
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterSortBy> thenByProgressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'progress', Sort.desc);
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterSortBy> thenByStage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stage', Sort.asc);
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterSortBy> thenByStageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stage', Sort.desc);
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterSortBy> thenByStartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startDate', Sort.asc);
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterSortBy> thenByStartDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startDate', Sort.desc);
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterSortBy> thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterSortBy> thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterSortBy> thenBySupervisor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'supervisor', Sort.asc);
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterSortBy>
  thenBySupervisorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'supervisor', Sort.desc);
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterSortBy> thenBySystemType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'systemType', Sort.asc);
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterSortBy>
  thenBySystemTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'systemType', Sort.desc);
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterSortBy>
  thenByTeamMembersJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'teamMembersJson', Sort.asc);
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterSortBy>
  thenByTeamMembersJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'teamMembersJson', Sort.desc);
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterSortBy> thenByTotalCost() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalCost', Sort.asc);
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterSortBy> thenByTotalCostDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalCost', Sort.desc);
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterSortBy> thenByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterSortBy> thenByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterSortBy> thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterSortBy> thenByUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.asc);
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterSortBy> thenByUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.desc);
    });
  }
}

extension ProjectModelQueryWhereDistinct
    on QueryBuilder<ProjectModel, ProjectModel, QDistinct> {
  QueryBuilder<ProjectModel, ProjectModel, QDistinct> distinctByBomSpecsJson({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bomSpecsJson', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QDistinct> distinctByCapacity() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'capacityMw');
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QDistinct> distinctByCapacityUnit({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'capacityUnit', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QDistinct> distinctByClient({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'client', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QDistinct> distinctByDescription({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'description', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QDistinct> distinctByEndDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'endDate');
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QDistinct> distinctByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isSynced');
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QDistinct> distinctByLocation({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'location', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QDistinct> distinctByName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QDistinct> distinctByProgress() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'progress');
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QDistinct> distinctByStage({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'stage', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QDistinct> distinctByStartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'startDate');
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QDistinct> distinctByStatus({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QDistinct> distinctBySupervisor({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'supervisor', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QDistinct> distinctBySystemType({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'systemType', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QDistinct>
  distinctByTeamMembersJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'teamMembersJson',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QDistinct> distinctByTotalCost() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalCost');
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QDistinct> distinctByType({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'type', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QDistinct> distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QDistinct> distinctByUuid({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'uuid', caseSensitive: caseSensitive);
    });
  }
}

extension ProjectModelQueryProperty
    on QueryBuilder<ProjectModel, ProjectModel, QQueryProperty> {
  QueryBuilder<ProjectModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ProjectModel, String?, QQueryOperations> bomSpecsJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bomSpecsJson');
    });
  }

  QueryBuilder<ProjectModel, double, QQueryOperations> capacityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'capacityMw');
    });
  }

  QueryBuilder<ProjectModel, String?, QQueryOperations> capacityUnitProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'capacityUnit');
    });
  }

  QueryBuilder<ProjectModel, String?, QQueryOperations> clientProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'client');
    });
  }

  QueryBuilder<ProjectModel, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<ProjectModel, String?, QQueryOperations> descriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'description');
    });
  }

  QueryBuilder<ProjectModel, DateTime, QQueryOperations> endDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'endDate');
    });
  }

  QueryBuilder<ProjectModel, bool, QQueryOperations> isSyncedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isSynced');
    });
  }

  QueryBuilder<ProjectModel, String, QQueryOperations> locationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'location');
    });
  }

  QueryBuilder<ProjectModel, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<ProjectModel, double, QQueryOperations> progressProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'progress');
    });
  }

  QueryBuilder<ProjectModel, String?, QQueryOperations> stageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'stage');
    });
  }

  QueryBuilder<ProjectModel, DateTime, QQueryOperations> startDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'startDate');
    });
  }

  QueryBuilder<ProjectModel, String, QQueryOperations> statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }

  QueryBuilder<ProjectModel, String?, QQueryOperations> supervisorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'supervisor');
    });
  }

  QueryBuilder<ProjectModel, String?, QQueryOperations> systemTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'systemType');
    });
  }

  QueryBuilder<ProjectModel, String?, QQueryOperations>
  teamMembersJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'teamMembersJson');
    });
  }

  QueryBuilder<ProjectModel, double, QQueryOperations> totalCostProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalCost');
    });
  }

  QueryBuilder<ProjectModel, String, QQueryOperations> typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'type');
    });
  }

  QueryBuilder<ProjectModel, DateTime, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }

  QueryBuilder<ProjectModel, String, QQueryOperations> uuidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'uuid');
    });
  }
}
