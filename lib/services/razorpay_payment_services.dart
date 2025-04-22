import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/razorpay_order_model.dart';

class RazorpayPaymentService {
  // Replace this with your actual deployed function URL
  static const String secretKey = "rzp_test_UQBrIhVfRRXj3S";
  static const String cloudFunctionUrl =
      'https://us-central1-bmcsports2025.cloudfunctions.net/createRazorpayOrder';

  Future<RazorpayOrderModel?> createOrder(int amount) async {
    try {
      // Generate a unique receipt ID, here we're using a timestamp
      final receiptId = 'receipt_${DateTime.now().millisecondsSinceEpoch}';

      final response = await http.post(
        Uri.parse(cloudFunctionUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'amount': amount, 'receipt': receiptId}),
      );

      if (response.statusCode == 200) {
        return RazorpayOrderModel.fromJson(jsonDecode(response.body));
      } else {
        print('Failed to create order: ${response.body}');
      }
    } catch (e) {
      print('Exception while creating order: $e');
    }
    return null;
  }
}
