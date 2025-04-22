class RazorpayOrderModel {
  final String bookingId;
  final int amount;
  final String currency;

  RazorpayOrderModel({
    required this.bookingId,
    required this.amount,
    required this.currency,
  });

  factory RazorpayOrderModel.fromJson(Map<String, dynamic> json) {
    return RazorpayOrderModel(
      bookingId: json['bookingId'],
      amount: json['amount'],
      currency: json['currency'],
    );
  }
}
