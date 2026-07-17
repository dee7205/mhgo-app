import 'package:mhgo/features/survey/domain/entities/inspection_entities.dart';
import 'package:mhgo/features/survey/domain/repositories/inspections_repository.dart';

class GetInspectionsUseCase {
  final InspectionsRepository repository;

  GetInspectionsUseCase(this.repository);

  Future<List<InspectionReport>> execute() {
    return repository.getInspections();
  }
}
