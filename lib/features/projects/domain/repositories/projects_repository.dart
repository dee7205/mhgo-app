import 'package:mhgo/core/database/models/project_model.dart';
import 'package:mhgo/features/projects/domain/entities/projects_entities.dart';

abstract class ProjectsRepository {
  Future<List<ProjectModel>> getProjects();
  Future<DetailedProjectData> getProjectDetails(String projectUuid);
  Future<void> addProject(ProjectModel project);
  Future<void> deleteProject(String projectUuid);
  Future<void> updateProjectTeam(
    String projectUuid,
    List<ProjectTeamMember> team,
  );
}
