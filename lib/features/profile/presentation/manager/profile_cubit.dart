import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

import '../../../../core/helpers/safe_print.dart';
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
      emit(ProfileLoaded(profile));
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }

  Future<void> saveProfile(ProfileModel profile) async {
    try {
      emit(ProfileLoading());
      await saveProfileUseCase.execute(profile);
      emit(ProfileSaved());
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }
}
