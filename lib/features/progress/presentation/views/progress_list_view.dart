import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/progress_entities.dart';
import '../providers/progress_provider.dart';
import '../../../projects/presentation/providers/projects_provider.dart';

class ProgressListView extends ConsumerStatefulWidget {
  const ProgressListView({super.key});

  @override
  ConsumerState<ProgressListView> createState() => _ProgressListViewState();
}

class _ProgressListViewState extends ConsumerState<ProgressListView> {
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
    final progressState = ref.watch(progressNotifierProvider);

    return Scaffold(
      backgroundColor: isDark ? AppTheme.darkBg : AppTheme.lightBg,
      appBar: AppBar(
        title: const Text('Progress Tracking'),
        backgroundColor: isDark ? AppTheme.darkSurface : AppTheme.lightSurface,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () =>
                ref.read(progressNotifierProvider.notifier).refresh(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'progress-list-fab',
        onPressed: () => _showCreateProgressDialog(context),
        icon: const Icon(Icons.add),
        label: const Text(
          'Track New Project',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: progressState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (reports) {
          if (reports.isEmpty && _searchController.text.isEmpty) {
            return const Center(child: Text('No progress reports found.'));
          }

          // Deduplicate reports by projectUuid
          final Map<String, ProgressReport> uniqueReports = {};
          for (final report in reports) {
            if (!uniqueReports.containsKey(report.projectUuid) ||
                report.updatedAt.isAfter(
                  uniqueReports[report.projectUuid]!.updatedAt,
                )) {
              uniqueReports[report.projectUuid] = report;
            }
          }
          final deduplicatedReports = uniqueReports.values.toList();

          int totalProjects = deduplicatedReports.length;
          double totalProgress = deduplicatedReports.isEmpty
              ? 0.0
              : deduplicatedReports.fold(
                      0.0,
                      (sum, r) =>
                          sum +
                          (r.overallProgress.isNaN ||
                                  r.overallProgress.isInfinite
                              ? 0.0
                              : r.overallProgress),
                    ) /
                    deduplicatedReports.length;
          int autoCalculated = deduplicatedReports
              .where((r) => r.isAutoCalculated)
              .length;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildFilters(theme, isDark),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildKPIs(
                        theme: theme,
                        isDark: isDark,
                        totalProgress: totalProgress,
                        totalProjects: totalProjects,
                        autoCalculated: autoCalculated,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Projects',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (deduplicatedReports.isEmpty)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(32.0),
                            child: Text('No projects match the search.'),
                          ),
                        )
                      else
                        LayoutBuilder(
                          builder: (context, constraints) {
                            int crossAxisCount = 1;
                            if (constraints.maxWidth > 1200) {
                              crossAxisCount = 3;
                            } else if (constraints.maxWidth > 800) {
                              crossAxisCount = 2;
                            }

                            if (crossAxisCount == 1) {
                              return Column(
                                children: deduplicatedReports
                                    .map((r) => _ProjectCard(report: r))
                                    .toList(),
                              );
                            }

                            return Wrap(
                              spacing: 16,
                              runSpacing: 16,
                              children: deduplicatedReports.map((r) {
                                return SizedBox(
                                  width:
                                      (constraints.maxWidth -
                                          (16 * (crossAxisCount - 1))) /
                                      crossAxisCount,
                                  child: _ProjectCard(report: r),
                                );
                              }).toList(),
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFilters(ThemeData theme, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkSurface : AppTheme.lightSurface,
        border: Border(
          bottom: BorderSide(color: isDark ? Colors.white12 : Colors.black12),
        ),
      ),
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          SizedBox(
            width: 300,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search projects...',
                prefixIcon: const Icon(Icons.search),
                isDense: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (val) =>
                  ref.read(progressSearchQueryProvider.notifier).update(val),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKPIs({
    required ThemeData theme,
    required bool isDark,
    required double totalProgress,
    required int totalProjects,
    required int autoCalculated,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _KpiCard(
              title: 'Avg Overall Progress',
              value:
                  '${(totalProgress.isNaN || totalProgress.isInfinite ? 0.0 : totalProgress).toStringAsFixed(1)}%',
              icon: Icons.pie_chart,
              color: Colors.blue,
              width: _getKpiWidth(constraints.maxWidth),
            ),
            _KpiCard(
              title: 'Total Projects',
              value: '$totalProjects',
              icon: Icons.business,
              color: Colors.indigo,
              width: _getKpiWidth(constraints.maxWidth),
            ),
            _KpiCard(
              title: 'Auto-Calculated',
              value: '$autoCalculated',
              icon: Icons.auto_graph,
              color: Colors.green,
              width: _getKpiWidth(constraints.maxWidth),
            ),
          ],
        );
      },
    );
  }

  double _getKpiWidth(double maxWidth) {
    if (maxWidth > 1200) return (maxWidth - (16 * 2)) / 3;
    if (maxWidth > 600) return (maxWidth - 16) / 2;
    return maxWidth;
  }

  void _showCreateProgressDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const _CreateProgressDialog(),
    );
  }
}

class _KpiCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final double width;

  const _KpiCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: width,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkSurface : AppTheme.lightSurface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withValues(alpha: 0.1),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isDark ? Colors.white70 : Colors.black54,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProjectCard extends StatelessWidget {
  final ProgressReport report;

  const _ProjectCard({required this.report});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: isDark ? AppTheme.darkSurface : AppTheme.lightSurface,
      child: InkWell(
        onTap: () => context.push('/progress/details/${report.projectUuid}'),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      report.projectName,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  _AutoCalcChip(isAuto: report.isAutoCalculated),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Overall Progress', style: theme.textTheme.bodySmall),
                  Text(
                    '${(report.overallProgress.isNaN || report.overallProgress.isInfinite ? 0.0 : report.overallProgress).toStringAsFixed(1)}%',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value:
                    (report.overallProgress.isNaN ||
                            report.overallProgress.isInfinite
                        ? 0.0
                        : report.overallProgress) /
                    100,
                backgroundColor: isDark ? Colors.white12 : Colors.grey.shade200,
                color: theme.colorScheme.primary,
                minHeight: 6,
                borderRadius: BorderRadius.circular(3),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.category, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    '${report.categories.length} Categories',
                    style: theme.textTheme.bodySmall,
                  ),
                  const Spacer(),
                  Text(
                    'Updated: ${DateFormat('MMM dd, yyyy').format(report.updatedAt)}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AutoCalcChip extends StatelessWidget {
  final bool isAuto;
  const _AutoCalcChip({required this.isAuto});

  @override
  Widget build(BuildContext context) {
    final color = isAuto ? Colors.green : Colors.orange;
    final text = isAuto ? 'Auto' : 'Manual';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _CreateProgressDialog extends ConsumerStatefulWidget {
  const _CreateProgressDialog();

  @override
  ConsumerState<_CreateProgressDialog> createState() =>
      _CreateProgressDialogState();
}

class _CreateProgressDialogState extends ConsumerState<_CreateProgressDialog> {
  String? _selectedProjectUuid;
  String? _selectedProjectName;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final projectsAsync = ref.watch(projectsListProvider);
    final progressState = ref.watch(progressNotifierProvider);

    return AlertDialog(
      title: const Text('Track New Project Progress'),
      content: projectsAsync.when(
        loading: () => const SizedBox(
          height: 100,
          child: Center(child: CircularProgressIndicator()),
        ),
        error: (err, _) => Text('Error loading projects: $err'),
        data: (projects) {
          final existingUuids =
              progressState.value?.map((r) => r.projectUuid).toSet() ?? {};
          final availableProjects = projects
              .where((p) => !existingUuids.contains(p.uuid))
              .toList();

          if (availableProjects.isEmpty) {
            return const Text('All active projects are already being tracked.');
          }

          return SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Select a project to start tracking its progress:'),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  isExpanded: true,
                  decoration: const InputDecoration(
                    labelText: 'Project',
                    border: OutlineInputBorder(),
                  ),
                  initialValue: _selectedProjectUuid,
                  items: availableProjects.map((p) {
                    return DropdownMenuItem(
                      value: p.uuid,
                      child: Text(p.name, overflow: TextOverflow.ellipsis),
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      _selectedProjectUuid = val;
                      _selectedProjectName = availableProjects
                          .firstWhere((p) => p.uuid == val)
                          .name;
                    });
                  },
                ),
              ],
            ),
          );
        },
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        if (_isLoading)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          )
        else
          ElevatedButton(
            onPressed: _selectedProjectUuid == null ? null : _createReport,
            child: const Text('Start Tracking'),
          ),
      ],
    );
  }

  Future<void> _createReport() async {
    setState(() => _isLoading = true);

    try {
      final newReport = ProgressReport(
        uuid: 'PRG-${DateTime.now().millisecondsSinceEpoch}',
        projectUuid: _selectedProjectUuid!,
        projectName: _selectedProjectName!,
        overallProgress: 0.0,
        isAutoCalculated: false,
        categories: [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isSynced: false,
      );

      await ref.read(progressNotifierProvider.notifier).saveReport(newReport);

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
        setState(() => _isLoading = false);
      }
    }
  }
}
