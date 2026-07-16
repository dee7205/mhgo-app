import '../entities/materials_entities.dart';

abstract class MaterialsRepository {
  // Materials
  Future<List<MaterialEntity>> getMaterials();
  Future<MaterialEntity?> getMaterialById(String uuid);
  Future<void> saveMaterial(MaterialEntity material);
  Future<void> deleteMaterial(String uuid);

  // Requests
  Future<List<ProjectMaterialRequirementEntity>> getRequirementsForProject(String projectUuid);
  Future<List<ProjectMaterialRequirementEntity>> getRequirementsForMaterial(String materialUuid);
  Future<void> saveRequirement(ProjectMaterialRequirementEntity requirement);
  Future<void> deleteRequirement(String uuid);
}
