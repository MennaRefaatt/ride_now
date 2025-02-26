import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ride_now/core/helpers/safe_print.dart';
import 'package:ride_now/core/services/routing/routing_endpoints.dart';
import 'package:ride_now/features/passenger/check_out/presentation/check_out_args.dart';
import '../../../../../core/theming/app_colors.dart';
import '../../../../../core/theming/styles.dart';
import '../../../../../core/utils/app_button.dart';
import '../../../../../generated/l10n.dart';
import '../../../maps/presentation/manager/location_cubit.dart';
import '../manager/home_cubit.dart';
class OrderButton extends StatelessWidget {
  const OrderButton({super.key, required this.homeCubit, required this.openEnterYourRouteFromOrderButton});
final HomeCubit homeCubit;
  final void Function(BuildContext context) openEnterYourRouteFromOrderButton; // Fixed declaration
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AppButton(
        text: S().order,
        textStyle: TextStyles.font18BlackBold,
        onPressed: () async {
          if (homeCubit.fromController.text.isEmpty ||
              homeCubit.toController.text.isEmpty ||
              homeCubit.fromLatLng == null ||
              homeCubit.toLatLng == null) {
            openEnterYourRouteFromOrderButton(context);
          } else {
            final locationState =
                context.read<LocationCubit>().state;
            if (locationState is LocationLoaded) {
              homeCubit.fromLatLng = LatLng(
                locationState.position.latitude,
                locationState.position.longitude,
              );
            }

            safePrint(
                "From: ${homeCubit.fromLatLng}, To: ${homeCubit.toLatLng}");

            await Navigator.pushNamed(
                context, RoutingEndpoints.checkOut,
                arguments: CheckOutArgs(
                  fromAddress:
                  homeCubit.fromController.text,
                  toAddress:
                  homeCubit.toController.text,
                  fromLatLng: homeCubit.fromLatLng!,
                  toLatLng: homeCubit.toLatLng!,
                  selectedCategory:
                  homeCubit.selectedCategory!,
                ));
          }
        },
        backgroundColor: AppColors.primary,
        width: double.infinity,
      ),
    );
  }
}
