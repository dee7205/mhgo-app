import 'dart:io';
import 'package:isar_community/isar.dart';
import 'lib/core/database/models/project_model.dart';
import 'lib/core/database/models/progress_model.dart';

void main() async {
  await Isar.initializeIsarCore(download: true);
  final isar = await Isar.open([
    ProjectModelSchema,
    ProgressModelSchema,
  ], directory: Directory.current.path);

  await isar.writeTxn(() async {
    final testProjects = await isar.projectModels
        .filter()
        .nameContains("test", caseSensitive: false)
        .findAll();
    for (final p in testProjects) {
      await isar.projectModels.delete(p.id);
    }

    final allProjects = await isar.projectModels.where().findAll();
    final validUuids = allProjects.map((e) => e.uuid).toSet();

    final allProgress = await isar.progressModels.where().findAll();
    for (final pr in allProgress) {
      if (!validUuids.contains(pr.projectUuid)) {
        await isar.progressModels.delete(pr.id);
      }
    }
  });

  await isar.close();
  print('Cleanup done');
}
