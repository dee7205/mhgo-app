import 'package:mhgo/core/database/models/project_model.dart';
import 'package:mhgo/core/database/models/task_model.dart';
import 'package:mhgo/features/materials/domain/entities/materials_entities.dart';
import 'package:mhgo/features/survey/domain/entities/survey_entities.dart';

class DashboardOverview {
  final int totalProjectsCount;
  final int activeProjectsCount;
  final int planningProjectsCount;
  final double totalCapacityMw;
  final double overallProgress; // average progress of active/construction projects (0.0 to 1.0)
  
  final Map<String, int> projectsByStage;

  final List<ProjectModel> projects;
  final List<TaskModel> urgentTasks;
  final List<MaterialEntity> lowStockMaterials;
  final List<Survey> recentInspections;

  final int recentDarCount;

  DashboardOverview({
    required this.totalProjectsCount,
    required this.activeProjectsCount,
    required this.planningProjectsCount,
    required this.totalCapacityMw,
    required this.overallProgress,
    required this.projectsByStage,
    required this.recentDarCount,
    required this.projects,
    required this.urgentTasks,
    required this.lowStockMaterials,
    required this.recentInspections,
  });
}
