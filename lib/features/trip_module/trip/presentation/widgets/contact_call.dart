import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ride_now/core/theming/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_now/features/contact/presentation/contact_args.dart';
import '../../../../../core/services/routing/routing_endpoints.dart';
class ContactCall extends StatefulWidget {
  const ContactCall({super.key, required this.phone,
    required this.receiverFCMToken,
    required this.receiverProfilePicture,
    required this.callerName});
  final String phone;
  final String receiverFCMToken;
  final String callerName;
  final String receiverProfilePicture;
  @override
  State<ContactCall> createState() => _ContactCallState();
}

class _ContactCallState extends State<ContactCall> {
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 30.r,
      backgroundColor: AppColors.primary,
      child: IconButton(
        onPressed: () {
          Navigator.pushNamed(context, RoutingEndpoints.contactScreen,
              arguments: ContactArgs(
                receiverProfilePicture: widget.receiverProfilePicture,
                  callerName: widget.callerName, phoneNumber: widget.phone, receiverFCMToken: widget.receiverFCMToken));
        },
        icon: const Icon(CupertinoIcons.phone),
      ),
    );
  }
}
