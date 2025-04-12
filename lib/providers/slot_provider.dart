import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SlotProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> slotsByDate = [];
  bool isLoading = false;

  String selectedTurfType = '5s'; // default filter

  void setTurfFilter(String turfType) {
    selectedTurfType = turfType;
    notifyListeners();
  }

  Future<void> fetchSlotsByDate(DateTime selectedDate) async {
    isLoading = true;
    notifyListeners();

    try {
      final formattedDate = "${selectedDate.year.toString().padLeft(4, '0')}-"
          "${selectedDate.month.toString().padLeft(2, '0')}-"
          "${selectedDate.day.toString().padLeft(2, '0')}";

      final query = await _firestore
          .collection('slots')
          .where('date', isEqualTo: formattedDate)
          .orderBy('startTime')
          .get();

      final allSlots = query.docs.map((doc) => doc.data()).toList();

      slotsByDate = allSlots.where((slot) {
        final available5s = slot['available5s'] ?? 0;
        final available7s = slot['available7s'] ?? 0;

        return selectedTurfType == '5s' ? available5s > 0 : available7s > 0;
      }).toList();
    } catch (e) {
      debugPrint("Error fetching slots: $e");
    }

    isLoading = false;
    notifyListeners();
  }
}
