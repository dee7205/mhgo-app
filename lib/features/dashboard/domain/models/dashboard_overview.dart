import 'package:mhgo/core/database/models/project_model.dart';
import 'package:mhgo/core/database/models/task_model.dart';
import 'package:mhgo/core/database/models/material_model.dart';
import 'package:mhgo/core/database/models/inspection_model.dart';

class DashboardOverview {
  final int totalProjectsCount;
  final int activeProjectsCount;
  final int planningProjectsCount;
  final double totalCapacityMw;
  final double overallProgress; // average progress of active/construction projects (0.0 to 1.0)
  
  final List<ProjectModel> projects;
  final List<TaskModel> urgentTasks;
  final List<MaterialModel> lowStockMaterials;
  final List<InspectionModel> recentInspections;

  DashboardOverview({
    required this.totalProjectsCount,
    required this.activeProjectsCount,
    required this.planningProjectsCount,
    required this.totalCapacityMw,
    required this.overallProgress,
    required this.projects,
    required this.urgentTasks,
    required this.lowStockMaterials,
    required this.recentInspections,
  });
}
