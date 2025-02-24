import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:intl/intl.dart';
import 'package:ride_now/core/components/app_bar.dart';
import 'package:ride_now/core/components/app_text_form_field.dart';
import 'package:ride_now/core/components/drawer/drawer_items.dart';
import 'package:ride_now/core/helpers/safe_print.dart';
import 'package:ride_now/core/helpers/shared_pref.dart';
import 'package:ride_now/core/helpers/shared_pref_keys.dart';
import 'package:ride_now/core/theming/app_colors.dart';
import 'package:ride_now/core/utils/app_button.dart';
import 'package:u_credit_card/u_credit_card.dart';
import '../../../../core/di/di.dart';
import '../../../../core/services/network/api_constants.dart';
import '../../../../core/theming/styles.dart';
import '../../../../generated/l10n.dart';
import '../manager/wallet_cubit.dart';

class WalletScreen extends StatefulWidget {
  final String userId;

  const WalletScreen({super.key, required this.userId});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  bool _isEnteringAmount = false;
  final TextEditingController _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          WalletCubit(sl(), sl())..fetchWalletBalance(widget.userId),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.h),
          child: DefaultAppBar(text: S().wallet, withDivider: false),
        ),
        drawer: DrawerItems(),
        body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('wallet')
              .doc(widget.userId)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }

            if (!snapshot.hasData || !snapshot.data!.exists) {
              return Center(
                  child: Text('Balance: \$0.00',
                      style: TextStyles.font18BlackBold));
            }

            double balance =
                (snapshot.data!.data() as Map<String, dynamic>)['balance'] ??
                    0.0;
            Timestamp? lastUpdated =
                (snapshot.data!.data() as Map<String, dynamic>)['lastUpdated'];

            String lastUpdatedText = lastUpdated != null
                ? DateFormat('yyyy-MM-dd hh:mm a').format(lastUpdated.toDate())
                : "Never Updated";

            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Center(
                    child: CreditCardUi(
                      cardHolderFullName:
                          SharedPref.getString(key: MySharedKeys.userName) ??
                              "",
                      cardNumber: '1234567812345678',
                      validThru: '10/24',
                      topLeftColor: AppColors.primary,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(10.sp),
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                    decoration: BoxDecoration(
                      color: AppColors.semiGrey.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Row(
                      spacing: 10,
                      children: [
                        CircleAvatar(
                          backgroundColor:
                              AppColors.semiGrey.withValues(alpha: 0.2),
                          radius: 30.r,
                          child: Icon(Icons.wallet, color: AppColors.primary),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(S().yourBalance,
                                  style: TextStyles.font18BlackBold),
                              Text(
                                balance.toStringAsFixed(2).padLeft(2, '0'),
                                style: TextStyles.font24BlackBold,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(S().lastUpdated,
                                  style: TextStyles.font18BlackBold),
                              Text(
                                lastUpdatedText,
                                style: TextStyles.font18BlackBold,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (_isEnteringAmount)
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.w, vertical: 10.h),
                      child: AppTextFormField(
                        controller: _amountController,
                        hintText: "Enter Amount",
                        withHint: true,
                        hintStyle: TextStyles.font14BlackRegular,
                        backgroundColor:
                            AppColors.semiGrey.withValues(alpha: 0.2),
                        isFilled: true,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                    child: AppButton(
                      onPressed: () => _isEnteringAmount
                          ? _chargeWallet(context)
                          : setState(() => _isEnteringAmount = true),
                      text: _isEnteringAmount ? S().pay : S().chargeWallet,
                      backgroundColor: AppColors.primary,
                      textStyle: TextStyles.font14BlackRegular,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _chargeWallet(BuildContext context) async {
    final String amountText = _amountController.text.trim();
    if (amountText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter an amount")),
      );
      return;
    }

    final double? amount = double.tryParse(amountText);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Invalid amount entered")),
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

      if (mounted) {
        setState(() {
          _isEnteringAmount = false;
          _amountController.clear();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Payment Successful! Wallet Updated.")),
        );
      }
    } catch (e) {
      if (mounted) {
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
        FirebaseFirestore.instance.collection('wallet').doc(widget.userId);

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

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }
}
