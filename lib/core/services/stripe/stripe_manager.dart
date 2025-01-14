import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:ride_now/core/helpers/safe_print.dart';
import 'package:ride_now/core/services/network/api_constants.dart';

import '../../helpers/enums/stripe_payment_status.dart';

abstract class StripePaymentManager {
  static Future<String> makePayment(double amount, String currency) async {
    try {
      String clientSecret = await _getClientSecret(
        (amount * 100).round().toString(),
        currency,
      );
      await _initializePaymentSheet(clientSecret);
      await Stripe.instance.presentPaymentSheet();
      return StripePaymentStatus.succeeded.name;
    } catch (error) {
      if (error is StripeException) {
        return 'Payment failed: ${error.error.localizedMessage}';
      } else {
        safePrint("Payment failed: $error");
        return 'Payment failed: $error';
      }
    }
  }

  static Future<void> _initializePaymentSheet(String clientSecret) async {
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: clientSecret,
        merchantDisplayName: "Menna",
      ),
    );
  }

  static Future<String> _getClientSecret(String amount, String currency) async {
    try {
      Dio dio = Dio();
      var response = await dio.post(
        'https://api.stripe.com/v1/payment_intents',
        options: Options(
          headers: {
            'Authorization': 'Bearer ${ApiConstants.stripeSecretKey}',
            'Content-Type': 'application/x-www-form-urlencoded',
          },
        ),
        data: {
          'amount': amount,
          'currency': currency,
        },
      );

      if (response.statusCode == 200) {
        return response.data["client_secret"];
      } else {
        throw Exception(
            "Failed to create payment intent: ${response.statusMessage}");
      }
    } catch (e) {
      safePrint('Error creating payment intent: $e');
      rethrow;
    }
  }
}
