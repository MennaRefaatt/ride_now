import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/di.dart';
import '../../data/models/notification_model.dart';
import '../manager/notification_cubit.dart';

class NotificationIcon extends StatelessWidget {
  const NotificationIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NotificationsCubit(sl()),
      child: BlocBuilder<NotificationsCubit, List<NotificationModel>>(
        builder: (context, notifications) {
          int unreadCount = notifications
              .where((n) => !n.isRead)
              .length;

          return Stack(
            clipBehavior: Clip.none,
            children: [
              const Icon(Icons.notifications, size: 30, color: Colors.grey),
              if (unreadCount > 0)
                Positioned(
                  right: 0,
                  top: -2,
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.red,
                    child: Text(
                      unreadCount.toString(),
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
