import 'dart:convert';
import 'package:isar_community/isar.dart';
import 'package:mhgo/core/database/models/dar_model.dart';
import 'package:mhgo/features/dar/domain/entities/dar_entities.dart';
import 'package:mhgo/features/dar/domain/repositories/dar_repository.dart';

class DarRepositoryImpl implements DarRepository {
  final Isar _isar;

  DarRepositoryImpl(this._isar);

  @override
  Future<List<DarReport>> getDars() async {
    final models = await _isar.darModels.where().sortByReportDateDesc().findAll();
    if (models.isEmpty) {
      // Seed initial mock data on first load
      final seeded = _getSeededReports();
      for (final report in seeded) {
        await saveDar(report);
      }
      return seeded;
    }
    return models.map(_modelToReport).toList();
  }

  @override
  Future<DarReport?> getDarById(String id) async {
    final model = await _isar.darModels.filter().uuidEqualTo(id).findFirst();
    if (model == null) return null;
    return _modelToReport(model);
  }

  @override
  Future<void> saveDar(DarReport report) async {
    final existing = await _isar.darModels.filter().uuidEqualTo(report.id).findFirst();

    await _isar.writeTxn(() async {
      final model = existing ?? DarModel();
      model.uuid = report.id;
      model.darNumber = report.darNumber;
      model.projectUuid = report.projectUuid;
      model.projectName = report.projectName;
      model.reportDate = report.reportDate;
      model.preparedBy = report.preparedBy;
      model.reportingPeriod = report.reportingPeriod;
      model.weather = report.weather;
      model.temperature = report.temperature;
      model.windCondition = report.windCondition;
      model.siteCondition = report.siteCondition;
      model.accomplishmentsJson = json.encode(report.accomplishments.map((a) => a.toJson()).toList());
      model.manpowerJson = json.encode(report.manpower.map((m) => m.toJson()).toList());
      model.equipmentJson = json.encode(report.equipment.map((e) => e.toJson()).toList());
      model.materialsJson = json.encode(report.materials.map((m) => m.toJson()).toList());
      model.delaysJson = json.encode(report.delays.map((d) => d.toJson()).toList());
      model.photosJson = json.encode(report.photos.map((p) => p.toJson()).toList());
      model.signedPrepared = report.signedPrepared;
      model.signedChecked = report.signedChecked;
      model.signedApproved = report.signedApproved;
      model.status = report.status;
      model.createdAt = existing?.createdAt ?? DateTime.now();
      model.updatedAt = DateTime.now();
      model.isSynced = false;

      await _isar.darModels.put(model);
    });
  }

  @override
  Future<void> deleteDar(String id) async {
    final model = await _isar.darModels.filter().uuidEqualTo(id).findFirst();
    if (model != null) {
      await _isar.writeTxn(() async {
        await _isar.darModels.delete(model.id);
      });
    }
  }

  // --- Model-to-Entity Converter ---
  DarReport _modelToReport(DarModel m) {
    return DarReport(
      id: m.uuid,
      darNumber: m.darNumber,
      projectUuid: m.projectUuid,
      projectName: m.projectName,
      reportDate: m.reportDate,
      preparedBy: m.preparedBy,
      reportingPeriod: m.reportingPeriod,
      weather: m.weather,
      temperature: m.temperature,
      windCondition: m.windCondition,
      siteCondition: m.siteCondition,
      accomplishments: _decodeList(m.accomplishmentsJson, (j) => AccomplishmentItem.fromJson(j)),
      manpower: _decodeList(m.manpowerJson, (j) => ManpowerAccomplishment.fromJson(j)),
      equipment: _decodeList(m.equipmentJson, (j) => EquipmentUsage.fromJson(j)),
      materials: _decodeList(m.materialsJson, (j) => MaterialInstalled.fromJson(j)),
      delays: _decodeList(m.delaysJson, (j) => DelayIssue.fromJson(j)),
      photos: _decodeList(m.photosJson, (j) => DarPhoto.fromJson(j)),
      signedPrepared: m.signedPrepared ?? '',
      signedChecked: m.signedChecked ?? '',
      signedApproved: m.signedApproved ?? '',
      status: m.status,
      lastUpdated: m.updatedAt,
    );
  }

  List<T> _decodeList<T>(String jsonStr, T Function(Map<String, dynamic>) fromJson) {
    try {
      final List decoded = json.decode(jsonStr) as List;
      return decoded.map((item) => fromJson(item as Map<String, dynamic>)).toList();
    } catch (_) {
      return [];
    }
  }

