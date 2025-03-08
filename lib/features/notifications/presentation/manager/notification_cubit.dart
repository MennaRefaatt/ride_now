import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:ride_now/core/helpers/safe_print.dart';

import '../../data/models/notification_model.dart';
import '../../data/repositories/notification_repo.dart';

part 'notification_state.dart';

class NotificationsCubit extends Cubit<List<NotificationModel>> {
  final NotificationsRepository _repository;

  NotificationsCubit(this._repository) : super([]) {
    fetchNotifications();
  }
  Future<void> fetchNotifications() async {
    _repository.getNotifications().listen((notifications) {
      if (!isClosed) {
        emit(notifications);
      }
    });
  }

  Future<void> markNotificationAsRead(String id) async {
    try {
      await _repository.markAsRead(id);
      List<NotificationModel> updatedNotifications = state.map((notification) {
        if (notification.id == id) {
          return notification.copyWith(isRead: true);
        }
        return notification;
      }).toList();
      emit(updatedNotifications);
    } catch (e) {
      safePrint("Error marking notification as read: $e");
    }
  }

  Future<void> markAllNotificationsAsRead() async {
    try {
      await _repository.markAllAsRead();
      List<NotificationModel> updatedNotifications = state
          .map(
            (notification) => notification.copyWith(isRead: true),
          )
          .toList();
      emit(updatedNotifications);
    } catch (e) {
      safePrint("Error marking all notifications as read: $e");
    }
  }
}
