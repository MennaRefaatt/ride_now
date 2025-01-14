import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_now/core/helpers/enums/payment_method.dart';
import 'package:ride_now/core/helpers/safe_print.dart';
import 'package:ride_now/core/helpers/spacing.dart';
import 'package:ride_now/core/theming/app_colors.dart';
import '../../../../../core/components/custom_bottom_sheet.dart';
import '../../../../../core/services/stripe/stripe_manager.dart';
import '../../../../../core/theming/styles.dart';
import '../../../../trip_module/presentation/manager/trip_cubit.dart';

class TripPaymentMethod extends StatefulWidget {
  TripPaymentMethod({
    super.key,
    required this.selectedPaymentMethod,
    required this.onSelect,
    required this.cost,
    required this.tripCubit,
    required this.tripId,
  });

  String selectedPaymentMethod;
  final Function(String) onSelect;
  final double cost;
  final TripCubit tripCubit;
  final String tripId;

  @override
  State<TripPaymentMethod> createState() => _TripPaymentMethodState();
}

class _TripPaymentMethodState extends State<TripPaymentMethod> {
  void _showPaymentMethodSheet(
    BuildContext context,
    String selectedPaymentMethod,
  ) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (_) => CustomBottomSheet(
        title: "Select Payment Method",
        child: ListView(
          shrinkWrap: true,
          children: [
            _buildPaymentOption(
              context,
              method: PaymentMethod.cash,
              isSelected:
                  widget.selectedPaymentMethod == PaymentMethod.cash.name,
            ),
            _buildPaymentOption(
              context,
              method: PaymentMethod.card,
              isSelected:
                  widget.selectedPaymentMethod == PaymentMethod.card.name,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOption(
    BuildContext context, {
    required PaymentMethod method,
    required bool isSelected,
  }) {
    return Container(
      color:
          isSelected ? AppColors.primary.withOpacity(0.2) : Colors.transparent,
      child: ListTile(
        leading: Icon(
          method == PaymentMethod.cash
              ? Icons.wallet
              : CupertinoIcons.creditcard,
          color: isSelected ? AppColors.primary : AppColors.semiGrey,
        ),
        title: Text(method.name),
        trailing:
            isSelected ? Icon(Icons.check, color: AppColors.primary) : null,
        onTap: () async {
          widget.onSelect(method.name);
          Navigator.pop(context);
          safePrint("Selected payment cost: ${widget.cost}");
          if (method == PaymentMethod.card) {
            if (widget.cost <= 0) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Please enter a valid amount")));
              return;
            }
            if (widget.cost > 0) {
              String paymentStatus = await StripePaymentManager.makePayment(
                  widget.cost, "EGP", widget.tripId);
              widget.tripCubit.updatePaymentStatus(paymentStatus);
            }
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showPaymentMethodSheet(
        context,
        widget.selectedPaymentMethod,
      ),
      child: Container(
        padding: EdgeInsets.all(15.sp),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30.r),
        ),
        child: Row(
          children: [
            Icon(Icons.wallet),
            horizontalSpacing(10.w),
            Expanded(
              child: Text(
                widget.selectedPaymentMethod,
                style: TextStyles.font18BlackRegular
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            Icon(CupertinoIcons.right_chevron),
          ],
        ),
      ),
    );
  }
}
