import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_now/features/driver/driver_registration/presentation/widgets/text_form_entry.dart';
import '../../../../../core/di/di.dart';
import '../../../../../core/theming/app_colors.dart';
import '../../../../../core/theming/styles.dart';
import '../manager/driver_registration_cubit.dart';

class DriverBottomSheet extends StatefulWidget {
  final String type;
  final TextEditingController controller;
  final Future<List<Map<String, dynamic>>> itemsFuture; // Accept Future here

  const DriverBottomSheet({
    super.key,
    required this.type,
    required this.controller,
    required this.itemsFuture, // Accept Future here
  });

  @override
  State<DriverBottomSheet> createState() => _DriverBottomSheetState();
}

class _DriverBottomSheetState extends State<DriverBottomSheet> {
  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> filteredItems = [];
  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DriverRegistrationCubit(
          fetchColorsUseCase: sl(),
          fetchBrandsUseCase: sl(),
          fetchModelsUseCase: sl(),
          submitDriverRegistrationUseCase: sl())
        ..fetchModels()
        ..fetchColors()
        ..fetchBrands(),
      child: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(15.sp),
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: BlocBuilder<DriverRegistrationCubit, DriverRegistrationState>(
            builder: (context, state) {
              if (state is DriverRegistrationBrandsFetched) {
                if (widget.type == 'brand') {
                  filteredItems = state.brands;
                }
              } else if (state is DriverRegistrationModelsFetched) {
                if (widget.type == 'model') {
                  filteredItems = state.models;
                }
              } else if (state is DriverRegistrationColorsFetched) {
                if (widget.type == 'color') {
                  filteredItems = state.colors;
                }
              }
              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _getTitle(),
                          style: TextStyles.font18BlackRegular,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      CircleAvatar(
                        radius: 15.r,
                        backgroundColor: AppColors.semiGrey.withOpacity(0.2),
                        child: InkWell(
                          onTap: () => Navigator.pop(context),
                          child: Icon(CupertinoIcons.xmark, size: 20.sp),
                        ),
                      ),
                    ],
                  ),
                  TextFormEntry(
                    controller: searchController,
                    hintText: "S().search",
                    onChanged: (value) {
                      setState(() {
                        filteredItems = filteredItems
                            .where((item) => item['name']
                                .toLowerCase()
                                .contains(value.toLowerCase()))
                            .toList();
                      });
                    },
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = filteredItems[index];
                      return ListTile(
                        leading: Visibility(
                          visible: item['color'] != null,
                          child: CircleAvatar(
                            radius: 15.r,
                            backgroundColor: item['color'],
                          ),
                        ),
                        title: Text(
                          item['name'],
                          style: TextStyles.font18BlackRegular,
                        ),
                        onTap: () {
                          setState(() {
                            widget.controller.text = item['name'];
                          });
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  String _getTitle() {
    switch (widget.type) {
      case 'model':
        return "S().selectModel";
      case 'brand':
        return "S().selectBrand";
      case 'color':
        return "S().selectColor";
      default:
        return '';
    }
  }
}
