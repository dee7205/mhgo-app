import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mhgo/features/dashboard/domain/models/dashboard_overview.dart';
import 'package:mhgo/features/dashboard/domain/usecases/get_dashboard_overview.dart';
import 'package:mhgo/features/projects/presentation/providers/projects_provider.dart';
import 'package:mhgo/features/dar/presentation/providers/dar_provider.dart';
import 'package:mhgo/features/inspections/presentation/providers/inspections_provider.dart';
import 'package:mhgo/features/progress/presentation/providers/progress_provider.dart';

// Riverpod AsyncNotifierProvider for managing dashboard state, including loading, error, and refresh controls.
final dashboardStateProvider = AsyncNotifierProvider<DashboardNotifier, DashboardOverview>(() {
  return DashboardNotifier();
});

class DashboardNotifier extends AsyncNotifier<DashboardOverview> {
  @override
  Future<DashboardOverview> build() async {
    // Watch main modules so dashboard auto-refreshes on CRUD operations
    ref.watch(projectsListProvider);
    ref.watch(darsListProvider);
    ref.watch(inspectionsListProvider);
    ref.watch(progressNotifierProvider);

    final useCase = ref.watch(getDashboardOverviewProvider);
    // In our mock data, 'Dave Gigawin' is the logged-in Project Manager
    return useCase.execute(assignedToName: 'Dave Gigawin');
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final useCase = ref.read(getDashboardOverviewProvider);
      return useCase.execute(assignedToName: 'Dave Gigawin');
    });
  }
}
