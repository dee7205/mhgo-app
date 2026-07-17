import 'dart:convert';
import 'package:isar_community/isar.dart';
import '../../domain/entities/materials_entities.dart';
import '../../domain/repositories/materials_repository.dart';
import '../models/material_model.dart';
import '../models/project_material_requirement_model.dart';

class MaterialsRepositoryImpl implements MaterialsRepository {
  final Isar isar;

  MaterialsRepositoryImpl(this.isar);

  @override
  Future<List<MaterialEntity>> getMaterials() async {
    final models = await isar.materialModels.where().findAll();
    final entities = <MaterialEntity>[];
    for (final model in models) {
      final allocated = await _computeAllocatedStock(model.uuid);
      entities.add(_mapMaterialToEntity(model, allocated));
    }
    return entities;
  }

  @override
  Future<MaterialEntity?> getMaterialById(String uuid) async {
    final model = await isar.materialModels
        .filter()
        .uuidEqualTo(uuid)
        .findFirst();
    if (model == null) return null;
    final allocated = await _computeAllocatedStock(uuid);
    return _mapMaterialToEntity(model, allocated);
  }

  Future<double> _computeAllocatedStock(String materialUuid) async {
    final requirements = await isar.projectMaterialRequirementModels
        .filter()
        .materialUuidEqualTo(materialUuid)
        .findAll();
    return requirements.fold<double>(0.0, (sum, req) => sum + req.allocatedQuantity);
  }

  @override
  Future<void> saveMaterial(MaterialEntity material) async {
    final model = _mapMaterialToModel(material);
    final existing = await isar.materialModels
        .filter()
        .uuidEqualTo(material.uuid)
        .findFirst();
    if (existing != null) {
      model.id = existing.id;
    }
    await isar.writeTxn(() async {
      await isar.materialModels.put(model);
    });
  }

  @override
  Future<void> deleteMaterial(String uuid) async {
    final existing = await isar.materialModels
        .filter()
        .uuidEqualTo(uuid)
        .findFirst();
    if (existing != null) {
      await isar.writeTxn(() async {
        await isar.materialModels.delete(existing.id);
        
        // Cascading delete requirements linked to this material
        final requirements = await isar.projectMaterialRequirementModels
            .filter()
            .materialUuidEqualTo(uuid)
            .findAll();
        for (final req in requirements) {
          await isar.projectMaterialRequirementModels.delete(req.id);
        }
      });
    }
  }

  @override
  Future<List<ProjectMaterialRequirementEntity>> getRequirementsForProject(
    String projectUuid,
  ) async {
    final models = await isar.projectMaterialRequirementModels
        .filter()
        .projectUuidEqualTo(projectUuid)
        .findAll();
    return models.map(_mapReqToEntity).toList();
  }

  @override
  Future<List<ProjectMaterialRequirementEntity>> getRequirementsForMaterial(
    String materialUuid,
  ) async {
    final models = await isar.projectMaterialRequirementModels
        .filter()
        .materialUuidEqualTo(materialUuid)
        .findAll();
    return models.map(_mapReqToEntity).toList();
  }

  @override
  Future<void> saveRequirement(ProjectMaterialRequirementEntity req) async {
    final model = _mapReqToModel(req);
    final existing = await isar.projectMaterialRequirementModels
        .filter()
        .uuidEqualTo(req.uuid)
        .findFirst();
    if (existing != null) {
      model.id = existing.id;
    }
    await isar.writeTxn(() async {
      await isar.projectMaterialRequirementModels.put(model);
    });
  }

  @override
  Future<void> deleteRequirement(String uuid) async {
    final existing = await isar.projectMaterialRequirementModels
        .filter()
        .uuidEqualTo(uuid)
        .findFirst();
    if (existing != null) {
      await isar.writeTxn(() async {
        await isar.projectMaterialRequirementModels.delete(existing.id);
      });
    }
  }

  @override
  Future<void> forceResetAllRequirementsToZero() async {
    final requirements = await isar.projectMaterialRequirementModels.where().findAll();
    await isar.writeTxn(() async {
      for (var req in requirements) {
        req.requiredQuantity = 0.0;
        req.allocatedQuantity = 0.0;
        req.estimatedCost = 0.0;
        await isar.projectMaterialRequirementModels.put(req);
      }
    });
  }

  MaterialEntity _mapMaterialToEntity(MaterialModel m, double allocated) {
    return MaterialEntity(
      uuid: m.uuid,
      name: m.name,
      category: m.category,
      unit: m.unit,
      currentStock: m.currentStock,
      minimumStock: m.minimumStock,
      allocatedStock: allocated,
      availableStock: m.currentStock - allocated,
      supplier: m.supplier,
      storageLocation: m.storageLocation,
      remarks: m.remarks,
      stockStatus: m.stockStatus,
    );
  }

  MaterialModel _mapMaterialToModel(MaterialEntity e) {
    return MaterialModel()
      ..uuid = e.uuid
      ..name = e.name
      ..category = e.category
      ..unit = e.unit
      ..currentStock = e.currentStock
      ..minimumStock = e.minimumStock
      ..supplier = e.supplier
      ..storageLocation = e.storageLocation
      ..remarks = e.remarks
      ..createdAt = DateTime.now()
      ..updatedAt = DateTime.now()
      ..isSynced = false;
  }

  ProjectMaterialRequirementEntity _mapReqToEntity(ProjectMaterialRequirementModel m) {
    return ProjectMaterialRequirementEntity(
      uuid: m.uuid,
      projectUuid: m.projectUuid,
      materialUuid: m.materialUuid,
      requiredQuantity: m.requiredQuantity,
      allocatedQuantity: m.allocatedQuantity,
      unit: m.unit,
      estimatedCost: m.estimatedCost,
    );
  }

  ProjectMaterialRequirementModel _mapReqToModel(ProjectMaterialRequirementEntity e) {
    return ProjectMaterialRequirementModel()
      ..uuid = e.uuid
      ..projectUuid = e.projectUuid
      ..materialUuid = e.materialUuid
      ..requiredQuantity = e.requiredQuantity
      ..allocatedQuantity = e.allocatedQuantity
      ..unit = e.unit
      ..estimatedCost = e.estimatedCost
      ..createdAt = DateTime.now()
      ..updatedAt = DateTime.now()
      ..isSynced = false;
  }
}
