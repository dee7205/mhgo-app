import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mhgo/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:mhgo/features/dashboard/domain/models/dashboard_overview.dart';
import 'package:mhgo/features/dashboard/domain/repositories/dashboard_repository.dart';

// Riverpod Provider for the GetDashboardOverview Use Case
final getDashboardOverviewProvider = Provider<GetDashboardOverview>((ref) {
  final repository = ref.watch(dashboardRepositoryProvider);
  return GetDashboardOverview(repository);
});

class GetDashboardOverview {
  final DashboardRepository _repository;

  GetDashboardOverview(this._repository);

  Future<DashboardOverview> execute({String? assignedToName}) async {
    final projects = await _repository.getAllProjects();
    final urgentTasks = await _repository.getUrgentTasks(assignedToName);
    final lowStockMaterials = await _repository.getLowStockMaterials();
    final recentInspections = await _repository.getRecentInspections();

    // 1. Calculate project counts
    final totalProjectsCount = projects.length;
    final activeProjectsCount = projects.where((p) => p.status == 'construction').length;
    final planningProjectsCount = projects.where((p) => p.status == 'planning').length;

    // 2. Sum up total MW capacity under implementation (planning + construction + completed)
    double totalCapacityMw = 0.0;
    for (final p in projects) {
      totalCapacityMw += p.capacityMw;
    }

    // 3. Compute overall progress average (weighted or simple average across active/construction projects)
    double overallProgress = 0.0;
    final activeOrComp = projects.where((p) => p.status == 'construction' || p.status == 'completed').toList();
    if (activeOrComp.isNotEmpty) {
      double totalProgressSum = 0.0;
      for (final p in activeOrComp) {
        totalProgressSum += p.progress;
      }
      overallProgress = totalProgressSum / activeOrComp.length;
    }

    // 4. Calculate stage distribution
    final Map<String, int> projectsByStage = {};
    for (final p in projects) {
      if (p.stage != null && p.stage!.isNotEmpty) {
        projectsByStage[p.stage!] = (projectsByStage[p.stage!] ?? 0) + 1;
      }
    }

    return DashboardOverview(
      totalProjectsCount: totalProjectsCount,
      activeProjectsCount: activeProjectsCount,
      planningProjectsCount: planningProjectsCount,
      totalCapacityMw: totalCapacityMw,
      overallProgress: overallProgress,
      projectsByStage: projectsByStage,
      recentDarCount: 0,
      projects: projects,
      urgentTasks: urgentTasks,
      lowStockMaterials: const [],
      recentInspections: const [],
    );
  }
}
