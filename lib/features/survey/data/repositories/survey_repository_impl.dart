import 'dart:convert';
import 'package:isar_community/isar.dart';
import 'package:uuid/uuid.dart';

import 'package:mhgo/core/database/models/survey_model.dart';
import 'package:mhgo/core/database/models/project_model.dart';
import 'package:mhgo/features/survey/domain/entities/survey_entities.dart';
import 'package:mhgo/features/survey/domain/repositories/survey_repository.dart';

class SurveyRepositoryImpl implements SurveyRepository {
  final Isar _isar;

  SurveyRepositoryImpl(this._isar);

  @override
  Future<List<Survey>> getAllSurveys() async {
    // Queries Isar and sorts natively by client name
    final models = await _isar.surveyModels.where().sortByClientName().findAll();
    return models.map((m) => _modelToEntity(m)).toList();
  }

  @override
  Future<Survey?> getSurveyByUuid(String uuid) async {
    final model = await _isar.surveyModels.filter().uuidEqualTo(uuid).findFirst();
    if (model == null) return null;
    
    return _modelToEntity(model);
  }

  @override
  Future<void> saveSurvey(Survey survey) async {
    final existing = await _isar.surveyModels.filter().uuidEqualTo(survey.uuid).findFirst();

    await _isar.writeTxn(() async {
      final model = existing ?? SurveyModel();
      
      // Strict 1:1 mapping based on modern fields
      model.uuid = survey.uuid;
      model.clientName = survey.clientName;
      model.contactNumber = survey.contactNumber;
      model.email = survey.email;
      model.address = survey.address;
      model.coordinates = survey.coordinates;
      model.surveyDate = survey.surveyDate;
      model.technicalSpecsJson = jsonEncode(survey.technicalSpecs);
      model.proposedSystem = survey.proposedSystem;
      model.proposedCapacityKw = survey.proposedCapacityKw;
      model.status = survey.status;
      model.notes = survey.notes;
      model.convertedProjectUuid = survey.convertedProjectUuid;
      
      model.createdAt = existing?.createdAt ?? DateTime.now();
      model.updatedAt = DateTime.now();
      model.isSynced = false;

      await _isar.surveyModels.put(model);
    });
  }

  @override
  Future<void> deleteSurvey(String uuid) async {
    final model = await _isar.surveyModels.filter().uuidEqualTo(uuid).findFirst();
    if (model != null) {
      await _isar.writeTxn(() async {
        await _isar.surveyModels.delete(model.id);
      });
    }
  }

  @override
  Future<String?> convertToProject(Survey survey) async {
    final model = await _isar.surveyModels.filter().uuidEqualTo(survey.uuid).findFirst();
    
    if (model == null) throw Exception('Survey not found in local database.');
    if (model.convertedProjectUuid != null) return model.convertedProjectUuid; // Already converted

    final newProjectUuid = 'p-${const Uuid().v4()}';
    
    // Architecting the Project Entity from Survey Context
    final project = ProjectModel()
      ..uuid = newProjectUuid
      ..name = '${model.clientName} - ${model.proposedSystem}'
      ..client = model.clientName
      ..location = model.address
      ..type = 'Rooftop' // Or mapped dynamically if needed
      ..capacity = model.proposedCapacityKw // Map directly as kWp
      ..capacityUnit = 'kWp'
      ..status = 'planning'
      ..stage = 'Engineering'
      ..progress = 0.0
      ..startDate = DateTime.now()
      ..endDate = DateTime.now().add(const Duration(days: 30))
      ..description = 'Converted from Survey: ${model.notes ?? ""}'
      ..createdAt = DateTime.now()
      ..updatedAt = DateTime.now()
      ..isSynced = false;

    // Single Atomic Transaction Guarantee
    await _isar.writeTxn(() async {
      // 1. Persist the newly born project
      await _isar.projectModels.put(project);
      
      // 2. Lock the survey by updating its status and link
      model.status = 'Converted';
      model.convertedProjectUuid = newProjectUuid;
      model.updatedAt = DateTime.now();
      
      await _isar.surveyModels.put(model);
    });

    return newProjectUuid;
  }

  // --- Entity Mapping Helper ---

  Survey _modelToEntity(SurveyModel m) {
    Map<String, String> parsedSpecs = {};
    try {
      if (m.technicalSpecsJson.isNotEmpty) {
        final decoded = jsonDecode(m.technicalSpecsJson);
        if (decoded is Map) {
          parsedSpecs = decoded.map((key, value) => MapEntry(key.toString(), value.toString()));
        }
      }
    } catch (e) {
      // Ignore
    }

    return Survey(
      uuid: m.uuid,
      clientName: m.clientName,
      contactNumber: m.contactNumber,
      email: m.email,
      address: m.address,
      coordinates: m.coordinates,
      surveyDate: m.surveyDate,
      technicalSpecs: parsedSpecs,
      proposedSystem: m.proposedSystem,
      proposedCapacityKw: m.proposedCapacityKw,
      status: m.status,
      notes: m.notes,
      convertedProjectUuid: m.convertedProjectUuid,
    );
  }
}