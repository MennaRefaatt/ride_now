import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_now/core/components/app_text_form_field.dart';
import 'package:ride_now/core/services/routing/routing_endpoints.dart';
import 'package:ride_now/core/theming/app_colors.dart';
import '../../../../core/helpers/shared_pref.dart';
import '../../../../core/helpers/shared_pref_keys.dart';

class UserForms extends StatefulWidget {
  const UserForms({
    super.key,
    required this.onFieldChanged,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.cityController,
    required this.phoneController,
  });

  final void Function() onFieldChanged;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController cityController;
  final TextEditingController phoneController;

  @override
  State<UserForms> createState() => _UserFormsState();
}

class _UserFormsState extends State<UserForms> {
  String? missingPhoneMessage;

  @override
  void initState() {
    super.initState();

    final String userName =
        SharedPref.getString(key: MySharedKeys.userName) ?? '';
    final String firstName =
        userName.split(' ').isNotEmpty ? userName.split(' ').first : '';
    final String lastName =
        userName.split(' ').length > 1 ? userName.split(' ').last : '';

    widget.firstNameController.text = firstName;
    widget.lastNameController.text = lastName;
    widget.emailController.text =
        SharedPref.getString(key: MySharedKeys.email) ?? '';
    widget.cityController.text =
        SharedPref.getString(key: MySharedKeys.city) ?? '';

    final phone = SharedPref.getString(key: MySharedKeys.phone) ?? '';
    widget.phoneController.text = phone;

    if (phone.isEmpty ||
        phone == "missing phone number" ||
        !isValidEgyptianPhone(phone)) {
      setState(() {
        missingPhoneMessage = "Phone number is required or invalid!";
      });
    }

    widget.firstNameController.addListener(() {
      if (widget.firstNameController.text != firstName) {
        widget.onFieldChanged();
      }
    });

    widget.lastNameController.addListener(() {
      if (widget.lastNameController.text != lastName) {
        widget.onFieldChanged();
      }
    });

    widget.cityController.addListener(() {
      if (widget.cityController.text !=
          SharedPref.getString(key: MySharedKeys.city)) {
        widget.onFieldChanged();
      }
    });

    widget.phoneController.addListener(() {
      final isPhoneValid = isValidEgyptianPhone(widget.phoneController.text);
      setState(() {
        missingPhoneMessage =
            isPhoneValid ? null : "Invalid or missing phone number!";
      });
    });
  }

  bool isValidEgyptianPhone(String phone) {
    final regex = RegExp(r'^\+20[1][0125][0-9]{8}$');
    return regex.hasMatch(phone);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10.sp),
      padding: EdgeInsets.all(10.sp),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25.r),
      ),
      child: Column(
        children: [
          item(
              context: context,
              icon: CupertinoIcons.person,
              controller: widget.firstNameController),
          item(
              context: context,
              icon: CupertinoIcons.person,
              controller: widget.lastNameController),
          item(
            context: context,
            icon: CupertinoIcons.mail,
            controller: widget.emailController,
            enable: false,
            controllerTextColor: Colors.grey,
          ),
          item(
              context: context,
              icon: CupertinoIcons.phone,
              controller: widget.phoneController,
              errorText: missingPhoneMessage,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Phone number is required!";
                }
                if (!isValidEgyptianPhone(value)) {
                  return "Enter a valid Egyptian phone number!";
                }
                return null;
              },
              controllerTextColor:
                  missingPhoneMessage != null ? AppColors.red : AppColors.primary,
              borderColor: missingPhoneMessage != null
                  ? AppColors.red
                  : Colors.transparent),
          item(
              context: context,
              icon: CupertinoIcons.building_2_fill,
              controller: widget.cityController,
              enable: false,
              onTap: () => Navigator.pushNamed(context, RoutingEndpoints.city),
              controllerTextColor: widget.cityController.text == "missing city"
                  ? AppColors.red
                  : AppColors.primary),
        ],
      ),
    );
  }

  @override
  void dispose() {
    widget.firstNameController.dispose();
    widget.lastNameController.dispose();
    widget.emailController.dispose();
    widget.cityController.dispose();
    super.dispose();
  }

  Widget item({
    required BuildContext context,
    required IconData icon,
    required TextEditingController controller,
    Color? controllerTextColor,
    Color? borderColor,
    bool? enable,
    String? errorText,
    String? Function(String?)? validator,
    int? maxLength,
    void Function()? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: AppTextFormField(
              controller: controller,
              contentPadding: EdgeInsets.only(left: 10.sp),
              borderColor: borderColor ?? Colors.transparent,
              enable: enable ?? true,
              controllerTextColor: errorText != null && errorText.isNotEmpty
                  ? Colors.red
                  : (controllerTextColor ?? AppColors.primary),
              errorText: errorText,
              validator: validator,
              onChanged: (_) => widget.onFieldChanged(),
              maxLength: maxLength,
            ),
          ),
        ],
      ),
    );
  }
}
