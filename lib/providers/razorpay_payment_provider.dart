import 'package:bmcsports/services/local_db_services.dart';
import 'package:bmcsports/services/razorpay_payment_services.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_web/razorpay_web.dart';
import '../models/razorpay_order_model.dart';

class RazorpayPaymentProvider with ChangeNotifier {
  final Razorpay _razorpay = Razorpay();
  RazorpayOrderModel? _order;
  bool isProcessing = false;

  RazorpayOrderModel? get order => _order;

  VoidCallback? _onPaymentSuccessCallback;

  void setOnPaymentSuccessCallback(VoidCallback callback) {
    _onPaymentSuccessCallback = callback;
  }

  RazorpayPaymentProvider() {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _onPaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _onPaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _onExternalWallet);
  }

// import LocalDbService

  Future<void> initiatePayment(int amount) async {
    isProcessing = true;
    notifyListeners();

    final orderData = await RazorpayPaymentService().createOrder(amount);
    if (orderData == null) return;

    _order = orderData;

    // 🔄 Load user data from SharedPreferences
    final userDetails = await LocalDbService().getUserDetails();
    final String email = userDetails['email'] ?? '';
    final String phone = userDetails['phone'] ?? '';
    final String name = userDetails['fullName'] ?? '';

    _razorpay.open({
      'key': "rzp_test_UQBrIhVfRRXj3S",
      'amount': orderData.amount,
      'name': "BMC SPORTS",
      'description': 'Turf Booking System',
      'order_id': orderData.id,
      'prefill': {
        'contact': phone,
        'email': email,
        'name': name,
      },
    });

    isProcessing = false;
    notifyListeners();
  }

  void _onPaymentSuccess(PaymentSuccessResponse response) {
    debugPrint('Payment Successful: ${response.paymentId}');
    if (_onPaymentSuccessCallback != null) {
      _onPaymentSuccessCallback!();
    }
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
