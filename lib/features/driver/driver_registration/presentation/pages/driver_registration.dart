import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_now/core/theming/app_colors.dart';
import 'package:ride_now/core/utils/app_button.dart';
import '../../../../../core/di/di.dart';
import '../../../../../core/helpers/spacing.dart';
import '../../../../../core/services/routing/routing_endpoints.dart';
import '../../../../../core/theming/styles.dart';
import '../../../../../generated/l10n.dart';
import '../manager/driver_registration_cubit.dart';
import '../widgets/drive_licence.dart';
import '../widgets/personal_document.dart';
import '../widgets/personal_information.dart';
import '../widgets/vehicle_information.dart';

class DriverRegistration extends StatefulWidget {
  const DriverRegistration({super.key});

  @override
  State<DriverRegistration> createState() => _DriverRegistration();
}

class _DriverRegistration extends State<DriverRegistration>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;

  final List<GlobalKey<FormState>> _formKeys = List.generate(
    4,
    (index) => GlobalKey<FormState>(),
  );

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  void _animateProgress(int nextPage) {
    final progressValue = (nextPage + 1) / onboardingData.length;
    _progressAnimation =
        Tween<double>(begin: _progressAnimation.value, end: progressValue)
            .animate(CurvedAnimation(
                parent: _animationController, curve: Curves.easeInOut));
    _animationController.forward(from: 0);
  }

  final List<Map<String, String>> onboardingData = [
    {"title": S().personalInformation},
    {"title": S().driverLicence},
    {"title": S().personalDocuments},
    {"title": S().vehicleInformation},
  ];

  final driverCubit = DriverRegistrationCubit(
    fetchBrandsUseCase: sl(),
    fetchColorsUseCase: sl(),
    fetchModelsUseCase: sl(),
    submitDriverRegistrationUseCase: sl(),
  );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => driverCubit,
      child: Scaffold(
        appBar: AppBar(
          title: Text(S().driverRegistration,
              style: TextStyles.font18BlackRegular),
          leading: Container(),
          centerTitle: true,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, RoutingEndpoints.driverOnBoarding);
              },
              child: Text(S().close, style: TextStyles.font18BlackRegular),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (page) {
                  setState(() {
                    _currentPage = page;
                    _animateProgress(page);
                  });
                },
                itemCount: onboardingData.length,
                itemBuilder: (context, index) {
                  switch (index) {
                    case 0:
                      return Form(
                        key: _formKeys[0],
                        child: PersonalInformationPage(cubit: driverCubit),
                      );
                    case 1:
                      return Form(
                        key: _formKeys[1],
                        child: DriverLicensePage(cubit: driverCubit),
                      );
                    case 2:
                      return Form(
                        key: _formKeys[2],
                        child: PersonalDocumentsPage(cubit: driverCubit),
                      );
                    case 3:
                      return Form(
                        key: _formKeys[3],
                        child: VehicleInformationPage(cubit: driverCubit),
                      );
                    default:
                      return Container();
                  }
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(15.0.sp),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${_currentPage + 1} of ${onboardingData.length}",
                          style: TextStyles.font24BlackBold,
                          textDirection: TextDirection.ltr,
                        ),
                        verticalSpacing(10.h),
                        AnimatedBuilder(
                          animation: _progressAnimation,
                          builder: (context, child) {
                            return SizedBox(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: LinearProgressIndicator(
                                value: _progressAnimation.value,
                                backgroundColor:
                                    AppColors.semiGrey.withOpacity(0.2),
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(10.r),
                                minHeight: 10.h,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  if (_currentPage != 0)
                    FloatingActionButton(
                      backgroundColor: AppColors.semiGrey.withOpacity(0.2),
                      onPressed: () {
                        _pageController.previousPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeIn);
                      },
                      elevation: 0,
                      child: Icon(Icons.arrow_back_ios_new_outlined),
                    ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: AppButton(
                      backgroundColor: AppColors.primary,
                      borderRadius: 10.r,
                      width: MediaQuery.of(context).size.width * 0.3,
                      textStyle: TextStyles.font18BlackRegular,
                      text: _currentPage == onboardingData.length - 1
                          ? S().finish
                          : S().next,
                      onPressed: () async {
                        if (_formKeys[_currentPage].currentState?.validate() ??
                            false) {
                          if (_currentPage < onboardingData.length - 1) {
                            _currentPage++;
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeIn,
                            );
                          } else {
                            final success =
                                await driverCubit.submitRegistration();
                            if (success) {
                              Navigator.pushNamed(context,
                                  RoutingEndpoints.driverPendingScreen);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.green,
                                  content: Text(S().registrationSuccessful),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.red,
                                  content: Text(S().registrationFailed),
                                ),
                              );
                            }
                          }
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
