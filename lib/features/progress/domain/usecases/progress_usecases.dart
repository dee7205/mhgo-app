import '../entities/progress_entities.dart';
import '../repositories/progress_repository.dart';

class GetProgressReports {
  final ProgressRepository repository;

  GetProgressReports(this.repository);

  Future<List<ProgressReport>> call() async {
    return await repository.getProgressReports();
  }
}

class GetProgressReportById {
  final ProgressRepository repository;

  GetProgressReportById(this.repository);

  Future<ProgressReport?> call(String uuid) async {
    return await repository.getProgressReportById(uuid);
  }
}

class SaveProgressReport {
  final ProgressRepository repository;

  SaveProgressReport(this.repository);

  Future<void> call(ProgressReport report) async {
    return await repository.saveProgressReport(report);
  }
}

class DeleteProgressReport {
  final ProgressRepository repository;

  DeleteProgressReport(this.repository);

  Future<void> call(String uuid) async {
    return await repository.deleteProgressReport(uuid);
  }
}
