import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mhgo/core/theme/app_theme.dart';
import 'package:mhgo/core/widgets/app_card.dart';
import 'package:mhgo/core/widgets/app_button.dart';
import 'package:mhgo/features/dar/domain/entities/dar_entities.dart';
import 'package:mhgo/features/dar/presentation/providers/dar_provider.dart';
import 'package:mhgo/features/projects/presentation/providers/projects_provider.dart';

class DarListView extends ConsumerStatefulWidget {
  const DarListView({super.key});

  @override
  ConsumerState<DarListView> createState() => _DarListViewState();
}

class _DarListViewState extends ConsumerState<DarListView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final darsAsync = ref.watch(darsListProvider);
    final projectsAsync = ref.watch(projectsListProvider);
    
    final searchQuery = ref.watch(darSearchQueryProvider);
    final selectedProject = ref.watch(darProjectFilterProvider);
    final selectedStatus = ref.watch(darStatusFilterProvider);
    final selectedDate = ref.watch(darDateFilterProvider);
    final isGridView = ref.watch(darGridViewProvider);

    return Scaffold(
      backgroundColor: isDark ? AppTheme.darkBg : AppTheme.lightBg,
      appBar: AppBar(
        title: Text(
          'Daily Accomplishment Reports',
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
              ref.read(darGridViewProvider.notifier).toggle();
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'dar-list-fab',
        onPressed: () => context.push('/dar/create'),
        label: const Text('New Daily Report', style: TextStyle(fontWeight: FontWeight.bold)),
        icon: const Icon(Icons.add),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(darsListProvider);
          },
          child: darsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => _buildErrorState(err.toString()),
            data: (reports) {
              // Apply filters
              var filtered = reports.where((r) {
                // Search query
                final query = searchQuery.toLowerCase();
                final matchesSearch = r.darNumber.toLowerCase().contains(query) ||
                    r.projectName.toLowerCase().contains(query) ||
                    r.preparedBy.toLowerCase().contains(query);

                // Project filter
                final matchesProject = selectedProject == null || r.projectUuid == selectedProject;

                // Status filter
                final matchesStatus = selectedStatus == null || r.status.toLowerCase() == selectedStatus.toLowerCase();

                // Date filter
                final matchesDate = selectedDate == null ||
                    (r.reportDate.year == selectedDate.year &&
                        r.reportDate.month == selectedDate.month &&
                        r.reportDate.day == selectedDate.day);

                return matchesSearch && matchesProject && matchesStatus && matchesDate;
              }).toList();

              // Sort by date descending (newest reports first)
              filtered.sort((a, b) => b.reportDate.compareTo(a.reportDate));

              return CustomScrollView(
                slivers: [
                  // Filter header panel
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSearchAndFiltersRow(projectsAsync, theme, isDark),
                          const SizedBox(height: 16),
                          _buildStatusFilterRow(theme, isDark),
                        ],
                      ),
                    ),
                  ),

                  // Reports List/Grid View
                  if (filtered.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: _buildEmptyState(),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                      sliver: isGridView
                          ? _buildReportsGrid(filtered, theme, isDark)
                          : _buildReportsList(filtered, theme, isDark),
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

  // --- SEARCH AND FILTERS PANEL ---
  Widget _buildSearchAndFiltersRow(AsyncValue<List<dynamic>> projectsAsync, ThemeData theme, bool isDark) {
    final selectedProject = ref.watch(darProjectFilterProvider);
    final selectedDate = ref.watch(darDateFilterProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 750;

        final searchField = TextField(
          controller: _searchController,
          onChanged: (val) {
            ref.read(darSearchQueryProvider.notifier).set(val);
          },
          decoration: InputDecoration(
            hintText: 'Search by DAR number, project, or preparer...',
            prefixIcon: const Icon(Icons.search, size: 20),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, size: 18),
                    onPressed: () {
                      _searchController.clear();
                      ref.read(darSearchQueryProvider.notifier).clear();
                    },
                  )
                : null,
            filled: true,
            fillColor: isDark ? AppTheme.darkSurface : AppTheme.lightSurface,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder),
            ),
          ),
        );

        final projectDropdown = projectsAsync.when(
          loading: () => const SizedBox(width: 120, height: 48),
          error: (_, __) => const SizedBox(),
          data: (projects) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: isDark ? AppTheme.darkSurface : AppTheme.lightSurface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String?>(
                  value: selectedProject,
                  hint: const Text('All Projects'),
                  icon: const Icon(Icons.arrow_drop_down, size: 18),
                  style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                  onChanged: (val) {
                    ref.read(darProjectFilterProvider.notifier).set(val);
                  },
                  items: [
                    const DropdownMenuItem(value: null, child: Text('All Projects')),
                    ...projects.map((p) => DropdownMenuItem(value: p.uuid as String, child: Text(p.name as String))),
                  ],
                ),
              ),
            );
          },
        );

        final dateSelector = TextButton.icon(
          onPressed: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: selectedDate ?? DateTime.now(),
              firstDate: DateTime(2025),
              lastDate: DateTime(2030),
            );
            if (picked != null) {
              ref.read(darDateFilterProvider.notifier).set(picked);
            }
          },
          icon: Icon(Icons.calendar_today_outlined, size: 16, color: theme.colorScheme.primary),
          label: Text(
            selectedDate == null 
                ? 'Select Date' 
                : DateFormat('MMM dd, yyyy').format(selectedDate),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            backgroundColor: theme.colorScheme.primary.withOpacity(0.08),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
        );

        if (selectedDate != null) {
          // Add clear button
          return isNarrow
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    searchField,
                    const SizedBox(height: 12),
                    projectDropdown,
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: dateSelector),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          onPressed: () => ref.read(darDateFilterProvider.notifier).clear(),
                        ),
                      ],
                    ),
                  ],
                )
              : Row(
                  children: [
                    Expanded(child: searchField),
                    const SizedBox(width: 12),
                    projectDropdown,
                    const SizedBox(width: 12),
                    dateSelector,
                    const SizedBox(width: 4),
                    IconButton(
                      icon: const Icon(Icons.clear, size: 18),
                      onPressed: () => ref.read(darDateFilterProvider.notifier).clear(),
                    ),
                  ],
                );
        }

        if (isNarrow) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              searchField,
              const SizedBox(height: 12),
              projectDropdown,
              const SizedBox(height: 12),
              dateSelector,
            ],
          );
        }

        return Row(
          children: [
            Expanded(child: searchField),
            const SizedBox(width: 12),
            projectDropdown,
            const SizedBox(width: 12),
            dateSelector,
          ],
        );
      },
    );
  }

  // --- STATUS CHIPS FILTER ROW ---
  Widget _buildStatusFilterRow(ThemeData theme, bool isDark) {
    final activeStatus = ref.watch(darStatusFilterProvider);
    final statuses = [
      {'label': 'All Reports', 'value': null},
      {'label': 'Drafts', 'value': 'Draft'},
      {'label': 'Submitted', 'value': 'Submitted'},
      {'label': 'Approved', 'value': 'Approved'},
      {'label': 'Rejected', 'value': 'Rejected'},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: statuses.map((status) {
          final isSelected = activeStatus == status['value'];
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              label: Text(status['label'] as String),
              selected: isSelected,
              onSelected: (_) {
                ref.read(darStatusFilterProvider.notifier).set(status['value'] as String?);
              },
              labelStyle: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected 
                    ? Colors.white 
                    : (isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary),
              ),
              selectedColor: theme.colorScheme.primary,
              backgroundColor: isDark ? AppTheme.darkSurface : AppTheme.lightSurface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
                side: BorderSide(
                  color: isSelected 
                      ? theme.colorScheme.primary 
                      : (isDark ? AppTheme.darkBorder : AppTheme.lightBorder),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // --- GRID RENDER ---
  Widget _buildReportsGrid(List<DarReport> reports, ThemeData theme, bool isDark) {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 420,
        mainAxisSpacing: 24,
        crossAxisSpacing: 24,
        mainAxisExtent: 280, // Fixed consistent height
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final report = reports[index];
          return _DarGridCard(report: report, theme: theme, isDark: isDark);
        },
        childCount: reports.length,
      ),
    );
  }

  // --- LIST RENDER ---
  Widget _buildReportsList(List<DarReport> reports, ThemeData theme, bool isDark) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final report = reports[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: _DarListCard(report: report, theme: theme, isDark: isDark),
          );
        },
        childCount: reports.length,
      ),
    );
  }

  // --- STATES ---
  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 56, color: Color(0xFFD32F2F)),
          const SizedBox(height: 16),
          Text('Failed to load activity reports', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(message, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 24),
          AppButton(
            text: 'Retry',
            onPressed: () => ref.invalidate(darsListProvider),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.assignment_outlined, size: 56, color: Theme.of(context).disabledColor),
          const SizedBox(height: 16),
          Text('No reports matches your selection', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          const Text('Create a new Daily Report or check your filter criteria.'),
        ],
      ),
    );
  }
}

