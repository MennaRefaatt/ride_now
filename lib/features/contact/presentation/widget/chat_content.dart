import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../core/helpers/shared_pref.dart';
import '../../../../core/helpers/shared_pref_keys.dart';
import '../../../../core/theming/app_colors.dart';
import '../../manager/chat_cubit.dart';

class ChatContent extends StatelessWidget {
  const ChatContent({
    super.key,
    required this.chatCubit,
    required this.scrollController,
  });
  final ChatCubit chatCubit;
  final ScrollController scrollController;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder(
        stream: chatCubit.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data is ChatMessagesLoaded) {
            final chatState = snapshot.data as ChatMessagesLoaded;
            final messages = chatState.messages;
            return ListView.builder(
              controller: scrollController,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final isCurrentUser =
                    SharedPref.getInt(key: MySharedKeys.userId) ==
                        message.userId;

                DateTime messageTime = DateTime.parse(message.createdAt);
                String formattedTime = DateFormat.jm().format(messageTime);

                return Align(
                  alignment: isCurrentUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.all(8.sp),
                    padding: EdgeInsets.all(10.sp),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.7,
                    ),
                    decoration: BoxDecoration(
                      color: isCurrentUser
                          ? AppColors.primary
                          : AppColors.primaryLight,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12.r),
                        topRight: Radius.circular(12.r),
                        bottomLeft:
                            isCurrentUser ? Radius.circular(12.r) : Radius.zero,
                        bottomRight:
                            isCurrentUser ? Radius.zero : Radius.circular(12.r),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          message.message,
                          style: TextStyle(
                            color: isCurrentUser ? Colors.white : Colors.black,
                          ),
                        ),
                        SizedBox(height: 5.sp),
                        Text(
                          formattedTime,
                          style: TextStyle(
                            color:
                                isCurrentUser ? Colors.white70 : Colors.black54,
                          ),
                        ),
                        Text(message.isRead ? 'Seen' : 'Delivered'),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          if (snapshot.data is ChatLoading) {
            return const Center(
                child: CircularProgressIndicator(
              color: AppColors.primary,
            ));
          }
          return const Center(child: Text("No Messages"));
        },
      ),
    );
  }
}
