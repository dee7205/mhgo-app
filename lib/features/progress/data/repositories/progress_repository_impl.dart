import 'dart:convert';
import 'package:isar_community/isar.dart';
import '../../../../core/database/models/progress_model.dart';
import '../../../../core/database/models/project_model.dart';
import '../../domain/entities/progress_entities.dart';
import '../../domain/repositories/progress_repository.dart';

class ProgressRepositoryImpl implements ProgressRepository {
  final Isar isar;

  ProgressRepositoryImpl(this.isar);

  @override
  Future<List<ProgressReport>> getProgressReports() async {
    final models = await isar.progressModels.where().findAll();
    return models.map(_mapToEntity).toList();
  }

  @override
  Future<ProgressReport?> getProgressReportById(String uuid) async {
    var model = await isar.progressModels.where().uuidEqualTo(uuid).findFirst();
    model ??= await isar.progressModels
        .filter()
        .projectUuidEqualTo(uuid)
        .findFirst();
    if (model == null) return null;
    return _mapToEntity(model);
  }

  @override
  Future<void> saveProgressReport(ProgressReport report) async {
    final model = _mapToModel(report);
    final existing = await isar.progressModels
        .where()
        .uuidEqualTo(report.uuid)
        .findFirst();
    if (existing != null) {
      model.id = existing.id;
    }

    await isar.writeTxn(() async {
      await isar.progressModels.put(model);

      // Update the related project's progress
      final project = await isar.projectModels
          .where()
          .uuidEqualTo(report.projectUuid)
          .findFirst();
      if (project != null) {
        project.progress = report.overallProgress;
        project.updatedAt = DateTime.now();
        await isar.projectModels.put(project);
      }
    });
  }

  @override
  Future<void> deleteProgressReport(String uuid) async {
    final existing = await isar.progressModels
        .where()
        .uuidEqualTo(uuid)
        .findFirst();
    if (existing != null) {
      await isar.writeTxn(() async {
        await isar.progressModels.delete(existing.id);

        final project = await isar.projectModels
            .where()
            .uuidEqualTo(existing.projectUuid)
            .findFirst();
        if (project != null) {
          project.progress = 0.0;
          project.updatedAt = DateTime.now();
          await isar.projectModels.put(project);
        }
      });
    }
  }

  ProgressReport _mapToEntity(ProgressModel model) {
    List<dynamic> categoriesList = [];
    if (model.categoriesJson.trim().isNotEmpty) {
      try {
        categoriesList = jsonDecode(model.categoriesJson) as List<dynamic>;
      } catch (e) {
        categoriesList = [];
      }
    }

    return ProgressReport(
      uuid: model.uuid,
      projectUuid: model.projectUuid,
      projectName: model.projectName,
      overallProgress: model.overallProgress,
      isAutoCalculated: model.isAutoCalculated,
      categories: categoriesList
          .map((e) => ProgressCategory.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
      isSynced: model.isSynced,
    );
  }

  ProgressModel _mapToModel(ProgressReport entity) {
    return ProgressModel()
      ..uuid = entity.uuid
      ..projectUuid = entity.projectUuid
      ..projectName = entity.projectName
      ..overallProgress = entity.overallProgress
      ..isAutoCalculated = entity.isAutoCalculated
      ..categoriesJson = jsonEncode(
        entity.categories.map((e) => e.toJson()).toList(),
      )
      ..createdAt = entity.createdAt
      ..updatedAt = entity.updatedAt
      ..isSynced = entity.isSynced;
  }
}
