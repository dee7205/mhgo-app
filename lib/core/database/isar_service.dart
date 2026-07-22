import 'dart:convert';
import 'dart:io';
import 'package:archive/archive_io.dart';
import 'package:csv/csv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'package:mhgo/core/database/models/project_model.dart';
import 'package:mhgo/core/database/models/progress_model.dart';
import 'package:mhgo/core/database/models/task_model.dart';
import 'package:mhgo/features/materials/data/models/material_model.dart';
import 'package:mhgo/features/materials/data/models/project_material_requirement_model.dart';
import 'package:mhgo/core/database/models/survey_model.dart';
import 'package:mhgo/core/database/models/dar_model.dart';
import 'package:mhgo/core/database/models/notification_model.dart';


// Riverpod Provider for IsarService
final isarServiceProvider = Provider<IsarService>((ref) {
  return IsarService();
});

class IsarService {
  late Isar _isar;

  Isar get isar => _isar;

  Future<void> init() async {
    // Determine path based on platform (Windows support requires correct pathing)
    final dir = await getApplicationDocumentsDirectory();
    final dbDirectory = Directory('${dir.path}/mhgo_db');
    if (!await dbDirectory.exists()) {
      await dbDirectory.create(recursive: true);
    }

    try {
      _isar = await Isar.open(
        [
          ProjectModelSchema,
          TaskModelSchema,
          MaterialModelSchema,
          ProjectMaterialRequirementModelSchema,
          SurveyModelSchema,
          DarModelSchema,
          ProgressModelSchema,
          NotificationModelSchema,
        ],
        directory: dbDirectory.path,
        name: 'mhgo_local_db',
      );
    } catch (e) {
      // Handle schema mismatches by wiping the database and starting fresh
      final dbFile = File('${dbDirectory.path}/mhgo_local_db.isar');
      final lockFile = File('${dbDirectory.path}/mhgo_local_db.isar.lock');
      if (dbFile.existsSync()) dbFile.deleteSync();
      if (lockFile.existsSync()) lockFile.deleteSync();

      _isar = await Isar.open(
        [
          ProjectModelSchema,
          TaskModelSchema,
          MaterialModelSchema,
          ProjectMaterialRequirementModelSchema,
          SurveyModelSchema,
          DarModelSchema,
          ProgressModelSchema,
          NotificationModelSchema,
        ],
        directory: dbDirectory.path,
        name: 'mhgo_local_db',
      );
    }
  }

  Future<String> exportDatabase() async {
    final dir = await getApplicationDocumentsDirectory();
    final backupDir = Directory('${dir.path}/mhgo_backup_temp');
    if (await backupDir.exists()) {
      await backupDir.delete(recursive: true);
    }
    await backupDir.create();

    // Export each collection to a separate JSON file
    Future<void> saveJson(String name, List<Map<String, dynamic>> data) async {
      final file = File('${backupDir.path}/$name.json');
      await file.writeAsString(jsonEncode(data));
    }

    await saveJson(
      'projectModels',
      await _isar.projectModels.where().exportJson(),
    );
    await saveJson('taskModels', await _isar.taskModels.where().exportJson());
    await saveJson(
      'materialModels',
      await _isar.materialModels.where().exportJson(),
    );
    await saveJson(
      'projectMaterialRequirementModels',
      await _isar.projectMaterialRequirementModels.where().exportJson(),
    );
    await saveJson(
      'surveyModels',
      await _isar.surveyModels.where().exportJson(),
    );
    await saveJson('darModels', await _isar.darModels.where().exportJson());
    await saveJson(
      'progressModels',
      await _isar.progressModels.where().exportJson(),
    );
    await saveJson(
      'notificationModels',
      await _isar.notificationModels.where().exportJson(),
    );

    // Create zip
    final zipFilePath =
        '${dir.path}/mhgo_backup_${DateTime.now().millisecondsSinceEpoch}.zip';
    final archive = Archive();
    for (final entity in backupDir.listSync()) {
      if (entity is File) {
        final filename = entity.path.split(Platform.pathSeparator).last;
        final bytes = await entity.readAsBytes();
        archive.addFile(ArchiveFile(filename, bytes.length, bytes));
      }
    }
    final zipData = ZipEncoder().encode(archive);
    await File(zipFilePath).writeAsBytes(zipData);

    // Cleanup temp dir
    await backupDir.delete(recursive: true);

    return zipFilePath;
  }

