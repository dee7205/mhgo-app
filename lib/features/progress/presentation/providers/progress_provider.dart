import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/database/isar_service.dart';
import '../../domain/repositories/progress_repository.dart';
import '../../domain/usecases/progress_usecases.dart';
import '../../data/repositories/progress_repository_impl.dart';
import '../../domain/entities/progress_entities.dart';

import '../../../projects/presentation/providers/projects_provider.dart';

final progressRepositoryProvider = Provider<ProgressRepository>((ref) {
  final isarService = ref.watch(isarServiceProvider);
  return ProgressRepositoryImpl(isarService.isar);
});

final getProgressReportsProvider = Provider<GetProgressReports>((ref) {
  final repository = ref.watch(progressRepositoryProvider);
  return GetProgressReports(repository);
});

final getProgressReportByIdProvider = Provider<GetProgressReportById>((ref) {
  final repository = ref.watch(progressRepositoryProvider);
  return GetProgressReportById(repository);
});

final saveProgressReportProvider = Provider<SaveProgressReport>((ref) {
  final repository = ref.watch(progressRepositoryProvider);
  return SaveProgressReport(repository);
});

final deleteProgressReportProvider = Provider<DeleteProgressReport>((ref) {
  final repository = ref.watch(progressRepositoryProvider);
  return DeleteProgressReport(repository);
});

class ProgressNotifier extends AsyncNotifier<List<ProgressReport>> {
  @override
  Future<List<ProgressReport>> build() async {
    final query = ref.watch(progressSearchQueryProvider).toLowerCase();
    return await _fetchReports(query);
  }

  Future<List<ProgressReport>> _fetchReports(String query) async {
    final getProgressReports = ref.read(getProgressReportsProvider);
    final reports = await getProgressReports();
    
    return reports.where((report) {
      final matchesQuery = report.projectName.toLowerCase().contains(query);
      return matchesQuery;
    }).toList();
  }
  
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    final query = ref.read(progressSearchQueryProvider).toLowerCase();
    state = await AsyncValue.guard(() => _fetchReports(query));
  }

  Future<void> saveReport(ProgressReport report) async {
    final saveProgressReport = ref.read(saveProgressReportProvider);
    await saveProgressReport(report);
    
    // Invalidate related providers so Projects views refresh with the new data
    ref.invalidate(projectsListProvider);
    ref.invalidate(projectDetailsProvider);
    
    await refresh();
  }

  Future<void> deleteReport(String uuid) async {
    final deleteProgressReport = ref.read(deleteProgressReportProvider);
    await deleteProgressReport(uuid);
    await refresh();
  }

  ProgressReport? _getReport(String uuid) {
    final reports = state.value;
    if (reports == null) return null;
    try {
      return reports.firstWhere((r) => r.uuid == uuid || r.projectUuid == uuid);
    } catch (e) {
      return null;
    }
  }

  double _calculateOverallProgress(List<ProgressCategory> categories) {
    final activeCategories = categories.where((c) => !c.isArchived).toList();
    if (activeCategories.isEmpty) return 0.0;
    double total = activeCategories.fold(0.0, (sum, cat) => sum + cat.progress);
    return total / activeCategories.length;
  }

  Future<void> addCategory(String reportUuid, ProgressCategory category) async {
    final report = _getReport(reportUuid);
    if (report == null) return;

    final updatedCategories = List<ProgressCategory>.from(report.categories)..add(category);
    
    double overallProgress = report.overallProgress;
    if (report.isAutoCalculated) {
      overallProgress = _calculateOverallProgress(updatedCategories);
    }

    final updatedReport = report.copyWith(
      categories: updatedCategories,
      overallProgress: overallProgress,
      updatedAt: DateTime.now(),
    );

    await saveReport(updatedReport);
  }

  Future<void> updateCategory(String reportUuid, ProgressCategory category) async {
    final report = _getReport(reportUuid);
    if (report == null) return;

    final updatedCategories = report.categories.map((c) => c.id == category.id ? category : c).toList();
    
    double overallProgress = report.overallProgress;
    if (report.isAutoCalculated) {
      overallProgress = _calculateOverallProgress(updatedCategories);
    }

    final updatedReport = report.copyWith(
      categories: updatedCategories,
      overallProgress: overallProgress,
      updatedAt: DateTime.now(),
    );

    await saveReport(updatedReport);
  }

  Future<void> deleteCategory(String reportUuid, String categoryId) async {
    final report = _getReport(reportUuid);
    if (report == null) return;

    final updatedCategories = report.categories.where((c) => c.id != categoryId).toList();
    
    double overallProgress = report.overallProgress;
    if (report.isAutoCalculated) {
      overallProgress = _calculateOverallProgress(updatedCategories);
    }

    final updatedReport = report.copyWith(
      categories: updatedCategories,
      overallProgress: overallProgress,
      updatedAt: DateTime.now(),
    );

    await saveReport(updatedReport);
  }

  Future<void> reorderCategories(String reportUuid, int oldIndex, int newIndex) async {
    final report = _getReport(reportUuid);
    if (report == null) return;

    final categories = List<ProgressCategory>.from(report.categories);
    categories.sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
    
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    
    final item = categories.removeAt(oldIndex);
    categories.insert(newIndex, item);

    // Update orderIndex
    for (int i = 0; i < categories.length; i++) {
      categories[i] = categories[i].copyWith(orderIndex: i);
    }

    final updatedReport = report.copyWith(
      categories: categories,
      updatedAt: DateTime.now(),
    );

    await saveReport(updatedReport);
  }

  Future<void> toggleAutoCalculate(String reportUuid, bool isAuto) async {
    final report = _getReport(reportUuid);
    if (report == null) return;

    double overallProgress = report.overallProgress;
    if (isAuto) {
      overallProgress = _calculateOverallProgress(report.categories);
    }

    final updatedReport = report.copyWith(
      isAutoCalculated: isAuto,
      overallProgress: overallProgress,
      updatedAt: DateTime.now(),
    );

    await saveReport(updatedReport);
  }

  Future<void> updateOverallProgress(String reportUuid, double progress) async {
    final report = _getReport(reportUuid);
    if (report == null) return;

    final updatedReport = report.copyWith(
      overallProgress: progress,
      isAutoCalculated: false,
      updatedAt: DateTime.now(),
    );

    await saveReport(updatedReport);
  }
}

class ProgressSearchQuery extends Notifier<String> {
  @override
  String build() => '';
  void update(String value) => state = value;
}
final progressSearchQueryProvider = NotifierProvider<ProgressSearchQuery, String>(() => ProgressSearchQuery());

final progressNotifierProvider = AsyncNotifierProvider<ProgressNotifier, List<ProgressReport>>(() {
  return ProgressNotifier();
});
