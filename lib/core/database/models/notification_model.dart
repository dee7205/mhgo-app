import 'package:isar_community/isar.dart';

part 'notification_model.g.dart';

@collection
class NotificationModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String uuid;

  late String title;

  late String description;

  late DateTime timestamp;

  late String type;

  bool isRead = false;

  String? relatedUuid;

  String? targetRoute;
}
