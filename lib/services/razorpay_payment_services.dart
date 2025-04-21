import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/razorpay_order_model.dart';

class RazorpayPaymentService {
  static const String apiUrl = 'https://api.razorpay.com/v1/orders';
  static const String apiKey = 'rzp_test_UQBrIhVfRRXj3S';
  static const String apiSecret = 'AFpylhkWjMugI20tioXypYFI';

  Future<RazorpayOrderModel?> createOrder(int amount) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Basic ${base64Encode(utf8.encode('$apiKey:$apiSecret'))}',
        },
        body: jsonEncode({'amount': amount * 100, 'currency': 'INR'}),
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
