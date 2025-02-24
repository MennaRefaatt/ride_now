import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import '../../../../core/helpers/safe_print.dart';
import '../../../../core/services/network/api_constants.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/styles.dart';
import '../../../../core/utils/app_button.dart';
import '../../../../generated/l10n.dart';

class ChargeButton extends StatelessWidget {
  const ChargeButton({
    super.key,
    required this.userId,
    required this.isEnteringAmount,
    required this.onToggleEnteringAmount,
    required this.amountController,
  });

  final bool isEnteringAmount;
  final String userId;
  final VoidCallback onToggleEnteringAmount;
  final TextEditingController amountController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: AppButton(
        onPressed: () => isEnteringAmount
            ? _chargeWallet(context)
            : onToggleEnteringAmount(),
        text: isEnteringAmount ? S().pay : S().chargeWallet,
        backgroundColor: AppColors.primary,
        textStyle: TextStyles.font18WhiteBold,
      ),
    );
  }

  Future<void> _chargeWallet(BuildContext context) async {
    final String amountText = amountController.text.trim();
    if (amountText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter an amount")),
      );
      return;
    }

    final double? amount = double.tryParse(amountText);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid amount entered")),
      );
      return;
    }

    try {
      final clientSecret = await _createPaymentIntent(amount);
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: "RideNow",
        ),
      );
      await Stripe.instance.presentPaymentSheet();
      await _updateWalletBalance(amount);

      if (context.mounted) {
        amountController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Payment Successful! Wallet Updated.")),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Payment Failed: $e")),
        );
      }
    }
  }

  Future<String> _createPaymentIntent(double amount) async {
    final dio = Dio();
    final response = await dio.post(
      'https://api.stripe.com/v1/payment_intents',
      options: Options(headers: {
        'Authorization': 'Bearer ${ApiConstants.stripeSecretKey}',
        'Content-Type': 'application/x-www-form-urlencoded',
      }),
      data: {
        'amount': (amount * 100).toInt().toString(),
        'currency': 'usd',
      },
    );
    return response.data["client_secret"];
  }

  Future<void> _updateWalletBalance(double amount) async {
    final walletRef =
    FirebaseFirestore.instance.collection('wallet').doc(userId);

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final snapshot = await transaction.get(walletRef);
      final currentTime = Timestamp.now();

      if (!snapshot.exists) {
        safePrint("Creating new wallet entry...");
        transaction.set(walletRef, {
          "balance": amount,
          "lastUpdated": currentTime,
        });
      } else {
        final newBalance = (snapshot["balance"] ?? 0) + amount;
        safePrint("Updating wallet balance: $newBalance");
        transaction.update(walletRef, {
          "balance": newBalance,
          "lastUpdated": currentTime,
        });
      }
    });
  }
}
