class MaterialEntity {
  final String uuid;
  final String name;
  final String category;
  final String unit;
  final double currentStock;
  final double minimumStock;
  final String? supplier;
  final String? storageLocation;
  final String? remarks;
  final String stockStatus;

  MaterialEntity({
    required this.uuid,
    required this.name,
    required this.category,
    required this.unit,
    required this.currentStock,
    required this.minimumStock,
    this.supplier,
    this.storageLocation,
    this.remarks,
    required this.stockStatus,
  });
}

class MaterialRequestEntity {
  final String uuid;
  final String projectUuid;
  final String materialUuid;
  final String projectName;
  final String materialName;
  final double quantity;
  final String unit;
  final String requestedBy;
  final DateTime date;
  final String status;
  final String? remarks;

  MaterialRequestEntity({
    required this.uuid,
    required this.projectUuid,
    required this.materialUuid,
    required this.projectName,
    required this.materialName,
    required this.quantity,
    required this.unit,
    required this.requestedBy,
    required this.date,
    required this.status,
    this.remarks,
  });
}

class DeliveryEntity {
  final String uuid;
  final String projectUuid;
  final String projectName;
  final String supplier;
  final DateTime deliveryDate;
  final String status;
  final List<String> deliveredMaterialsJson;

  DeliveryEntity({
    required this.uuid,
    required this.projectUuid,
    required this.projectName,
    required this.supplier,
    required this.deliveryDate,
    required this.status,
    required this.deliveredMaterialsJson,
  });
}
