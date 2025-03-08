import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_now/features/contact/presentation/contact_args.dart';
import '../../../../core/components/app_bar.dart';
import '../../../../core/theming/app_colors.dart';
import '../../core/service/socket_service.dart';
import '../../manager/chat_cubit.dart';
import '../widget/chat_bar.dart';
import '../widget/chat_content.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key, required this.contactArgs});
final ContactArgs contactArgs;
  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final SocketService _socketService = SocketService();
  late final ChatCubit chatCubit;
  final ScrollController _scrollController = ScrollController();

  String? channelId;

  @override
  void initState() {
    super.initState();
    _socketService.initSocket();
    chatCubit = ChatCubit(_socketService);
    chatCubit.fetchMessages();
    chatCubit.stream.listen((state) {
      if (state is ChatMessagesLoaded) {
        _scrollToBottom();
      }
    });
  }

  @override
  void dispose() {
    _socketService.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary.withValues(alpha: 0.1),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.h),
        child: DefaultAppBar(
          receiverProfilePicture: widget.contactArgs.receiverProfilePicture,
          text: widget.contactArgs.callerName,
          audioCallIcon: true,
          phone: widget.contactArgs.phoneNumber,
          withDivider: false,
          withProfilePicture: true,
          backgroundColor: Colors.transparent,
          callerName: widget.contactArgs.callerName,
          receiverFCMToken: widget.contactArgs.receiverFCMToken,
        ),
      ),
      body: Column(
        children: [
          ChatContent(
            chatCubit: chatCubit,
            scrollController: _scrollController,
          ),
          ChatBar(chatCubit: chatCubit, scrollToBottom: _scrollToBottom),
        ],
      ),
    );
  }
}
