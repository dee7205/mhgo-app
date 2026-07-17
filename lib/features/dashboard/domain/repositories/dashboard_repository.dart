import 'package:mhgo/core/database/models/project_model.dart';
import 'package:mhgo/core/database/models/task_model.dart';
import 'package:mhgo/features/materials/data/models/material_model.dart';
import 'package:mhgo/core/database/models/survey_model.dart';

abstract class DashboardRepository {
  Future<List<ProjectModel>> getAllProjects();
  Future<List<TaskModel>> getUrgentTasks(String? assignedToName);
  Future<List<MaterialModel>> getLowStockMaterials();
  Future<List<SurveyModel>> getRecentInspections();
}
