import 'package:isar_community/isar.dart';

part 'inspection_model.g.dart';

@collection
class InspectionModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String uuid;

  @Index()
  late String projectUuid;

  late String title; // General title/description
  late String inspectorName;
  late String status; // 'Draft' | 'Pending' | 'Approved' | 'Rejected'

  late DateTime inspectionDate;
  String? checklistJson; // Storing dynamic checklist items as JSON
  String? notes;
  String? signaturePath; // Legacy path

  // New fields for Site Inspections module
  late String inspectionId; // e.g. INSP-YYYYMMDD-XXXX
  late String inspectionType; // e.g. Civil, Structural, Electrical, etc.
  late String time;
  late String area;
  late String location;
  late String witness;
  late String priority; // 'Low' | 'Medium' | 'High' | 'Critical'
  late String overallResult; // 'Pass' | 'Fail' | 'Open NC'
  String? nonConformanceJson; // Stored as JSON string
  String? photosJson; // Stored as JSON string
  String? signaturesJson; // Stored as JSON string (inspector, contractor, qa/qc)

  late DateTime createdAt;
  late DateTime updatedAt;

  late bool isSynced;
}
