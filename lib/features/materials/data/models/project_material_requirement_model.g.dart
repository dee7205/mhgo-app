// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_material_requirement_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetProjectMaterialRequirementModelCollection on Isar {
  IsarCollection<ProjectMaterialRequirementModel>
  get projectMaterialRequirementModels => this.collection();
}

const ProjectMaterialRequirementModelSchema = CollectionSchema(
  name: r'ProjectMaterialRequirementModel',
  id: 6181632900347964534,
  properties: {
    r'allocatedQuantity': PropertySchema(
      id: 0,
      name: r'allocatedQuantity',
      type: IsarType.double,
    ),
    r'createdAt': PropertySchema(
      id: 1,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'estimatedCost': PropertySchema(
      id: 2,
      name: r'estimatedCost',
      type: IsarType.double,
    ),
    r'isSynced': PropertySchema(id: 3, name: r'isSynced', type: IsarType.bool),
    r'materialUuid': PropertySchema(
      id: 4,
      name: r'materialUuid',
      type: IsarType.string,
    ),
    r'projectUuid': PropertySchema(
      id: 5,
      name: r'projectUuid',
      type: IsarType.string,
    ),
    r'requiredQuantity': PropertySchema(
      id: 6,
      name: r'requiredQuantity',
      type: IsarType.double,
    ),
    r'unit': PropertySchema(id: 7, name: r'unit', type: IsarType.string),
    r'updatedAt': PropertySchema(
      id: 8,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
    r'uuid': PropertySchema(id: 9, name: r'uuid', type: IsarType.string),
  },

  estimateSize: _projectMaterialRequirementModelEstimateSize,
  serialize: _projectMaterialRequirementModelSerialize,
  deserialize: _projectMaterialRequirementModelDeserialize,
  deserializeProp: _projectMaterialRequirementModelDeserializeProp,
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
    r'materialUuid': IndexSchema(
      id: 1555030430418766309,
      name: r'materialUuid',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'materialUuid',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _projectMaterialRequirementModelGetId,
  getLinks: _projectMaterialRequirementModelGetLinks,
  attach: _projectMaterialRequirementModelAttach,
  version: '3.3.2',
);

int _projectMaterialRequirementModelEstimateSize(
  ProjectMaterialRequirementModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.materialUuid.length * 3;
  bytesCount += 3 + object.projectUuid.length * 3;
  bytesCount += 3 + object.unit.length * 3;
  bytesCount += 3 + object.uuid.length * 3;
  return bytesCount;
}

void _projectMaterialRequirementModelSerialize(
  ProjectMaterialRequirementModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.allocatedQuantity);
  writer.writeDateTime(offsets[1], object.createdAt);
  writer.writeDouble(offsets[2], object.estimatedCost);
  writer.writeBool(offsets[3], object.isSynced);
  writer.writeString(offsets[4], object.materialUuid);
  writer.writeString(offsets[5], object.projectUuid);
  writer.writeDouble(offsets[6], object.requiredQuantity);
  writer.writeString(offsets[7], object.unit);
  writer.writeDateTime(offsets[8], object.updatedAt);
  writer.writeString(offsets[9], object.uuid);
}

ProjectMaterialRequirementModel _projectMaterialRequirementModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ProjectMaterialRequirementModel();
  object.allocatedQuantity = reader.readDouble(offsets[0]);
  object.createdAt = reader.readDateTime(offsets[1]);
  object.estimatedCost = reader.readDoubleOrNull(offsets[2]);
  object.id = id;
  object.isSynced = reader.readBool(offsets[3]);
  object.materialUuid = reader.readString(offsets[4]);
  object.projectUuid = reader.readString(offsets[5]);
  object.requiredQuantity = reader.readDouble(offsets[6]);
  object.unit = reader.readString(offsets[7]);
  object.updatedAt = reader.readDateTime(offsets[8]);
  object.uuid = reader.readString(offsets[9]);
  return object;
}

P _projectMaterialRequirementModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDouble(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readDoubleOrNull(offset)) as P;
    case 3:
      return (reader.readBool(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readDouble(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readDateTime(offset)) as P;
    case 9:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _projectMaterialRequirementModelGetId(
  ProjectMaterialRequirementModel object,
) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _projectMaterialRequirementModelGetLinks(
  ProjectMaterialRequirementModel object,
) {
  return [];
}

void _projectMaterialRequirementModelAttach(
  IsarCollection<dynamic> col,
  Id id,
  ProjectMaterialRequirementModel object,
) {
  object.id = id;
}

extension ProjectMaterialRequirementModelByIndex
    on IsarCollection<ProjectMaterialRequirementModel> {
  Future<ProjectMaterialRequirementModel?> getByUuid(String uuid) {
    return getByIndex(r'uuid', [uuid]);
  }

  ProjectMaterialRequirementModel? getByUuidSync(String uuid) {
    return getByIndexSync(r'uuid', [uuid]);
  }

  Future<bool> deleteByUuid(String uuid) {
    return deleteByIndex(r'uuid', [uuid]);
  }

  bool deleteByUuidSync(String uuid) {
    return deleteByIndexSync(r'uuid', [uuid]);
  }

  Future<List<ProjectMaterialRequirementModel?>> getAllByUuid(
    List<String> uuidValues,
  ) {
    final values = uuidValues.map((e) => [e]).toList();
    return getAllByIndex(r'uuid', values);
  }

  List<ProjectMaterialRequirementModel?> getAllByUuidSync(
    List<String> uuidValues,
  ) {
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

  Future<Id> putByUuid(ProjectMaterialRequirementModel object) {
    return putByIndex(r'uuid', object);
  }

  Id putByUuidSync(
    ProjectMaterialRequirementModel object, {
    bool saveLinks = true,
  }) {
    return putByIndexSync(r'uuid', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByUuid(List<ProjectMaterialRequirementModel> objects) {
    return putAllByIndex(r'uuid', objects);
  }

  List<Id> putAllByUuidSync(
    List<ProjectMaterialRequirementModel> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(r'uuid', objects, saveLinks: saveLinks);
  }
}

extension ProjectMaterialRequirementModelQueryWhereSort
    on
        QueryBuilder<
          ProjectMaterialRequirementModel,
          ProjectMaterialRequirementModel,
          QWhere
        > {
  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterWhere
  >
  anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ProjectMaterialRequirementModelQueryWhere
    on
        QueryBuilder<
          ProjectMaterialRequirementModel,
          ProjectMaterialRequirementModel,
          QWhereClause
        > {
  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterWhereClause
  >
  idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterWhereClause
  >
  idNotEqualTo(Id id) {
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

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterWhereClause
  >
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterWhereClause
  >
  idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterWhereClause
  >
  idBetween(
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

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterWhereClause
  >
  uuidEqualTo(String uuid) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'uuid', value: [uuid]),
      );
    });
  }

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterWhereClause
  >
  uuidNotEqualTo(String uuid) {
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

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterWhereClause
  >
  projectUuidEqualTo(String projectUuid) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(
          indexName: r'projectUuid',
          value: [projectUuid],
        ),
      );
    });
  }

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterWhereClause
  >
  projectUuidNotEqualTo(String projectUuid) {
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

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterWhereClause
  >
  materialUuidEqualTo(String materialUuid) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(
          indexName: r'materialUuid',
          value: [materialUuid],
        ),
      );
    });
  }

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterWhereClause
  >
  materialUuidNotEqualTo(String materialUuid) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'materialUuid',
                lower: [],
                upper: [materialUuid],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'materialUuid',
                lower: [materialUuid],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'materialUuid',
                lower: [materialUuid],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'materialUuid',
                lower: [],
                upper: [materialUuid],
                includeUpper: false,
              ),
            );
      }
    });
  }
}

