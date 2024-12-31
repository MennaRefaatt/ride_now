import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/helpers/spacing.dart';
import '../../../../../core/theming/app_colors.dart';
import '../../../../../core/theming/styles.dart';

class PickImage extends StatelessWidget {
  const PickImage(
      {super.key,
      required this.text,
      required this.onTap,
      required this.image});
  final String text;
  final Function()? onTap;
  final String image;

  String formatText(String text) {
    final words = text.split(' ');
    final lines = <String>[];
    for (int i = 0; i < words.length; i += 2) {
      if (i + 1 < words.length) {
        lines.add('${words[i]} ${words[i + 1]}');
      } else {
        lines.add(words[i]);
      }
    }
    return lines.join('\n');
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Column(
        children: [
          image.isNotEmpty
              ? SizedBox(
                  height: MediaQuery.of(context).size.height * 0.15,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.r),
                      child: Image.file(File(image))),
                )
              : Container(
                  height: MediaQuery.of(context).size.height * 0.15,
                  width: MediaQuery.of(context).size.height * 0.15,
                  padding: EdgeInsets.all(20.sp),
                  decoration: BoxDecoration(
                    color: AppColors.semiGrey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Icon(CupertinoIcons.plus, size: 40.sp),
                ),
          verticalSpacing(10.h),
          Text(
            formatText(text),
            style: TextStyles.font14BlackRegular,
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            softWrap: true,
          ),
        ],
      ),
    );
  }
}
