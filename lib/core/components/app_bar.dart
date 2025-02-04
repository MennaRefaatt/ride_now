import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import '../helpers/spacing.dart';
import '../services/routing/routing_endpoints.dart';
import '../theming/app_colors.dart';
import '../theming/styles.dart';
import '../utils/app_button.dart';

class DefaultAppBar extends StatefulWidget {
  const DefaultAppBar({
    super.key,
    required this.text,
    this.withDivider = true,
    this.backgroundColor,
    this.audioCallIcon = false,
    this.phone,
    this.imageUrl,
  });

  final String text;
  final bool? withDivider;
  final Color? backgroundColor;
  final bool? audioCallIcon;
  final String? phone;
  final String? imageUrl;

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

      leading: Scaffold.of(context).hasDrawer
          ? null
          : Padding(
        padding: EdgeInsets.all(8.0.w),
        child: SizedBox(
          width: MediaQuery.of(context).size.width*0.1,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const BackButton(color: Colors.black),
              CircleAvatar(
                radius: 20.r,
                backgroundColor: AppColors.primary.withOpacity(0.3),
                backgroundImage: widget.imageUrl != null && widget.imageUrl!.isNotEmpty
                    ? NetworkImage(widget.imageUrl!)
                    : null,
                child: widget.imageUrl == null || widget.imageUrl!.isEmpty
                    ? Icon(Icons.person, size: 24.sp, color: Colors.white)
                    : null,
              ),
            ],
          ),
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
              Text("Choose Call Type", style: TextStyles.font24BlackBold),
              verticalSpacing(20.h),
              AppButton(
                text: "Regular Call",
                backgroundColor: AppColors.primary,
                onPressed: () {
                  Navigator.pop(context);
                  _startRegularCall();
                },
                textStyle: TextStyles.font18BlackRegular,
              ),
              AppButton(
                text: "Online Call (Audio)",
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
    Navigator.pushNamed(context, RoutingEndpoints.audioCall);
  }
}
