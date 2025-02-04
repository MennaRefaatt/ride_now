import 'dart:async';
import 'dart:isolate';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:ride_now/core/helpers/safe_print.dart';
import 'package:ride_now/core/services/network/api_constants.dart';

import '../../helpers/enums/stripe_payment_status.dart';

abstract class StripePaymentManager {
  static final Dio _dio = Dio();

  static Future<String> makePayment(
      double amount, String currency, String tripId) async {
    try {
      String clientSecret = await _getClientSecret(
        (amount * 100).round().toString(),
        currency,
      );
      await _initializePaymentSheet(clientSecret);
      await Stripe.instance.presentPaymentSheet();
      await FirebaseFirestore.instance
          .collection('trips')
          .doc(tripId)
          .update({'paymentStatus': StripePaymentStatus.holding.name});
      return StripePaymentStatus.holding.name;
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
    try {
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: "Menna",
        ),
      );
    } catch (error) {
      safePrint("Failed to initialize payment sheet: $error");
      rethrow;
    }
  }

  static Future<String> _getClientSecret(String amount, String currency) async {
    final receivePort = ReceivePort();
    await Isolate.spawn(
        _getClientSecretInBackground, [amount, currency, receivePort.sendPort]);
    final result = await receivePort.first;

    return result;
  }

  static void _getClientSecretInBackground(List<dynamic> params) async {
    String amount = params[0];
    String currency = params[1];
    SendPort sendPort = params[2];

    try {
      var response = await _dio.post(
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
          'capture_method': 'manual',
        },
      );

      if (response.statusCode == 200) {
        sendPort.send(response.data["client_secret"]);
      } else {
        safePrint('Error response: ${response.data}');
        sendPort
            .send('Failed to create payment intent: ${response.statusMessage}');
      }
    } catch (e) {
      safePrint('Error creating payment intent: $e');
      sendPort.send('Error creating payment intent: $e');
    }
  }

  static Future<String> capturePayment(String paymentIntentId) async {
    try {
      final response = await _dio.post(
        'https://api.stripe.com/v1/payment_intents/$paymentIntentId/capture',
        options: Options(
          headers: {
            'Authorization': 'Bearer ${ApiConstants.stripeSecretKey}',
          },
        ),
      );

      if (response.statusCode == 200) {
        return 'Payment succeeded';
      } else {
        safePrint('Error capturing payment: ${response.data}');
        return 'Failed to capture payment: ${response.statusMessage}';
      }
    } catch (e) {
      safePrint('Error capturing payment: $e');
      return 'Error capturing payment: $e';
    }
  }
}