extension ProjectMaterialRequirementModelQueryFilter
    on
        QueryBuilder<
          ProjectMaterialRequirementModel,
          ProjectMaterialRequirementModel,
          QFilterCondition
        > {
  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterFilterCondition
  >
  allocatedQuantityEqualTo(double value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'allocatedQuantity',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterFilterCondition
  >
  allocatedQuantityGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'allocatedQuantity',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterFilterCondition
  >
  allocatedQuantityLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'allocatedQuantity',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterFilterCondition
  >
  allocatedQuantityBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'allocatedQuantity',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterFilterCondition
  >
  createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'createdAt', value: value),
      );
    });
  }

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterFilterCondition
  >
  estimatedCostIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'estimatedCost'),
      );
    });
  }

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterFilterCondition
  >
  estimatedCostIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'estimatedCost'),
      );
    });
  }

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterFilterCondition
  >
  estimatedCostEqualTo(double? value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'estimatedCost',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterFilterCondition
  >
  estimatedCostGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'estimatedCost',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterFilterCondition
  >
  estimatedCostLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'estimatedCost',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterFilterCondition
  >
  estimatedCostBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'estimatedCost',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterFilterCondition
  >
  idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterFilterCondition
  >
  idGreaterThan(Id value, {bool include = false}) {
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

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterFilterCondition
  >
  idLessThan(Id value, {bool include = false}) {
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

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterFilterCondition
  >
  idBetween(
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

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterFilterCondition
  >
  isSyncedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isSynced', value: value),
      );
    });
  }

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterFilterCondition
  >
  materialUuidEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'materialUuid',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterFilterCondition
  >
  materialUuidGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'materialUuid',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterFilterCondition
  >
  materialUuidLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'materialUuid',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterFilterCondition
  >
  materialUuidBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'materialUuid',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterFilterCondition
  >
  materialUuidStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'materialUuid',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterFilterCondition
  >
  materialUuidEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'materialUuid',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterFilterCondition
  >
  materialUuidContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'materialUuid',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterFilterCondition
  >
  materialUuidMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'materialUuid',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterFilterCondition
  >
  materialUuidIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'materialUuid', value: ''),
      );
    });
  }

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterFilterCondition
  >
  materialUuidIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'materialUuid', value: ''),
      );
    });
  }

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterFilterCondition
  >
  projectUuidEqualTo(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterFilterCondition
  >
  projectUuidLessThan(
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

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterFilterCondition
  >
  projectUuidBetween(
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

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterFilterCondition
  >
  projectUuidStartsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterFilterCondition
  >
  projectUuidEndsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterFilterCondition
  >
  projectUuidContains(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterFilterCondition
  >
  projectUuidMatches(String pattern, {bool caseSensitive = true}) {
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

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterFilterCondition
  >
  projectUuidIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'projectUuid', value: ''),
      );
    });
  }

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterFilterCondition
  >
  projectUuidIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'projectUuid', value: ''),
      );
    });
  }

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterFilterCondition
  >
  requiredQuantityEqualTo(double value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'requiredQuantity',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterFilterCondition
  >
  requiredQuantityGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'requiredQuantity',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterFilterCondition
  >
  requiredQuantityLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'requiredQuantity',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterFilterCondition
  >
  requiredQuantityBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'requiredQuantity',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterFilterCondition
  >
  unitEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'unit',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterFilterCondition
  >
  unitGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'unit',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterFilterCondition
  >
  unitLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'unit',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterFilterCondition
  >
  unitBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'unit',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterFilterCondition
  >
  unitStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'unit',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterFilterCondition
  >
  unitEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'unit',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterFilterCondition
  >
  unitContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'unit',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterFilterCondition
  >
  unitMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'unit',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterFilterCondition
  >
  unitIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'unit', value: ''),
      );
    });
  }

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterFilterCondition
  >
  unitIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'unit', value: ''),
      );
    });
  }

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterFilterCondition
  >
  updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'updatedAt', value: value),
      );
    });
  }

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterFilterCondition
  >
  uuidEqualTo(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterFilterCondition
  >
  uuidLessThan(
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

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterFilterCondition
  >
  uuidBetween(
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

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterFilterCondition
  >
  uuidEndsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterFilterCondition
  >
  uuidContains(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterFilterCondition
  >
  uuidMatches(String pattern, {bool caseSensitive = true}) {
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

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterFilterCondition
  >
  uuidIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'uuid', value: ''),
      );
    });
  }

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterFilterCondition
  >
  uuidIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'uuid', value: ''),
      );
    });
  }
}

