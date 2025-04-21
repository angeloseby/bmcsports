import 'package:bmcsports/models/slot_model.dart';
import 'package:bmcsports/providers/razorpay_payment_provider.dart';
import 'package:bmcsports/screens/payment_summary_screen.dart';
import 'package:bmcsports/utils/app_colors.dart';
import 'package:bmcsports/widgets/custom_date_picker.dart';
import 'package:bmcsports/widgets/slot_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../providers/slot_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime selectedDate = DateTime.now();
  String selectedTurfType = '5s';
  final List<SlotModel> selectedSlots = [];

  void toggleSlotSelection(SlotModel slot) {
    setState(() {
      if (selectedSlots.contains(slot)) {
        selectedSlots.remove(slot);
      } else {
        selectedSlots.add(slot);
      }
    });
  }

  void _handleProceedToPayment() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider(
          create: (_) => RazorpayPaymentProvider(),
          child: PaymentSummaryScreen(
            selectedDate: selectedDate,
            selectedTurfType: selectedTurfType,
            selectedSlots: selectedSlots,
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final formatted = DateFormat('yyyy-MM-dd').format(selectedDate);
      context.read<SlotProvider>().setSlotStream(formatted);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: Image.asset(
          'assets/images/logo_w_name_vertical.png',
          fit: BoxFit.fitHeight,
        ),
        backgroundColor: const Color(0xFF003453),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              CustomDatePicker(
                initialDate: selectedDate,
                onDateSelected: (date) {
                  final formatted = DateFormat('yyyy-MM-dd').format(date);
                  context.read<SlotProvider>().setSlotStream(formatted);
                  setState(() {
                    selectedDate = date;
                    selectedSlots.clear();
                  });
                },
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Select Turf Type:",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  ChoiceChip(
                    label: const Text("5s"),
                    selected: selectedTurfType == '5s',
                    onSelected: (selected) {
                      setState(() {
                        selectedTurfType = '5s';
                        selectedSlots.clear();
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text("7s"),
                    selected: selectedTurfType == '7s',
                    onSelected: (selected) {
                      setState(() {
                        selectedTurfType = '7s';
                        selectedSlots.clear();
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Consumer<SlotProvider>(
                  builder: (context, provider, _) {
                    final stream = provider.slotsStream;
                    if (stream == null) {
                      return const Center(child: Text("No slots available."));
                    }

                    return StreamBuilder<List<SlotModel>>(
                      stream: stream,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return const Center(
                              child: Text("Error loading slots."));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Center(
                              child: Text("No slots available."));
                        }

                        List<SlotModel> slots = snapshot.data!;
                        slots = slots.where((slot) {
                          if (selectedTurfType == '5s') {
                            return slot.available5sTurfCount > 0;
                          } else if (selectedTurfType == '7s') {
                            return slot.available7sTurfCount > 0;
                          }
                          return true;
                        }).toList();

                        return ListView.builder(
                          itemCount: slots.length,
                          padding: const EdgeInsets.only(
                              bottom: 80, left: 12, right: 12, top: 12),
                          itemBuilder: (context, index) {
                            final slot = slots[index];
                            final isSelected = selectedSlots.contains(slot);
                            return GestureDetector(
                              onTap: () => toggleSlotSelection(slot),
                              child: SlotCard(
                                slot: slot,
                                selectedTurfType: selectedTurfType,
                                isSelected: isSelected,
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
          if (selectedSlots.isNotEmpty)
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: AppColors.secondaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  // Handle payment logic
                  _handleProceedToPayment();
                },
                child: Text(
                  "Proceed to Payment (${selectedSlots.length} slot${selectedSlots.length > 1 ? 's' : ''})",
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
