import 'package:bmcsports/models/booking_create_model.dart';
import 'package:bmcsports/models/slot_model.dart';
import 'package:bmcsports/providers/booking_provider.dart';
import 'package:bmcsports/providers/razorpay_payment_provider.dart';
import 'package:bmcsports/services/local_db_services.dart';
import 'package:bmcsports/styles/app_colors.dart';
import 'package:bmcsports/utils/booking_id_generator.dart';
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
  String? fullName;
  String? email;
  String? phone;

  @override
  void initState() {
    super.initState();
    _loadUserDetails();
  }

  Future<void> _loadUserDetails() async {
    final userDetails = await LocalDbService().getUserDetails();
    setState(() {
      fullName = userDetails['fullName'];
      email = userDetails['email'];
      phone = userDetails['phone'];
    });
  }

  Future<void> submitBooking(
    DateTime selectedDate,
    String bookingId,
    String bookingTime,
    List<SlotModel> selectedSlots,
    String paymentId,
  ) async {
    try {
      final bookingProvider =
          Provider.of<BookingProvider>(context, listen: false);

      // Create booking models for each selected slot
      final userDetails = await LocalDbService().getUserDetails();
      final String email = userDetails['email'] ?? '';
      final String phone = userDetails['phone'] ?? '';
      final String name = userDetails['fullName'] ?? 'BMC SPORTS';
      final List<BookingModel> bookings = widget.selectedSlots.map((slot) {
        return BookingModel(
          slotDate: selectedDate.toIso8601String().split("T")[0],
          bookingId: bookingId,
          bookedTime: DateTime.now(),
          slotIds: getAllSlotIds(selectedSlots),
          slotStartTimes: getAllSlotTime(selectedSlots),
          bookedType: widget.selectedTurfType,
          customerName: name,
          customerPhoneNumber: phone,
          customerEmail: email,
          paymentId: paymentId,
          paymentAmount: _calculateTotalPrice(),
          paymentStatus: "Success",
          paymentMode: "Online",
        );
      }).toList();

      await bookingProvider.addBookings(bookings);

      Navigator.pop(context, true); // Return the list of bookings
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error creating bookings: ${e.toString()}')),
      );
    }
  }

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
            /// 👤 User Details
            const Text("User Info:",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text("Name: ${fullName ?? '-'}"),
            Text("Email: ${email ?? '-'}"),
            Text("Phone: ${phone ?? '-'}"),
            const Divider(height: 24),

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
                      "₹${widget.selectedTurfType == '5s' ? slot.turf5sPrice : slot.turf7sPrice}",
                    ),
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
                            .setOnPaymentSuccessCallback(() {
                          submitBooking(
                            widget.selectedDate,
                            generateBookingId(),
                            getAllSlotTime(widget.selectedSlots).join(','),
                            widget.selectedSlots,
                            "test_payment_id", // Replace with actual payment ID
                          );
                        });

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
            )
          ],
        ),
      ),
    );
  }
}

List<String> getAllSlotIds(List<SlotModel> selectedSlots) {
  List<String> slotIds = [];
  for (SlotModel slot in selectedSlots) {
    slotIds.add(slot.slotId);
  }
  return slotIds;
}

List<String> getAllSlotTime(List<SlotModel> selectedSlots) {
  List<String> slotTimes = [];
  for (SlotModel slot in selectedSlots) {
    String hourOnly = slot.startTime.split('T')[1];
    slotTimes.add(hourOnly);
  }
  return slotTimes;
}
