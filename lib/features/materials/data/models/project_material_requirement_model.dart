import 'package:isar_community/isar.dart';

part 'project_material_requirement_model.g.dart';

@collection
class ProjectMaterialRequirementModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String uuid;

  @Index()
  late String projectUuid;

  @Index()
  late String materialUuid;

  late double requiredQuantity;
  late double allocatedQuantity;
  late String unit;
  String status = 'Pending';
  String? customName;
  late DateTime createdAt;
  late DateTime updatedAt;
  late bool isSynced;
}
