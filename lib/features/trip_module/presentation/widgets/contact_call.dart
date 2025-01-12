import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ride_now/core/theming/app_colors.dart';
import 'package:ride_now/core/theming/styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_now/core/utils/app_button.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/helpers/spacing.dart';

class ContactCall extends StatefulWidget {
  const ContactCall({super.key, required this.driverPhone});
  final String driverPhone;
  @override
  State<ContactCall> createState() => _ContactCallState();
}

class _ContactCallState extends State<ContactCall> {
  bool _isOnlineCall = false;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 30.r,
      backgroundColor: AppColors.primary,
      child: IconButton(
          onPressed: () => _showCallOptions(),
          icon: Icon(CupertinoIcons.phone)),
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
              Text("Choose Call Type", style: TextStyles.font24BlackBold),
              verticalSpacing(20.h),
              AppButton(
                  text: "Regular Call",
                  backgroundColor: AppColors.primary,
                  onPressed: () {
                    setState(() {
                      _isOnlineCall = false;
                    });
                    Navigator.pop(context);
                    _startRegularCall();
                  },
                  textStyle: TextStyles.font18BlackRegular),
              AppButton(
                text: "Online Call (Audio)",
                backgroundColor: AppColors.semiGrey,
                onPressed: () {
                  setState(() {
                    _isOnlineCall = true;
                  });
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
    final phoneNumber = widget.driverPhone;
    final url = 'tel:$phoneNumber';

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not initiate the call.')),
      );
    }
  }

  void _startOnlineCall() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Starting an online video call to the driver...')),
    );
  }
}
