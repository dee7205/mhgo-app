import 'dart:convert';
import 'package:isar_community/isar.dart';
import 'package:mhgo/core/database/models/project_model.dart';
import 'package:mhgo/core/database/models/progress_model.dart';
import 'package:mhgo/features/projects/domain/entities/projects_entities.dart';
import 'package:mhgo/features/projects/domain/repositories/projects_repository.dart';

class ProjectsRepositoryImpl implements ProjectsRepository {
  final Isar _isar;

  ProjectsRepositoryImpl(this._isar);

  @override
  Future<List<ProjectModel>> getProjects() async {
    return _isar.projectModels.where().findAll();
  }

  @override
  Future<void> addProject(ProjectModel project) async {
    await _isar.writeTxn(() async {
      await _isar.projectModels.put(project);
    });
  }

  @override
  Future<void> deleteProject(String projectUuid) async {
    await _isar.writeTxn(() async {
      final project = await _isar.projectModels
          .filter()
          .uuidEqualTo(projectUuid)
          .findFirst();
      if (project != null) {
        await _isar.projectModels.delete(project.id);
      }

      final progressReports = await _isar.progressModels
          .filter()
          .projectUuidEqualTo(projectUuid)
          .findAll();
      for (final report in progressReports) {
        await _isar.progressModels.delete(report.id);
      }
    });
  }

  @override
  Future<DetailedProjectData> getProjectDetails(String projectUuid) async {
    final project = await _isar.projectModels
        .filter()
        .uuidEqualTo(projectUuid)
        .findFirst();
    if (project == null) {
      throw Exception('Project not found with UUID: $projectUuid');
    }

    // Generate highly realistic mock data based on the specific project type & status
    final double overallProgress = project.progress;

    // Fetch actual progress report from Isar to populate engineering progress accurately
    final progressModel = await _isar.progressModels
        .filter()
        .projectUuidEqualTo(projectUuid)
        .findFirst();
    List<ProjectCategoryProgress> categoryProgresses = [];
    if (progressModel != null && progressModel.categoriesJson.isNotEmpty) {
      final List<dynamic> decoded = jsonDecode(progressModel.categoriesJson);
      categoryProgresses = decoded.map((e) {
        final data = e as Map<String, dynamic>;
        return ProjectCategoryProgress(
          name: data['name'] as String? ?? 'Unknown',
          progress: (data['progress'] as num?)?.toDouble() ?? 0.0,
          status: data['status'] as String? ?? 'Not Started',
        );
      }).toList();
    }

    // Since this is a real project management app now, we start with empty lists
    // until we implement the actual creation mechanisms for these entities.
    final kpis = ProjectKpis(
      totalManHours: 0,
      safeDays: 0,
      weatherDowntimeHours: 0,
      qualityComplianceRate: 0.0,
    );
    final activityLogs = <ProjectActivityLog>[];

    // Timeline auto-updated from progress entries
    final timeline = categoryProgresses.map((c) {
      String status = c.status;

      return ProjectTimelineItem(
        milestoneName: c.name,
        date: progressModel?.updatedAt ?? DateTime.now(),
        owner: 'Project Manager',
        status: status,
        progress: c.progress,
      );
    }).toList();

    List<ProjectTeamMember> team = [];
    if (project.teamMembersJson != null &&
        project.teamMembersJson!.isNotEmpty) {
      try {
        final decoded = jsonDecode(project.teamMembersJson!) as List<dynamic>;
        team = decoded
            .map((e) => ProjectTeamMember.fromJson(e as Map<String, dynamic>))
            .toList();
      } catch (e) {
        team = [];
      }
    }

    final documents = <DocumentSummary>[];
    final materials = <MaterialSummaryItem>[];

    const inspectionSummary = InspectionSummary(
      totalInspections: 0,
      approved: 0,
      rejected: 0,
      pending: 0,
    );
    const darSummary = DarSummary(
      reportsFiled: 0,
      averageProgressPerDay: 0.0,
      totalWorkersOnSite: 0,
    );
    const punchListSummary = PunchListSummary(
      totalItems: 0,
      openItems: 0,
      resolvedItems: 0,
      closedItems: 0,
    );

    return DetailedProjectData(
      project: project,
      categoryProgresses: categoryProgresses,
      kpis: kpis,
      activityLogs: activityLogs,
      timeline: timeline,
      team: team,
      documents: documents,
      materials: materials,
      inspectionSummary: inspectionSummary,
      darSummary: darSummary,
      punchListSummary: punchListSummary,
    );
  }

  @override
  Future<void> updateProjectTeam(
    String projectUuid,
    List<ProjectTeamMember> team,
  ) async {
    final project = await _isar.projectModels
        .filter()
        .uuidEqualTo(projectUuid)
        .findFirst();
    if (project == null) return;

    project.teamMembersJson = jsonEncode(team.map((e) => e.toJson()).toList());
    project.updatedAt = DateTime.now();
    project.isSynced = false;

    await _isar.writeTxn(() async {
      await _isar.projectModels.put(project);
    });
  }
}
