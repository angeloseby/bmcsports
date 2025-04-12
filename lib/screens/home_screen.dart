import 'package:bmcsports/widgets/book_slot_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:bmcsports/providers/auth_provider.dart';
import 'package:bmcsports/providers/slot_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SlotProvider>(context, listen: false)
          .fetchSlotsByDate(selectedDate);
    });
  }

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 60)),
    );
    if (picked != null && picked != selectedDate) {
      setState(() => selectedDate = picked);
      Provider.of<SlotProvider>(context, listen: false)
          .fetchSlotsByDate(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final slotProvider = Provider.of<SlotProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sign Out',
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Sign Out"),
                  content: const Text("Are you sure you want to sign out?"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text("Sign Out"),
                    ),
                  ],
                ),
              );
              if (confirm == true) {
                await authProvider.signOut(context);
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Text(
                  "Date: ${DateFormat('dd MMM yyyy').format(selectedDate)}",
                  style: const TextStyle(fontSize: 16),
                ),
                const Spacer(),
                DropdownButton<String>(
                  value: slotProvider.selectedTurfType,
                  items: const [
                    DropdownMenuItem(value: '5s', child: Text("5s Turf")),
                    DropdownMenuItem(value: '7s', child: Text("7s Turf")),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      slotProvider.setTurfFilter(value);
                      slotProvider.fetchSlotsByDate(selectedDate);
                    }
                  },
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: () => _pickDate(context),
                  icon: const Icon(Icons.calendar_today),
                  label: const Text("Pick Date"),
                ),
              ],
            ),
          ),
          Expanded(
            child: slotProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : slotProvider.slotsByDate.isEmpty
                    ? const Center(child: Text("No open slots"))
                    : ListView.builder(
                        itemCount: slotProvider.slotsByDate.length,
                        itemBuilder: (context, index) {
                          final slot = slotProvider.slotsByDate[index];
                          final availability =
                              slotProvider.selectedTurfType == '5s'
                                  ? slot['available5s']
                                  : slot['available7s'];

                          return Card(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: ListTile(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (_) => BookSlotDialog(slot: slot),
                                );
                              },
                              leading: const Icon(Icons.access_time),
                              title: Text(
                                  "Slot: ${slot['startTime']} - ${slot['endTime']}"),
                              subtitle: Text(
                                  "₹${slot['price']} | Available ${slotProvider.selectedTurfType}: $availability"),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
