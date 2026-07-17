import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mhgo/core/theme/app_theme.dart';
import 'package:mhgo/core/widgets/responsive_layout.dart';
import 'package:mhgo/features/auth/presentation/providers/auth_provider.dart';

class AppShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const AppShell({
    super.key,
    required this.navigationShell,
  });

  void _onTabSelected(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobile: _MobileLayout(
          navigationShell: navigationShell,
          onTabSelected: _onTabSelected,
        ),
        tablet: _TabletLayout(
          navigationShell: navigationShell,
          onTabSelected: _onTabSelected,
        ),
        desktop: _DesktopLayout(
          navigationShell: navigationShell,
          onTabSelected: _onTabSelected,
        ),
      ),
    );
  }
}

// Navigation Item Definition
class _NavItem {
  final String label;
  final IconData icon;
  final IconData selectedIcon;
  const _NavItem({
    required this.label,
    required this.icon,
    required this.selectedIcon,
  });
}

const List<_NavItem> _navItems = [
  _NavItem(
    label: 'Dashboard',
    icon: Icons.dashboard_outlined,
    selectedIcon: Icons.dashboard,
  ),
  _NavItem(
    label: 'Projects',
    icon: Icons.assignment_outlined,
    selectedIcon: Icons.assignment,
  ),
  _NavItem(
    label: 'Progress',
    icon: Icons.timeline_outlined,
    selectedIcon: Icons.timeline,
  ),
  _NavItem(
    label: 'Inventory',
    icon: Icons.inventory_2_outlined,
    selectedIcon: Icons.inventory_2,
  ),
  _NavItem(
    label: 'Survey',
    icon: Icons.verified_user_outlined,
    selectedIcon: Icons.verified_user,
  ),
  _NavItem(
    label: 'O&M',
    icon: Icons.settings_suggest_outlined,
    selectedIcon: Icons.settings_suggest,
  ),
];

// --- MOBILE LAYOUT ---
class _MobileLayout extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  final ValueChanged<int> onTabSelected;

  const _MobileLayout({
    required this.navigationShell,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: onTabSelected,
        height: 65,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: _navItems.map((item) {
          return NavigationDestination(
            icon: Icon(item.icon),
            selectedIcon: Icon(item.selectedIcon, color: Theme.of(context).colorScheme.primary),
            label: item.label,
          );
        }).toList(),
      ),
    );
  }
}

// --- TABLET LAYOUT ---
class _TabletLayout extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  final ValueChanged<int> onTabSelected;

  const _TabletLayout({
    required this.navigationShell,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Row(
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: NavigationRail(
                    selectedIndex: navigationShell.currentIndex,
                    onDestinationSelected: onTabSelected,
                    labelType: NavigationRailLabelType.all,
                    backgroundColor: isDark ? AppTheme.darkBg : AppTheme.lightBg,
                    leading: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Image.asset(
                        'assets/logo.png', // Fallback to icon if asset not found
                        width: 32,
                        height: 32,
                        errorBuilder: (context, error, stackTrace) => CircleAvatar(
                          radius: 18,
                          backgroundColor: theme.colorScheme.primary,
                          child: const Text('M', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                    destinations: _navItems.map((item) {
                      return NavigationRailDestination(
                        icon: Icon(item.icon),
                        selectedIcon: Icon(item.selectedIcon, color: theme.colorScheme.primary),
                        label: Text(item.label),
                      );
                    }).toList(),
                  ),
                ),
              ),
            );
          },
        ),
        const VerticalDivider(width: 1, thickness: 1),
        Expanded(
          child: Scaffold(
            body: navigationShell,
          ),
        ),
      ],
    );
  }
}

// --- DESKTOP LAYOUT ---
class _DesktopLayout extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  final ValueChanged<int> onTabSelected;

  const _DesktopLayout({
    required this.navigationShell,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Row(
      children: [
        // Premium Custom Sidebar
        Container(
          width: 250,
          color: isDark ? AppTheme.darkBg : Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo & App Name Header
              Padding(
                padding: const EdgeInsets.only(left: 24.0, right: 16.0, top: 24.0, bottom: 20.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: theme.colorScheme.primary,
                      child: const Text(
                        'M',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'MHGo',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.5,
                          ),
                        ),
                        Text(
                          'Built for MHG',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: isDark ? AppTheme.darkTextMuted : AppTheme.lightTextSecondary,
                            fontWeight: FontWeight.w500,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Navigation Links List
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: ListView.separated(
                    itemCount: _navItems.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 4),
                    itemBuilder: (context, index) {
                      final item = _navItems[index];
                      final isSelected = index == navigationShell.currentIndex;

                      return _SidebarLink(
                        label: item.label,
                        icon: isSelected ? item.selectedIcon : item.icon,
                        isSelected: isSelected,
                        onTap: () => onTabSelected(index),
                      );
                    },
                  ),
                ),
              ),

              // User Info card & Sync Status at the bottom
              const Divider(),
              const _SidebarFooter(),
            ],
          ),
        ),
        const VerticalDivider(width: 1, thickness: 1),
        Expanded(
          child: Scaffold(
            body: navigationShell,
          ),
        ),
      ],
    );
  }
}

// Custom animated sidebar list item
class _SidebarLink extends StatefulWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _SidebarLink({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_SidebarLink> createState() => _SidebarLinkState();
}

class _SidebarLinkState extends State<_SidebarLink> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color activeColor = theme.colorScheme.primary;
    final Color activeBg = theme.colorScheme.primary.withOpacity(0.08);
    final Color hoverBg = isDark ? Colors.white.withOpacity(0.04) : Colors.black.withOpacity(0.02);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? activeBg
                : _isHovered
                    ? hoverBg
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
          ),
          child: Row(
            children: [
              Icon(
                widget.icon,
                size: 20,
                color: widget.isSelected
                    ? activeColor
                    : isDark
                        ? AppTheme.darkTextSecondary
                        : AppTheme.lightTextSecondary,
              ),
              const SizedBox(width: 12),
              Text(
                widget.label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: widget.isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: widget.isSelected
                      ? activeColor
                      : isDark
                          ? AppTheme.darkTextPrimary
                          : AppTheme.lightTextPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Sidebar footer for user details & sync indicators
class _SidebarFooter extends ConsumerWidget {
  const _SidebarFooter();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    final authState = ref.watch(authProvider);
    final user = authState.user;
    final String name = user?.name ?? 'Guest User';
    final String role = user?.role ?? 'Viewer';

    // Helper to extract initials
    String initials = 'PM';
    if (name.isNotEmpty) {
      final parts = name.trim().split(' ');
      if (parts.length >= 2 && parts[0].isNotEmpty && parts[1].isNotEmpty) {
        initials = '${parts[0][0]}${parts[1][0]}'.toUpperCase();
      } else if (parts.isNotEmpty && parts[0].isNotEmpty) {
        initials = parts[0][0].toUpperCase();
      }
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Connection Status
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFF10B981),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Offline First (Synced)',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: 11,
                  color: isDark ? AppTheme.darkTextMuted : AppTheme.lightTextSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // User Card
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: theme.colorScheme.secondary.withOpacity(0.2),
                child: Text(
                  initials,
                  style: TextStyle(
                    color: theme.colorScheme.secondary,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      role,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: 11,
                        color: isDark ? AppTheme.darkTextMuted : AppTheme.lightTextSecondary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.logout_outlined, size: 18),
                tooltip: 'Sign Out',
                onPressed: () => ref.read(authProvider.notifier).logout(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
