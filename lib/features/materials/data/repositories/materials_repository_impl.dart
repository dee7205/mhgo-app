import 'dart:convert';
import 'package:isar_community/isar.dart';
import '../../domain/entities/materials_entities.dart';
import '../../domain/repositories/materials_repository.dart';
import '../models/material_model.dart';
import '../models/material_request_model.dart';
import '../models/delivery_model.dart';

class MaterialsRepositoryImpl implements MaterialsRepository {
  final Isar isar;

  MaterialsRepositoryImpl(this.isar);

  @override
  Future<List<MaterialEntity>> getMaterials() async {
    final models = await isar.materialModels.where().findAll();
    return models.map(_mapMaterialToEntity).toList();
  }

  @override
  Future<MaterialEntity?> getMaterialById(String uuid) async {
    final model = await isar.materialModels
        .filter()
        .uuidEqualTo(uuid)
        .findFirst();
    return model != null ? _mapMaterialToEntity(model) : null;
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
      });
    }
  }

  @override
  Future<List<MaterialRequestEntity>> getRequests() async {
    final models = await isar.materialRequestModels.where().findAll();
    return models.map(_mapRequestToEntity).toList();
  }

  @override
  Future<List<MaterialRequestEntity>> getRequestsForProject(
    String projectUuid,
  ) async {
    final models = await isar.materialRequestModels
        .filter()
        .projectUuidEqualTo(projectUuid)
        .findAll();
    return models.map(_mapRequestToEntity).toList();
  }

  @override
  Future<void> saveRequest(MaterialRequestEntity request) async {
    final model = _mapRequestToModel(request);
    final existing = await isar.materialRequestModels
        .filter()
        .uuidEqualTo(request.uuid)
        .findFirst();
    if (existing != null) {
      model.id = existing.id;
    }
    await isar.writeTxn(() async {
      await isar.materialRequestModels.put(model);
    });
  }

  @override
  Future<void> deleteRequest(String uuid) async {
    final existing = await isar.materialRequestModels
        .filter()
        .uuidEqualTo(uuid)
        .findFirst();
    if (existing != null) {
      await isar.writeTxn(() async {
        await isar.materialRequestModels.delete(existing.id);
      });
    }
  }

  @override
  Future<List<DeliveryEntity>> getDeliveries() async {
    final models = await isar.deliveryModels.where().findAll();
    return models.map(_mapDeliveryToEntity).toList();
  }

  @override
  Future<void> recordDelivery(DeliveryEntity delivery) async {
    final model = _mapDeliveryToModel(delivery);
    final existing = await isar.deliveryModels
        .filter()
        .uuidEqualTo(delivery.uuid)
        .findFirst();
    if (existing != null) {
      model.id = existing.id;
    }

    await isar.writeTxn(() async {
      // 1. Save delivery record
      await isar.deliveryModels.put(model);

      // 2. Increment stock for all delivered materials
      // deliveredMaterialsJson contains a list of JSON objects as strings, e.g. '{"materialUuid": "...", "quantity": 10.0}'
      for (final jsonStr in delivery.deliveredMaterialsJson) {
        try {
          final data = jsonDecode(jsonStr) as Map<String, dynamic>;
          final mUuid = data['materialUuid'] as String?;
          final qty = (data['quantity'] as num?)?.toDouble() ?? 0.0;

          if (mUuid != null && qty > 0) {
            final material = await isar.materialModels
                .filter()
                .uuidEqualTo(mUuid)
                .findFirst();
            if (material != null) {
              material.currentStock += qty;
              material.updatedAt = DateTime.now();
              await isar.materialModels.put(material);
            }
          }
        } catch (e) {
          // Skip invalid data
        }
      }
    });
  }

  MaterialEntity _mapMaterialToEntity(MaterialModel m) {
    return MaterialEntity(
      uuid: m.uuid,
      name: m.name,
      category: m.category,
      unit: m.unit,
      currentStock: m.currentStock,
      minimumStock: m.minimumStock,
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

  MaterialRequestEntity _mapRequestToEntity(MaterialRequestModel m) {
    return MaterialRequestEntity(
      uuid: m.uuid,
      projectUuid: m.projectUuid,
      materialUuid: m.materialUuid,
      projectName: m.projectName,
      materialName: m.materialName,
      quantity: m.quantity,
      unit: m.unit,
      requestedBy: m.requestedBy,
      date: m.date,
      status: m.status,
      remarks: m.remarks,
    );
  }

  MaterialRequestModel _mapRequestToModel(MaterialRequestEntity e) {
    return MaterialRequestModel()
      ..uuid = e.uuid
      ..projectUuid = e.projectUuid
      ..materialUuid = e.materialUuid
      ..projectName = e.projectName
      ..materialName = e.materialName
      ..quantity = e.quantity
      ..unit = e.unit
      ..requestedBy = e.requestedBy
      ..date = e.date
      ..status = e.status
      ..remarks = e.remarks
      ..createdAt = DateTime.now()
      ..updatedAt = DateTime.now()
      ..isSynced = false;
  }

  DeliveryEntity _mapDeliveryToEntity(DeliveryModel m) {
    return DeliveryEntity(
      uuid: m.uuid,
      projectUuid: m.projectUuid,
      projectName: m.projectName,
      supplier: m.supplier,
      deliveryDate: m.deliveryDate,
      status: m.status,
      deliveredMaterialsJson: m.deliveredMaterialsJson,
    );
  }

  DeliveryModel _mapDeliveryToModel(DeliveryEntity e) {
    return DeliveryModel()
      ..uuid = e.uuid
      ..projectUuid = e.projectUuid
      ..projectName = e.projectName
      ..supplier = e.supplier
      ..deliveryDate = e.deliveryDate
      ..status = e.status
      ..deliveredMaterialsJson = e.deliveredMaterialsJson
      ..createdAt = DateTime.now()
      ..updatedAt = DateTime.now()
      ..isSynced = false;
  }
}
