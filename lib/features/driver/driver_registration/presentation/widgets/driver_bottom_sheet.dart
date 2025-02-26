import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_now/features/driver/driver_registration/presentation/widgets/text_form_entry.dart';
import '../../../../../core/di/di.dart';
import '../../../../../core/theming/app_colors.dart';
import '../../../../../core/theming/styles.dart';
import '../../../../../generated/l10n.dart';
import '../manager/driver_registration_cubit.dart';

class DriverBottomSheet extends StatefulWidget {
  final String type;
  final TextEditingController controller;

  const DriverBottomSheet({
    super.key,
    required this.type,
    required this.controller,
  });

  @override
  State<DriverBottomSheet> createState() => _DriverBottomSheetState();
}

class _DriverBottomSheetState extends State<DriverBottomSheet> {
  TextEditingController searchController = TextEditingController();
  List<Map<dynamic, dynamic>> filteredItems = [];

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  final driverCubit = sl<DriverRegistrationCubit>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DriverRegistrationCubit, DriverRegistrationState>(
      builder: (context, state) {
        List<dynamic> items = [];

        if (state is DriverRegistrationBrandsFetched && widget.type == "brand") {
          items = state.brands;
        } else if (state is DriverRegistrationModelsFetched && widget.type == "model") {
          items = state.models;
        } else if (state is DriverRegistrationColorsFetched && widget.type == "color") {
          items = state.colors;
        } else if (state is DriverRegistrationLoading) {
          return Center(child: CircularProgressIndicator());
        }

        return Container(
          margin: EdgeInsets.all(15.sp),
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
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
                hintText: S().search,
                onChanged: (value) {
                  setState(() {
                    filteredItems = filteredItems.where((item) => item['name'].toLowerCase().contains(value.toLowerCase())).toList();
                  });
                },
                suffixIcon: InkWell(
                  onTap: () {
                    setState(() {
                      filteredItems = filteredItems.where((item) => item['name'].toLowerCase().contains(searchController.text.toLowerCase())).toList();
                    });
                  },
                  child: Icon(CupertinoIcons.search, size: 20.sp),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return ListTile(
                      leading: widget.type == "color"
                          ? CircleAvatar(
                        radius: 15.r,
                        backgroundColor: _parseColor(item.hexCode),
                      )
                          : null,

                      title: Text(item.name),
                      onTap: () {
                        widget.controller.text = item.name;
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _getTitle() {
    switch (widget.type) {
      case 'model':
        return S().selectModel;
      case 'brand':
        return S().selectBrand;
      case 'color':
        return S().selectColor;
      default:
        return '';
    }
  }
  Color _parseColor(String hexCode) {
    try {
      if (hexCode.startsWith('#')) {
        return Color(int.parse(hexCode.replaceFirst('#', '0xFF')));
      }
      return Color(int.parse(hexCode));
    } catch (e) {
      return Colors.grey;
    }
  }


}
