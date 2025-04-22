import 'package:bmcsports/models/booking_create_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addBookings(List<BookingModel> bookings) async {
    try {
      WriteBatch batch = _firestore.batch();

      for (var booking in bookings) {
        final bookingRef = _firestore.collection('bookings').doc();

        for (String slotId in booking.slotIds) {
          final slotRef = _firestore.collection('slots').doc(slotId);
          final slotSnapshot = await slotRef.get();

          if (!slotSnapshot.exists) {
            throw Exception("Slot not found: $slotId");
          }

          final slotData = slotSnapshot.data()!;
          int available5s = slotData['available5sTurfCount'] ?? 0;
          int available7s = slotData['available7sTurfCount'] ?? 0;

          if (booking.bookedType == '5s') {
            if (available5s <= 0) {
              throw Exception(
                  'No 5s turf available for booking in slot $slotId');
            }
            available5s -= 1;

            if (available5s < 2) {
              available7s = 0; // Less than 2 x 5s means no room for 7s
            }
          } else if (booking.bookedType == '7s') {
            if (available7s <= 0) {
              throw Exception(
                  'No 7s turf available for booking in slot $slotId');
            }
            available7s -= 1;

            available5s = 0; // 7s booking blocks all 5s
          }

          batch.update(slotRef, {
            'available5sTurfCount': available5s,
            'available7sTurfCount': available7s,
          });
        }

        batch.set(bookingRef, booking.toMap());
      }

      await batch.commit();
    } catch (e) {
      throw Exception('Error creating bookings: $e');
    }
  }
}
