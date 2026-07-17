import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mhgo/core/theme/app_theme.dart';
import 'package:mhgo/core/widgets/app_card.dart';
import 'package:mhgo/core/widgets/app_button.dart';
import 'package:mhgo/core/database/models/project_model.dart';
import 'package:mhgo/features/projects/presentation/providers/projects_provider.dart';
import 'package:mhgo/features/projects/presentation/widgets/project_create_edit_dialog.dart';

class ProjectsListView extends ConsumerStatefulWidget {
  const ProjectsListView({super.key});

  @override
  ConsumerState<ProjectsListView> createState() => _ProjectsListViewState();
}

class _ProjectsListViewState extends ConsumerState<ProjectsListView> {
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
    
    final projectsAsync = ref.watch(projectsListProvider);
    final searchQuery = ref.watch(projectsSearchQueryProvider);
    final filterStatus = ref.watch(projectsFilterStatusProvider);
    final sortBy = ref.watch(projectsSortProvider);
    final isGridView = ref.watch(projectsGridViewProvider);

    return Scaffold(
      backgroundColor: isDark ? AppTheme.darkBg : AppTheme.lightBg,
      appBar: AppBar(
        title: Text(
          'Engineering Projects',
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
              ref.read(projectsGridViewProvider.notifier).toggle();
            },
          ),
          const SizedBox(width: 6),
          AppButton(
            text: 'New Project',
            icon: Icons.add,
            variant: AppButtonVariant.primary,
            height: 36,
            width: 110,
            onPressed: () => _showAddProjectDialog(context, ref),
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(projectsListProvider);
          },
          child: projectsAsync.when(
            loading: () => _buildSkeletonLoading(),
            error: (err, stack) => _buildErrorState(err.toString()),
            data: (projects) {
              // Apply search query filter
              var filtered = projects.where((p) {
                final query = searchQuery.toLowerCase();
                return p.name.toLowerCase().contains(query) ||
                    (p.client?.toLowerCase() ?? '').contains(query) ||
                    p.location.toLowerCase().contains(query);
              }).toList();

              // Apply status filters
              if (filterStatus != null) {
                if (filterStatus == 'active') {
                  // Active means planning, construction, or commissioning
                  filtered = filtered.where((p) => 
                      p.status == 'planning' || 
                      p.status == 'construction' || 
                      p.status == 'commissioning').toList();
                } else {
                  filtered = filtered.where((p) => p.status == filterStatus).toList();
                }
              }

              // Apply sorting options
              filtered.sort((a, b) {
                switch (sortBy) {
                  case 'progress':
                    return b.progress.compareTo(a.progress);
                  case 'capacity':
                    return b.capacityMw.compareTo(a.capacityMw);
                  case 'completion':
                    return a.endDate.compareTo(b.endDate);
                  case 'name':
                  default:
                    return a.name.toLowerCase().compareTo(b.name.toLowerCase());
                }
              });

              return CustomScrollView(
                slivers: [
                  // Filter and Search Header Panel
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSearchAndSortRow(theme, isDark),
                          const SizedBox(height: 16),
                          _buildFilterChipsRow(theme, isDark),
                        ],
                      ),
                    ),
                  ),

                  // Project List Grid/List section
                  if (filtered.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: _buildEmptyState(),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                      sliver: isGridView
                          ? _buildProjectsGrid(filtered, theme, isDark)
                          : _buildProjectsList(filtered, theme, isDark),
                    ),
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 48),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  // --- SEARCH AND SORT BAR ---
  Widget _buildSearchAndSortRow(ThemeData theme, bool isDark) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final useVerticalLayout = constraints.maxWidth < 650;
        final sortBy = ref.watch(projectsSortProvider);

        final searchField = TextField(
          controller: _searchController,
          onChanged: (val) {
            ref.read(projectsSearchQueryProvider.notifier).set(val);
          },
          decoration: InputDecoration(
            hintText: 'Search projects by name, client, or site location...',
            prefixIcon: const Icon(Icons.search, size: 20),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, size: 18),
                    onPressed: () {
                      _searchController.clear();
                      ref.read(projectsSearchQueryProvider.notifier).clear();
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

        final sortDropdown = Container(
          width: 170,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: isDark ? AppTheme.darkSurface : AppTheme.lightSurface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: sortBy,
              isExpanded: true,
              icon: const Icon(Icons.sort_rounded, size: 18),
              style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
              onChanged: (val) {
                if (val != null) {
                  ref.read(projectsSortProvider.notifier).set(val);
                }
              },
              items: const [
                DropdownMenuItem(value: 'name', child: Text('Sort by Name', overflow: TextOverflow.ellipsis)),
                DropdownMenuItem(value: 'progress', child: Text('Sort by Progress', overflow: TextOverflow.ellipsis)),
                DropdownMenuItem(value: 'capacity', child: Text('Sort by Capacity', overflow: TextOverflow.ellipsis)),
                DropdownMenuItem(value: 'completion', child: Text('Sort by Completion', overflow: TextOverflow.ellipsis)),
              ],
            ),
          ),
        );

