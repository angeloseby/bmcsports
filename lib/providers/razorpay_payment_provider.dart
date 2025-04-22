import 'package:bmcsports/models/booking_create_model.dart';
import 'package:bmcsports/providers/booking_provider.dart';
import 'package:bmcsports/services/local_db_services.dart';
import 'package:bmcsports/services/razorpay_payment_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_web/razorpay_web.dart';

class RazorpayPaymentProvider with ChangeNotifier {
  final Razorpay _razorpay = Razorpay();
  bool isProcessing = false;

  Future<void> initiatePayment(int amount, String orderId) async {
    isProcessing = true;
    notifyListeners();
    Map<String, String?> _userDetails = await LocalDbService().getUserDetails();

    _razorpay.open({
      'key': RazorpayPaymentService.apiKey,
      'amount': amount * 100, // Amount in paise
      'name': 'BMC SPORTS TURF',
      'order_id': orderId,
      'prefill': {
        'phone': _userDetails['phone'],
        'email': _userDetails['fullName'],
        'fullName': _userDetails['fullName'],
      },
    });

    isProcessing = false;
    notifyListeners();
  }

  void _onPaymentSuccess(
    PaymentSuccessResponse response,
    BuildContext context,
    List<BookingModel> slots,
  ) {
    Provider.of<BookingProvider>(context, listen: false).addBookings(slots);
    debugPrint('Payment Successful: ${response.paymentId}');
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
