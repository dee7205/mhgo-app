import 'package:mhgo/features/inspections/domain/entities/inspection_entities.dart';

abstract class InspectionsRepository {
  Future<List<InspectionReport>> getInspections();
  Future<InspectionReport?> getInspectionById(String id);
  Future<void> saveInspection(InspectionReport report);
  Future<void> deleteInspection(String id);
}