extension ProjectMaterialRequirementModelQueryObject
    on
        QueryBuilder<
          ProjectMaterialRequirementModel,
          ProjectMaterialRequirementModel,
          QFilterCondition
        > {}

extension ProjectMaterialRequirementModelQueryLinks
    on
        QueryBuilder<
          ProjectMaterialRequirementModel,
          ProjectMaterialRequirementModel,
          QFilterCondition
        > {}

extension ProjectMaterialRequirementModelQuerySortBy
    on
        QueryBuilder<
          ProjectMaterialRequirementModel,
          ProjectMaterialRequirementModel,
          QSortBy
        > {
  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterSortBy
  >
  sortByAllocatedQuantity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'allocatedQuantity', Sort.asc);
    });
  }

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterSortBy
  >
  sortByAllocatedQuantityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'allocatedQuantity', Sort.desc);
    });
  }

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterSortBy
  >
  sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterSortBy
  >
  sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterSortBy
  >
  sortByEstimatedCost() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'estimatedCost', Sort.asc);
    });
  }

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterSortBy
  >
  sortByEstimatedCostDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'estimatedCost', Sort.desc);
    });
  }

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterSortBy
  >
  sortByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.asc);
    });
  }

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterSortBy
  >
  sortByIsSyncedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.desc);
    });
  }

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterSortBy
  >
  sortByMaterialUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'materialUuid', Sort.asc);
    });
  }

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterSortBy
  >
  sortByMaterialUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'materialUuid', Sort.desc);
    });
  }

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterSortBy
  >
  sortByProjectUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'projectUuid', Sort.asc);
    });
  }

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterSortBy
  >
  sortByProjectUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'projectUuid', Sort.desc);
    });
  }

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterSortBy
  >
  sortByRequiredQuantity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'requiredQuantity', Sort.asc);
    });
  }

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterSortBy
  >
  sortByRequiredQuantityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'requiredQuantity', Sort.desc);
    });
  }

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterSortBy
  >
  sortByUnit() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unit', Sort.asc);
    });
  }

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterSortBy
  >
  sortByUnitDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unit', Sort.desc);
    });
  }

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterSortBy
  >
  sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterSortBy
  >
  sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterSortBy
  >
  sortByUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.asc);
    });
  }

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterSortBy
  >
  sortByUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.desc);
    });
  }
}

