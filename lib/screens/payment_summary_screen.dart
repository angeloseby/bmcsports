import 'package:bmcsports/models/slot_model.dart';
import 'package:bmcsports/providers/razorpay_payment_provider.dart';
import 'package:bmcsports/utils/app_colors.dart';
import 'package:bmcsports/utils/slot_time_formatter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PaymentSummaryScreen extends StatefulWidget {
  final DateTime selectedDate;
  final String selectedTurfType;
  final List<SlotModel> selectedSlots;

  const PaymentSummaryScreen({
    super.key,
    required this.selectedDate,
    required this.selectedTurfType,
    required this.selectedSlots,
  });

  @override
  State<PaymentSummaryScreen> createState() => _PaymentSummaryScreenState();
}

class _PaymentSummaryScreenState extends State<PaymentSummaryScreen> {
  @override
  void dispose() {
    context.read<RazorpayPaymentProvider>().disposeRazorpay();
    super.dispose();
  }

  double _calculateTotalPrice() {
    double total = 0;
    for (var slot in widget.selectedSlots) {
      if (widget.selectedTurfType == '5s') {
        total += slot.turf5sPrice;
      } else {
        total += slot.turf7sPrice;
      }
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate =
        DateFormat('EEE, MMM d, yyyy').format(widget.selectedDate);
    final totalPrice = _calculateTotalPrice();
    final isProcessing = context.watch<RazorpayPaymentProvider>().isProcessing;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Summary'),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
      ),
      backgroundColor: const Color(0xFFF5F6FA),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Date: $formattedDate", style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 4),
            Text("Turf Type: ${widget.selectedTurfType}",
                style: const TextStyle(fontSize: 16)),
            const Divider(height: 24),
            const Text("Selected Slots:",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: widget.selectedSlots.length,
                itemBuilder: (context, index) {
                  final slot = widget.selectedSlots[index];
                  return ListTile(
                    title: Text(slotTimeFormatter(slot.startTime)),
                    trailing: Text(
                        "₹${widget.selectedTurfType == '5s' ? slot.turf5sPrice : slot.turf7sPrice}"),
                  );
                },
              ),
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Total:",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                Text("₹$totalPrice",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18)),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: isProcessing
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: () {
                        final totalPrice = _calculateTotalPrice().toInt();
                        context
                            .read<RazorpayPaymentProvider>()
                            .initiatePayment(totalPrice);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        foregroundColor: AppColors.secondaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text("Confirm & Pay",
                          style: TextStyle(fontSize: 16)),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
