import 'package:ride_now/features/notifications/data/data_sources/notification_ds.dart';

import '../models/notification_model.dart';

abstract class NotificationsRepository {
  Stream<List<NotificationModel>> getNotifications();
  Future<void> markAsRead(String id);
  Future<void> markAllAsRead();

}

class NotificationsRepositoryImpl implements NotificationsRepository {
final NotificationDs notificationDs;

  NotificationsRepositoryImpl({required this.notificationDs});
  @override
  Stream<List<NotificationModel>> getNotifications() {
    return notificationDs.getNotifications();
  }

  @override
  Future<void> markAsRead(String id) async {
    return notificationDs.markAsRead(id);
  }

  @override
  Future<void> markAllAsRead() async {
    return notificationDs.markAllAsRead();
  }

}
