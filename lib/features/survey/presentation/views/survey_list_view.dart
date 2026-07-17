import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mhgo/core/theme/app_theme.dart';
import 'package:mhgo/core/widgets/app_card.dart';
import 'package:mhgo/core/widgets/app_button.dart';
import 'package:mhgo/features/inspections/domain/entities/survey_entities.dart';
import 'package:mhgo/features/inspections/presentation/providers/survey_provider.dart';
import 'package:mhgo/features/projects/presentation/providers/projects_provider.dart';

class InspectionListView extends ConsumerStatefulWidget {
  const InspectionListView({super.key});

  @override
  ConsumerState<InspectionListView> createState() => _InspectionListViewState();
}

class _InspectionListViewState extends ConsumerState<InspectionListView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize controller with current search state
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchController.text = ref.read(inspectionSearchQueryProvider);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _clearAllFilters() {
    _searchController.clear();
    ref.read(inspectionSearchQueryProvider.notifier).clear();
    ref.read(inspectionProjectFilterProvider.notifier).clear();
    ref.read(inspectionTypeFilterProvider.notifier).clear();
    ref.read(inspectionStatusFilterProvider.notifier).clear();
    ref.read(inspectionInspectorFilterProvider.notifier).clear();
    ref.read(inspectionDateFilterProvider.notifier).clear();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final inspectionsAsync = ref.watch(filteredInspectionsProvider);
    final projectsAsync = ref.watch(projectsListProvider);
    final isGridView = ref.watch(inspectionGridViewProvider);

    return Scaffold(
      backgroundColor: isDark ? AppTheme.darkBg : AppTheme.lightBg,
      appBar: AppBar(
        title: Text(
          'Site Inspections',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(isGridView ? Icons.view_list_rounded : Icons.grid_view_rounded),
            tooltip: isGridView ? 'Switch to List View' : 'Switch to Grid View',
            onPressed: () {
              ref.read(inspectionGridViewProvider.notifier).toggle();
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_alt_off_rounded),
            tooltip: 'Clear All Filters',
            onPressed: _clearAllFilters,
          ),
          const SizedBox(width: 8),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/inspections/create'),
        label: const Text('New Inspection', style: TextStyle(fontWeight: FontWeight.bold)),
        icon: const Icon(Icons.add),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(inspectionsListProvider);
          },
          child: inspectionsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => _buildErrorState(err.toString()),
            data: (filtered) {
              return CustomScrollView(
                slivers: [
                  // Filter header panel
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSearchAndSortingRow(theme, isDark),
                          const SizedBox(height: 12),
                          _buildFilterDropdownsRow(projectsAsync, theme, isDark),
                        ],
                      ),
                    ),
                  ),

                  // Content view
                  if (filtered.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: _buildEmptyState(),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                      sliver: isGridView
                          ? _buildInspectionsGrid(filtered, theme, isDark)
                          : _buildInspectionsList(filtered, theme, isDark),
                    ),
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 80), // spacer for FAB
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSearchAndSortingRow(ThemeData theme, bool isDark) {
    final activeSort = ref.watch(inspectionSortFilterProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 600;

        final searchField = Expanded(
          flex: isCompact ? 1 : 3,
          child: TextField(
            controller: _searchController,
            onChanged: (val) => ref.read(inspectionSearchQueryProvider.notifier).set(val),
            decoration: InputDecoration(
              hintText: 'Search inspections by title, ID, location...',
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear_rounded),
                      onPressed: () {
                        _searchController.clear();
                        ref.read(inspectionSearchQueryProvider.notifier).clear();
                      },
                    )
                  : null,
            ),
          ),
        );

        final sortDropdown = SizedBox(
          width: isCompact ? double.infinity : 180,
          child: DropdownButtonFormField<String>(
            value: activeSort,
            decoration: const InputDecoration(
              labelText: 'Sort By',
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            items: const [
              DropdownMenuItem(value: 'date_desc', child: Text('Date (Newest)')),
              DropdownMenuItem(value: 'date_asc', child: Text('Date (Oldest)')),
              DropdownMenuItem(value: 'priority_desc', child: Text('Priority (High)')),
              DropdownMenuItem(value: 'priority_asc', child: Text('Priority (Low)')),
            ],
            onChanged: (val) {
              if (val != null) {
                ref.read(inspectionSortFilterProvider.notifier).set(val);
              }
            },
          ),
        );

        if (isCompact) {
          return Column(
            children: [
              Row(children: [searchField]),
              const SizedBox(height: 12),
              sortDropdown,
            ],
          );
        }

        return Row(
          children: [
            searchField,
            const SizedBox(width: 12),
            sortDropdown,
          ],
        );
      },
    );
  }

  Widget _buildFilterDropdownsRow(
    AsyncValue<List<dynamic>> projectsAsync,
    ThemeData theme,
    bool isDark,
  ) {
    final selectedProj = ref.watch(inspectionProjectFilterProvider);
    final selectedType = ref.watch(inspectionTypeFilterProvider);
    final selectedStatus = ref.watch(inspectionStatusFilterProvider);
    final selectedDate = ref.watch(inspectionDateFilterProvider);

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        // Project Dropdown
        projectsAsync.when(
          loading: () => const SizedBox(width: 120, height: 40, child: Center(child: CircularProgressIndicator(strokeWidth: 2))),
          error: (_, __) => const Text('Error loading projects'),
          data: (projects) {
            return SizedBox(
              width: 160,
              child: DropdownButtonFormField<String?>(
                value: selectedProj,
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: 'Project',
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                items: [
                  const DropdownMenuItem(value: null, child: Text('All Projects', overflow: TextOverflow.ellipsis)),
                  ...projects.map((p) => DropdownMenuItem(value: p.uuid, child: Text(p.name, overflow: TextOverflow.ellipsis))),
                ],
                onChanged: (val) => ref.read(inspectionProjectFilterProvider.notifier).set(val),
              ),
            );
          },
        ),

        // Inspection Type Dropdown
        SizedBox(
          width: 140,
          child: DropdownButtonFormField<String?>(
            value: selectedType,
            isExpanded: true,
            decoration: const InputDecoration(
              labelText: 'Type',
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            items: const [
              DropdownMenuItem(value: null, child: Text('All Types', overflow: TextOverflow.ellipsis)),
              DropdownMenuItem(value: 'Civil', child: Text('Civil', overflow: TextOverflow.ellipsis)),
              DropdownMenuItem(value: 'Structural', child: Text('Structural', overflow: TextOverflow.ellipsis)),
              DropdownMenuItem(value: 'Electrical', child: Text('Electrical', overflow: TextOverflow.ellipsis)),
              DropdownMenuItem(value: 'Mechanical', child: Text('Mechanical', overflow: TextOverflow.ellipsis)),
              DropdownMenuItem(value: 'General', child: Text('General', overflow: TextOverflow.ellipsis)),
            ],
            onChanged: (val) => ref.read(inspectionTypeFilterProvider.notifier).set(val),
          ),
        ),

        // Status Dropdown
        SizedBox(
          width: 130,
          child: DropdownButtonFormField<String?>(
            value: selectedStatus,
            isExpanded: true,
            decoration: const InputDecoration(
              labelText: 'Status',
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            items: const [
              DropdownMenuItem(value: null, child: Text('All Status', overflow: TextOverflow.ellipsis)),
              DropdownMenuItem(value: 'Draft', child: Text('Draft', overflow: TextOverflow.ellipsis)),
              DropdownMenuItem(value: 'Pending', child: Text('Pending', overflow: TextOverflow.ellipsis)),
              DropdownMenuItem(value: 'Approved', child: Text('Approved', overflow: TextOverflow.ellipsis)),
              DropdownMenuItem(value: 'Rejected', child: Text('Rejected', overflow: TextOverflow.ellipsis)),
            ],
            onChanged: (val) => ref.read(inspectionStatusFilterProvider.notifier).set(val),
          ),
        ),

        // Date Picker chip-button
        TextButton.icon(
          onPressed: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: selectedDate ?? DateTime.now(),
              firstDate: DateTime(2020),
              lastDate: DateTime(2100),
            );
            if (picked != null) {
              ref.read(inspectionDateFilterProvider.notifier).set(picked);
            }
          },
          icon: Icon(Icons.calendar_today_rounded, size: 16, color: theme.colorScheme.primary),
          label: Text(
            selectedDate != null ? DateFormat('yyyy-MM-dd').format(selectedDate) : 'Select Date',
            style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.primary),
          ),
          style: TextButton.styleFrom(
            backgroundColor: theme.colorScheme.primary.withOpacity(0.08),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium)),
          ),
        ),

        if (selectedDate != null)
          IconButton(
            icon: const Icon(Icons.cancel_outlined, size: 18),
            tooltip: 'Clear Date Filter',
            onPressed: () => ref.read(inspectionDateFilterProvider.notifier).clear(),
          ),
      ],
    );
  }

  Widget _buildInspectionsGrid(List<InspectionReport> reports, ThemeData theme, bool isDark) {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 450,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        mainAxisExtent: 260,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final report = reports[index];
          return _InspectionItemCard(report: report, theme: theme, isDark: isDark);
        },
        childCount: reports.length,
      ),
    );
  }
  Widget _buildInspectionsList(List<InspectionReport> reports, ThemeData theme, bool isDark) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final report = reports[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: _InspectionItemCard(report: report, theme: theme, isDark: isDark),
          );
        },
        childCount: reports.length,
      ),
    );
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
            Text('Failed to load inspections', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 24),
            AppButton(
              text: 'Retry',
              onPressed: () => ref.invalidate(inspectionsListProvider),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.find_in_page_outlined,
            size: 80,
            color: isDark ? AppTheme.darkTextMuted : AppTheme.lightTextMuted,
          ),
          const SizedBox(height: 16),
          Text(
            'No inspections found',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Try clearing your search or applying different filters.',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          AppButton(
            text: 'Reset Filters',
            variant: AppButtonVariant.outlined,
            onPressed: _clearAllFilters,
          )
        ],
      ),
    );
  }
}

