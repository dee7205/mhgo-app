import 'materials_entities.dart';

abstract class MaterialsRepository {
  // Materials
  Future<List<MaterialEntity>> getMaterials();
  Future<MaterialEntity?> getMaterialById(String uuid);
  Future<void> saveMaterial(MaterialEntity material);
  Future<void> deleteMaterial(String uuid);

  // Requests
  Future<List<MaterialRequestEntity>> getRequests();
  Future<List<MaterialRequestEntity>> getRequestsForProject(String projectUuid);
  Future<void> saveRequest(MaterialRequestEntity request);
  Future<void> deleteRequest(String uuid);

  // Deliveries
  Future<List<DeliveryEntity>> getDeliveries();
  Future<void> recordDelivery(DeliveryEntity delivery);
}
