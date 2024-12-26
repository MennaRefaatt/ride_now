import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_now/core/components/app_bar.dart';
import 'package:ride_now/core/components/app_text_form_field.dart';
import 'package:ride_now/core/services/routing/routing_endpoints.dart';
import '../../../../core/di/di.dart';
import '../../../../core/helpers/spacing.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/styles.dart';
import '../../../../generated/l10n.dart';
import '../manager/city_cubit.dart';

class CityScreen extends StatefulWidget {
  const CityScreen({super.key});

  @override
  _CityScreenState createState() => _CityScreenState();
}

class _CityScreenState extends State<CityScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cityCubit = CityCubit(sl(), sl());
    return BlocProvider(
      create: (context) => cityCubit..fetchCities(""),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.h),
          child: DefaultAppBar(text: S().city),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w,),
          child: Column(
            children: [
              AppTextFormField(
                controller: _searchController,
                hintText: "S().startTyping",
                withHint: true,
                onChanged: (value) {
                  cityCubit.fetchCities(value);
                  _searchController.text = value;
                },
                isFilled: true,
                prefixIcon:
                    Icon(CupertinoIcons.search, color: AppColors.semiGrey),
                borderRadius: BorderRadius.circular(10.r),
                contentPadding: EdgeInsets.all(5.sp),
                backgroundColor: AppColors.semiGrey.withOpacity(0.2),
              ),
              verticalSpacing(20.h),
              Expanded(
                child: BlocBuilder<CityCubit, CityState>(
                  builder: (context, state) {
                    if (state is CityLoading) {
                      return Center(
                          child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ));
                    } else if (state is CityLoaded) {
                      if (state.cities.isEmpty) {
                        return Center(
                            child: Text("No cities match your search"));
                      }
                      return ListView.builder(
                        itemCount: state.cities.length,
                        itemBuilder: (context, index) {
                          final city = state.cities[index];
                          return Column(
                            children: [
                              ListTile(
                                title: Text(city.cityName,style: TextStyles.font18BlackRegular,),
                                onTap: () {
                                  cityCubit.selectCity(city.cityName);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Saved city: ${city.cityName}"),
                                      backgroundColor: AppColors.primary,
                                    ),
                                  );
                                  Navigator.pushReplacementNamed(
                                      context, RoutingEndpoints.profile);
                                },
                              ),
                              if (index != state.cities.length - 1)
                              Divider(
                                color: AppColors.semiGrey.withOpacity(0.2),
                              ),
                            ],
                          );
                        },
                      );
                    } else if (state is CityError) {
                      return Center(child: Text(state.message));
                    } else {
                      return Center(child: Text("No cities available"));
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
