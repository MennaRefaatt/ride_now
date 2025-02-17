import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../../core/helpers/enums/stripe_payment_status.dart';
import '../../../../../core/helpers/safe_print.dart';
import '../../../../../core/helpers/secure_storage/secure_keys.dart';
import '../../../../../core/helpers/secure_storage/secure_storage.dart';
import '../../../../../core/helpers/shared_pref.dart';
import '../../../../../core/helpers/shared_pref_keys.dart';
import '../../../../../core/services/f_c_m_service/firebase_messaging_service.dart';
import '../../../../../core/services/routing/routing_endpoints.dart';
import '../../../../../core/services/stripe/stripe_manager.dart';
import '../../../../../core/theming/app_colors.dart';
import '../../../../../core/theming/styles.dart';
import '../../../../../core/utils/app_button.dart';
import '../../../../../generated/l10n.dart';
import '../../../../trip_module/trip/data/models/trip_model.dart';
import '../../../../trip_module/trip/presentation/manager/trip_cubit.dart';
import '../../../../trip_module/trip/presentation/trip_tracking_args.dart';
import '../../../../trip_module/trip/presentation/trip_tracking_route_args.dart';

class TripActions extends StatelessWidget {
  final TripModel trip;
  final TripCubit tripCubit;

  const TripActions({super.key, required this.trip, required this.tripCubit});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        /// Decline Button
        AppButton(
          text: S.of(context).decline,
          backgroundColor: Colors.grey.shade200,
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Trip Declined")),
            );
          },
          textStyle: TextStyles.font18WhiteBold.copyWith(color: AppColors.red),
          borderRadius: 10.r,
          width: MediaQuery.of(context).size.width * 0.3,
        ),

        /// Accept Button
        AppButton(
          text: S.of(context).accept,
          backgroundColor: AppColors.primary,
          onPressed: () async {
            final driverData = await getDriverData();
            await tripCubit.acceptTrip(trip, driverData);

            if (trip.tripId.isNotEmpty) {
              safePrint("Trip id: ${trip.tripId}");
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Trip Accepted: ${trip.tripId}")),
              );

              /// Send notification to passenger
              if (trip.passengerData.passengerToken.isNotEmpty) {
                // await sendNotification(
                //   title: "رحلتك قيد التنفيذ!",
                //   body: "لقد قبل السائق ${driverData.driverName} رحلتك، استعد للانطلاق 🚗",
                //   token: trip.passengerData.passengerToken,
                // );
              }

              /// Navigate to Trip Tracking screen
              Navigator.pushReplacementNamed(
                context,
                RoutingEndpoints.tripTracking,
                arguments: TripTrackingRouteArgs(
                  tripTrackingArgs: TripTrackingArgs(
                    fromAddress: trip.from,
                    toAddress: trip.to,
                    tripId: trip.tripId,
                    fromLatLng: trip.fromLatLng,
                    toLatLng: trip.toLatLng,
                    driverLatLng: driverData.driverLocation,
                    tripStatus: trip.status,
                  ),
                  isPassenger: false,
                ),
              );

              /// Capture Payment
              final captureResult = await StripePaymentManager.capturePayment(trip.tripId);
              if (captureResult == 'Payment succeeded') {
                tripCubit.updatePaymentStatus(StripePaymentStatus.succeeded.name);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: AppColors.primary,
                    content: Text('Payment Captured Successfully'),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: AppColors.red,
                    content: Text('Payment Capture Failed: $captureResult'),
                  ),
                );
              }
            }
          },
          textStyle: TextStyles.font18BlackRegular,
          borderRadius: 10.r,
          width: MediaQuery.of(context).size.width * 0.4,
        ),
      ],
    );
  }
}

/// Fetch Driver Data
Future<DriverData> getDriverData() async {
  final driverToken = await SecureStorageService.readData(SecureKeys.deviceToken) ?? '';

  return DriverData(
    driverId: SharedPref.getString(key: MySharedKeys.driverId) ?? '',
    driverName: SharedPref.getString(key: MySharedKeys.driverName) ?? '',
    driverPhone: SharedPref.getString(key: MySharedKeys.driverPhone) ?? '',
    driverImage: SharedPref.getString(key: MySharedKeys.driverPicture) ?? '',
    carModel: SharedPref.getString(key: MySharedKeys.carModel) ?? '',
    carColor: SharedPref.getString(key: MySharedKeys.carColor) ?? '',
    carNumber: SharedPref.getString(key: MySharedKeys.carNumber) ?? '',
    driverToken: driverToken,
    driverLocation: LatLng(
      SharedPref.getDouble(key: MySharedKeys.driverLatitude) ?? 0.0,
      SharedPref.getDouble(key: MySharedKeys.driverLongitude) ?? 0.0,
    ),
  );
}
