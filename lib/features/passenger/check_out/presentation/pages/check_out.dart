import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_now/core/helpers/enums/payment_method.dart';
import 'package:ride_now/core/helpers/enums/stripe_payment_status.dart';
import 'package:ride_now/core/helpers/spacing.dart';
import 'package:ride_now/features/passenger/check_out/presentation/check_out_args.dart';
import 'package:ride_now/features/trip_module/presentation/manager/trip_cubit.dart';
import '../../../../../core/di/di.dart';
import '../../../../../core/helpers/shared_pref.dart';
import '../../../../../core/helpers/shared_pref_keys.dart';
import '../../../../../core/theming/app_colors.dart';
import '../../../../../core/theming/styles.dart';
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
    createTripUseCase: sl(),
    getTripDetailsUseCase: sl(),
    cancelTripUseCase: sl(),
  );
  String selectedPaymentMethod = PaymentMethod.cash.name;
  late String tripId;

  @override
  void initState() {
    super.initState();
    tripId = SharedPref.getString(key: MySharedKeys.currentTripId) ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => tripCubit,
      child: Scaffold(
        backgroundColor: AppColors.semiGrey.withOpacity(0.2),
        appBar: AppBar(
          title: Text("Check Out", style: TextStyles.font24BlackBold),
          backgroundColor: Colors.white,
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
                        color: AppColors.primary.withOpacity(0.2),
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
            ),
            BlocBuilder<TripCubit, TripState>(
              builder: (context, state) {
                if ((selectedPaymentMethod == PaymentMethod.cash.name) ||
                    (selectedPaymentMethod == PaymentMethod.card.name &&
                        tripCubit.paymentStatus ==
                            StripePaymentStatus.holding.name)) {
                  return CheckOutButtons(
                    tripCubit: tripCubit,
                    fromAddress: widget.args.fromAddress,
                    toAddress: widget.args.toAddress,
                    fromLatLng: widget.args.fromLatLng,
                    toLatLng: widget.args.toLatLng,
                    paymentMethod: selectedPaymentMethod,
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
