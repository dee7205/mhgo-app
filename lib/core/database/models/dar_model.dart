import 'package:isar_community/isar.dart';

part 'dar_model.g.dart';

@collection
class DarModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String uuid;

  late String darNumber;

  @Index()
  late String projectUuid;

  late String projectName;
  late DateTime reportDate;
  late String preparedBy;
  late String reportingPeriod;
  late String weather;
  late double temperature;
  late String windCondition;
  late String siteCondition;

  // Complex nested lists stored as JSON strings
  late String accomplishmentsJson;
  late String manpowerJson;
  late String equipmentJson;
  late String materialsJson;
  late String delaysJson;
  late String photosJson;

  // Signatories
  String? signedPrepared;
  String? signedChecked;
  String? signedApproved;

  late String status; // 'Draft' | 'Submitted' | 'Approved' | 'Rejected'

  late DateTime createdAt;
  late DateTime updatedAt;

  late bool isSynced;
}