class _InspectionItemCard extends StatelessWidget {
  final InspectionReport report;
  final ThemeData theme;
  final bool isDark;

  const _InspectionItemCard({
    required this.report,
    required this.theme,
    required this.isDark,
  });

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
        return const Color(0xFFD32F2F); // Deep Red
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
    final statusColor = _getStatusColor(report.status);
    final priorityColor = _getPriorityColor(report.priority);
    final resultColor = _getResultColor(report.overallResult);

    final formattedDate = DateFormat('MMMM dd, yyyy').format(report.inspectionDate);

    return AppCard(
      variant: AppCardVariant.outlined,
      padding: const EdgeInsets.all(20),
      onTap: () {
        context.push('/inspections/details/${report.id}');
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Status, Priority and Result Chips
          Wrap(
            spacing: 6,
            runSpacing: 6,
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Status Chip
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: statusColor.withOpacity(0.2)),
                    ),
                    child: Text(
                      report.status.toUpperCase(),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.w800,
                        fontSize: 9,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  // Priority Chip
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: priorityColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: priorityColor.withOpacity(0.2)),
                    ),
                    child: Text(
                      report.priority.toUpperCase(),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: priorityColor,
                        fontWeight: FontWeight.w800,
                        fontSize: 9,
                      ),
                    ),
                  ),
                ],
              ),
              // Overall Result Chip
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
                      size: 12,
                      color: resultColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      report.overallResult.toUpperCase(),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: resultColor,
                        fontWeight: FontWeight.w900,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // ID and Title
          Text(
            report.inspectionId,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: isDark ? AppTheme.darkTextMuted : AppTheme.lightTextMuted,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            report.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 6),

          // Project name and Type
          Row(
            children: [
              Icon(Icons.business_rounded, size: 14, color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  report.projectName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              // Date
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.calendar_today_rounded, size: 13, color: isDark ? AppTheme.darkTextMuted : AppTheme.lightTextMuted),
                  const SizedBox(width: 4),
                  Text(
                    formattedDate,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              // Inspector Name
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.person_rounded, size: 13, color: isDark ? AppTheme.darkTextMuted : AppTheme.lightTextMuted),
                  const SizedBox(width: 4),
                  Text(
                    report.inspectorName,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const Spacer(),
          const Divider(),
          const SizedBox(height: 6),

          // Bottom Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                report.inspectionType,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit_document, size: 18),
                    tooltip: 'Edit Draft',
                    visualDensity: VisualDensity.compact,
                    onPressed: () {
                      context.push('/inspections/edit/${report.id}');
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.picture_as_pdf_rounded, size: 18),
                    tooltip: 'Print PDF Preview',
                    visualDensity: VisualDensity.compact,
                    onPressed: () {
                      context.push('/inspections/pdf/${report.id}');
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
