import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mhgo/core/theme/app_theme.dart';
import 'package:mhgo/core/widgets/app_card.dart';
import 'package:mhgo/core/widgets/app_button.dart';
import 'package:mhgo/features/survey/domain/entities/survey_entities.dart';
import 'package:mhgo/features/survey/presentation/providers/survey_provider.dart';

class SurveyListView extends ConsumerStatefulWidget {
  const SurveyListView({super.key});

  @override
  ConsumerState<SurveyListView> createState() => _SurveyListViewState();
}

class _SurveyListViewState extends ConsumerState<SurveyListView> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String? _selectedStatus;
  bool _isGridView = true;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _clearAllFilters() {
    _searchController.clear();
    setState(() {
      _searchQuery = '';
      _selectedStatus = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Assuming surveyListProvider is defined to return AsyncValue<List<Survey>>
    final surveysAsync = ref.watch(surveyListProvider);

    return Scaffold(
      backgroundColor: isDark ? AppTheme.darkBg : AppTheme.lightBg,
      appBar: AppBar(
        title: Text(
          'Site Surveys',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isGridView ? Icons.view_list_rounded : Icons.grid_view_rounded,
            ),
            tooltip: _isGridView
                ? 'Switch to List View'
                : 'Switch to Grid View',
            onPressed: () {
              setState(() => _isGridView = !_isGridView);
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
        heroTag: 'survey-list-fab',
        onPressed: () => context.push('/survey/new'),
        label: const Text(
          'New Survey',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        icon: const Icon(Icons.add),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(surveyListProvider);
          },
          child: surveysAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => _buildErrorState(err.toString(), theme),
            data: (surveys) {
              final filtered = surveys.where((s) {
                if (_searchQuery.isNotEmpty) {
                  final q = _searchQuery.toLowerCase();
                  if (!s.clientName.toLowerCase().contains(q) &&
                      !s.address.toLowerCase().contains(q) &&
                      !(s.notes?.toLowerCase().contains(q) ?? false)) {
                    return false;
                  }
                }
                if (_selectedStatus != null && s.status != _selectedStatus) {
                  return false;
                }
                return true;
              }).toList();

              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24.0,
                        vertical: 16.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [_buildSearchAndFilterRow(theme, isDark)],
                      ),
                    ),
                  ),
                  if (filtered.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: _buildEmptyState(theme, isDark),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24.0,
                        vertical: 8.0,
                      ),
                      sliver: _isGridView
                          ? _buildGrid(filtered, theme, isDark)
                          : _buildList(filtered, theme, isDark),
                    ),
                  const SliverToBoxAdapter(child: SizedBox(height: 80)),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSearchAndFilterRow(ThemeData theme, bool isDark) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 600;

        final searchField = Expanded(
          flex: isCompact ? 1 : 3,
          child: TextField(
            controller: _searchController,
            onChanged: (val) => setState(() => _searchQuery = val),
            decoration: InputDecoration(
              isDense: true,
              hintText: 'Search by client, address...',
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear_rounded),
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _searchQuery = '');
                      },
                    )
                  : null,
            ),
          ),
        );

        final statusDropdown = SizedBox(
          width: isCompact ? double.infinity : 180,
          child: DropdownButtonFormField<String?>(
            value: _selectedStatus,
            isExpanded: true,
            decoration: const InputDecoration(
              isDense: true,
              labelText: 'Status',
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            items: const [
              DropdownMenuItem(value: null, child: Text('All Status')),
              DropdownMenuItem(value: 'Surveyed', child: Text('Surveyed')),
              DropdownMenuItem(value: 'Quoted', child: Text('Quoted')),
              DropdownMenuItem(
                value: 'Waiting Client',
                child: Text('Waiting Client'),
              ),
              DropdownMenuItem(value: 'Approved', child: Text('Approved')),
              DropdownMenuItem(value: 'Declined', child: Text('Declined')),
              DropdownMenuItem(value: 'Converted', child: Text('Converted')),
            ],
            onChanged: (val) {
              setState(() => _selectedStatus = val);
            },
          ),
        );

        if (isCompact) {
          return Column(
            children: [
              Row(children: [searchField]),
              const SizedBox(height: 12),
              statusDropdown,
            ],
          );
        }

        return Row(
          children: [searchField, const SizedBox(width: 12), statusDropdown],
        );
      },
    );
  }

  Widget _buildGrid(List<Survey> surveys, ThemeData theme, bool isDark) {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 450,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        mainAxisExtent: 220,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) =>
            _SurveyCard(survey: surveys[index], theme: theme, isDark: isDark),
        childCount: surveys.length,
      ),
    );
  }

  Widget _buildList(List<Survey> surveys, ThemeData theme, bool isDark) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: _SurveyCard(
            survey: surveys[index],
            theme: theme,
            isDark: isDark,
          ),
        ),
        childCount: surveys.length,
      ),
    );
  }

  Widget _buildErrorState(String message, ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              size: 60,
              color: Colors.redAccent,
            ),
            const SizedBox(height: 16),
            Text('Failed to load surveys', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            AppButton(
              text: 'Retry',
              onPressed: () => ref.invalidate(surveyListProvider),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme, bool isDark) {
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
            'No surveys found',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
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
          ),
        ],
      ),
    );
  }
}

class _SurveyCard extends StatelessWidget {
  final Survey survey;
  final ThemeData theme;
  final bool isDark;

  const _SurveyCard({
    required this.survey,
    required this.theme,
    required this.isDark,
  });

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Approved':
      case 'Converted':
        return Colors.green;
      case 'Surveyed':
      case 'Quoted':
      case 'Waiting Client':
        return Colors.orange;
      case 'Declined':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(survey.status);
    final formattedDate = DateFormat('MMMM dd, yyyy').format(survey.surveyDate);

    return AppCard(
      variant: AppCardVariant.outlined,
      padding: const EdgeInsets.all(20),
      onTap: () {
        context.push('/survey/details/${survey.uuid}');
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Status Chip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: statusColor.withOpacity(0.3),
                width: 1.2,
              ),
            ),
            child: Text(
              survey.status.toUpperCase(),
              style: theme.textTheme.labelSmall?.copyWith(
                color: statusColor,
                fontWeight: FontWeight.w900,
                fontSize: 10,
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Client Name
          Text(
            survey.clientName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 6),

          // Proposed System
          Row(
            children: [
              Icon(
                Icons.solar_power_rounded,
                size: 14,
                color: isDark
                    ? AppTheme.darkTextSecondary
                    : AppTheme.lightTextSecondary,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  survey.proposedSystem,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isDark
                        ? AppTheme.darkTextSecondary
                        : AppTheme.lightTextSecondary,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Date
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.calendar_today_rounded,
                size: 13,
                color: isDark
                    ? AppTheme.darkTextMuted
                    : AppTheme.lightTextMuted,
              ),
              const SizedBox(width: 4),
              Text(
                formattedDate,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isDark
                      ? AppTheme.darkTextSecondary
                      : AppTheme.lightTextSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 6),

          // Bottom Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.edit_document, size: 18),
                tooltip: 'Edit Survey',
                visualDensity: VisualDensity.compact,
                onPressed: () {
                  context.push('/survey/edit/${survey.uuid}');
                },
              ),
              IconButton(
                icon: const Icon(Icons.picture_as_pdf_rounded, size: 18),
                tooltip: 'Print PDF Preview',
                visualDensity: VisualDensity.compact,
                onPressed: () {
                  context.push('/survey/pdf/${survey.uuid}');
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