        if (useVerticalLayout) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              searchField,
              const SizedBox(height: 12),
              sortDropdown,
            ],
          );
        }

        return Row(
          children: [
            Expanded(child: searchField),
            const SizedBox(width: 16),
            sortDropdown,
          ],
        );
      },
    );
  }

  // --- FILTER CHIPS ROW ---
  Widget _buildFilterChipsRow(ThemeData theme, bool isDark) {
    final activeFilter = ref.watch(projectsFilterStatusProvider);
    
    final filters = [
      {'label': 'All Projects', 'value': null},
      {'label': 'Active Sites', 'value': 'active'},
      {'label': 'Planning', 'value': 'planning'},
      {'label': 'Construction', 'value': 'construction'},
      {'label': 'Commissioning', 'value': 'commissioning'},
      {'label': 'Completed', 'value': 'completed'},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((filter) {
          final isSelected = activeFilter == filter['value'];
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              label: Text(filter['label'] as String),
              selected: isSelected,
              onSelected: (_) {
                ref.read(projectsFilterStatusProvider.notifier).set(filter['value'] as String?);
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

  // --- PROJECTS GRID MODE ---
  Widget _buildProjectsGrid(List<ProjectModel> projects, ThemeData theme, bool isDark) {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 420,
        mainAxisSpacing: 24,
        crossAxisSpacing: 24,
        mainAxisExtent: 280, // Consistent fixed height for Project cards
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final project = projects[index];
          return _ProjectGridCard(project: project, theme: theme, isDark: isDark);
        },
        childCount: projects.length,
      ),
    );
  }

  // --- PROJECTS LIST MODE ---
  Widget _buildProjectsList(List<ProjectModel> projects, ThemeData theme, bool isDark) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final project = projects[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: _ProjectListCard(project: project, theme: theme, isDark: isDark),
          );
        },
        childCount: projects.length,
      ),
    );
  }

  // --- SKELETON LOADING ---
  Widget _buildSkeletonLoading() {
    return const Center(child: CircularProgressIndicator());
  }

  // --- ERROR STATE ---
  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 56, color: Color(0xFFD32F2F)),
          const SizedBox(height: 16),
          Text('Failed to load projects', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(message, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 24),
          AppButton(
            text: 'Retry',
            onPressed: () => ref.invalidate(projectsListProvider),
          ),
        ],
      ),
    );
  }

  // --- EMPTY STATE ---
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2_outlined, size: 56, color: Theme.of(context).disabledColor),
          const SizedBox(height: 16),
          Text('No projects matched your filters', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          const Text('Try adjusting your search criteria or filter status.'),
        ],
      ),
    );
  }

  void _showAddProjectDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => const ProjectCreateEditDialog(),
    );
  }
}

// --- PROJECT GRID CARD ---
class _ProjectGridCard extends StatelessWidget {
  final ProjectModel project;
  final ThemeData theme;
  final bool isDark;

