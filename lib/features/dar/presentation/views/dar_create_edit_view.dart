import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:mhgo/core/theme/app_theme.dart';
import 'package:mhgo/core/widgets/app_card.dart';
import 'package:mhgo/core/widgets/app_button.dart';
import 'package:mhgo/core/database/models/project_model.dart';
import 'package:mhgo/features/dar/domain/entities/dar_entities.dart';
import 'package:mhgo/features/dar/presentation/providers/dar_provider.dart';
import 'package:mhgo/features/projects/presentation/providers/projects_provider.dart';
import 'package:mhgo/features/dashboard/presentation/providers/dashboard_provider.dart';
import 'package:mhgo/features/notifications/presentation/providers/notification_provider.dart';

enum DarFormMode { create, edit }

class DarCreateEditView extends ConsumerStatefulWidget {
  final DarFormMode mode;
  final String? id;

  const DarCreateEditView({super.key, required this.mode, this.id});

  @override
  ConsumerState<DarCreateEditView> createState() => _DarCreateEditViewState();
}

class _DarCreateEditViewState extends ConsumerState<DarCreateEditView> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();

  // --- State values ---
  late String _darId;
  String? _selectedProjectUuid;
  String? _selectedProjectName;
  DateTime _reportDate = DateTime.now();
  final _preparedByController = TextEditingController();
  String _reportingPeriod = 'Day Shift';

  String _weather = 'Sunny';
  final _temperatureController = TextEditingController(text: '30.0');
  String _windCondition = 'Light';
  String _siteCondition = 'Dry';

  // Dynamic Lists
  final List<AccomplishmentItem> _accomplishments = [];
  final List<DelayIssue> _delays = [];
  final List<DarPhoto> _photos = [];

  String _signedPrepared = '';
  String _signedChecked = '';
  String _signedApproved = '';

  bool _isLoading = false;
  bool _isSubmitting = false;

  // --- Manpower Table Data ---
  final Map<String, Map<String, int>> _manpowerData = {
    'Project Engineer': {'planned': 0, 'present': 0, 'overtime': 0},
    'Site Supervisor': {'planned': 0, 'present': 0, 'overtime': 0},
    'Electrician': {'planned': 0, 'present': 0, 'overtime': 0},
    'Civil Worker': {'planned': 0, 'present': 0, 'overtime': 0},
    'Mechanical Worker': {'planned': 0, 'present': 0, 'overtime': 0},
    'Helper': {'planned': 0, 'present': 0, 'overtime': 0},
  };

  // --- Equipment Table Data ---
  final Map<String, Map<String, dynamic>> _equipmentData = {
    'Crane': {'count': 0, 'hours': 0.0},
    'Boom Truck': {'count': 0, 'hours': 0.0},
    'Excavator': {'count': 0, 'hours': 0.0},
    'Concrete Mixer': {'count': 0, 'hours': 0.0},
    'Service Vehicle': {'count': 0, 'hours': 0.0},
  };

  // --- Materials Table Data ---
  final Map<String, Map<String, dynamic>> _materialData = {
    'PV Modules': {'quantity': 0, 'unit': 'pcs'},
    'Mounting Rails': {'quantity': 0, 'unit': 'lengths'},
    'Inverters': {'quantity': 0, 'unit': 'pcs'},
    'DC Cables': {'quantity': 0, 'unit': 'meters'},
    'AC Cables': {'quantity': 0, 'unit': 'meters'},
    'Combiner Boxes': {'quantity': 0, 'unit': 'pcs'},
  };

  @override
  void initState() {
    super.initState();
    if (widget.mode == DarFormMode.edit && widget.id != null) {
      _darId = widget.id!;
      _loadExistingReport();
    } else {
      _darId = const Uuid().v4();
      _preparedByController.text = 'Dave Gigawin';
      _signedPrepared = 'Dave Gigawin';
    }
  }

  @override
  void dispose() {
    _preparedByController.dispose();
    _temperatureController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadExistingReport() async {
    setState(() => _isLoading = true);
    final repo = ref.read(darRepositoryProvider);
    final report = await repo.getDarById(_darId);
    if (report != null && mounted) {
      setState(() {
        _selectedProjectUuid = report.projectUuid;
        _selectedProjectName = report.projectName;
        _reportDate = report.reportDate;
        _preparedByController.text = report.preparedBy;
        _reportingPeriod = report.reportingPeriod;
        _weather = report.weather;
        _temperatureController.text = report.temperature.toString();
        _windCondition = report.windCondition;
        _siteCondition = report.siteCondition;
        _accomplishments.addAll(report.accomplishments);
        _delays.addAll(report.delays);
        _photos.addAll(report.photos);
        _signedPrepared = report.signedPrepared;
        _signedChecked = report.signedChecked;
        _signedApproved = report.signedApproved;

        for (var m in report.manpower) {
          if (_manpowerData.containsKey(m.category)) {
            _manpowerData[m.category] = {
              'planned': m.planned,
              'present': m.present,
              'overtime': m.overtime,
            };
          }
        }
        for (var e in report.equipment) {
          if (_equipmentData.containsKey(e.name)) {
            _equipmentData[e.name] = {'count': e.count, 'hours': e.hoursUsed};
          }
        }
        for (var mat in report.materials) {
          if (_materialData.containsKey(mat.name)) {
            _materialData[mat.name]!['quantity'] = mat.quantity;
          }
        }
      });
    }
    if (mounted) setState(() => _isLoading = false);
  }

  DarReport _assembleReport(String status) {
    final manpowerList = <ManpowerAccomplishment>[];
    _manpowerData.forEach((category, data) {
      if ((data['present'] ?? 0) > 0 || (data['planned'] ?? 0) > 0) {
        manpowerList.add(
          ManpowerAccomplishment(
            category: category,
            planned: data['planned'] ?? 0,
            present: data['present'] ?? 0,
            overtime: data['overtime'] ?? 0,
          ),
        );
      }
    });

    final equipmentList = <EquipmentUsage>[];
    _equipmentData.forEach((name, data) {
      if ((data['count'] as int) > 0) {
        equipmentList.add(
          EquipmentUsage(
            name: name,
            count: data['count'] as int,
            hoursUsed: (data['hours'] as num).toDouble(),
          ),
        );
      }
    });

    final materialsList = <MaterialInstalled>[];
    _materialData.forEach((name, data) {
      if ((data['quantity'] as int) > 0) {
        materialsList.add(
          MaterialInstalled(
            name: name,
            quantity: data['quantity'] as int,
            unit: data['unit'] as String,
          ),
        );
      }
    });

    final formattedDate = DateFormat('yyyyMMdd').format(_reportDate);
    final darNumber = widget.mode == DarFormMode.edit
        ? 'DAR-$formattedDate-${_darId.substring(0, 4).toUpperCase()}'
        : 'DAR-$formattedDate-${_darId.substring(0, 4).toUpperCase()}';

    return DarReport(
      id: _darId,
      darNumber: darNumber,
      projectUuid: _selectedProjectUuid ?? '',
      projectName: _selectedProjectName ?? '',
      reportDate: _reportDate,
      preparedBy: _preparedByController.text,
      reportingPeriod: _reportingPeriod,
      weather: _weather,
      temperature: double.tryParse(_temperatureController.text) ?? 30.0,
      windCondition: _windCondition,
      siteCondition: _siteCondition,
      accomplishments: _accomplishments,
      manpower: manpowerList,
      equipment: equipmentList,
      materials: materialsList,
      delays: _delays,
      photos: _photos,
      signedPrepared: _signedPrepared,
      signedChecked: _signedChecked,
      signedApproved: _signedApproved,
      status: status,
      lastUpdated: DateTime.now(),
    );
  }

  Future<void> _submitReport() async {
    if (_selectedProjectUuid == null) {
      _showSnackBar('Please select a project.', isError: true);
      return;
    }
    if (!_formKey.currentState!.validate()) return;
    if (_accomplishments.isEmpty) {
      _showSnackBar(
        'Add at least one daily accomplishment record.',
        isError: true,
      );
      return;
    }

    setState(() => _isSubmitting = true);
    final report = _assembleReport('Submitted');
    await ref.read(saveDarUseCaseProvider).execute(report);
    ref.invalidate(darsListProvider);
    ref.invalidate(dashboardStateProvider);

    ref.read(notificationProvider.notifier).createNotification(
      title: widget.mode == DarFormMode.create ? 'DAR Created' : 'DAR Updated',
      description: 'DAR ${report.darNumber} has been successfully submitted.',
      type: 'dar',
      relatedUuid: report.id,
      targetRoute: '/dar/${report.id}',
    );

    if (mounted) {
      setState(() => _isSubmitting = false);
      _showSnackBar('DAR ${report.darNumber} submitted successfully!');
      context.pop();
    }
  }

  Future<void> _saveDraft() async {
    if (_selectedProjectUuid == null) {
      _showSnackBar(
        'Please select a project before saving draft.',
        isError: true,
      );
      return;
    }
    if (_preparedByController.text.trim().isEmpty) {
      _showSnackBar(
        'Please enter who the report is prepared by.',
        isError: true,
      );
      return;
    }
    final report = _assembleReport('Draft');
    await ref.read(saveDarUseCaseProvider).execute(report);
    ref.invalidate(darsListProvider);
    ref.invalidate(dashboardStateProvider);

    ref.read(notificationProvider.notifier).createNotification(
      title: 'DAR Draft Saved',
      description: 'DAR ${report.darNumber} has been saved as a draft.',
      type: 'dar',
      relatedUuid: report.id,
      targetRoute: '/dar/${report.id}',
    );

    if (mounted) _showSnackBar('Draft saved.');
  }

  void _showSnackBar(String msg, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError
            ? const Color(0xFFD32F2F)
            : const Color(0xFF2E7D32),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final projectsAsync = ref.watch(projectsListProvider);
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isDesktop = screenWidth >= 1000;

    return Scaffold(
      backgroundColor: isDark ? AppTheme.darkBg : AppTheme.lightBg,
      appBar: AppBar(
        title: Text(
          widget.mode == DarFormMode.create
              ? 'Create Daily Accomplishment Report'
              : 'Edit Daily Accomplishment Report',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
          ),
        ),
        actions: [
          if (_selectedProjectUuid != null)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: AppButton(
                text: 'Save Draft',
                icon: Icons.save_outlined,
                variant: AppButtonVariant.outlined,
                onPressed: _saveDraft,
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
                    horizontal: isDesktop ? 48 : 20,
                    vertical: 24,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1100),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildProjectInfoSection(
                            projectsAsync,
                            theme,
                            isDark,
                            isDesktop,
                          ),
                          const SizedBox(height: 28),
                          _buildWeatherSection(theme, isDark, isDesktop),
                          const SizedBox(height: 28),
                          _buildAccomplishmentsSection(theme, isDark),
                          const SizedBox(height: 28),
                          _buildManpowerSection(theme, isDark),
                          const SizedBox(height: 28),
                          _buildEquipmentSection(theme, isDark, isDesktop),
                          const SizedBox(height: 28),
                          _buildMaterialsSection(theme, isDark, isDesktop),
                          const SizedBox(height: 28),
                          _buildDelaysSection(theme, isDark),
                          const SizedBox(height: 28),
                          _buildPhotosSection(theme, isDark),
                          const SizedBox(height: 28),
                          _buildSignaturesSection(theme, isDark, isDesktop),
                          const SizedBox(height: 48),
                          _buildSubmitArea(theme, isDark),
                          const SizedBox(height: 64),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  // ─── SECTION HEADER ────────────────────────────────────────
  Widget _sectionHeader(String title, IconData icon, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: theme.colorScheme.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: theme.colorScheme.primary,
                letterSpacing: -0.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════════════
  // 1. PROJECT & PERIOD CONFIGURATION
  // ════════════════════════════════════════════════════════════
  Widget _buildProjectInfoSection(
    AsyncValue<List<ProjectModel>> projectsAsync,
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
          _sectionHeader(
            'Project & Period Configuration',
            Icons.assignment_outlined,
            theme,
          ),
          projectsAsync.when(
            loading: () => const LinearProgressIndicator(),
            error: (e, _) => Text('Error: $e'),
            data: (projects) {
              return DropdownButtonFormField<String?>(
                value: _selectedProjectUuid,
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: 'Select Project',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.folder_open_outlined),
                ),
                validator: (val) =>
                    val == null ? 'Project selection is required' : null,
                items: projects.map((p) {
                  return DropdownMenuItem(
                    value: p.uuid,
                    child: Text(p.name, overflow: TextOverflow.ellipsis),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    final proj = projects.firstWhere((p) => p.uuid == val);
                    setState(() {
                      _selectedProjectUuid = val;
                      _selectedProjectName = proj.name;
                    });
                  }
                },
              );
            },
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              SizedBox(
                width: isDesktop ? 280 : double.infinity,
                child: InkWell(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _reportDate,
                      firstDate: DateTime(2025),
                      lastDate: DateTime(2030),
                    );
                    if (picked != null) setState(() => _reportDate = picked);
                  },
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Report Date',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.calendar_today_outlined),
                    ),
                    child: Text(
                      DateFormat('MMMM dd, yyyy').format(_reportDate),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: isDesktop ? 320 : double.infinity,
                child: DropdownButtonFormField<String>(
                  value: _reportingPeriod,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    labelText: 'Reporting Period',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.schedule_outlined),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'Day Shift',
                      child: Text('Day Shift (07:00 – 16:00)'),
                    ),
                    DropdownMenuItem(
                      value: 'Night Shift',
                      child: Text('Night Shift (19:00 – 04:00)'),
                    ),
                  ],
                  onChanged: (val) {
                    if (val != null) setState(() => _reportingPeriod = val);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: isDesktop ? 400 : double.infinity,
            child: TextFormField(
              controller: _preparedByController,
              decoration: const InputDecoration(
                labelText: 'Prepared By',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person_outline),
              ),
              validator: (val) =>
                  val == null || val.trim().isEmpty ? 'Required' : null,
            ),
          ),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════════════
  // 2. WEATHER CONDITIONS
  // ════════════════════════════════════════════════════════════
  Widget _buildWeatherSection(ThemeData theme, bool isDark, bool isDesktop) {
    return AppCard(
      variant: AppCardVariant.outlined,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader(
            'Site Weather Conditions',
            Icons.cloud_queue_outlined,
            theme,
          ),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              SizedBox(
                width: isDesktop ? 240 : double.infinity,
                child: DropdownButtonFormField<String>(
                  value: _weather,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    labelText: 'Weather',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'Sunny', child: Text('☀️  Sunny')),
                    DropdownMenuItem(value: 'Rainy', child: Text('🌧️  Rainy')),
                    DropdownMenuItem(
                      value: 'Cloudy',
                      child: Text('☁️  Cloudy'),
                    ),
                    DropdownMenuItem(value: 'Windy', child: Text('💨  Windy')),
                  ],
                  onChanged: (val) {
                    if (val != null) setState(() => _weather = val);
                  },
                ),
              ),
              SizedBox(
                width: isDesktop ? 200 : double.infinity,
                child: TextFormField(
                  controller: _temperatureController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Temperature',
                    border: OutlineInputBorder(),
                    suffixText: '°C',
                  ),
                ),
              ),
              SizedBox(
                width: isDesktop ? 240 : double.infinity,
                child: DropdownButtonFormField<String>(
                  value: _windCondition,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    labelText: 'Wind',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'Light',
                      child: Text('Light Breeze'),
                    ),
                    DropdownMenuItem(
                      value: 'Moderate',
                      child: Text('Moderate Wind'),
                    ),
                    DropdownMenuItem(
                      value: 'Strong',
                      child: Text('Strong Gusts'),
                    ),
                  ],
                  onChanged: (val) {
                    if (val != null) setState(() => _windCondition = val);
                  },
                ),
              ),
              SizedBox(
                width: isDesktop ? 240 : double.infinity,
                child: DropdownButtonFormField<String>(
                  value: _siteCondition,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    labelText: 'Terrain',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'Dry', child: Text('Dry / Clear')),
                    DropdownMenuItem(value: 'Muddy', child: Text('Muddy')),
                    DropdownMenuItem(
                      value: 'Flooded',
                      child: Text('Waterlogged'),
                    ),
                    DropdownMenuItem(value: 'Normal', child: Text('Normal')),
                  ],
                  onChanged: (val) {
                    if (val != null) setState(() => _siteCondition = val);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════════════
  // 3. ACCOMPLISHMENTS
  // ════════════════════════════════════════════════════════════
  Widget _buildAccomplishmentsSection(ThemeData theme, bool isDark) {
    return AppCard(
      variant: AppCardVariant.outlined,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader(
            'Daily Construction Accomplishments',
            Icons.construction_outlined,
            theme,
          ),
          Text(
            'Record structural installations, piling counts, cable laying, and other site work.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.disabledColor,
            ),
          ),
          const SizedBox(height: 20),
          if (_accomplishments.isEmpty)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
              width: double.infinity,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.03),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: theme.dividerColor),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.playlist_add,
                    size: 40,
                    color: theme.disabledColor,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'No accomplishments recorded yet.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.disabledColor,
                    ),
                  ),
                ],
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _accomplishments.length,
              separatorBuilder: (_, __) => const Divider(height: 20),
              itemBuilder: (context, index) {
                final item = _accomplishments[index];
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 14,
                      backgroundColor: theme.colorScheme.primary.withOpacity(
                        0.1,
                      ),
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.workDescription,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '📍 ${item.areaLocation}  •  ${item.quantity} ${item.unit}',
                            style: theme.textTheme.bodySmall,
                          ),
                          if (item.remarks.isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Text(
                              'Notes: ${item.remarks}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontStyle: FontStyle.italic,
                                color: theme.disabledColor,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.delete_outline,
                        size: 18,
                        color: Color(0xFFD32F2F),
                      ),
                      onPressed: () =>
                          setState(() => _accomplishments.removeAt(index)),
                    ),
                  ],
                );
              },
            ),
          const SizedBox(height: 20),
          AppButton(
            text: 'Add Work Record',
            icon: Icons.add,
            variant: AppButtonVariant.secondary,
            onPressed: () => _showAddAccomplishmentDialog(theme),
          ),
        ],
      ),
    );
  }

  void _showAddAccomplishmentDialog(ThemeData theme) {
    final descCtrl = TextEditingController();
    final areaCtrl = TextEditingController();
    final qtyCtrl = TextEditingController();
    final unitCtrl = TextEditingController(text: 'pcs');
    final remarksCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Work Accomplishment'),
        content: SizedBox(
          width: 500,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: descCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Work Description',
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: areaCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Area / Location',
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: qtyCtrl,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Quantity',
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: unitCtrl,
                        decoration: const InputDecoration(labelText: 'Unit'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: remarksCtrl,
                  decoration: const InputDecoration(labelText: 'Remarks'),
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final qty = double.tryParse(qtyCtrl.text) ?? 0;
              if (descCtrl.text.trim().isNotEmpty &&
                  areaCtrl.text.trim().isNotEmpty &&
                  qty > 0) {
                setState(() {
                  _accomplishments.add(
                    AccomplishmentItem(
                      workDescription: descCtrl.text.trim(),
                      areaLocation: areaCtrl.text.trim(),
                      quantity: qty,
                      unit: unitCtrl.text.trim(),
                      remarks: remarksCtrl.text.trim(),
                    ),
                  );
                });
                Navigator.pop(ctx);
              }
            },
            child: const Text('Add Record'),
          ),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════════════
  // 4. MANPOWER TABLE
  // ════════════════════════════════════════════════════════════
  Widget _buildManpowerSection(ThemeData theme, bool isDark) {
    return AppCard(
      variant: AppCardVariant.outlined,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader(
            'Site Personnel Manpower',
            Icons.people_outline,
            theme,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Table(
              border: TableBorder.all(
                color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder,
                borderRadius: BorderRadius.circular(12),
              ),
              columnWidths: const {
                0: FlexColumnWidth(3),
                1: FlexColumnWidth(1.5),
                2: FlexColumnWidth(1.5),
                3: FlexColumnWidth(1.5),
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                // Header row
                TableRow(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(
                      isDark ? 0.15 : 0.06,
                    ),
                  ),
                  children: [
                    _tableHeader('Personnel Role', theme),
                    _tableHeader('Plan', theme, center: true),
                    _tableHeader('Pres', theme, center: true),
                    _tableHeader('OT', theme, center: true),
                  ],
                ),
                // Data rows
                ..._manpowerData.entries.map((entry) {
                  return TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Text(
                          entry.key,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      _buildCompactNumberInput(
                        entry.value,
                        'planned',
                        isDark,
                        theme,
                      ),
                      _buildCompactNumberInput(
                        entry.value,
                        'present',
                        isDark,
                        theme,
                      ),
                      _buildCompactNumberInput(
                        entry.value,
                        'overtime',
                        isDark,
                        theme,
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tableHeader(String text, ThemeData theme, {bool center = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Text(
        text,
        textAlign: center ? TextAlign.center : TextAlign.left,
        style: theme.textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w800,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  Widget _buildCompactNumberInput(
    Map<String, int> data,
    String key,
    bool isDark,
    ThemeData theme,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: SizedBox(
        height: 40,
        child: TextFormField(
          initialValue: data[key].toString(),
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 8,
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            filled: true,
            fillColor: isDark ? AppTheme.darkSurface : AppTheme.lightSurface,
          ),
          onChanged: (val) {
            data[key] = int.tryParse(val) ?? 0;
          },
        ),
      ),
    );
  }

  // ════════════════════════════════════════════════════════════
  // 5. EQUIPMENT SECTION
  // ════════════════════════════════════════════════════════════
  Widget _buildEquipmentSection(ThemeData theme, bool isDark, bool isDesktop) {
    return AppCard(
      variant: AppCardVariant.outlined,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader(
            'Machinery & Equipment',
            Icons.local_shipping_outlined,
            theme,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Table(
              border: TableBorder.all(
                color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder,
                borderRadius: BorderRadius.circular(12),
              ),
              columnWidths: const {
                0: FlexColumnWidth(3),
                1: FlexColumnWidth(2),
                2: FlexColumnWidth(2),
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                TableRow(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(
                      isDark ? 0.15 : 0.06,
                    ),
                  ),
                  children: [
                    _tableHeader('Equipment Name', theme),
                    _tableHeader('Qty', theme, center: true),
                    _tableHeader('Hrs', theme, center: true),
                  ],
                ),
                ..._equipmentData.entries.map((entry) {
                  return TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Text(
                          entry.key,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      _buildEquipmentNumberInput(
                        entry.value,
                        'count',
                        isDark,
                        theme,
                      ),
                      _buildEquipmentHoursInput(entry.value, isDark, theme),
                    ],
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEquipmentNumberInput(
    Map<String, dynamic> data,
    String key,
    bool isDark,
    ThemeData theme,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: SizedBox(
        height: 40,
        child: TextFormField(
          initialValue: (data[key] as int).toString(),
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 8,
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            filled: true,
            fillColor: isDark ? AppTheme.darkSurface : AppTheme.lightSurface,
          ),
          onChanged: (val) {
            data[key] = int.tryParse(val) ?? 0;
          },
        ),
      ),
    );
  }

  Widget _buildEquipmentHoursInput(
    Map<String, dynamic> data,
    bool isDark,
    ThemeData theme,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: SizedBox(
        height: 40,
        child: TextFormField(
          initialValue: (data['hours'] as double) > 0
              ? (data['hours'] as double).toString()
              : '',
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          decoration: InputDecoration(
            hintText: '0.0',
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 8,
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            filled: true,
            fillColor: isDark ? AppTheme.darkSurface : AppTheme.lightSurface,
          ),
          onChanged: (val) {
            data['hours'] = double.tryParse(val) ?? 0.0;
          },
        ),
      ),
    );
  }

  // ════════════════════════════════════════════════════════════
  // 6. MATERIALS
  // ════════════════════════════════════════════════════════════
  Widget _buildMaterialsSection(ThemeData theme, bool isDark, bool isDesktop) {
    return AppCard(
      variant: AppCardVariant.outlined,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader(
            'Materials Installed',
            Icons.inventory_2_outlined,
            theme,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Table(
              border: TableBorder.all(
                color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder,
                borderRadius: BorderRadius.circular(12),
              ),
              columnWidths: const {
                0: FlexColumnWidth(3),
                1: FlexColumnWidth(2),
                2: FlexColumnWidth(1.2),
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                TableRow(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(
                      isDark ? 0.15 : 0.06,
                    ),
                  ),
                  children: [
                    _tableHeader('Material Name', theme),
                    _tableHeader('Qty', theme, center: true),
                    _tableHeader('Unit', theme, center: true),
                  ],
                ),
                ..._materialData.entries.map((entry) {
                  return TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Text(
                          entry.key,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 6,
                        ),
                        child: SizedBox(
                          height: 40,
                          child: TextFormField(
                            initialValue: (entry.value['quantity'] as int)
                                .toString(),
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 8,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              filled: true,
                              fillColor: isDark
                                  ? AppTheme.darkSurface
                                  : AppTheme.lightSurface,
                            ),
                            onChanged: (val) {
                              entry.value['quantity'] = int.tryParse(val) ?? 0;
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Text(
                          entry.value['unit'] as String,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.disabledColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════════════
  // 7. DELAYS
  // ════════════════════════════════════════════════════════════
  Widget _buildDelaysSection(ThemeData theme, bool isDark) {
    return AppCard(
      variant: AppCardVariant.outlined,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader('Delays & Issues', Icons.warning_amber_rounded, theme),
          if (_delays.isEmpty)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              width: double.infinity,
              decoration: BoxDecoration(
                color: theme.colorScheme.secondary.withOpacity(0.03),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: theme.dividerColor),
              ),
              child: Center(
                child: Text(
                  'No delays or issues recorded.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.disabledColor,
                  ),
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _delays.length,
              separatorBuilder: (_, __) => const Divider(height: 16),
              itemBuilder: (context, index) {
                final d = _delays[index];
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      size: 18,
                      color: Color(0xFFFFB300),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            d.type,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFFFB300),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(d.description, style: theme.textTheme.bodySmall),
                          const SizedBox(height: 2),
                          Text(
                            'Impact: ${d.impactHours} hours',
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.delete_outline,
                        size: 18,
                        color: Color(0xFFD32F2F),
                      ),
                      onPressed: () => setState(() => _delays.removeAt(index)),
                    ),
                  ],
                );
              },
            ),
          const SizedBox(height: 20),
          AppButton(
            text: 'Record Delay',
            icon: Icons.add,
            variant: AppButtonVariant.secondary,
            onPressed: () => _showAddDelayDialog(theme),
          ),
        ],
      ),
    );
  }

  void _showAddDelayDialog(ThemeData theme) {
    String delayType = 'Weather Delay';
    final descCtrl = TextEditingController();
    final impactCtrl = TextEditingController(text: '1.0');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Record Delay'),
        content: SizedBox(
          width: 450,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: delayType,
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'Weather Delay',
                    child: Text('Weather Delay'),
                  ),
                  DropdownMenuItem(
                    value: 'Material Delay',
                    child: Text('Material Delay'),
                  ),
                  DropdownMenuItem(
                    value: 'Safety Issue',
                    child: Text('Safety Issue'),
                  ),
                  DropdownMenuItem(
                    value: 'Technical Issue',
                    child: Text('Technical Issue'),
                  ),
                  DropdownMenuItem(value: 'Other', child: Text('Other')),
                ],
                onChanged: (val) {
                  if (val != null) delayType = val;
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descCtrl,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: impactCtrl,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(labelText: 'Impact Hours'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final impact = double.tryParse(impactCtrl.text) ?? 0;
              if (descCtrl.text.trim().isNotEmpty && impact > 0) {
                setState(() {
                  _delays.add(
                    DelayIssue(
                      type: delayType,
                      description: descCtrl.text.trim(),
                      impactHours: impact,
                    ),
                  );
                });
                Navigator.pop(ctx);
              }
            },
            child: const Text('Record'),
          ),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════════════
  // 8. PHOTOS
  // ════════════════════════════════════════════════════════════
  Widget _buildPhotosSection(ThemeData theme, bool isDark) {
    return AppCard(
      variant: AppCardVariant.outlined,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader(
            'Site Documentation Photos',
            Icons.photo_library_outlined,
            theme,
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = constraints.maxWidth > 700
                  ? 4
                  : (constraints.maxWidth > 400 ? 3 : 2);
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
                          border: Border.all(
                            color: theme.dividerColor,
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_photo_alternate_outlined,
                              size: 32,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Add Photo',
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary,
                              ),
                            ),
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
                          child: const Center(
                            child: Icon(
                              Icons.image,
                              size: 28,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              borderRadius: const BorderRadius.vertical(
                                bottom: Radius.circular(12),
                              ),
                            ),
                            child: Text(
                              photo.caption,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: GestureDetector(
                            onTap: () =>
                                setState(() => _photos.removeAt(index)),
                            behavior: HitTestBehavior.opaque,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Color(0xFFD32F2F),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                size: 12,
                                color: Colors.white,
                              ),
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
        title: const Text('Add Photo'),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.blueGrey.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Icon(
                    Icons.camera_alt_outlined,
                    size: 32,
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: captionCtrl,
                decoration: const InputDecoration(labelText: 'Caption'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final caption = captionCtrl.text.trim().isEmpty
                  ? 'Attached Photo #${_photos.length + 1}'
                  : captionCtrl.text.trim();
              setState(() {
                _photos.add(
                  DarPhoto(
                    path: 'mock_${_photos.length + 1}.jpg',
                    caption: caption,
                  ),
                );
              });
              Navigator.pop(ctx);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════════════
  // 9. SIGNATURES
  // ════════════════════════════════════════════════════════════
  Widget _buildSignaturesSection(ThemeData theme, bool isDark, bool isDesktop) {
    return AppCard(
      variant: AppCardVariant.outlined,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader('Approvals & Sign-off', Icons.draw_outlined, theme),
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 700;
              final cards = [
                _signatureCard(
                  'Prepared By',
                  _signedPrepared,
                  (val) => setState(() => _signedPrepared = val),
                  theme,
                  isDark,
                  required: true,
                ),
                _signatureCard(
                  'Checked By (QA/QC)',
                  _signedChecked,
                  (val) => setState(() => _signedChecked = val),
                  theme,
                  isDark,
                ),
                _signatureCard(
                  'Approved By (PM)',
                  _signedApproved,
                  (val) => setState(() => _signedApproved = val),
                  theme,
                  isDark,
                ),
              ];

              if (isWide) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: cards
                      .map(
                        (card) => Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: card,
                          ),
                        ),
                      )
                      .toList(),
                );
              }
              return Column(
                children: cards
                    .map(
                      (card) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: card,
                      ),
                    )
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _signatureCard(
    String title,
    String value,
    ValueChanged<String> onChanged,
    ThemeData theme,
    bool isDark, {
    bool required = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkSurface : AppTheme.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.disabledColor,
            ),
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
                      content: SizedBox(
                        width: 350,
                        child: TextField(
                          controller: ctrl,
                          decoration: const InputDecoration(
                            labelText: 'Full Name',
                          ),
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (ctrl.text.trim().isNotEmpty) {
                              onChanged(ctrl.text.trim());
                              Navigator.pop(ctx);
                            }
                          },
                          child: const Text('Sign'),
                        ),
                      ],
                    ),
                  );
                },
                icon: const Icon(Icons.draw_outlined, size: 16),
                label: const Text('Click to Sign'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            )
          else
            Row(
              children: [
                Expanded(
                  child: Text(
                    value,
                    style: const TextStyle(
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.clear, size: 16),
                  onPressed: () => onChanged(''),
                ),
              ],
            ),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════════════
  // SUBMIT AREA
  // ════════════════════════════════════════════════════════════
  Widget _buildSubmitArea(ThemeData theme, bool isDark) {
    return Column(
      children: [
        const Divider(height: 1),
        const SizedBox(height: 32),
        Center(
          child: Column(
            children: [
              SizedBox(
                width: 360,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: _isSubmitting ? null : _submitReport,
                  icon: _isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(
                          Icons.assignment_turned_in_rounded,
                          size: 22,
                        ),
                  label: Text(
                    _isSubmitting
                        ? 'Submitting...'
                        : 'Submit Accomplishment Report',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.3,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7D32),
                    foregroundColor: Colors.white,
                    elevation: 4,
                    shadowColor: const Color(0xFF2E7D32).withOpacity(0.4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => context.pop(),
                child: Text(
                  'Cancel & Return',
                  style: TextStyle(color: theme.disabledColor),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
