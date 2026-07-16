import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:mhgo/core/theme/app_theme.dart';
import 'package:mhgo/core/theme/theme_provider.dart';
import 'package:mhgo/core/widgets/app_card.dart';
import 'package:mhgo/core/widgets/app_button.dart';
import 'package:mhgo/core/widgets/responsive_layout.dart';
import 'package:mhgo/features/dashboard/presentation/providers/dashboard_provider.dart';
import 'package:mhgo/features/dashboard/domain/models/dashboard_overview.dart';
import 'package:mhgo/core/database/models/project_model.dart';
import 'package:mhgo/core/database/models/task_model.dart';
import 'package:mhgo/features/materials/data/models/material_model.dart';
import 'package:mhgo/core/database/models/inspection_model.dart';

class DashboardView extends ConsumerStatefulWidget {
  const DashboardView({super.key});

  @override
  ConsumerState<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends ConsumerState<DashboardView> with TickerProviderStateMixin {
  bool _showNotifications = false;
  int _touchedChartIndex = -1;
  DateTime _lastSyncTime = DateTime.now();
  bool _isSyncing = false;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    // Pulse animation for sync dot and skeleton loader
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _triggerSync() async {
    if (_isSyncing) return;
    setState(() {
      _isSyncing = true;
    });

    // Simulate network delay for sync
    await ref.read(dashboardStateProvider.notifier).refresh();
    await Future.delayed(const Duration(milliseconds: 800));

    if (mounted) {
      setState(() {
        _isSyncing = false;
        _lastSyncTime = DateTime.now();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: const [
              Icon(Icons.cloud_done, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text('Offline data sync completed. Database up-to-date.'),
            ],
          ),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium)),
          backgroundColor: AppTheme.lightPrimary,
        ),
      );
    }
  }

  // Quick Action Handler
  void _handleQuickAction(String actionTitle) {
    if (actionTitle.toLowerCase().contains('daily activity report') || 
        actionTitle.toLowerCase().contains('dar')) {
      if (actionTitle.toLowerCase().contains('new') || 
          actionTitle.toLowerCase().contains('create')) {
        context.push('/dar/create');
      } else {
        context.push('/dar');
      }
    } else if (actionTitle.toLowerCase().contains('inspection') ||
        actionTitle.toLowerCase().contains('qa/qc')) {
      if (actionTitle.toLowerCase().contains('new') || 
          actionTitle.toLowerCase().contains('create') ||
          actionTitle.toLowerCase().contains('checklist')) {
        context.push('/inspections/create');
      } else {
        context.push('/inspections');
      }
    } else if (actionTitle.toLowerCase().contains('progress')) {
      context.push('/progress');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Triggered Action: $actionTitle'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final stateAsync = ref.watch(dashboardStateProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Define keyboard shortcuts
    final shortcuts = <ShortcutActivator, VoidCallback>{
      LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyR): _triggerSync,
      LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyN): () => _handleQuickAction('New Project Creation'),
      LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyD): () => _handleQuickAction('Create Daily Activity Report (DAR)'),
      LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyI): () => _handleQuickAction('New QA/QC Site Inspection'),
    };

    return CallbackShortcuts(
      bindings: shortcuts,
      child: Focus(
        autofocus: true,
        child: Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                const Icon(Icons.solar_power_outlined, size: 24, color: Color(0xFF2E7D32)),
                const SizedBox(width: 10),
                Text(
                  'MHGo Solar EPC Center',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
            actions: [
              // Dynamic Pulse Offline / Sync Indicator
              _buildSyncIndicator(theme, isDark),
              const SizedBox(width: 12),

              // Theme Switcher
              IconButton(
                icon: Icon(
                  isDark ? Icons.wb_sunny_outlined : Icons.dark_mode_outlined,
                  size: 20,
                ),
                tooltip: 'Toggle Theme',
                onPressed: () => ref.read(themeModeProvider.notifier).toggleTheme(context),
              ),

              // Notification Bell
              Stack(
                alignment: Alignment.topRight,
                children: [
                  IconButton(
                    icon: Icon(
                      _showNotifications ? Icons.notifications : Icons.notifications_none_outlined,
                      size: 20,
                      color: _showNotifications ? theme.colorScheme.primary : null,
                    ),
                    tooltip: 'System Alerts',
                    onPressed: () => setState(() => _showNotifications = !_showNotifications),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
            ],
          ),
          body: Stack(
            children: [
              // Main Scroll Area & Docked Drawer for desktop
              Positioned.fill(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: stateAsync.when(
                        loading: () => _DashboardSkeleton(pulse: _pulseAnimation),
                        error: (err, stack) => _buildErrorState(err),
                        data: (data) {
                          final double screenWidth = MediaQuery.sizeOf(context).width;
                          final double horizontalPadding = screenWidth < 600 ? 16.0 : 32.0;
                          final double verticalPadding = screenWidth < 600 ? 16.0 : 24.0;
                          return RefreshIndicator(
                            onRefresh: _triggerSync,
                            child: SingleChildScrollView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              padding: EdgeInsets.symmetric(
                                horizontal: horizontalPadding,
                                vertical: verticalPadding,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // What do I need to do today? welcome panel
                                  _buildWelcomeHeader(theme, isDark, data),
                                  const SizedBox(height: 28),

                                  // Summary stats grids
                                  _buildKpiGrid(data),
                                  const SizedBox(height: 32),

                                  // Responsive grid blocks
                                  ResponsiveLayout(
                                    mobile: Column(
                                      children: [
                                        _buildQuickActionsPanel(theme, isDark),
                                        const SizedBox(height: 24),
                                        _buildActiveProjects(data.projects),
                                        const SizedBox(height: 24),
                                        _buildUrgentTasks(data.urgentTasks),
                                        const SizedBox(height: 24),
                                        _buildProjectDistribution(data.projects),
                                        const SizedBox(height: 24),
                                        _buildInventoryAlerts(data.lowStockMaterials),
                                        const SizedBox(height: 24),
                                        _buildQCFeed(data.recentInspections, data.projects),
                                        const SizedBox(height: 24),
                                        _buildActivityTimeline(theme, isDark, data),
                                      ],
                                    ),
                                    tablet: Column(
                                      children: [
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Expanded(child: _buildQuickActionsPanel(theme, isDark)),
                                            const SizedBox(width: 24),
                                            Expanded(child: _buildUrgentTasks(data.urgentTasks)),
                                          ],
                                        ),
                                        const SizedBox(height: 24),
                                        _buildActiveProjects(data.projects),
                                        const SizedBox(height: 24),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Expanded(child: _buildProjectDistribution(data.projects)),
                                            const SizedBox(width: 24),
                                            Expanded(child: _buildInventoryAlerts(data.lowStockMaterials)),
                                          ],
                                        ),
                                        const SizedBox(height: 24),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Expanded(child: _buildQCFeed(data.recentInspections, data.projects)),
                                            const SizedBox(width: 24),
                                            Expanded(child: _buildActivityTimeline(theme, isDark, data)),
                                          ],
                                        ),
                                      ],
                                    ),
                                    desktop: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Left grid content - 60%
                                        Expanded(
                                          flex: 3,
                                          child: Column(
                                            children: [
                                              _buildActiveProjects(data.projects),
                                              const SizedBox(height: 28),
                                              _buildProjectDistribution(data.projects),
                                              const SizedBox(height: 28),
                                              _buildQCFeed(data.recentInspections, data.projects),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 28),
                                        // Right grid content - 40%
                                        Expanded(
                                          flex: 2,
                                          child: Column(
                                            children: [
                                              _buildQuickActionsPanel(theme, isDark),
                                              const SizedBox(height: 28),
                                              _buildUrgentTasks(data.urgentTasks),
                                              const SizedBox(height: 28),
                                              _buildInventoryAlerts(data.lowStockMaterials),
                                              const SizedBox(height: 28),
                                              _buildActivityTimeline(theme, isDark, data),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    // If on wide screen (desktop), show side-by-side
                    if (_showNotifications && MediaQuery.sizeOf(context).width >= 1000)
                      _buildRightNotificationPanel(theme, isDark),
                  ],
                ),
              ),

              // If on narrow screen (mobile/tablet), show as a sliding overlay drawer
              if (_showNotifications && MediaQuery.sizeOf(context).width < 1000)
                Positioned.fill(
                  child: Stack(
                    children: [
                      // Dimmed background tap-to-dismiss
                      GestureDetector(
                        onTap: () => setState(() => _showNotifications = false),
                        child: Container(
                          color: Colors.black45,
                        ),
                      ),
                      // Slide-in panel from the right
                      Align(
                        alignment: Alignment.centerRight,
                        child: _buildRightNotificationPanel(theme, isDark),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // --- SYNC STATUS HEADER WIDGET ---
  Widget _buildSyncIndicator(ThemeData theme, bool isDark) {
    final formattedTime = DateFormat('h:mm a').format(_lastSyncTime);
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final bool isNarrow = screenWidth < 650;

    if (isNarrow) {
      return InkWell(
        onTap: _triggerSync,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDark ? Colors.white.withOpacity(0.04) : Colors.black.withOpacity(0.03),
            shape: BoxShape.circle,
            border: Border.all(
              color: isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.05),
            ),
          ),
          child: AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: _isSyncing
                      ? Colors.amber
                      : const Color(0xFF2E7D32).withOpacity(_pulseAnimation.value),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: _isSyncing
                          ? Colors.amber.withOpacity(0.4)
                          : const Color(0xFF2E7D32).withOpacity(0.4 * _pulseAnimation.value),
                      blurRadius: 4,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.04) : Colors.black.withOpacity(0.03),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.05),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Pulsing Dot
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _isSyncing
                      ? Colors.amber
                      : const Color(0xFF2E7D32).withOpacity(_pulseAnimation.value),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: _isSyncing
                          ? Colors.amber.withOpacity(0.4)
                          : const Color(0xFF2E7D32).withOpacity(0.4 * _pulseAnimation.value),
                      blurRadius: 4,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(width: 8),
          Text(
            _isSyncing
                ? 'Syncing...'
                : 'Offline-First (Synced $formattedTime)',
            style: theme.textTheme.bodySmall?.copyWith(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white70 : Colors.black87,
            ),
          ),
          if (!_isSyncing) ...[
            const SizedBox(width: 6),
            InkWell(
              onTap: _triggerSync,
              borderRadius: BorderRadius.circular(10),
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Icon(
                  Icons.sync,
                  size: 14,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // --- "WHAT DO I NEED TO DO TODAY" WELCOME SECTION ---
  Widget _buildWelcomeHeader(ThemeData theme, bool isDark, DashboardOverview data) {
    final String timeGreeting;
    final hour = DateTime.now().hour;
    if (hour < 12) {
      timeGreeting = 'Good morning';
    } else if (hour < 18) {
      timeGreeting = 'Good afternoon';
    } else {
      timeGreeting = 'Good evening';
    }

    final activeActionCount = data.urgentTasks.length +
        data.recentInspections.where((a) => a.status.toLowerCase() == 'rejected').length +
        data.lowStockMaterials.length;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$timeGreeting, Merhayks',
                style: theme.textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 32,
                  letterSpacing: -1.0,
                ),
              ),
              const SizedBox(height: 6),
              RichText(
                text: TextSpan(
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                  children: [
                    const TextSpan(text: 'What do I need to do today? You have '),
                    TextSpan(
                      text: '$activeActionCount critical items',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: activeActionCount > 0 ? theme.colorScheme.error : theme.colorScheme.primary,
                      ),
                    ),
                    const TextSpan(text: ' requiring immediate attention on site.'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- STATS KPI GRID ---
  Widget _buildKpiGrid(DashboardOverview data) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final double screenWidth = MediaQuery.sizeOf(context).width;
    int crossAxisCount = 4;
    if (screenWidth < 600) {
      crossAxisCount = 1;
    } else if (screenWidth < 1100) {
      crossAxisCount = 2;
    }

    final double spacing = 16.0;

    final cards = [
      _KpiCard(
        title: 'PROJECT TRACKING',
        value: '${data.activeProjectsCount} Active',
        subtitle: '${data.totalProjectsCount} Total portfolios managed',
        icon: Icons.folder_copy_outlined,
        accentColor: theme.colorScheme.primary,
        theme: theme,
        isDark: isDark,
      ),
      _KpiCard(
        title: 'CAPACITY IMPLEMENTED',
        value: '${data.totalCapacityMw.toStringAsFixed(1)} MWp',
        subtitle: 'EPC solar generation target',
        icon: Icons.wb_sunny_rounded,
        accentColor: const Color(0xFFFFB300), // Amber
        theme: theme,
        isDark: isDark,
      ),
      _KpiCard(
        title: 'CONSTRUCTION HEALTH',
        value: '${(data.overallProgress.isNaN || data.overallProgress.isInfinite ? 0 : data.overallProgress * 100).toStringAsFixed(0)}%',
        subtitle: 'Avg execution progress',
        icon: Icons.trending_up,
        accentColor: const Color(0xFF2196F3), // Accent Sky Blue
        progressValue: data.overallProgress,
        theme: theme,
        isDark: isDark,
      ),
      _KpiCard(
        title: 'LOGISTICS & SHORTAGES',
        value: '${data.lowStockMaterials.length} Alerts',
        subtitle: data.lowStockMaterials.isEmpty ? 'All items in stock' : 'Warehouse reorders due',
        icon: Icons.warehouse_rounded,
        accentColor: data.lowStockMaterials.isEmpty ? Colors.green : const Color(0xFFD32F2F), // Danger Red
        theme: theme,
        isDark: isDark,
      ),
    ];

    if (crossAxisCount == 1) {
      return Column(
        children: cards.map((c) => Padding(
          padding: EdgeInsets.only(bottom: spacing),
          child: c,
        )).toList(),
      );
    }

    if (crossAxisCount == 2) {
      return Column(
        children: [
          Row(
            children: [
              Expanded(child: cards[0]),
              SizedBox(width: spacing),
              Expanded(child: cards[1]),
            ],
          ),
          SizedBox(height: spacing),
          Row(
            children: [
              Expanded(child: cards[2]),
              SizedBox(width: spacing),
              Expanded(child: cards[3]),
            ],
          ),
        ],
      );
    }

    return Row(
      children: [
        Expanded(child: cards[0]),
        SizedBox(width: spacing),
        Expanded(child: cards[1]),
        SizedBox(width: spacing),
        Expanded(child: cards[2]),
        SizedBox(width: spacing),
        Expanded(child: cards[3]),
      ],
    );
  }

  // --- PERSISTENT QUICK ACTIONS PANEL ---
  Widget _buildQuickActionsPanel(ThemeData theme, bool isDark) {
    final actions = [
      _QuickActionItem(
        title: 'New DAR',
        subtitle: 'Daily log',
        icon: Icons.assignment_outlined,
        color: theme.colorScheme.primary,
        onTap: () => _handleQuickAction('New Daily Activity Report (DAR)'),
      ),
      _QuickActionItem(
        title: 'DAR History',
        subtitle: 'View submitted DARs',
        icon: Icons.history_edu,
        color: const Color(0xFF9C27B0),
        onTap: () => _handleQuickAction('View Daily Activity Report (DAR)'),
      ),
      _QuickActionItem(
        title: 'New Inspection',
        subtitle: 'QA/QC check',
        icon: Icons.playlist_add_check,
        color: const Color(0xFFFFB300), // Amber
        onTap: () => _handleQuickAction('QA/QC Site Inspection Checklist'),
      ),
      _QuickActionItem(
        title: 'Update Progress',
        subtitle: 'Log milestones',
        icon: Icons.trending_up,
        color: const Color(0xFF2196F3), // Accent Sky Blue
        onTap: () => _handleQuickAction('Update Milestones Progress'),
      ),
      _QuickActionItem(
        title: 'Material Request',
        subtitle: 'Dispatch log',
        icon: Icons.local_shipping_outlined,
        color: theme.colorScheme.primary,
        onTap: () => _handleQuickAction('New Material Request'),
      ),
      _QuickActionItem(
        title: 'New Punch Item',
        subtitle: 'Defect logging',
        icon: Icons.rule,
        color: const Color(0xFFD32F2F), // Danger Red
        onTap: () => _handleQuickAction('Log Site Defect Punch Item'),
      ),
    ];

    final double screenWidth = MediaQuery.sizeOf(context).width;
    final int gridCrossAxisCount = screenWidth < 450 ? 1 : 2;
    final double gridChildAspectRatio = screenWidth < 450
        ? 4.5
        : (screenWidth < 600 ? 2.5 : 2.2);

    return AppCard(
      variant: AppCardVariant.outlined,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Operations',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: actions.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: gridCrossAxisCount,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: gridChildAspectRatio,
            ),
            itemBuilder: (context, index) {
              final action = actions[index];
              return InkWell(
                onTap: action.onTap,
                borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white.withOpacity(0.02) : Colors.black.withOpacity(0.01),
                    borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
                    border: Border.all(
                      color: isDark ? Colors.white.withOpacity(0.06) : Colors.black.withOpacity(0.04),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: action.color.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(action.icon, color: action.color, size: 16),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              action.title,
                              style: theme.textTheme.labelMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              action.subtitle,
                              style: theme.textTheme.bodySmall?.copyWith(fontSize: 10),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // --- ACTIVE PROJECTS WITH MILESTONES & ASSIGNMENTS ---
  Widget _buildActiveProjects(List<ProjectModel> projects) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AppCard(
      variant: AppCardVariant.outlined,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Solar Portfolios Execution',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Active site progress, milestones, and personnel',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              TextButton.icon(
                icon: const Icon(Icons.arrow_forward, size: 16),
                label: const Text('All Portfolios'),
                onPressed: () => context.go('/projects'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (projects.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 32.0),
              child: Center(child: Text('No active solar portfolios found.')),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: projects.length,
              separatorBuilder: (context, index) => const Divider(height: 32),
              itemBuilder: (context, index) {
                final project = projects[index];
                return _ProjectExpandedListItem(project: project, theme: theme, isDark: isDark);
              },
            ),
        ],
      ),
    );
  }

  // --- PROJECT PORTFOLIO DISTRIBUTION CHART ---
  Widget _buildProjectDistribution(List<ProjectModel> projects) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    int rooftopCount = 0;
    int groundCount = 0;
    int floatingCount = 0;

    for (final p in projects) {
      final t = p.type.toLowerCase();
      if (t.contains('roof')) {
        rooftopCount++;
      } else if (t.contains('ground')) {
        groundCount++;
      } else if (t.contains('float')) {
        floatingCount++;
      }
    }

    final total = rooftopCount + groundCount + floatingCount;

    return AppCard(
      variant: AppCardVariant.outlined,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'EPC Site Type Breakdown',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Distribution of rooftop, ground-mount, and floating solar arrays',
            style: theme.textTheme.bodySmall?.copyWith(
              color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary,
            ),
          ),
          const SizedBox(height: 32),
          if (total == 0)
            const SizedBox(height: 150, child: Center(child: Text('No distribution data available.')))
          else
            LayoutBuilder(
              builder: (context, constraints) {
                final double screenWidth = MediaQuery.sizeOf(context).width;
                final bool useVertical = screenWidth < 500;

                final chartWidget = Center(
                  child: SizedBox(
                    width: 150,
                    height: 150,
                    child: PieChart(
                      PieChartData(
                        sectionsSpace: 4,
                        centerSpaceRadius: 44,
                        pieTouchData: PieTouchData(
                          touchCallback: (FlTouchEvent event, pieTouchResponse) {
                            setState(() {
                              if (!event.isInterestedForInteractions ||
                                  pieTouchResponse == null ||
                                  pieTouchResponse.touchedSection == null) {
                                _touchedChartIndex = -1;
                                return;
                              }
                              _touchedChartIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                            });
                          },
                        ),
                        sections: [
                          PieChartSectionData(
                            color: theme.colorScheme.primary,
                            value: groundCount.toDouble(),
                            title: groundCount > 0 ? '$groundCount' : '',
                            radius: _touchedChartIndex == 0 ? 28.0 : 22.0,
                            titleStyle: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          PieChartSectionData(
                            color: const Color(0xFFFFB300), // Amber
                            value: rooftopCount.toDouble(),
                            title: rooftopCount > 0 ? '$rooftopCount' : '',
                            radius: _touchedChartIndex == 1 ? 28.0 : 22.0,
                            titleStyle: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          PieChartSectionData(
                            color: theme.colorScheme.tertiary, // Accent Sky Blue
                            value: floatingCount.toDouble(),
                            title: floatingCount > 0 ? '$floatingCount' : '',
                            radius: _touchedChartIndex == 2 ? 28.0 : 22.0,
                            titleStyle: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );

                final legendWidget = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _LegendRow(
                      color: theme.colorScheme.primary,
                      label: 'Ground-Mounted',
                      value: '$groundCount sites (${total > 0 ? (groundCount / total * 100).toStringAsFixed(0) : 0}%)',
                      theme: theme,
                    ),
                    const SizedBox(height: 14),
                    _LegendRow(
                      color: const Color(0xFFFFB300),
                      label: 'Rooftop Arrays',
                      value: '$rooftopCount sites (${total > 0 ? (rooftopCount / total * 100).toStringAsFixed(0) : 0}%)',
                      theme: theme,
                    ),
                    const SizedBox(height: 14),
                    _LegendRow(
                      color: theme.colorScheme.tertiary,
                      label: 'Floating Arrays',
                      value: '$floatingCount sites (${total > 0 ? (floatingCount / total * 100).toStringAsFixed(0) : 0}%)',
                      theme: theme,
                    ),
                  ],
                );

                if (useVertical) {
                  return Column(
                    children: [
                      chartWidget,
                      const SizedBox(height: 24),
                      legendWidget,
                    ],
                  );
                }

                return Row(
                  children: [
                    chartWidget,
                    const SizedBox(width: 36),
                    Expanded(child: legendWidget),
                  ],
                );
              },
            ),
        ],
      ),
    );
  }

  // --- URGENT TASKS FOR LOGGED-IN PM ---
  Widget _buildUrgentTasks(List<TaskModel> tasks) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AppCard(
      variant: AppCardVariant.outlined,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'My Pending Actions',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Assigned to Dave Gigawin',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFD32F2F).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFD32F2F).withOpacity(0.2)),
                ),
                child: Text(
                  '${tasks.length} Action Needed',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: const Color(0xFFD32F2F),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (tasks.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 32.0),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.check_circle_outline, color: Colors.green, size: 40),
                    SizedBox(height: 10),
                    Text('No critical actions pending today.'),
                  ],
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: tasks.length > 5 ? 5 : tasks.length,
              separatorBuilder: (context, index) => const Divider(height: 24),
              itemBuilder: (context, index) {
                final task = tasks[index];
                return _TaskListItem(task: task, theme: theme, isDark: isDark);
              },
            ),
        ],
      ),
    );
  }

  // --- MATERIAL WAREHOUSE SHORTAGES ---
  Widget _buildInventoryAlerts(List<MaterialModel> lowStock) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AppCard(
      variant: AppCardVariant.outlined,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Warehouse Dispatch Logs',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Items below safety stock threshold',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.warehouse_outlined, size: 24),
            ],
          ),
          const SizedBox(height: 20),
          if (lowStock.isEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(isDark ? 0.08 : 0.05),
                borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
                border: Border.all(color: Colors.green.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle_outline, color: Colors.green, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'All equipment levels (PV modules, Solis Inverters, mounting kits) secure.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isDark ? Colors.green.shade300 : Colors.green.shade800,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: lowStock.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final mat = lowStock[index];
                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD32F2F).withOpacity(isDark ? 0.06 : 0.03),
                    borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
                    border: Border.all(color: const Color(0xFFD32F2F).withOpacity(isDark ? 0.15 : 0.1)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD32F2F).withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.warning_amber_rounded, size: 16, color: Color(0xFFD32F2F)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              mat.name,
                              style: theme.textTheme.titleSmall?.copyWith(fontSize: 12, fontWeight: FontWeight.w700),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'ID: ${mat.uuid.substring(0, 8)} • Location: ${mat.storageLocation ?? "Unassigned"}',
                              style: theme.textTheme.bodySmall?.copyWith(fontSize: 10),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${mat.currentStock.toInt()} ${mat.unit}',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: const Color(0xFFD32F2F),
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            'Min: ${mat.minimumStock.toInt()}',
                            style: theme.textTheme.bodySmall?.copyWith(fontSize: 9),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  // --- QA/QC CHECKLIST FEED ---
  Widget _buildQCFeed(List<InspectionModel> inspections, List<ProjectModel> projects) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final projectMap = {for (var p in projects) p.uuid: p.name};

    return AppCard(
      variant: AppCardVariant.outlined,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Supervision Sign-offs & QA/QC Logs',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Field checklist status logs and structural audits',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.add_task_outlined, size: 20),
                tooltip: 'Log New Checklist Audit',
                onPressed: () => _handleQuickAction('Log QA/QC Field Checklist'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (inspections.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 32.0),
              child: Center(child: Text('No QA/QC inspections logged.')),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: inspections.length,
              separatorBuilder: (context, index) => const Divider(height: 24),
              itemBuilder: (context, index) {
                final audit = inspections[index];
                final pName = projectMap[audit.projectUuid] ?? 'Solar EPC Site';
                return _QCListItem(audit: audit, projectName: pName, theme: theme, isDark: isDark);
              },
            ),
        ],
      ),
    );
  }

  // --- RECENT ACTIVITY TIMELINE ---
  Widget _buildActivityTimeline(ThemeData theme, bool isDark, DashboardOverview data) {
    final List<_ActivityItem> activities = [];

    // Add recent projects
    for (final p in data.projects.take(2)) {
      activities.add(_ActivityItem(
        time: DateFormat('MMM d, h:mm a').format(p.createdAt),
        title: 'Portfolio Created',
        description: '${p.name} was successfully registered.',
        icon: Icons.folder_open,
        color: theme.colorScheme.primary,
        timestamp: p.createdAt,
      ));
    }

    // Add recent inspections
    for (final insp in data.recentInspections.take(3)) {
      final isRejected = insp.status.toLowerCase() == 'rejected';
      activities.add(_ActivityItem(
        time: DateFormat('MMM d, h:mm a').format(insp.createdAt),
        title: 'QC Inspection Logged',
        description: isRejected ? '${insp.title} flagged an issue at ${insp.location}.' : '${insp.title} passed QA/QC.',
        icon: isRejected ? Icons.cancel_outlined : Icons.check_circle_outline,
        color: isRejected ? const Color(0xFFD32F2F) : const Color(0xFF2E7D32),
        timestamp: insp.createdAt,
      ));
    }

    activities.sort((a, b) => b.timestamp.compareTo(a.timestamp));

    if (activities.isEmpty) {
      activities.add(_ActivityItem(
        time: 'Now',
        title: 'System Ready',
        description: 'Dashboard initialized and ready for new entries.',
        icon: Icons.check,
        color: theme.colorScheme.primary,
        timestamp: DateTime.now(),
      ));
    }

    return AppCard(
      variant: AppCardVariant.outlined,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Operations Activity Logs',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 20),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: activities.length,
            itemBuilder: (context, index) {
              final act = activities[index];
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: act.color.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(act.icon, size: 14, color: act.color),
                      ),
                      if (index != activities.length - 1)
                        Container(
                          width: 2,
                          height: 38,
                          color: isDark ? Colors.white12 : Colors.black12,
                        ),
                    ],
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                act.title,
                                style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                act.time,
                                style: theme.textTheme.bodySmall?.copyWith(fontSize: 10),
                              ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Text(
                            act.description,
                            style: theme.textTheme.bodySmall?.copyWith(fontSize: 11),
                          ),
                        ],
                      ),
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

  // --- SLIDE-OUT NOTIFICATION CENTER ---
  Widget _buildRightNotificationPanel(ThemeData theme, bool isDark) {
    final notifications = [
      _AlertItem(
        title: 'Cavite building #4 QC alert',
        message: 'PV array structural clamp torque check failed at sector C.',
        time: '1h ago',
        type: 'error',
      ),
      _AlertItem(
        title: 'Weather Warning: Bulacan Farm',
        message: 'Heavy rain delay expected. Civil foundation works suspended.',
        time: '3h ago',
        type: 'warning',
      ),
      _AlertItem(
        title: 'Laguna environmental clearance',
        message: 'Laguna Lake Floating project EIA clearance passed review.',
        time: 'Yesterday',
        type: 'success',
      ),
    ];

    return Container(
      width: 320,
      height: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        border: Border(
          left: BorderSide(
            color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'EPC System Alerts',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  onPressed: () => setState(() => _showNotifications = false),
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: notifications.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final note = notifications[index];

                Color iconColor = theme.colorScheme.primary;
                IconData alertIcon = Icons.info_outline;

                if (note.type == 'error') {
                  iconColor = const Color(0xFFD32F2F);
                  alertIcon = Icons.error_outline;
                } else if (note.type == 'warning') {
                  iconColor = const Color(0xFFFFB300);
                  alertIcon = Icons.warning_amber_rounded;
                } else if (note.type == 'success') {
                  iconColor = const Color(0xFF2E7D32);
                  alertIcon = Icons.check_circle_outline;
                }

                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white.withOpacity(0.02) : Colors.black.withOpacity(0.01),
                    borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
                    border: Border.all(
                      color: isDark ? Colors.white.withOpacity(0.06) : Colors.black.withOpacity(0.04),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(alertIcon, color: iconColor, size: 18),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              note.title,
                              style: theme.textTheme.labelMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              note.message,
                              style: theme.textTheme.bodySmall?.copyWith(fontSize: 10),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              note.time,
                              style: theme.textTheme.bodySmall?.copyWith(fontSize: 9, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // --- SKELETON ERROR STATE PANEL ---
  Widget _buildErrorState(Object err) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFD32F2F).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.cloud_off, size: 48, color: Color(0xFFD32F2F)),
            ),
            const SizedBox(height: 20),
            Text(
              'EPC Database Offline Sync Failure',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'An error occurred: $err. Let\'s try re-initializing the local database.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            AppButton(
              text: 'Re-sync Local Store',
              icon: Icons.sync,
              onPressed: _triggerSync,
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// PRIVATE SUPPORTING MINI CARD WIDGETS
// ==========================================

// --- KPI CARD WIDGET ---
class _KpiCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color accentColor;
  final double? progressValue;
  final ThemeData theme;
  final bool isDark;

  const _KpiCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.accentColor,
    this.progressValue,
    required this.theme,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      variant: AppCardVariant.outlined,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary,
                      fontWeight: FontWeight.w800,
                      fontSize: 10,
                      letterSpacing: 0.8,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.08),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: accentColor, size: 16),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w800,
                fontSize: 24,
                letterSpacing: -0.5,
                color: isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary,
              ),
            ),
            const SizedBox(height: 6),
            if (progressValue != null) ...[
              const SizedBox(height: 4),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progressValue,
                  minHeight: 5,
                  backgroundColor: isDark ? AppTheme.darkBorder : AppTheme.lightBorder,
                  valueColor: AlwaysStoppedAnimation<Color>(accentColor),
                ),
              ),
              const SizedBox(height: 6),
            ],
            Text(
              subtitle,
              style: theme.textTheme.bodySmall?.copyWith(
                fontSize: 11,
                color: isDark ? AppTheme.darkTextMuted : AppTheme.lightTextSecondary,
              ),
            ),
          ],
        ),
      );
  }
}

