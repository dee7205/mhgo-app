import 'dart:convert';
import 'package:isar_community/isar.dart';
import 'package:mhgo/core/database/models/inspection_model.dart';
import 'package:mhgo/core/database/models/project_model.dart';
import 'package:mhgo/features/inspections/domain/entities/inspection_entities.dart';
import 'package:mhgo/features/inspections/domain/repositories/inspections_repository.dart';

class InspectionsRepositoryImpl implements InspectionsRepository {
  final Isar _isar;

  InspectionsRepositoryImpl(this._isar);

  @override
  Future<List<InspectionReport>> getInspections() async {
    final models = await _isar.inspectionModels.where().sortByInspectionDateDesc().findAll();
    
    // Fetch projects to map project names
    final projects = await _isar.projectModels.where().findAll();
    final projectMap = {for (var p in projects) p.uuid: p.name};

    return models.map((m) => _modelToReport(m, projectMap[m.projectUuid] ?? 'Unknown Project')).toList();
  }

  @override
  Future<InspectionReport?> getInspectionById(String id) async {
    final model = await _isar.inspectionModels.filter().uuidEqualTo(id).findFirst();
    if (model == null) return null;

    final project = await _isar.projectModels.filter().uuidEqualTo(model.projectUuid).findFirst();
    return _modelToReport(model, project?.name ?? 'Unknown Project');
  }

  @override
  Future<void> saveInspection(InspectionReport report) async {
    final existing = await _isar.inspectionModels.filter().uuidEqualTo(report.id).findFirst();

    await _isar.writeTxn(() async {
      final model = existing ?? InspectionModel();
      model.uuid = report.id;
      model.inspectionId = report.inspectionId;
      model.projectUuid = report.projectUuid;
      model.title = report.title;
      model.inspectorName = report.inspectorName;
      model.status = report.status;
      model.inspectionDate = report.inspectionDate;
      model.inspectionType = report.inspectionType;
      model.time = report.time;
      model.area = report.area;
      model.location = report.location;
      model.witness = report.witness;
      model.priority = report.priority;
      model.overallResult = report.overallResult;
      model.checklistJson = json.encode(report.checklist.map((e) => e.toJson()).toList());
      model.nonConformanceJson = json.encode(report.nonConformance.map((e) => e.toJson()).toList());
      model.photosJson = json.encode(report.photos.map((e) => e.toJson()).toList());
      model.signaturesJson = json.encode(report.signatures.toJson());
      model.notes = report.title;
      model.createdAt = existing?.createdAt ?? report.createdAt;
      model.updatedAt = DateTime.now();
      model.isSynced = report.isSynced;

      await _isar.inspectionModels.put(model);
    });
  }

  @override
  Future<void> deleteInspection(String id) async {
    final model = await _isar.inspectionModels.filter().uuidEqualTo(id).findFirst();
    if (model != null) {
      await _isar.writeTxn(() async {
        await _isar.inspectionModels.delete(model.id);
      });
    }
  }

  // --- Model-to-Entity Mapping Helpers ---

  InspectionReport _modelToReport(InspectionModel m, String projectName) {
    return InspectionReport(
      id: m.uuid,
      inspectionId: m.inspectionId,
      projectUuid: m.projectUuid,
      projectName: projectName,
      title: m.title,
      inspectorName: m.inspectorName,
      witness: m.witness,
      status: m.status,
      priority: m.priority,
      overallResult: m.overallResult,
      inspectionDate: m.inspectionDate,
      inspectionType: m.inspectionType,
      checklist: _parseChecklist(m.checklistJson),
      nonConformance: _parseNonConformance(m.nonConformanceJson),
      photos: _parsePhotos(m.photosJson),
      signatures: _parseSignatures(m.signaturesJson),
      time: m.time,
      area: m.area,
      location: m.location,
      createdAt: m.createdAt,
      updatedAt: m.updatedAt,
      isSynced: m.isSynced,
    );
  }

  List<ChecklistItem> _parseChecklist(String? jsonStr) {
    if (jsonStr == null || jsonStr.isEmpty) return [];
    try {
      final decoded = json.decode(jsonStr);
      if (decoded is List) {
        return decoded.map((item) => ChecklistItem.fromJson(item as Map<String, dynamic>)).toList();
      } else if (decoded is Map) {
        // Fallback for key-value pair map stored in seed data
        return decoded.entries.map((entry) {
          return ChecklistItem(
            name: entry.key.toString(),
            result: entry.value.toString(),
            remarks: '',
          );
        }).toList();
      }
    } catch (_) {}
    return [];
  }

  List<NonConformance> _parseNonConformance(String? jsonStr) {
    if (jsonStr == null || jsonStr.isEmpty) return [];
    try {
      final decoded = json.decode(jsonStr);
      if (decoded is List) {
        return decoded.map((item) => NonConformance.fromJson(item as Map<String, dynamic>)).toList();
      }
    } catch (_) {}
    return [];
  }

  List<InspectionPhoto> _parsePhotos(String? jsonStr) {
    if (jsonStr == null || jsonStr.isEmpty) return [];
    try {
      final decoded = json.decode(jsonStr);
      if (decoded is List) {
        return decoded.map((item) => InspectionPhoto.fromJson(item as Map<String, dynamic>)).toList();
      }
    } catch (_) {}
    return [];
  }

  InspectionSignatures _parseSignatures(String? jsonStr) {
    if (jsonStr == null || jsonStr.isEmpty) {
      return const InspectionSignatures(inspector: '', contractor: '', qaqc: '');
    }
    try {
      final decoded = json.decode(jsonStr);
      if (decoded is Map<String, dynamic>) {
        return InspectionSignatures.fromJson(decoded);
      }
    } catch (_) {}
    return const InspectionSignatures(inspector: '', contractor: '', qaqc: '');
  }
}
