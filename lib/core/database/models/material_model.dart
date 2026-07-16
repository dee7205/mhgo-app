import 'package:isar_community/isar.dart';

part 'material_model.g.dart';

@collection
class MaterialModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String uuid;

  late String name;
  
  @Index(unique: true)
  late String sku;

  late String category; // 'Solar Modules' | 'Inverters' | 'Mounting Structures' | 'DC/AC Cabling' | 'Transformers' | 'BOS'
  late double quantityInStock;
  late double quantityReserved; // Allocated to active projects
  late String unit; // 'pcs' | 'meters' | 'sets' | 'rolls'
  
  late double reorderPoint; // Minimum threshold
  late String warehouseLocation; // e.g. 'Warehouse A - Bay 3'

  late DateTime createdAt;
  late DateTime updatedAt;

  late bool isSynced;
}
