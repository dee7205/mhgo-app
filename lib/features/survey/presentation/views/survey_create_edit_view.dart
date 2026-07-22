import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:mhgo/core/theme/app_theme.dart';
import 'package:mhgo/core/widgets/app_card.dart';
import 'package:mhgo/core/widgets/app_button.dart';
import 'package:mhgo/features/survey/domain/entities/survey_entities.dart';
import 'package:mhgo/features/survey/presentation/providers/survey_provider.dart';
import 'package:mhgo/features/notifications/presentation/providers/notification_provider.dart';
class SurveyCreateEditView extends ConsumerStatefulWidget {
  final String? uuid;

  const SurveyCreateEditView({super.key, this.uuid});

  @override
  ConsumerState<SurveyCreateEditView> createState() =>
      _SurveyCreateEditViewState();
}

class _SpecEntry {
  final TextEditingController keyController;
  final TextEditingController valueController;

  _SpecEntry({String key = '', String value = ''})
    : keyController = TextEditingController(text: key),
      valueController = TextEditingController(text: value);

  void dispose() {
    keyController.dispose();
    valueController.dispose();
  }
}

class _SurveyCreateEditViewState extends ConsumerState<SurveyCreateEditView> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();

  late String _surveyUuid;
  bool _isLoading = false;

  // Form Fields
  final _clientNameController = TextEditingController();
  final _contactNumberController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _coordinatesController = TextEditingController();

  DateTime _surveyDate = DateTime.now();

  final List<_SpecEntry> _specs = [];

  String _proposedSystem = 'On-Grid';
  final _proposedCapacityKwController = TextEditingController();

  String _status = 'Surveyed';
  final _notesController = TextEditingController();

  String? _convertedProjectUuid;

  final List<String> _systemOptions = ['On-Grid', 'Off-Grid', 'Hybrid'];

  final List<String> _statusOptions = [
    'Surveyed',
    'Quoted',
    'Waiting Client',
    'Approved',
    'Declined',
    'Converted',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.uuid != null) {
      _surveyUuid = widget.uuid!;
      _loadExistingSurvey();
    } else {
      _surveyUuid = const Uuid().v4();
      _specs.add(_SpecEntry(key: 'Roof Type'));
      _specs.add(_SpecEntry(key: 'Roof Area (sqm)'));
      _specs.add(_SpecEntry(key: 'Monthly Bill'));
    }
  }

  @override
  void dispose() {
    _clientNameController.dispose();
    _contactNumberController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _coordinatesController.dispose();
    for (var spec in _specs) {
      spec.dispose();
    }
    _proposedCapacityKwController.dispose();
    _notesController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadExistingSurvey() async {
    setState(() => _isLoading = true);
    try {
      // NOTE: Using the likely new provider names. If your survey_provider.dart
      // still uses `inspectionDetailsProvider`, please rename them to match Survey.
      final survey = await ref.read(surveyDetailsProvider(_surveyUuid).future);
      if (survey != null && mounted) {
        setState(() {
          _clientNameController.text = survey.clientName;
          _contactNumberController.text = survey.contactNumber;
          _emailController.text = survey.email;
          _addressController.text = survey.address;
          _coordinatesController.text = survey.coordinates ?? '';
          _surveyDate = survey.surveyDate;
          _specs.clear();
          survey.technicalSpecs.forEach((k, v) {
            _specs.add(_SpecEntry(key: k, value: v));
          });
          if (_specs.isEmpty) {
            _specs.add(_SpecEntry());
          }
          _proposedSystem = _systemOptions.contains(survey.proposedSystem)
              ? survey.proposedSystem
              : 'On-Grid';
          _proposedCapacityKwController.text = survey.proposedCapacityKw
              .toString();
          _status = _statusOptions.contains(survey.status)
              ? survey.status
              : 'Surveyed';
          _notesController.text = survey.notes ?? '';
          _convertedProjectUuid = survey.convertedProjectUuid;
        });
      }
    } catch (e) {
      debugPrint('Error loading survey: $e');
    }

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Survey _assembleSurvey() {
    Map<String, String> technicalSpecs = {};
    for (var spec in _specs) {
      final k = spec.keyController.text.trim();
      final v = spec.valueController.text.trim();
      if (k.isNotEmpty && v.isNotEmpty) {
        technicalSpecs[k] = v;
      }
    }

    return Survey(
      uuid: _surveyUuid,
      clientName: _clientNameController.text.trim(),
      contactNumber: _contactNumberController.text.trim(),
      email: _emailController.text.trim(),
      address: _addressController.text.trim(),
      coordinates: _coordinatesController.text.trim().isEmpty
          ? null
          : _coordinatesController.text.trim(),
      surveyDate: _surveyDate,
      technicalSpecs: technicalSpecs,
      proposedSystem: _proposedSystem,
      proposedCapacityKw:
          double.tryParse(_proposedCapacityKwController.text) ?? 0.0,
      status: _status,
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
      convertedProjectUuid: _convertedProjectUuid,
    );
  }

  Future<void> _submitSurvey() async {
    if (!_formKey.currentState!.validate()) {
      _showSnackBar(
        'Please correct form validation errors first.',
        isError: true,
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final survey = _assembleSurvey();
      await ref.read(saveSurveyUseCaseProvider).execute(survey);
      ref.invalidate(surveyListProvider);
      ref.invalidate(surveyDetailsProvider(_surveyUuid));

      ref.read(notificationProvider.notifier).createNotification(
        title: widget.uuid == null ? 'Survey Created' : 'Survey Updated',
        description: '${survey.clientName} survey has been successfully ${widget.uuid == null ? 'created' : 'updated'}.',
        type: 'survey',
        relatedUuid: survey.uuid,
        targetRoute: '/survey/${survey.uuid}',
      );

      if (mounted) {
        _showSnackBar('Survey saved successfully!');
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) context.pop();
        });
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar('Error saving survey: $e', isError: true);
        setState(() => _isLoading = false);
      }
    }
  }

  void _showSnackBar(String msg, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError
            ? AppTheme.lightError
            : Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppTheme.darkBg : AppTheme.lightBg,
      appBar: AppBar(
        title: Text(
          widget.uuid == null
              ? 'New Pre-Construction Survey'
              : 'Edit Survey Details',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 24.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildClientSection(theme),
                      const SizedBox(height: 20),
                      _buildTechnicalSection(theme),
                      const SizedBox(height: 20),
                      _buildProposalSection(theme),
                      const SizedBox(height: 32),
                      AppButton(
                        text: widget.uuid == null
                            ? 'Submit Survey'
                            : 'Update Survey',
                        icon: Icons.check_circle_outline_rounded,
                        variant: AppButtonVariant.primary,
                        height: 52,
                        onPressed: _submitSurvey,
                      ),
                      const SizedBox(height: 48),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

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

  Widget _buildClientSection(ThemeData theme) {
    return AppCard(
      variant: AppCardVariant.outlined,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _sectionHeader(
            'Client Information',
            Icons.person_outline_rounded,
            theme,
          ),
          _buildResponsiveGrid([
            _buildTextField(
              _clientNameController,
              'Client Name',
              required: true,
            ),
            _buildTextField(
              _contactNumberController,
              'Contact Number',
              required: true,
              keyboardType: TextInputType.phone,
            ),
            _buildTextField(
              _emailController,
              'Email Address',
              required: true,
              keyboardType: TextInputType.emailAddress,
            ),
            _buildTextField(_addressController, 'Address', required: true),
            _buildTextField(_coordinatesController, 'Coordinates (Optional)'),
            _buildDatePickerField(theme),
          ]),
        ],
      ),
    );
  }

  Widget _buildTechnicalSection(ThemeData theme) {
    return AppCard(
      variant: AppCardVariant.outlined,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _sectionHeader(
            'Technical Specifications',
            Icons.handyman_outlined,
            theme,
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _specs.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final spec = _specs[index];
              return Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: spec.keyController,
                      decoration: InputDecoration(
                        labelText: 'Specification Name',
                        hintText: 'e.g. Roof Type',
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 18,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      controller: spec.valueController,
                      decoration: InputDecoration(
                        labelText: 'Value',
                        hintText: 'e.g. Metal Sheet',
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 18,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? 'Required' : null,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.remove_circle_outline,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      setState(() {
                        spec.dispose();
                        _specs.removeAt(index);
                      });
                    },
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () {
                setState(() {
                  _specs.add(_SpecEntry());
                });
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Specification'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProposalSection(ThemeData theme) {
    return AppCard(
      variant: AppCardVariant.outlined,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _sectionHeader(
            'Proposal & Status',
            Icons.request_quote_outlined,
            theme,
          ),
          _buildResponsiveGrid([
            _buildDropdown(
              'Proposed System *',
              _proposedSystem,
              _systemOptions,
              (val) {
                if (val != null) setState(() => _proposedSystem = val);
              },
            ),
            _buildTextField(
              _proposedCapacityKwController,
              'Proposed Capacity (kWp)',
              required: true,
              keyboardType: TextInputType.number,
            ),
            _buildDropdown('Survey Status *', _status, _statusOptions, (val) {
              if (val != null) setState(() => _status = val);
            }),
          ]),
          const SizedBox(height: 20),
          TextFormField(
            controller: _notesController,
            decoration: InputDecoration(
              labelText: 'Notes',
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 18,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    bool required = false,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: required ? '$label *' : label,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: required
          ? (val) => (val == null || val.trim().isEmpty)
                ? '$label is required'
                : null
          : null,
    );
  }

  Widget _buildDatePickerField(ThemeData theme) {
    final formatted = DateFormat('MMMM dd, yyyy').format(_surveyDate);
    return TextFormField(
      readOnly: true,
      decoration: InputDecoration(
        labelText: 'Survey Date *',
        suffixIcon: const Icon(Icons.calendar_today_rounded),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      controller: TextEditingController(text: formatted),
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: _surveyDate,
          firstDate: DateTime(2020),
          lastDate: DateTime(2100),
        );
        if (picked != null) {
          setState(() {
            _surveyDate = picked;
          });
        }
      },
    );
  }

  Widget _buildDropdown(
    String label,
    String value,
    List<String> items,
    ValueChanged<String?> onChanged,
  ) {
    return DropdownButtonFormField<String>(
      isExpanded: true,
      decoration: InputDecoration(
        labelText: label,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      value: value,
      items: items
          .map(
            (s) => DropdownMenuItem(
              value: s,
              child: Text(s, overflow: TextOverflow.ellipsis),
            ),
          )
          .toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildResponsiveGrid(List<Widget> children) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 600;
        if (isDesktop) {
          return Wrap(
            spacing: 24,
            runSpacing: 24,
            children: children
                .map(
                  (child) => SizedBox(
                    width: (constraints.maxWidth - 24) / 2,
                    child: child,
                  ),
                )
                .toList(),
          );
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children:
                children.expand((w) => [w, const SizedBox(height: 20)]).toList()
                  ..removeLast(),
          );
        }
      },
    );
  }
}
