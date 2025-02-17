import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_now/core/components/app_bar.dart';
import 'package:ride_now/core/components/drawer/drawer_items.dart';
import 'package:ride_now/core/theming/app_colors.dart';
import '../../../../generated/l10n.dart';
import '../manager/notification_cubit.dart';
import '../../data/models/notification_model.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationsScreen> {
  @override
  void dispose() {
    super.dispose();
    context.read<NotificationsCubit>().markAllNotificationsAsRead();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.h),
          child: DefaultAppBar(
            text: S().notifications,
            withDivider: false,
          )),
      drawer: DrawerItems(),
      body: BlocBuilder<NotificationsCubit, List<NotificationModel>>(
        builder: (context, notifications) {
          final sortedNotifications =
              List<NotificationModel>.from(notifications)
                ..sort((a, b) => b.timestamp.compareTo(a.timestamp));

          return sortedNotifications.isEmpty
              ? Center(
            child: Text(
              S().noNotificationsFound,
              style: TextStyle(fontSize: 18.sp, color: AppColors.semiGrey),
            ),
          )
              :ListView.builder(
            itemCount: sortedNotifications.length,
            itemBuilder: (context, index) {
              final notification = sortedNotifications[index];
              return GestureDetector(
                onTap: () => context
                    .read<NotificationsCubit>()
                    .markNotificationAsRead(notification.id),
                child: Container(
                  margin: EdgeInsets.all(10.sp),
                  decoration: BoxDecoration(
                    color: notification.isRead
                        ? AppColors.semiGrey.withValues(alpha: 0.1)
                        : AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: ListTile(
                    title: Text(notification.title),
                    subtitle: Text(notification.body),
                    trailing: notification.isRead
                        ? null
                        : const Icon(Icons.circle, color: Colors.red, size: 10),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
