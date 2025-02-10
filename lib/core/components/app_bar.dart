import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_now/core/helpers/shared_pref.dart';
import 'package:ride_now/core/services/f_c_m_service/firebase_messaging_service.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../generated/l10n.dart';
import '../helpers/shared_pref_keys.dart';
import '../helpers/spacing.dart';
import '../services/network/api_constants.dart';
import '../services/routing/routing_endpoints.dart';
import '../theming/app_colors.dart';
import '../theming/styles.dart';
import '../utils/app_button.dart';
import 'app_entry_point.dart';

class DefaultAppBar extends StatefulWidget {
  const DefaultAppBar(
      {super.key,
      required this.text,
      this.withDivider = true,
      this.backgroundColor,
      this.audioCallIcon = false,
      this.phone,
      this.withProfilePicture = false,
      this.callerName,
      this.receiverFCMToken});

  final String text;
  final bool? withDivider;
  final Color? backgroundColor;
  final bool? audioCallIcon;
  final String? phone;
  final bool? withProfilePicture;
  final String? callerName;
  final String? receiverFCMToken;
  @override
  State<DefaultAppBar> createState() => _DefaultAppBarState();
}

class _DefaultAppBarState extends State<DefaultAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        widget.text,
        style: TextStyles.font24BlackBold.copyWith(
          fontSize: 20.sp,
        ),
      ),
      backgroundColor: widget.backgroundColor,
      centerTitle: true,
      leadingWidth: Scaffold.of(context).hasDrawer
          ? MediaQuery.of(context).size.width * 0.1
          : MediaQuery.of(context).size.width * 0.3,
      leading: Scaffold.of(context).hasDrawer
          ? null
          : widget.withProfilePicture == false
              ? SizedBox()
              : Padding(
                  padding: EdgeInsets.all(2.0.sp),
                  child: Row(
                    children: [
                      const BackButton(),
                      CircleAvatar(
                        radius: 30.r,
                        backgroundColor: AppColors.primary.withValues(alpha: 0.3),
                        backgroundImage: (SharedPref.getString(
                                        key: MySharedKeys.picture) !=
                                    null &&
                                SharedPref.getString(key: MySharedKeys.picture)!
                                    .isNotEmpty)
                            ? NetworkImage(SharedPref.getString(
                                key: MySharedKeys.picture)!)
                            : null,
                        child: (SharedPref.getString(
                                        key: MySharedKeys.picture) ==
                                    null ||
                                SharedPref.getString(key: MySharedKeys.picture)!
                                    .isEmpty)
                            ? Icon(Icons.person,
                                size: 24.sp, color: Colors.white)
                            : null,
                      ),
                    ],
                  ),
                ),
      actions: [
        widget.audioCallIcon == false
            ? const SizedBox()
            : IconButton(
                onPressed: () {
                  _showCallOptions();
                },
                icon: const Icon(CupertinoIcons.phone),
              )
      ],
      bottom: widget.withDivider == true
          ? const PreferredSize(
              preferredSize: Size.fromHeight(1),
              child: Divider(),
            )
          : null,
    );
  }

  void _showCallOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(S().chooseCallType, style: TextStyles.font24BlackBold),
              verticalSpacing(20.h),
              AppButton(
                text: S().regularCall,
                backgroundColor: AppColors.primary,
                onPressed: () {
                  Navigator.pop(context);
                  _startRegularCall();
                },
                textStyle: TextStyles.font18BlackRegular,
              ),
              AppButton(
                text: S().audioCall,
                backgroundColor: AppColors.semiGrey,
                onPressed: () {
                  Navigator.pop(context);
                  _startOnlineCall();
                },
                textStyle: TextStyles.font18BlackRegular,
              ),
            ],
          ),
        );
      },
    );
  }

  void _startRegularCall() async {
    final phoneNumber = widget.phone;
    final url = 'tel:$phoneNumber';

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not initiate the call.')),
      );
    }
  }

  void _startOnlineCall() {
    if (widget.receiverFCMToken != null && widget.callerName != null) {
      sendCallNotification(widget.receiverFCMToken!, widget.callerName!,
          AgoraConstants.channelId);
      appNavKey.currentState?.pushNamed(RoutingEndpoints.audioCall);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Missing call parameters')),
      );
    }
  }
}
