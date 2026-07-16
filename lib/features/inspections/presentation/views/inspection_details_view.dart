import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mhgo/core/theme/app_theme.dart';
import 'package:mhgo/core/widgets/app_card.dart';
import 'package:mhgo/core/widgets/app_button.dart';
import 'package:mhgo/features/inspections/domain/entities/inspection_entities.dart';
import 'package:mhgo/features/inspections/presentation/providers/inspections_provider.dart';

class InspectionDetailsView extends ConsumerStatefulWidget {
  final String id;

  const InspectionDetailsView({
    super.key,
    required this.id,
  });

  @override
  ConsumerState<InspectionDetailsView> createState() => _InspectionDetailsViewState();
}

class _InspectionDetailsViewState extends ConsumerState<InspectionDetailsView> {
  // Collapsible section toggles
  bool _showGeneral = true;
  bool _showChecklist = true;
  bool _showNCR = true;
  bool _showPhotos = true;
  bool _showSignatures = true;

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'rejected':
        return Colors.red;
      case 'draft':
      default:
        return Colors.grey;
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'critical':
        return const Color(0xFFD32F2F);
      case 'high':
        return Colors.orange;
      case 'medium':
        return Colors.amber;
      case 'low':
      default:
        return Colors.blue;
    }
  }

  Color _getResultColor(String result) {
    switch (result.toLowerCase()) {
      case 'pass':
        return Colors.green;
      case 'fail':
        return Colors.red;
      case 'open nc':
      default:
        return Colors.deepOrange;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final detailsAsync = ref.watch(inspectionDetailsProvider(widget.id));

    return Scaffold(
      backgroundColor: isDark ? AppTheme.darkBg : AppTheme.lightBg,
      appBar: AppBar(
        title: Text(
          'Inspection Details',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
          ),
        ),
      ),
      body: SafeArea(
        child: detailsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => _buildErrorState(err.toString()),
          data: (report) {
            if (report == null) {
              return const Center(child: Text('Inspection report not found.'));
            }

            final statusColor = _getStatusColor(report.status);
            final priorityColor = _getPriorityColor(report.priority);
            final resultColor = _getResultColor(report.overallResult);

            final formattedDate = DateFormat('EEEE, MMMM dd, yyyy').format(report.inspectionDate);
            final formattedUpdated = DateFormat('MMMM dd, yyyy hh:mm a').format(report.updatedAt);

            return SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 850),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Section
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final isNarrow = constraints.maxWidth < 600;
                          final textInfo = Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    report.inspectionId,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: isDark ? AppTheme.darkTextMuted : AppTheme.lightTextMuted,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '(${report.inspectionType})',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: theme.colorScheme.primary,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                report.title,
                                style: theme.textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: -1.0,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Last updated on $formattedUpdated',
                                style: theme.textTheme.bodySmall?.copyWith(color: theme.disabledColor),
                              ),
                            ],
                          );

                          final statusTags = Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              // Status Chip
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                                decoration: BoxDecoration(
                                  color: statusColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: statusColor.withOpacity(0.2)),
                                ),
                                child: Text(
                                  report.status.toUpperCase(),
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: statusColor,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                              // Priority Chip
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                                decoration: BoxDecoration(
                                  color: priorityColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: priorityColor.withOpacity(0.2)),
                                ),
                                child: Text(
                                  report.priority.toUpperCase(),
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: priorityColor,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                              // Result Chip
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                                decoration: BoxDecoration(
                                  color: resultColor.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: resultColor.withOpacity(0.3), width: 1.2),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      report.overallResult.toLowerCase() == 'pass'
                                          ? Icons.check_circle_rounded
                                          : Icons.warning_rounded,
                                      size: 13,
                                      color: resultColor,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      report.overallResult.toUpperCase(),
                                      style: theme.textTheme.labelSmall?.copyWith(
                                        color: resultColor,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );

                          if (isNarrow) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                textInfo,
                                const SizedBox(height: 16),
                                statusTags,
                              ],
                            );
                          }

                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(child: textInfo),
                              const SizedBox(width: 16),
                              statusTags,
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 16),

                      // Action Controls Row
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          AppButton(
                            text: report.status == 'Draft' ? 'Edit Draft Report' : 'Modify Report',
                            icon: Icons.edit_document,
                            onPressed: () => context.push('/inspections/edit/${report.id}'),
                          ),
                          AppButton(
                            text: 'Print PDF Preview',
                            icon: Icons.picture_as_pdf_rounded,
                            variant: AppButtonVariant.secondary,
                            onPressed: () => context.push('/inspections/pdf/${report.id}'),
                          ),
                          AppButton(
                            text: 'Delete Report',
                            icon: Icons.delete_outline,
                            variant: AppButtonVariant.danger,
                            onPressed: () => _confirmDeleteReport(context, report),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // 1. General & Ambient Metadata Section
                      _buildCollapsibleCard(
                        title: 'Inspection Metadata & Site Ambient',
                        icon: Icons.info_outline_rounded,
                        isExpanded: _showGeneral,
                        onToggle: () => setState(() => _showGeneral = !_showGeneral),
                        child: _buildGeneralMetadataContent(report, theme, isDark),
                        theme: theme,
                      ),
                      const SizedBox(height: 16),

                      // 2. Checklist Results
                      _buildCollapsibleCard(
                        title: 'Verification Checklist Results',
                        icon: Icons.fact_check_outlined,
                        isExpanded: _showChecklist,
                        onToggle: () => setState(() => _showChecklist = !_showChecklist),
                        child: _buildChecklistContent(report.checklist, theme, isDark),
                        theme: theme,
                      ),
                      const SizedBox(height: 16),

                      // 3. Non-Conformance log
                      _buildCollapsibleCard(
                        title: 'Non-Conformance Logging (NCR)',
                        icon: Icons.report_problem_outlined,
                        isExpanded: _showNCR,
                        onToggle: () => setState(() => _showNCR = !_showNCR),
                        child: _buildNCRContent(report.nonConformance, theme, isDark),
                        theme: theme,
                      ),
                      const SizedBox(height: 16),

                      // 4. Photos Gallery
                      _buildCollapsibleCard(
                        title: 'Attached Documentation Photos',
                        icon: Icons.photo_library_outlined,
                        isExpanded: _showPhotos,
                        onToggle: () => setState(() => _showPhotos = !_showPhotos),
                        child: _buildPhotosContent(report, theme, isDark),
                        theme: theme,
                      ),
                      const SizedBox(height: 16),

                      // 5. Sign-offs
                      _buildCollapsibleCard(
                        title: 'Signatures & Approvals',
                        icon: Icons.draw_outlined,
                        isExpanded: _showSignatures,
                        onToggle: () => setState(() => _showSignatures = !_showSignatures),
                        child: _buildSignaturesContent(report.signatures, theme, isDark),
                        theme: theme,
                      ),
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

  // --- COLLAPSIBLE CARD HELPER ---
  Widget _buildCollapsibleCard({
    required String title,
    required IconData icon,
    required bool isExpanded,
    required VoidCallback onToggle,
    required Widget child,
    required ThemeData theme,
  }) {
    return AppCard(
      variant: AppCardVariant.outlined,
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          InkWell(
            onTap: onToggle,
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(icon, size: 20, color: theme.colorScheme.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
                ],
              ),
            ),
          ),
          if (isExpanded) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: child,
            ),
          ],
        ],
      ),
    );
  }

  // --- 1. GENERAL METADATA CONTENT ---
  Widget _buildGeneralMetadataContent(InspectionReport report, ThemeData theme, bool isDark) {
    Widget metaRow(String label, String value, IconData icon) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 16, color: isDark ? AppTheme.darkTextMuted : AppTheme.lightTextMuted),
            const SizedBox(width: 8),
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary,
                  ),
                  children: [
                    TextSpan(text: '$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: value),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    final dateStr = DateFormat('MMMM dd, yyyy').format(report.inspectionDate);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 550;
        final col1 = [
          metaRow('Project Portfolio', report.projectName, Icons.business_rounded),
          metaRow('Lead Inspector', report.inspectorName, Icons.person_rounded),
          metaRow('Witness Sign-off', report.witness.isNotEmpty ? report.witness : 'N/A', Icons.person_outline_rounded),
          metaRow('Inspection Type', report.inspectionType, Icons.construction_rounded),
        ];
        final col2 = [
          metaRow('Inspection Date', dateStr, Icons.calendar_today_rounded),
          metaRow('Inspection Time', report.time, Icons.access_time_rounded),
          metaRow('Site Area block', report.area, Icons.location_city_rounded),
          metaRow('GPS / Location', report.location, Icons.pin_drop_rounded),
        ];

        if (isWide) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: col1)),
              const SizedBox(width: 24),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: col2)),
            ],
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [...col1, ...col2],
        );
      },
    );
  }

  // --- 2. CHECKLIST CONTENT ---
  Widget _buildChecklistContent(List<ChecklistItem> checklist, ThemeData theme, bool isDark) {
    if (checklist.isEmpty) return const Text('No checklist items verified.');

    return Table(
      columnWidths: const {
        0: FlexColumnWidth(4),
        1: FlexColumnWidth(2),
        2: FlexColumnWidth(4),
      },
      border: TableBorder(
        horizontalInside: BorderSide(
          color: theme.dividerColor.withOpacity(0.4),
          width: 1,
        ),
      ),
      children: [
        // Table Header
        TableRow(
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.04),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              child: Text('Checklist Item', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              child: Text('Result', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              child: Text('Remarks / Measurements', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        // Table Content
        ...checklist.map((item) {
          Color resultColor = Colors.grey;
          IconData resultIcon = Icons.remove_circle_outline_rounded;
          if (item.result == 'Pass') {
            resultColor = Colors.green;
            resultIcon = Icons.check_circle_rounded;
          } else if (item.result == 'Fail') {
            resultColor = Colors.red;
            resultIcon = Icons.cancel_rounded;
          }

          return TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                child: Text(item.name, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                child: Row(
                  children: [
                    Icon(resultIcon, color: resultColor, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      item.result,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: resultColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                child: Text(
                  item.remarks.isNotEmpty ? item.remarks : '-',
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            ],
          );
        }),
      ],
    );
  }

  // --- 3. NCR CONTENT ---
  Widget _buildNCRContent(List<NonConformance> ncr, ThemeData theme, bool isDark) {
    if (ncr.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.04),
          border: Border.all(color: Colors.green.withOpacity(0.2)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.green),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'No technical non-conformances identified.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.green.shade700,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: ncr.map((nc) {
        Color sevColor = Colors.blue;
        if (nc.severity == 'High') sevColor = Colors.red;
        if (nc.severity == 'Medium') sevColor = Colors.orange;

        final targetStr = nc.targetCompletionDate != null
            ? DateFormat('yyyy-MM-dd').format(nc.targetCompletionDate!)
            : 'Unspecified';

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? AppTheme.darkSurface : AppTheme.lightSurface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: theme.dividerColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: sevColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'SEVERITY: ${nc.severity.toUpperCase()}',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: sevColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 9,
                      ),
                    ),
                  ),
                  Text(
                    'Target Resolve: $targetStr',
                    style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                nc.description,
                style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const Divider(height: 20),
              if (nc.recommendedAction.isNotEmpty) ...[
                RichText(
                  text: TextSpan(
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary,
                    ),
                    children: [
                      const TextSpan(text: 'Recommended Action: ', style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: nc.recommendedAction),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
              ],
              if (nc.responsiblePerson.isNotEmpty)
                RichText(
                  text: TextSpan(
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary,
                    ),
                    children: [
                      const TextSpan(text: 'Responsible Person: ', style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: nc.responsiblePerson, style: const TextStyle(fontStyle: FontStyle.italic)),
                    ],
                  ),
                ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // --- 4. PHOTOS GALLERY CONTENT ---
  Widget _buildPhotosContent(InspectionReport report, ThemeData theme, bool isDark) {
    if (report.photos.isEmpty) return const Text('No documentation photos uploaded.');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final crossAxisCount = constraints.maxWidth > 700 ? 4 : (constraints.maxWidth > 400 ? 3 : 2);
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.2,
              ),
              itemCount: report.photos.length,
              itemBuilder: (context, index) {
                final photo = report.photos[index];
                return GestureDetector(
                  onTap: () {
                    // Navigate to visual gallery view
                    context.push('/inspections/gallery/${report.id}');
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blueGrey.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: theme.dividerColor),
                    ),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        const Center(child: Icon(Icons.image, size: 32, color: Colors.grey)),
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
                            child: Text(
                              photo.caption,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: Colors.white, fontSize: 10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            onPressed: () => context.push('/inspections/gallery/${report.id}'),
            icon: const Icon(Icons.photo_library_outlined, size: 16),
            label: const Text('View Full Gallery', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

  // --- 5. SIGNATURES CONTENT ---
  Widget _buildSignaturesContent(InspectionSignatures signatures, ThemeData theme, bool isDark) {
    Widget sigBlock(String role, String name) {
      final hasSignature = name.isNotEmpty;
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppTheme.darkSurface : AppTheme.lightSurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.dividerColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              role,
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: theme.disabledColor,
              ),
            ),
            const SizedBox(height: 16),
            if (hasSignature)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontFamily: 'Courier',
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text('Digitally Verified', style: TextStyle(fontSize: 9, color: Colors.green, fontWeight: FontWeight.bold)),
                ],
              )
            else
              Text(
                'NOT SIGNED',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.red.withOpacity(0.7),
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                  fontSize: 11,
                ),
              ),
          ],
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 650;

        if (isWide) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: sigBlock('Inspector Sign-off', signatures.inspector)),
              const SizedBox(width: 12),
              Expanded(child: sigBlock('Contractor Witness', signatures.contractor)),
              const SizedBox(width: 12),
              Expanded(child: sigBlock('QA/QC Rep Approved', signatures.qaqc)),
            ],
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            sigBlock('Inspector Sign-off', signatures.inspector),
            const SizedBox(height: 12),
            sigBlock('Contractor Witness', signatures.contractor),
            const SizedBox(height: 12),
            sigBlock('QA/QC Rep Approved', signatures.qaqc),
          ],
        );
      },
    );
  }

  // --- CRUD DELETION ---
  Future<void> _confirmDeleteReport(BuildContext context, InspectionReport report) async {
    final theme = Theme.of(context);
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.delete_outline, color: Colors.red),
            SizedBox(width: 8),
            Text('Delete Inspection Report'),
          ],
        ),
        content: Text('Are you sure you want to delete inspection report ${report.inspectionId}? \n\nThis action is permanent and cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD32F2F),
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete permanently'),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      setState(() => _showGeneral = false); // show loader or similar
      final repo = ref.read(inspectionsRepositoryProvider);
      await repo.deleteInspection(report.id);

      // Invalidate list provider to refresh list
      ref.invalidate(inspectionsListProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Deleted inspection report ${report.inspectionId}'),
            backgroundColor: Colors.redAccent,
          ),
        );
        context.pop(); // go back to list
      }
    }
  }

  Widget _buildErrorState(String message) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline_rounded, size: 60, color: Colors.redAccent),
            const SizedBox(height: 16),
            Text('Failed to load inspection details', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 24),
            AppButton(
              text: 'Go Back',
              onPressed: () => context.pop(),
            )
          ],
        ),
      ),
    );
  }
}
