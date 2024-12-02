import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: enable ?? true,
      focusNode: focusNode ?? FocusNode(),
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      minLines: minLines,
      maxLines: maxLines,
      maxLength: maxLength,
      controller: controller,
      initialValue: initialValue,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(20.0.r),
        ),
        isDense: true,
        labelText: withTitle == true ? title : null,
        labelStyle: titleStyle??TextStyles.font14grayRegular,
        contentPadding: contentPadding ??
            EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
        focusedBorder: focusedBorder ??
            OutlineInputBorder(
              borderSide: BorderSide(
                color: borderColor ?? AppColors.primary,
                width: 1.3,
              ),
              borderRadius: borderRadius ?? BorderRadius.circular(20.0.r),
            ),
        enabledBorder: enabledBorder ??
            OutlineInputBorder(
              borderSide: BorderSide(
                color: borderColor ?? AppColors.primary,
                width: 1.3,
              ),
              borderRadius: borderRadius ?? BorderRadius.circular(20.0.r),
            ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1.3,
          ),
          borderRadius: borderRadius ?? BorderRadius.circular(20.0.r),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1.3,
          ),
          borderRadius: borderRadius ?? BorderRadius.circular(20.0.r),
        ),
        hintStyle: hintStyle ?? TextStyles.font14grayRegular,
        hintText: withHint == true ? hintText : null,
        suffixIcon: suffixIcon,
        fillColor: backgroundColor ?? Colors.transparent,
        filled: isFilled ?? false,
      ),
      obscureText: isObscureText ?? false,
      style: TextStyles.font14primaryMedium,
      onChanged: onChanged,
      validator: validator,
    );
  }
}
