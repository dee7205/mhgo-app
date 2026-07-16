import 'package:mhgo/features/projects/domain/entities/projects_entities.dart';
import 'package:mhgo/features/projects/domain/repositories/projects_repository.dart';

class GetProjectDetailsUseCase {
  final ProjectsRepository repository;

  GetProjectDetailsUseCase(this.repository);

  Future<DetailedProjectData> execute(String projectUuid) {
    return repository.getProjectDetails(projectUuid);
  }
}
