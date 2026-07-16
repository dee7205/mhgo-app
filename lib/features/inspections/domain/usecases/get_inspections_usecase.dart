import 'package:mhgo/features/inspections/domain/entities/inspection_entities.dart';
import 'package:mhgo/features/inspections/domain/repositories/inspections_repository.dart';

class GetInspectionsUseCase {
  final InspectionsRepository repository;

  GetInspectionsUseCase(this.repository);

  Future<List<InspectionReport>> execute() {
    return repository.getInspections();
  }
}
