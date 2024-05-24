import 'dart:convert';
import 'dart:developer';

import 'package:bheeshmaorganics/data/entitites/processing_order.dart';
import 'package:bheeshmaorganics/data/utils/razorpay_options.dart';
import 'package:bheeshmaorganics/data/utils/secrets.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:http/http.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorPayIntegration {
  final Razorpay _razorpay = Razorpay();
  String? orderId;
  Function(PaymentSuccessResponse) onSuccess;
  Function(PaymentFailureResponse, String?) onFailure;
  RazorPayIntegration({
    required this.onSuccess,
    required this.onFailure,
  });
  initializeRazorpay() {
    // Razorpay event listeners
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  Future<ProcessingOrder?> createOrder(
      amount, currency, receipt, description, userid) async {
    final _functions = FirebaseFunctions.instance;
    final result = await _functions.httpsCallable('createOrder').call(
      <String, dynamic>{
        'amount': amount,
        'currency': currency,
        'receipt': receipt,
        'description': description,
        'userid': userid,
      },
    );
    final responseData = result.data as Map<String, dynamic>;
    final orderDetails = ProcessingOrder.fromMap(responseData);
    orderId = orderDetails.id;
    return orderDetails;
  }

  Future<bool> _verifySignature({
    required String orderId,
    required String paymentId,
    required String signature,
  }) async {
    try {
      final _functions = FirebaseFunctions.instance;
      final result = await _functions.httpsCallable('verifySignature').call(
        <String, dynamic>{
          'orderId': orderId,
          'paymentId': paymentId,
          'signature': signature,
        },
      );
      return result.data;
    } on FirebaseFunctionsException catch (error) {
      onFailure(PaymentFailureResponse(-1, error.message, {}), orderId);
    }
    return false;
  }

  Future<void> openRazorpay(userid,
      {required int amount, // Enter the amount in the smallest currency
      required String currency, // Eg: INR
      required String receipt, // Eg: receipt#001
      required String businessName, // Eg: Acme Corp.
      required Prefill prefill,
      String description = '',
      int timeout = 60}) async {
    // Step 1: Create an order
    final processingOrderDetails =
        await createOrder(amount, currency, receipt, description, userid);
    if (processingOrderDetails != null) {
      // Step 2: Define the RazorpayOptions
      final options = RazorpayOptions(
        key: RazorpaySecret.keyId,
        amount: amount,
        businessName: businessName,
        orderId: processingOrderDetails.id!,
        description: description,
        timeout: 5 * 60,
        prefill: prefill,
        retry: Retry(enabled: false),
      ).toMap();

      // Step 3: Start the checkout (by opening dialog)
      _razorpay.open(options);
    }
  }

  _clear() {
    // Clear event listeners
    _razorpay.clear();
  }

  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    // Do something when payment succeeds
    bool isValid = await _verifySignature(
      orderId: response.orderId ?? '',
      paymentId: response.paymentId ?? '',
      signature: response.signature ?? '',
    );
    if (isValid) {
      onSuccess(response);
    } else {
      log('Payment failed');
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // When payment fails
    onFailure(response, orderId);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet is selected
  }
}