  const _ProjectGridCard({
    required this.project,
    required this.theme,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(project.status);
    final formattedStart = DateFormat('MMMM yyyy').format(project.startDate);
    final formattedEnd = DateFormat('MMMM yyyy').format(project.endDate);

    return AppCard(
      variant: AppCardVariant.outlined,
      padding: const EdgeInsets.all(24),
      onTap: () {
        context.push('/projects/${project.uuid}');
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Status & Type Tag
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            spacing: 8,
            runSpacing: 8,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: statusColor.withOpacity(0.2)),
                ),
                child: Text(
                  project.status.toUpperCase(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Row(
                children: [
                  Icon(
                    project.type == 'Rooftop'
                        ? Icons.storefront_outlined
                        : (project.type == 'Floating' ? Icons.tsunami_outlined : Icons.landscape_outlined),
                    size: 16,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    project.type,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Title & Client
          Text(
            project.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Client: ${project.client ?? 'MHG Internals'}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary,
            ),
          ),
          const Spacer(),

          // Details grid
          _buildDetailRow(Icons.pin_drop_outlined, project.location),
          const SizedBox(height: 8),
          _buildDetailRow(Icons.flash_on_outlined, '${project.capacityMw.toStringAsFixed(1)} ${project.capacityUnit ?? 'MWp'} Capacity'),
          const SizedBox(height: 8),
          _buildDetailRow(Icons.calendar_month_outlined, '$formattedStart - $formattedEnd'),
          const SizedBox(height: 8),
          _buildDetailRow(Icons.engineering_outlined, 'Lead: ${project.supervisor ?? "N/A"}'),
          
          const Spacer(),

          // Progress section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Overall Stage: ${project.stage}',
                  style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                '${(project.progress.isNaN || project.progress.isInfinite ? 0 : project.progress).toStringAsFixed(0)}%',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: LinearProgressIndicator(
              value: (project.progress.isNaN || project.progress.isInfinite ? 0.0 : project.progress) / 100.0,
              minHeight: 6.0,
              backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: theme.disabledColor),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(fontSize: 12),
          ),
        ),
      ],
    );
  }
}

// --- PROJECT LIST CARD ---
class _ProjectListCard extends StatelessWidget {
  final ProjectModel project;
  final ThemeData theme;
  final bool isDark;

  const _ProjectListCard({
    required this.project,
    required this.theme,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(project.status);
    final formattedStart = DateFormat('MMMM yyyy').format(project.startDate);
    final formattedEnd = DateFormat('MMMM yyyy').format(project.endDate);

    return AppCard(
      variant: AppCardVariant.outlined,
      padding: const EdgeInsets.all(20),
      onTap: () {
        context.push('/projects/${project.uuid}');
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 750;

          final titleSection = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                project.name,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: statusColor.withOpacity(0.15)),
                    ),
                    child: Text(
                      project.status.toUpperCase(),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.w800,
                        fontSize: 9,
                      ),
                    ),
                  ),
                  Text(
                    'Client: ${project.client ?? 'MHG Internals'}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary,
                    ),
                  ),
                ],
              ),
            ],
          );

          final detailsSection = Wrap(
            spacing: 24,
            runSpacing: 8,
            children: [
              _buildDetailItem(Icons.pin_drop_outlined, project.location),
              _buildDetailItem(Icons.flash_on_outlined, '${project.capacityMw.toStringAsFixed(1)} ${project.capacityUnit ?? 'MWp'}'),
              _buildDetailItem(Icons.calendar_month_outlined, '$formattedStart - $formattedEnd'),
              _buildDetailItem(Icons.engineering_outlined, project.supervisor ?? 'N/A'),
            ],
          );

          final progressSection = Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      project.stage ?? 'Planning',
                      style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${(project.progress.isNaN || project.progress.isInfinite ? 0 : project.progress).toStringAsFixed(0)}%',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: 150,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: LinearProgressIndicator(
                    value: (project.progress.isNaN || project.progress.isInfinite ? 0.0 : project.progress) / 100.0,
                    minHeight: 5.0,
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
                titleSection,
                const SizedBox(height: 16),
                detailsSection,
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Stage: ${project.stage}',
                        style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      '${(project.progress.isNaN || project.progress.isInfinite ? 0 : project.progress).toStringAsFixed(0)}% Complete',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            );
          }

          return Row(
            children: [
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    titleSection,
                    const SizedBox(height: 12),
                    detailsSection,
                  ],
                ),
              ),
              const SizedBox(width: 24),
              progressSection,
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
        Icon(icon, size: 14, color: theme.disabledColor),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            text,
            style: theme.textTheme.bodySmall?.copyWith(fontSize: 12),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

// --- HELPER STATUS COLOR GETTER ---
Color _getStatusColor(String status) {
  switch (status.toLowerCase()) {
    case 'planning':
      return const Color(0xFF2196F3); // Sky Blue
    case 'construction':
      return const Color(0xFFFFB300); // Amber
    case 'commissioning':
      return const Color(0xFF9C27B0); // Purple / Custom Commissioning
    case 'completed':
    case 'om':
      return const Color(0xFF2E7D32); // Solar Green
    case 'on_hold':
    default:
      return const Color(0xFFD32F2F); // Red
  }
}
