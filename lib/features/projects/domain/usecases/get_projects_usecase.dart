import 'package:mhgo/core/database/models/project_model.dart';
import 'package:mhgo/features/projects/domain/repositories/projects_repository.dart';

class GetProjectsUseCase {
  final ProjectsRepository repository;

  GetProjectsUseCase(this.repository);

  Future<List<ProjectModel>> execute() {
    return repository.getProjects();
  }
}
