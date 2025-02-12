import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ride_now/core/theming/app_colors.dart';
import 'package:ride_now/core/theming/styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_now/core/utils/app_button.dart';
import 'package:ride_now/features/contact/presentation/contact_args.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../../core/helpers/safe_print.dart';
import '../../../../../core/services/routing/routing_endpoints.dart';
class ContactCall extends StatefulWidget {
  const ContactCall({super.key, required this.phone,
    required this.receiverFCMToken,
    required this.callerName});
  final String phone;
  final String receiverFCMToken;
  final String callerName;
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
              arguments: ContactArgs(callerName: widget.callerName, phoneNumber: widget.phone, receiverFCMToken: widget.receiverFCMToken));
        },
        icon: const Icon(CupertinoIcons.phone),
      ),
    );
  }
}
