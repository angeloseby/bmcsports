import 'package:bmcsports/models/booking_create_model.dart';
import 'package:bmcsports/services/booking_service.dart';
import 'package:flutter/material.dart';

class BookingProvider extends ChangeNotifier {
  final BookingService _bookingService = BookingService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final List<BookingModel> _bookings = [];
  List<BookingModel> get bookings => _bookings;

  // Add bookings (single or multiple)
  Future<void> addBookings(List<BookingModel> bookings) async {
    try {
      _isLoading = true;
      notifyListeners();
      await _bookingService.addBookings(bookings);
      _bookings.addAll(bookings);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to add bookings: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
