import 'dart:convert';
import 'package:code_structure/core/constants/endpoints.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:code_structure/core/services/call_minutes_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StripeServices {
  // Your Stripe publishable key from the dashboard
  static const String _publishableKey =
      'pk_test_51Lxl0OLy0LoiWOlnlZH3GNGXV7vDAjj9uJcVYcNiPcBapitoe0HGLXebIsQ3zvMRFSAJwNxibAojwCc6pUNO2Svm00CRrVl3ua';

  static final CallMinutesService _callMinutesService = CallMinutesService();
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Firebase Functions URL - replace with your actual URL after deploying
  static const String _apiBase =
      'https://createpaymentintent-lczraojsja-uc.a.run.app';

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

      // Get the user's ID token
      final idToken = await _auth.currentUser?.getIdToken();
      if (idToken == null) {
        throw Exception('User not authenticated');
      }

      // API call to Firebase Functions endpoint
      final response = await http.post(
        Uri.parse('$_apiBase'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $idToken',
        },
        body: jsonEncode({
          'amount': amountInCents,
          'currency': currency,
          'description': description,
          'metadata': metadata,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to create payment intent: ${response.body}');
      }

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
        items: {'audioMinutes': audioMinutes, 'videoMinutes': videoMinutes},
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

      return PaymentIntentResult(status: 'failed', errorMessage: e.toString());
    }
  }

  // Create Stripe account
  static Future<Map<String, dynamic>> createAccount() async {
    try {
      // Get the user's ID token
      final idToken = await _auth.currentUser?.getIdToken();
      if (idToken == null) {
        throw Exception('User not authenticated');
      }

      // API call to Firebase Functions endpoint
      final response = await http.post(
        Uri.parse(createConnectedAccountUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $idToken',
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to create Stripe account: ${response.body}');
      }

      return jsonDecode(response.body);
    } catch (e) {
      print('Error creating Stripe account: $e');
      throw Exception('Failed to create Stripe account');
    }
  }

  // Create Checkout Session
  static Future<String> createCheckoutSession(
      String amount, String currency, String connectedAccountId) async {
    try {
      // Get the user's ID token
      final idToken = await _auth.currentUser?.getIdToken();
      if (idToken == null) {
        throw Exception('User not authenticated');
      }

      // API call to Firebase Functions endpoint
      final response = await http.post(
        Uri.parse(createCheckoutSessionUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $idToken',
        },
        body: jsonEncode({
          'amount': amount,
          'currency': currency,
          'connected_account_id': connectedAccountId,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to create checkout session: ${response.body}');
      }

      final responseData = jsonDecode(response.body);
      return responseData['link'];
    } catch (e) {
      print('Error creating checkout session: $e');
      throw Exception('Failed to create checkout session');
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
