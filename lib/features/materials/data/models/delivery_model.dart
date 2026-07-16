import 'package:isar_community/isar.dart';

part 'delivery_model.g.dart';

@collection
class DeliveryModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String uuid;

  @Index()
  late String projectUuid;

  late String projectName;
  late String supplier;
  late DateTime deliveryDate;
  late String status;

  // Since Isar doesn't easily store complex lists of custom objects without embedded objects,
  // we use a JSON list or a list of strings as requested: deliveredMaterialsJson (List<String>)
  late List<String> deliveredMaterialsJson;

  late DateTime createdAt;
  late DateTime updatedAt;
  late bool isSynced;
}
