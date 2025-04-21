import 'package:bmcsports/services/razorpay_payment_services.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_web/razorpay_web.dart';
import '../models/razorpay_order_model.dart';

class RazorpayPaymentProvider with ChangeNotifier {
  final Razorpay _razorpay = Razorpay();
  RazorpayOrderModel? _order;
  bool isProcessing = false;

  RazorpayOrderModel? get order => _order;

  RazorpayPaymentProvider() {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _onPaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _onPaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _onExternalWallet);
  }

  Future<void> initiatePayment(int amount) async {
    isProcessing = true;
    notifyListeners();

    final orderData = await RazorpayPaymentService().createOrder(amount);
    if (orderData == null) return;

    _order = orderData;

    _razorpay.open({
      'key': RazorpayPaymentService.apiKey,
      'amount': orderData.amount,
      'name': 'BMC Sports',
      'description': 'Slot Booking Payment',
      'order_id': orderData.id,
      'prefill': {
        'contact': '1234567890',
        'email': 'test@example.com',
      },
    });

    isProcessing = false;
    notifyListeners();
  }

  void _onPaymentSuccess(PaymentSuccessResponse response) {
    debugPrint('Payment Successful: ${response.paymentId}');
    // TODO: Save booking / call confirmation dialog
  }

  void _onPaymentError(PaymentFailureResponse response) {
    debugPrint('Payment Error: ${response.code} - ${response.message}');
    // TODO: Show failure dialog
  }

  void _onExternalWallet(ExternalWalletResponse response) {
    debugPrint('External Wallet: ${response.walletName}');
  }

  void disposeRazorpay() {
    _razorpay.clear();
  }
}
