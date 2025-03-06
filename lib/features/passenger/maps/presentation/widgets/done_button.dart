import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../../core/theming/app_colors.dart';
import '../../../../../core/theming/styles.dart';
import '../../../../../core/utils/app_button.dart';
import '../../../../../generated/l10n.dart';
import '../../data/model/location_model.dart';

class DoneButton extends StatelessWidget {
  const DoneButton({super.key,
    required this.selectedAddress,
    required this.selectedLocation,
    required this.address});
  final String? selectedAddress ;
  final LatLng? selectedLocation;
  final String address;

  @override
  Widget build(BuildContext context) {
    return AppButton(
      text: S().done,
      backgroundColor: AppColors.primary,
      borderRadius: 15.r,
      onPressed: () {
        if (selectedLocation != null) {
          Navigator.pop(
            context,
            LocationData(
              address: selectedAddress == null
                  ? address.toString()
                  : selectedAddress!,
              latitude: selectedLocation!.latitude,
              longitude: selectedLocation!.longitude,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                backgroundColor: AppColors.red,
                content: Text("Please select a location.")),
          );
        }
      },
      textStyle: TextStyles.font18BlackRegular,
    );
  }
}
