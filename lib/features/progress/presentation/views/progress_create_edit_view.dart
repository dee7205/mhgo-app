import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/progress_entities.dart';
import '../providers/progress_provider.dart';
import '../../../../core/database/isar_service.dart';
import '../../../../core/database/models/project_model.dart';
import 'package:isar_community/isar.dart';

class ProgressCreateEditView extends ConsumerStatefulWidget {
  final String id; // The project UUID (report UUID)
  const ProgressCreateEditView({super.key, required this.id});

  @override
  ConsumerState<ProgressCreateEditView> createState() =>
      _ProgressCreateEditViewState();
}

class _ProgressCreateEditViewState
    extends ConsumerState<ProgressCreateEditView> {
  final _formKey = GlobalKey<FormState>();
  final _progressController = TextEditingController(text: '0');

  String? _categoryId;
  bool _isInit = false;
  bool _isLoading = false;

  String _name = '';
  String _description = '';
  double _progress = 0.0;
  String _status = 'Not Started';
  DateTime? _targetDate;
  String _notes = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      final queryParams = GoRouterState.of(context).uri.queryParameters;
      _categoryId = queryParams['categoryId'];

      if (_categoryId != null) {
        _loadExistingCategory();
      }
      _isInit = true;
    }
  }

  void _loadExistingCategory() {
    final reportsAsync = ref.read(progressNotifierProvider);
    final report = reportsAsync.value?.cast<ProgressReport?>().firstWhere(
      (r) => r?.uuid == widget.id || r?.projectUuid == widget.id,
      orElse: () => null,
    );
    if (report != null) {
      try {
        final category = report.categories.firstWhere(
          (c) => c.id == _categoryId,
        );
        setState(() {
          _name = category.name;
          _description = category.description ?? '';
          _progress = category.progress;
          _progressController.text = _progress.toStringAsFixed(0);
          _status = category.status;
          _targetDate = category.targetDate;
          _notes = category.notes ?? '';
        });
      } catch (e) {
        // Category not found
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _targetDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _targetDate = picked);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() => _isLoading = true);

    try {
      final reportsAsync = ref.read(progressNotifierProvider);
      var report = reportsAsync.value?.cast<ProgressReport?>().firstWhere(
        (r) => r?.uuid == widget.id || r?.projectUuid == widget.id,
        orElse: () => null,
      );

      bool isNewReport = false;
      if (report == null || report.uuid.isEmpty) {
        // Find the project via Isar to get details
        final isarService = ref.read(isarServiceProvider);
        final project = await isarService.isar.projectModels
            .filter()
            .uuidEqualTo(widget.id)
            .findFirst();
        if (project == null)
          throw Exception('Project not found to attach progress.');

        isNewReport = true;
        report = ProgressReport(
          uuid: widget.id,
          projectUuid: widget.id,
          projectName: project.name,
          categories: [],
          overallProgress: 0.0,
          isAutoCalculated: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          isSynced: false,
        );
      }

      final notifier = ref.read(progressNotifierProvider.notifier);
      final nav = GoRouter.of(context);
      final scaffold = ScaffoldMessenger.of(context);
      final isEdit = _categoryId != null;

      nav.pop();
      scaffold.showSnackBar(
        SnackBar(
          content: Text(
            isEdit
                ? 'Category updated successfully'
                : 'Category added successfully',
          ),
        ),
      );

      if (isEdit && !isNewReport) {
        // Edit existing
        final existing = report.categories.firstWhere(
          (c) => c.id == _categoryId,
        );
        final updatedCategory = existing.copyWith(
          name: _name,
          description: _description.isEmpty ? null : _description,
          progress: _progress,
          status: _status,
          targetDate: _targetDate,
          notes: _notes.isEmpty ? null : _notes,
          lastUpdated: DateTime.now(),
        );
        await notifier.updateCategory(widget.id, updatedCategory);
      } else {
        // Create new
        final newCategory = ProgressCategory(
          id: const Uuid().v4(),
          name: _name,
          description: _description.isEmpty ? null : _description,
          progress: _progress,
          status: _status,
          targetDate: _targetDate,
          lastUpdated: DateTime.now(),
          notes: _notes.isEmpty ? null : _notes,
          isArchived: false,
          orderIndex: report.categories.length,
        );

        if (isNewReport) {
          final updatedReport = report.copyWith(
            categories: [newCategory],
            overallProgress: newCategory.progress,
          );
          await notifier.saveReport(updatedReport);
        } else {
          await notifier.addCategory(widget.id, newCategory);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isEditing = _categoryId != null;

    return Scaffold(
      backgroundColor: isDark ? AppTheme.darkBg : AppTheme.lightBg,
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Category' : 'Add Category'),
        backgroundColor: isDark ? AppTheme.darkSurface : AppTheme.lightSurface,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Card(
            elevation: 0,
            color: isDark ? AppTheme.darkSurface : AppTheme.lightSurface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: isDark ? Colors.white12 : Colors.black12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Category Details',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Name
                  TextFormField(
                    initialValue: _name,
                    decoration: const InputDecoration(
                      labelText: 'Category Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (val) => val == null || val.trim().isEmpty
                        ? 'Name is required'
                        : null,
                    onSaved: (val) => _name = val!.trim(),
                  ),
                  const SizedBox(height: 16),

                  // Description
                  TextFormField(
                    initialValue: _description,
                    decoration: const InputDecoration(
                      labelText: 'Description (Optional)',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 2,
                    onSaved: (val) => _description = val?.trim() ?? '',
                  ),
                  const SizedBox(height: 16),

                  // Status
                  DropdownButtonFormField<String>(
                    isExpanded: true,
                    decoration: const InputDecoration(
                      labelText: 'Status',
                      border: OutlineInputBorder(),
                    ),
                    value: _status,
                    items:
                        [
                              'Not Started',
                              'On Track',
                              'At Risk',
                              'Delayed',
                              'Completed',
                            ]
                            .map(
                              (d) => DropdownMenuItem(value: d, child: Text(d)),
                            )
                            .toList(),
                    onChanged: (val) => setState(() => _status = val!),
                    onSaved: (val) => _status = val ?? 'Not Started',
                  ),
                  const SizedBox(height: 16),

                  // Progress Slider & Input
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Progress: ${(_progress.isNaN || _progress.isInfinite ? 0 : _progress).toStringAsFixed(1)}%',
                              style: theme.textTheme.bodyMedium,
                            ),
                            Slider(
                              value:
                                  (_progress.isNaN || _progress.isInfinite
                                          ? 0.0
                                          : _progress)
                                      .clamp(0.0, 100.0),
                              min: 0,
                              max: 100,
                              divisions: 100,
                              onChanged: (val) {
                                setState(() => _progress = val);
                                final formatted = val.toStringAsFixed(0);
                                if (_progressController.text != formatted) {
                                  _progressController.value =
                                      _progressController.value.copyWith(
                                        text: formatted,
                                        selection: TextSelection.collapsed(
                                          offset: formatted.length,
                                        ),
                                      );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 1,
                        child: TextFormField(
                          controller: _progressController,
                          decoration: const InputDecoration(
                            labelText: '%',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          onChanged: (val) {
                            final p = double.tryParse(val);
                            if (p != null && p >= 0 && p <= 100) {
                              setState(() => _progress = p);
                            }
                          },
                          onSaved: (val) {
                            final p = double.tryParse(val ?? '0');
                            if (p != null) _progress = p.clamp(0, 100);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Target Date
                  InkWell(
                    onTap: () => _selectDate(context),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Target Completion Date (Optional)',
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.calendar_today),
                        suffixIcon: _targetDate != null
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () =>
                                    setState(() => _targetDate = null),
                              )
                            : null,
                      ),
                      child: Text(
                        _targetDate != null
                            ? DateFormat('yyyy-MM-dd').format(_targetDate!)
                            : 'Not set',
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Notes
                  TextFormField(
                    initialValue: _notes,
                    decoration: const InputDecoration(
                      labelText: 'Notes / Remarks (Optional)',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                    onSaved: (val) => _notes = val?.trim() ?? '',
                  ),
                  const SizedBox(height: 32),

                  // Submit Button
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _submit,
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(isEditing ? 'Save Changes' : 'Add Category'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }
}
