import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_now/core/components/app_bar.dart';
import 'package:ride_now/core/components/drawer/drawer_items.dart';
import 'package:ride_now/features/privacy_policy/presentation/manager/privacy_cubit.dart';

import '../../../../core/di/di.dart';
import '../../../../generated/l10n.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<PrivacyCubit>()..loadPrivacyPolicy(),
      child: Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(50.h),
            child: DefaultAppBar(
              text: S().privacyPolicy,
              withDivider: false,
            )),
        drawer: DrawerItems(),
        body: BlocBuilder<PrivacyCubit, PrivacyState>(
          builder: (context, state) {
            if (state is PrivacyPolicyLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is PrivacyPolicyLoaded) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Text(
                    state.policy.replaceAllMapped(
                      RegExp(r'(?<=\.)\s*'),
                          (match) => '\n',
                    ),
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
              );
            } else if (state is PrivacyPolicyError) {
              return Center(
                  child:
                  Text(state.message, style: TextStyle(color: Colors.red)));
            }
            return SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

