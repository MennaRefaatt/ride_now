import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:ride_now/core/forms/user_data_form_validators.dart';
import 'package:ride_now/core/helpers/safe_print.dart';
import 'package:ride_now/core/utils/app_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/services/routing/routing_endpoints.dart';
import '../../../../../core/theming/app_colors.dart';
import '../../../../../core/theming/styles.dart';
import '../../../../../generated/l10n.dart';
import '../manager/phone/phone_notifier.dart';

class PhoneField extends ConsumerWidget {
  const PhoneField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    FocusNode focusNode = FocusNode();
    final phoneState = ref.watch(phoneNotifierProvider);
    UserDataFormValidators userDataFormValidators = UserDataFormValidators();
    final phoneAuthNotifier = ref.watch(phoneNotifierProvider.notifier);

    return Column(
      children: [
        Text(S().phone,
            style: TextStyles.font18BlackRegular
                .copyWith(fontWeight: FontWeight.bold)),
        IntlPhoneField(
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
          },
          onCountryChanged: (country) {
            safePrint('Country changed to: ${country.name}');
          },
        ),
        if (phoneState.isLoading)
          CircularProgressIndicator(
            color: AppColors.primary,
          )
        else if (userDataFormValidators.phoneController.text.isEmpty)
          AppButton(
              text: "S().next",
              backgroundColor: AppColors.primary,
              onPressed: () async {
                final phoneNumber = userDataFormValidators.phoneController.text;
                if (phoneNumber.isNotEmpty) {
                  await phoneAuthNotifier.sendOtp(phoneNumber);
                  await Navigator.pushNamed(context, RoutingEndpoints.otp);
                } else {
                  safePrint("Phone number is required");
                }
              },
              textStyle: TextStyles.font14WhiteRegular),
        Visibility(
            visible: userDataFormValidators.phoneController.text.isEmpty,
            child: Text("Phone number is required",
                style: TextStyles.font14grayRegular
                    .copyWith(color: AppColors.red))),
        if (phoneState.errorMessage != null)
          Text(
            phoneState.errorMessage!,
            style: TextStyles.font14grayRegular.copyWith(color: AppColors.red),
          ),
      ],
    );
  }
}
