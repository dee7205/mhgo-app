import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:mhgo/core/theme/app_theme.dart';
import 'package:mhgo/core/widgets/app_card.dart';
import 'package:mhgo/core/widgets/app_button.dart';
import 'package:mhgo/features/inspections/domain/entities/inspection_entities.dart';
import 'package:mhgo/features/inspections/presentation/providers/inspections_provider.dart';
import 'package:mhgo/features/projects/presentation/providers/projects_provider.dart';

enum InspectionFormMode { create, edit }

class InspectionCreateEditView extends ConsumerStatefulWidget {
  final InspectionFormMode mode;
  final String? id;

  const InspectionCreateEditView({
    super.key,
    required this.mode,
    this.id,
  });

  @override
  ConsumerState<InspectionCreateEditView> createState() => _InspectionCreateEditViewState();
}

class _InspectionCreateEditViewState extends ConsumerState<InspectionCreateEditView> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();

  late String _inspectionId;
  bool _isLoading = false;

  // Form Fields
  String? _selectedProjectUuid;
  String? _selectedProjectName;
  final _titleController = TextEditingController();
  final _timeController = TextEditingController();
  DateTime _inspectionDate = DateTime.now();
  final _areaController = TextEditingController();
  final _locationController = TextEditingController();
  final _inspectorController = TextEditingController();
  final _witnessController = TextEditingController();

  String _priority = 'Medium';
  String _inspectionType = 'General';

  // Checklist Items (Prefilled with MHG QA/QC standards)
  final List<String> _checklistNames = [
    'Foundation Dimensions',
    'Anchor Bolts',
    'Module Alignment',
    'Torque Verification',
    'Cable Routing',
    'Cable Labeling',
    'Earthing Continuity',
    'Equipment Installation',
    'Safety Compliance',
    'Housekeeping',
  ];
  List<ChecklistItem> _checklist = [];
  List<TextEditingController> _remarksControllers = [];

  // Non-Conformance Section
  final List<NonConformance> _nonConformances = [];

  // Photos Section
  final List<InspectionPhoto> _photos = [];

  // Signatures
  String _signatureInspector = '';
  String _signatureContractor = '';
  String _signatureQaqc = '';
  String _reportStatus = 'Draft';

  @override
  void initState() {
    super.initState();
    _timeController.text = DateFormat('hh:mm a').format(DateTime.now());

    if (widget.mode == InspectionFormMode.edit && widget.id != null) {
      _inspectionId = widget.id!;
      _loadExistingReport();
    } else {
      _inspectionId = const Uuid().v4();
      _inspectorController.text = 'Dave Gigawin'; // Prefill default inspector
      _signatureInspector = 'Dave Gigawin'; // Prefill signature for inspector
      
      // Initialize checklist with default items
      _checklist = _checklistNames.map((name) {
        return ChecklistItem(name: name, result: 'N/A', remarks: '');
      }).toList();

      _remarksControllers = List.generate(
        _checklist.length,
        (index) => TextEditingController(text: ''),
      );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _timeController.dispose();
    _areaController.dispose();
    _locationController.dispose();
    _inspectorController.dispose();
    _witnessController.dispose();
    _scrollController.dispose();
    for (var ctrl in _remarksControllers) {
      ctrl.dispose();
    }
    super.dispose();
  }

  Future<void> _loadExistingReport() async {
    setState(() => _isLoading = true);
    final repo = ref.read(inspectionsRepositoryProvider);
    final report = await repo.getInspectionById(_inspectionId);

    if (report != null && mounted) {
      setState(() {
        _reportStatus = report.status;
        _selectedProjectUuid = report.projectUuid.isNotEmpty ? report.projectUuid : null;
        _selectedProjectName = report.projectName;
        _titleController.text = report.title;
        _timeController.text = report.time;
        _inspectionDate = report.inspectionDate;
        _areaController.text = report.area;
        _locationController.text = report.location;
        _inspectorController.text = report.inspectorName;
        _witnessController.text = report.witness;
        _priority = report.priority;
        _inspectionType = report.inspectionType;

        _checklist = List.from(report.checklist);
        _remarksControllers = List.generate(
          _checklist.length,
          (index) => TextEditingController(text: _checklist[index].remarks),
        );

        _nonConformances.addAll(report.nonConformance);
        _photos.addAll(report.photos);

        _signatureInspector = report.signatures.inspector;
        _signatureContractor = report.signatures.contractor;
        _signatureQaqc = report.signatures.qaqc;
      });
    }
    setState(() => _isLoading = false);
  }

  // Helper for generating custom human-readable ID: INSP-YYYYMMDD-XXXX
  String _generateInspectionIdNumber() {
    final dateStr = DateFormat('yyyyMMdd').format(_inspectionDate);
    final suffix = _inspectionId.substring(0, 4).toUpperCase();
    return 'INSP-$dateStr-$suffix';
  }

  InspectionReport _assembleReport(String status) {
    // Sync checklist remarks from controllers
    final updatedChecklist = List<ChecklistItem>.generate(_checklist.length, (i) {
      return _checklist[i].copyWith(remarks: _remarksControllers[i].text.trim());
    });

    // Automatically calculate overallResult based on checklist & NC logs
    String overallResult = 'Pass';
    if (_nonConformances.isNotEmpty) {
      overallResult = 'Open NC';
    } else if (updatedChecklist.any((item) => item.result == 'Fail')) {
      overallResult = 'Fail';
    }

    final now = DateTime.now();

    return InspectionReport(
      id: _inspectionId,
      inspectionId: _generateInspectionIdNumber(),
      projectUuid: _selectedProjectUuid ?? '',
      projectName: _selectedProjectName ?? '',
      title: _titleController.text.trim().isEmpty 
          ? 'Inspection of ${_areaController.text.isNotEmpty ? _areaController.text : _inspectionType}' 
          : _titleController.text.trim(),
      inspectorName: _inspectorController.text.trim(),
      witness: _witnessController.text.trim(),
      status: status,
      priority: _priority,
      overallResult: overallResult,
      inspectionDate: _inspectionDate,
      inspectionType: _inspectionType,
      checklist: updatedChecklist,
      nonConformance: _nonConformances,
      photos: _photos,
      signatures: InspectionSignatures(
        inspector: _signatureInspector,
        contractor: _signatureContractor,
        qaqc: _signatureQaqc,
      ),
      time: _timeController.text.trim(),
      area: _areaController.text.trim(),
      location: _locationController.text.trim(),
      createdAt: widget.mode == InspectionFormMode.edit ? _inspectionDate : now,
      updatedAt: now,
      isSynced: false,
    );
  }

  Future<void> _saveDraft() async {
    // If project is not selected or inspector is empty, warn before saving
    final bool isProjEmpty = _selectedProjectUuid == null;
    final bool isInspectorEmpty = _inspectorController.text.trim().isEmpty;

    if (isProjEmpty || isInspectorEmpty) {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.warning_rounded, color: Colors.orange),
              SizedBox(width: 8),
              Text('Missing Information'),
            ],
          ),
          content: Text(
            'You are saving a draft with missing ${isProjEmpty ? 'Project Portfolio' : ''}'
            '${(isProjEmpty && isInspectorEmpty) ? ' and ' : ''}'
            '${isInspectorEmpty ? 'Inspector Name' : ''}. \n\nAre you sure you want to proceed?',
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
            ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Save Draft anyway')),
          ],
        ),
      );
      if (confirm != true) return;
    }

    setState(() => _isLoading = true);
    final report = _assembleReport('Draft');
    await ref.read(saveInspectionUseCaseProvider).execute(report);
    
    // Refresh Riverpod list
    ref.invalidate(inspectionsListProvider);
    ref.invalidate(inspectionDetailsProvider(_inspectionId));

    if (mounted) {
      _showSnackBar('Draft saved successfully.');
      context.pop();
    }
  }

  Future<void> _submitReport() async {
    if (!_formKey.currentState!.validate()) {
      _showSnackBar('Please correct form validation errors first.', isError: true);
      return;
    }

    if (_selectedProjectUuid == null) {
      _showSnackBar('Please select a project before submitting.', isError: true);
      return;
    }

    // Warn if checklist items are still marked as N/A or if there is any failed item without Non-Conformance
    final hasFails = _checklist.any((item) => item.result == 'Fail');
    if (hasFails && _nonConformances.isEmpty) {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Failed Checklist Items'),
          content: const Text(
            'You have checklist items marked as "Fail" but no Non-Conformance items logged. '
            'It is recommended to log a Non-Conformance report for failures. \n\nDo you want to submit anyway?',
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
            ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Submit Report')),
          ],
        ),
      );
      if (confirm != true) return;
    }

    setState(() => _isLoading = true);
    // Submitting sets status to Pending approval
    final report = _assembleReport('Pending');
    await ref.read(saveInspectionUseCaseProvider).execute(report);
    
    // Refresh Riverpod list
    ref.invalidate(inspectionsListProvider);
    ref.invalidate(inspectionDetailsProvider(_inspectionId));

    if (mounted) {
      _showSnackBar('Inspection Report submitted successfully!');
      context.pop();
    }
  }

  void _showSnackBar(String msg, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? AppTheme.lightError : themeColorPrimary(),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Color themeColorPrimary() {
    return Theme.of(context).colorScheme.primary;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final projectsAsync = ref.watch(projectsListProvider);
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isDesktop = screenWidth >= 900;

    return Scaffold(
      backgroundColor: isDark ? AppTheme.darkBg : AppTheme.lightBg,
      appBar: AppBar(
        title: Text(
          widget.mode == InspectionFormMode.create 
              ? 'New Site Inspection' 
              : (_reportStatus == 'Draft' ? 'Edit Draft Report' : 'Modify Report'),
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900, letterSpacing: -0.5),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: AppButton(
              text: 'Save Draft',
              icon: Icons.save_outlined,
              variant: AppButtonVariant.outlined,
              onPressed: _isLoading ? null : _saveDraft,
              height: 36,
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  padding: EdgeInsets.symmetric(
                    horizontal: isDesktop ? screenWidth * 0.1 : 16.0,
                    vertical: 24.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. Metadata General Section
                      _buildMetadataSection(projectsAsync, theme, isDark, isDesktop),
                      const SizedBox(height: 20),

                      // 2. Checklist Section
                      _buildChecklistSection(theme, isDark),
                      const SizedBox(height: 20),

                      // 3. Non-Conformance Section
                      _buildNCSection(theme, isDark),
                      const SizedBox(height: 20),

                      // 4. Photos Grid Section
                      _buildPhotosSection(theme, isDark),
                      const SizedBox(height: 20),

                      // 5. Signatures Section
                      _buildSignaturesSection(theme, isDark, isDesktop),
                      const SizedBox(height: 32),

                      // 6. Submit Area
                      Center(
                        child: AppButton(
                          text: widget.mode == InspectionFormMode.create 
                              ? 'Submit Inspection Report' 
                              : 'Update & Submit Report',
                          icon: Icons.check_circle_outline_rounded,
                          variant: AppButtonVariant.primary,
                          isFullWidth: isDesktop ? false : true,
                          width: isDesktop ? 320 : null,
                          height: 52,
                          onPressed: _submitReport,
                        ),
                      ),
                      const SizedBox(height: 48),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  // --- SECTION HEADER ---
  Widget _sectionHeader(String title, IconData icon, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Icon(icon, color: theme.colorScheme.primary, size: 22),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- 1. METADATA SECTION ---
  Widget _buildMetadataSection(
    AsyncValue<List<dynamic>> projectsAsync,
    ThemeData theme,
    bool isDark,
    bool isDesktop,
  ) {
    return AppCard(
      variant: AppCardVariant.outlined,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader('General Information', Icons.info_outline_rounded, theme),
          
          // Row 1: Project Selection & Title
          LayoutBuilder(builder: (context, constraints) {
            final isWide = constraints.maxWidth > 650;
            return Column(
              children: [
                if (isWide)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _buildProjectDropdown(projectsAsync)),
                      const SizedBox(width: 16),
                      Expanded(child: _buildTitleField()),
                    ],
                  )
                else ...[
                  _buildProjectDropdown(projectsAsync),
                  const SizedBox(height: 16),
                  _buildTitleField(),
                ],
              ],
            );
          }),
          const SizedBox(height: 16),

          // Row 2: Date Picker & Time
          LayoutBuilder(builder: (context, constraints) {
            final isWide = constraints.maxWidth > 650;
            return Column(
              children: [
                if (isWide)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _buildDatePickerField(theme)),
                      const SizedBox(width: 16),
                      Expanded(child: _buildTimeField()),
                    ],
                  )
                else ...[
                  _buildDatePickerField(theme),
                  const SizedBox(height: 16),
                  _buildTimeField(),
                ],
              ],
            );
          }),
          const SizedBox(height: 16),

          // Row 3: Area & Location
          LayoutBuilder(builder: (context, constraints) {
            final isWide = constraints.maxWidth > 650;
            return Column(
              children: [
                if (isWide)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _buildTextField(_areaController, 'Area (e.g. Inverter Station 2, Block A)', required: true)),
                      const SizedBox(width: 16),
                      Expanded(child: _buildTextField(_locationController, 'Location GPS / Coordinates (e.g. Zone 4)', required: true)),
                    ],
                  )
                else ...[
                  _buildTextField(_areaController, 'Area (e.g. Inverter Station 2, Block A)', required: true),
                  const SizedBox(height: 16),
                  _buildTextField(_locationController, 'Location GPS / Coordinates (e.g. Zone 4)', required: true),
                ],
              ],
            );
          }),
          const SizedBox(height: 16),

          // Row 4: Inspector & Witness
          LayoutBuilder(builder: (context, constraints) {
            final isWide = constraints.maxWidth > 650;
            return Column(
              children: [
                if (isWide)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _buildTextField(_inspectorController, 'Lead Inspector Name', required: true)),
                      const SizedBox(width: 16),
                      Expanded(child: _buildTextField(_witnessController, 'Witness Name (Contractor / Owner)', required: false)),
                    ],
                  )
                else ...[
                  _buildTextField(_inspectorController, 'Lead Inspector Name', required: true),
                  const SizedBox(height: 16),
                  _buildTextField(_witnessController, 'Witness Name (Contractor / Owner)', required: false),
                ],
              ],
            );
          }),
          const SizedBox(height: 16),

          // Row 5: Priority & Inspection Type
          LayoutBuilder(builder: (context, constraints) {
            final isWide = constraints.maxWidth > 650;
            return Column(
              children: [
                if (isWide)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _buildPriorityDropdown()),
                      const SizedBox(width: 16),
                      Expanded(child: _buildTypeDropdown()),
                    ],
                  )
                else ...[
                  _buildPriorityDropdown(),
                  const SizedBox(height: 16),
                  _buildTypeDropdown(),
                ],
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildProjectDropdown(AsyncValue<List<dynamic>> projectsAsync) {
    return projectsAsync.when(
      loading: () => const SizedBox(height: 52, child: Center(child: CircularProgressIndicator())),
      error: (_, __) => const Text('Error loading projects'),
      data: (projects) {
        return DropdownButtonFormField<String>(
          value: _selectedProjectUuid,
          decoration: const InputDecoration(labelText: 'Project Portfolio *'),
          validator: (val) => val == null ? 'Project portfolio is required' : null,
          items: projects.map((p) => DropdownMenuItem<String>(value: p.uuid as String, child: Text(p.name as String, overflow: TextOverflow.ellipsis))).toList(),
          onChanged: (val) {
            if (val != null) {
              final selected = projects.firstWhere((p) => p.uuid == val);
              setState(() {
                _selectedProjectUuid = val;
                _selectedProjectName = selected.name;
              });
            }
          },
        );
      },
    );
  }

  Widget _buildTitleField() {
    return TextFormField(
      controller: _titleController,
      decoration: const InputDecoration(
        labelText: 'Inspection Report Title',
        hintText: 'Enter title (Optional: auto-generated if blank)',
      ),
    );
  }

  Widget _buildDatePickerField(ThemeData theme) {
    final formatted = DateFormat('MMMM dd, yyyy').format(_inspectionDate);
    return TextFormField(
      readOnly: true,
      decoration: const InputDecoration(
        labelText: 'Inspection Date *',
        suffixIcon: Icon(Icons.calendar_today_rounded),
      ),
      controller: TextEditingController(text: formatted),
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: _inspectionDate,
          firstDate: DateTime(2020),
          lastDate: DateTime(2100),
        );
        if (picked != null) {
          setState(() {
            _inspectionDate = picked;
          });
        }
      },
    );
  }

  Widget _buildTimeField() {
    return TextFormField(
      controller: _timeController,
      decoration: const InputDecoration(
        labelText: 'Inspection Time *',
        suffixIcon: Icon(Icons.access_time_rounded),
      ),
      validator: (val) => (val == null || val.trim().isEmpty) ? 'Time is required' : null,
      onTap: () async {
        final nowTime = TimeOfDay.fromDateTime(_inspectionDate);
        final picked = await showTimePicker(
          context: context,
          initialTime: nowTime,
        );
        if (picked != null) {
          if (mounted) {
            _timeController.text = picked.format(context);
          }
        }
      },
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {required bool required}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: required ? '$label *' : label),
      validator: required
          ? (val) => (val == null || val.trim().isEmpty) ? '$label is required' : null
          : null,
    );
  }

  Widget _buildPriorityDropdown() {
    return DropdownButtonFormField<String>(
      value: _priority,
      decoration: const InputDecoration(labelText: 'Inspection Priority *'),
      items: const [
        DropdownMenuItem(value: 'Low', child: Text('Low')),
        DropdownMenuItem(value: 'Medium', child: Text('Medium')),
        DropdownMenuItem(value: 'High', child: Text('High')),
        DropdownMenuItem(value: 'Critical', child: Text('Critical')),
      ],
      onChanged: (val) {
        if (val != null) {
          setState(() => _priority = val);
        }
      },
    );
  }

  Widget _buildTypeDropdown() {
    return DropdownButtonFormField<String>(
      value: _inspectionType,
      decoration: const InputDecoration(labelText: 'Inspection Type *'),
      items: const [
        DropdownMenuItem(value: 'Civil', child: Text('Civil')),
        DropdownMenuItem(value: 'Structural', child: Text('Structural')),
        DropdownMenuItem(value: 'Electrical', child: Text('Electrical')),
        DropdownMenuItem(value: 'Mechanical', child: Text('Mechanical')),
        DropdownMenuItem(value: 'General', child: Text('General')),
      ],
      onChanged: (val) {
        if (val != null) {
          setState(() => _inspectionType = val);
        }
      },
    );
  }

  // --- 2. CHECKLIST SECTION ---
  Widget _buildChecklistSection(ThemeData theme, bool isDark) {
    return AppCard(
      variant: AppCardVariant.outlined,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader('Quality Checklist & Verification', Icons.fact_check_outlined, theme),
          const SizedBox(height: 8),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _checklist.length,
            separatorBuilder: (ctx, idx) => const Divider(height: 24),
            itemBuilder: (ctx, index) {
              final item = _checklist[index];
              return LayoutBuilder(
                builder: (context, constraints) {
                  final isCompact = constraints.maxWidth < 650;
                  
                  final headerAndToggles = Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '${index + 1}',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              item.name,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: SegmentedButton<String>(
                          style: SegmentedButton.styleFrom(
                            visualDensity: VisualDensity.compact,
                          ),
                          segments: const [
                            ButtonSegment(
                              value: 'Pass',
                              label: Text('Pass'),
                              icon: Icon(Icons.check_circle_rounded, size: 14, color: Colors.green),
                            ),
                            ButtonSegment(
                              value: 'Fail',
                              label: Text('Fail'),
                              icon: Icon(Icons.cancel_rounded, size: 14, color: Colors.red),
                            ),
                            ButtonSegment(
                              value: 'N/A',
                              label: Text('N/A'),
                              icon: Icon(Icons.remove_circle_outline_rounded, size: 14),
                            ),
                          ],
                          selected: {item.result},
                          onSelectionChanged: (newSel) {
                            setState(() {
                              _checklist[index] = item.copyWith(result: newSel.first);
                            });
                          },
                        ),
                      ),
                    ],
                  );

                  final remarksField = TextFormField(
                    controller: _remarksControllers[index],
                    decoration: const InputDecoration(
                      labelText: 'Remarks / Measurements',
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    maxLines: 1,
                  );

                  if (isCompact) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        headerAndToggles,
                        const SizedBox(height: 10),
                        remarksField,
                      ],
                    );
                  }

                  return Row(
                    children: [
                      Expanded(flex: 3, child: headerAndToggles),
                      const SizedBox(width: 16),
                      Expanded(flex: 2, child: remarksField),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  // --- 3. NON-CONFORMANCE SECTION ---
  Widget _buildNCSection(ThemeData theme, bool isDark) {
    return AppCard(
      variant: AppCardVariant.outlined,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: _sectionHeader('Non-Conformance Reports (NCR) Log', Icons.report_problem_outlined, theme)),
              AppButton(
                text: 'Add NC',
                icon: Icons.add_alert_rounded,
                variant: AppButtonVariant.outlined,
                height: 36,
                onPressed: _openAddNCDialog,
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (_nonConformances.isEmpty)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 24),
              width: double.infinity,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.02),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: theme.dividerColor.withOpacity(0.5)),
              ),
              child: Column(
                children: [
                  Icon(Icons.check_circle_outline_outlined, color: theme.colorScheme.primary, size: 28),
                  const SizedBox(height: 8),
                  Text(
                    'No non-conformance items found or logged.',
                    style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600, color: theme.disabledColor),
                  ),
                ],
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _nonConformances.length,
              separatorBuilder: (ctx, idx) => const SizedBox(height: 12),
              itemBuilder: (ctx, index) {
                final nc = _nonConformances[index];
                Color sevColor = Colors.blue;
                if (nc.severity == 'High') sevColor = Colors.red;
                if (nc.severity == 'Medium') sevColor = Colors.orange;

                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? AppTheme.darkSurface : AppTheme.lightSurface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: theme.dividerColor),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // NC severity dot indicator
                      Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.only(top: 6, right: 12),
                        decoration: BoxDecoration(color: sevColor, shape: BoxShape.circle),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Severity: ${nc.severity}',
                                  style: theme.textTheme.bodySmall?.copyWith(color: sevColor, fontWeight: FontWeight.w900),
                                ),
                                if (nc.targetCompletionDate != null)
                                  Text(
                                    'Target Date: ${DateFormat('yyyy-MM-dd').format(nc.targetCompletionDate!)}',
                                    style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              nc.description,
                              style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 6),
                            if (nc.recommendedAction.isNotEmpty) ...[
                              Text(
                                'Recommended Action: ${nc.recommendedAction}',
                                style: theme.textTheme.bodySmall,
                              ),
                              const SizedBox(height: 4),
                            ],
                            if (nc.responsiblePerson.isNotEmpty)
                              Text(
                                'Responsible: ${nc.responsiblePerson}',
                                style: theme.textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic),
                              ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                        onPressed: () {
                          setState(() {
                            _nonConformances.removeAt(index);
                          });
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  void _openAddNCDialog() {
    final descCtrl = TextEditingController();
    final actionCtrl = TextEditingController();
    final respCtrl = TextEditingController();
    String sev = 'Medium';
    DateTime? targetDate = DateTime.now().add(const Duration(days: 7));

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) {
          final formattedDate = targetDate != null ? DateFormat('MMMM dd, yyyy').format(targetDate!) : 'Select Date';
          
          return AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.add_alert_rounded, color: Colors.orange),
                SizedBox(width: 8),
                Text('Log Non-Conformance'),
              ],
            ),
            content: SingleChildScrollView(
              child: SizedBox(
                width: 450,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: descCtrl,
                      decoration: const InputDecoration(labelText: 'Description of Defect *'),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: sev,
                      decoration: const InputDecoration(labelText: 'Severity *'),
                      items: const [
                        DropdownMenuItem(value: 'Low', child: Text('Low')),
                        DropdownMenuItem(value: 'Medium', child: Text('Medium')),
                        DropdownMenuItem(value: 'High', child: Text('High')),
                      ],
                      onChanged: (val) {
                        if (val != null) {
                          setDialogState(() => sev = val);
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: actionCtrl,
                      decoration: const InputDecoration(labelText: 'Recommended Action'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: respCtrl,
                      decoration: const InputDecoration(labelText: 'Responsible Person / subcontractor'),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Target Completion Date:'),
                        TextButton(
                          onPressed: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: targetDate ?? DateTime.now(),
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2100),
                            );
                            if (picked != null) {
                              setDialogState(() => targetDate = picked);
                            }
                          },
                          child: Text(formattedDate, style: const TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
              ElevatedButton(
                onPressed: () {
                  if (descCtrl.text.trim().isEmpty) {
                    return;
                  }
                  setState(() {
                    _nonConformances.add(NonConformance(
                      description: descCtrl.text.trim(),
                      severity: sev,
                      recommendedAction: actionCtrl.text.trim(),
                      responsiblePerson: respCtrl.text.trim(),
                      targetCompletionDate: targetDate,
                    ));
                  });
                  Navigator.pop(ctx);
                },
                child: const Text('Log Defect'),
              ),
            ],
          );
        },
      ),
    );
  }

  // --- 4. PHOTOS SECTION ---
  Widget _buildPhotosSection(ThemeData theme, bool isDark) {
    return AppCard(
      variant: AppCardVariant.outlined,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader('Inspection Documentation Photos', Icons.photo_library_outlined, theme),
          LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = constraints.maxWidth > 700 ? 4 : (constraints.maxWidth > 400 ? 3 : 2);
              final itemCount = _photos.length + 1;

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.2,
                ),
                itemCount: itemCount,
                itemBuilder: (context, index) {
                  if (index == _photos.length) {
                    return GestureDetector(
                      onTap: _simulatePhotoUpload,
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withOpacity(0.04),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: theme.dividerColor, style: BorderStyle.solid),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_photo_alternate_outlined, size: 32, color: theme.colorScheme.primary),
                            const SizedBox(height: 8),
                            Text('Add Photo', style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.primary)),
                          ],
                        ),
                      ),
                    );
                  }

                  final photo = _photos[index];
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: theme.dividerColor),
                    ),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.blueGrey.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(child: Icon(Icons.image, size: 28, color: Colors.grey)),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
                            ),
                            child: Text(photo.caption, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontSize: 10)),
                          ),
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: GestureDetector(
                            onTap: () => setState(() => _photos.removeAt(index)),
                            behavior: HitTestBehavior.opaque,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(color: Color(0xFFD32F2F), shape: BoxShape.circle),
                              child: const Icon(Icons.close, size: 12, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  void _simulatePhotoUpload() {
    final captionCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Documentation Photo'),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(color: Colors.blueGrey.withOpacity(0.08), borderRadius: BorderRadius.circular(8)),
                child: const Center(child: Icon(Icons.camera_alt_outlined, size: 32, color: Colors.grey)),
              ),
              const SizedBox(height: 16),
              TextField(controller: captionCtrl, decoration: const InputDecoration(labelText: 'Photo Caption / Location description')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final caption = captionCtrl.text.trim().isEmpty 
                  ? 'Attached Photo #${_photos.length + 1}' 
                  : captionCtrl.text.trim();
              setState(() {
                _photos.add(InspectionPhoto(
                  path: 'mock_${_photos.length + 1}.jpg', 
                  caption: caption,
                ));
              });
              Navigator.pop(ctx);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  // --- 5. SIGNATURES SECTION ---
  Widget _buildSignaturesSection(ThemeData theme, bool isDark, bool isDesktop) {
    return AppCard(
      variant: AppCardVariant.outlined,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader('Approvals & Sign-off Signatures', Icons.draw_outlined, theme),
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 700;
              final cards = [
                _signatureCard('Lead Inspector Sign-off', _signatureInspector, (val) => setState(() => _signatureInspector = val), theme, isDark, required: true),
                _signatureCard('Contractor Witness Sign-off', _signatureContractor, (val) => setState(() => _signatureContractor = val), theme, isDark, required: false),
                _signatureCard('QA/QC Representative Sign-off', _signatureQaqc, (val) => setState(() => _signatureQaqc = val), theme, isDark, required: false),
              ];

              if (isWide) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: cards.map((card) => Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 6), child: card))).toList(),
                );
              }
              return Column(
                children: cards.map((card) => Padding(padding: const EdgeInsets.only(bottom: 12), child: card)).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _signatureCard(String title, String value, ValueChanged<String> onChanged, ThemeData theme, bool isDark, {bool required = false}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkSurface : AppTheme.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            required ? '$title *' : title,
            style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700, color: theme.disabledColor),
          ),
          const SizedBox(height: 16),
          if (value.isEmpty)
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  final ctrl = TextEditingController();
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text('Sign as $title'),
                      content: SizedBox(width: 350, child: TextField(controller: ctrl, decoration: const InputDecoration(labelText: 'Enter Full Name for digital signature'))),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                        ElevatedButton(
                          onPressed: () { if (ctrl.text.trim().isNotEmpty) { onChanged(ctrl.text.trim()); Navigator.pop(ctx); } },
                          child: const Text('Sign'),
                        ),
                      ],
                    ),
                  );
                },
                icon: const Icon(Icons.draw_rounded, size: 16),
                label: const Text('Click to Sign'),
                style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
              ),
            )
          else
            Row(
              children: [
                Expanded(
                  child: Text(
                    value,
                    style: const TextStyle(
                      fontFamily: 'Courier',
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                IconButton(icon: const Icon(Icons.clear, size: 16), onPressed: () => onChanged('')),
              ],
            ),
        ],
      ),
    );
  }
}
