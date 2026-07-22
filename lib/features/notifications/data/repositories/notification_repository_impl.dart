import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar_community/isar.dart';
import 'package:mhgo/core/database/isar_service.dart';
import 'package:mhgo/core/database/models/notification_model.dart';
import 'package:mhgo/features/notifications/domain/entities/notification_entity.dart';

final notificationRepositoryProvider = Provider<NotificationRepositoryImpl>((ref) {
  final isarService = ref.watch(isarServiceProvider);
  return NotificationRepositoryImpl(isarService);
});

class NotificationRepositoryImpl {
  final IsarService _isarService;

  NotificationRepositoryImpl(this._isarService);

  Future<List<NotificationEntity>> getNotifications() async {
    final models = await _isarService.isar.notificationModels.where().findAll();
    models.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return models.map((e) => NotificationEntity.fromModel(e)).toList();
  }

  Future<void> saveNotification(NotificationEntity notification) async {
    await _isarService.isar.writeTxn(() async {
      await _isarService.isar.notificationModels.put(notification.toModel());
    });
  }

  Future<void> markAsRead(String uuid) async {
    final model = await _isarService.isar.notificationModels.where().uuidEqualTo(uuid).findFirst();
    if (model != null) {
      model.isRead = true;
      await _isarService.isar.writeTxn(() async {
        await _isarService.isar.notificationModels.put(model);
      });
    }
  }

  Future<void> markAllAsRead() async {
    final models = await _isarService.isar.notificationModels.filter().isReadEqualTo(false).findAll();
    if (models.isNotEmpty) {
      for (var model in models) {
        model.isRead = true;
      }
      await _isarService.isar.writeTxn(() async {
        await _isarService.isar.notificationModels.putAll(models);
      });
    }
  }

  Future<void> deleteNotification(String uuid) async {
    final model = await _isarService.isar.notificationModels.where().uuidEqualTo(uuid).findFirst();
    if (model != null) {
      await _isarService.isar.writeTxn(() async {
        await _isarService.isar.notificationModels.delete(model.id);
      });
    }
  }
}
