import 'package:bmcsports/models/slot_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SlotService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<SlotModel>> getSlotsByDate(String date) {
    return _firestore
        .collection('slots')
        .where('date', isEqualTo: date)
        .orderBy('startTime')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return SlotModel.fromMap(doc.data(), doc.data());
      }).toList();
    });
  }
}
