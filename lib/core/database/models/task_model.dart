import 'package:isar_community/isar.dart';

part 'task_model.g.dart';

@collection
class TaskModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String uuid;

  @Index()
  late String projectUuid;

  late String title;
  String? description;
  String? assignedToName;
  String? assignedToRole;

  late String
  status; // 'todo' | 'in_progress' | 'under_review' | 'done' | 'blocked'
  late String priority; // 'low' | 'medium' | 'high' | 'critical'
  late String
  category; // 'Engineering' | 'Procurement' | 'Civil Works' | 'Electrical' | 'QA/QC' | 'Commissioning'

  late DateTime dueDate;
  late double progress; // 0.0 to 1.0

  late DateTime createdAt;
  late DateTime updatedAt;

  late bool isSynced;
}
