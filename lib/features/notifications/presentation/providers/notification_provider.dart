import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:mhgo/features/notifications/domain/entities/notification_entity.dart';
import 'package:mhgo/features/notifications/data/repositories/notification_repository_impl.dart';

final notificationProvider = AsyncNotifierProvider<NotificationNotifier, List<NotificationEntity>>(() {
  return NotificationNotifier();
});

class NotificationNotifier extends AsyncNotifier<List<NotificationEntity>> {
  @override
  FutureOr<List<NotificationEntity>> build() async {
    return _fetchNotifications();
  }

  Future<List<NotificationEntity>> _fetchNotifications() async {
    final repository = ref.read(notificationRepositoryProvider);
    return await repository.getNotifications();
  }

  Future<void> fetchNotifications() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchNotifications());
  }

  Future<void> markAsRead(String uuid) async {
    final repository = ref.read(notificationRepositoryProvider);
    await repository.markAsRead(uuid);
    await fetchNotifications();
  }

  Future<void> markAllAsRead() async {
    final repository = ref.read(notificationRepositoryProvider);
    await repository.markAllAsRead();
    await fetchNotifications();
  }

  Future<void> deleteNotification(String uuid) async {
    final repository = ref.read(notificationRepositoryProvider);
    await repository.deleteNotification(uuid);
    await fetchNotifications();
  }

  Future<void> createNotification({
    required String title,
    required String description,
    required String type,
    String? relatedUuid,
    String? targetRoute,
  }) async {
    final repository = ref.read(notificationRepositoryProvider);
    final notification = NotificationEntity(
      uuid: const Uuid().v4(),
      title: title,
      description: description,
      timestamp: DateTime.now(),
      type: type,
      isRead: false,
      relatedUuid: relatedUuid,
      targetRoute: targetRoute,
    );
    await repository.saveNotification(notification);
    await fetchNotifications();
  }
}
