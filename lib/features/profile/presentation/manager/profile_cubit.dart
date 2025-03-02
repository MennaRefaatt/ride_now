import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:ride_now/core/helpers/shared_pref.dart';

import '../../../../core/helpers/safe_print.dart';
import '../../../../core/helpers/shared_pref_keys.dart';
import '../../data/models/profile_model.dart';
import '../../domain/use_cases/get_profile_usecase.dart';
import '../../domain/use_cases/save_profile_usecase.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetProfileUseCase getProfileUseCase;
  final SaveProfileUseCase saveProfileUseCase;

  ProfileCubit(this.getProfileUseCase, this.saveProfileUseCase)
      : super(ProfileInitial());

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  String? pictureUrl;
  final formKey = GlobalKey<FormState>();

  Future<void> loadProfile() async {
    try {
      emit(ProfileLoading());
      final profile = await getProfileUseCase.execute();
      safePrint("profile loaded: ${profile.toJson()}");

      firstNameController.text = profile.name.split(' ').first;
      lastNameController.text = profile.name.split(' ').last;
      emailController.text = profile.email;
      phoneController.text = profile.phoneNumber == "missing phone number" ? "" : profile.phoneNumber;
      cityController.text = profile.city ?? '';

      // ✅ Save profile image to SharedPreferences
      if (profile.photoUrl.isNotEmpty) {
        await SharedPref.setString(key: MySharedKeys.picture, value: profile.photoUrl);
      }

      emit(ProfileLoaded(profile));
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }

  Future<void> saveProfile(ProfileModel profile, {File? imageFile}) async {
    try {
      emit(ProfileLoading());
      await saveProfileUseCase.execute(profile, imageFile: imageFile);
      safePrint("profile saved: ${profile.toJson()}");
      SharedPref.setString(key: MySharedKeys.picture, value: profile.photoUrl);
      emit(ProfileSaved());
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }
}
