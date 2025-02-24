import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../core/components/app_text_form_field.dart';
import '../../../../core/helpers/shared_pref.dart';
import '../../../../core/helpers/shared_pref_keys.dart';
import '../../../../core/theming/app_colors.dart';
import '../../manager/chat_cubit.dart';
import '../../model/message_req.dart';

class ChatBar extends StatelessWidget {
  const ChatBar(
      {super.key, required this.chatCubit, required this.scrollToBottom});
  final ChatCubit chatCubit;
  final void Function() scrollToBottom;
  @override
  Widget build(BuildContext context) {
    return BlurryContainer(
      blur: 8,
      elevation: 6,
      color: AppColors.primary.withOpacity(0.1),
      padding: EdgeInsets.all(8.sp),
      borderRadius: BorderRadius.circular(0),
      child: Row(
        children: [
          Flexible(
            child: AppTextFormField(
              borderColor: Colors.transparent,
              controller: chatCubit.messageController,
              hintText: 'Enter message',
              keyboardType: TextInputType.multiline,
              isFilled: true,
              maxLines: 100,
              contentPadding: EdgeInsets.all(10.sp),
              borderRadius: BorderRadius.circular(30.r),
              onChanged: (text) {
                if (text.isNotEmpty) {
                  scrollToBottom();
                }
              },
            ),
          ),
          IconButton(
            icon: const Icon(CupertinoIcons.paperplane),
            onPressed: () {
              DateTime now = DateTime.now();
              String formattedTime = DateFormat('yyyy-MM-ddTHH:mm:ss')
                  .format(now);
              String trimmedMessage = chatCubit.messageController.text.trim();
              if (chatCubit.messageController.text.isNotEmpty &&
                  trimmedMessage.isNotEmpty) {
                chatCubit.sendMessage(
                  message: MessageReq(
                    message: trimmedMessage,
                    id: SharedPref.getInt(key: MySharedKeys.userId)
                        .toString(),
                    createdAt: formattedTime,
                  ),
                );
                chatCubit.messageController.clear();
                scrollToBottom();
              }
            },
          ),
        ],
      ),
    );
  }
}
