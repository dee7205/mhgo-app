import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:mhgo/features/notifications/domain/entities/notification_entity.dart';
import 'package:mhgo/features/notifications/presentation/providers/notification_provider.dart';

class NotificationsListView extends ConsumerStatefulWidget {
  const NotificationsListView({super.key});

  @override
  ConsumerState<NotificationsListView> createState() => _NotificationsListViewState();
}

class _NotificationsListViewState extends ConsumerState<NotificationsListView> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notificationsState = ref.watch(notificationProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all),
            tooltip: 'Mark all as read',
            onPressed: () {
              ref.read(notificationProvider.notifier).markAllAsRead();
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Unread'),
            Tab(text: 'Read'),
          ],
        ),
      ),
      body: notificationsState.when(
        data: (notifications) {
          final unread = notifications.where((n) => !n.isRead).toList();
          final read = notifications.where((n) => n.isRead).toList();

          return TabBarView(
            controller: _tabController,
            children: [
              _buildList(unread),
              _buildList(read),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildList(List<NotificationEntity> notifications) {
    if (notifications.isEmpty) {
      return const Center(child: Text('No notifications found.'));
    }

    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return Dismissible(
          key: Key(notification.uuid),
          direction: DismissDirection.endToStart,
          background: Container(
            color: Theme.of(context).colorScheme.error,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 16),
            child: Icon(Icons.delete, color: Theme.of(context).colorScheme.onError),
          ),
          onDismissed: (_) {
            ref.read(notificationProvider.notifier).deleteNotification(notification.uuid);
          },
          child: ListTile(
            leading: _getIconForType(notification.type, context),
            title: Text(
              notification.title,
              style: TextStyle(
                fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(notification.description, maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Text(
                  DateFormat.yMMMd().add_jm().format(notification.timestamp),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
            onTap: () {
              if (!notification.isRead) {
                ref.read(notificationProvider.notifier).markAsRead(notification.uuid);
              }
              if (notification.targetRoute != null && notification.targetRoute!.isNotEmpty) {
                context.push(notification.targetRoute!);
              }
            },
          ),
        );
      },
    );
  }

  Widget _getIconForType(String type, BuildContext context) {
    IconData iconData;
    switch (type) {
      case 'project':
        iconData = Icons.business_center;
        break;
      case 'survey':
        iconData = Icons.assignment;
        break;
      case 'dar':
        iconData = Icons.receipt_long;
        break;
      case 'progress':
        iconData = Icons.trending_up;
        break;
      default:
        iconData = Icons.notifications;
    }
    return CircleAvatar(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
      child: Icon(iconData),
    );
  }
}
