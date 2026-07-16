import 'package:isar_community/isar.dart';

part 'material_model.g.dart';

@collection
class MaterialModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String uuid;

  late String name;
  late String category;
  late String unit;

  late double currentStock;
  late double minimumStock;

  String? supplier;
  String? storageLocation;
  String? remarks;

  late DateTime createdAt;
  late DateTime updatedAt;
  late bool isSynced;

  String get stockStatus {
    if (currentStock <= 0) return 'Out of Stock';
    if (currentStock <= minimumStock) return 'Low Stock';
    return 'In Stock';
  }
}
