import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mhgo/core/theme/app_theme.dart';
import 'package:mhgo/core/widgets/app_card.dart';
import 'package:mhgo/core/widgets/app_button.dart';
import 'package:mhgo/core/database/models/project_model.dart';
import 'package:mhgo/features/projects/domain/entities/projects_entities.dart';
import 'package:mhgo/features/projects/presentation/providers/projects_provider.dart';
import 'package:mhgo/features/projects/presentation/widgets/project_create_edit_dialog.dart';
import 'package:mhgo/features/materials/presentation/widgets/project_material_requirements_tab.dart';

class ProjectDetailsView extends ConsumerStatefulWidget {
  final String uuid;

  // Add getter for projectUuid aliases
  String get projectUuid => uuid;

  const ProjectDetailsView({
    super.key,
    required this.uuid,
  });

  @override
  ConsumerState<ProjectDetailsView> createState() => _ProjectDetailsViewState();
}

class _ProjectDetailsViewState extends ConsumerState<ProjectDetailsView> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    final detailsAsync = ref.watch(projectDetailsProvider(widget.uuid));

    return detailsAsync.when(
      loading: () => Scaffold(
        backgroundColor: isDark ? AppTheme.darkBg : AppTheme.lightBg,
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (err, stack) => Scaffold(
        backgroundColor: isDark ? AppTheme.darkBg : AppTheme.lightBg,
        appBar: AppBar(title: const Text('Error')),
        body: _buildErrorState(err.toString()),
      ),
      data: (data) => _buildProjectLayout(data, theme, isDark),
    );
  }

  // --- HEADER & TABBED LAYOUT ---
  Widget _buildProjectLayout(DetailedProjectData data, ThemeData theme, bool isDark) {
    final project = data.project;
    final statusColor = _getStatusColor(project.status);

    return Scaffold(
      backgroundColor: isDark ? AppTheme.darkBg : AppTheme.lightBg,
      appBar: AppBar(
        title: Text(project.name),
        backgroundColor: isDark ? AppTheme.darkSurface : AppTheme.lightSurface,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == 'edit') {
                showDialog(
                  context: context,
                  builder: (ctx) => ProjectCreateEditDialog(existingProject: project),
                );
              } else if (value == 'pdf') {
                context.push('/projects/${project.uuid}/pdf');
              } else if (value == 'delete') {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Delete Project?'),
                    content: Text('Are you sure you want to delete ${project.name}? This action cannot be undone.'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        child: const Text('Delete', style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );
                
                if (confirm == true && context.mounted) {
                  final repo = ref.read(projectsRepositoryProvider);
                  await repo.deleteProject(project.uuid);
                  ref.invalidate(projectsListProvider);
                  if (context.mounted) {
                    context.pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${project.name} deleted successfully')),
                    );
                  }
                }
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'pdf', child: Text('Export PDF Specs')),
              const PopupMenuItem(value: 'edit', child: Text('Edit Project')),
              const PopupMenuItem(value: 'delete', child: Text('Delete Project', style: TextStyle(color: Colors.red))),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'project-details-fab',
        onPressed: () {
          context.push('/progress/details/${project.uuid}');
        },
        icon: const Icon(Icons.timeline),
        label: const Text('View Progress'),
      ),
      body: SafeArea(
        child: Column(
          children: [

        // 2. Main Title Header Card
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 750;

              final titleInfo = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 10,
                    runSpacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: statusColor.withOpacity(0.2)),
                        ),
                        child: Text(
                          project.status.toUpperCase(),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: statusColor,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),
                      Text(
                        '${project.capacityMw.toStringAsFixed(1)} ${project.capacityUnit ?? 'MWp'} • ${project.systemType != null ? '${project.systemType} ' : ''}${project.type}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    project.name,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1.0,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Client: ${project.client ?? "MHG Internals"} | Location: ${project.location}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary,
                    ),
                  ),
                ],
              );

              final progressIndicator = Column(
                crossAxisAlignment: isNarrow ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          'Current Stage: ${project.stage}',
                          style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '${(project.progress.isNaN || project.progress.isInfinite ? 0 : project.progress).toStringAsFixed(0)}%',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: isNarrow ? double.infinity : 200,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: LinearProgressIndicator(
                        value: (project.progress.isNaN || project.progress.isInfinite ? 0.0 : project.progress) / 100.0,
                        minHeight: 8.0,
                        backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                      ),
                    ),
                  ),
                ],
              );

              if (isNarrow) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    titleInfo,
                    const SizedBox(height: 16),
                    progressIndicator,
                    const SizedBox(height: 16),
                  ],
                );
              }

              return Row(
                children: [
                  Expanded(child: titleInfo),
                  const SizedBox(width: 24),
                  progressIndicator,
                ],
              );
            },
          ),
        ),

        const SizedBox(height: 12),

        // 3. Tab Bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              labelStyle: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
              unselectedLabelStyle: theme.textTheme.bodyMedium,
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: const [
                Tab(text: 'Overview & Analytics'),
                Tab(text: 'Timeline & Milestones'),
                Tab(text: 'Engineering Team'),
                Tab(text: 'Material Requirements'),
              ],
            ),
          ),
        ),

        const Divider(height: 1),

        // 4. Tab Bar View
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildOverviewTab(data, theme, isDark),
              _buildTimelineTab(data, theme, isDark),
              _buildTeamTab(data, theme, isDark),
              ProjectMaterialRequirementsTab(projectUuid: widget.uuid, projectType: data.project.type),
            ],
          ),
        ),
      ],
    ),),);
  }

  // ==========================================
  // TAB 1: OVERVIEW & ANALYTICS
  // ==========================================
  Widget _buildOverviewTab(DetailedProjectData data, ThemeData theme, bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth >= 950;

          final leftColumn = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProjectInfoCard(data.project, theme, isDark),
              const SizedBox(height: 20),
              _buildBomCard(data.project, theme, isDark),
              const SizedBox(height: 20),
              _buildCategoryProgressCard(data.categoryProgresses, theme, isDark),
              const SizedBox(height: 20),
            ],
          );

          final rightColumn = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildRecentActivityCard(data.activityLogs, theme, isDark),
              const SizedBox(height: 20),
            ],
          );

          if (isDesktop) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 5, child: leftColumn),
                const SizedBox(width: 20),
                Expanded(flex: 4, child: rightColumn),
              ],
            );
          }

          return Column(
            children: [
              leftColumn,
              const SizedBox(height: 20),
              rightColumn,
            ],
          );
        },
      ),
    );
  }

  // --- SUB-CARD: PROJECT INFO ---
  Widget _buildProjectInfoCard(ProjectModel project, ThemeData theme, bool isDark) {
    final formattedStart = DateFormat('MMMM dd, yyyy').format(project.startDate);
    final formattedEnd = DateFormat('MMMM dd, yyyy').format(project.endDate);

    return AppCard(
      variant: AppCardVariant.outlined,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Project Profile & Specs',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          if (project.description != null) ...[
            const SizedBox(height: 8),
            Text(
              project.description!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary,
              ),
            ),
          ],
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),
          _buildInfoRow('Client Name', project.client ?? 'MHG Internals', theme, isDark),
          _buildInfoRow('Contract Reference', 'CONTR-${project.uuid.toUpperCase().substring(0, 6)}', theme, isDark),
          _buildInfoRow('Site Location', project.location, theme, isDark),
          _buildInfoRow('Target Capacity', '${project.capacityMw.toStringAsFixed(2)} ${project.capacityUnit ?? 'MWp'}', theme, isDark),
          _buildInfoRow('Arrangement Type', project.type, theme, isDark),
          _buildInfoRow('Contract Start', formattedStart, theme, isDark),
          _buildInfoRow('Expected Completion', formattedEnd, theme, isDark),
          _buildInfoRow('Total Project Cost', NumberFormat.currency(symbol: '₱', decimalDigits: 2).format(project.totalCost), theme, isDark),
        ],
      ),
    );
  }

  // --- SUB-CARD: BOM SPECS ---
  Widget _buildBomCard(ProjectModel project, ThemeData theme, bool isDark) {
    Map<String, dynamic> solar = {};
    Map<String, dynamic> battery = {};
    Map<String, dynamic> inverter = {};

    if (project.bomSpecsJson != null) {
      try {
        final bom = jsonDecode(project.bomSpecsJson!);
        solar = bom['solar'] as Map<String, dynamic>? ?? {};
        battery = bom['battery'] as Map<String, dynamic>? ?? {};
        inverter = bom['inverter'] as Map<String, dynamic>? ?? {};
        
        // Backward compatibility
        if (solar.isEmpty && bom['panels'] != null) solar['brand'] = bom['panels'];
        if (battery.isEmpty && bom['battery'] != null) battery['brand'] = bom['battery'];
        if (inverter.isEmpty && bom['inverter'] != null) inverter['brand'] = bom['inverter'];
      } catch (_) {}
    }

    String formatSpecs(Map<String, dynamic> specs) {
      final entries = specs.entries.where((e) => e.value.toString().isNotEmpty);
      if (entries.isEmpty) return 'N/A';
      return entries.map((e) => '${e.key.toUpperCase()}: ${e.value}').join(' | ');
    }

    return AppCard(
      variant: AppCardVariant.elevated,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.inventory_2, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                'BOM Specifications',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoRow('Solar Panels', formatSpecs(solar), theme, isDark),
          _buildInfoRow('Inverter', formatSpecs(inverter), theme, isDark),
          _buildInfoRow('Battery System', formatSpecs(battery), theme, isDark),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, ThemeData theme, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isDark ? AppTheme.darkTextMuted : AppTheme.lightTextSecondary,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // --- SUB-CARD: ENGINEERING PROGRESS ---
  Widget _buildCategoryProgressCard(List<ProjectCategoryProgress> categories, ThemeData theme, bool isDark) {
    return AppCard(
      variant: AppCardVariant.outlined,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Project Progress Categories',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 16),
          if (categories.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Center(
                child: Text(
                  'No categories added yet.',
                  style: theme.textTheme.bodyMedium?.copyWith(color: theme.disabledColor),
                ),
              ),
            ),
          ...categories.map((stage) {
            final double val = stage.progress / 100.0;
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          stage.name,
                          style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        '${stage.progress.toStringAsFixed(0)}%',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: LinearProgressIndicator(
                      value: val,
                      minHeight: 5.0,
                      backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.08),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // --- SUB-CARD: SAFETY & OPERATIONS KPIS ----

  Widget _buildKpiGridItem(
    String title,
    String value,
    IconData icon,
    Color color,
    ThemeData theme,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkSurface : AppTheme.lightSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(fontSize: 10),
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w900,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  // --- SUB-CARD: RECENT ACTIVITY LOG ---
  Widget _buildRecentActivityCard(List<ProjectActivityLog> logs, ThemeData theme, bool isDark) {
    return AppCard(
      variant: AppCardVariant.outlined,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Field Operations Log',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 16),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: logs.length,
            separatorBuilder: (context, index) => const Divider(height: 24),
            itemBuilder: (context, idx) {
              final log = logs[idx];
              final categoryColor = _getCategoryColor(log.category);
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: categoryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      log.category == 'QC'
                          ? Icons.verified_user_outlined
                          : (log.category == 'Logistics' ? Icons.local_shipping_outlined : Icons.engineering_outlined),
                      size: 14,
                      color: categoryColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                log.title,
                                style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              DateFormat('HH:mm').format(log.timestamp),
                              style: theme.textTheme.bodySmall?.copyWith(fontSize: 10),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          log.description,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'By: ${log.author}',
                          style: theme.textTheme.bodySmall?.copyWith(fontSize: 9, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  // --- SUB-CARD: SUMMARY REGISTER METRICS --

  Widget _buildSummaryListItem(
    String title,
    String detail,
    String statusText,
    IconData icon,
    ThemeData theme,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkSurface : AppTheme.lightSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder),
      ),
      child: Row(
        children: [
          Icon(icon, color: theme.colorScheme.primary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  detail,
                  style: theme.textTheme.bodySmall?.copyWith(fontSize: 10, color: theme.disabledColor),
                ),
                const SizedBox(height: 2),
                Text(
                  statusText,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: 9,
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // TAB 2: TIMELINE & MILESTONES
  // ==========================================
  Widget _buildTimelineTab(DetailedProjectData data, ThemeData theme, bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: AppCard(
            variant: AppCardVariant.outlined,
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Vertical Milestone Timeline',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Text(
                  'Key deliverables, actual completion dates, and personnel responsibilities.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary,
                  ),
                ),
                const SizedBox(height: 32),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: data.timeline.length,
                  itemBuilder: (context, index) {
                    final item = data.timeline[index];
                    final isLast = index == data.timeline.length - 1;

                    // this is for the "status" color on the project & milestones tab
                    Color dotColor;
                    IconData statusIcon;
                    switch (item.status) {
                      case 'Completed':
                      case 'completed':
                        dotColor = const Color(0xFF2E7D32); // Solar Green
                        statusIcon = Icons.check_circle_outline;
                        break;
                      case 'Delayed':
                      case 'delayed':
                        dotColor = const Color(0xFFD32F2F); // Red
                        statusIcon = Icons.error_outline;
                        break;
                      case 'At Risk':
                        dotColor = const Color(0xFFFFB300); // Amber
                        statusIcon = Icons.warning_amber_rounded;
                        break;
                      case 'On Track':
                        dotColor = theme.colorScheme.primary;
                        statusIcon = Icons.play_circle_outline;
                        break;
                      case 'upcoming':
                      case 'Not Started':
                      default:
                        dotColor = theme.disabledColor;
                        statusIcon = Icons.schedule;
                        break;
                    }

                    return IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Left Indicator Line
                          Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: dotColor.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: dotColor, width: 2),
                                ),
                                child: Icon(statusIcon, size: 16, color: dotColor),
                              ),
                              if (!isLast)
                                Expanded(
                                  child: Container(
                                    width: 2.0,
                                    color: item.status == 'completed' 
                                        ? const Color(0xFF2E7D32) 
                                        : theme.disabledColor.withOpacity(0.3),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(width: 16),
                          // Content Card
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 28.0),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: isDark ? AppTheme.darkSurface : AppTheme.lightSurface,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            item.milestoneName,
                                            style: theme.textTheme.bodyMedium?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: dotColor.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            item.status.toUpperCase(),
                                            style: theme.textTheme.labelSmall?.copyWith(
                                              color: dotColor,
                                              fontSize: 9,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      'Target Date: ${DateFormat('MMMM dd, yyyy').format(item.date)}',
                                      style: theme.textTheme.bodySmall?.copyWith(fontSize: 11),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Milestone Owner: ${item.owner}',
                                      style: theme.textTheme.bodySmall?.copyWith(
                                        fontSize: 11,
                                        color: theme.colorScheme.primary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(100),
                                            child: LinearProgressIndicator(
                                              value: item.progress,
                                              minHeight: 4.0,
                                              backgroundColor: theme.colorScheme.primary.withOpacity(0.08),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          '${(item.progress.isNaN || item.progress.isInfinite ? 0 : item.progress).toStringAsFixed(0)}%',
                                          style: theme.textTheme.bodySmall?.copyWith(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================
  // TAB 3: TEAM MEMBERS
  // ==========================================
  Widget _buildTeamTab(DetailedProjectData data, ThemeData theme, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Project Team',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              AppButton(
                text: 'Add Member',
                icon: Icons.person_add,
                width: 110,
                onPressed: () => _showTeamMemberDialog(data, null),
              ),
            ],
          ),
        ),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final double width = constraints.maxWidth;
              int crossAxisCount = 1;
              if (width >= 1100) {
                crossAxisCount = 3;
              } else if (width >= 700) {
                crossAxisCount = 2;
              }

              if (data.team.isEmpty) {
                return Center(
                  child: Text('No team members added yet.', style: theme.textTheme.bodyMedium),
                );
              }

              return GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 2.0,
                ),
                itemCount: data.team.length,
                itemBuilder: (context, index) {
                  final member = data.team[index];

                  return AppCard(
                    variant: AppCardVariant.outlined,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: theme.colorScheme.primaryContainer,
                              child: Text(
                                member.avatarInitials,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onPrimaryContainer,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    member.name,
                                    style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    '${member.role} (${member.department})',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: theme.textTheme.bodySmall?.copyWith(fontSize: 11, color: theme.disabledColor),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit, size: 16),
                              onPressed: () => _showTeamMemberDialog(data, index),
                              tooltip: 'Edit',
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, size: 16, color: Colors.redAccent),
                              onPressed: () => _deleteTeamMember(data, index),
                              tooltip: 'Delete',
                            ),
                          ],
                        ),
                        const Spacer(),
                        const Divider(),
                        const Spacer(),
                        Row(
                          children: [
                            const Icon(Icons.email_outlined, size: 12, color: Colors.grey),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                member.contactEmail,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.bodySmall?.copyWith(fontSize: 10),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const Icon(Icons.phone_outlined, size: 12, color: Colors.grey),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                member.contactPhone,
                                style: theme.textTheme.bodySmall?.copyWith(fontSize: 10),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Future<void> _showTeamMemberDialog(DetailedProjectData data, int? editIndex) async {
    final isEdit = editIndex != null;
    final member = isEdit ? data.team[editIndex] : null;

    final nameController = TextEditingController(text: member?.name);
    final roleController = TextEditingController(text: member?.role);
    final deptController = TextEditingController(text: member?.department);
    final emailController = TextEditingController(text: member?.contactEmail);
    final phoneController = TextEditingController(text: member?.contactPhone);

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isEdit ? 'Edit Team Member' : 'Add Team Member'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: roleController,
                  decoration: const InputDecoration(labelText: 'Role', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: deptController,
                  decoration: const InputDecoration(labelText: 'Department', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: phoneController,
                  decoration: const InputDecoration(labelText: 'Phone', border: OutlineInputBorder()),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final newMember = ProjectTeamMember(
                  name: nameController.text.trim(),
                  role: roleController.text.trim(),
                  department: deptController.text.trim(),
                  contactEmail: emailController.text.trim(),
                  contactPhone: phoneController.text.trim(),
                  assignedTasksCount: member?.assignedTasksCount ?? 0,
                  workload: member?.workload ?? 'Optimal',
                  avatarInitials: nameController.text.trim().isNotEmpty 
                      ? nameController.text.trim().substring(0, 1).toUpperCase() 
                      : '?',
                );

                final updatedTeam = List<ProjectTeamMember>.from(data.team);
                if (isEdit) {
                  updatedTeam[editIndex] = newMember;
                } else {
                  updatedTeam.add(newMember);
                }

                await ref.read(projectsRepositoryProvider).updateProjectTeam(widget.projectUuid, updatedTeam);
                ref.invalidate(projectDetailsProvider(widget.projectUuid));
                if (context.mounted) Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteTeamMember(DetailedProjectData data, int index) async {
    final updatedTeam = List<ProjectTeamMember>.from(data.team);
    updatedTeam.removeAt(index);
    await ref.read(projectsRepositoryProvider).updateProjectTeam(widget.projectUuid, updatedTeam);
    ref.invalidate(projectDetailsProvider(widget.projectUuid));
  }

  // --- SKELETON / ERROR ---
  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 56, color: Color(0xFFD32F2F)),
          const SizedBox(height: 16),
          Text('Failed to load project details', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(message, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 24),
          AppButton(
            text: 'Return to Projects',
            onPressed: () => context.pop(),
          ),
        ],
      ),
    );
  }
}

// --- HELPER LOG COLOR GETTERS ---
Color _getCategoryColor(String category) {
  switch (category) {
    case 'QC':
      return const Color(0xFF2E7D32); // Green
    case 'Logistics':
      return const Color(0xFFFFB300); // Amber
    case 'Engineering':
      return const Color(0xFF2196F3); // Sky Blue
    default:
      return Colors.grey;
  }
}

Color _getWorkloadColor(String workload) {
  switch (workload.toLowerCase()) {
    case 'high':
      return const Color(0xFFD32F2F); // Red
    case 'optimal':
      return const Color(0xFF2E7D32); // Solar Green
    case 'medium':
      return const Color(0xFFFFB300); // Amber
    case 'low':
    default:
      return const Color(0xFF2196F3); // Sky Blue
  }
}

Color _getStatusColor(String status) {
  switch (status.toLowerCase()) {
    case 'planning':
      return const Color(0xFF2196F3);
    case 'construction':
      return const Color(0xFFFFB300);
    case 'commissioning':
      return const Color(0xFF9C27B0);
    case 'completed':
    case 'om':
      return const Color(0xFF2E7D32);
    case 'on_hold':
    default:
      return const Color(0xFFD32F2F);
  }
}
