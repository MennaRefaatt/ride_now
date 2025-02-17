import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_now/core/helpers/shared_pref.dart';
import 'package:ride_now/core/helpers/shared_pref_keys.dart';
import 'package:ride_now/core/helpers/spacing.dart';
import 'package:ride_now/core/services/routing/routing_endpoints.dart';

import '../../../theming/styles.dart';

class ProfileSection extends StatelessWidget {
  final String pictureUrl;
  final String userName;

  const ProfileSection({required this.pictureUrl, required this.userName, super.key});

  @override
  Widget build(BuildContext context) {
    ImageProvider? imageProvider;

    if (pictureUrl.isNotEmpty) {
      if (Uri.tryParse(pictureUrl)?.hasAbsolutePath == true && pictureUrl.startsWith('http')) {
        imageProvider = NetworkImage(pictureUrl);
      } else if (File(pictureUrl).existsSync()) {
        imageProvider = FileImage(File(pictureUrl));
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        verticalSpacing(20),
        InkWell(
          onTap: () => Navigator.pushReplacementNamed(context, RoutingEndpoints.profile),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30.sp,
                backgroundImage: imageProvider,
                child: imageProvider == null
                    ? Text(
                  userName.isNotEmpty ? userName[0] : '',
                  style: TextStyles.font18BlackRegular,
                )
                    : null,
              ),
              horizontalSpacing(10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      SharedPref.getString(key: MySharedKeys.userName) ?? 'Unknown User',
                      style: TextStyles.font14BlackRegular,
                    ),
                    Text(
                      SharedPref.getString(key: MySharedKeys.email) ?? 'No Email',
                      style: TextStyles.font12BlackRegular,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.navigate_next),
            ],
          ),
        ),
      ],
    );
  }
}
