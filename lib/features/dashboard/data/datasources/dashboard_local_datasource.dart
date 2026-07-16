import 'package:isar_community/isar.dart';
import 'package:mhgo/core/database/models/project_model.dart';
import 'package:mhgo/core/database/models/task_model.dart';
import 'package:mhgo/core/database/models/material_model.dart';
import 'package:mhgo/core/database/models/inspection_model.dart';

class DashboardLocalDatasource {
  final Isar _isar;

  DashboardLocalDatasource(this._isar);

  Future<List<ProjectModel>> getAllProjects() async {
    return _isar.projectModels.where().findAll();
  }

  Future<List<TaskModel>> getUrgentTasks(String? assignedToName) async {
    final allTasks = await _isar.taskModels.where().findAll();
    var filtered = allTasks.where((task) => task.status != 'done').toList();
    if (assignedToName != null) {
      filtered = filtered.where((task) => task.assignedToName == assignedToName).toList();
    }
    
    // Sort by priority: critical -> high -> medium -> low
    final priorityWeight = {
      'critical': 4,
      'high': 3,
      'medium': 2,
      'low': 1,
    };
    
    filtered.sort((a, b) {
      final aWeight = priorityWeight[a.priority.toLowerCase()] ?? 0;
      final bWeight = priorityWeight[b.priority.toLowerCase()] ?? 0;
      return bWeight.compareTo(aWeight); // descending priority
    });
    
    return filtered;
  }

  Future<List<MaterialModel>> getLowStockMaterials() async {
    final materials = await _isar.materialModels.where().findAll();
    return materials.where((m) => m.quantityInStock <= m.reorderPoint).toList();
  }

  Future<List<InspectionModel>> getRecentInspections() async {
    final inspections = await _isar.inspectionModels.where().findAll();
    inspections.sort((a, b) => b.inspectionDate.compareTo(a.inspectionDate)); // Newest first
    return inspections;
  }
}
