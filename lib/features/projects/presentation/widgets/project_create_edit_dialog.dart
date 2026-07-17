import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/database/models/project_model.dart';
import '../../../../core/database/models/progress_model.dart';
import '../../../../core/database/isar_service.dart';
import '../providers/projects_provider.dart';
import '../../../progress/presentation/providers/progress_provider.dart';
import '../../../dashboard/presentation/providers/dashboard_provider.dart';
import 'package:isar_community/isar.dart';

import '../../../materials/presentation/widgets/project_material_requirements_tab.dart';
import '../../../materials/data/models/project_material_requirement_model.dart';

class ProjectCreateEditDialog extends ConsumerStatefulWidget {
  final ProjectModel? existingProject;

  const ProjectCreateEditDialog({super.key, this.existingProject});

  @override
  ConsumerState<ProjectCreateEditDialog> createState() =>
      _ProjectCreateEditDialogState();
}

class _ProjectCreateEditDialogState
    extends ConsumerState<ProjectCreateEditDialog> {
  final _formKey = GlobalKey<FormState>();
  final _capacityController = TextEditingController();
  final _totalCostController = TextEditingController();

  String _name = '';
  String _description = '';
  String _client = '';
  String _location = '';
  String _supervisor = '';

  double _capacityMw = 0.0;
  String _capacityUnit = 'kWp';

  String _type = 'Ground Mounted';
  String _systemType = 'On-Grid';
  String _status = 'planning';
  String _stage = 'Engineering';
  double _totalCost = 0.0;

  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 90));

  String _solarBrand = '';
  String _solarWatts = '';
  String _solarVolts = '';

  String _inverterBrand = '';
  String _inverterWattage = '';
  String _inverterSerial = '';

  String _batteryBrand = '';
  String _batteryWattage = '';
  String _batteryVoltage = '';
  String _batterySerial = '';
  String _batteryAh = '';

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.existingProject != null) {
      final p = widget.existingProject!;
      _name = p.name;
      _description = p.description ?? '';
      _client = p.client ?? '';
      _location = p.location;
      _supervisor = p.supervisor ?? '';
      _capacityMw = p.capacityMw;
      _capacityUnit = p.capacityUnit ?? 'MWp';
      _capacityController.text = _capacityMw == _capacityMw.roundToDouble() 
          ? _capacityMw.toInt().toString() 
          : _capacityMw.toString();
      _type = p.type;
      _systemType = p.systemType ?? 'On-Grid';
      _status = p.status;
      _stage = p.stage ?? 'Engineering';
      _totalCost = p.totalCost;
      _totalCostController.text = _totalCost == _totalCost.roundToDouble() 
          ? _totalCost.toInt().toString() 
          : _totalCost.toStringAsFixed(2);
      _startDate = p.startDate;
      _endDate = p.endDate;
      if (p.bomSpecsJson != null) {
        try {
          final bom = jsonDecode(p.bomSpecsJson!);
          final solar = bom['solar'] as Map<String, dynamic>? ?? {};
          final inv = bom['inverter'] as Map<String, dynamic>? ?? {};
          final bat = bom['battery'] as Map<String, dynamic>? ?? {};

          _solarBrand = solar['brand'] ?? bom['panels']?.toString() ?? '';
          _solarWatts = solar['watts'] ?? '';
          _solarVolts = solar['volts'] ?? '';

          _inverterBrand = inv['brand'] ?? bom['inverter']?.toString() ?? '';
          _inverterWattage = inv['wattage'] ?? '';
          _inverterSerial = inv['serial'] ?? '';

          _batteryBrand = bat['brand'] ?? bom['battery']?.toString() ?? '';
          _batteryWattage = bat['wattage'] ?? '';
          _batteryVoltage = bat['voltage'] ?? '';
          _batterySerial = bat['serial'] ?? '';
          _batteryAh = bat['ah'] ?? '';
        } catch (_) {}
      }
    }
  }

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final initialDate = isStart ? _startDate : _endDate;
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
          if (_endDate.isBefore(_startDate)) {
            _endDate = _startDate.add(const Duration(days: 90));
          }
        } else {
          _endDate = picked;
        }
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() => _isLoading = true);

    try {
      final isar = ref.read(isarServiceProvider).isar;

      final project = widget.existingProject ?? ProjectModel()
        ..uuid = widget.existingProject?.uuid ?? 'P-${const Uuid().v4()}';

      if (widget.existingProject == null) {
        project.progress = 0.0;
        project.createdAt = DateTime.now();
        project.isSynced = false;
      }

      final typeChanged = widget.existingProject != null && widget.existingProject!.systemType != _systemType;

      project
        ..name = _name
        ..description = _description.isEmpty ? null : _description
        ..client = _client.isEmpty ? null : _client
        ..location = _location
        ..supervisor = _supervisor.isEmpty ? null : _supervisor
        ..capacityMw = double.tryParse(_capacityController.text) ?? 0.0
        ..capacityUnit = _capacityUnit
        ..type = _type
        ..systemType = _systemType
        ..status = _status
        ..stage = _stage
        ..totalCost = _totalCost
        ..startDate = _startDate
        ..endDate = _endDate
        ..bomSpecsJson = jsonEncode({
          'solar': {
            'brand': _solarBrand,
            'watts': _solarWatts,
            'volts': _solarVolts,
          },
          'inverter': {
            'brand': _inverterBrand,
            'wattage': _inverterWattage,
            'serial': _inverterSerial,
          },
          'battery': {
            'brand': _batteryBrand,
            'wattage': _batteryWattage,
            'voltage': _batteryVoltage,
            'serial': _batterySerial,
            'ah': _batteryAh,
          },
        })
        ..updatedAt = DateTime.now()
        ..isSynced = false;

      await isar.writeTxn(() async {
        await isar.projectModels.put(project); //
        if (widget.existingProject != null) {
          final progressReports = await isar.progressModels
              .filter()
              .projectUuidEqualTo(project.uuid)
              .findAll();
          for (final report in progressReports) {
            report.projectName = project.name;
            await isar.progressModels.put(report);
          }
        }
        if (widget.existingProject == null || typeChanged) {
          if (typeChanged) {
            await isar.projectMaterialRequirementModels.filter().projectUuidEqualTo(project.uuid).deleteAll();
          }
          final defaultBom = _systemType.toLowerCase().contains('on-grid') || _systemType.toLowerCase().contains('ongrid') ? onGridBom : hybridBom;
          
          for (final section in bomSections) {
            final items = defaultBom[section] ?? [];
            for (final item in items) {
              final reqModel = ProjectMaterialRequirementModel()
                ..uuid = const Uuid().v4()
                ..projectUuid = project.uuid
                ..materialUuid = item.$1
                ..unit = item.$2
                ..requiredQuantity = item.$3
                ..allocatedQuantity = 0.0
                ..createdAt = DateTime.now()
                ..updatedAt = DateTime.now()
                ..isSynced = false;
              await isar.projectMaterialRequirementModels.put(reqModel);
            }
          }
        }
      });


      ref.invalidate(projectsListProvider);
      ref.invalidate(projectDetailsProvider(project.uuid));
      ref.invalidate(progressNotifierProvider);
      ref.invalidate(dashboardStateProvider);
      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error saving project: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingProject != null;

    return AlertDialog(
      title: Text(isEditing ? 'Edit Project' : 'New Project'),
      content: SizedBox(
        width: 600,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isNarrow = constraints.maxWidth < 450;

            Widget buildResponsiveRow(
              Widget child1,
              Widget child2, [
              int flex1 = 1,
              int flex2 = 1,
            ]) {
              if (isNarrow) {
                return Column(
                  children: [child1, const SizedBox(height: 12), child2],
                );
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: flex1, child: child1),
                  const SizedBox(width: 12),
                  Expanded(flex: flex2, child: child2),
                ],
              );
            }

            return SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // BASIC INFO
                    const Text(
                      'Basic Information',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      initialValue: _name,
                      decoration: const InputDecoration(
                        labelText: 'Project Name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (val) =>
                          val == null || val.trim().isEmpty ? 'Required' : null,
                      onSaved: (val) => _name = val!.trim(),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      initialValue: _client,
                      decoration: const InputDecoration(
                        labelText: 'Client',
                        border: OutlineInputBorder(),
                      ),
                      onSaved: (val) => _client = val?.trim() ?? '',
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      initialValue: _location,
                      decoration: const InputDecoration(
                        labelText: 'Location',
                        border: OutlineInputBorder(),
                      ),
                      validator: (val) =>
                          val == null || val.trim().isEmpty ? 'Required' : null,
                      onSaved: (val) => _location = val!.trim(),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      initialValue: _description,
                      decoration: const InputDecoration(
                        labelText: 'Description (Optional)',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 2,
                      onSaved: (val) => _description = val?.trim() ?? '',
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _totalCostController,
                      decoration: const InputDecoration(
                        labelText: 'Total Project Cost (PHP)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      validator: (val) =>
                          val == null || val.trim().isEmpty ? 'Required' : null,
                      onSaved: (val) => _totalCost = double.tryParse(val ?? '0') ?? 0.0,
                    ),

                    const SizedBox(height: 24),
                    const Divider(),
                    const SizedBox(height: 12),

                    // SPECS
                    const Text(
                      'Project Specs & Profile',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    buildResponsiveRow(
                      TextFormField(
                        controller: _capacityController,
                        decoration: const InputDecoration(
                          labelText: 'Capacity',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        validator: (val) => val == null || val.trim().isEmpty
                            ? 'Required'
                            : null,
                        onSaved: (val) =>
                            _capacityMw = double.tryParse(val ?? '0') ?? 0.0,
                      ),
                      DropdownButtonFormField<String>(
                        isExpanded: true,
                        decoration: const InputDecoration(
                          labelText: 'Unit',
                          border: OutlineInputBorder(),
                        ),
                        value: ['MWp', 'kWp', 'Wp'].contains(_capacityUnit)
                            ? _capacityUnit
                            : 'MWp',
                        items: ['MWp', 'kWp', 'Wp']
                            .map(
                              (t) => DropdownMenuItem(
                                value: t,
                                child: Text(t, overflow: TextOverflow.ellipsis),
                              ),
                            )
                            .toList(),
                        onChanged: (val) {
                          if (val == null) return;
                          setState(() => _capacityUnit = val);
                        },
                      ),
                      2,
                      1,
                    ),
                    const SizedBox(height: 12),
                    buildResponsiveRow(
                      DropdownButtonFormField<String>(
                        isExpanded: true,
                        decoration: const InputDecoration(
                          labelText: 'Installation Type',
                          border: OutlineInputBorder(),
                        ),
                        value:
                            [
                              'Ground Mounted',
                              'Rooftop',
                              'Floating',
                              'Carport',
                            ].contains(_type)
                            ? _type
                            : 'Ground Mounted',
                        items:
                            ['Ground Mounted', 'Rooftop', 'Floating', 'Carport']
                                .map(
                                  (t) => DropdownMenuItem(
                                    value: t,
                                    child: Text(
                                      t,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                )
                                .toList(),
                        onChanged: (val) => setState(() => _type = val!),
                      ),
                      DropdownButtonFormField<String>(
                        isExpanded: true,
                        decoration: const InputDecoration(
                          labelText: 'System Type',
                          border: OutlineInputBorder(),
                        ),
                        value:
                            [
                              'On-Grid',
                              'Off-Grid',
                              'Hybrid',
                            ].contains(_systemType)
                            ? _systemType
                            : 'On-Grid',
                        items: ['On-Grid', 'Off-Grid', 'Hybrid']
                            .map(
                              (t) => DropdownMenuItem(
                                value: t,
                                child: Text(t, overflow: TextOverflow.ellipsis),
                              ),
                            )
                            .toList(),
                        onChanged: (val) => setState(() => _systemType = val!),
                      ),
                    ),

                    const SizedBox(height: 24),
                    const Divider(),
                    const SizedBox(height: 12),

                    // BOM SPECS
                    const Text(
                      'BOM Specifications: Solar Panels',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    buildResponsiveRow(
                      TextFormField(
                        initialValue: _solarBrand,
                        decoration: const InputDecoration(labelText: 'Brand', border: OutlineInputBorder()),
                        onChanged: (v) => _solarBrand = v,
                      ),
                      TextFormField(
                        initialValue: _solarWatts,
                        decoration: const InputDecoration(labelText: 'Watts', border: OutlineInputBorder()),
                        onChanged: (v) => _solarWatts = v,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      initialValue: _solarVolts,
                      decoration: const InputDecoration(labelText: 'Volts', border: OutlineInputBorder()),
                      onChanged: (v) => _solarVolts = v,
                    ),

                    const SizedBox(height: 24),
                    const Text(
                      'BOM Specifications: Inverter',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    buildResponsiveRow(
                      TextFormField(
                        initialValue: _inverterBrand,
                        decoration: const InputDecoration(labelText: 'Brand', border: OutlineInputBorder()),
                        onChanged: (v) => _inverterBrand = v,
                      ),
                      TextFormField(
                        initialValue: _inverterWattage,
                        decoration: const InputDecoration(labelText: 'Wattage', border: OutlineInputBorder()),
                        onChanged: (v) => _inverterWattage = v,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      initialValue: _inverterSerial,
                      decoration: const InputDecoration(labelText: 'Serial No.', border: OutlineInputBorder()),
                      onChanged: (v) => _inverterSerial = v,
                    ),

                    const SizedBox(height: 24),
                    const Text(
                      'BOM Specifications: Battery',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    buildResponsiveRow(
                      TextFormField(
                        initialValue: _batteryBrand,
                        decoration: const InputDecoration(labelText: 'Brand', border: OutlineInputBorder()),
                        onChanged: (v) => _batteryBrand = v,
                      ),
                      TextFormField(
                        initialValue: _batteryWattage,
                        decoration: const InputDecoration(labelText: 'Wattage', border: OutlineInputBorder()),
                        onChanged: (v) => _batteryWattage = v,
                      ),
                    ),
                    const SizedBox(height: 12),
                    buildResponsiveRow(
                      TextFormField(
                        initialValue: _batteryVoltage,
                        decoration: const InputDecoration(labelText: 'Voltage', border: OutlineInputBorder()),
                        onChanged: (v) => _batteryVoltage = v,
                      ),
                      TextFormField(
                        initialValue: _batteryAh,
                        decoration: const InputDecoration(labelText: 'Ah', border: OutlineInputBorder()),
                        onChanged: (v) => _batteryAh = v,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      initialValue: _batterySerial,
                      decoration: const InputDecoration(labelText: 'Serial No.', border: OutlineInputBorder()),
                      onChanged: (v) => _batterySerial = v,
                    ),

                    const SizedBox(height: 24),
                    const Divider(),
                    const SizedBox(height: 12),

                    // TIMELINE & STATUS
                    const Text(
                      'Timeline & Status',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    buildResponsiveRow(
                      InkWell(
                        onTap: () => _selectDate(context, true),
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Start Date',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.calendar_today),
                          ),
                          child: Text(
                            DateFormat('yyyy-MM-dd').format(_startDate),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () => _selectDate(context, false),
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Expected Completion',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.calendar_today),
                          ),
                          child: Text(
                            DateFormat('yyyy-MM-dd').format(_endDate),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    buildResponsiveRow(
                      DropdownButtonFormField<String>(
                        isExpanded: true,
                        decoration: const InputDecoration(
                          labelText: 'Project Stage',
                          border: OutlineInputBorder(),
                        ),
                        value:
                            [
                              'Engineering',
                              'Procurement',
                              'Civil Works',
                              'Electrical',
                              'Testing',
                              'Commissioning',
                              'O&M',
                            ].contains(_stage)
                            ? _stage
                            : 'Engineering',
                        items:
                            [
                                  'Engineering',
                                  'Procurement',
                                  'Civil Works',
                                  'Electrical',
                                  'Testing',
                                  'Commissioning',
                                  'O&M',
                                ]
                                .map(
                                  (t) => DropdownMenuItem(
                                    value: t,
                                    child: Text(
                                      t,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                )
                                .toList(),
                        onChanged: (val) => setState(() => _stage = val!),
                      ),
                      DropdownButtonFormField<String>(
                        isExpanded: true,
                        decoration: const InputDecoration(
                          labelText: 'Status',
                          border: OutlineInputBorder(),
                        ),
                        value:
                            [
                              'active',
                              'planning',
                              'construction',
                              'commissioning',
                              'completed',
                              'on_hold',
                            ].contains(_status)
                            ? _status
                            : 'planning',
                        items:
                            [
                                  'active',
                                  'planning',
                                  'construction',
                                  'commissioning',
                                  'completed',
                                  'on_hold',
                                ]
                                .map(
                                  (t) => DropdownMenuItem(
                                    value: t,
                                    child: Text(
                                      t,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                )
                                .toList(),
                        onChanged: (val) => setState(() => _status = val!),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _save,
          child: _isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(isEditing ? 'Save Changes' : 'Create Project'),
        ),
      ],
    );
  }
}