  Future<String> exportProjectsCsv() async {
    final dir = await getApplicationDocumentsDirectory();
    final csvFilePath =
        '${dir.path}/mhgo_projects_${DateTime.now().millisecondsSinceEpoch}.csv';

    final projects = await _isar.projectModels.where().findAll();

    List<List<dynamic>> rows = [];
    rows.add([
      'Project ID',
      'Project Name',
      'Client',
      'Location',
      'System Type',
      'Arrangement Type',
      'Capacity',
      'Capacity Unit',
      'Start Date',
      'Expected Completion',
      'Status',
      'Total Cost (PHP)',
    ]);

    for (final p in projects) {
      rows.add([
        p.uuid,
        p.name,
        p.client ?? 'MHG Internals',
        p.location,
        p.systemType ?? 'N/A',
        p.type,
        p.capacity,
        p.capacityUnit ?? 'kWp',
        p.startDate.toIso8601String().split('T').first,
        p.endDate.toIso8601String().split('T').first,
        p.status,
        p.totalCost,
      ]);
    }

    final csvData = csv.encode(rows);
    await File(csvFilePath).writeAsString(csvData);

    return csvFilePath;
  }

  Future<void> importDatabase(String backupFilePath) async {
    final dir = await getApplicationDocumentsDirectory();
    final tempDir = Directory('${dir.path}/mhgo_import_temp');
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
    await tempDir.create();

    try {
      final bytes = await File(backupFilePath).readAsBytes();
      final archive = ZipDecoder().decodeBytes(bytes);

      for (final file in archive) {
        if (file.isFile) {
          final filename = file.name;
          final outFile = File('${tempDir.path}/$filename');
          await outFile.parent.create(recursive: true);
          await outFile.writeAsBytes(file.content as List<int>);
        }
      }

      Future<List<Map<String, dynamic>>?> loadJson(String name) async {
        final files = tempDir
            .listSync(recursive: true)
            .whereType<File>()
            .where((f) => f.path.endsWith('$name.json'))
            .toList();

        if (files.isEmpty) return null;
        return List<Map<String, dynamic>>.from(
          jsonDecode(await files.first.readAsString()),
        );
      }

      final projectData = await loadJson('projectModels');
      final taskData = await loadJson('taskModels');
      final materialData = await loadJson('materialModels');
      final projMaterialData = await loadJson(
        'projectMaterialRequirementModels',
      );
      final surveyData = await loadJson('surveyModels');
      final darData = await loadJson('darModels');
      final progressData = await loadJson('progressModels');
      final notificationData = await loadJson('notificationModels');

      if (projectData == null && taskData == null) {
        throw Exception('Invalid backup format: Missing JSON files.');
      }

      await _isar.writeTxn(() async {
        if (projectData != null) {
          await _isar.projectModels.clear();
          await _isar.projectModels.importJson(projectData);
        }
        if (taskData != null) {
          await _isar.taskModels.clear();
          await _isar.taskModels.importJson(taskData);
        }
        if (materialData != null) {
          await _isar.materialModels.clear();
          await _isar.materialModels.importJson(materialData);
        }
        if (projMaterialData != null) {
          await _isar.projectMaterialRequirementModels.clear();
          await _isar.projectMaterialRequirementModels.importJson(
            projMaterialData,
          );
        }
        if (surveyData != null) {
          await _isar.surveyModels.clear();
          await _isar.surveyModels.importJson(surveyData);
        }
        if (darData != null) {
          await _isar.darModels.clear();
          await _isar.darModels.importJson(darData);
        }
        if (progressData != null) {
          await _isar.progressModels.clear();
          await _isar.progressModels.importJson(progressData);
        }
        if (notificationData != null) {
          await _isar.notificationModels.clear();
          await _isar.notificationModels.importJson(notificationData);
        }
      });
    } finally {
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    }
  }

  Future<void> clearAllData() async {
    await _isar.writeTxn(() async {
      await _isar.projectModels.clear();
      await _isar.taskModels.clear();
      await _isar.materialModels.clear();
      await _isar.projectMaterialRequirementModels.clear();
      await _isar.surveyModels.clear();
      await _isar.darModels.clear();
      await _isar.progressModels.clear();
      await _isar.notificationModels.clear();
    });

    final dir = await getApplicationDocumentsDirectory();
    final List<FileSystemEntity> entities = await dir.list().toList();
    for (var entity in entities) {
      if (entity is File && entity.path.endsWith('.pdf')) {
        await entity.delete();
      }
    }
  }
}
