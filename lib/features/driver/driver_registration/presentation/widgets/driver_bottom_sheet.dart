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
    return BlocProvider(
  create: (context) => driverCubit,
  child: BlocBuilder<DriverRegistrationCubit, DriverRegistrationState>(
      builder: (context, state) {
        if (state is DriverRegistrationDataFetched && widget.type == 'brand') {
          filteredItems = state.brands.map((brand) => brand.toJson()).toList();
        } else if (state is DriverRegistrationDataFetched && widget.type == 'model') {
          filteredItems = state.models.map((model) => model.toJson()).toList();
        } else if (state is DriverRegistrationDataFetched && widget.type == 'color') {
          filteredItems = state.colors.map((color) => color.toJson()).toList();
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
                    backgroundColor: AppColors.semiGrey.withValues(alpha: 0.2),
                    child: InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Icon(CupertinoIcons.xmark, size: 20.sp),
                    ),
                  ),
                ],
              ),
              BlocBuilder<DriverRegistrationCubit, DriverRegistrationState>(
                builder: (context, state) {
                  if (state is DriverRegistrationDataFetched) {
                    final items = widget.type == "brand"
                        ? state.brands.map((brand) => brand.name).toList()
                        : widget.type == "model"
                        ? state.models.map((model) => model.name).toList()
                        : widget.type == "color"
                        ? state.colors.map((color) => color.name).toList()
                        : [];

                    return DropdownButton<String>(
                      value: widget.controller.text.isNotEmpty ? widget.controller.text : null,
                      items: items
                          .map((name) => DropdownMenuItem<String>(
                        value: name,
                        child: Text(name),
                      ))
                          .toList(),
                      onChanged: (value) {
                        widget.controller.text = value ?? "";
                        Navigator.pop(context);
                      },
                    );
                  }
                  return CircularProgressIndicator();
                },
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
                  shrinkWrap: true,
                  itemCount: filteredItems.length,
                  itemBuilder: (context, index) {
                    final item = filteredItems[index];
                    return ListTile(
                      leading: item['color'] != null
                          ? CircleAvatar(
                        radius: 15.r,
                        backgroundColor: Color(int.parse(item['color'])),
                      )
                          : null,
                      title: Text(
                        item['name'],
                        style: TextStyles.font18BlackRegular,
                      ),
                      onTap: () {
                        widget.controller.text = item['name'];
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
    ),
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
}
