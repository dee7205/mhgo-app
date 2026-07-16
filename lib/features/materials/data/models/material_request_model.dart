import 'package:isar_community/isar.dart';

part 'material_request_model.g.dart';

@collection
class MaterialRequestModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String uuid;

  @Index()
  late String projectUuid;

  late String materialUuid;
  late String projectName;
  late String materialName;

  late double quantity;
  late String unit;
  late String requestedBy;
  late DateTime date;

  late String status; // Pending, Approved, Fulfilled, Rejected
  String? remarks;

  late DateTime createdAt;
  late DateTime updatedAt;
  late bool isSynced;
}