extension ProjectMaterialRequirementModelQuerySortThenBy
    on
        QueryBuilder<
          ProjectMaterialRequirementModel,
          ProjectMaterialRequirementModel,
          QSortThenBy
        > {
  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterSortBy
  >
  thenByAllocatedQuantity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'allocatedQuantity', Sort.asc);
    });
  }

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterSortBy
  >
  thenByAllocatedQuantityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'allocatedQuantity', Sort.desc);
    });
  }

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterSortBy
  >
  thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterSortBy
  >
  thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterSortBy
  >
  thenByEstimatedCost() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'estimatedCost', Sort.asc);
    });
  }

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterSortBy
  >
  thenByEstimatedCostDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'estimatedCost', Sort.desc);
    });
  }

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterSortBy
  >
  thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterSortBy
  >
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterSortBy
  >
  thenByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.asc);
    });
  }

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterSortBy
  >
  thenByIsSyncedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.desc);
    });
  }

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterSortBy
  >
  thenByMaterialUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'materialUuid', Sort.asc);
    });
  }

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterSortBy
  >
  thenByMaterialUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'materialUuid', Sort.desc);
    });
  }

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterSortBy
  >
  thenByProjectUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'projectUuid', Sort.asc);
    });
  }

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterSortBy
  >
  thenByProjectUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'projectUuid', Sort.desc);
    });
  }

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterSortBy
  >
  thenByRequiredQuantity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'requiredQuantity', Sort.asc);
    });
  }

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterSortBy
  >
  thenByRequiredQuantityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'requiredQuantity', Sort.desc);
    });
  }

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterSortBy
  >
  thenByUnit() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unit', Sort.asc);
    });
  }

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterSortBy
  >
  thenByUnitDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unit', Sort.desc);
    });
  }

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterSortBy
  >
  thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterSortBy
  >
  thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterSortBy
  >
  thenByUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.asc);
    });
  }

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QAfterSortBy
  >
  thenByUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.desc);
    });
  }
}

