import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:ride_now/core/forms/user_data_form_validators.dart';
import 'package:ride_now/core/helpers/safe_print.dart';
import 'package:ride_now/core/utils/app_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/theming/app_colors.dart';
import '../../../../../core/theming/styles.dart';
import '../../../../../generated/l10n.dart';
import '../manager/phone/phone_state.dart';

class LoginForms extends ConsumerWidget {
  const LoginForms({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    FocusNode focusNode = FocusNode();
    bool isLoading = false;
    UserDataFormValidators userDataFormValidators = UserDataFormValidators();
    final phoneAuthNotifier = ref.watch(phoneAuthNotifierProvider.notifier);

    return Column(
      children: [
        Text(S().phone, style: TextStyles.font18BlackRegular.copyWith(
            fontWeight: FontWeight.bold
        )),
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
              )),
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
        isLoading
            ? const CircularProgressIndicator()
            : AppButton(
            text: "S().next",  // Corrected text to actual translation
            backgroundColor: AppColors.primary,
            onPressed: () async {
              final phoneNumber = userDataFormValidators.phoneController.text;
              if (phoneNumber.isNotEmpty) {
                await phoneAuthNotifier.sendOtp(phoneNumber);
              } else {
                // Handle empty phone number error
                safePrint("Phone number is required");
              }
            },
            textStyle: TextStyles.font14WhiteRegular),
      ],
    );
  }
}
