import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ride_now/core/theming/styles.dart';
import 'package:ride_now/core/utils/app_button.dart';
import '../../../../../core/theming/app_colors.dart';

import '../manager/trip_cubit.dart';

class CancelButton extends StatelessWidget {
  const CancelButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TripCubit, TripState>(
      listener: (context, state) {
        if (state is CancelTripSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Trip canceled successfully!')),
          );
          Navigator.pop(context);
        } else if (state is CancelTripError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error canceling trip: ${state.message}')),
          );
        }
      },
      builder: (context, state) {
        String? tripId;
        if (state is GetTripDetailsLoaded) {
          tripId = state.trip.tripId;
        }
        return Visibility(
          child: AppButton(
            text: 'Cancel the trip',
            backgroundColor: AppColors.semiGrey,
            onPressed: () {
              context.read<TripCubit>().cancelTrip(tripId!);
            },
            textStyle:
                TextStyles.font18WhiteBold.copyWith(color: AppColors.red),
          ),
        );
      },
    );
  }
}
