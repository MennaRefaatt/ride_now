import 'package:flutter/cupertino.dart';

class UserDataFormValidators {
  UserDataFormValidators();

  TextEditingController emailController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController passwordController = TextEditingController();

  TextEditingController nameController = TextEditingController();

  TextEditingController phoneController = TextEditingController();

  TextEditingController confirmPasswordController = TextEditingController();

  bool isPasswordVisible = true;

  bool isConfirmPasswordVisible = true;

  bool hasLowercase = false;

  bool hasUppercase = false;

  bool hasSpecialCharacters = false;

  bool hasNumber = false;

  bool hasMinLength = false;

  bool get canSubmitLogin =>
      emailController.text.isNotEmpty && passwordController.text.isNotEmpty;

  bool get canSubmitRegister =>
      emailController.text.isNotEmpty &&
          passwordController.text.isNotEmpty &&
          confirmPasswordController.text.isNotEmpty;

  void setEmail(String value) {
    emailController.text = value;
  }

  void setPassword(String value) {
    passwordController.text = value;
    hasLowercase = passwordController.text.contains(RegExp(r'[a-z]'));
    hasUppercase = passwordController.text.contains(RegExp(r'[A-Z]'));
    hasSpecialCharacters =
        passwordController.text.contains(RegExp(r'[!@#$&*~]'));
    hasNumber = passwordController.text.contains(RegExp(r'[0-9]'));
    hasMinLength = passwordController.text.length >= 8;
  }
  void setConfirmPassword(String value) {
    confirmPasswordController.text = value;
    hasLowercase = confirmPasswordController.text.contains(RegExp(r'[a-z]'));
    hasUppercase = confirmPasswordController.text.contains(RegExp(r'[A-Z]'));
    hasSpecialCharacters =
        confirmPasswordController.text.contains(RegExp(r'[!@#$&*~]'));
    hasNumber = confirmPasswordController.text.contains(RegExp(r'[0-9]'));
    hasMinLength = confirmPasswordController.text.length >= 8;
  }

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible = !isConfirmPasswordVisible;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    // if (value != validatePasswordStrength()) {
    //   return 'Password must contain the below characters'.tr();
    // }
    return null;
  }

  validatePasswordStrength() {
    hasLowercase = RegExp(r'[a-z]').hasMatch(passwordController.text);
    hasUppercase = RegExp(r'[A-Z]').hasMatch(passwordController.text);
    hasSpecialCharacters =
        RegExp(r'[!@#$&*~]').hasMatch(passwordController.text);
    hasNumber = RegExp(r'[0-9]').hasMatch(passwordController.text);
    hasMinLength = passwordController.text.length >= 8;
  }

  String? validateEmail(String? value) {
    if (value == null ||
        value.isEmpty ||
        !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }
  String? validateName(String? value) {
    if (value == null ||
        value.isEmpty) {
      return 'Please enter your name';
    }
    return null;
  }
  String? validatePhone(String? value) {
    if (value == null ||
        value.isEmpty ||
        !RegExp(r'^01').hasMatch(value)) {
      return 'Please start with 01';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    // if (value != validatePasswordStrength()) {
    //   return 'Password must contain the below characters'.tr();
    // }
    if (value != passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }
}