// --- DAR GRID CARD ---
class _DarGridCard extends StatelessWidget {
  final DarReport report;
  final ThemeData theme;
  final bool isDark;

  const _DarGridCard({
    required this.report,
    required this.theme,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(report.status);
    final formattedDate = DateFormat('MMMM dd, yyyy').format(report.reportDate);
    final formattedUpdated = DateFormat('MMM dd, hh:mm a').format(report.lastUpdated);

    return AppCard(
      variant: AppCardVariant.outlined,
      padding: const EdgeInsets.all(20),
      onTap: () {
        context.push('/dar/details/${report.id}');
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header status & weather icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: statusColor.withOpacity(0.2)),
                ),
                child: Text(
                  report.status.toUpperCase(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Row(
                children: [
                  Icon(_getWeatherIcon(report.weather), size: 16, color: Colors.amber),
                  const SizedBox(width: 4),
                  Text(report.weather, style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // DAR Number & date
          Text(
            report.darNumber,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            formattedDate,
            style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
          ),
          const Spacer(),

          // Project name
          Text(
            report.projectName,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary,
              fontSize: 13,
            ),
          ),
          const Spacer(),

          // Details
          Row(
            children: [
              const Icon(Icons.person_outline, size: 14, color: Colors.grey),
              const SizedBox(width: 8),
              Text(
                'By: ${report.preparedBy}',
                style: theme.textTheme.bodySmall?.copyWith(fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.update, size: 14, color: Colors.grey),
              const SizedBox(width: 8),
              Text(
                'Updated: $formattedUpdated',
                style: theme.textTheme.bodySmall?.copyWith(fontSize: 11),
              ),
            ],
          ),
          const Spacer(),

          // Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (report.status == 'Draft') ...[
                TextButton.icon(
                  onPressed: () => context.push('/dar/edit/${report.id}'),
                  icon: const Icon(Icons.edit_outlined, size: 14),
                  label: const Text('Edit Draft', style: TextStyle(fontSize: 11)),
                ),
              ],
              TextButton.icon(
                onPressed: () => context.push('/dar/pdf/${report.id}'),
                icon: const Icon(Icons.picture_as_pdf_outlined, size: 14),
                label: const Text('PDF Preview', style: TextStyle(fontSize: 11)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// --- DAR LIST CARD ---
class _DarListCard extends StatelessWidget {
  final DarReport report;
  final ThemeData theme;
  final bool isDark;

  const _DarListCard({
    required this.report,
    required this.theme,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(report.status);
    final formattedDate = DateFormat('MMMM dd, yyyy').format(report.reportDate);
    final formattedUpdated = DateFormat('MMM dd, hh:mm a').format(report.lastUpdated);

    return AppCard(
      variant: AppCardVariant.outlined,
      padding: const EdgeInsets.all(20),
      onTap: () {
        context.push('/dar/details/${report.id}');
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 750;

          final leftCol = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    report.darNumber,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: statusColor.withOpacity(0.15)),
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
                ],
              ),
              const SizedBox(height: 4),
              Text(
                report.projectName,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 16,
                runSpacing: 4,
                children: [
                  _buildDetailItem(Icons.calendar_today_outlined, formattedDate),
                  _buildDetailItem(Icons.person_outline, 'By: ${report.preparedBy}'),
                  _buildDetailItem(_getWeatherIcon(report.weather), 'Weather: ${report.weather}'),
                ],
              ),
            ],
          );

          final rightCol = Column(
            crossAxisAlignment: isNarrow ? CrossAxisAlignment.start : CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Last updated:',
                style: theme.textTheme.bodySmall?.copyWith(fontSize: 10, color: theme.disabledColor),
              ),
              Text(
                formattedUpdated,
                style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  if (report.status == 'Draft') ...[
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, size: 18),
                      tooltip: 'Edit Report',
                      onPressed: () => context.push('/dar/edit/${report.id}'),
                    ),
                  ],
                  IconButton(
                    icon: const Icon(Icons.picture_as_pdf_outlined, size: 18),
                    tooltip: 'PDF Preview',
                    onPressed: () => context.push('/dar/pdf/${report.id}'),
                  ),
                ],
              ),
            ],
          );

          if (isNarrow) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                leftCol,
                const SizedBox(height: 12),
                const Divider(),
                const SizedBox(height: 8),
                rightCol,
              ],
            );
          }

          return Row(
            children: [
              Expanded(child: leftCol),
              const SizedBox(width: 24),
              rightCol,
            ],
          );
        },
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: theme.disabledColor),
        const SizedBox(width: 6),
        Text(
          text,
          style: theme.textTheme.bodySmall?.copyWith(fontSize: 11),
        ),
      ],
    );
  }
}

// --- HELPER UTILITIES ---
Color _getStatusColor(String status) {
  switch (status.toLowerCase()) {
    case 'draft':
      return const Color(0xFF2196F3); // Sky Blue
    case 'submitted':
      return const Color(0xFFFFB300); // Amber
    case 'approved':
      return const Color(0xFF2E7D32); // Solar Green
    case 'rejected':
    default:
      return const Color(0xFFD32F2F); // Red
  }
}

IconData _getWeatherIcon(String weather) {
  switch (weather.toLowerCase()) {
    case 'sunny':
      return Icons.wb_sunny_rounded;
    case 'rainy':
      return Icons.umbrella_rounded;
    case 'cloudy':
      return Icons.cloud_rounded;
    case 'windy':
    default:
      return Icons.wind_power_rounded;
  }
}
