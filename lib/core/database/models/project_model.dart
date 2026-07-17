import 'package:isar_community/isar.dart';

part 'project_model.g.dart';

@collection
class ProjectModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String uuid;

  late String name;
  String? description;
  late double capacityMw;
  String? capacityUnit; // 'MWp' | 'kWp'
  late String status; // 'planning' | 'construction' | 'commissioning' | 'om' | 'completed' | 'on_hold'
  String? stage; // 'Engineering' | 'Procurement' | 'Civil Works' | 'Electrical' | 'Commissioning' | 'Grid Tie'
  late String type; // 'Rooftop' | 'Ground Mounted' | 'Floating'
  String? systemType; // 'On-Grid' | 'Off-Grid' | 'Hybrid'
  late String location;
  String? supervisor;
  String? client;
  
  late double progress; // 0.0 to 1.0
  double totalCost = 0.0;

  late DateTime startDate;
  late DateTime endDate;

  String? teamMembersJson;
  String? bomSpecsJson;

  late DateTime createdAt;
  late DateTime updatedAt;

  late bool isSynced;
}
