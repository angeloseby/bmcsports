class RazorpayOrderModel {
  final String id;
  final int amount;
  final String currency;

  RazorpayOrderModel({
    required this.id,
    required this.amount,
    required this.currency,
  });

  factory RazorpayOrderModel.fromJson(Map<String, dynamic> json) {
    return RazorpayOrderModel(
      id: json['id'],
      amount: json['amount'],
      currency: json['currency'],
    );
  }
}
