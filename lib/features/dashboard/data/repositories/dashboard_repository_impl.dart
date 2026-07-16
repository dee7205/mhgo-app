import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mhgo/core/database/isar_service.dart';
import 'package:mhgo/core/database/models/project_model.dart';
import 'package:mhgo/core/database/models/task_model.dart';
import 'package:mhgo/core/database/models/material_model.dart';
import 'package:mhgo/core/database/models/inspection_model.dart';
import 'package:mhgo/features/dashboard/data/datasources/dashboard_local_datasource.dart';
import 'package:mhgo/features/dashboard/domain/repositories/dashboard_repository.dart';

// Riverpod Provider for the Local Datasource
final dashboardLocalDatasourceProvider = Provider<DashboardLocalDatasource>((ref) {
  final isarService = ref.watch(isarServiceProvider);
  return DashboardLocalDatasource(isarService.isar);
});

// Riverpod Provider for the Repository Implementation
final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  final localDatasource = ref.watch(dashboardLocalDatasourceProvider);
  return DashboardRepositoryImpl(localDatasource);
});

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardLocalDatasource _localDatasource;

  DashboardRepositoryImpl(this._localDatasource);

  @override
  Future<List<ProjectModel>> getAllProjects() {
    return _localDatasource.getAllProjects();
  }

  @override
  Future<List<TaskModel>> getUrgentTasks(String? assignedToName) {
    return _localDatasource.getUrgentTasks(assignedToName);
  }

  @override
  Future<List<MaterialModel>> getLowStockMaterials() {
    return _localDatasource.getLowStockMaterials();
  }

  @override
  Future<List<InspectionModel>> getRecentInspections() {
    return _localDatasource.getRecentInspections();
  }
}
