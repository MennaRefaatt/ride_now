import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_now/core/components/app_text_form_field.dart';
import 'package:ride_now/core/helpers/safe_print.dart';
import 'package:ride_now/core/helpers/spacing.dart';
import 'package:ride_now/core/utils/app_button.dart';

import '../../../../../core/theming/app_colors.dart';
import '../../../../../core/theming/styles.dart';
import '../../../../../generated/l10n.dart';

class MoreOptions extends StatefulWidget {
  final Function(bool, String) onApply;
  final TextEditingController commentController;

  const MoreOptions({
    super.key,
    required this.onApply,
    required this.commentController,
  });

  @override
  State<MoreOptions> createState() => _MoreOptionsState();
}

class _MoreOptionsState extends State<MoreOptions> {
  bool moreThan4Passengers = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FloatingActionButton(
      onPressed: () => showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setModalState) {
              return DraggableScrollableSheet(
                initialChildSize: 0.6,
                minChildSize: 0.4,
                maxChildSize: 0.95,
                expand: false,
                builder: (context, scrollController) {
                  return Container(
                    padding: EdgeInsets.all(15.sp),
                    decoration: BoxDecoration(
                      color: theme.brightness == Brightness.dark
                          ? Colors.black
                          : Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(15.r),
                      ),
                    ),
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  S().options,
                                  style: theme.brightness == Brightness.dark
                                      ? TextStyles.font24WhiteBold
                                      : TextStyles.font24BlackBold,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: Container(
                                  padding: EdgeInsets.all(10.sp),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30.r),
                                    color: Colors.grey.shade200,
                                  ),
                                  child: Icon(
                                    CupertinoIcons.xmark,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          verticalSpacing(30),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  S().moreThan4Passengers,
                                  style: theme.brightness == Brightness.dark
                                      ? TextStyles.font18WhiteRegular
                                      : TextStyles.font18BlackRegular,
                                ),
                              ),
                              CupertinoSwitch(
                                value: moreThan4Passengers,
                                onChanged: (bool value) {
                                  setModalState(() {
                                    moreThan4Passengers = value;
                                    safePrint(moreThan4Passengers);
                                  });
                                },
                                activeColor: AppColors.primary,
                              ),
                            ],
                          ),

                          verticalSpacing(20.h),
                          AppTextFormField(
                            hintText: S().comment,
                            withHint: true,
                            controller: widget.commentController,
                            borderRadius: BorderRadius.circular(15.r),
                            backgroundColor: Colors.grey.shade200,
                            borderColor: Colors.transparent,
                            isFilled: true,
                            hintStyle: TextStyles.font18BlackRegular.copyWith(
                              color: Colors.grey.shade800,
                            ),
                          ),

                          verticalSpacing(20.h),

                          // Apply Button
                          AppButton(
                            text: S().apply,
                            width: double.infinity,
                            backgroundColor: AppColors.primary,
                            borderRadius: 15.r,
                            onPressed: () {
                              widget.onApply(moreThan4Passengers,
                                  widget.commentController.text);
                              Navigator.pop(context);
                            },
                            textStyle: TextStyles.font18BlackRegular,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      backgroundColor: AppColors.primary,
      elevation: 0,
      child: Icon(CupertinoIcons.location),
    );
  }
}
