import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_now/core/theming/app_colors.dart';
import '../../../../core/components/app_bar.dart';
import '../../../../core/components/drawer_items.dart';
import '../../../../core/di/di.dart';
import '../../../../core/theming/styles.dart';
import '../../../../core/utils/app_button.dart';
import '../../../../generated/l10n.dart';
import '../../data/models/profile_model.dart';
import '../manager/profile_cubit.dart';
import '../widgets/user_forms.dart';
import '../widgets/user_image.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isChanged = false;

  final profileCubit = ProfileCubit(sl(), sl());

  void _onFieldChanged() {
    setState(() {
      isChanged = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => profileCubit..loadProfile(),
      child: Scaffold(
        backgroundColor: AppColors.semiGrey.withOpacity(0.1),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.h),
          child: DefaultAppBar(
            text: S().profile,
            withDivider: false,
            backgroundColor: Colors.white,
          ),
        ),
        drawer: DrawerItems(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              UserImage(isChanged: isChanged),
              BlocBuilder<ProfileCubit, ProfileState>(
                builder: (context, state) {
                  if (state is ProfileLoading) {
                    return Center(child: CircularProgressIndicator(
                      color: AppColors.primary
                    ));
                  } else if (state is ProfileLoaded) {
                    final profile = state.profile;
                    return Column(
                      children: [
                        Form(
                          key: profileCubit.formKey,
                          child: UserForms(
                            onFieldChanged: _onFieldChanged,
                            firstNameController: profileCubit.firstNameController,
                            lastNameController: profileCubit.lastNameController,
                            cityController: profileCubit.cityController,
                            emailController: profileCubit.emailController,
                            phoneController: profileCubit.phoneController,
                          ),
                        ),
                        Visibility(
                          visible: isChanged,
                          child: AppButton(
                            text: S().save,
                            backgroundColor: AppColors.primary,
                            onPressed: () async {
                              final firstName =
                                  profileCubit.firstNameController.text;
                              final lastName =
                                  profileCubit.lastNameController.text;
                              final city = profileCubit.cityController.text;
                              final phone = profileCubit.phoneController.text;
                              await profileCubit.saveProfile(
                                ProfileModel(
                                  name: '$firstName $lastName',
                                  email: profile.email,
                                  phoneNumber: phone,
                                  city: city,
                                  photoUrl: profile.photoUrl,
                                  uid: profile.uid,
                                ),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Profile saved successfully"),
                                  backgroundColor: AppColors.primary,
                                ),
                              );
                              setState(() {
                                isChanged = false;
                              });
                            },
                            textStyle: TextStyles.font14BlackRegular,
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Center(child: Text("No Profile Data"));
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