extension ProjectMaterialRequirementModelQueryWhereDistinct
    on
        QueryBuilder<
          ProjectMaterialRequirementModel,
          ProjectMaterialRequirementModel,
          QDistinct
        > {
  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QDistinct
  >
  distinctByAllocatedQuantity() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'allocatedQuantity');
    });
  }

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QDistinct
  >
  distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QDistinct
  >
  distinctByEstimatedCost() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'estimatedCost');
    });
  }

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QDistinct
  >
  distinctByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isSynced');
    });
  }

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QDistinct
  >
  distinctByMaterialUuid({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'materialUuid', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QDistinct
  >
  distinctByProjectUuid({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'projectUuid', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QDistinct
  >
  distinctByRequiredQuantity() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'requiredQuantity');
    });
  }

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QDistinct
  >
  distinctByUnit({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'unit', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QDistinct
  >
  distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }

  QueryBuilder<
    ProjectMaterialRequirementModel,
    ProjectMaterialRequirementModel,
    QDistinct
  >
  distinctByUuid({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'uuid', caseSensitive: caseSensitive);
    });
  }
}

extension ProjectMaterialRequirementModelQueryProperty
    on
        QueryBuilder<
          ProjectMaterialRequirementModel,
          ProjectMaterialRequirementModel,
          QQueryProperty
        > {
  QueryBuilder<ProjectMaterialRequirementModel, int, QQueryOperations>
  idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ProjectMaterialRequirementModel, double, QQueryOperations>
  allocatedQuantityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'allocatedQuantity');
    });
  }

  QueryBuilder<ProjectMaterialRequirementModel, DateTime, QQueryOperations>
  createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<ProjectMaterialRequirementModel, double?, QQueryOperations>
  estimatedCostProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'estimatedCost');
    });
  }

  QueryBuilder<ProjectMaterialRequirementModel, bool, QQueryOperations>
  isSyncedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isSynced');
    });
  }

  QueryBuilder<ProjectMaterialRequirementModel, String, QQueryOperations>
  materialUuidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'materialUuid');
    });
  }

  QueryBuilder<ProjectMaterialRequirementModel, String, QQueryOperations>
  projectUuidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'projectUuid');
    });
  }

  QueryBuilder<ProjectMaterialRequirementModel, double, QQueryOperations>
  requiredQuantityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'requiredQuantity');
    });
  }

  QueryBuilder<ProjectMaterialRequirementModel, String, QQueryOperations>
  unitProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'unit');
    });
  }

  QueryBuilder<ProjectMaterialRequirementModel, DateTime, QQueryOperations>
  updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }

  QueryBuilder<ProjectMaterialRequirementModel, String, QQueryOperations>
  uuidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'uuid');
    });
  }
}
