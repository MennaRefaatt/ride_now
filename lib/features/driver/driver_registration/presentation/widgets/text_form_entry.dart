import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_now/core/helpers/safe_print.dart';

import '../../../../../core/components/app_text_form_field.dart';
import '../../../../../core/theming/app_colors.dart';

class TextFormEntry extends StatelessWidget {
  const TextFormEntry(
      {super.key,
      required this.hintText,
      required this.controller,
      this.inputFormatters,
      this.textInputAction,
      this.keyboardType,
      this.validator,
      this.enable,
      this.maxLength,
      this.onChanged});
  final String hintText;
  final TextEditingController controller;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final int? maxLength;
  final FormFieldValidator<String>? validator;
  final Function(String)? onChanged;
  final bool? enable;
  @override
  Widget build(BuildContext context) {
    return AppTextFormField(
      withHint: true,
      hintText: hintText,
      controller: controller,
      onChanged: onChanged,
      keyboardType: keyboardType,
      enable: enable,
      controllerTextColor: AppColors.black,
      textInputAction: textInputAction ?? TextInputAction.next,
      borderRadius: BorderRadius.circular(10.r),
      backgroundColor: AppColors.semiGrey.withOpacity(0.2),
      isFilled: true,
      maxLength: maxLength,
      inputFormatters: inputFormatters,
      validator: validator,
    );
  }
}

class DateValidator {
  static String? validateDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your date of birth';
    }

    final parts = value.split('/');
    if (parts.length != 3) {
      return 'Date format must be DD/MM/YYYY';
    }

    final day = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);
    final currentYear = DateTime.now().year;

    if (day == null || month == null || year == null) {
      return 'Invalid date';
    }

    if (day < 1 || day > 31) {
      return 'Day must be between 01 and 31';
    }

    if (month < 1 || month > 12) {
      return 'Month must be between 01 and 12';
    }

    if (year < 1950 || year > currentYear) {
      return 'Year must be between 1950 and $currentYear';
    }

    try {
      final date = DateTime(year, month, day);
      if (date.year != year || date.month != month || date.day != day) {
        return 'Invalid date (e.g., 31st Feb is not valid)';
      }
    } catch (e) {
      return 'Invalid date';
    }

    return null;
  }
}

class RealDateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text.replaceAll('/', '');
    final buffer = StringBuffer();

    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      if ((i == 1 || i == 3) && i != text.length - 1 && text.length <= 8) {
        buffer.write('/');
        safePrint("text: $text");
      }
    }

    final segments = buffer.toString().split('/');
    if (segments.isNotEmpty && segments[0].isNotEmpty) {
      final day = int.tryParse(segments[0]);
      if (day == null || day < 1 || day > 31) return oldValue;
    }

    if (segments.length > 1 && segments[1].isNotEmpty) {
      final month = int.tryParse(segments[1]);
      if (month == null || month < 1 || month > 12) return oldValue;
    }

    if (segments.length > 4 && segments[2].isNotEmpty) {
      final year = int.tryParse(segments[2]);
      if (year != null || year! < 1950 || year > DateTime.now().year) {
        return oldValue;
      }
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}

class YearInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text;

    if (text.length > 4) return oldValue;
    return newValue;
  }
}

class ExpiryDateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text.replaceAll('/', '');
    final buffer = StringBuffer();

    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      if ((i == 1 || i == 3) && i != text.length - 1 && text.length <= 8) {
        buffer.write('/');
        safePrint("text: $text");
      }
    }

    final segments = buffer.toString().split('/');
    if (segments.isNotEmpty && segments[0].isNotEmpty) {
      final day = int.tryParse(segments[0]);
      if (day == null || day < 1 || day > 31) return oldValue;
    }

    if (segments.length > 1 && segments[1].isNotEmpty) {
      final month = int.tryParse(segments[1]);
      if (month == null || month < 1 || month > 12) return oldValue;
    }

    if (segments.length > 4 && segments[2].isNotEmpty) {
      final year = int.tryParse(segments[2]);
      final month = int.tryParse(segments[1]);
      final currentYear = DateTime.now().year;
      final currentMonth = DateTime.now().month;
      final currentDay = DateTime.now().day;

      // Ensure the date is in the future
      if (year! < currentYear ||
          (year == currentYear && month! < currentMonth) ||
          (year == currentYear &&
              month == currentMonth &&
              int.tryParse(segments[0])! <= currentDay)) {
        return oldValue; // Reject if the date is in the past
      }
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}

class ExpiryDateValidator {
  static String? validateExpiryDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the expiry date';
    }

    final parts = value.split('/');
    if (parts.length != 3) {
      return 'Date format must be DD/MM/YYYY';
    }

    final day = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);
    final currentYear = DateTime.now().year;
    final currentMonth = DateTime.now().month;

    if (day == null || month == null || year == null) {
      return 'Invalid date';
    }

    if (day < 1 || day > 31) {
      return 'Day must be between 01 and 31';
    }

    if (month < 1 || month > 12) {
      return 'Month must be between 01 and 12';
    }

    if (year < currentYear || (year == currentYear && month < currentMonth)) {
      return 'Expiry date must be in the future';
    }

    try {
      final date = DateTime(year, month, day);
      if (date.year != year || date.month != month || date.day != day) {
        return 'Invalid date (e.g., 31st Feb is not valid)';
      }
    } catch (e) {
      return 'Invalid date';
    }

    return null;
  }
}
