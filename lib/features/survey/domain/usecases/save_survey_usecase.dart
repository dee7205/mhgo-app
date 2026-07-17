import 'package:mhgo/features/inspections/domain/entities/inspection_entities.dart';
import 'package:mhgo/features/inspections/domain/repositories/inspections_repository.dart';

class SaveInspectionUseCase {
  final InspectionsRepository repository;

  SaveInspectionUseCase(this.repository);

  Future<void> execute(InspectionReport report) {
    return repository.saveInspection(report);
  }
}
