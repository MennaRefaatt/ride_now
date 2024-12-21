import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_now/core/components/social_icons.dart';
import 'package:ride_now/core/helpers/spacing.dart';
import '../../../../../core/services/routing/routing_endpoints.dart';
import '../manager/facebook/facebook_notifier.dart';
import '../manager/google/google_notifier.dart';

class GoogleFacebookButtons extends ConsumerWidget {
  const GoogleFacebookButtons({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final googleState = ref.watch(googleNotifierProvider);
    final facebookState = ref.watch(facebookNotifierProvider);

    ref.listen(googleNotifierProvider, (previous, next) {
      if (next.user != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacementNamed(context, RoutingEndpoints.home);
        });
      }
    });

    ref.listen(facebookNotifierProvider, (previous, next) {
      if (next.user != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacementNamed(context, RoutingEndpoints.home);
        });
      }
    });

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SocialIcons(
              path: "icons/google.png",
              onTap: () async {
                await ref
                    .read(googleNotifierProvider.notifier)
                    .signInWithGoogle();
              },
            ),
            horizontalSpacing(20.w),
            SocialIcons(
              path: "icons/facebook.png",
              onTap: () async {
                await ref
                    .read(facebookNotifierProvider.notifier)
                    .signInWithFacebook();
              },
            ),
          ],
        ),
        if (googleState.isLoading || facebookState.isLoading)
          const CircularProgressIndicator(),
        if (googleState.error != null)
          Text(googleState.error!, style: const TextStyle(color: Colors.red)),
        if (facebookState.error != null)
          Text(facebookState.error!, style: const TextStyle(color: Colors.red)),
      ],
    );
  }
}