// --- PROJECT DETAILED ROW ---
class _ProjectExpandedListItem extends StatelessWidget {
  final ProjectModel project;
  final ThemeData theme;
  final bool isDark;

  const _ProjectExpandedListItem({
    required this.project,
    required this.theme,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    Color statusBg = Colors.grey.withOpacity(0.12);
    Color statusFg = isDark ? Colors.white70 : Colors.black87;

    switch (project.status) {
      case 'construction':
        statusBg = theme.colorScheme.primary.withOpacity(0.08);
        statusFg = theme.colorScheme.primary;
        break;
      case 'planning':
        statusBg = Colors.blue.withOpacity(0.08);
        statusFg = Colors.blue.shade400;
        break;
      case 'completed':
        statusBg = Colors.green.withOpacity(0.08);
        statusFg = Colors.green.shade400;
        break;
      case 'on_hold':
        statusBg = Colors.amber.withOpacity(0.08);
        statusFg = Colors.amber.shade400;
        break;
    }

    // Milestones definition based on mock data
    final List<String> milestones;
    if (project.uuid.contains('bulacan')) {
      milestones = ['Civil: 65%', 'Structures: 0%', 'Inverters: Oct 26'];
    } else if (project.uuid.contains('cavite')) {
      milestones = ['Roof Reinforce: Done', 'PV Installation: 85%', 'Grid Tie: Sep 26'];
    } else if (project.uuid.contains('laguna')) {
      milestones = ['Geotech Survey: 40%', 'Denr EIA Clearance: Dec 26'];
    } else {
      milestones = ['Breaker Test: Done', 'Grid Tie: Done'];
    }

    // Engineer Avatar initials
    final engineerInitials = project.uuid.contains('bulacan')
        ? ['JR', 'ML']
        : project.uuid.contains('cavite')
            ? ['JC', 'ML', 'LS']
            : ['LS'];

    return InkWell(
      onTap: () => context.go('/projects/${project.uuid}'),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Circle type icon
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: (project.type.contains('Roof')
                          ? const Color(0xFFFFB300)
                          : project.type.contains('Float')
                              ? theme.colorScheme.tertiary
                              : theme.colorScheme.primary)
                      .withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  project.type.contains('Roof')
                      ? Icons.roofing
                      : project.type.contains('Float')
                          ? Icons.waves
                          : Icons.wb_sunny_rounded,
                  color: project.type.contains('Roof')
                      ? const Color(0xFFFFB300)
                      : project.type.contains('Float')
                          ? theme.colorScheme.tertiary
                          : theme.colorScheme.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      project.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        Text(
                          '${project.capacityMw.toStringAsFixed(1)} MWp • ${project.location}',
                          style: theme.textTheme.bodySmall?.copyWith(fontSize: 11),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: statusBg,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: statusFg.withOpacity(0.2)),
                          ),
                          child: Text(
                            project.stage,
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontSize: 9,
                              color: statusFg,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Progress text row above progress bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Construction Progress',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '${(project.progress.isNaN || project.progress.isInfinite ? 0 : project.progress * 100).toStringAsFixed(0)}% Complete',
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 11,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          // Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: project.progress,
              minHeight: 6,
              backgroundColor: isDark ? AppTheme.darkBorder : AppTheme.lightBorder,
              valueColor: AlwaysStoppedAnimation<Color>(
                project.progress == 1.0 ? Colors.green : theme.colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Milestones Chips & Assignments
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 12,
            runSpacing: 8,
            children: [
              // Milestones Scroll Panel
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: milestones.map((milestone) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white.withOpacity(0.03) : Colors.black.withOpacity(0.02),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: isDark ? Colors.white.withOpacity(0.06) : Colors.black.withOpacity(0.04),
                      ),
                    ),
                    child: Text(
                      milestone,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white54 : Colors.black54,
                      ),
                    ),
                  );
                }).toList(),
              ),

              // Engr Team Avatars
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Team: ',
                    style: theme.textTheme.bodySmall?.copyWith(fontSize: 10, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(width: 4),
                  SizedBox(
                    height: 20,
                    width: (engineerInitials.length * 12.0) + 8.0,
                    child: Stack(
                      children: List.generate(engineerInitials.length, (idx) {
                        return Positioned(
                          left: idx * 12.0,
                          child: CircleAvatar(
                            radius: 10,
                            backgroundColor: theme.colorScheme.secondary.withOpacity(0.2),
                            child: Text(
                              engineerInitials[idx],
                              style: TextStyle(
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.secondary,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ),
    );
  }
}

// --- LEGEND ROW FOR DISTRIBUTION CHART ---
class _LegendRow extends StatelessWidget {
  final Color color;
  final String label;
  final String value;
  final ThemeData theme;

  const _LegendRow({
    required this.color,
    required this.label,
    required this.value,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.titleSmall?.copyWith(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              Text(
                value,
                style: theme.textTheme.bodySmall?.copyWith(fontSize: 11),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// --- TASK LIST CHECKLIST ITEM ---
class _TaskListItem extends StatelessWidget {
  final TaskModel task;
  final ThemeData theme;
  final bool isDark;

  const _TaskListItem({
    required this.task,
    required this.theme,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    Color priorityColor = Colors.grey;
    switch (task.priority.toLowerCase()) {
      case 'critical':
        priorityColor = const Color(0xFFD32F2F); // Danger Red
        break;
      case 'high':
        priorityColor = const Color(0xFFFFB300); // Amber
        break;
      case 'medium':
        priorityColor = const Color(0xFF2196F3); // Accent Sky
        break;
      case 'low':
        priorityColor = Colors.grey;
        break;
    }

    final dueDateStr = DateFormat('MMM d').format(task.dueDate);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(
            task.status == 'done' ? Icons.check_circle : Icons.circle_outlined,
            color: task.status == 'done' ? Colors.green : (isDark ? Colors.white38 : Colors.black26),
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    decoration: task.status == 'done' ? TextDecoration.lineThrough : null,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '${task.category}  •  Due $dueDateStr',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: 10,
                    color: task.dueDate.isBefore(DateTime.now()) && task.status != 'done'
                        ? const Color(0xFFD32F2F)
                        : (isDark ? AppTheme.darkTextMuted : AppTheme.lightTextSecondary),
                    fontWeight: task.dueDate.isBefore(DateTime.now()) && task.status != 'done'
                        ? FontWeight.bold
                        : null,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Priority Tag
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: priorityColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: priorityColor.withOpacity(0.2)),
            ),
            child: Text(
              task.priority.toUpperCase(),
              style: theme.textTheme.bodySmall?.copyWith(
                fontSize: 8,
                fontWeight: FontWeight.bold,
                color: priorityColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- QA/QC CHECKLIST LIST ITEM ---
class _QCListItem extends StatelessWidget {
  final InspectionModel audit;
  final String projectName;
  final ThemeData theme;
  final bool isDark;

  const _QCListItem({
    required this.audit,
    required this.projectName,
    required this.theme,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor = Colors.grey;
    IconData statusIcon = Icons.help_outline;

    switch (audit.status.toLowerCase()) {
      case 'approved':
        statusColor = const Color(0xFF2E7D32); // Solar Green
        statusIcon = Icons.verified;
        break;
      case 'rejected':
        statusColor = const Color(0xFFD32F2F); // Danger Red
        statusIcon = Icons.cancel;
        break;
      case 'pending':
        statusColor = const Color(0xFFFFB300); // Amber
        statusIcon = Icons.pending_actions;
        break;
    }

    final dateStr = DateFormat('MMM d, y').format(audit.inspectionDate);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(statusIcon, color: statusColor, size: 20),
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
                        audit.title,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: statusColor.withOpacity(0.2)),
                      ),
                      child: Text(
                        audit.status.toUpperCase(),
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  projectName,
                  style: theme.textTheme.bodySmall?.copyWith(fontSize: 11, fontWeight: FontWeight.w500),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                if (audit.notes != null && audit.notes!.isNotEmpty) ...[
                  Text(
                    audit.notes!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontSize: 11,
                      color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary,
                      fontStyle: FontStyle.italic,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                ],
                Row(
                  children: [
                    Text(
                      'Inspector: ${audit.inspectorName}',
                      style: theme.textTheme.bodySmall?.copyWith(fontSize: 10),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '•  $dateStr',
                      style: theme.textTheme.bodySmall?.copyWith(fontSize: 10),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- SKELETON LOADER PANEL ---
class _DashboardSkeleton extends StatelessWidget {
  final Animation<double> pulse;

  const _DashboardSkeleton({required this.pulse});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final skeletonColor = isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.04);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(32.0),
      child: AnimatedBuilder(
        animation: pulse,
        builder: (context, child) {
          return Opacity(
            opacity: pulse.value,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header skeleton
                Container(
                  width: 320,
                  height: 32,
                  decoration: BoxDecoration(
                    color: skeletonColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  width: 480,
                  height: 16,
                  decoration: BoxDecoration(
                    color: skeletonColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 36),

                // KPI grids
                Row(
                  children: List.generate(4, (idx) {
                    return Expanded(
                      child: Container(
                        height: 120,
                        margin: EdgeInsets.only(right: idx == 3 ? 0 : 16),
                        decoration: BoxDecoration(
                          color: skeletonColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 36),

                // Content splits
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left main skeleton
                    Expanded(
                      flex: 3,
                      child: Column(
                        children: [
                          Container(
                            height: 350,
                            decoration: BoxDecoration(
                              color: skeletonColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          const SizedBox(height: 28),
                          Container(
                            height: 250,
                            decoration: BoxDecoration(
                              color: skeletonColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 28),
                    // Right side skeleton
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          Container(
                            height: 240,
                            decoration: BoxDecoration(
                              color: skeletonColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          const SizedBox(height: 28),
                          Container(
                            height: 350,
                            decoration: BoxDecoration(
                              color: skeletonColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// Data structures
class _QuickActionItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });
}

class _ActivityItem {
  final String time;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final DateTime timestamp;

  const _ActivityItem({
    required this.time,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.timestamp,
  });
}

class _AlertItem {
  final String title;
  final String message;
  final String time;
  final String type;

  const _AlertItem({
    required this.title,
    required this.message,
    required this.time,
    required this.type,
  });
}
