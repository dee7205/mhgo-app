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

  String _name = '';
  String _description = '';
  String _client = '';
  String _location = '';
  String _supervisor = '';

  double _capacityMw = 0.0;
  String _capacityUnit = 'MWp';

  String _type = 'Ground Mounted';
  String _systemType = 'On-Grid';
  String _status = 'planning';
  String _stage = 'Engineering';

  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 90));

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
      _type = p.type;
      _systemType = p.systemType ?? 'On-Grid';
      _status = p.status;
      _stage = p.stage;
      _startDate = p.startDate;
      _endDate = p.endDate;
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

      project
        ..name = _name
        ..description = _description.isEmpty ? null : _description
        ..client = _client.isEmpty ? null : _client
        ..location = _location
        ..supervisor = _supervisor.isEmpty ? null : _supervisor
        ..capacityMw = _capacityMw
        ..capacityUnit = _capacityUnit
        ..type = _type
        ..systemType = _systemType
        ..status = _status
        ..stage = _stage
        ..startDate = _startDate
        ..endDate = _endDate
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
                        initialValue: _capacityMw > 0
                            ? _capacityMw.toString()
                            : '',
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
                        onChanged: (val) =>
                            setState(() => _capacityUnit = val!),
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
