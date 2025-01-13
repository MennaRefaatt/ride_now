import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_now/core/components/app_bar.dart';
import 'package:ride_now/core/helpers/enums/payment_method.dart';
import 'package:ride_now/core/helpers/spacing.dart';
import 'package:ride_now/features/passenger/check_out/presentation/check_out_args.dart';
import 'package:ride_now/features/trip_module/presentation/manager/trip_cubit.dart';
import '../../../../../core/di/di.dart';
import '../../../../../core/theming/app_colors.dart';
import '../widgets/address_summarize.dart';
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
      cancelTripUseCase: sl());
  String selectedPaymentMethod = PaymentMethod.cash.name;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => tripCubit,
      child: Scaffold(
        backgroundColor: AppColors.semiGrey.withOpacity(0.2),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.h),
          child: DefaultAppBar(
            text: "S().CheckOut",
            withDivider: false,
            backgroundColor: Colors.white,
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
            TripPaymentMethod(
              selectedPaymentMethod: selectedPaymentMethod,
              onSelect: (value) {
                setState(() {
                  selectedPaymentMethod = value;
                });
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
          ],
        ),
      ),
    );
  }
}
