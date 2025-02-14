import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_now/core/helpers/enums/payment_method.dart';
import 'package:ride_now/core/helpers/safe_print.dart';
import 'package:ride_now/core/helpers/spacing.dart';
import 'package:ride_now/core/theming/app_colors.dart';
import '../../../../../core/components/custom_bottom_sheet.dart';
import '../../../../../core/helpers/enums/stripe_payment_status.dart';
import '../../../../../core/services/stripe/stripe_manager.dart';
import '../../../../../core/theming/styles.dart';
import '../../../../../generated/l10n.dart';
import '../../../../trip_module/trip/presentation/manager/trip_cubit.dart';

class TripPaymentMethod extends StatefulWidget {
  const TripPaymentMethod({
    super.key,
    required this.selectedPaymentMethod,
    required this.onSelect,
    required this.cost,
    required this.tripCubit,
    required this.tripId,
  });

  final String selectedPaymentMethod;
  final Function(String) onSelect;
  final double cost;
  final TripCubit tripCubit;
  final String tripId;

  @override
  State<TripPaymentMethod> createState() => _TripPaymentMethodState();
}

class _TripPaymentMethodState extends State<TripPaymentMethod> {
  void _showPaymentMethodSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (_) => CustomBottomSheet(
        title: S().paymentMethod,
        child: Column(
          children: [
            _buildPaymentOption(context, method: PaymentMethod.cash),
            _buildPaymentOption(context, method: PaymentMethod.card),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOption(BuildContext context, {required PaymentMethod method}) {
    return Container(
      color: widget.selectedPaymentMethod == method.name
          ? AppColors.primary.withValues(alpha: 0.2)
          : Colors.transparent,
      child: ListTile(
        leading: Icon(
          method == PaymentMethod.cash ? Icons.wallet : CupertinoIcons.creditcard,
          color: widget.selectedPaymentMethod == method.name
              ? AppColors.primary
              : AppColors.semiGrey,
        ),
        title: Text(method.name),
        trailing: widget.selectedPaymentMethod == method.name
            ? Icon(Icons.check, color: AppColors.primary)
            : null,
        onTap: () async {
          widget.onSelect(method.name);
          Navigator.pop(context);
          safePrint("Selected payment cost: ${widget.cost}");

          if (method == PaymentMethod.card && widget.cost > 0) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: AppColors.primary,
                content: Text("Processing payment...")));
            String paymentStatus = await _processStripePayment(widget.cost, widget.tripId,context: context);
            widget.tripCubit.updatePaymentStatus(paymentStatus);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.orange, content: Text(paymentStatus)));
          } else if (widget.cost <= 0) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: AppColors.red,
                content: Text("Please enter a valid amount")));
          }
        },
      ),
    );
  }

  Future<String> _processStripePayment(double amount, String tripId,
      {required BuildContext context}) async {
    try {
      String paymentStatus =
      await StripePaymentManager.makePayment(amount, "EGP", tripId);
      widget.tripCubit.updatePaymentStatus(paymentStatus);

      if (paymentStatus == StripePaymentStatus.holding.name) {
        if (context.mounted) {
          setState(() {}); // Refresh the UI
        }
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(paymentStatus)),
      );
      return paymentStatus;
    } catch (error) {
      safePrint("Payment failed: $error");
      return 'Payment failed: $error';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showPaymentMethodSheet(context),
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
