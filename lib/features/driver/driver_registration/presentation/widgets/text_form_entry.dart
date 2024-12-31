import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/components/app_text_form_field.dart';
import '../../../../../core/theming/app_colors.dart';

class TextFormEntry extends StatelessWidget {
  const TextFormEntry({
    super.key,
    required this.hintText,
    required this.controller,
    this.inputFormatters,
    this.textInputAction,
    this.keyboardType,
    this.validator,
    this.enable,
    this.maxLength,
    this.onChanged,
    this.suffixIcon,
  });

  final String hintText;
  final Widget? suffixIcon;
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
      suffixIcon: suffixIcon,
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

      if (year! < currentYear ||
          (year == currentYear && month! < currentMonth) ||
          (year == currentYear &&
              month == currentMonth &&
              int.tryParse(segments[0])! <= currentDay)) {
        return oldValue;
      }
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}

class LicenseNumberValidator {
  static String? validateLicenseNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your license number';
    }

    if (value.length != 14) {
      return 'License number must be 14 characters long';
    }

    if (!RegExp(r'^[A-Za-z]').hasMatch(value[0])) {
      return 'License number should start with a letter';
    }

    if (!RegExp(r'^\d{13}$').hasMatch(value.substring(1))) {
      return 'License number should have 13 digits following the first letter';
    }

    final year = int.tryParse(value.substring(1, 5));
    final currentYear = DateTime.now().year;

    if (year != null && (year < 1950 || year > currentYear)) {
      return 'Year in license number is not valid';
    }

    return null;
  }
}

class NationalIdValidator {
  static String? validateNationalId(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your National ID';
    }

    if (value.length != 14) {
      return 'National ID must be 14 digits long';
    }

    if (!RegExp(r'^\d{14}$').hasMatch(value)) {
      return 'National ID must contain only digits';
    }

    if (!_isValidChecksum(value)) {
      return 'Invalid National ID checksum';
    }
    final birthYear = int.parse(value.substring(1, 3));
    final birthMonth = int.parse(value.substring(3, 5));
    final currentYear = DateTime.now().year % 100;
    final currentMonth = DateTime.now().month;

    if (birthMonth < 1 || birthMonth > 12) {
      return 'Invalid birth month';
    }
    if (birthYear > currentYear ||
        (birthYear == currentYear && birthMonth > currentMonth)) {
      return 'Birth date cannot be in the future';
    }

    return null;
  }

  static bool _isValidChecksum(String id) {
    int sum = 0;
    for (int i = 0; i < 13; i++) {
      sum += int.parse(id[i]) * (i % 2 == 0 ? 1 : 2);
    }

    final checksum = (10 - (sum % 10)) % 10;
    return checksum == int.parse(id[13]);
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

    if (day == null || month == null || year == null) {
      return 'Invalid date';
    }

    final currentDate = DateTime.now();
    final currentYear = currentDate.year;

    if (day < 1 || day > 31) {
      return 'Day must be between 01 and 31';
    }

    if (month < 1 || month > 12) {
      return 'Month must be between 01 and 12';
    }

    if (year < currentYear || year > currentYear + 10) {
      return 'Year must be within the next 10 years';
    }

    try {
      final expiryDate = DateTime(year, month, day);
      if (expiryDate.isBefore(currentDate)) {
        return 'Expiry date cannot be in the past';
      }

      if (expiryDate.year != year ||
          expiryDate.month != month ||
          expiryDate.day != day) {
        return 'Invalid date (e.g., 31st Feb is not valid)';
      }
    } catch (e) {
      return 'Invalid date';
    }

    return null;
  }
}

class VehiclePlateValidator {
  static String? validatePlateNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a vehicle plate number';
    }
    final platePattern = RegExp(r'^[A-Za-z]{1,2}\d{4,6}[A-Za-z0-9]?$');
    if (!platePattern.hasMatch(value)) {
      return 'Invalid plate number format. Example: C12345 or A1234E';
    }
    return null;
  }
}
