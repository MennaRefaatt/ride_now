import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ride_now/core/helpers/enums/payment_method.dart';
import 'package:ride_now/core/helpers/enums/stripe_payment_status.dart';
import 'package:ride_now/core/helpers/spacing.dart';
import 'package:ride_now/features/passenger/check_out/presentation/check_out_args.dart';
import '../../../../../core/di/di.dart';
import '../../../../../core/helpers/shared_pref.dart';
import '../../../../../core/helpers/shared_pref_keys.dart';
import '../../../../../core/theming/app_colors.dart';
import '../../../../../core/theming/styles.dart';
import '../../../../../generated/l10n.dart';
import '../../../../trip_module/trip/presentation/manager/trip_cubit.dart';
import '../widgets/address_summarize.dart';
import '../widgets/check_out_buttons.dart';
import '../widgets/trip_payment_method.dart';
import '../widgets/recommended_cost.dart';

class CheckOut extends StatefulWidget {
  const CheckOut({
    super.key,
    required this.args,
  });
  final CheckOutArgs args;

  @override
  State<CheckOut> createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> {
  final tripCubit = TripCubit(
    acceptTripUseCase: sl(),
    getTripsUseCase: sl(),
    declineTripUseCase: sl(),
    createTripUseCase: sl(),
    getTripDetailsUseCase: sl(),
    cancelTripUseCase: sl(),
    completeTripUseCase: sl(),
  );
  String selectedPaymentMethod = PaymentMethod.cash.name;
  late String tripId;
  String newToAddress = "";
  LatLng newToLatLng = LatLng(0.0, 0.0);
  double newCost = 0.0;
  bool newPickedToAddress = false;
  @override
  void initState() {
    super.initState();
    tripId = SharedPref.getString(key: MySharedKeys.currentTripId) ?? "";
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocProvider(
      create: (context) => tripCubit,
      child: Scaffold(
        backgroundColor: AppColors.semiGrey.withValues(alpha: 0.2),
        appBar: AppBar(
          title: Text(S().checkout, style: theme.brightness == Brightness.dark ? TextStyles.font24WhiteBold : TextStyles.font24BlackBold),
          backgroundColor: theme.brightness == Brightness.dark ? Colors.black : Colors.white,
          centerTitle: true,
          leading: Visibility(
            visible:
                tripCubit.paymentStatus != StripePaymentStatus.succeeded.name,
            child: IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () => Navigator.of(context).pop()),
          ),
        ),
        body: Column(
          children: [
            BlocBuilder<TripCubit, TripState>(
              builder: (context, state) {
                if (state is TripCostUpdated) {
                  return RecommendedCost(
                    costText: state.cost.toStringAsFixed(2),
                  );
                }
                return RecommendedCost(
                  costText: tripCubit.cost.toStringAsFixed(2),
                );
              },
            ),
            verticalSpacing(10.h),
            BlocBuilder<TripCubit, TripState>(
              builder: (context, state) {
                if (tripCubit.cost > 0) {
                  return TripPaymentMethod(
                    selectedPaymentMethod: selectedPaymentMethod,
                    onSelect: (value) {
                      setState(() {
                        selectedPaymentMethod = value;
                      });
                    },
                    tripCubit: tripCubit,
                    cost: tripCubit.cost,
                    tripId: tripId,
                  );
                }
                if (state is TripPaymentStatusUpdated) {
                  return Center(
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(10.sp),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.r),
                        color: AppColors.primary.withValues(alpha: 0.2),
                      ),
                      child: Text(tripCubit.paymentStatus,
                          style: TextStyles.font18primaryBold),
                    ),
                  );
                }
                return SizedBox.shrink();
              },
            ),
            verticalSpacing(10.h),
            AddressSummarize(
              fromAddress: widget.args.fromAddress,
              toAddress: widget.args.toAddress,
              tripCubit: tripCubit,
              fromLatLng: widget.args.fromLatLng,
              toLatLng: widget.args.toLatLng,
              paymentMethod: selectedPaymentMethod,
              newCost: newCost,
              newToAddress: newToAddress,
              newToLatLng: newToLatLng,
              newPickedToAddress: newPickedToAddress,
            ),
            BlocBuilder<TripCubit, TripState>(
              builder: (context, state) {
                if ((selectedPaymentMethod == PaymentMethod.cash.name) ||
                    (selectedPaymentMethod == PaymentMethod.card.name &&
                        tripCubit.paymentStatus ==
                            StripePaymentStatus.holding.name)) {
                  return Container(
                    color: theme.brightness == Brightness.dark ? Colors.black : Colors.white,
                    padding: EdgeInsets.all(15.sp),
                    child: CheckOutButtons(
                      tripCubit: tripCubit,
                      selectedCategory: widget.args.selectedCategory,
                      fromAddress: widget.args.fromAddress,
                      toAddress: newPickedToAddress == true
                          ? newToAddress
                          : widget.args.toAddress,
                      fromLatLng: widget.args.fromLatLng,
                      toLatLng: newPickedToAddress == true
                          ? newToLatLng
                          : widget.args.toLatLng,
                      paymentMethod: selectedPaymentMethod,
                      cost:
                          newPickedToAddress == true ? newCost : tripCubit.cost,
                    ),
                  );
                }
                return SizedBox.shrink();
              },
            )
          ],
        ),
      ),
    );
  }
}
