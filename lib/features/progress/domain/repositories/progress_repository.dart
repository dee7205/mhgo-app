import '../entities/progress_entities.dart';

abstract class ProgressRepository {
  Future<List<ProgressReport>> getProgressReports();
  Future<ProgressReport?> getProgressReportById(String uuid);
  Future<void> saveProgressReport(ProgressReport report);
  Future<void> deleteProgressReport(String uuid);
}
