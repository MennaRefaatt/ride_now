import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_now/core/helpers/spacing.dart';

import '../theming/app_colors.dart';
import '../theming/styles.dart';

class AppTextFormField extends StatelessWidget {
  final EdgeInsetsGeometry? contentPadding;
  final InputBorder? focusedBorder;
  final InputBorder? enabledBorder;
  final TextStyle? inputTextStyle;
  final TextStyle? hintStyle;
  final String? hintText;
  final bool? isObscureText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final Color? backgroundColor;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final String? initialValue;
  final int? maxLength;
  final int? minLines;
  final int? maxLines;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final bool? withTitle;
  final String? title;
  final bool? isFilled;
  final BorderRadius? borderRadius;
  final bool? enable;
  final FocusNode? focusNode;
  final Color? borderColor;
  final bool? withHint;
  final TextStyle? titleStyle;
  final bool? withShadow;
  final Color? controllerTextColor;
  final String? errorText;
  final  List<TextInputFormatter>? inputFormatters;
  const AppTextFormField({
    super.key,
    this.contentPadding,
    this.focusedBorder,
    this.enabledBorder,
    this.inputTextStyle,
    this.hintStyle,
    this.hintText,
    this.isObscureText,
    this.suffixIcon,
    this.backgroundColor,
    this.controller,
    this.validator,
    this.onChanged,
    this.withTitle,
    this.initialValue,
    this.title,
    this.minLines = 1,
    this.maxLines = 1,
    this.maxLength,
    this.keyboardType,
    this.textInputAction,
    this.borderRadius,
    this.isFilled,
    this.enable,
    this.focusNode,
    this.borderColor,
    this.withHint,
    this.titleStyle,
    this.prefixIcon,
    this.withShadow = false,
    this.controllerTextColor,
    this.errorText, this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (withTitle == true)
          Text(title ?? '',
              style: TextStyles.font14BlackRegular
                  .copyWith(fontWeight: FontWeight.bold)),
        verticalSpacing(10.h),
        Container(
          decoration: BoxDecoration(
              borderRadius: borderRadius ?? BorderRadius.circular(30.0.r),
              boxShadow: [
                BoxShadow(
                  color: withShadow == true
                      ? Colors.grey.withOpacity(0.5)
                      : Colors.transparent,
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ]),
          child: TextFormField(
            focusNode: focusNode ?? FocusNode(),
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            minLines: minLines,
            maxLines: maxLines,
            maxLength: maxLength,
            inputFormatters: inputFormatters,
            controller: controller,
            initialValue: initialValue,
            decoration: InputDecoration(
              errorText: errorText,
              border: OutlineInputBorder(
                borderRadius: borderRadius ?? BorderRadius.circular(30.0.r),
              ),
              isDense: true,
              labelStyle: titleStyle ?? TextStyles.font14grayRegular,
              contentPadding: contentPadding ??
                  EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
              focusedBorder: focusedBorder ??
                  OutlineInputBorder(
                    borderSide: BorderSide(
                      color: borderColor ?? AppColors.hint,
                      width: 0,
                    ),
                    borderRadius: borderRadius ?? BorderRadius.circular(30.0.r),
                  ),
              disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.transparent,
                  width: 0,
                ),
                borderRadius: borderRadius ?? BorderRadius.circular(30.0.r),
              ),
              enabledBorder: enabledBorder ??
                  OutlineInputBorder(
                    borderSide: BorderSide(
                      color: borderColor ?? Colors.grey.shade300,
                      width: 0,
                    ),
                    borderRadius: borderRadius ?? BorderRadius.circular(30.0.r),
                  ),
              errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.red,
                  width: 1.3,
                ),
                borderRadius: borderRadius ?? BorderRadius.circular(30.0.r),
              ),
              enabled: enable ?? true,
              focusedErrorBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.red,
                  width: 1.3,
                ),
                borderRadius: borderRadius ?? BorderRadius.circular(30.0.r),
              ),
              hintStyle: hintStyle ?? TextStyles.font14grayRegular,
              hintText: withHint == true ? hintText : null,
              suffixIcon: suffixIcon,
              fillColor: backgroundColor ?? Colors.transparent,
              filled: isFilled ?? false,
              prefixIcon: prefixIcon,
            ),
            obscureText: isObscureText ?? false,
            style: controllerTextColor != null
                ? TextStyle(color: controllerTextColor, fontSize: 18.sp)
                : TextStyles.font18primaryMedium,
            onChanged: onChanged,
            validator: validator,
          ),
        ),
      ],
    );
  }
}
