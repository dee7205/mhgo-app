import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mhgo/core/theme/app_theme.dart';
import 'package:mhgo/core/widgets/app_card.dart';
import 'package:mhgo/core/widgets/app_button.dart';
import 'package:mhgo/features/dar/domain/entities/dar_entities.dart';
import 'package:mhgo/features/dar/presentation/providers/dar_provider.dart';
import 'package:mhgo/features/dashboard/presentation/providers/dashboard_provider.dart';

class DarDetailsView extends ConsumerStatefulWidget {
  final String id;

  const DarDetailsView({super.key, required this.id});

  @override
  ConsumerState<DarDetailsView> createState() => _DarDetailsViewState();
}

class _DarDetailsViewState extends ConsumerState<DarDetailsView> {
  // Collapsible section toggles
  bool _showAccomplishments = true;
  bool _showManpower = true;
  bool _showEquipment = true;
  bool _showMaterials = true;
  bool _showDelays = true;
  bool _showPhotos = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final detailsAsync = ref.watch(darDetailsProvider(widget.id));

    return Scaffold(
      backgroundColor: isDark ? AppTheme.darkBg : AppTheme.lightBg,
      appBar: AppBar(
        title: Text(
          'Accomplishment Site Log',
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
              return const Center(child: Text('Activity report not found.'));
            }

            final statusColor = _getStatusColor(report.status);
            final formattedDate = DateFormat(
              'EEEE, MMMM dd, yyyy',
            ).format(report.reportDate);
            final formattedUpdated = DateFormat(
              'MMMM dd, yyyy hh:mm a',
            ).format(report.lastUpdated);

            return SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 850),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header panel
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final isNarrow = constraints.maxWidth < 500;
                          final textInfo = Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                report.darNumber,
                                style: theme.textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: -1.0,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Last modified on $formattedUpdated',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.disabledColor,
                                ),
                              ),
                            ],
                          );

                          final statusTag = Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: statusColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: statusColor.withValues(alpha: 0.2),
                              ),
                            ),
                            child: Text(
                              report.status.toUpperCase(),
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: statusColor,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          );

                          if (isNarrow) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                textInfo,
                                const SizedBox(height: 12),
                                statusTag,
                              ],
                            );
                          }

                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(child: textInfo),
                              statusTag,
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 16),

                      // Navigation Actions
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          if (report.status == 'Draft') ...[
                            AppButton(
                              text: 'Edit Draft Report',
                              icon: Icons.edit_outlined,
                              onPressed: () =>
                                  context.push('/dar/edit/${report.id}'),
                            ),
                          ],
                          AppButton(
                            text: 'Preview Print PDF',
                            icon: Icons.picture_as_pdf_outlined,
                            variant: AppButtonVariant.secondary,
                            onPressed: () =>
                                context.push('/dar/pdf/${report.id}'),
                          ),
                          AppButton(
                            text: 'Delete Report',
                            icon: Icons.delete_outline,
                            variant: AppButtonVariant.danger,
                            onPressed: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text('Delete Report'),
                                  content: Text(
                                    'Are you sure you want to delete ${report.darNumber}?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(ctx, false),
                                      child: const Text('Cancel'),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(
                                          0xFFD32F2F,
                                        ),
                                        foregroundColor: Colors.white,
                                      ),
                                      onPressed: () => Navigator.pop(ctx, true),
                                      child: const Text('Delete'),
                                    ),
                                  ],
                                ),
                              );

                              if (confirm == true && mounted) {
                                final repo = ref.read(darRepositoryProvider);
                                await repo.deleteDar(report.id);
                                ref.invalidate(darsListProvider);
                                ref.invalidate(dashboardStateProvider);
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Report deleted successfully.',
                                      ),
                                    ),
                                  );
                                  context.pop();
                                }
                              }
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Project Configuration details & Weather Details
                      LayoutBuilder(
                        builder: (context, constraints) {
                          if (constraints.maxWidth > 750) {
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  flex: 5,
                                  child: _buildInfoBlock(
                                    report,
                                    formattedDate,
                                    theme,
                                    isDark,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  flex: 4,
                                  child: _buildWeatherBlock(
                                    report,
                                    theme,
                                    isDark,
                                  ),
                                ),
                              ],
                            );
                          }
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _buildInfoBlock(
                                report,
                                formattedDate,
                                theme,
                                isDark,
                              ),
                              const SizedBox(height: 16),
                              _buildWeatherBlock(report, theme, isDark),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 16),

                      // Expandable Accomplishments
                      _buildCollapsibleCard(
                        title: 'Daily Accomplishments',
                        icon: Icons.construction_outlined,
                        isExpanded: _showAccomplishments,
                        onToggle: () => setState(
                          () => _showAccomplishments = !_showAccomplishments,
                        ),
                        child: _buildAccomplishmentsList(
                          report.accomplishments,
                          theme,
                        ),
                        theme: theme,
                      ),
                      const SizedBox(height: 16),

                      // Expandable Manpower
                      _buildCollapsibleCard(
                        title: 'Manpower Tally',
                        icon: Icons.people_outline,
                        isExpanded: _showManpower,
                        onToggle: () =>
                            setState(() => _showManpower = !_showManpower),
                        child: _buildManpowerList(
                          report.manpower,
                          theme,
                          isDark,
                        ),
                        theme: theme,
                      ),
                      const SizedBox(height: 16),

                      // Expandable Equipment
                      _buildCollapsibleCard(
                        title: 'Equipment & Machinery Hours',
                        icon: Icons.local_shipping_outlined,
                        isExpanded: _showEquipment,
                        onToggle: () =>
                            setState(() => _showEquipment = !_showEquipment),
                        child: _buildEquipmentList(
                          report.equipment,
                          theme,
                          isDark,
                        ),
                        theme: theme,
                      ),
                      const SizedBox(height: 16),

                      // Expandable Materials
                      _buildCollapsibleCard(
                        title: 'Materials Installed Logs',
                        icon: Icons.inventory_2_outlined,
                        isExpanded: _showMaterials,
                        onToggle: () =>
                            setState(() => _showMaterials = !_showMaterials),
                        child: _buildMaterialsList(
                          report.materials,
                          theme,
                          isDark,
                        ),
                        theme: theme,
                      ),
                      const SizedBox(height: 16),

                      // Expandable Delays
                      _buildCollapsibleCard(
                        title: 'Technical Delays & Issues',
                        icon: Icons.warning_amber_rounded,
                        isExpanded: _showDelays,
                        onToggle: () =>
                            setState(() => _showDelays = !_showDelays),
                        child: _buildDelaysList(report.delays, theme),
                        theme: theme,
                      ),
                      const SizedBox(height: 16),

                      // Expandable Photos
                      _buildCollapsibleCard(
                        title: 'Operations Photos Documentation',
                        icon: Icons.photo_library_outlined,
                        isExpanded: _showPhotos,
                        onToggle: () =>
                            setState(() => _showPhotos = !_showPhotos),
                        child: _buildPhotosGrid(report.photos, theme),
                        theme: theme,
                      ),
                      const SizedBox(height: 16),

                      // Signatures block
                      _buildSignaturesBlock(report, theme, isDark),
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

  // --- SUB-BLOCKS ---
  Widget _buildInfoBlock(
    DarReport report,
    String formattedDate,
    ThemeData theme,
    bool isDark,
  ) {
    return AppCard(
      variant: AppCardVariant.outlined,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Project Spec Details',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 400) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoRow('Projects', report.projectName, theme),
                          _buildInfoRow(
                            'Report Log Date',
                            formattedDate,
                            theme,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoRow(
                            'Prepared By',
                            report.preparedBy,
                            theme,
                          ),
                          _buildInfoRow(
                            'Reporting Shift',
                            report.reportingPeriod,
                            theme,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow('Project Name', report.projectName, theme),
                  _buildInfoRow('Report Log Date', formattedDate, theme),
                  _buildInfoRow('Prepared By', report.preparedBy, theme),
                  _buildInfoRow(
                    'Reporting Shift',
                    report.reportingPeriod,
                    theme,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 200;
          if (isNarrow) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.disabledColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
              ],
            );
          }
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.disabledColor,
                ),
              ),
              Expanded(
                child: Text(
                  value,
                  textAlign: TextAlign.right,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildWeatherBlock(DarReport report, ThemeData theme, bool isDark) {
    return AppCard(
      variant: AppCardVariant.outlined,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Site Environment',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 500;
              return Wrap(
                spacing: 16,
                runSpacing: 16,
                alignment: WrapAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: isNarrow ? (constraints.maxWidth - 20) / 2 : 150,
                    child: _buildWeatherStatus(
                      'Weather',
                      report.weather,
                      Icons.cloud_outlined,
                      theme,
                    ),
                  ),
                  SizedBox(
                    width: isNarrow ? (constraints.maxWidth - 20) / 2 : 150,
                    child: _buildWeatherStatus(
                      'Avg Temp',
                      '${report.temperature}°C',
                      Icons.thermostat_outlined,
                      theme,
                    ),
                  ),
                  SizedBox(
                    width: isNarrow ? (constraints.maxWidth - 20) / 2 : 150,
                    child: _buildWeatherStatus(
                      'Wind Velocity',
                      report.windCondition,
                      Icons.wind_power_outlined,
                      theme,
                    ),
                  ),
                  SizedBox(
                    width: isNarrow ? (constraints.maxWidth - 20) / 2 : 150,
                    child: _buildWeatherStatus(
                      'Terrain Type',
                      report.siteCondition,
                      Icons.landscape_outlined,
                      theme,
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

  Widget _buildWeatherStatus(
    String label,
    String value,
    IconData icon,
    ThemeData theme,
  ) {
    return Column(
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.primary),
        const SizedBox(height: 6),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            fontSize: 10,
            color: theme.disabledColor,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ],
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
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(icon, size: 20, color: theme.colorScheme.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
                ],
              ),
            ),
          ),
          if (isExpanded) ...[
            const Divider(height: 1),
            Padding(padding: const EdgeInsets.all(20.0), child: child),
          ],
        ],
      ),
    );
  }

  // --- ACC ITEM LIST ---
  Widget _buildAccomplishmentsList(
    List<AccomplishmentItem> items,
    ThemeData theme,
  ) {
    if (items.isEmpty) return const Text('No accomplishments listed.');
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      separatorBuilder: (context, index) => const Divider(height: 16),
      itemBuilder: (context, idx) {
        final item = items[idx];
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 12,
              backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
              child: Text(
                '${idx + 1}',
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontSize: 10,
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
                    item.workDescription,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Area: ${item.areaLocation} | Quantity: ${item.quantity} ${item.unit}',
                  ),
                  if (item.remarks.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Remarks: ${item.remarks}',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: theme.disabledColor,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _tableHeader(String text, ThemeData theme, {bool center = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Text(
        text,
        textAlign: center ? TextAlign.center : TextAlign.left,
        style: theme.textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.w800,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  // --- MANPOWER LIST ---
  Widget _buildManpowerList(
    List<ManpowerAccomplishment> list,
    ThemeData theme,
    bool isDark,
  ) {
    if (list.isEmpty) return const Text('No manpower count recorded.');
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Table(
        border: TableBorder.all(
          color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder,
          borderRadius: BorderRadius.circular(12),
        ),
        columnWidths: const {
          0: FlexColumnWidth(3),
          1: FlexColumnWidth(1.5),
          2: FlexColumnWidth(1.5),
          3: FlexColumnWidth(1.5),
        },
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
          TableRow(
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(
                alpha: isDark ? 0.15 : 0.06,
              ),
            ),
            children: [
              _tableHeader('Personnel Role', theme),
              _tableHeader('Plan', theme, center: true),
              _tableHeader('Pres', theme, center: true),
              _tableHeader('OT', theme, center: true),
            ],
          ),
          ...list.map(
            (m) => TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 10,
                  ),
                  child: Text(
                    m.category,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 10,
                  ),
                  child: Text(
                    m.planned.toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 10,
                  ),
                  child: Text(
                    m.present.toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 10,
                  ),
                  child: Text(
                    m.overtime.toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- EQUIPMENT LIST ---
  Widget _buildEquipmentList(
    List<EquipmentUsage> list,
    ThemeData theme,
    bool isDark,
  ) {
    if (list.isEmpty) return const Text('No machinery logs recorded.');
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Table(
        border: TableBorder.all(
          color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder,
          borderRadius: BorderRadius.circular(12),
        ),
        columnWidths: const {
          0: FlexColumnWidth(3),
          1: FlexColumnWidth(2),
          2: FlexColumnWidth(2),
        },
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
          TableRow(
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(
                alpha: isDark ? 0.15 : 0.06,
              ),
            ),
            children: [
              _tableHeader('Equipment Name', theme),
              _tableHeader('Qty', theme, center: true),
              _tableHeader('Hrs', theme, center: true),
            ],
          ),
          ...list.map(
            (e) => TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 10,
                  ),
                  child: Text(
                    e.name,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 10,
                  ),
                  child: Text(
                    e.count.toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 10,
                  ),
                  child: Text(
                    e.hoursUsed.toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- MATERIALS LIST ---
  Widget _buildMaterialsList(
    List<MaterialInstalled> list,
    ThemeData theme,
    bool isDark,
  ) {
    if (list.isEmpty) return const Text('No material logs recorded.');
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Table(
        border: TableBorder.all(
          color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder,
          borderRadius: BorderRadius.circular(12),
        ),
        columnWidths: const {
          0: FlexColumnWidth(3),
          1: FlexColumnWidth(2),
          2: FlexColumnWidth(1.2),
        },
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
          TableRow(
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(
                alpha: isDark ? 0.15 : 0.06,
              ),
            ),
            children: [
              _tableHeader('Material Name', theme),
              _tableHeader('Qty', theme, center: true),
              _tableHeader('Unit', theme, center: true),
            ],
          ),
          ...list.map(
            (m) => TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 10,
                  ),
                  child: Text(
                    m.name,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 10,
                  ),
                  child: Text(
                    m.quantity.toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 10,
                  ),
                  child: Text(
                    m.unit,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.disabledColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- DELAYS LIST ---
  Widget _buildDelaysList(List<DelayIssue> list, ThemeData theme) {
    if (list.isEmpty) return const Text('No technical delays occurred.');
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: list.length,
      separatorBuilder: (context, index) => const Divider(height: 16),
      itemBuilder: (context, index) {
        final d = list[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  d.type,
                  style: const TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${d.impactHours} hrs impact',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(d.description),
          ],
        );
      },
    );
  }

  // --- PHOTOS GRID ---
  Widget _buildPhotosGrid(List<DarPhoto> list, ThemeData theme) {
    if (list.isEmpty) {
      return const Text('No supporting documentation photo logs attached.');
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 500 ? 2 : 1;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.4,
          ),
          itemCount: list.length,
          itemBuilder: (context, index) {
            final p = list[index];
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: theme.dividerColor),
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      color: Colors.blueGrey.withValues(alpha: 0.08),
                      child: const Center(
                        child: Icon(Icons.image, size: 32, color: Colors.grey),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      color: Colors.black.withValues(alpha: 0.6),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      child: Text(
                        p.caption,
                        maxLines: 2,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // --- SIGNATURES ---
  Widget _buildSignaturesBlock(DarReport report, ThemeData theme, bool isDark) {
    return AppCard(
      variant: AppCardVariant.outlined,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Approvals Log Status',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 600;
              final boxes = [
                _buildSignatureSignBox(
                  'Prepared By',
                  report.signedPrepared,
                  theme,
                  isDark,
                ),
                _buildSignatureSignBox(
                  'Checked By (QA/QC)',
                  report.signedChecked.isEmpty
                      ? 'Pending Check'
                      : report.signedChecked,
                  theme,
                  isDark,
                  pending: report.signedChecked.isEmpty,
                ),
                _buildSignatureSignBox(
                  'Approved By (PM)',
                  report.signedApproved.isEmpty
                      ? 'Pending Approval'
                      : report.signedApproved,
                  theme,
                  isDark,
                  pending: report.signedApproved.isEmpty,
                ),
              ];
              if (isWide) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(child: boxes[0]),
                    const SizedBox(width: 16),
                    Expanded(child: boxes[1]),
                    const SizedBox(width: 16),
                    Expanded(child: boxes[2]),
                  ],
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: boxes
                    .map(
                      (box) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: box,
                      ),
                    )
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSignatureSignBox(
    String label,
    String value,
    ThemeData theme,
    bool isDark, {
    bool pending = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkSurface : AppTheme.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              fontSize: 10,
              color: theme.disabledColor,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              fontStyle: pending ? FontStyle.normal : FontStyle.italic,
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: pending
                  ? Colors.orange
                  : theme.textTheme.bodyMedium?.color,
            ),
          ),
        ],
      ),
    );
  }

  // --- HELPER UTILS ---
  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 56, color: Color(0xFFD32F2F)),
          const SizedBox(height: 16),
          Text(
            'Failed to load report spec',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(message, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 24),
          AppButton(text: 'Return to list', onPressed: () => context.pop()),
        ],
      ),
    );
  }
}

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
