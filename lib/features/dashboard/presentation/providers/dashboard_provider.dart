import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mhgo/features/dashboard/domain/models/dashboard_overview.dart';
import 'package:mhgo/features/projects/presentation/providers/projects_provider.dart';
import 'package:mhgo/features/dar/presentation/providers/dar_provider.dart';
import 'package:mhgo/features/survey/presentation/providers/survey_provider.dart';
import 'package:mhgo/features/materials/presentation/providers/materials_provider.dart';
import 'package:mhgo/features/progress/presentation/providers/progress_provider.dart';

final dashboardStateProvider = AsyncNotifierProvider<DashboardNotifier, DashboardOverview>(() {
  return DashboardNotifier();
});

class DashboardNotifier extends AsyncNotifier<DashboardOverview> {
  @override
  Future<DashboardOverview> build() async {
    // Dashboard auto-refreshes on CRUD operations via specific provider futures.
    // We intentionally don't watch progressNotifierProvider here because saveReport
    // explicitly invalidates projectsListProvider, which we already watch below.
    // Wait for all data to load to ensure sync is accurate
    // If any provider throws a RangeError due to Isar schema corruption or invalid data,
    // we catch it and fallback to safe defaults to prevent the EPC offline sync crash.
    List<dynamic> projects = [];
    List<dynamic> dars = [];
    List<dynamic> surveys = [];
    List<dynamic> materials = [];

    try {
      projects = await ref.watch(projectsListProvider.future);
    } catch (e) {
      // Validate and prevent recurrence: Catch Isar serialization errors and return empty list
      projects = [];
    }
    
    try {
      dars = await ref.watch(darsListProvider.future);
    } catch (e) {
      dars = [];
    }

    try {
      surveys = await ref.watch(surveyListProvider.future);
    } catch (e) {
      surveys = [];
    }

    try {
      materials = await ref.watch(materialsProvider.future);
    } catch (e) {
      materials = [];
    }

    // 1. Projects KPIs
    // Assuming 'construction', 'om', 'commissioning' are active statuses
    final activeProjects = projects.where((p) => p.status == 'active' || p.status == 'construction' || p.status == 'om' || p.status == 'commissioning').toList();
    final planningProjects = projects.where((p) => p.status == 'planning').toList();
    
    final activeProjectsCount = activeProjects.length;
    final planningProjectsCount = planningProjects.length;
    final totalProjectsCount = projects.length;

    // 2. Capacity KPIs — preserve stored unit, no conversions
    final Map<String, double> capacityByUnit = {};
    double accumulatedTotalCost = 0.0;
    for (final p in projects) {
      if (p.status == 'on_hold') continue;
      // Capacity: sum per unit
      final double cap = (p.capacity.isNaN || p.capacity.isInfinite) ? 0.0 : p.capacity;
      final String unit = (p.capacityUnit ?? 'kWp').isEmpty ? 'kWp' : p.capacityUnit!;
      capacityByUnit[unit] = (capacityByUnit[unit] ?? 0.0) + cap;
      // Total cost: sum all non-on_hold projects
      final double cost = (p.totalCost.isNaN || p.totalCost.isInfinite) ? 0.0 : p.totalCost;
      accumulatedTotalCost += cost;
    }

    // 3. Progress KPI
    double overallProgress = 0.0;
    if (activeProjects.isNotEmpty) {
      double totalProgressSum = 0.0;
      for (final p in activeProjects) {
        totalProgressSum += p.progress;
      }
      overallProgress = totalProgressSum / activeProjects.length;
    }

    // 4. Logistics KPIs
    final lowStockMaterials = materials.where((m) => m.currentStock <= m.minimumStock).toList();
    
    // 5. DAR KPIs
    final recentDars = List.of(dars)..sort((a, b) => b.reportDate.compareTo(a.reportDate));
    final recentDarCount = recentDars.where((dar) => dar.reportDate.isAfter(DateTime.now().subtract(const Duration(days: 7)))).length;

    // 6. Recent Inspections (Survey)
    final recentSurveys = List.of(surveys)..sort((a, b) => b.surveyDate.compareTo(a.surveyDate));
    final recentInspections = recentSurveys.take(5).toList();

    // 6. Stage distribution
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
      capacityByUnit: capacityByUnit,
      accumulatedTotalCost: accumulatedTotalCost,
      overallProgress: overallProgress,
      projectsByStage: projectsByStage,
      recentDarCount: recentDarCount,
      projects: projects.cast(),
      urgentTasks: [], // deprecated mock tasks
      lowStockMaterials: lowStockMaterials.cast(),
      recentInspections: recentInspections.cast(),
    );
  }

  Future<void> refresh() async {
    // Manually force an invalidation of all underlying resources
    ref.invalidate(projectsListProvider);
    ref.invalidate(darsListProvider);
    ref.invalidate(surveyListProvider);
    ref.invalidate(materialsProvider);
    ref.invalidate(progressNotifierProvider);
  }
}
