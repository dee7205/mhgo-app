import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../../core/database/isar_service.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:share_plus/share_plus.dart';

import '../../../dashboard/presentation/providers/dashboard_provider.dart';
import '../../../projects/presentation/providers/projects_provider.dart';
import '../../../survey/presentation/providers/survey_provider.dart';
import '../../../dar/presentation/providers/dar_provider.dart';

class SettingsView extends ConsumerWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings'), centerTitle: false),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        children: [
          _buildSectionHeader(context, 'Appearance'),
          Card(
            elevation: 0,
            color: isDark ? AppTheme.darkBorder : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: isDark
                    ? Colors.white12
                    : Colors.black.withValues(alpha: 0.05),
              ),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.palette_outlined),
                  title: const Text('Theme'),
                  trailing: DropdownButton<ThemeMode>(
                    value: themeMode,
                    underline: const SizedBox(),
                    items: const [
                      DropdownMenuItem(
                        value: ThemeMode.system,
                        child: Text('System'),
                      ),
                      DropdownMenuItem(
                        value: ThemeMode.light,
                        child: Text('Light'),
                      ),
                      DropdownMenuItem(
                        value: ThemeMode.dark,
                        child: Text('Dark'),
                      ),
                    ],
                    onChanged: (mode) {
                      if (mode != null) {
                        ref.read(themeModeProvider.notifier).setThemeMode(mode);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionHeader(context, 'App Preferences'),
          Card(
            elevation: 0,
            color: isDark ? AppTheme.darkBorder : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: isDark
                    ? Colors.white12
                    : Colors.black.withValues(alpha: 0.05),
              ),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.payments_outlined),
                  title: const Text('Currency'),
                  trailing: const Text('Philippine Peso (₱)'),
                ),
                const Divider(height: 1, indent: 56),
                ListTile(
                  leading: const Icon(Icons.straighten_outlined),
                  title: const Text('Measurement Unit'),
                  trailing: const Text('Standard (kWp/MWp)'),
                ),
                const Divider(height: 1, indent: 56),
                ListTile(
                  leading: const Icon(Icons.notifications_none_outlined),
                  title: const Text('Notifications'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionHeader(context, 'Account'),
          Card(
            elevation: 0,
            color: isDark ? AppTheme.darkBorder : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: isDark
                    ? Colors.white12
                    : Colors.black.withValues(alpha: 0.05),
              ),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.person_outline),
                  title: const Text('Profile Information'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/settings/profile'),
                ),
                const Divider(height: 1, indent: 56),
                ListTile(
                  leading: const Icon(Icons.manage_accounts_outlined),
                  title: const Text('Account Settings'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
                const Divider(height: 1, indent: 56),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.redAccent),
                  title: const Text(
                    'Logout',
                    style: TextStyle(color: Colors.redAccent),
                  ),
                  onTap: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Logout'),
                        content: const Text('Are you sure you want to logout?'),
                        actions: [
                          TextButton(
                            onPressed: () => context.pop(false),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => context.pop(true),
                            child: const Text(
                              'Logout',
                              style: TextStyle(color: Colors.redAccent),
                            ),
                          ),
                        ],
                      ),
                    );

                    if (confirm == true) {
                      await ref.read(authProvider.notifier).logout();
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionHeader(context, 'Data & Storage'),
          Card(
            elevation: 0,
            color: isDark ? AppTheme.darkBorder : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: isDark
                    ? Colors.white12
                    : Colors.black.withValues(alpha: 0.05),
              ),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.storage_outlined),
                  title: const Text('Local Database'),
                  subtitle: const Text('Isar NoSQL Engine'),
                ),
                const Divider(height: 1, indent: 56),
                ListTile(
                  leading: const Icon(Icons.wifi_off_outlined),
                  title: const Text('Offline-First Status'),
                  subtitle: const Text('Enabled'),
                  trailing: Icon(
                    Icons.check_circle,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const Divider(height: 1, indent: 56),
                ListTile(
                  leading: const Icon(Icons.file_upload_outlined),
                  title: const Text('Export Data'),
                  subtitle: const Text('Backup local database'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () async {
                    try {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Generating backup...')),
                        );
                      }
                      final path = await ref
                          .read(isarServiceProvider)
                          .exportDatabase();

                      if (Platform.isAndroid) {
                        final downloadsDir = Directory(
                          '/storage/emulated/0/Download',
                        );
                        if (await downloadsDir.exists()) {
                          final fileName = path.split('/').last;
                          final newPath = '${downloadsDir.path}/$fileName';
                          await File(path).copy(newPath);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Saved to Downloads: $fileName'),
                              ),
                            );
                          }
                          return;
                        }
                      }

                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Backup ready. Choose where to save.',
                            ),
                          ),
                        );
                      }
                      await SharePlus.instance.share(
                        ShareParams(files: [XFile(path)], text: 'MHGo Backup'),
                      );
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Export failed: $e'),
                            backgroundColor: Colors.redAccent,
                          ),
                        );
                      }
                    }
                  },
                ),
                const Divider(height: 1, indent: 56),
                ListTile(
                  leading: const Icon(Icons.table_view_outlined),
                  title: const Text('Export Projects (CSV)'),
                  subtitle: const Text('Export projects to spreadsheet'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    _showCsvExportDialog(context, ref);
                  },
                ),
                const Divider(height: 1, indent: 56),
                ListTile(
                  leading: const Icon(Icons.file_download_outlined),
                  title: const Text('Import Data'),
                  subtitle: const Text('Restore from backup'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () async {
                    try {
                      final result = await FilePicker.platform.pickFiles(
                        type: FileType.any,
                      );
                      if (result != null && result.files.single.path != null) {
                        final file = result.files.single;
                        if (!file.name.endsWith('.zip')) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Invalid backup file. Must be a .zip file.',
                                ),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                          }
                          return;
                        }

                        if (!context.mounted) return;
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Import Data'),
                            content: const Text(
                              'This will overwrite all existing local data. Are you sure you want to proceed?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => context.pop(false),
                                child: const Text('Cancel'),
                              ),
                              FilledButton(
                                onPressed: () => context.pop(true),
                                child: const Text('Confirm'),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true) {
                          await ref
                              .read(isarServiceProvider)
                              .importDatabase(file.path!);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Data imported successfully. Please restart the app to sync all views.',
                                ),
                              ),
                            );
                          }
                        }
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Import failed: $e'),
                            backgroundColor: Colors.redAccent,
                          ),
                        );
                      }
                    }
                  },
                ),
                const Divider(height: 1, indent: 56),
                ListTile(
                  leading: const Icon(
                    Icons.delete_sweep_outlined,
                    color: Colors.redAccent,
                  ),
                  title: const Text(
                    'Clear App Data',
                    style: TextStyle(color: Colors.redAccent),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (dialogContext) => AlertDialog(
                        title: const Text('Clear Data'),
                        content: const Text(
                          'This will permanently delete all offline projects, surveys, DARs, and settings. Are you sure?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => dialogContext.pop(),
                            child: const Text('Cancel'),
                          ),
                          FilledButton(
                            onPressed: () async {
                              dialogContext.pop();

                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Clearing all local data...'),
                                  ),
                                );
                              }

                              try {
                                await ref
                                    .read(isarServiceProvider)
                                    .clearAllData();

                                // Invalidate core state providers to force a fresh UI reload
                                ref.invalidate(projectsListProvider);
                                ref.invalidate(surveyListProvider);
                                ref.invalidate(darsListProvider);
                                ref.invalidate(dashboardStateProvider);

                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'All local data cleared successfully.',
                                      ),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                }
                              } catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Failed to clear data: $e'),
                                      backgroundColor: Colors.redAccent,
                                    ),
                                  );
                                }
                              }
                            },
                            style: FilledButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                            ),
                            child: const Text('Confirm'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionHeader(context, 'About'),
          Card(
            elevation: 0,
            color: isDark ? AppTheme.darkBorder : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: isDark
                    ? Colors.white12
                    : Colors.black.withValues(alpha: 0.05),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/company_logo.png',
                    height: 50,
                    errorBuilder: (context, error, stackTrace) =>
                        const SizedBox(),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'MHGo',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Built for MHG',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'v1.1.2',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Powered by Flutter & Isar Database',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isDark ? Colors.white54 : Colors.black38,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 8),
      child: Text(
        title,
        style: theme.textTheme.titleSmall?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  void _showCsvExportDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Export Projects (CSV)'),
        content: const Text(
          'Export all projects as a CSV file.\n\n'
          'Would you like to save this file locally (Downloads) or share it?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _handleCsvExport(context, ref, share: false);
            },
            child: const Text('Save Local'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _handleCsvExport(context, ref, share: true);
            },
            child: const Text('Share'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleCsvExport(
    BuildContext context,
    WidgetRef ref, {
    required bool share,
  }) async {
    try {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Generating CSV export...')),
        );
      }

      final path = await ref.read(isarServiceProvider).exportProjectsCsv();
      final fileName = path.split(Platform.pathSeparator).last;

      if (!share && Platform.isAndroid) {
        final downloadsDir = Directory('/storage/emulated/0/Download');
        if (await downloadsDir.exists()) {
          final newPath = '${downloadsDir.path}/$fileName';
          await File(path).copy(newPath);
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Saved to Downloads: $fileName')),
            );
          }
          return;
        }
      }

      if (share) {
        await SharePlus.instance.share(
          ShareParams(files: [XFile(path)], text: 'MHGo Projects CSV Export'),
        );
      } else {
        // Fallback if not android or downloads dir missing
        await SharePlus.instance.share(
          ShareParams(
            files: [XFile(path)],
            text: 'Save MHGo Projects CSV Export',
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('CSV Export failed: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }
}
