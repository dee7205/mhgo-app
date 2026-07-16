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

class ProjectMaterialRequirementEntity {
  final String uuid;
  final String projectUuid;
  final String materialUuid;
  final double requiredQuantity;
  final double allocatedQuantity;
  final String unit;

  ProjectMaterialRequirementEntity({
    required this.uuid,
    required this.projectUuid,
    required this.materialUuid,
    required this.requiredQuantity,
    required this.allocatedQuantity,
    required this.unit,
  });
}
