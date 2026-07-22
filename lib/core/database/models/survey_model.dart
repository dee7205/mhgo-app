import 'package:isar_community/isar.dart';

part 'survey_model.g.dart';

@collection
class SurveyModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String uuid;

  // Search Indexes
  @Index(type: IndexType.value, caseSensitive: false)
  late String clientName;

  late String contactNumber;
  late String email;

  @Index(type: IndexType.value, caseSensitive: false)
  late String address;

  String? coordinates;
  late DateTime surveyDate;

  // Technical Specifications
  late String technicalSpecsJson;

  // Proposal Context
  late String proposedSystem; // 'On-Grid', 'Off-Grid', 'Hybrid'
  late double proposedCapacityKw;

  // Workflow Status
  @Index()
  late String status; // 'Pending Survey', 'Quoted', 'Waiting Client', 'Approved', 'Declined', 'Converted'

  String? notes;

  // Project Relationship
  String? convertedProjectUuid; // Populated only after conversion

  late DateTime createdAt;
  late DateTime updatedAt;
  late bool isSynced;
}
