import 'package:mhgo/core/database/models/notification_model.dart';

class NotificationEntity {
  final String uuid;
  final String title;
  final String description;
  final DateTime timestamp;
  final String type;
  final bool isRead;
  final String? relatedUuid;
  final String? targetRoute;

  NotificationEntity({
    required this.uuid,
    required this.title,
    required this.description,
    required this.timestamp,
    required this.type,
    this.isRead = false,
    this.relatedUuid,
    this.targetRoute,
  });

  factory NotificationEntity.fromModel(NotificationModel model) {
    return NotificationEntity(
      uuid: model.uuid,
      title: model.title,
      description: model.description,
      timestamp: model.timestamp,
      type: model.type,
      isRead: model.isRead,
      relatedUuid: model.relatedUuid,
      targetRoute: model.targetRoute,
    );
  }

  NotificationModel toModel() {
    return NotificationModel()
      ..uuid = uuid
      ..title = title
      ..description = description
      ..timestamp = timestamp
      ..type = type
      ..isRead = isRead
      ..relatedUuid = relatedUuid
      ..targetRoute = targetRoute;
  }

  NotificationEntity copyWith({
    String? uuid,
    String? title,
    String? description,
    DateTime? timestamp,
    String? type,
    bool? isRead,
    String? relatedUuid,
    String? targetRoute,
  }) {
    return NotificationEntity(
      uuid: uuid ?? this.uuid,
      title: title ?? this.title,
      description: description ?? this.description,
      timestamp: timestamp ?? this.timestamp,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      relatedUuid: relatedUuid ?? this.relatedUuid,
      targetRoute: targetRoute ?? this.targetRoute,
    );
  }
}
