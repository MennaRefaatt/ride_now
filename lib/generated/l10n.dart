// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name =
        (locale.countryCode?.isEmpty ?? false)
            ? locale.languageCode
            : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Login Screen`
  String get loginText {
    return Intl.message('Login Screen', name: 'loginText', desc: '', args: []);
  }

  /// `Suggested For You`
  String get suggestedForYou {
    return Intl.message(
      'Suggested For You',
      name: 'suggestedForYou',
      desc: '',
      args: [],
    );
  }

  /// `See All`
  String get seeAll {
    return Intl.message('See All', name: 'seeAll', desc: '', args: []);
  }

  /// `Spacial For You`
  String get spacialForYou {
    return Intl.message(
      'Spacial For You',
      name: 'spacialForYou',
      desc: '',
      args: [],
    );
  }

  /// `Shop By Category`
  String get shopByCategory {
    return Intl.message(
      'Shop By Category',
      name: 'shopByCategory',
      desc: '',
      args: [],
    );
  }

  /// `Passwords Don't Match`
  String get passwordsDontMatch {
    return Intl.message(
      'Passwords Don\'t Match',
      name: 'passwordsDontMatch',
      desc: '',
      args: [],
    );
  }

  /// `Already Have An Account ?`
  String get alreadyHaveAnAccount {
    return Intl.message(
      'Already Have An Account ?',
      name: 'alreadyHaveAnAccount',
      desc: '',
      args: [],
    );
  }

  /// `Create account`
  String get createAccount {
    return Intl.message(
      'Create account',
      name: 'createAccount',
      desc: '',
      args: [],
    );
  }

  /// `Manage Account`
  String get manageAccount {
    return Intl.message(
      'Manage Account',
      name: 'manageAccount',
      desc: '',
      args: [],
    );
  }

  /// `Profile Info`
  String get profileInfo {
    return Intl.message(
      'Profile Info',
      name: 'profileInfo',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message('Settings', name: 'settings', desc: '', args: []);
  }

  /// `Update Account`
  String get updateAccount {
    return Intl.message(
      'Update Account',
      name: 'updateAccount',
      desc: '',
      args: [],
    );
  }

  /// `Mobile Phone`
  String get mobilePhone {
    return Intl.message(
      'Mobile Phone',
      name: 'mobilePhone',
      desc: '',
      args: [],
    );
  }

  /// `Current Password`
  String get currentPassword {
    return Intl.message(
      'Current Password',
      name: 'currentPassword',
      desc: '',
      args: [],
    );
  }

  /// `Repeat Password`
  String get repeatPassword {
    return Intl.message(
      'Repeat Password',
      name: 'repeatPassword',
      desc: '',
      args: [],
    );
  }

  /// `Must Be Different`
  String get mustBeDifferent {
    return Intl.message(
      'Must Be Different',
      name: 'mustBeDifferent',
      desc: '',
      args: [],
    );
  }

  /// `Product Details`
  String get productDetails {
    return Intl.message(
      'Product Details',
      name: 'productDetails',
      desc: '',
      args: [],
    );
  }

  /// `Category Details`
  String get categoryDetails {
    return Intl.message(
      'Category Details',
      name: 'categoryDetails',
      desc: '',
      args: [],
    );
  }

  /// `Favorite`
  String get favorite {
    return Intl.message('Favorite', name: 'favorite', desc: '', args: []);
  }

  /// `Cart`
  String get cart {
    return Intl.message('Cart', name: 'cart', desc: '', args: []);
  }

  /// `Order Info`
  String get orderInfo {
    return Intl.message('Order Info', name: 'orderInfo', desc: '', args: []);
  }

  /// `Total`
  String get total {
    return Intl.message('Total', name: 'total', desc: '', args: []);
  }

  /// `Sub Total`
  String get subTotal {
    return Intl.message('Sub Total', name: 'subTotal', desc: '', args: []);
  }

  /// `Products`
  String get products {
    return Intl.message('Products', name: 'products', desc: '', args: []);
  }

  /// `Check Out`
  String get checkout {
    return Intl.message('Check Out', name: 'checkout', desc: '', args: []);
  }

  /// `Description`
  String get description {
    return Intl.message('Description', name: 'description', desc: '', args: []);
  }

  /// `Address`
  String get address {
    return Intl.message('Address', name: 'address', desc: '', args: []);
  }

  /// `My Addresses`
  String get myAddresses {
    return Intl.message(
      'My Addresses',
      name: 'myAddresses',
      desc: '',
      args: [],
    );
  }

  /// `Add New Address`
  String get addNewAddress {
    return Intl.message(
      'Add New Address',
      name: 'addNewAddress',
      desc: '',
      args: [],
    );
  }

  /// `Saved Addresses`
  String get savedAddresses {
    return Intl.message(
      'Saved Addresses',
      name: 'savedAddresses',
      desc: '',
      args: [],
    );
  }

  /// `Notes`
  String get notes {
    return Intl.message('Notes', name: 'notes', desc: '', args: []);
  }

  /// `City`
  String get city {
    return Intl.message('City', name: 'city', desc: '', args: []);
  }

  /// `Longitude`
  String get longitude {
    return Intl.message('Longitude', name: 'longitude', desc: '', args: []);
  }

  /// `Latitude`
  String get latitude {
    return Intl.message('Latitude', name: 'latitude', desc: '', args: []);
  }

  /// `Save`
  String get save {
    return Intl.message('Save', name: 'save', desc: '', args: []);
  }

  /// `Details`
  String get details {
    return Intl.message('Details', name: 'details', desc: '', args: []);
  }

  /// `Region`
  String get region {
    return Intl.message('Region', name: 'region', desc: '', args: []);
  }

  /// `Required`
  String get required {
    return Intl.message('Required', name: 'required', desc: '', args: []);
  }

  /// `Optional`
  String get optional {
    return Intl.message('Optional', name: 'optional', desc: '', args: []);
  }

  /// `Buy Now`
  String get buyNow {
    return Intl.message('Buy Now', name: 'buyNow', desc: '', args: []);
  }

  /// `Add To Cart`
  String get addToCart {
    return Intl.message('Add To Cart', name: 'addToCart', desc: '', args: []);
  }

  /// `Profile`
  String get profile {
    return Intl.message('Profile', name: 'profile', desc: '', args: []);
  }

  /// `Home`
  String get home {
    return Intl.message('Home', name: 'home', desc: '', args: []);
  }

  /// `Search`
  String get search {
    return Intl.message('Search', name: 'search', desc: '', args: []);
  }

  /// `Categories`
  String get categories {
    return Intl.message('Categories', name: 'categories', desc: '', args: []);
  }

  /// `Are you surely you want to logout ?`
  String get areYouSuretyYouWantToLogout {
    return Intl.message(
      'Are you surely you want to logout ?',
      name: 'areYouSuretyYouWantToLogout',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this address ?`
  String get areYouSureYouWantToDeleteThisAddress {
    return Intl.message(
      'Are you sure you want to delete this address ?',
      name: 'areYouSureYouWantToDeleteThisAddress',
      desc: '',
      args: [],
    );
  }

  /// `Category Complaint`
  String get categoryComplaint {
    return Intl.message(
      'Category Complaint',
      name: 'categoryComplaint',
      desc: '',
      args: [],
    );
  }

  /// `Write Your Complaint Here`
  String get writeYourComplaintHere {
    return Intl.message(
      'Write Your Complaint Here',
      name: 'writeYourComplaintHere',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get logout {
    return Intl.message('Logout', name: 'logout', desc: '', args: []);
  }

  /// `Change Language`
  String get changeLanguage {
    return Intl.message(
      'Change Language',
      name: 'changeLanguage',
      desc: '',
      args: [],
    );
  }

  /// `English`
  String get english {
    return Intl.message('English', name: 'english', desc: '', args: []);
  }

  /// `Arabic`
  String get arabic {
    return Intl.message('Arabic', name: 'arabic', desc: '', args: []);
  }

  /// `Are you sure you want to logout ?`
  String get logoutText {
    return Intl.message(
      'Are you sure you want to logout ?',
      name: 'logoutText',
      desc: '',
      args: [],
    );
  }

  /// `Yes`
  String get yes {
    return Intl.message('Yes', name: 'yes', desc: '', args: []);
  }

  /// `No`
  String get no {
    return Intl.message('No', name: 'no', desc: '', args: []);
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `Done`
  String get done {
    return Intl.message('Done', name: 'done', desc: '', args: []);
  }

  /// `New Password`
  String get newPassword {
    return Intl.message(
      'New Password',
      name: 'newPassword',
      desc: '',
      args: [],
    );
  }

  /// `Confirm New Password`
  String get confirmNewPassword {
    return Intl.message(
      'Confirm New Password',
      name: 'confirmNewPassword',
      desc: '',
      args: [],
    );
  }

  /// `Old Password`
  String get oldPassword {
    return Intl.message(
      'Old Password',
      name: 'oldPassword',
      desc: '',
      args: [],
    );
  }

  /// `Change`
  String get change {
    return Intl.message('Change', name: 'change', desc: '', args: []);
  }

  /// `Password Changed`
  String get passwordChanged {
    return Intl.message(
      'Password Changed',
      name: 'passwordChanged',
      desc: '',
      args: [],
    );
  }

  /// `Password Not Changed`
  String get passwordNotChanged {
    return Intl.message(
      'Password Not Changed',
      name: 'passwordNotChanged',
      desc: '',
      args: [],
    );
  }

  /// `Not Valid Email`
  String get notValidEmail {
    return Intl.message(
      'Not Valid Email',
      name: 'notValidEmail',
      desc: '',
      args: [],
    );
  }

  /// `Not Valid Password`
  String get notValidPassword {
    return Intl.message(
      'Not Valid Password',
      name: 'notValidPassword',
      desc: '',
      args: [],
    );
  }

  /// `Not Valid Phone`
  String get notValidPhone {
    return Intl.message(
      'Not Valid Phone',
      name: 'notValidPhone',
      desc: '',
      args: [],
    );
  }

  /// `Not Valid Name`
  String get notValidName {
    return Intl.message(
      'Not Valid Name',
      name: 'notValidName',
      desc: '',
      args: [],
    );
  }

  /// `Not Valid Old Password`
  String get notValidOldPassword {
    return Intl.message(
      'Not Valid Old Password',
      name: 'notValidOldPassword',
      desc: '',
      args: [],
    );
  }

  /// `Not Valid Confirm Password`
  String get notValidConfirmPassword {
    return Intl.message(
      'Not Valid Confirm Password',
      name: 'notValidConfirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `Not Valid New Password`
  String get notValidNewPassword {
    return Intl.message(
      'Not Valid New Password',
      name: 'notValidNewPassword',
      desc: '',
      args: [],
    );
  }

  /// `Not Valid`
  String get notValid {
    return Intl.message('Not Valid', name: 'notValid', desc: '', args: []);
  }

  /// `Notification`
  String get notification {
    return Intl.message(
      'Notification',
      name: 'notification',
      desc: '',
      args: [],
    );
  }

  /// `Full Name`
  String get fullName {
    return Intl.message('Full Name', name: 'fullName', desc: '', args: []);
  }

  /// `Phone`
  String get phone {
    return Intl.message('Phone', name: 'phone', desc: '', args: []);
  }

  /// `Email`
  String get email {
    return Intl.message('Email', name: 'email', desc: '', args: []);
  }

  /// `Change Password`
  String get changePassword {
    return Intl.message(
      'Change Password',
      name: 'changePassword',
      desc: '',
      args: [],
    );
  }

  /// `Contact Us`
  String get contactUs {
    return Intl.message('Contact Us', name: 'contactUs', desc: '', args: []);
  }

  /// `Complaints`
  String get complaints {
    return Intl.message('Complaints', name: 'complaints', desc: '', args: []);
  }

  /// `FAQs`
  String get fAQs {
    return Intl.message('FAQs', name: 'fAQs', desc: '', args: []);
  }

  /// `Terms and Conditions`
  String get termsAndConditions {
    return Intl.message(
      'Terms and Conditions',
      name: 'termsAndConditions',
      desc: '',
      args: [],
    );
  }

  /// `App Language`
  String get appLanguage {
    return Intl.message(
      'App Language',
      name: 'appLanguage',
      desc: '',
      args: [],
    );
  }

  /// `English`
  String get englishLanguage {
    return Intl.message('English', name: 'englishLanguage', desc: '', args: []);
  }

  /// `Arabic`
  String get arabicLanguage {
    return Intl.message('Arabic', name: 'arabicLanguage', desc: '', args: []);
  }

  /// `logOut`
  String get logOut {
    return Intl.message('logOut', name: 'logOut', desc: '', args: []);
  }

  /// `Orders`
  String get orders {
    return Intl.message('Orders', name: 'orders', desc: '', args: []);
  }

  /// `Password`
  String get password {
    return Intl.message('Password', name: 'password', desc: '', args: []);
  }

  /// `Please Enter Old Password`
  String get pleaseEnterOldPassword {
    return Intl.message(
      'Please Enter Old Password',
      name: 'pleaseEnterOldPassword',
      desc: '',
      args: [],
    );
  }

  /// `Please Enter New Password`
  String get pleaseEnterNewPassword {
    return Intl.message(
      'Please Enter New Password',
      name: 'pleaseEnterNewPassword',
      desc: '',
      args: [],
    );
  }

  /// `Please Enter Confirm Password`
  String get pleaseEnterConfirmPassword {
    return Intl.message(
      'Please Enter Confirm Password',
      name: 'pleaseEnterConfirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `Please Enter Your Name`
  String get pleaseEnterYourName {
    return Intl.message(
      'Please Enter Your Name',
      name: 'pleaseEnterYourName',
      desc: '',
      args: [],
    );
  }

  /// `Please Enter Your Phone`
  String get pleaseEnterYourPhone {
    return Intl.message(
      'Please Enter Your Phone',
      name: 'pleaseEnterYourPhone',
      desc: '',
      args: [],
    );
  }

  /// `Please Enter Your Email`
  String get pleaseEnterYourEmail {
    return Intl.message(
      'Please Enter Your Email',
      name: 'pleaseEnterYourEmail',
      desc: '',
      args: [],
    );
  }

  /// `Please Enter Your Password`
  String get pleaseEnterYourPassword {
    return Intl.message(
      'Please Enter Your Password',
      name: 'pleaseEnterYourPassword',
      desc: '',
      args: [],
    );
  }

  /// `Invalid Email`
  String get invalidEmail {
    return Intl.message(
      'Invalid Email',
      name: 'invalidEmail',
      desc: '',
      args: [],
    );
  }

  /// `Invalid Password`
  String get invalidPassword {
    return Intl.message(
      'Invalid Password',
      name: 'invalidPassword',
      desc: '',
      args: [],
    );
  }

  /// `Invalid Phone`
  String get invalidPhone {
    return Intl.message(
      'Invalid Phone',
      name: 'invalidPhone',
      desc: '',
      args: [],
    );
  }

  /// `Invalid Name`
  String get invalidName {
    return Intl.message(
      'Invalid Name',
      name: 'invalidName',
      desc: '',
      args: [],
    );
  }

  /// `Invalid Old Password`
  String get invalidOldPassword {
    return Intl.message(
      'Invalid Old Password',
      name: 'invalidOldPassword',
      desc: '',
      args: [],
    );
  }

  /// `Invalid Confirm Password`
  String get invalidConfirmPassword {
    return Intl.message(
      'Invalid Confirm Password',
      name: 'invalidConfirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `Invalid New Password`
  String get invalidNewPassword {
    return Intl.message(
      'Invalid New Password',
      name: 'invalidNewPassword',
      desc: '',
      args: [],
    );
  }

  /// `Invalid`
  String get invalid {
    return Intl.message('Invalid', name: 'invalid', desc: '', args: []);
  }

  /// `Wrong Phone`
  String get wrongPhone {
    return Intl.message('Wrong Phone', name: 'wrongPhone', desc: '', args: []);
  }

  /// `Wrong Password`
  String get wrongPassword {
    return Intl.message(
      'Wrong Password',
      name: 'wrongPassword',
      desc: '',
      args: [],
    );
  }

  /// `Length Must Be Equal 11`
  String get lengthMustBeEqual11 {
    return Intl.message(
      'Length Must Be Equal 11',
      name: 'lengthMustBeEqual11',
      desc: '',
      args: [],
    );
  }

  /// `Repeat Password`
  String get RepeatPassword {
    return Intl.message(
      'Repeat Password',
      name: 'RepeatPassword',
      desc: '',
      args: [],
    );
  }

  /// `Password Not Match`
  String get passwordNotMatch {
    return Intl.message(
      'Password Not Match',
      name: 'passwordNotMatch',
      desc: '',
      args: [],
    );
  }

  /// `Password Not Changed Successfully`
  String get passwordNotChangedSuccessfully {
    return Intl.message(
      'Password Not Changed Successfully',
      name: 'passwordNotChangedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Password Changed Successfully`
  String get passwordChangedSuccessfully {
    return Intl.message(
      'Password Changed Successfully',
      name: 'passwordChangedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get register {
    return Intl.message('Register', name: 'register', desc: '', args: []);
  }

  /// `I Already Have An Account`
  String get iAlreadyHaveAnAccount {
    return Intl.message(
      'I Already Have An Account',
      name: 'iAlreadyHaveAnAccount',
      desc: '',
      args: [],
    );
  }

  /// `Register Screen`
  String get registerText {
    return Intl.message(
      'Register Screen',
      name: 'registerText',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login {
    return Intl.message('Login', name: 'login', desc: '', args: []);
  }

  /// `Enter Your Email`
  String get enterYourEmail {
    return Intl.message(
      'Enter Your Email',
      name: 'enterYourEmail',
      desc: '',
      args: [],
    );
  }

  /// `Enter Your Password`
  String get enterYourPassword {
    return Intl.message(
      'Enter Your Password',
      name: 'enterYourPassword',
      desc: '',
      args: [],
    );
  }

  /// `Enter Your Name`
  String get enterYourName {
    return Intl.message(
      'Enter Your Name',
      name: 'enterYourName',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message('Name', name: 'name', desc: '', args: []);
  }

  /// `Enter Your Phone`
  String get enterYourPhone {
    return Intl.message(
      'Enter Your Phone',
      name: 'enterYourPhone',
      desc: '',
      args: [],
    );
  }

  /// `Sign In`
  String get signIn {
    return Intl.message('Sign In', name: 'signIn', desc: '', args: []);
  }

  /// `Sign Up`
  String get signUp {
    return Intl.message('Sign Up', name: 'signUp', desc: '', args: []);
  }

  /// `OR`
  String get or {
    return Intl.message('OR', name: 'or', desc: '', args: []);
  }

  /// `Forgot Password?`
  String get forgotPassword {
    return Intl.message(
      'Forgot Password?',
      name: 'forgotPassword',
      desc: '',
      args: [],
    );
  }

  /// `Reset Password`
  String get resetPassword {
    return Intl.message(
      'Reset Password',
      name: 'resetPassword',
      desc: '',
      args: [],
    );
  }

  /// `Enter Your Email To Reset Password`
  String get enterYourEmailToResetPassword {
    return Intl.message(
      'Enter Your Email To Reset Password',
      name: 'enterYourEmailToResetPassword',
      desc: '',
      args: [],
    );
  }

  /// `Enter Your New Password`
  String get enterYourNewPassword {
    return Intl.message(
      'Enter Your New Password',
      name: 'enterYourNewPassword',
      desc: '',
      args: [],
    );
  }

  /// `Enter Your Confirm Password`
  String get enterYourConfirmPassword {
    return Intl.message(
      'Enter Your Confirm Password',
      name: 'enterYourConfirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `Enter Your Old Password`
  String get enterYourOldPassword {
    return Intl.message(
      'Enter Your Old Password',
      name: 'enterYourOldPassword',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Password`
  String get confirmPassword {
    return Intl.message(
      'Confirm Password',
      name: 'confirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `Save And Continue`
  String get saveAndContinue {
    return Intl.message(
      'Save And Continue',
      name: 'saveAndContinue',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Order`
  String get confirmOrder {
    return Intl.message(
      'Confirm Order',
      name: 'confirmOrder',
      desc: '',
      args: [],
    );
  }

  /// `Payment Method`
  String get paymentMethod {
    return Intl.message(
      'Payment Method',
      name: 'paymentMethod',
      desc: '',
      args: [],
    );
  }

  /// `Add Address`
  String get addAddress {
    return Intl.message('Add Address', name: 'addAddress', desc: '', args: []);
  }

  /// `Item Details`
  String get itemDetails {
    return Intl.message(
      'Item Details',
      name: 'itemDetails',
      desc: '',
      args: [],
    );
  }

  /// `Order Details`
  String get orderDetails {
    return Intl.message(
      'Order Details',
      name: 'orderDetails',
      desc: '',
      args: [],
    );
  }

  /// `Continue Shopping`
  String get continueShopping {
    return Intl.message(
      'Continue Shopping',
      name: 'continueShopping',
      desc: '',
      args: [],
    );
  }

  /// `Your Order Has Been Placed Successfully Processed And Is On Its Way To You Soon.`
  String get yourOrderHasBeenPlacedSuccessfullyProcessedAndIsOnItsWayToYouSoon {
    return Intl.message(
      'Your Order Has Been Placed Successfully Processed And Is On Its Way To You Soon.',
      name: 'yourOrderHasBeenPlacedSuccessfullyProcessedAndIsOnItsWayToYouSoon',
      desc: '',
      args: [],
    );
  }

  /// `Don't Have An Account ?`
  String get dontHaveAnAccount {
    return Intl.message(
      'Don\'t Have An Account ?',
      name: 'dontHaveAnAccount',
      desc: '',
      args: [],
    );
  }

  /// `Sign In To E-Shop`
  String get signInToEShop {
    return Intl.message(
      'Sign In To E-Shop',
      name: 'signInToEShop',
      desc: '',
      args: [],
    );
  }

  /// ` Forget Password?`
  String get forgetPassword {
    return Intl.message(
      ' Forget Password?',
      name: 'forgetPassword',
      desc: '',
      args: [],
    );
  }

  /// `E-ShOp`
  String get eShop {
    return Intl.message('E-ShOp', name: 'eShop', desc: '', args: []);
  }

  /// `Old`
  String get old {
    return Intl.message('Old', name: 'old', desc: '', args: []);
  }

  /// `Current`
  String get currentt {
    return Intl.message('Current', name: 'currentt', desc: '', args: []);
  }

  /// `Order Placed!`
  String get orderPlaced {
    return Intl.message(
      'Order Placed!',
      name: 'orderPlaced',
      desc: '',
      args: [],
    );
  }

  /// `My Order Details`
  String get myOrderDetails {
    return Intl.message(
      'My Order Details',
      name: 'myOrderDetails',
      desc: '',
      args: [],
    );
  }

  /// `Cash On Delivery`
  String get cashOnDelivery {
    return Intl.message(
      'Cash On Delivery',
      name: 'cashOnDelivery',
      desc: '',
      args: [],
    );
  }

  /// `Online Payment`
  String get onlinePayment {
    return Intl.message(
      'Online Payment',
      name: 'onlinePayment',
      desc: '',
      args: [],
    );
  }

  /// `Quantity: `
  String get quantity {
    return Intl.message('Quantity: ', name: 'quantity', desc: '', args: []);
  }

  /// `Payment Summary`
  String get paymentSummary {
    return Intl.message(
      'Payment Summary',
      name: 'paymentSummary',
      desc: '',
      args: [],
    );
  }

  /// `Cost: `
  String get cost {
    return Intl.message('Cost: ', name: 'cost', desc: '', args: []);
  }

  /// `VAT: `
  String get vat {
    return Intl.message('VAT: ', name: 'vat', desc: '', args: []);
  }

  /// `Cancel Order`
  String get cancelOrder {
    return Intl.message(
      'Cancel Order',
      name: 'cancelOrder',
      desc: '',
      args: [],
    );
  }

  /// `Delivery Address `
  String get deliveryAddress {
    return Intl.message(
      'Delivery Address ',
      name: 'deliveryAddress',
      desc: '',
      args: [],
    );
  }

  /// `Shipment Details`
  String get shipmentDetails {
    return Intl.message(
      'Shipment Details',
      name: 'shipmentDetails',
      desc: '',
      args: [],
    );
  }

  /// `Products You Might Like`
  String get productsYouMightLike {
    return Intl.message(
      'Products You Might Like',
      name: 'productsYouMightLike',
      desc: '',
      args: [],
    );
  }

  /// `No Orders Found`
  String get noOrdersFound {
    return Intl.message(
      'No Orders Found',
      name: 'noOrdersFound',
      desc: '',
      args: [],
    );
  }

  /// `Chats`
  String get chats {
    return Intl.message('Chats', name: 'chats', desc: '', args: []);
  }

  /// `Sign In With Google`
  String get signInWithGoogle {
    return Intl.message(
      'Sign In With Google',
      name: 'signInWithGoogle',
      desc: '',
      args: [],
    );
  }

  /// `Sign In With Facebook`
  String get signInWithFacebook {
    return Intl.message(
      'Sign In With Facebook',
      name: 'signInWithFacebook',
      desc: '',
      args: [],
    );
  }

  /// `Order`
  String get order {
    return Intl.message('Order', name: 'order', desc: '', args: []);
  }

  /// `Your Balance`
  String get yourBalance {
    return Intl.message(
      'Your Balance',
      name: 'yourBalance',
      desc: '',
      args: [],
    );
  }

  /// `Add More`
  String get addMore {
    return Intl.message('Add More', name: 'addMore', desc: '', args: []);
  }

  /// `Recent Rides`
  String get recentRides {
    return Intl.message(
      'Recent Rides',
      name: 'recentRides',
      desc: '',
      args: [],
    );
  }

  /// `No Rides Found`
  String get noRidesFound {
    return Intl.message(
      'No Rides Found',
      name: 'noRidesFound',
      desc: '',
      args: [],
    );
  }

  /// `Ride`
  String get ride {
    return Intl.message('Ride', name: 'ride', desc: '', args: []);
  }

  /// `Ride Details`
  String get rideDetails {
    return Intl.message(
      'Ride Details',
      name: 'rideDetails',
      desc: '',
      args: [],
    );
  }

  /// `Ride Summary`
  String get rideSummary {
    return Intl.message(
      'Ride Summary',
      name: 'rideSummary',
      desc: '',
      args: [],
    );
  }

  /// `Open Map`
  String get openMap {
    return Intl.message('Open Map', name: 'openMap', desc: '', args: []);
  }

  /// `Where To ?`
  String get whereTo {
    return Intl.message('Where To ?', name: 'whereTo', desc: '', args: []);
  }

  /// `Ride Date`
  String get rideDate {
    return Intl.message('Ride Date', name: 'rideDate', desc: '', args: []);
  }

  /// `Ride Time`
  String get rideTime {
    return Intl.message('Ride Time', name: 'rideTime', desc: '', args: []);
  }

  /// `Ride Type`
  String get rideType {
    return Intl.message('Ride Type', name: 'rideType', desc: '', args: []);
  }

  /// `Ride Distance`
  String get rideDistance {
    return Intl.message(
      'Ride Distance',
      name: 'rideDistance',
      desc: '',
      args: [],
    );
  }

  /// `From Where?`
  String get fromWhere {
    return Intl.message('From Where?', name: 'fromWhere', desc: '', args: []);
  }

  /// `Passenger`
  String get passenger {
    return Intl.message('Passenger', name: 'passenger', desc: '', args: []);
  }

  /// `Driver`
  String get driver {
    return Intl.message('Driver', name: 'driver', desc: '', args: []);
  }

  /// `Passenger Mode`
  String get passengerMode {
    return Intl.message(
      'Passenger Mode',
      name: 'passengerMode',
      desc: '',
      args: [],
    );
  }

  /// `Driver Mode`
  String get driverMode {
    return Intl.message('Driver Mode', name: 'driverMode', desc: '', args: []);
  }

  /// `Get Income With Us`
  String get getIncomeWithUs {
    return Intl.message(
      'Get Income With Us',
      name: 'getIncomeWithUs',
      desc: '',
      args: [],
    );
  }

  /// `Flexible Hours`
  String get flexibleHours {
    return Intl.message(
      'Flexible Hours',
      name: 'flexibleHours',
      desc: '',
      args: [],
    );
  }

  /// `Your Prices`
  String get yourPrices {
    return Intl.message('Your Prices', name: 'yourPrices', desc: '', args: []);
  }

  /// `Low Service Payments`
  String get lowServicePayments {
    return Intl.message(
      'Low Service Payments',
      name: 'lowServicePayments',
      desc: '',
      args: [],
    );
  }

  /// `Go To Passenger Mode`
  String get goToPassengerMode {
    return Intl.message(
      'Go To Passenger Mode',
      name: 'goToPassengerMode',
      desc: '',
      args: [],
    );
  }

  /// `Driver Registration`
  String get driverRegistration {
    return Intl.message(
      'Driver Registration',
      name: 'driverRegistration',
      desc: '',
      args: [],
    );
  }

  /// `Close`
  String get close {
    return Intl.message('Close', name: 'close', desc: '', args: []);
  }

  /// `Personal Information`
  String get personalInformation {
    return Intl.message(
      'Personal Information',
      name: 'personalInformation',
      desc: '',
      args: [],
    );
  }

  /// `Pick Your Personal Picture`
  String get pickYourPersonalPicture {
    return Intl.message(
      'Pick Your Personal Picture',
      name: 'pickYourPersonalPicture',
      desc: '',
      args: [],
    );
  }

  /// `First Name`
  String get firstName {
    return Intl.message('First Name', name: 'firstName', desc: '', args: []);
  }

  /// `Last Name`
  String get lastName {
    return Intl.message('Last Name', name: 'lastName', desc: '', args: []);
  }

  /// `Date Of Birth`
  String get dateOfBirth {
    return Intl.message(
      'Date Of Birth',
      name: 'dateOfBirth',
      desc: '',
      args: [],
    );
  }

  /// `Enter Your First Name`
  String get enterYourFirstName {
    return Intl.message(
      'Enter Your First Name',
      name: 'enterYourFirstName',
      desc: '',
      args: [],
    );
  }

  /// `Enter Your Last Name`
  String get enterYourLastName {
    return Intl.message(
      'Enter Your Last Name',
      name: 'enterYourLastName',
      desc: '',
      args: [],
    );
  }

  /// `Enter Your Date Of Birth`
  String get enterYourDateOfBirth {
    return Intl.message(
      'Enter Your Date Of Birth',
      name: 'enterYourDateOfBirth',
      desc: '',
      args: [],
    );
  }

  /// `Enter Your Personal Image`
  String get enterYourPersonalImage {
    return Intl.message(
      'Enter Your Personal Image',
      name: 'enterYourPersonalImage',
      desc: '',
      args: [],
    );
  }

  /// `Licence Number`
  String get licenceNumber {
    return Intl.message(
      'Licence Number',
      name: 'licenceNumber',
      desc: '',
      args: [],
    );
  }

  /// `Expiry Date`
  String get expiryDate {
    return Intl.message('Expiry Date', name: 'expiryDate', desc: '', args: []);
  }

  /// `Driver Licence`
  String get driverLicence {
    return Intl.message(
      'Driver Licence',
      name: 'driverLicence',
      desc: '',
      args: [],
    );
  }

  /// `Back Side Of Licence`
  String get backSideOfLicence {
    return Intl.message(
      'Back Side Of Licence',
      name: 'backSideOfLicence',
      desc: '',
      args: [],
    );
  }

  /// `Selfie With Licence`
  String get selfieWithLicence {
    return Intl.message(
      'Selfie With Licence',
      name: 'selfieWithLicence',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get next {
    return Intl.message('Next', name: 'next', desc: '', args: []);
  }

  /// `ID Number`
  String get idNumber {
    return Intl.message('ID Number', name: 'idNumber', desc: '', args: []);
  }

  /// `National ID`
  String get nationalId {
    return Intl.message('National ID', name: 'nationalId', desc: '', args: []);
  }

  /// `Back Side Of ID`
  String get backSideOfId {
    return Intl.message(
      'Back Side Of ID',
      name: 'backSideOfId',
      desc: '',
      args: [],
    );
  }

  /// `Criminal Status`
  String get criminalStatus {
    return Intl.message(
      'Criminal Status',
      name: 'criminalStatus',
      desc: '',
      args: [],
    );
  }

  /// `Personal Documents`
  String get personalDocuments {
    return Intl.message(
      'Personal Documents',
      name: 'personalDocuments',
      desc: '',
      args: [],
    );
  }

  /// `Vehicle Information`
  String get vehicleInformation {
    return Intl.message(
      'Vehicle Information',
      name: 'vehicleInformation',
      desc: '',
      args: [],
    );
  }

  /// `Vehicle Picture`
  String get vehiclePicture {
    return Intl.message(
      'Vehicle Picture',
      name: 'vehiclePicture',
      desc: '',
      args: [],
    );
  }

  /// `Vehicle Registration Certificate`
  String get vehicleRegistrationCertificate {
    return Intl.message(
      'Vehicle Registration Certificate',
      name: 'vehicleRegistrationCertificate',
      desc: '',
      args: [],
    );
  }

  /// `Back Side Of Certificate`
  String get backSideOfCertificate {
    return Intl.message(
      'Back Side Of Certificate',
      name: 'backSideOfCertificate',
      desc: '',
      args: [],
    );
  }

  /// `Vehicle Brand`
  String get vehicleBrand {
    return Intl.message(
      'Vehicle Brand',
      name: 'vehicleBrand',
      desc: '',
      args: [],
    );
  }

  /// `Vehicle Model`
  String get vehicleModel {
    return Intl.message(
      'Vehicle Model',
      name: 'vehicleModel',
      desc: '',
      args: [],
    );
  }

  /// `Vehicle Color`
  String get vehicleColor {
    return Intl.message(
      'Vehicle Color',
      name: 'vehicleColor',
      desc: '',
      args: [],
    );
  }

  /// `Production Year`
  String get productionYear {
    return Intl.message(
      'Production Year',
      name: 'productionYear',
      desc: '',
      args: [],
    );
  }

  /// `Vehicle Plate Number`
  String get vehiclePlateNumber {
    return Intl.message(
      'Vehicle Plate Number',
      name: 'vehiclePlateNumber',
      desc: '',
      args: [],
    );
  }

  /// `Enter Your Vehicle Picture`
  String get enterYourVehiclePicture {
    return Intl.message(
      'Enter Your Vehicle Picture',
      name: 'enterYourVehiclePicture',
      desc: '',
      args: [],
    );
  }

  /// `Enter Your Vehicle Registration Certificate`
  String get enterYourVehicleRegistrationCertificate {
    return Intl.message(
      'Enter Your Vehicle Registration Certificate',
      name: 'enterYourVehicleRegistrationCertificate',
      desc: '',
      args: [],
    );
  }

  /// `Enter Your Back Side Of Certificate`
  String get enterYourBackSideOfCertificate {
    return Intl.message(
      'Enter Your Back Side Of Certificate',
      name: 'enterYourBackSideOfCertificate',
      desc: '',
      args: [],
    );
  }

  /// `Enter Your Vehicle Brand`
  String get enterYourVehicleBrand {
    return Intl.message(
      'Enter Your Vehicle Brand',
      name: 'enterYourVehicleBrand',
      desc: '',
      args: [],
    );
  }

  /// `Enter Your Vehicle Model`
  String get enterYourVehicleModel {
    return Intl.message(
      'Enter Your Vehicle Model',
      name: 'enterYourVehicleModel',
      desc: '',
      args: [],
    );
  }

  /// `Enter Your Vehicle Color`
  String get enterYourVehicleColor {
    return Intl.message(
      'Enter Your Vehicle Color',
      name: 'enterYourVehicleColor',
      desc: '',
      args: [],
    );
  }

  /// `Enter Your Production Year`
  String get enterYourProductionYear {
    return Intl.message(
      'Enter Your Production Year',
      name: 'enterYourProductionYear',
      desc: '',
      args: [],
    );
  }

  /// `Enter Your Vehicle Plate Number`
  String get enterYourVehiclePlateNumber {
    return Intl.message(
      'Enter Your Vehicle Plate Number',
      name: 'enterYourVehiclePlateNumber',
      desc: '',
      args: [],
    );
  }

  /// `Add Profile Picture`
  String get addProfilePicture {
    return Intl.message(
      'Add Profile Picture',
      name: 'addProfilePicture',
      desc: '',
      args: [],
    );
  }

  /// `Start Typing`
  String get startTyping {
    return Intl.message(
      'Start Typing',
      name: 'startTyping',
      desc: '',
      args: [],
    );
  }

  /// `The Cost Of The Order Will Be`
  String get theCostOfTheOrderWillBe {
    return Intl.message(
      'The Cost Of The Order Will Be',
      name: 'theCostOfTheOrderWillBe',
      desc: '',
      args: [],
    );
  }

  /// `Recommended Fare`
  String get recommendedFare {
    return Intl.message(
      'Recommended Fare',
      name: 'recommendedFare',
      desc: '',
      args: [],
    );
  }

  /// `Cash`
  String get cash {
    return Intl.message('Cash', name: 'cash', desc: '', args: []);
  }

  /// `Card`
  String get card {
    return Intl.message('Card', name: 'card', desc: '', args: []);
  }

  /// `Comment`
  String get comment {
    return Intl.message('Comment', name: 'comment', desc: '', args: []);
  }

  /// `More Than 4 Passengers`
  String get moreThan4Passengers {
    return Intl.message(
      'More Than 4 Passengers',
      name: 'moreThan4Passengers',
      desc: '',
      args: [],
    );
  }

  /// `Apply`
  String get apply {
    return Intl.message('Apply', name: 'apply', desc: '', args: []);
  }

  /// `App Theme`
  String get appTheme {
    return Intl.message('App Theme', name: 'appTheme', desc: '', args: []);
  }

  /// `Dark`
  String get dark {
    return Intl.message('Dark', name: 'dark', desc: '', args: []);
  }

  /// `Light`
  String get light {
    return Intl.message('Light', name: 'light', desc: '', args: []);
  }

  /// `Language`
  String get language {
    return Intl.message('Language', name: 'language', desc: '', args: []);
  }

  /// `Options`
  String get options {
    return Intl.message('Options', name: 'options', desc: '', args: []);
  }

  /// `System Default`
  String get systemDefault {
    return Intl.message(
      'System Default',
      name: 'systemDefault',
      desc: '',
      args: [],
    );
  }

  /// `Contact Driver`
  String get contactDriver {
    return Intl.message(
      'Contact Driver',
      name: 'contactDriver',
      desc: '',
      args: [],
    );
  }

  /// `Contact Passenger`
  String get contactPassenger {
    return Intl.message(
      'Contact Passenger',
      name: 'contactPassenger',
      desc: '',
      args: [],
    );
  }

  /// `Audio Call`
  String get audioCall {
    return Intl.message('Audio Call', name: 'audioCall', desc: '', args: []);
  }

  /// `Regular Call`
  String get regularCall {
    return Intl.message(
      'Regular Call',
      name: 'regularCall',
      desc: '',
      args: [],
    );
  }

  /// `Your Recent Rides`
  String get yourRecentRides {
    return Intl.message(
      'Your Recent Rides',
      name: 'yourRecentRides',
      desc: '',
      args: [],
    );
  }

  /// `Choose On Map`
  String get chooseOnMap {
    return Intl.message(
      'Choose On Map',
      name: 'chooseOnMap',
      desc: '',
      args: [],
    );
  }

  /// `Enter Your Route`
  String get enterYourRoute {
    return Intl.message(
      'Enter Your Route',
      name: 'enterYourRoute',
      desc: '',
      args: [],
    );
  }

  /// `Finish`
  String get finish {
    return Intl.message('Finish', name: 'finish', desc: '', args: []);
  }

  /// `Registration Successful`
  String get registrationSuccessful {
    return Intl.message(
      'Registration Successful',
      name: 'registrationSuccessful',
      desc: '',
      args: [],
    );
  }

  /// `Registration Failed`
  String get registrationFailed {
    return Intl.message(
      'Registration Failed',
      name: 'registrationFailed',
      desc: '',
      args: [],
    );
  }

  /// `Enter text`
  String get hintText {
    return Intl.message('Enter text', name: 'hintText', desc: '', args: []);
  }

  /// `Please enter your date of birth`
  String get pleaseEnterDate {
    return Intl.message(
      'Please enter your date of birth',
      name: 'pleaseEnterDate',
      desc: '',
      args: [],
    );
  }

  /// `Date format must be DD/MM/YYYY`
  String get invalidDateFormat {
    return Intl.message(
      'Date format must be DD/MM/YYYY',
      name: 'invalidDateFormat',
      desc: '',
      args: [],
    );
  }

  /// `Invalid date`
  String get invalidDate {
    return Intl.message(
      'Invalid date',
      name: 'invalidDate',
      desc: '',
      args: [],
    );
  }

  /// `Day must be between 01 and 31`
  String get invalidDay {
    return Intl.message(
      'Day must be between 01 and 31',
      name: 'invalidDay',
      desc: '',
      args: [],
    );
  }

  /// `Month must be between 01 and 12`
  String get invalidMonth {
    return Intl.message(
      'Month must be between 01 and 12',
      name: 'invalidMonth',
      desc: '',
      args: [],
    );
  }

  /// `Year must be between 1950 and current year`
  String get invalidYear {
    return Intl.message(
      'Year must be between 1950 and current year',
      name: 'invalidYear',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your license number`
  String get pleaseEnterLicense {
    return Intl.message(
      'Please enter your license number',
      name: 'pleaseEnterLicense',
      desc: '',
      args: [],
    );
  }

  /// `License number must be 14 characters long`
  String get invalidLicenseLength {
    return Intl.message(
      'License number must be 14 characters long',
      name: 'invalidLicenseLength',
      desc: '',
      args: [],
    );
  }

  /// `License number should start with a letter`
  String get invalidLicenseStart {
    return Intl.message(
      'License number should start with a letter',
      name: 'invalidLicenseStart',
      desc: '',
      args: [],
    );
  }

  /// `License number should have 13 digits following the first letter`
  String get invalidLicenseDigits {
    return Intl.message(
      'License number should have 13 digits following the first letter',
      name: 'invalidLicenseDigits',
      desc: '',
      args: [],
    );
  }

  /// `Year in license number is not valid`
  String get invalidLicenseYear {
    return Intl.message(
      'Year in license number is not valid',
      name: 'invalidLicenseYear',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your National ID`
  String get pleaseEnterNationalId {
    return Intl.message(
      'Please enter your National ID',
      name: 'pleaseEnterNationalId',
      desc: '',
      args: [],
    );
  }

  /// `National ID must be 14 digits long`
  String get invalidNationalIdLength {
    return Intl.message(
      'National ID must be 14 digits long',
      name: 'invalidNationalIdLength',
      desc: '',
      args: [],
    );
  }

  /// `National ID must contain only digits`
  String get invalidNationalIdDigits {
    return Intl.message(
      'National ID must contain only digits',
      name: 'invalidNationalIdDigits',
      desc: '',
      args: [],
    );
  }

  /// `Invalid National ID checksum`
  String get invalidNationalIdChecksum {
    return Intl.message(
      'Invalid National ID checksum',
      name: 'invalidNationalIdChecksum',
      desc: '',
      args: [],
    );
  }

  /// `Invalid birth month`
  String get invalidBirthMonth {
    return Intl.message(
      'Invalid birth month',
      name: 'invalidBirthMonth',
      desc: '',
      args: [],
    );
  }

  /// `Birth date cannot be in the future`
  String get invalidBirthDateFuture {
    return Intl.message(
      'Birth date cannot be in the future',
      name: 'invalidBirthDateFuture',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the expiry date`
  String get pleaseEnterExpiryDate {
    return Intl.message(
      'Please enter the expiry date',
      name: 'pleaseEnterExpiryDate',
      desc: '',
      args: [],
    );
  }

  /// `Date format must be DD/MM/YYYY`
  String get invalidExpiryDateFormat {
    return Intl.message(
      'Date format must be DD/MM/YYYY',
      name: 'invalidExpiryDateFormat',
      desc: '',
      args: [],
    );
  }

  /// `Expiry date cannot be in the past`
  String get expiryDateInPast {
    return Intl.message(
      'Expiry date cannot be in the past',
      name: 'expiryDateInPast',
      desc: '',
      args: [],
    );
  }

  /// `Invalid expiry date`
  String get invalidExpiryDate {
    return Intl.message(
      'Invalid expiry date',
      name: 'invalidExpiryDate',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a vehicle plate number`
  String get pleaseEnterPlateNumber {
    return Intl.message(
      'Please enter a vehicle plate number',
      name: 'pleaseEnterPlateNumber',
      desc: '',
      args: [],
    );
  }

  /// `Invalid plate number format. Example: C12345 or A1234E`
  String get invalidPlateFormat {
    return Intl.message(
      'Invalid plate number format. Example: C12345 or A1234E',
      name: 'invalidPlateFormat',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your license number`
  String get pleaseEnterLicenseNumber {
    return Intl.message(
      'Please enter your license number',
      name: 'pleaseEnterLicenseNumber',
      desc: '',
      args: [],
    );
  }

  /// `License number must be 14 characters long`
  String get licenseNumberMustBe14Characters {
    return Intl.message(
      'License number must be 14 characters long',
      name: 'licenseNumberMustBe14Characters',
      desc: '',
      args: [],
    );
  }

  /// `License number should start with a letter`
  String get licenseNumberMustStartWithLetter {
    return Intl.message(
      'License number should start with a letter',
      name: 'licenseNumberMustStartWithLetter',
      desc: '',
      args: [],
    );
  }

  /// `License number should have 13 digits following the first letter`
  String get licenseNumberMustHave13Digits {
    return Intl.message(
      'License number should have 13 digits following the first letter',
      name: 'licenseNumberMustHave13Digits',
      desc: '',
      args: [],
    );
  }

  /// `National ID must be 14 digits long`
  String get nationalIdMustBe14Digits {
    return Intl.message(
      'National ID must be 14 digits long',
      name: 'nationalIdMustBe14Digits',
      desc: '',
      args: [],
    );
  }

  /// `National ID must contain only digits`
  String get nationalIdMustContainOnlyDigits {
    return Intl.message(
      'National ID must contain only digits',
      name: 'nationalIdMustContainOnlyDigits',
      desc: '',
      args: [],
    );
  }

  /// `Birth date cannot be in the future`
  String get birthDateCannotBeInFuture {
    return Intl.message(
      'Birth date cannot be in the future',
      name: 'birthDateCannotBeInFuture',
      desc: '',
      args: [],
    );
  }

  /// `Date format must be DD/MM/YYYY`
  String get dateFormatMustBeDDMMYYYY {
    return Intl.message(
      'Date format must be DD/MM/YYYY',
      name: 'dateFormatMustBeDDMMYYYY',
      desc: '',
      args: [],
    );
  }

  /// `Day must be between 01 and 31`
  String get dayMustBeBetween01And31 {
    return Intl.message(
      'Day must be between 01 and 31',
      name: 'dayMustBeBetween01And31',
      desc: '',
      args: [],
    );
  }

  /// `Month must be between 01 and 12`
  String get monthMustBeBetween01And12 {
    return Intl.message(
      'Month must be between 01 and 12',
      name: 'monthMustBeBetween01And12',
      desc: '',
      args: [],
    );
  }

  /// `Year must be within the next 10 years`
  String get yearMustBeWithinNext10Years {
    return Intl.message(
      'Year must be within the next 10 years',
      name: 'yearMustBeWithinNext10Years',
      desc: '',
      args: [],
    );
  }

  /// `Expiry date cannot be in the past`
  String get expiryDateCannotBeInPast {
    return Intl.message(
      'Expiry date cannot be in the past',
      name: 'expiryDateCannotBeInPast',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a vehicle plate number`
  String get pleaseEnterVehiclePlateNumber {
    return Intl.message(
      'Please enter a vehicle plate number',
      name: 'pleaseEnterVehiclePlateNumber',
      desc: '',
      args: [],
    );
  }

  /// `Invalid plate number format. Example: C12345 or A1234E`
  String get invalidPlateNumberFormat {
    return Intl.message(
      'Invalid plate number format. Example: C12345 or A1234E',
      name: 'invalidPlateNumberFormat',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your first name`
  String get pleaseEnterYourFirstName {
    return Intl.message(
      'Please enter your first name',
      name: 'pleaseEnterYourFirstName',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your last name`
  String get pleaseEnterYourLastName {
    return Intl.message(
      'Please enter your last name',
      name: 'pleaseEnterYourLastName',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your date of birth`
  String get pleaseEnterYourDateOfBirth {
    return Intl.message(
      'Please enter your date of birth',
      name: 'pleaseEnterYourDateOfBirth',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your personal image`
  String get pleaseEnterYourPersonalImage {
    return Intl.message(
      'Please enter your personal image',
      name: 'pleaseEnterYourPersonalImage',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your vehicle picture`
  String get pleaseEnterYourVehiclePicture {
    return Intl.message(
      'Please enter your vehicle picture',
      name: 'pleaseEnterYourVehiclePicture',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your vehicle registration certificate`
  String get pleaseEnterYourVehicleRegistrationCertificate {
    return Intl.message(
      'Please enter your vehicle registration certificate',
      name: 'pleaseEnterYourVehicleRegistrationCertificate',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your back side of certificate`
  String get pleaseEnterYourBackSideOfCertificate {
    return Intl.message(
      'Please enter your back side of certificate',
      name: 'pleaseEnterYourBackSideOfCertificate',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your vehicle brand`
  String get pleaseEnterYourVehicleBrand {
    return Intl.message(
      'Please enter your vehicle brand',
      name: 'pleaseEnterYourVehicleBrand',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your vehicle model`
  String get pleaseEnterYourVehicleModel {
    return Intl.message(
      'Please enter your vehicle model',
      name: 'pleaseEnterYourVehicleModel',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your vehicle color`
  String get pleaseEnterYourVehicleColor {
    return Intl.message(
      'Please enter your vehicle color',
      name: 'pleaseEnterYourVehicleColor',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your production year`
  String get pleaseEnterYourProductionYear {
    return Intl.message(
      'Please enter your production year',
      name: 'pleaseEnterYourProductionYear',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your vehicle plate number`
  String get pleaseEnterYourVehiclePlateNumber {
    return Intl.message(
      'Please enter your vehicle plate number',
      name: 'pleaseEnterYourVehiclePlateNumber',
      desc: '',
      args: [],
    );
  }

  /// `Select Brand`
  String get selectBrand {
    return Intl.message(
      'Select Brand',
      name: 'selectBrand',
      desc: '',
      args: [],
    );
  }

  /// `Select Model`
  String get selectModel {
    return Intl.message(
      'Select Model',
      name: 'selectModel',
      desc: '',
      args: [],
    );
  }

  /// `Select Color`
  String get selectColor {
    return Intl.message(
      'Select Color',
      name: 'selectColor',
      desc: '',
      args: [],
    );
  }

  /// `This field is required`
  String get requiredField {
    return Intl.message(
      'This field is required',
      name: 'requiredField',
      desc: '',
      args: [],
    );
  }

  /// `Passenger Requests`
  String get passengerRequests {
    return Intl.message(
      'Passenger Requests',
      name: 'passengerRequests',
      desc: '',
      args: [],
    );
  }

  /// `Decline`
  String get decline {
    return Intl.message('Decline', name: 'decline', desc: '', args: []);
  }

  /// `Accept`
  String get accept {
    return Intl.message('Accept', name: 'accept', desc: '', args: []);
  }

  /// `Your Request Has Been Sent Successfully`
  String get YourRequestHasBeenSentSuccessfully {
    return Intl.message(
      'Your Request Has Been Sent Successfully',
      name: 'YourRequestHasBeenSentSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `We Will Contact You Soon`
  String get WeWillContactYouSoon {
    return Intl.message(
      'We Will Contact You Soon',
      name: 'WeWillContactYouSoon',
      desc: '',
      args: [],
    );
  }

  /// `OK`
  String get ok {
    return Intl.message('OK', name: 'ok', desc: '', args: []);
  }

  /// `Ride Description`
  String get rideDescription {
    return Intl.message(
      'Ride Description',
      name: 'rideDescription',
      desc: '',
      args: [],
    );
  }

  /// `Camera`
  String get camera {
    return Intl.message('Camera', name: 'camera', desc: '', args: []);
  }

  /// `Gallery`
  String get gallery {
    return Intl.message('Gallery', name: 'gallery', desc: '', args: []);
  }

  /// `Pick Image`
  String get pickImage {
    return Intl.message('Pick Image', name: 'pickImage', desc: '', args: []);
  }

  /// `Missing Phone Number`
  String get missingPhoneNumber {
    return Intl.message(
      'Missing Phone Number',
      name: 'missingPhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Choose Call Type`
  String get chooseCallType {
    return Intl.message(
      'Choose Call Type',
      name: 'chooseCallType',
      desc: '',
      args: [],
    );
  }

  /// `Theme`
  String get theme {
    return Intl.message('Theme', name: 'theme', desc: '', args: []);
  }

  /// `Please complete your registration or wait for approval.`
  String get pleaseCompleteYourRegistration {
    return Intl.message(
      'Please complete your registration or wait for approval.',
      name: 'pleaseCompleteYourRegistration',
      desc: '',
      args: [],
    );
  }

  /// `You are not eligible to access driver mode.`
  String get youAreNotEligible {
    return Intl.message(
      'You are not eligible to access driver mode.',
      name: 'youAreNotEligible',
      desc: '',
      args: [],
    );
  }

  /// `Access Denied`
  String get accessDenied {
    return Intl.message(
      'Access Denied',
      name: 'accessDenied',
      desc: '',
      args: [],
    );
  }

  /// `Help`
  String get help {
    return Intl.message('Help', name: 'help', desc: '', args: []);
  }

  /// `Notifications`
  String get notifications {
    return Intl.message(
      'Notifications',
      name: 'notifications',
      desc: '',
      args: [],
    );
  }

  /// `Privacy Policy`
  String get privacyPolicy {
    return Intl.message(
      'Privacy Policy',
      name: 'privacyPolicy',
      desc: '',
      args: [],
    );
  }

  /// `My Trips`
  String get myTrips {
    return Intl.message('My Trips', name: 'myTrips', desc: '', args: []);
  }

  /// `Wallet`
  String get wallet {
    return Intl.message('Wallet', name: 'wallet', desc: '', args: []);
  }

  /// `Payment`
  String get payment {
    return Intl.message('Payment', name: 'payment', desc: '', args: []);
  }

  /// `Charge Wallet`
  String get chargeWallet {
    return Intl.message(
      'Charge Wallet',
      name: 'chargeWallet',
      desc: '',
      args: [],
    );
  }

  /// `Pay`
  String get pay {
    return Intl.message('Pay', name: 'pay', desc: '', args: []);
  }

  /// `Last Updated`
  String get lastUpdated {
    return Intl.message(
      'Last Updated',
      name: 'lastUpdated',
      desc: '',
      args: [],
    );
  }

  /// `Estimated Time`
  String get estimatedTime {
    return Intl.message(
      'Estimated Time',
      name: 'estimatedTime',
      desc: '',
      args: [],
    );
  }

  /// `No Trip Requests Available`
  String get noTripRequestsAvailable {
    return Intl.message(
      'No Trip Requests Available',
      name: 'noTripRequestsAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Get Started`
  String get getStarted {
    return Intl.message('Get Started', name: 'getStarted', desc: '', args: []);
  }

  /// `No Notifications Found`
  String get noNotificationsFound {
    return Intl.message(
      'No Notifications Found',
      name: 'noNotificationsFound',
      desc: '',
      args: [],
    );
  }

  /// `Trip Completed`
  String get tripCompleted {
    return Intl.message(
      'Trip Completed',
      name: 'tripCompleted',
      desc: '',
      args: [],
    );
  }

  /// `Submit`
  String get submit {
    return Intl.message('Submit', name: 'submit', desc: '', args: []);
  }

  /// `Please Select Rating`
  String get pleaseSelectRating {
    return Intl.message(
      'Please Select Rating',
      name: 'pleaseSelectRating',
      desc: '',
      args: [],
    );
  }

  /// `Thank you for rating`
  String get thankYouForRating {
    return Intl.message(
      'Thank you for rating',
      name: 'thankYouForRating',
      desc: '',
      args: [],
    );
  }

  /// `Leave Comment`
  String get leaveComment {
    return Intl.message(
      'Leave Comment',
      name: 'leaveComment',
      desc: '',
      args: [],
    );
  }

  /// `Rate your driver`
  String get rateYourDriver {
    return Intl.message(
      'Rate your driver',
      name: 'rateYourDriver',
      desc: '',
      args: [],
    );
  }

  /// `Waiting for driver`
  String get waitingForDriver {
    return Intl.message(
      'Waiting for driver',
      name: 'waitingForDriver',
      desc: '',
      args: [],
    );
  }

  /// `Your Current Trip`
  String get yourCurrentTrip {
    return Intl.message(
      'Your Current Trip',
      name: 'yourCurrentTrip',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
