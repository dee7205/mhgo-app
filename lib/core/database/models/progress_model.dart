import 'package:isar_community/isar.dart';

part 'progress_model.g.dart';

@collection
class ProgressModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String uuid;

  @Index()
  late String projectUuid;

  late String projectName;
  late double overallProgress;
  late bool isAutoCalculated;

  late String categoriesJson;

  late DateTime createdAt;
  late DateTime updatedAt;
  late bool isSynced;
}
