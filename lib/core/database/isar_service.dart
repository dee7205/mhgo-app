import 'dart:io';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import 'package:mhgo/core/database/models/project_model.dart';
import 'package:mhgo/core/database/models/progress_model.dart';
import 'package:mhgo/core/database/models/task_model.dart';
import 'package:mhgo/features/materials/data/models/material_model.dart';
import 'package:mhgo/features/materials/data/models/project_material_requirement_model.dart';
import 'package:mhgo/core/database/models/inspection_model.dart';
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
          InspectionModelSchema,
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
          InspectionModelSchema,
          DarModelSchema,
          ProgressModelSchema,
        ],
        directory: dbDirectory.path,
        name: 'mhgo_local_db',
      );
    }

    // Populate with realistic mock data if the database is currently empty
    await _seedMockDataIfNeeded();
  }

  Future<void> _seedMockDataIfNeeded() async {
    final projectCount = await _isar.projectModels.count();
    if (projectCount > 0) return; // Already seeded

    const uuidGen = Uuid();

    // 1. Projects Mock Data
    final projects = [
      ProjectModel()
        ..uuid = 'p-1-bulacan-ground'
        ..name = 'MHG 15MW Ground-Mounted Solar Farm'
        ..description = 'EPC Ground-mounted utility scale project with grid-tied substation interconnect.'
        ..capacityMw = 15.0
        ..status = 'construction'
        ..stage = 'Civil Works'
        ..type = 'Ground Mounted'
        ..location = 'Bulacan, Philippines'
        ..supervisor = 'Engr. John Reyes'
        ..client = 'Bulacan Power Corp'
        ..progress = 0.45
        ..startDate = DateTime.now().subtract(const Duration(days: 60))
        ..endDate = DateTime.now().add(const Duration(days: 120))
        ..createdAt = DateTime.now().subtract(const Duration(days: 60))
        ..updatedAt = DateTime.now()
        ..isSynced = true,
      ProjectModel()
        ..uuid = 'p-2-cavite-roof'
        ..name = 'MHG 3.2MW Industrial Rooftop Phase 2'
        ..description = 'EPC Rooftop solar array on manufacturing facility with net metering setup.'
        ..capacityMw = 3.2
        ..status = 'construction'
        ..stage = 'Electrical'
        ..type = 'Rooftop'
        ..location = 'Cavite Economic Zone, Philippines'
        ..supervisor = 'Engr. Joyce Cruz'
        ..client = 'Semicon Manufacturing Asia'
        ..progress = 0.72
        ..startDate = DateTime.now().subtract(const Duration(days: 45))
        ..endDate = DateTime.now().add(const Duration(days: 45))
        ..createdAt = DateTime.now().subtract(const Duration(days: 45))
        ..updatedAt = DateTime.now()
        ..isSynced = true,
      ProjectModel()
        ..uuid = 'p-3-laguna-floating'
        ..name = 'MHG 50MW Floating Lake Solar'
        ..description = 'Pre-feasibility & Engineering for floating photovoltaic solar panels on Laguna Lake.'
        ..capacityMw = 50.0
        ..status = 'planning'
        ..stage = 'Engineering'
        ..type = 'Floating'
        ..location = 'Laguna Lake, Rizal'
        ..supervisor = 'Engr. Leo Santos'
        ..client = 'National Renewable Development'
        ..progress = 0.15
        ..startDate = DateTime.now().add(const Duration(days: 30))
        ..endDate = DateTime.now().add(const Duration(days: 270))
        ..createdAt = DateTime.now().subtract(const Duration(days: 10))
        ..updatedAt = DateTime.now()
        ..isSynced = true,
      ProjectModel()
        ..uuid = 'p-4-pampanga-farm'
        ..name = 'MHG Solar Farm Site Bravo'
        ..description = 'EPC Ground-mounted grid-connected commercial solar facility.'
        ..capacityMw = 25.0
        ..status = 'completed'
        ..stage = 'Grid Tie'
        ..type = 'Ground Mounted'
        ..location = 'San Fernando, Pampanga'
        ..supervisor = 'Engr. John Reyes'
        ..client = 'Luzon Grid Renewables'
        ..progress = 1.0
        ..startDate = DateTime.now().subtract(const Duration(days: 150))
        ..endDate = DateTime.now().subtract(const Duration(days: 15))
        ..createdAt = DateTime.now().subtract(const Duration(days: 150))
        ..updatedAt = DateTime.now().subtract(const Duration(days: 15))
        ..isSynced = true,
    ];

    // 2. Tasks Mock Data
    final tasks = [
      // Bulacan Ground farm
      TaskModel()
        ..uuid = 't-1'
        ..projectUuid = 'p-1-bulacan-ground'
        ..title = 'Land Clearing and Grading'
        ..description = 'Clear and level the terrain for area A1 to A4.'
        ..assignedToName = 'Civil Subcontractor'
        ..assignedToRole = 'Site Supervisor'
        ..status = 'done'
        ..priority = 'high'
        ..category = 'Civil Works'
        ..dueDate = DateTime.now().subtract(const Duration(days: 30))
        ..progress = 1.0
        ..createdAt = DateTime.now().subtract(const Duration(days: 60))
        ..updatedAt = DateTime.now().subtract(const Duration(days: 30))
        ..isSynced = true,
      TaskModel()
        ..uuid = 't-2'
        ..projectUuid = 'p-1-bulacan-ground'
        ..title = 'Pile Driving & Ramming'
        ..description = 'Drive structural mounting steel piles in A1 block.'
        ..assignedToName = 'Engr. John Reyes'
        ..assignedToRole = 'Lead Project Engineer'
        ..status = 'in_progress'
        ..priority = 'critical'
        ..category = 'Civil Works'
        ..dueDate = DateTime.now().add(const Duration(days: 14))
        ..progress = 0.65
        ..createdAt = DateTime.now().subtract(const Duration(days: 20))
        ..updatedAt = DateTime.now()
        ..isSynced = true,
      TaskModel()
        ..uuid = 't-3'
        ..projectUuid = 'p-1-bulacan-ground'
        ..title = 'Mounting Structure Assembly'
        ..description = 'Assemble brackets and purlins on completed piles.'
        ..assignedToName = 'Civil Team B'
        ..assignedToRole = 'Subcontractor'
        ..status = 'todo'
        ..priority = 'medium'
        ..category = 'Civil Works'
        ..dueDate = DateTime.now().add(const Duration(days: 30))
        ..progress = 0.0
        ..createdAt = DateTime.now().subtract(const Duration(days: 10))
        ..updatedAt = DateTime.now()
        ..isSynced = true,
      TaskModel()
        ..uuid = 't-4'
        ..projectUuid = 'p-1-bulacan-ground'
        ..title = 'DC Cable Routing Layout'
        ..description = 'Prepare DC cable trenches and route underground cables.'
        ..assignedToName = 'Engr. Marc Lim'
        ..assignedToRole = 'Electrical Engineer'
        ..status = 'blocked'
        ..priority = 'high'
        ..category = 'Electrical'
        ..dueDate = DateTime.now().add(const Duration(days: 40))
        ..progress = 0.10
        ..createdAt = DateTime.now().subtract(const Duration(days: 10))
        ..updatedAt = DateTime.now()
        ..isSynced = true,

      // Cavite Rooftop
      TaskModel()
        ..uuid = 't-5'
        ..projectUuid = 'p-2-cavite-roof'
        ..title = 'Rooftop Structural Reinforcement'
        ..description = 'Strengthen support beams for building #3.'
        ..assignedToName = 'Engr. Joyce Cruz'
        ..assignedToRole = 'Site Supervisor'
        ..status = 'done'
        ..priority = 'high'
        ..category = 'Civil Works'
        ..dueDate = DateTime.now().subtract(const Duration(days: 20))
        ..progress = 1.0
        ..createdAt = DateTime.now().subtract(const Duration(days: 45))
        ..updatedAt = DateTime.now().subtract(const Duration(days: 20))
        ..isSynced = true,
      TaskModel()
        ..uuid = 't-6'
        ..projectUuid = 'p-2-cavite-roof'
        ..title = 'PV Module Installation'
        ..description = 'Mount 5,800 modules onto building 3 & 4 rooftops.'
        ..assignedToName = 'Montage Team A'
        ..assignedToRole = 'Subcontractor'
        ..status = 'in_progress'
        ..priority = 'high'
        ..category = 'Electrical'
        ..dueDate = DateTime.now().add(const Duration(days: 10))
        ..progress = 0.85
        ..createdAt = DateTime.now().subtract(const Duration(days: 20))
        ..updatedAt = DateTime.now()
        ..isSynced = true,
      TaskModel()
        ..uuid = 't-7'
        ..projectUuid = 'p-2-cavite-roof'
        ..title = 'Inverter Mounting and Cabling'
        ..description = 'Install 20 units of Solis 110kW inverters.'
        ..assignedToName = 'Engr. Marc Lim'
        ..assignedToRole = 'Electrical Engineer'
        ..status = 'todo'
        ..priority = 'high'
        ..category = 'Electrical'
        ..dueDate = DateTime.now().add(const Duration(days: 20))
        ..progress = 0.0
        ..createdAt = DateTime.now().subtract(const Duration(days: 5))
        ..updatedAt = DateTime.now()
        ..isSynced = true,
      TaskModel()
        ..uuid = 't-8'
        ..projectUuid = 'p-2-cavite-roof'
        ..title = 'Pre-commissioning String Test'
        ..description = 'Conduct Voc and Isc checks on all strings.'
        ..assignedToName = 'Engr. Leo Santos'
        ..assignedToRole = 'QA/QC Engineer'
        ..status = 'under_review'
        ..priority = 'medium'
        ..category = 'QA/QC'
        ..dueDate = DateTime.now().add(const Duration(days: 25))
        ..progress = 0.50
        ..createdAt = DateTime.now().subtract(const Duration(days: 5))
        ..updatedAt = DateTime.now()
        ..isSynced = true,

      // Laguna Floating
      TaskModel()
        ..uuid = 't-9'
        ..projectUuid = 'p-3-laguna-floating'
        ..title = 'Geotechnical & Lake Bed Survey'
        ..description = 'Analyze lake soil samples for anchor mooring stability.'
        ..assignedToName = 'Oceanography Survey Inc'
        ..assignedToRole = 'Consultant'
        ..status = 'in_progress'
        ..priority = 'high'
        ..category = 'Engineering'
        ..dueDate = DateTime.now().add(const Duration(days: 15))
        ..progress = 0.40
        ..createdAt = DateTime.now().subtract(const Duration(days: 10))
        ..updatedAt = DateTime.now()
        ..isSynced = true,

      // Pampanga Farm
      TaskModel()
        ..uuid = 't-10'
        ..projectUuid = 'p-4-pampanga-farm'
        ..title = 'Substation Grid Interconnection'
        ..description = 'Energize substation transformer and link to 69kV transmission line.'
        ..assignedToName = 'Meralco Testing Team'
        ..assignedToRole = 'External Utility'
        ..status = 'done'
        ..priority = 'critical'
        ..category = 'Commissioning'
        ..dueDate = DateTime.now().subtract(const Duration(days: 15))
        ..progress = 1.0
        ..createdAt = DateTime.now().subtract(const Duration(days: 50))
        ..updatedAt = DateTime.now().subtract(const Duration(days: 15))
        ..isSynced = true,
    ];

    // 3. Materials Mock Data
    final materials = [
      MaterialModel()
        ..uuid = 'm-1'
        ..name = 'Jinko Tiger Neo 550W Monocrystalline PV Panel'
        ..category = 'Solar Modules'
        ..currentStock = 12400.0
        ..unit = 'pcs'
        ..minimumStock = 3000.0
        ..storageLocation = 'Main Yard - Section A'
        ..remarks = 'SKU: PV-JK-550W'
        ..createdAt = DateTime.now().subtract(const Duration(days: 100))
        ..updatedAt = DateTime.now()
        ..isSynced = true,
      MaterialModel()
        ..uuid = 'm-2'
        ..name = 'Solis 110kW 3-Phase Grid-Tied String Inverter'
        ..category = 'Inverters'
        ..currentStock = 85.0
        ..unit = 'pcs'
        ..minimumStock = 15.0
        ..storageLocation = 'Building 2 - Rack B3'
        ..remarks = 'SKU: INV-SL-110K'
        ..createdAt = DateTime.now().subtract(const Duration(days: 100))
        ..updatedAt = DateTime.now()
        ..isSynced = true,
      MaterialModel()
        ..uuid = 'm-3'
        ..name = '4mm2 XLPE Solar DC Cable - Red'
        ..category = 'DC/AC Cabling'
        ..currentStock = 45.0
        ..unit = 'rolls'
        ..minimumStock = 10.0
        ..storageLocation = 'Building 1 - Row D'
        ..remarks = 'SKU: CAB-DC-4-RD'
        ..createdAt = DateTime.now().subtract(const Duration(days: 100))
        ..updatedAt = DateTime.now()
        ..isSynced = true,
      MaterialModel()
        ..uuid = 'm-4'
        ..name = '4mm2 XLPE Solar DC Cable - Black'
        ..category = 'DC/AC Cabling'
        ..currentStock = 8.0 // Low Stock Alert
        ..unit = 'rolls'
        ..minimumStock = 10.0
        ..storageLocation = 'Building 1 - Row D'
        ..remarks = 'SKU: CAB-DC-4-BK'
        ..createdAt = DateTime.now().subtract(const Duration(days: 100))
        ..updatedAt = DateTime.now()
        ..isSynced = true,
      MaterialModel()
        ..uuid = 'm-5'
        ..name = 'HDG Al-Magnesite Ground Mount Bracket Set'
        ..category = 'Mounting Structures'
        ..currentStock = 18000.0
        ..unit = 'sets'
        ..minimumStock = 5000.0
        ..storageLocation = 'Main Yard - Section C'
        ..remarks = 'SKU: MNT-HDG-BRK'
        ..createdAt = DateTime.now().subtract(const Duration(days: 100))
        ..updatedAt = DateTime.now()
        ..isSynced = true,
    ];

    // 4. Inspections Mock Data
    final inspections = [
      InspectionModel()
        ..uuid = 'ins-1'
        ..projectUuid = 'p-2-cavite-roof'
        ..title = 'PV Array Structural Rigging Quality'
        ..inspectorName = 'Engr. Leo Santos'
        ..status = 'Rejected'
        ..inspectionDate = DateTime.now().subtract(const Duration(days: 3))
        ..notes = 'Mounting clamps on Block B Bldg 3 fail torque spec. 12% are loose. Needs tightening.'
        ..checklistJson = '{"Structural": "Fail", "Torque Check": "Fail", "Safety Harness": "Pass"}'
        ..signaturePath = ''
        ..inspectionId = 'INSP-20260712-001'
        ..inspectionType = 'Structural'
        ..time = '10:00 AM'
        ..area = 'Block B'
        ..location = 'Building 3 Roof'
        ..witness = 'Contractor Rep'
        ..priority = 'High'
        ..overallResult = 'Fail'
        ..createdAt = DateTime.now().subtract(const Duration(days: 3))
        ..updatedAt = DateTime.now().subtract(const Duration(days: 3))
        ..isSynced = true,
      InspectionModel()
        ..uuid = 'ins-2'
        ..projectUuid = 'p-1-bulacan-ground'
        ..title = 'Piling Ramming Alignment Check'
        ..inspectorName = 'Engr. Leo Santos'
        ..status = 'Pending'
        ..inspectionDate = DateTime.now().add(const Duration(days: 2))
        ..notes = 'Check structural plumbness and depth for Blocks A1-A2.'
        ..checklistJson = '{"Plumbness": "Pending", "Depth Check": "Pending"}'
        ..signaturePath = ''
        ..inspectionId = 'INSP-20260714-001'
        ..inspectionType = 'Structural'
        ..time = '02:00 PM'
        ..area = 'Blocks A1-A2'
        ..location = 'Zone 1 Plinth'
        ..witness = 'QA/QC Lead'
        ..priority = 'Medium'
        ..overallResult = 'Open NC'
        ..createdAt = DateTime.now().subtract(const Duration(days: 1))
        ..updatedAt = DateTime.now()
        ..isSynced = true,
      InspectionModel()
        ..uuid = 'ins-3'
        ..projectUuid = 'p-4-pampanga-farm'
        ..title = 'Interconnect Substation Commissioning Sign-off'
        ..inspectorName = 'Engr. Joyce Cruz'
        ..status = 'Approved'
        ..inspectionDate = DateTime.now().subtract(const Duration(days: 16))
        ..notes = 'Substation insulation resistance, phase sequence, and breaker operations pass testing protocols.'
        ..checklistJson = '{"Insulation Check": "Pass", "Phase Sequence": "Pass", "Breaker Test": "Pass"}'
        ..signaturePath = ''
        ..inspectionId = 'INSP-20260629-001'
        ..inspectionType = 'Commissioning'
        ..time = '09:30 AM'
        ..area = 'Substation'
        ..location = 'Control Room'
        ..witness = 'Utility Rep'
        ..priority = 'Critical'
        ..overallResult = 'Pass'
        ..createdAt = DateTime.now().subtract(const Duration(days: 17))
        ..updatedAt = DateTime.now().subtract(const Duration(days: 16))
        ..isSynced = true,
    ];

    // Perform database seed write in transaction
    await _isar.writeTxn(() async {
      await _isar.projectModels.putAll(projects);
      await _isar.taskModels.putAll(tasks);
      await _isar.materialModels.putAll(materials);
      await _isar.inspectionModels.putAll(inspections);

      final progressCount = await _isar.progressModels.count();
      if (progressCount == 0) {
        // Progress reports start empty on a fresh installation.
      }
    });
  }
}
