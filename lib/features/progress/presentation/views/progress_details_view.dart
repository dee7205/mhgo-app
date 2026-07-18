import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/progress_entities.dart';
import '../providers/progress_provider.dart';
import '../../../projects/presentation/providers/projects_provider.dart';
import 'package:uuid/uuid.dart';

class ProgressDetailsView extends ConsumerWidget {
  final String id;
  const ProgressDetailsView({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final reportAsync = ref.watch(progressNotifierProvider);

    return reportAsync.when(
      loading: () => Scaffold(
        backgroundColor: isDark ? AppTheme.darkBg : AppTheme.lightBg,
        appBar: AppBar(title: const Text('Progress Details')),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        backgroundColor: isDark ? AppTheme.darkBg : AppTheme.lightBg,
        appBar: AppBar(title: const Text('Progress Details')),
        body: Center(child: Text('Error: $error')),
      ),
      data: (reports) {
        final report = reports.cast<ProgressReport?>().firstWhere(
          (r) => r?.projectUuid == id || r?.uuid == id,
          orElse: () => null,
        );

        if (report == null) {
          return Scaffold(
            backgroundColor: isDark ? AppTheme.darkBg : AppTheme.lightBg,
            appBar: AppBar(title: const Text('Progress Details')),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.analytics_outlined,
                    size: 64,
                    color: theme.colorScheme.secondary.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No progress tracking initialized for this project.',
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Start Tracking Progress'),
                    onPressed: () async {
                      final projects =
                          ref.read(projectsListProvider).value ?? [];
                      final project = projects.firstWhere(
                        (p) => p.uuid == id,
                        orElse: () => throw Exception('Project not found'),
                      );

                      final newReport = ProgressReport(
                        uuid: id, // 1:1 project-progress uuid
                        projectUuid: id,
                        projectName: project.name,
                        overallProgress: 0.0,
                        createdAt: DateTime.now(),
                        updatedAt: DateTime.now(),
                        isSynced: false,
                        categories: [],
                        isAutoCalculated: false,
                      );
                      await ref
                          .read(progressNotifierProvider.notifier)
                          .saveReport(newReport);
                    },
                  ),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          backgroundColor: isDark ? AppTheme.darkBg : AppTheme.lightBg,
          appBar: AppBar(
            title: Text(report.projectName),
            backgroundColor: isDark
                ? AppTheme.darkSurface
                : AppTheme.lightSurface,
            actions: [
              Row(
                children: [
                  const Text('Auto-Calc', style: TextStyle(fontSize: 12)),
                  Switch(
                    value: report.isAutoCalculated,
                    onChanged: (val) {
                      ref
                          .read(progressNotifierProvider.notifier)
                          .toggleAutoCalculate(report.uuid, val);
                    },
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Delete Progress Tracking'),
                      content: const Text(
                        'Are you sure you want to delete all progress data for this project?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            ref
                                .read(progressNotifierProvider.notifier)
                                .deleteReport(report.uuid);
                            Navigator.pop(ctx);
                            context.pop();
                          },
                          child: const Text(
                            'Delete',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(width: 8),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            heroTag: 'progress-details-fab',
            onPressed: () => context.push('/progress/update/$id'),
            icon: const Icon(Icons.add),
            label: const Text('Add Category'),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildOverallProgressCard(context, ref, report, theme, isDark),
              Expanded(
                child: _buildCategoriesList(
                  context,
                  ref,
                  report,
                  theme,
                  isDark,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOverallProgressCard(
    BuildContext context,
    WidgetRef ref,
    ProgressReport report,
    ThemeData theme,
    bool isDark,
  ) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      elevation: 0,
      color: isDark ? AppTheme.darkSurface : AppTheme.lightSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: isDark ? Colors.white12 : Colors.black12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Overall Project Progress',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${(report.overallProgress.isNaN || report.overallProgress.isInfinite ? 0.0 : report.overallProgress).toStringAsFixed(1)}%',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (report.isAutoCalculated)
              LinearProgressIndicator(
                value:
                    (report.overallProgress.isNaN ||
                            report.overallProgress.isInfinite
                        ? 0.0
                        : report.overallProgress) /
                    100,
                backgroundColor: isDark ? Colors.white12 : Colors.grey.shade200,
                color: theme.colorScheme.primary,
                minHeight: 12,
                borderRadius: BorderRadius.circular(6),
              )
            else
              Slider(
                value:
                    (report.overallProgress.isNaN ||
                                report.overallProgress.isInfinite
                            ? 0.0
                            : report.overallProgress)
                        .clamp(0.0, 100.0),
                min: 0,
                max: 100,
                divisions: 100,
                label:
                    '${(report.overallProgress.isNaN || report.overallProgress.isInfinite ? 0 : report.overallProgress).round()}%',
                onChanged: (val) {
                  ref
                      .read(progressNotifierProvider.notifier)
                      .updateOverallProgress(report.uuid, val);
                },
              ),
            const SizedBox(height: 8),
            Text(
              report.isAutoCalculated
                  ? 'Automatically calculated as the average of active categories.'
                  : 'Manual mode enabled. Drag the slider to set progress.',
              style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriesList(
    BuildContext context,
    WidgetRef ref,
    ProgressReport report,
    ThemeData theme,
    bool isDark,
  ) {
    if (report.categories.isEmpty) {
      return const Center(child: Text('No custom categories defined.'));
    }

    final sortedCategories = List<ProgressCategory>.from(report.categories);
    sortedCategories.sort((a, b) => a.orderIndex.compareTo(b.orderIndex));

    return Theme(
      data: theme.copyWith(canvasColor: Colors.transparent),
      child: ReorderableListView.builder(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 80),
        itemCount: sortedCategories.length,
        onReorder: (oldIndex, newIndex) {
          ref
              .read(progressNotifierProvider.notifier)
              .reorderCategories(report.uuid, oldIndex, newIndex);
        },
        itemBuilder: (context, index) {
          final cat = sortedCategories[index];
          return Card(
            key: ValueKey(cat.id),
            margin: const EdgeInsets.only(bottom: 12),
            color: isDark ? AppTheme.darkSurface : AppTheme.lightSurface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: isDark ? Colors.white12 : Colors.black12),
            ),
            child: Opacity(
              opacity: cat.isArchived ? 0.5 : 1.0,
              child: ListTile(
                contentPadding: const EdgeInsets.all(12),
                title: Row(
                  children: [
                    Expanded(
                      child: Text(
                        cat.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          decoration: cat.isArchived
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                    ),
                    _StatusChip(status: cat.status),
                  ],
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (cat.description != null && cat.description!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                        child: Text(cat.description!),
                      ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: LinearProgressIndicator(
                            value:
                                (cat.progress.isNaN || cat.progress.isInfinite
                                    ? 0.0
                                    : cat.progress) /
                                100,
                            backgroundColor: isDark
                                ? Colors.white12
                                : Colors.grey.shade200,
                            color: _getStatusColor(cat.status),
                            minHeight: 6,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '${(cat.progress.isNaN || cat.progress.isInfinite ? 0.0 : cat.progress).toStringAsFixed(1)}%',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 14,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          cat.targetDate != null
                              ? 'Target: ${DateFormat('MMM dd').format(cat.targetDate!)}'
                              : 'No target date',
                          style: theme.textTheme.bodySmall,
                        ),
                        const Spacer(),
                        Text(
                          'Updated: ${DateFormat('MMM dd').format(cat.lastUpdated)}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                trailing: PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert),
                  onSelected: (val) {
                    if (val == 'edit') {
                      context.push(
                        '/progress/update/${report.uuid}?categoryId=${cat.id}',
                      );
                    } else if (val == 'archive') {
                      final updatedCat = cat.copyWith(
                        isArchived: !cat.isArchived,
                      );
                      ref
                          .read(progressNotifierProvider.notifier)
                          .updateCategory(report.uuid, updatedCat);
                    } else if (val == 'delete') {
                      // Ask for confirmation
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Delete Category'),
                          content: const Text(
                            'Are you sure you want to delete this category?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                ref
                                    .read(progressNotifierProvider.notifier)
                                    .deleteCategory(report.uuid, cat.id);
                                Navigator.pop(ctx);
                              },
                              child: const Text(
                                'Delete',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: 'edit', child: Text('Edit')),
                    PopupMenuItem(
                      value: 'archive',
                      child: Text(cat.isArchived ? 'Unarchive' : 'Archive'),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Text(
                        'Delete',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'On Track':
        return Colors.green;
      case 'At Risk':
        return Colors.orange;
      case 'Delayed':
        return Colors.red;
      case 'Completed':
        return Colors.teal;
      default:
        return Colors.blue;
    }
  }
}

class _StatusChip extends StatelessWidget {
  final String status;
  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (status) {
      case 'On Track':
        color = Colors.green;
        break;
      case 'At Risk':
        color = Colors.orange;
        break;
      case 'Delayed':
        color = Colors.red;
        break;
      case 'Completed':
        color = Colors.teal;
        break;
      default:
        color = Colors.blue;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
