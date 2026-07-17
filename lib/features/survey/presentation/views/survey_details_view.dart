import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:mhgo/core/theme/app_theme.dart';
import 'package:mhgo/core/widgets/app_button.dart';
import 'package:mhgo/features/survey/presentation/providers/survey_provider.dart';

import 'package:mhgo/features/projects/presentation/providers/projects_provider.dart';
import 'package:mhgo/features/survey/domain/entities/survey_entities.dart';
import 'package:mhgo/features/survey/presentation/views/pdf_preview_view.dart';

class SurveyDetailsView extends ConsumerStatefulWidget {
  final String uuid;

  const SurveyDetailsView({
    super.key,
    required this.uuid,
  });

  @override
  ConsumerState<SurveyDetailsView> createState() => _SurveyDetailsViewState();
}

class _SurveyDetailsViewState extends ConsumerState<SurveyDetailsView> {
  bool _isConverting = false;

  Future<void> _convertToProject(Survey survey) async {
    setState(() => _isConverting = true);
    try {
      final repo = ref.read(surveyRepositoryProvider);
      final String? newProjectUuid = await repo.convertToProject(survey);
      ref.invalidate(surveyListProvider);
      ref.invalidate(surveyDetailsProvider(survey.uuid));
      ref.invalidate(projectsListProvider);
      
      if (mounted && newProjectUuid != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Project created successfully. Complete the remaining project details (e.g. End Date) from the Projects module.'),
            duration: Duration(seconds: 4),
          ),
        );
        context.push('/projects/$newProjectUuid');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isConverting = false);
    }
  }

  Future<void> _confirmDelete(Survey survey) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Survey'),
        content: const Text('Are you sure you want to delete this survey? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: AppTheme.lightError),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        final repo = ref.read(surveyRepositoryProvider);
        await repo.deleteSurvey(survey.uuid);
        ref.invalidate(surveyListProvider);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Survey deleted successfully')),
          );
          context.pop();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error deleting survey: $e')),
          );
        }
      }
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Approved':
        return Colors.green;
      case 'Pending Survey':
        return Colors.orange;
      case 'Waiting Client':
        return Colors.blue;
      case 'Quoted':
        return Colors.purple;
      case 'Declined':
        return Colors.red;
      case 'Converted':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final detailsAsync = ref.watch(surveyDetailsProvider(widget.uuid));

    return Scaffold(
      backgroundColor: isDark ? AppTheme.darkBg : AppTheme.lightBg,
      appBar: AppBar(
        title: Text(
          'Survey Details',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
          ),
        ),
      ),
      body: SafeArea(
        child: detailsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Error: $err')),
          data: (survey) {
            if (survey == null) {
              return const Center(child: Text('Survey not found.'));
            }

            final statusColor = _getStatusColor(survey.status);
            final formattedDate = DateFormat('EEEE, MMMM dd, yyyy').format(survey.surveyDate);

            return SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 850),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  survey.clientName,
                                  style: theme.textTheme.headlineMedium?.copyWith(
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: -1.0,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Survey Date: $formattedDate',
                                  style: theme.textTheme.bodyMedium?.copyWith(color: theme.disabledColor),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: statusColor.withAlpha(25),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: statusColor.withAlpha(51)),
                            ),
                            child: Text(
                              survey.status.toUpperCase(),
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: statusColor,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      if (survey.status == 'Approved') ...[
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            onPressed: _isConverting ? null : () => _convertToProject(survey),
                            icon: _isConverting 
                                ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                                : const Icon(Icons.check_circle_outline),
                            label: Text(_isConverting ? 'Converting...' : 'Convert to Active Project'),
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],

                      // Action Controls Row
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          AppButton(
                            text: 'Edit Survey',
                            icon: Icons.edit_document,
                            onPressed: () => context.push('/survey/edit/${survey.uuid}'),
                          ),
                          AppButton(
                            text: 'View PDF',
                            icon: Icons.picture_as_pdf,
                            onPressed: () async {
                              await Printing.layoutPdf(
                                onLayout: (format) => SurveyPdfPreviewView.generatePdfDocument(survey, format),
                                name: 'survey_report_${survey.uuid}.pdf',
                              );
                            },
                          ),
                          AppButton(
                            text: 'Delete',
                            icon: Icons.delete_outline,
                            variant: AppButtonVariant.outlined,
                            onPressed: () => _confirmDelete(survey),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const Divider(),
                      const SizedBox(height: 24),

                      // Contact Info
                      _buildSectionHeader('Client Contact Info', Icons.person, theme),
                      const SizedBox(height: 12),
                      _buildInfoRow('Contact Number', survey.contactNumber, theme, isDark),
                      _buildInfoRow('Email', survey.email, theme, isDark),
                      _buildInfoRow('Address', survey.address, theme, isDark),
                      if (survey.coordinates != null && survey.coordinates!.isNotEmpty)
                        _buildInfoRow('Coordinates', survey.coordinates!, theme, isDark),
                      
                      const SizedBox(height: 24),

                      // Technical Specifications
                      _buildSectionHeader('Technical Specifications', Icons.handyman, theme),
                      const SizedBox(height: 12),
                      if (survey.technicalSpecs.isEmpty)
                        Text(
                          'No technical specifications provided.', 
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: isDark ? AppTheme.darkTextMuted : AppTheme.lightTextMuted,
                          ),
                        )
                      else
                        ...survey.technicalSpecs.entries.map((e) => _buildInfoRow(e.key, e.value, theme, isDark)),


                      const SizedBox(height: 24),

                      // Proposed System
                      _buildSectionHeader('Proposed System', Icons.solar_power, theme),
                      const SizedBox(height: 12),
                      _buildInfoRow('System', survey.proposedSystem, theme, isDark),
                      _buildInfoRow('Capacity', '${survey.proposedCapacityKw.toStringAsFixed(2)} kW', theme, isDark),

                      if (survey.notes != null && survey.notes!.isNotEmpty) ...[
                        const SizedBox(height: 24),
                        _buildSectionHeader('Notes', Icons.notes, theme),
                        const SizedBox(height: 12),
                        Text(
                          survey.notes!,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary,
                          ),
                        ),
                      ],

                      if (survey.convertedProjectUuid != null && survey.convertedProjectUuid!.isNotEmpty) ...[
                        const SizedBox(height: 24),
                        _buildSectionHeader('Project Info', Icons.business_center, theme),
                        const SizedBox(height: 12),
                        _buildInfoRow('Converted Project ID', survey.convertedProjectUuid!, theme, isDark),
                      ],

                      const SizedBox(height: 48),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, ThemeData theme) {
    return Row(
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value, ThemeData theme, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isDark ? AppTheme.darkTextMuted : AppTheme.lightTextMuted,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
