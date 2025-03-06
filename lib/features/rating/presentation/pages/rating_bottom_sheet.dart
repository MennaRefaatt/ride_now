import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:ride_now/core/components/app_text_form_field.dart';
import 'package:ride_now/core/helpers/spacing.dart';

import '../../../../core/components/custom_bottom_sheet.dart';
import '../../../../core/di/di.dart';
import '../../../../core/services/routing/routing_endpoints.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/styles.dart';
import '../../../../core/utils/app_button.dart';
import '../../../../generated/l10n.dart';
import '../manager/rating_cubit.dart';

class RatingBottomSheet extends StatefulWidget {
  final String tripId;
  final String ratedUserId;
  final bool isDriver;

  const RatingBottomSheet({
    super.key,
    required this.tripId,
    required this.ratedUserId,
    required this.isDriver,
  });

  @override
  State<RatingBottomSheet> createState() => _RatingBottomSheetState();
}

class _RatingBottomSheetState extends State<RatingBottomSheet> {
  double _rating = 0;
  final TextEditingController _commentController = TextEditingController();
  final ratingCubit = RatingCubit(sl());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocProvider(
      create: (context) => ratingCubit,
      child: CustomBottomSheet(
        title: S().rateYourDriver,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RatingBar.builder(
              initialRating: _rating,
              minRating: 1,
              glowColor: AppColors.primary,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                CupertinoIcons.star,
                color: AppColors.primary,
              ),
              onRatingUpdate: (rating) {
                setState(() {
                  _rating = rating;
                });
              },
            ),
            verticalSpacing(10),
            if (_rating > 0)
              AppTextFormField(
                controller: _commentController,
                withHint: true,
                hintText: S().leaveComment,
                hintStyle: theme.brightness == Brightness.dark
                    ? TextStyles.font14WhiteRegular
                    : TextStyles.font14BlackRegular,
                maxLines: 3,
                borderColor: theme.brightness == Brightness.dark
                    ? Colors.white
                    : AppColors.black,
              ),

            verticalSpacing(10),
            BlocConsumer<RatingCubit, RatingState>(
              listener: (context, state) {
                if (state is RatingSubmitSuccess) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(S().thankYouForRating)),
                  );

                  Navigator.pushReplacementNamed(
                    context,
                    RoutingEndpoints.passengerHome,
                  );
                } else if (state is RatingSubmitFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.error)),
                  );
                }
              },
              builder: (context, state) {
                return AppButton(
                  onPressed: () {
                    if (_rating > 0) {
                      context.read<RatingCubit>().submitRating(
                        tripId: widget.tripId,
                        ratedUserId: widget.ratedUserId,
                        rating: _rating,
                        comment: _commentController.text,
                        isDriver: false,
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(S().pleaseSelectRating)),
                      );
                    }
                  },
                  text: S().submit,
                  textStyle: TextStyles.font18WhiteBold,
                  backgroundColor: AppColors.primary,
                  borderRadius: 10,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