  // --- Seed Data ---
  List<DarReport> _getSeededReports() {
    return [
      DarReport(
        id: 'dar-seed-1',
        darNumber: 'DAR-20260714-001',
        projectUuid: 'p-1-bulacan-ground',
        projectName: 'MHG 15MW Ground-Mounted Solar Farm',
        reportDate: DateTime.now().subtract(const Duration(days: 1)),
        preparedBy: 'Joyce Cruz',
        reportingPeriod: 'Day Shift',
        weather: 'Sunny',
        temperature: 32.5,
        windCondition: 'Moderate',
        siteCondition: 'Dry',
        accomplishments: const [
          AccomplishmentItem(workDescription: 'Ramming of structural piles for Block A3 arrays.', areaLocation: 'Zone A3-East', quantity: 45, unit: 'piles', remarks: 'Target met for the day.'),
          AccomplishmentItem(workDescription: 'Trenching for DC strings cabling feed.', areaLocation: 'Inverter Station #2', quantity: 120, unit: 'meters', remarks: 'Slight delay due to rocky soil.'),
        ],
        manpower: const [
          ManpowerAccomplishment(category: 'Project Engineer', planned: 1, present: 1, overtime: 0),
          ManpowerAccomplishment(category: 'Site Supervisor', planned: 2, present: 2, overtime: 0),
          ManpowerAccomplishment(category: 'Electrician', planned: 8, present: 6, overtime: 2),
          ManpowerAccomplishment(category: 'Civil Worker', planned: 15, present: 15, overtime: 4),
          ManpowerAccomplishment(category: 'Helper', planned: 10, present: 10, overtime: 0),
        ],
        equipment: const [
          EquipmentUsage(name: 'Crane', count: 1, hoursUsed: 6.5),
          EquipmentUsage(name: 'Excavator', count: 1, hoursUsed: 8.0),
          EquipmentUsage(name: 'Service Vehicle', count: 2, hoursUsed: 4.0),
        ],
        materials: const [
          MaterialInstalled(name: 'Mounting Rails', quantity: 90, unit: 'lengths'),
          MaterialInstalled(name: 'DC Cables', quantity: 240, unit: 'meters'),
        ],
        delays: const [
          DelayIssue(type: 'Technical Issue', description: 'Excavator bucket teeth replaced.', impactHours: 1.5),
        ],
        photos: const [
          DarPhoto(path: 'mock_pile_driving.jpg', caption: 'Block A3 steel pile driving operations.'),
          DarPhoto(path: 'mock_dc_trenching.jpg', caption: 'DC cable conduit laying.'),
        ],
        signedPrepared: 'Joyce Cruz',
        signedChecked: 'John Rey',
        signedApproved: 'Dave Gigawin',
        status: 'Approved',
        lastUpdated: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
      ),
      DarReport(
        id: 'dar-seed-2',
        darNumber: 'DAR-20260715-001',
        projectUuid: 'p-2-cavite-roof',
        projectName: 'MHG 3.2MW Industrial Rooftop Phase 2',
        reportDate: DateTime.now(),
        preparedBy: 'John Rey',
        reportingPeriod: 'Day Shift',
        weather: 'Rainy',
        temperature: 27.0,
        windCondition: 'Strong',
        siteCondition: 'Muddy',
        accomplishments: const [
          AccomplishmentItem(workDescription: 'Laying PV solar panels string brackets.', areaLocation: 'Roof Area Bldg 3', quantity: 24, unit: 'brackets', remarks: 'Halted early due to lightning risk.'),
        ],
        manpower: const [
          ManpowerAccomplishment(category: 'Project Engineer', planned: 1, present: 1, overtime: 0),
          ManpowerAccomplishment(category: 'Electrician', planned: 8, present: 8, overtime: 0),
          ManpowerAccomplishment(category: 'Helper', planned: 4, present: 4, overtime: 0),
        ],
        equipment: const [
          EquipmentUsage(name: 'Boom Truck', count: 1, hoursUsed: 3.5),
        ],
        materials: const [
          MaterialInstalled(name: 'PV Modules', quantity: 48, unit: 'pcs'),
        ],
        delays: const [
          DelayIssue(type: 'Weather Delay', description: 'Heavy thunderstorm warning suspended all rooftop tasks.', impactHours: 4.0),
        ],
        photos: const [
          DarPhoto(path: 'mock_lightning.jpg', caption: 'Storm halting tasks at building #3 roof.'),
        ],
        signedPrepared: 'John Rey',
        signedChecked: 'Leo Santos',
        signedApproved: '',
        status: 'Draft',
        lastUpdated: DateTime.now(),
      ),
    ];
  }
}
