import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:code_structure/core/services/call_minutes_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StripeService {
  // Replace with your actual backend API URL to create payment intents
  static const String _apiBase = 'YOUR_BACKEND_API_URL';

  // Your Stripe publishable key from the dashboard
  static const String _publishableKey = 'YOUR_STRIPE_PUBLISHABLE_KEY';

  static final CallMinutesService _callMinutesService = CallMinutesService();
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Initialize Stripe
  static Future<void> initialize() async {
    Stripe.publishableKey = _publishableKey;
    await Stripe.instance.applySettings();
  }

  // Create payment intent on the server
  static Future<Map<String, dynamic>> createPaymentIntent(
    String amount,
    String currency, {
    String? description,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      // Convert amount to cents/smallest currency unit
      final amountInCents = (double.parse(amount) * 100).round().toString();

      // API call to your backend endpoint
      final response = await http.post(
        Uri.parse('$_apiBase/create-payment-intent'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'amount': amountInCents,
          'currency': currency,
          'description': description,
          'metadata': metadata,
        }),
      );

      return jsonDecode(response.body);
    } catch (e) {
      print('Error creating payment intent: $e');
      throw Exception('Failed to create payment intent');
    }
  }

  // Process payment for call minutes purchase
  static Future<PaymentIntentResult> purchaseCallMinutes(
    BuildContext context,
    double amount,
    int audioMinutes,
    int videoMinutes,
    String paymentMethod,
  ) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      // Create metadata for the purchase
      final metadata = {
        'userId': userId,
        'audioMinutes': audioMinutes,
        'videoMinutes': videoMinutes,
        'purchase_type': 'call_minutes',
      };

      // Create description for the purchase
      final description =
          'Purchase: ${audioMinutes}min audio + ${videoMinutes}min video calls';

      // Create payment intent
      final paymentIntent = await createPaymentIntent(
        amount.toString(),
        'USD',
        description: description,
        metadata: metadata,
      );

      if (paymentIntent['error'] != null) {
        throw Exception(paymentIntent['error']);
      }

      // Set up the payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent['clientSecret'],
          merchantDisplayName: 'Buzz Me',
          style: ThemeMode.light,
          billingDetails: BillingDetails(
            email: _auth.currentUser?.email,
            name: _auth.currentUser?.displayName,
          ),
        ),
      );

      // Present the payment sheet
      await Stripe.instance.presentPaymentSheet();

      // Payment was successful, update the user's call minutes
      await _callMinutesService.addPurchasedMinutes(
        userId,
        audioMinutes,
        videoMinutes,
      );

      // Record transaction in Firebase
      await _callMinutesService.createTransaction(
        userId: userId,
        amount: amount,
        status: 'succeeded',
        paymentMethod: paymentMethod,
        paymentIntentId: paymentIntent['id'],
        items: {
          'audioMinutes': audioMinutes,
          'videoMinutes': videoMinutes,
        },
      );

      // Return success result
      return PaymentIntentResult(
        status: 'succeeded',
        paymentIntentId: paymentIntent['id'],
      );
    } on StripeException catch (e) {
      print('Stripe error: ${e.error.localizedMessage}');

      if (_auth.currentUser?.uid != null) {
        // Record failed transaction
        await _callMinutesService.createTransaction(
          userId: _auth.currentUser!.uid,
          amount: amount,
          status: 'failed',
          paymentMethod: paymentMethod,
          paymentIntentId: 'error_${DateTime.now().millisecondsSinceEpoch}',
          items: {
            'audioMinutes': audioMinutes,
            'videoMinutes': videoMinutes,
            'error': e.error.localizedMessage,
          },
        );
      }

      return PaymentIntentResult(
        status: 'failed',
        errorMessage: e.error.localizedMessage,
      );
    } catch (e) {
      print('General error: $e');

      if (_auth.currentUser?.uid != null) {
        // Record failed transaction
        await _callMinutesService.createTransaction(
          userId: _auth.currentUser!.uid,
          amount: amount,
          status: 'failed',
          paymentMethod: paymentMethod,
          paymentIntentId: 'error_${DateTime.now().millisecondsSinceEpoch}',
          items: {
            'audioMinutes': audioMinutes,
            'videoMinutes': videoMinutes,
            'error': e.toString(),
          },
        );
      }

      return PaymentIntentResult(
        status: 'failed',
        errorMessage: e.toString(),
      );
    }
  }
}

class PaymentIntentResult {
  final String status;
  final String? paymentIntentId;
  final String? errorMessage;

  PaymentIntentResult({
    required this.status,
    this.paymentIntentId,
    this.errorMessage,
  });

  bool get isSuccess => status == 'succeeded';
}
