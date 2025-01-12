import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:ride_now/core/components/app_bar.dart';
import 'package:ride_now/core/helpers/shared_pref.dart';
import 'package:ride_now/core/helpers/shared_pref_keys.dart';
import 'package:ride_now/core/helpers/spacing.dart';
import 'package:ride_now/core/utils/app_button.dart';
import 'package:ride_now/features/auth/login/data/data_sources/firestore_service/firestore_service.dart';
import 'package:ride_now/features/auth/phone_args.dart';
import '../../core/di/di.dart';
import '../../core/forms/user_data_form_validators.dart';
import '../../core/helpers/enums/user_type.dart';
import '../../core/helpers/safe_print.dart';
import '../../core/services/routing/routing_endpoints.dart';
import '../../core/theming/app_colors.dart';
import '../../core/theming/styles.dart';
import '../../generated/l10n.dart';

class PhoneNumberScreen extends StatefulWidget {
  final PhoneArgs args;
  const PhoneNumberScreen({super.key, required this.args});

  @override
  State<PhoneNumberScreen> createState() => _PhoneNumberScreenState();
}

class _PhoneNumberScreenState extends State<PhoneNumberScreen> {
  final FirestoreService _firestoreService=FirestoreService(sl(), sl());

  Future<void> _savePhoneNumber() async {
    userDataFormValidators.phoneController.text.trim();
    if (phoneNum.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: AppColors.red,
          content: Text("Please enter a valid phone number")));
      return;
    }
    if (formKey.currentState!.validate()) {
      await _firestoreService
          .updatePhoneNumberToFirestore(phoneNum)
          .then((value) {
        SharedPref.setString(key: MySharedKeys.phone, value: phoneNum);
        final userType = SharedPref.getString(key: MySharedKeys.type);
        if (userType == UserType.driver.name) {
          SharedPref.setString(key: MySharedKeys.driverPhone, value: phoneNum);
          Navigator.pushReplacementNamed(context, RoutingEndpoints.driverHome);
        } else {
          Navigator.pushReplacementNamed(
              context, RoutingEndpoints.passengerHome);
        }
      });
    }
  }

  late String phoneNum;
  UserDataFormValidators userDataFormValidators = UserDataFormValidators();
  FocusNode focusNode = FocusNode();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.h),
          child: DefaultAppBar(text: "Phone Number", withDivider: false)),
      body: Padding(
        padding: EdgeInsets.all(16.0.sp),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              key: formKey,
              child: IntlPhoneField(
                focusNode: focusNode,
                controller: userDataFormValidators.phoneController,
                validator: (value) => userDataFormValidators.validatePhone(
                  userDataFormValidators.phoneController.text,
                ),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.r),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.r),
                    borderSide: BorderSide(color: AppColors.red),
                  ),
                ),
                languageCode: "en",
                initialCountryCode: "EG",
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  LengthLimitingTextInputFormatter(10),
                ],
                onChanged: (phone) {
                  safePrint(phone.completeNumber);
                  safePrint(phone.countryCode);
                  phoneNum = phone.countryCode +
                      userDataFormValidators.phoneController.text;
                },
                onCountryChanged: (country) {
                  safePrint('Country changed to: ${country.name}');
                },
              ),
            ),
            verticalSpacing(10.h),
            AppButton(
                text: S().done,
                backgroundColor: AppColors.primary,
                onPressed: _savePhoneNumber,
                textStyle: TextStyles.font14WhiteBold),
          ],
        ),
      ),
    );
  }
}
