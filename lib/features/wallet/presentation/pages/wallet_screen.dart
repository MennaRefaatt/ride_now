import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:ride_now/core/components/app_bar.dart';
import 'package:ride_now/core/components/app_text_form_field.dart';
import 'package:ride_now/core/components/drawer/drawer_items.dart';
import 'package:ride_now/core/helpers/shared_pref.dart';
import 'package:ride_now/core/helpers/shared_pref_keys.dart';
import 'package:ride_now/core/theming/app_colors.dart';
import 'package:ride_now/features/wallet/presentation/widgets/balance_widget.dart';
import 'package:ride_now/features/wallet/presentation/widgets/charge_button.dart';
import 'package:u_credit_card/u_credit_card.dart';
import '../../../../core/di/di.dart';
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
  void _toggleEnteringAmount() {
    setState(() {
      _isEnteringAmount = !_isEnteringAmount;
    });
  }

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
                  BalanceWidget(
                      balance: balance, lastUpdatedText: lastUpdatedText),
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
                  ChargeButton(
                      onToggleEnteringAmount: _toggleEnteringAmount,
                      userId: widget.userId,
                      isEnteringAmount: _isEnteringAmount,
                      amountController: _amountController)
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }
}
