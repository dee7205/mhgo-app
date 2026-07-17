import 'dart:io';
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
      ],
      directory: dbDirectory.path,
      name: 'mhgo_local_db',
    );
  }
}

}
