import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BookSlotDialog extends StatefulWidget {
  final Map<String, dynamic> slot;

  const BookSlotDialog({super.key, required this.slot});

  @override
  State<BookSlotDialog> createState() => _BookSlotDialogState();
}

class _BookSlotDialogState extends State<BookSlotDialog> {
  List<Map<String, dynamic>> allUsers = [];
  List<String> selectedUserIds = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('customers').get();

    allUsers = snapshot.docs
        .map(
            (doc) => {"id": doc.id, "name": doc['name'], "phone": doc['phone']})
        .toList();

    setState(() {
      isLoading = false;
    });
  }

  Future<void> bookSlot() async {
    final bookings = FirebaseFirestore.instance.collection('bookings');

    for (final userId in selectedUserIds) {
      await bookings.add({
        "customerId": userId,
        "slotId": widget.slot['id'], // Ensure slot['id'] is passed
        "turfType": widget.slot['available5s'] > 0 ? '5s' : '7s',
        "bookingTime": Timestamp.now(),
        "paymentMode": "Cash",
        "paymentStatus": "Pending",
        "isCancelled": false,
      });
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Book Slot"),
      content: isLoading
          ? const SizedBox(
              height: 100, child: Center(child: CircularProgressIndicator()))
          : SizedBox(
              width: double.maxFinite,
              height: 300,
              child: ListView(
                children: allUsers.map((user) {
                  final userId = user['id'];
                  final isSelected = selectedUserIds.contains(userId);

                  return CheckboxListTile(
                    title: Text(user['name']),
                    subtitle: Text(user['phone']),
                    value: isSelected,
                    onChanged: (selected) {
                      setState(() {
                        if (selected == true) {
                          selectedUserIds.add(userId);
                        } else {
                          selectedUserIds.remove(userId);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
            ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel")),
        ElevatedButton(
          onPressed: selectedUserIds.isEmpty ? null : bookSlot,
          child: const Text("Book"),
        ),
      ],
    );
  }
}
